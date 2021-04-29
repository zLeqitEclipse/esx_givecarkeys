ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterCommand('givecarkeys', 'user', function(xPlayer)

	xPlayer.triggerEvent("esx_givecarkeys:givekeys")

	end, false,	{help = "Give someone else your carkeys"
})

ESX.RegisterCommand('owncar', 'admin', function(xPlayer)

	xPlayer.triggerEvent("esx_givecarkeys:ownvehicle")

	end, false,	{help = "Set the next Vehicle to yours"
})

ESX.RegisterCommand('unowncar', 'admin', function(xPlayer)

	xPlayer.triggerEvent("esx_givecarkeys:unownvehicle")

	end, false,	{help = "Remove any owner of the car next to you"
})


ESX.RegisterServerCallback('esx_givecarkeys:checkOwnership', function(source, cb, plate)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.fetchAll(
		'SELECT * FROM owned_vehicles WHERE owner = @identifier',
		{
			['@identifier'] = xPlayer.identifier
		},
		function(result)

			local found = false

			for i=1, #result, 1 do

				local vehicleProps = json.decode(result[i].vehicle)

				if trim(vehicleProps.plate) == trim(plate) then
					found = true
					break
				end

			end

			if found then
				cb(true)
			else
				cb(false)
			end

		end
	)
end)

ESX.RegisterServerCallback('esx_givecarkeys:checkOwnerStatus', function(source, cb, plate)
	MySQL.Async.fetchAll(
		'SELECT owner FROM owned_vehicles WHERE plate = @plate',
		{
			['@plate'] = plate
		},
		function(result)

			local found = false
			local ownerName = nil

			if result[1] ~= nil then
				local xPlayer = ESX.GetPlayerFromIdentifier(result[1].owner)
				ownerName = xPlayer.getName()
				found = true
			end

			if found then
				cb(true, ownerName)
			else
				cb(false, ownerName)
			end

		end
	)
end)

RegisterServerEvent('setExistingOwner')
AddEventHandler('setExistingOwner', function(playerId, vehiclePlate, msg)
	local _source = source
	local xPlayer = nil

	if playerId ~= nil then
		xPlayer = ESX.GetPlayerFromId(playerId)
	else
		xPlayer = ESX.GetPlayerFromId(_source)
	end

	MySQL.Async.execute('UPDATE owned_vehicles SET owner=@owner WHERE plate=@plate',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = vehiclePlate
	},

	function (rowsChanged)
		if msg then
			TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('handover2', vehicleProps.plate), type = "success", timeout = 2000})
		end

	end)
end)

function trim(s)
    if s ~= nil then
		return s:match("^%s*(.-)%s*$")
	else
		return nil
    end
end

RegisterServerEvent('setOwner')
AddEventHandler('setOwner', function(playerPed, vehicleProps)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	local vehprop = json.encode(vehicleProps)
	local plate = vehicleProps.plate

	MySQL.Async.execute('INSERT INTO owned_vehicles (owner, plate, vehicle) VALUES (@owner, @plate, @vehicle)',
	{
		['@owner']   = xPlayer.identifier,
		['@plate']   = plate,
		['@vehicle'] = vehprop
	},

	function (rowsChanged)
		TriggerClientEvent("pNotify:SendNotification", _source, {text = _U('nowyourcar'), type = "success", timeout = 2000})
	end)
end)

function trim(s)
    if s ~= nil then
		return s:match("^%s*(.-)%s*$")
	else
		return nil
    end
end


RegisterServerEvent('removeExistingOwner')
AddEventHandler('removeExistingOwner', function(vehiclePlate)
	MySQL.Async.execute('DELETE FROM owned_vehicles WHERE plate=@plate',
	{
		['@plate']   = vehiclePlate
	}
	)
end)