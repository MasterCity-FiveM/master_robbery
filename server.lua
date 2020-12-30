ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local deadPeds = {}

RegisterServerEvent('master_robbery:pedDead')
AddEventHandler('master_robbery:pedDead', function(store)
    if not deadPeds[store] then
        deadPeds[store] = 'deadlol'
        TriggerClientEvent('master_robbery:onPedDeath', -1, store)
        local second = 1000
        local minute = 60 * second
        local hour = 60 * minute
        local cooldown = Config.Shops[store].cooldown
        local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
        Wait(wait)
        if not Config.Shops[store].robbed then
            for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
            TriggerClientEvent('master_robbery:resetStore', -1, store)
        end
    end
end)

RegisterServerEvent('master_robbery:handsUp')
AddEventHandler('master_robbery:handsUp', function(store)
    TriggerClientEvent('master_robbery:handsUp', -1, store)
end)

RegisterServerEvent('master_robbery:pickUp')
AddEventHandler('master_robbery:pickUp', function(store)
    local xPlayer = ESX.GetPlayerFromId(source)
    local randomAmount = math.random(Config.Shops[store].money[1], Config.Shops[store].money[2])
    xPlayer.addMoney(randomAmount)
	TriggerClientEvent("pNotify:SendNotification", source, { text = "شما مبلغ " .. randomAmount .. " بدست آوردید.", type = "info", timeout = 5000, layout = "bottomCenter"})
    TriggerClientEvent('master_robbery:removePickup', -1, store) 
end)

ESX.RegisterServerCallback('master_robbery:canRob', function(source, cb, store)
    local cops = 0
	
	TriggerEvent('esx_service:GetServiceCount',  function(cops)
		if cops >= Config.Shops[store].cops then
			if not Config.Shops[store].robbed and not deadPeds[store] then
				cb(true)
			else
				cb(false)
			end
		else
			cb('no_cops')
		end
	end,'police')
end)

RegisterServerEvent('master_robbery:rob')
AddEventHandler('master_robbery:rob', function(store)
    local src = source
    Config.Shops[store].robbed = true
    local xPlayer = ESX.GetPlayerFromId(src)
	
    TriggerClientEvent('master_robbery:rob', -1, store)
    Wait(30000)
    TriggerClientEvent('master_robbery:robberyOver', src)

    local second = 1000
    local minute = 60 * second
    local hour = 60 * minute
    local cooldown = Config.Shops[store].cooldown
    local wait = cooldown.hour * hour + cooldown.minute * minute + cooldown.second * second
    Wait(wait)
    Config.Shops[store].robbed = false
    for k, v in pairs(deadPeds) do if k == store then table.remove(deadPeds, k) end end
    TriggerClientEvent('master_robbery:resetStore', -1, store)
end)

Citizen.CreateThread(function()
    while true do
        for i = 1, #deadPeds do TriggerClientEvent('master_robbery:pedDead', -1, i) end -- update dead peds
        Citizen.Wait(500)
    end
end)
