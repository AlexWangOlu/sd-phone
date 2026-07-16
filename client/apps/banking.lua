---@type fun(nuiAction: string, serverEvent: string) NUI->server pass-through registrar (client.nui).
local proxy = require 'client.nui'

-- Thin delegates into server/banking: the account overview and phone transfers.
proxy('sd-phone:banking:overview', 'sd-phone:server:banking:overview')
proxy('sd-phone:banking:send',     'sd-phone:server:banking:send')

---Server push: another player transferred money to us; relays it to the Wallet.
---@param data table { amount, from } from server/banking/actions.lua
RegisterNetEvent('sd-phone:client:bankReceived', function(data)
    SendNUIMessage({ action = 'sd-phone:bank:received', data = data })
end)

---Server push: a transaction was recorded outside the app (an external debit/credit); nudges
---the Wallet to refetch.
RegisterNetEvent('sd-phone:client:bankTxAdded', function()
    SendNUIMessage({ action = 'sd-phone:bank:txAdded' })
end)
