ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

local G_key = 58
local X_key = 73

RegisterNetEvent('esx_givecarkeys:givekeys')
AddEventHandler('esx_givecarkeys:givekeys', function()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)			
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
    end

    local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

    if vehicleProps ~= nil then
        ESX.TriggerServerCallback('esx_givecarkeys:checkOwnership', function(isOwnedVehicle)
            if isOwnedVehicle then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                if closestPlayer == -1 or closestDistance > 3.0 then
                    exports.pNotify:SendNotification({text = "No Players Nearby!", type = "error", timeout = 2000})
                else
                    exports.pNotify:SendNotification({layout = "bottomRight", text = _U('confirmation', GetPlayerName(closestPlayer)), type = "warning", timeout = 10000})

                    while true do
                        Citizen.Wait(1)
                        if IsControlJustReleased(1, G_key) then                         
                            exports.pNotify:SendNotification({text = _U('handover', vehicleProps.plate), type = "success", timeout = 2000})
                            TriggerServerEvent('setExistingOwner', GetPlayerServerId(closestPlayer), vehicleProps, true)
                            break
                        else if IsControlJustReleased(1, X_key) then  
                            exports.pNotify:SendNotification({text = _U('handovercancel'), type = "error", timeout = 2000})
                            break
                        end
                        end
                    end
                end
            else
                exports.pNotify:SendNotification({text = _U('dontownvehicle'), type = "error", timeout = 2000})
            end
        end, GetVehicleNumberPlateText(vehicle))
    else
        exports.pNotify:SendNotification({text = _U('nonearvehicle'), type = "error", timeout = 2000})
    end

end)

RegisterNetEvent('esx_givecarkeys:ownvehicle')
AddEventHandler('esx_givecarkeys:ownvehicle', function()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)			
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
    end

    local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

    if vehicleProps ~= nil then
        ESX.TriggerServerCallback('esx_givecarkeys:checkOwnerStatus', function(vehicleOwned, ownerName)
            if vehicleOwned then
                exports.pNotify:SendNotification({layout = "bottomRight", text = _U('confirmation2', ownerName), type = "warning", timeout = 10000})
                while true do
                    Citizen.Wait(1)
                    if IsControlJustReleased(1, G_key) then                         
                        exports.pNotify:SendNotification({text = _U('nowyourcar'), type = "success", timeout = 2000})
                        TriggerServerEvent('setExistingOwner', nil, vehicleProps.plate, false)
                        break
                    else if IsControlJustReleased(1, X_key) then  
                        exports.pNotify:SendNotification({text = _U('ownershipoverridecancel'), type = "error", timeout = 2000})
                        break
                    end
                    end
                end
            else
                TriggerServerEvent('setOwner', playerPed, vehicleProps)
            end
        end, GetVehicleNumberPlateText(vehicle))
    else
        exports.pNotify:SendNotification({text = _U('nonearvehicle'), type = "error", timeout = 2000})
    end
end)

RegisterNetEvent('esx_givecarkeys:unownvehicle')
AddEventHandler('esx_givecarkeys:unownvehicle', function()
    local playerPed = GetPlayerPed(-1)
    local coords = GetEntityCoords(playerPed)

    if IsPedInAnyVehicle(playerPed,  false) then
        vehicle = GetVehiclePedIsIn(playerPed, false)			
    else
        vehicle = GetClosestVehicle(coords.x, coords.y, coords.z, 7.0, 0, 70)
    end

    local plate = GetVehicleNumberPlateText(vehicle)
	local vehicleProps = ESX.Game.GetVehicleProperties(vehicle)

    if vehicleProps ~= nil then
        ESX.TriggerServerCallback('esx_givecarkeys:checkOwnerStatus', function(vehicleOwned, ownerName)
            if vehicleOwned then
                exports.pNotify:SendNotification({layout = "bottomRight", text = _U('confirmation3', ownerName), type = "warning", timeout = 10000})
                while true do
                    Citizen.Wait(1)
                    if IsControlJustReleased(1, G_key) then                         
                        exports.pNotify:SendNotification({text = _U('carunowned'), type = "success", timeout = 2000})
                        TriggerServerEvent('removeExistingOwner', vehicleProps.plate)
                        break
                    else if IsControlJustReleased(1, X_key) then  
                        exports.pNotify:SendNotification({text = _U('unowncancel'), type = "error", timeout = 2000})
                        break
                    end
                    end
                end
            else
                exports.pNotify:SendNotification({text = _U('nobodyown'), type = "error", timeout = 2000})
            end
        end, GetVehicleNumberPlateText(vehicle))
    else
        exports.pNotify:SendNotification({text = _U('nonearvehicle'), type = "error", timeout = 2000})
    end
end)