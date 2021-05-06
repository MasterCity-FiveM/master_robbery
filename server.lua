ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local deadPeds = {}
local robers = {}


ESX.RegisterServerCallback('master_robbery:canRob', function(source, cb, store)
	local _source = source
	ESX.RunCustomFunction("anti_ddos", _source, 'master_robbery:canRob', {store = store})
    local cops = 0
	
	TriggerEvent('esx_service:GetServiceCount',  function(cops)
		if cops >= Config.Shops[store].cops then
			if ((os.time() - Config.Shops[store].lastrobbed) < Config.Shops[store].cooldown and Config.Shops[store].lastrobbed ~= 0) or deadPeds[store] then
				cb(false)
			else
				Config.Shops[store].lastrobbed = os.time()
				cb(true)
				ESX.RunCustomFunction("discord", _source, 'robstart', 'Shop Robbery', "Store: " .. store)
				robers[store] = _source
			end
		else
			cb('no_cops')
		end
	end, Config.Shops[store].organ)
end)

RegisterServerEvent('master_robbery:pedDead')
AddEventHandler('master_robbery:pedDead', function(store)
	--ESX.RunCustomFunction("anti_ddos", source, 'master_robbery:pedDead', {store = store})
    if not deadPeds[store] then
        deadPeds[store] = 'deadlol'
		Config.Shops[store].lastrobbed = os.time()
		robers[store] = nil
        TriggerClientEvent('master_robbery:onPedDeath', -1, store)
    end
end)

RegisterServerEvent('master_robbery:robLeave')
AddEventHandler('master_robbery:robLeave', function(store)
	--ESX.RunCustomFunction("anti_ddos", source, 'master_robbery:pedDead', {store = store})
    robers[store] = nil
end)

RegisterServerEvent('master_robbery:rob_finish')
AddEventHandler('master_robbery:rob_finish', function(store)
	local _source = source
	if robers[store] ~= nil and robers[store] == _source then
		ESX.RunCustomFunction("anti_ddos", source, 'master_robbery:pickUp', {store = store})
		local xPlayer = ESX.GetPlayerFromId(source)
		local randomAmount = math.random(Config.Shops[store].money[1], Config.Shops[store].money[2])
		xPlayer.addMoney(randomAmount)
		TriggerClientEvent("pNotify:SendNotification", source, { text = "شما مبلغ " .. randomAmount .. " بدست آوردید.", type = "info", timeout = 5000, layout = "bottomCenter"})
		TriggerClientEvent('master_robbery:removePickup', -1, store) 
		robers[store] = nil
	end
end)

RegisterServerEvent('master_robbery:rob')
AddEventHandler('master_robbery:rob', function(store)
	local _source = source
	if robers[store] ~= nil and robers[store] == _source then
		ESX.RunCustomFunction("anti_ddos", _source, 'master_robbery:rob', {store = store})
		local xPlayer = ESX.GetPlayerFromId(_source)
		
		TriggerClientEvent('master_robbery:rob', _source, store)
	end
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
