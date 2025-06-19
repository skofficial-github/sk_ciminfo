local infoMarkers = {}
local activeImage = nil

RegisterNetEvent("cim:createMarker")
AddEventHandler("cim:createMarker", function(data)
    local id = data.id
    local coords = vector3(data.coords.x, data.coords.y, data.coords.z)
    local text = data.text
    local image = data.image

    infoMarkers[id] = {
        coords = coords,
        text = text,
        image = image,
        shown = false
    }
end)

RegisterNetEvent("cim:removeMarker")
AddEventHandler("cim:removeMarker", function(id)
    infoMarkers[id] = nil
end)

RegisterNetEvent("cim:requestCoordsForDelete")
AddEventHandler("cim:requestCoordsForDelete", function()
    local coords = GetEntityCoords(PlayerPedId())
    TriggerServerEvent("cim:findNearestMarkerToDelete", coords)
end)

function GetGroundZ(coords)
    local x, y = coords.x, coords.y
    local groundZ = nil

    for z = coords.z + 50, coords.z - 50, -1 do
        local success, testZ = GetGroundZFor_3dCoord(x, y, z, false)
        if success then
            groundZ = testZ
            break
        end
    end

    return groundZ or coords.z
end

Citizen.CreateThread(function()
    while true do
        Wait(0)
        local ped = PlayerPedId()
        local playerCoords = GetEntityCoords(ped)

        for id, marker in pairs(infoMarkers) do
            local dist = #(playerCoords - marker.coords)
            if dist < 20.0 then
                local groundZ = GetGroundZ(marker.coords) + 0.4
                DrawMarker(
                    32,
                    marker.coords.x, marker.coords.y, groundZ,
                    0, 0, 0, 0, 0, 0,
                    0.4, 0.4, 0.4,
                    255, 255, 0, 80,
                    false, true, 2, false, nil, nil, false
                )
            end

            if dist < 0.5 and not marker.shown then
                local fullMessage = marker.text
                if marker.image then
                    fullMessage = fullMessage .. " (( Press ^4K^0 to look at the image. ))"
                    activeImage = marker.image
                else
                    activeImage = nil
                end

                TriggerEvent("chat:addMessage", {
                    color = {30, 144, 255},
                    args = {"[INFORMATOIN]", fullMessage}
                
                
                })

                marker.shown = true
            elseif dist >= 0.5 and marker.shown then
                marker.shown = false
                if activeImage == marker.image then
                    activeImage = nil
                end
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, 311) and activeImage then -- K
            SendNUIMessage({
                type = "showImage",
                url = activeImage
            })
            SetNuiFocus(true, true)
        end
    end
end)

RegisterNUICallback("close", function(_, cb)
    SetNuiFocus(false, false)
    cb({})
end)

Citizen.CreateThread(function()
    -- Suggestion for /cim
    TriggerEvent('chat:addSuggestion', '/cim', 'Adds an information marker to the place.', {
        { name = 'Message', help = 'Enter the marker message.' },
        { name = 'Image URL (optional)', help = 'Enter a direct image link (optional).' }
    })

    -- Suggestion for /delcim
    TriggerEvent('chat:addSuggestion', '/delcim', 'Removes the placed information marker.')
end)
