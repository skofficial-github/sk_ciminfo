local QBCore = exports['qb-core']:GetCoreObject()

local infoData = {}
local idCounter = 1

RegisterCommand("cim", function(source, args)
    local src = source
    if #args < 1 then
        TriggerClientEvent('chat:addMessage', src, {
            args = { "^1Usage:", "/cim [message] [image_url(optional)]" }
        })
        return
    end

    local lastArg = args[#args]
    local isImageURL = string.match(lastArg, "^https?://") ~= nil

    local imageUrl = nil
    if isImageURL then
        imageUrl = lastArg
        table.remove(args, #args)
    end

    local message = table.concat(args, " ")

    local ped = GetPlayerPed(src)
    local coords = GetEntityCoords(ped)

    local id = idCounter
    idCounter = idCounter + 1

    infoData[id] = {
        coords = { x = coords.x, y = coords.y, z = coords.z },
        text = message,
        image = imageUrl
    }

    TriggerClientEvent("cim:createMarker", -1, {
        id = id,
        coords = infoData[id].coords,
        text = message,
        image = imageUrl
    })

    TriggerClientEvent('QBCore:Notify', src, "Marker created.", "success")
end)

RegisterCommand("delcim", function(source)
    local src = source
    TriggerClientEvent("cim:requestCoordsForDelete", src)
end)

RegisterNetEvent("cim:findNearestMarkerToDelete")
AddEventHandler("cim:findNearestMarkerToDelete", function(coords)
    local src = source
    local x, y, z = coords.x, coords.y, coords.z
    local nearestId = nil
    local nearestDist = 9999

    for id, data in pairs(infoData) do
        local dist = #(vector3(data.coords.x, data.coords.y, data.coords.z) - vector3(x, y, z))
        if dist < nearestDist then
            nearestDist = dist
            nearestId = id
        end
    end

    if nearestId and nearestDist <= 1.0 then
        infoData[nearestId] = nil
        TriggerClientEvent("cim:removeMarker", -1, nearestId)

        TriggerClientEvent('QBCore:Notify', src, "Marker deleted.", "error")

        print("[DEBUG] Player ID " .. src .. " deleted marker ID " .. nearestId)
    else
        TriggerClientEvent('QBCore:Notify', src, "No markers nearby.", "warning")
    end
end)

AddEventHandler('playerJoining', function()
    local src = source
    Wait(1000)
    for id, data in pairs(infoData) do
        TriggerClientEvent("cim:createMarker", src, {
            id = id,
            coords = data.coords,
            text = data.text,
            image = data.image
        })
    end
end)
