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
        ESX.TriggerServerCallback('esx_givecarkeys:checkOwnStatus', function(isOwnedVehicle)
            if isOwnedVehicle then
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()
    
                if closestPlayer == -1 or closestDistance > 3.0 then
                    exports.pNotify:SendNotification({text = "No Players Nearby!", type = "error", timeout = 2000})
                else

                    ESX.ShowNotification(_U('confirmation', GetPlayerName(closestPlayer)))

                    while true do
                        Citizen.Wait(1)
                        if IsControlJustReleased(1, G_key) then                         
                            ESX.ShowNotification(_U('handover', vehicleProps.plate))
                            TriggerServerEvent('setExistingOwner', GetPlayerServerId(closestPlayer), vehicleProps)
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