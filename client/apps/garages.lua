---@type table Notify bridge (bridge.client.notify): local notification popups.
local notify = require 'bridge.client.notify'

---@type table<integer, string> GTA vehicle-class id -> display label for the app's class chip.
local CLASS_NAMES = {
    [0] = 'Compact',  [1] = 'Sedan',      [2] = 'SUV',        [3] = 'Coupe',
    [4] = 'Muscle',   [5] = 'Sports Classic', [6] = 'Sports', [7] = 'Super',
    [8] = 'Motorcycle', [9] = 'Off-Road', [10] = 'Industrial',[11] = 'Utility',
    [12] = 'Van',     [13] = 'Cycle',     [14] = 'Boat',      [15] = 'Helicopter',
    [16] = 'Plane',   [17] = 'Service',   [18] = 'Emergency', [19] = 'Military',
    [20] = 'Commercial', [21] = 'Train',
}

-- Vehicle-image source: toggle, default and URL template live in configs/garages.lua.
---@type table Garages app config (configs.garages): system pick, image knobs, waypoint fallbacks.
local GARAGES_CFG     = require 'configs.garages'
---@type boolean Whether players may flip photos <-> icons from the app header.
local ALLOW_TOGGLE    = GARAGES_CFG.AllowImageToggle == true
---@type boolean Default photos-on state.
local SHOW_IMAGES_DEF = GARAGES_CFG.ShowVehicleImages ~= false
---@type boolean True when images could show at all.
local IMAGES_POSSIBLE = ALLOW_TOGGLE or SHOW_IMAGES_DEF
---@type string Image URL template with a `{model}` placeholder ('' disables images).
local IMAGE_TEMPLATE  = type(GARAGES_CFG.VehicleImageUrl) == 'string' and GARAGES_CFG.VehicleImageUrl or ''

---Enriches one server vehicle row in place: resolves the raw model into a display name + class
---label, attaches the photo URL when images can show, and strips internal fields.
---@param v table vehicle row from the server list callback (mutated in place)
---@return table v the same row, for call-through convenience
local function enrich(v)
    local raw  = v.model
    local hash = nil
    if type(raw) == 'number' then
        hash = raw
    elseif type(raw) == 'string' and raw ~= '' then
        hash = GetHashKey(raw)
    end

    local display = type(raw) == 'string' and raw or nil
    local spawn = type(raw) == 'string' and raw ~= '' and raw:lower() or nil

    if hash then
        local dn = GetDisplayNameFromVehicleModel(hash)
        if dn and dn ~= '' and dn ~= 'CARNOTFOUND' then
            local label = GetLabelText(dn)
            display = (label and label ~= 'NULL' and label) or dn
            spawn = spawn or dn:lower()
        end
        local cls = GetVehicleClassFromName(hash)
        v.class = CLASS_NAMES[cls] or v.class
    end

    if IMAGES_POSSIBLE and spawn and IMAGE_TEMPLATE ~= '' then
        v.image = (IMAGE_TEMPLATE:gsub('{model}', spawn))
    end

    v.model = display or 'Vehicle'
    if not v.class or v.class == '' then
        v.class = v.garageType == 'boat' and 'Boat'
            or v.garageType == 'air' and 'Aircraft'
            or 'Vehicle'
    end
    v.garageType = nil
    v.hash = nil
    return v
end

---@type table|nil Cached valet availability + price, resolved from the server on first use.
local valetInfo

---Valet availability for the app, asked of the server once per session.
---@return table info { enabled, price, account }
local function getValetInfo()
    if valetInfo then return valetInfo end
    local ok, info = pcall(function() return lib.callback.await('sd-phone:server:garages:valetInfo', false) end)
    valetInfo = (ok and type(info) == 'table') and info or { enabled = false, price = 0 }
    return valetInfo
end

---React -> Lua: the player's vehicle list. Forwards to the server callback, enriches each row
---(pcall'd per row), and attaches the image toggle flags plus valet availability.
RegisterNUICallback('sd-phone:garages:list', function(_payload, cb)
    local result = lib.callback.await('sd-phone:server:garages:list', false)
    if not result then result = { success = false, message = 'No response from server', data = {} } end
    if result.success and type(result.data) == 'table' then
        for i = 1, #result.data do
            pcall(enrich, result.data[i])
        end
    end
    result.images = { allowToggle = ALLOW_TOGGLE, default = SHOW_IMAGES_DEF }
    result.valet  = getValetInfo()
    cb(result)
end)

---React -> Lua: drops a map waypoint at server-resolved coords; non-numeric input is rejected.
RegisterNUICallback('sd-phone:garages:waypoint', function(payload, cb)
    local x = type(payload) == 'table' and tonumber(payload.x) or nil
    local y = type(payload) == 'table' and tonumber(payload.y) or nil
    if not x or not y then return cb({ success = false }) end
    SetNewWaypoint(x + 0.0, y + 0.0)
    notify.show({ description = 'Waypoint set.', type = 'success' })
    cb({ success = true })
end)

-- Live mileage (jg-vehiclemileage), resolved on the client.
---@type string|nil Cached 'mi'/'km' from jg-vehiclemileage's getUnit.
local cachedUnit

---Returns the short unit label for mileage figures, cached after the first successful export
---read. Defaults to 'km'.
---@return string unit 'mi' or 'km'
local function unitShort()
    if cachedUnit then return cachedUnit end
    local ok, u = pcall(function() return exports['jg-vehiclemileage']:getUnit() end)
    cachedUnit = (ok and u == 'miles') and 'mi' or 'km'
    return cachedUnit
end

---Plate equality tolerant of the game's plate padding: trailing whitespace stripped and case
---ignored on both sides. nil-safe on either input.
---@param a string|nil
---@param b string|nil
---@return boolean
local function plateMatches(a, b)
    if not a or not b then return false end
    return (a:gsub('%s+$', '')):upper() == (b:gsub('%s+$', '')):upper()
end

---@type table Vehicle-key bridge (bridge.client.vehiclekeys): live lock state + fob lock/unlock
---across the supported key resources.
local vehiclekeys = require 'bridge.client.vehiclekeys'

---React -> Lua: live lock state for one of the player's vehicles; answers only for a vehicle
---streamed near the player. Read-only.
RegisterNUICallback('sd-phone:garages:lockstate', function(payload, cb)
    local plate = type(payload) == 'table' and payload.plate or nil
    if not vehiclekeys.active() or type(plate) ~= 'string' or plate == '' then return cb({ success = false }) end
    local locked = vehiclekeys.isLocked(plate)
    if locked == nil then return cb({ success = false }) end
    cb({ success = true, locked = locked })
end)

---React -> Lua: locks/unlocks a nearby spawned vehicle, chirping the hazards. Fails when the
---car isn't streamed near the player.
RegisterNUICallback('sd-phone:garages:setlock', function(payload, cb)
    local plate  = type(payload) == 'table' and payload.plate or nil
    local locked = type(payload) == 'table' and payload.locked == true
    if type(plate) ~= 'string' or plate == '' then return cb({ success = false }) end
    local applied = vehiclekeys.setLocked(plate, locked)
    if applied == nil then return cb({ success = false }) end
    cb({ success = true, locked = applied })
end)

---React -> Lua: a vehicle's odometer reading: the live export value when the player sits in
---that vehicle, else the persisted value by plate; converts km -> mi per jg's unit and floors.
RegisterNUICallback('sd-phone:garages:mileage', function(payload, cb)
    if GetResourceState('jg-vehiclemileage') ~= 'started' then return cb({ success = false }) end
    local plate = type(payload) == 'table' and payload.plate or nil
    if type(plate) ~= 'string' or plate == '' then return cb({ success = false }) end

    local km
    local veh = GetVehiclePedIsIn(PlayerPedId(), false)
    if veh ~= 0 and plateMatches(GetVehicleNumberPlateText(veh), plate) then
        local ok, v = pcall(function() return exports['jg-vehiclemileage']:getMileage() end)
        if ok and type(v) == 'number' then km = v end
    end
    if km == nil then
        local ok, v = pcall(function() return exports['jg-vehiclemileage']:getMileageByPlate(plate) end)
        if ok and type(v) == 'number' then km = v end
    end
    if type(km) ~= 'number' then return cb({ success = false }) end

    local unit = unitShort()
    local val  = unit == 'mi' and km * 0.621371 or km
    cb({ success = true, mileage = math.floor(val), unit = unit })
end)

-- Valet delivery. The server owns every decision that matters (ownership, funds, cooldown, where
-- the car may be delivered); this side only finds a road spot, then plays out the arrival.
---@type table Valet settings from configs.garages.
local VALET        = type(GARAGES_CFG.Valet) == 'table' and GARAGES_CFG.Valet or {}
---@type number Seconds after taking damage that valet stays blocked (0 disables).
local COMBAT_BLOCK = math.max(0, tonumber(VALET.CombatBlock) or 0)
---@type number Metres out a driven delivery starts from.
local DRIVE_FROM   = math.max(5, tonumber(VALET.DriveFrom) or 75)
---@type string Valet driver model.
local VALET_PED    = type(VALET.Ped) == 'string' and VALET.Ped or 'S_M_Y_XMech_01'

---@type table<string, string> Server refusal code -> message shown to the player.
local VALET_ERRORS = {
    disabled      = 'Valet is unavailable.',
    notFound      = 'Vehicle not found.',
    impounded     = 'Impounded vehicles must be collected from the impound.',
    notStored     = 'That vehicle is not in a garage.',
    notRoad       = 'This vehicle cannot be delivered by road.',
    cooldown      = 'You have already called a valet recently.',
    inVehicle     = 'You cannot call a valet while driving.',
    combat        = 'Too dangerous to call a valet right now.',
    blockedArea   = 'A valet cannot deliver here.',
    funds         = 'You cannot afford the valet fee.',
    noSpace       = 'No safe place nearby to drop the vehicle off.',
    takeOutFailed = 'The garage would not release the vehicle.',
}

---@type integer GetGameTimer of the player's last health drop (0 = never).
local lastHurt = 0

if VALET.Enabled == true and COMBAT_BLOCK > 0 then
    CreateThread(function()
        local last = GetEntityHealth(PlayerPedId())
        while true do
            Wait(1000)
            local hp = GetEntityHealth(PlayerPedId())
            if hp < last then lastHurt = GetGameTimer() end
            last = hp
        end
    end)
end

---@return boolean hurt whether the player took damage inside the configured window
local function recentDamage()
    if COMBAT_BLOCK <= 0 or lastHurt == 0 then return false end
    return (GetGameTimer() - lastHurt) < (COMBAT_BLOCK * 1000)
end

---Nearest road node at least minDist away, walking outwards through the closest nodes.
---@param minDist number metres
---@return vector3|nil coords
---@return number|nil heading
local function findSpawn(minDist)
    local at = GetEntityCoords(PlayerPedId())
    for nth = 1, 30 do
        local ok, pos, head = GetNthClosestVehicleNodeWithHeading(at.x, at.y, at.z, nth, 0, 0, 0)
        if ok and pos and #(at - pos) >= minDist then return pos, head or 0.0 end
    end
    return nil
end

---Wait for a server-spawned vehicle to stream in locally.
---@param netId number
---@return number|nil veh entity handle
local function awaitEntity(netId)
    for _ = 1, 100 do
        if NetworkDoesNetworkIdExist(netId) then
            local veh = NetToVeh(netId)
            if veh and veh ~= 0 and DoesEntityExist(veh) then return veh end
        end
        Wait(50)
    end
    return nil
end

---Drive the delivered car to the player with a valet at the wheel, blipped on the way. The ped
---gets out and wanders off on arrival. Runs in its own thread; gives up after 90s.
---@param veh number vehicle entity
local function driveToPlayer(veh)
    CreateThread(function()
        local model = joaat(VALET_PED)
        RequestModel(model)
        for _ = 1, 40 do
            if HasModelLoaded(model) then break end
            Wait(50)
        end
        if not HasModelLoaded(model) or not DoesEntityExist(veh) then return end

        local ped = CreatePedInsideVehicle(veh, 4, model, -1, true, false)
        SetModelAsNoLongerNeeded(model)
        if not DoesEntityExist(ped) then return end

        SetEntityAsMissionEntity(ped, true, true)
        SetBlockingOfNonTemporaryEvents(ped, true)
        SetPedKeepTask(ped, true)
        SetPedAlertness(ped, 0)

        local at = GetEntityCoords(PlayerPedId())
        TaskVehicleDriveToCoord(ped, veh, at.x, at.y, at.z, 25.0, 0, GetEntityModel(veh), 786603, 3.0, 1)

        local blip = AddBlipForEntity(veh)
        SetBlipSprite(blip, 225)
        SetBlipColour(blip, 5)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentSubstringPlayerName('Valet')
        EndTextCommandSetBlipName(blip)

        local until_ = GetGameTimer() + 90000
        while DoesEntityExist(ped) and DoesEntityExist(veh) and GetGameTimer() < until_ do
            if #(GetEntityCoords(ped) - GetEntityCoords(PlayerPedId())) <= 12.0 then break end
            Wait(1000)
        end

        if DoesBlipExist(blip) then RemoveBlip(blip) end
        if DoesEntityExist(ped) then
            TaskLeaveVehicle(ped, veh, 0)
            Wait(3000)
            TaskWanderStandard(ped, 10.0, 10)
            SetPedAsNoLongerNeeded(ped)
        end
    end)
end

---React -> Lua: request a valet delivery for one of the player's stored vehicles. Picks the drop
---spot, hands the request to the server, then applies the saved properties, grants keys and either
---drives the car in or leaves it waiting.
RegisterNUICallback('sd-phone:garages:valet', function(payload, cb)
    local plate = type(payload) == 'table' and payload.plate or nil
    if type(plate) ~= 'string' or plate == '' then
        return cb({ success = false, message = VALET_ERRORS.notFound })
    end

    local info = getValetInfo()
    if not info.enabled then return cb({ success = false, message = VALET_ERRORS.disabled }) end

    local drive = VALET.Drive ~= false
    local pos, heading = findSpawn(drive and DRIVE_FROM or 3.0)
    if not pos then return cb({ success = false, message = VALET_ERRORS.noSpace }) end

    local res = lib.callback.await('sd-phone:server:garages:valet', false, {
        plate        = plate,
        class        = type(payload) == 'table' and payload.class or nil,
        spawn        = { x = pos.x, y = pos.y, z = pos.z, h = heading },
        recentDamage = recentDamage(),
    })

    if type(res) ~= 'table' or not res.success then
        local reason  = type(res) == 'table' and res.reason or nil
        local message = VALET_ERRORS[reason or ''] or VALET_ERRORS.disabled
        if reason == 'blockedArea' and type(res.detail) == 'string' then
            message = ('A valet cannot deliver to %s.'):format(res.detail)
        end
        notify.show({ description = message, type = 'error' })
        return cb({ success = false, message = message })
    end

    local veh = awaitEntity(res.netId)
    if not veh then
        notify.show({ description = VALET_ERRORS.noSpace, type = 'error' })
        return cb({ success = false, message = VALET_ERRORS.noSpace })
    end

    if type(res.props) == 'table' then pcall(lib.setVehicleProperties, veh, res.props) end
    SetVehicleNumberPlateText(veh, res.plate)
    SetVehicleNeedsToBeHotwired(veh, false)
    SetVehicleEngineOn(veh, true, true, false)
    SetVehicleDirtLevel(veh, 0.0)
    vehiclekeys.giveKeys(res.plate, veh)

    if res.drive then
        driveToPlayer(veh)
        notify.show({ description = 'Your valet is on the way.', type = 'success' })
    else
        SetVehicleDoorsLocked(veh, 1)
        notify.show({ description = 'Your vehicle is waiting nearby.', type = 'success' })
    end

    cb({ success = true, drive = res.drive == true })
end)
