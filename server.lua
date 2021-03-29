ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local deadPeds = {}

RegisterServerEvent('master_robbery:pedDead')
AddEventHandler('master_robbery:pedDead', function(store)
	ESX.RunCustomFunction("anti_ddos", source, 'master_robbery:pedDead', {store = store})
    if not deadPeds[store] then
        deadPeds[store] = 'deadlol'
		Config.Shops[store].lastrobbed = os.time()
        TriggerClientEvent('master_robbery:onPedDeath', -1, store)
    end
end)

RegisterServerEvent('master_robbery:handsUp')
AddEventHandler('master_robbery:handsUp', function(store)
	ESX.RunCustomFunction("anti_ddos", source, 'master_robbery:handsUp', {store = store})
    TriggerClientEvent('master_robbery:handsUp', -1, store)
end)

RegisterServerEvent('master_robbery:pickUp')
AddEventHandler('master_robbery:pickUp', function(store)
	ESX.RunCustomFunction("anti_ddos", source, 'master_robbery:pickUp', {store = store})
    local xPlayer = ESX.GetPlayerFromId(source)
    local randomAmount = math.random(Config.Shops[store].money[1], Config.Shops[store].money[2])
    xPlayer.addMoney(randomAmount)
	TriggerClientEvent("pNotify:SendNotification", source, { text = "شما مبلغ " .. randomAmount .. " بدست آوردید.", type = "info", timeout = 5000, layout = "bottomCenter"})
    TriggerClientEvent('master_robbery:removePickup', -1, store) 
end)

ESX.RegisterServerCallback('master_robbery:canRob', function(source, cb, store)
	ESX.RunCustomFunction("anti_ddos", source, 'master_robbery:canRob', {store = store})
    local cops = 0
	
	TriggerEvent('esx_service:GetServiceCount',  function(cops)
		if cops >= Config.Shops[store].cops then
			if ((os.time() - Config.Shops[store].lastrobbed) < Config.Shops[store].cooldown and Config.Shops[store].lastrobbed ~= 0) or deadPeds[store] then
				cb(false)
			else
				Config.Shops[store].lastrobbed = os.time()
				cb(true)
			end
		else
			cb('no_cops')
		end
	end, Config.Shops[store].organ)
end)

RegisterServerEvent('master_robbery:rob')
AddEventHandler('master_robbery:rob', function(store)
	ESX.RunCustomFunction("anti_ddos", source, 'master_robbery:rob', {store = store})
	ESX.RunCustomFunction("discord", source, 'robstart', 'Shop Robbery', "Store: " .. store)
    local src = source
    local xPlayer = ESX.GetPlayerFromId(src)
	
    TriggerClientEvent('master_robbery:rob', -1, store)
    Wait(30000)
    TriggerClientEvent('master_robbery:robberyOver', src)
end)

Citizen.CreateThread(function()
    while true do
		for k, v in pairs(deadPeds) do 
			if deadPeds[k] ~= nil then
				if (os.time() - Config.Shops[k].lastrobbed) < Config.Shops[k].cooldown and Config.Shops[k].lastrobbed ~= 0 then
					TriggerClientEvent('master_robbery:pedDead', -1, i)
				else
					TriggerClientEvent('master_robbery:resetStore', -1, k)
					deadPeds[k] = nil
				end
			end 
		end
        Citizen.Wait(1000)
    end
end)
