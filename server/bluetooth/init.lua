---@type table Bluetooth persistence (server.bluetooth.store): schema, radio switch, paired list.
local store = require 'server.bluetooth.store'
---@type table Device registry (server.bluetooth.registry): registrations + live connections.
local registry = require 'server.bluetooth.registry'
---@type table Bluetooth callbacks (server.bluetooth.actions): scan, pair, forget, disconnect.
local actions = require 'server.bluetooth.actions'

---@type integer Milliseconds between reconnect sweeps. Slow on purpose: this is the only cost the
---feature carries when nobody is looking at the Bluetooth page.
local TICK_MS = 4000

---@type table<number, table|false> Per-player state the tick needs, loaded once per session. `false`
---records a player with nothing paired, so they are never queried again.
local watch = {}

CreateThread(function()
    local ok, err = pcall(store.ensureSchema)
    if not ok then
        print(('^1[sd-phone:bluetooth]^0 schema failed, the feature is off: %s'):format(tostring(err)))
    end
end)

---A player's cached state, read from the database the first time and kept until they leave or change
---something. Returns nil when they have nothing paired and so need no sweeping.
---@param src number player server id
---@return table|nil state { enabled: boolean, paired: table<string, string> }
local function stateOf(src)
    local cached = watch[src]
    if cached ~= nil then return cached or nil end

    local player = require 'bridge.server.player'
    local cid = player.getIdentifier(src)
    if not cid then return nil end

    local state = store.get(cid)
    if not next(state.paired) then
        watch[src] = false
        return nil
    end
    watch[src] = state
    return state
end

---Drops a player's cache so the next sweep reloads it, after anything that changes their pairings.
---@param src number player server id
local function invalidate(src)
    watch[src] = nil
end

lib.callback.register('sd-phone:server:bluetooth:scan', function(source)
    invalidate(source)
    return actions.scan(source)
end)

lib.callback.register('sd-phone:server:bluetooth:pair', function(source, payload)
    local res = actions.pair(source, payload)
    invalidate(source)
    return res
end)

lib.callback.register('sd-phone:server:bluetooth:forget', function(source, payload)
    local res = actions.forget(source, payload)
    invalidate(source)
    return res
end)

lib.callback.register('sd-phone:server:bluetooth:disconnect', function(source, payload)
    return actions.disconnect(source, payload)
end)

lib.callback.register('sd-phone:server:bluetooth:setEnabled', function(source, payload)
    local res = actions.setEnabled(source, payload)
    invalidate(source)
    return res
end)

---Connects paired devices that have come into reach and drops the ones that have left it. Only
---players with something paired are considered, so an empty server does no work at all.
CreateThread(function()
    while true do
        Wait(TICK_MS)

        for _, sid in ipairs(GetPlayers()) do
            local src = tonumber(sid)
            local state = src and stateOf(src) or nil

            if src and state and state.enabled then
                local ped = GetPlayerPed(src)
                local pos = (ped and ped ~= 0) and GetEntityCoords(ped) or nil

                if pos then
                    for id in pairs(state.paired) do
                        local device = registry.get(id)
                        local near = device and registry.reachable(device, pos.x, pos.y, pos.z)
                        local live = registry.isConnected(src, id)

                        if near and not live then
                            registry.connect(src, id)
                        elseif live and not near then
                            registry.disconnect(src, id, 'range')
                        end
                    end
                end
            end
        end
    end
end)

AddEventHandler('playerDropped', function()
    local src = source
    registry.disconnectAll(src, 'dropped')
    watch[src] = nil
end)

---Another resource stopping takes its devices with it, so nothing points at a script that is gone.
AddEventHandler('onResourceStop', function(name)
    if name == GetCurrentResourceName() then return end
    registry.removeByOwner(name)
end)

exports('registerBluetoothDevice', function(def)
    return registry.add(def, GetInvokingResource() or GetCurrentResourceName())
end)

exports('unregisterBluetoothDevice', function(id)
    return registry.remove(id)
end)

exports('isBluetoothConnected', function(source, deviceId)
    return registry.isConnected(source, deviceId)
end)

exports('getBluetoothConnections', function(deviceId)
    return registry.connections(deviceId)
end)

exports('getConnectedDevices', function(source)
    return registry.connectedTo(source)
end)

exports('disconnectBluetooth', function(source, deviceId)
    return registry.disconnect(source, deviceId, 'kicked')
end)
