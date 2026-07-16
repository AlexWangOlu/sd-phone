---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxy = require 'client.nui'

-- Thin delegates into server/pages: listing CRUD.
proxy('sd-phone:pages:list',   'sd-phone:server:pages:list')
proxy('sd-phone:pages:create', 'sd-phone:server:pages:create')
proxy('sd-phone:pages:update', 'sd-phone:server:pages:update')
proxy('sd-phone:pages:delete', 'sd-phone:server:pages:delete')

---Server push (fan-out to every other open phone): another player posted / edited / removed a
---listing. Forwarded straight to the NUI.
---@param payload table feed patch from server/pages
RegisterNetEvent('sd-phone:client:pages:feed', function(payload)
    SendNUIMessage({ action = 'sd-phone:pages:feed', data = payload })
end)
