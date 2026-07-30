---Nearby and paired devices for the Bluetooth settings page. Thin forward into server/bluetooth,
---which reads player distances server-side.
RegisterNUICallback('sd-phone:bluetooth:scan', function(_, cb)
    cb(lib.callback.await('sd-phone:server:bluetooth:scan', false) or { success = false, data = { enabled = false, devices = {} } })
end)

---Pair with a device and connect to it, which is what tapping it in the list means.
RegisterNUICallback('sd-phone:bluetooth:pair', function(payload, cb)
    cb(lib.callback.await('sd-phone:server:bluetooth:pair', false, payload) or { success = false })
end)

---Forget a device: disconnect and stop auto-reconnecting to it.
RegisterNUICallback('sd-phone:bluetooth:forget', function(payload, cb)
    cb(lib.callback.await('sd-phone:server:bluetooth:forget', false, payload) or { success = false })
end)

---Disconnect without forgetting, so it stays in the list for later.
RegisterNUICallback('sd-phone:bluetooth:disconnect', function(payload, cb)
    cb(lib.callback.await('sd-phone:server:bluetooth:disconnect', false, payload) or { success = false })
end)

---The radio switch, persisted per character.
RegisterNUICallback('sd-phone:bluetooth:setEnabled', function(payload, cb)
    cb(lib.callback.await('sd-phone:server:bluetooth:setEnabled', false, payload) or { success = false })
end)
