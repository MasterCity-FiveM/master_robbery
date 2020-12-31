ESX                           = nil
local ESXLoaded = false
local robbing = false

Citizen.CreateThread(function ()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
	end

    ESXLoaded = true
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    ESX.PlayerData.job = job
end)

local peds = {}
local objects = {}

RegisterNetEvent('master_robbery:onPedDeath')
AddEventHandler('master_robbery:onPedDeath', function(store)
    SetEntityHealth(peds[store], 0)
end)

RegisterNetEvent('master_robbery:msgPolice')
AddEventHandler('master_robbery:msgPolice', function(phone)
	local playerPed = PlayerPedId()
	PedPosition		= GetEntityCoords(playerPed)
	local PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z }

	exports.pNotify:SendNotification({text = "یک نفر دزدی شما رو به پلیس گزارش داده!", type = "error", timeout = 4000})

    TriggerServerEvent('esx_addons_gcphone:startCall', phone, 'یک دزدی گزارش شده!', PlayerCoords, {
		PlayerCoords = { x = PedPosition.x, y = PedPosition.y, z = PedPosition.z },
	})
end)

RegisterNetEvent('master_robbery:removePickup')
AddEventHandler('master_robbery:removePickup', function(bank)
    for i = 1, #objects do 
        if objects[i].bank == bank and DoesEntityExist(objects[i].object) then 
            DeleteObject(objects[i].object) 
        end 
    end
end)

RegisterNetEvent('master_robbery:robberyOver')
AddEventHandler('master_robbery:robberyOver', function()
    robbing = false
end)

RegisterCommand('animation', function(source, args)
    if args[1] and args[2] then
        loadDict(args[1])
        TaskPlayAnim(PlayerPedId(), args[1], args[2], 8.0, -8.0, -1, 2, 0, false, false, false)
    end
end)

RegisterNetEvent('master_robbery:rob')
AddEventHandler('master_robbery:rob', function(i)
    if not IsPedDeadOrDying(peds[i]) then
        SetEntityCoords(peds[i], Config.Shops[i].coords)
        loadDict('mp_am_hold_up')
        TaskPlayAnim(peds[i], "mp_am_hold_up", "holdup_victim_20s", 8.0, -8.0, -1, 2, 0, false, false, false)
        while not IsEntityPlayingAnim(peds[i], "mp_am_hold_up", "holdup_victim_20s", 3) do Wait(0) end
        local timer = GetGameTimer() + 10800
        while timer >= GetGameTimer() do
            if IsPedDeadOrDying(peds[i]) then
                break
            end
            Wait(0)
        end

        if not IsPedDeadOrDying(peds[i]) then
            local cashRegister = GetClosestObjectOfType(GetEntityCoords(peds[i]), 5.0, GetHashKey('prop_till_01'))
            if DoesEntityExist(cashRegister) then
                CreateModelSwap(GetEntityCoords(cashRegister), 0.5, GetHashKey('prop_till_01'), GetHashKey('prop_till_01_dam'), false)
            end

            timer = GetGameTimer() + 200 
            while timer >= GetGameTimer() do
                if IsPedDeadOrDying(peds[i]) then
                    break
                end
                Wait(0)
            end

            local model = GetHashKey('prop_poly_bag_01')
            RequestModel(model)
            while not HasModelLoaded(model) do Wait(0) end
            local bag = CreateObject(model, GetEntityCoords(peds[i]), false, false)
                        
            AttachEntityToEntity(bag, peds[i], GetPedBoneIndex(peds[i], 60309), 0.1, -0.11, 0.08, 0.0, -75.0, -75.0, 1, 1, 0, 0, 2, 1)
            timer = GetGameTimer() + 10000
            while timer >= GetGameTimer() do
                if IsPedDeadOrDying(peds[i]) then
                    break
                end
                Wait(0)
            end
            if not IsPedDeadOrDying(peds[i]) then
                DetachEntity(bag, true, false)
                timer = GetGameTimer() + 75
                while timer >= GetGameTimer() do
                    if IsPedDeadOrDying(peds[i]) then
                        break
                    end
                    Wait(0)
                end
                SetEntityHeading(bag, Config.Shops[i].heading)
                ApplyForceToEntity(bag, 3, vector3(0.0, 50.0, 0.0), 0.0, 0.0, 0.0, 0, true, true, false, false, true)
                table.insert(objects, {bank = i, object = bag})
                Citizen.CreateThread(function()
                    while true do
                        Wait(5)
                        if DoesEntityExist(bag) then
                            if GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(bag), true) <= 1.5 then
                                PlaySoundFrontend(-1, 'ROBBERY_MONEY_TOTAL', 'HUD_FRONTEND_CUSTOM_SOUNDSET', true)
                                TriggerServerEvent('master_robbery:pickUp', i)
                                break
                            end
                        else
                            break
                        end
                    end
                end)
            else
                DeleteObject(bag)
            end
        end
        loadDict('mp_am_hold_up')
        TaskPlayAnim(peds[i], "mp_am_hold_up", "cower_intro", 8.0, -8.0, -1, 0, 0, false, false, false)
        timer = GetGameTimer() + 2500
        while timer >= GetGameTimer() do Wait(0) end
        TaskPlayAnim(peds[i], "mp_am_hold_up", "cower_loop", 8.0, -8.0, -1, 1, 0, false, false, false)
        local stop = GetGameTimer() + 120000
        while stop >= GetGameTimer() do
            Wait(50)
        end
        if IsEntityPlayingAnim(peds[i], "mp_am_hold_up", "cower_loop", 3) then
            ClearPedTasks(peds[i])
        end
    end
end)

RegisterNetEvent('master_robbery:resetStore')
AddEventHandler('master_robbery:resetStore', function(i)
    while not ESXLoaded do Wait(0) end
    if DoesEntityExist(peds[i]) then
        DeletePed(peds[i])
    end
    Wait(250)
    peds[i] = _CreatePed(Config.Shopkeeper, Config.Shops[i].coords, Config.Shops[i].heading)
    local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(peds[i]), 5.0, GetHashKey('prop_till_01_dam'))
    if DoesEntityExist(brokenCashRegister) then
        CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'), GetHashKey('prop_till_01'), false)
    end
end)

function _CreatePed(hash, coords, heading)
    RequestModel(hash)
    while not HasModelLoaded(hash) do
        Wait(5)
    end

    local ped = CreatePed(4, hash, coords, false, false)
    SetEntityHeading(ped, heading)
    SetEntityAsMissionEntity(ped, true, true)
    SetPedHearingRange(ped, 0.0)
    SetPedSeeingRange(ped, 0.0)
    SetPedAlertness(ped, 0.0)
    SetPedFleeAttributes(ped, 0, 0)
    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedCombatAttributes(ped, 46, true)
    SetPedFleeAttributes(ped, 0, 0)
    return ped
end

Citizen.CreateThread(function()
    while not ESXLoaded do Wait(0) end
    for i = 1, #Config.Shops do 
        peds[i] = _CreatePed(Config.Shopkeeper, Config.Shops[i].coords, Config.Shops[i].heading)
		
        local brokenCashRegister = GetClosestObjectOfType(GetEntityCoords(peds[i]), 5.0, GetHashKey('prop_till_01_dam'))
        if DoesEntityExist(brokenCashRegister) then
            CreateModelSwap(GetEntityCoords(brokenCashRegister), 0.5, GetHashKey('prop_till_01_dam'), GetHashKey('prop_till_01'), false)
        end
    end

    Citizen.CreateThread(function()
        while true do
            for i = 1, #peds do
                if IsPedDeadOrDying(peds[i]) then
                    TriggerServerEvent('master_robbery:pedDead', i)
                end
            end
            Wait(5000)
        end
    end)

    while true do
        Wait(5)
        local me = PlayerPedId()
        if IsPedArmed(me, 7) then
            if IsPlayerFreeAiming(PlayerId()) then
                for i = 1, #peds do
                    if HasEntityClearLosToEntityInFront(me, peds[i], 19) and not IsPedDeadOrDying(peds[i]) and GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <= 5.0 then
                        if not robbing then
                            local canRob = nil
                            ESX.TriggerServerCallback('master_robbery:canRob', function(cb)
                                canRob = cb
                            end, i)
                            while canRob == nil do
                                Wait(0)
                            end
                            if canRob == true then
                                robbing = true
                                Citizen.CreateThread(function()
                                    while robbing do Wait(0) if IsPedDeadOrDying(peds[i]) then robbing = false end end
                                end)
                                loadDict('missheist_agency2ahands_up')
                                TaskPlayAnim(peds[i], "missheist_agency2ahands_up", "handsup_anxious", 8.0, -8.0, -1, 1, 0, false, false, false)
								
								TriggerEvent('master_robbery:msgPolice', Config.Shops[i].organ)
                                local scared = 0
								
                                while scared < 100 and not IsPedDeadOrDying(peds[i]) and GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <= 7.5 do
                                    local sleep = Config.Shops[i].rob_time
                                    SetEntityAnimSpeed(peds[i], "missheist_agency2ahands_up", "handsup_anxious", 1.0)
                                    if IsPlayerFreeAiming(PlayerId()) then
                                        sleep = 250
                                        SetEntityAnimSpeed(peds[i], "missheist_agency2ahands_up", "handsup_anxious", 1.3)
                                    end
                                    if IsPedArmed(me, 4) and GetAmmoInClip(me, GetSelectedPedWeapon(me)) > 0 and IsControlPressed(0, 24) then
                                        sleep = 50
                                        SetEntityAnimSpeed(peds[i], "missheist_agency2ahands_up", "handsup_anxious", 1.7)
                                    end
                                    sleep = GetGameTimer() + sleep
									
                                    while sleep >= GetGameTimer() and not IsPedDeadOrDying(peds[i]) do
                                        Wait(0)
                                        DrawRect(0.5, 0.5, 0.2, 0.03, 75, 75, 75, 200)
                                        local draw = scared/500
                                        DrawRect(0.5, 0.5, draw, 0.03, 0, 221, 255, 200)
                                    end
                                    scared = scared + 1
                                end
                                if GetDistanceBetweenCoords(GetEntityCoords(me), GetEntityCoords(peds[i]), true) <= 7.5 then
                                    if not IsPedDeadOrDying(peds[i]) then
                                        TriggerServerEvent('master_robbery:rob', i)
                                        while robbing do Wait(0) if IsPedDeadOrDying(peds[i]) then robbing = false end end
                                    end
                                else
                                    ClearPedTasks(peds[i])
                                    robbing = false
									exports.pNotify:SendNotification({text = "فروشنده: آخیش رفت، اینا هم مارو مسخره کردن!", type = "info", timeout = 4000})
                                end
                            elseif canRob == 'no_cops' then
								if Config.Shops[i].organ == 'sheriff' then
									exports.pNotify:SendNotification({text = "تعداد شریف ها کم می باشد!", type = "error", timeout = 4000})
								else
									exports.pNotify:SendNotification({text = "تعداد پلیس ها کم می باشد!", type = "error", timeout = 4000})
								end
		
                                local wait = GetGameTimer()+4000
                                while wait >= GetGameTimer() do
                                    Wait(0)
                                end
                            else
								exports.pNotify:SendNotification({text = "فروشنده: برو بابا، دیر اومدی نخواه زود برو! قبل تو زرنگ ترهاش مغازه رو زدن، پول نیست!", type = "info", timeout = 4000})
                                Wait(4000)
                            end
                        end
                    end
                end
            end
        end
    end
end)

loadDict = function(dict)
    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Wait(10)
    end
end

