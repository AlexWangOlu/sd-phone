---@type table Garages bridge (bridge.server.garages): cross-resource garage-system detection +
---DB normalisation into the app's vehicle shape.
local garages = require 'bridge.server.garages'

---Owned-vehicle list for the caller. Read-only; a disabled/undetected system degrades to an
---empty array.
lib.callback.register('sd-phone:server:garages:list', function(src)
    return { success = true, data = garages.list(src) }
end)

-- No boot print: the detected garage system is available via garages.activeSystem() when needed.
