--[[
    NUI
--]]

RegisterNUICallback('getRaces', function (data, cb)
    cb(
        ESX.TriggerServerCallback('gcphone:getRaces', function(data)
            cb(data)
        end)
    )
end)

--[[
    Core
--]]

local currentMap = {}
local customMaps = {}
local dst = 30.0
local creatingMap = false
local SetBlips = {}
local particleList = {}
local currentRaces = {}
local JoinedRaces = {}
local racing = false
local racesStarted = 0
local mylastid = "NA"

function getCardinalDirectionFromHeading()
    local heading = GetEntityHeading(PlayerPedId())
    if heading >= 315 or heading < 45 then
        return "North Bound"
    elseif heading >= 45 and heading < 135 then
        return "West Bound"
    elseif heading >= 135 and heading < 225 then
        return "South Bound"
    elseif heading >= 225 and heading < 315 then
        return "East Bound"
    end    
end


function StartEvent(map,laps,counter,raceName, startTime, mapCreator, mapDistance, mapDescription)
    local map = tostring(map)
    local laps = tonumber(laps)
    local counter = tonumber(counter)
    local mapCreator = tostring(mapCreator)
    local mapDistance = tonumber(mapDistance)
    local mapDescription = tostring(mapDescription)

    if map == 0 then
        ShowText("Pick a map or use the old racing system.")
        return
    end

    local ped = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ped)
    local dist =
        Vdist(
        customMaps[map]["checkpoints"][1]["coords"]["x"],
        customMaps[map]["checkpoints"][1]["coords"]["y"],
        customMaps[map]["checkpoints"][1]["coords"]["z"],
        plyCoords.x,
        plyCoords.y,
        plyCoords.z
    )
    if dist > 40.0 then
        ShowText("You are too far away!")
        return
    end

    ShowText(
        "Race Starting on " .. customMaps[map]["track_name"] .. " with " .. laps .. " laps in " .. counter .. " seconds!"
    )
    racesStarted = racesStarted + 1
    local cid = exports["isPed"]:isPed("cid")
    local uniqueid = cid .. "-" .. racesStarted
    local s1, s2 =
        GetStreetNameAtCoord(
        customMaps[map]["checkpoints"][1]["coords"].x,
        customMaps[map]["checkpoints"][1]["coords"].y,
        customMaps[map]["checkpoints"][1]["coords"].z
    )
    local street1 = GetStreetNameFromHashKey(s1)
    zone =
        tostring(
        GetNameOfZone(
            customMaps[map]["checkpoints"][1]["coords"].x,
            customMaps[map]["checkpoints"][1]["coords"].y,
            customMaps[map]["checkpoints"][1]["coords"].z
        )
    )
    --local playerStreetsLocation = zoneNames[tostring(zone)]
    local dir = getCardinalDirectionFromHeading()
    local street1 = street1 .. ", " .. zone
    local street2 = GetStreetNameFromHashKey(s2) .. " " .. dir
    TriggerServerEvent(
        "racing-global-race",
        map,
        laps,
        counter,
        uniqueid,
        cid,
        raceName,
        startTime,
        mapCreator,
        mapDistance,
        mapDescription,
        street1,
        street2
    )

end

function hudUpdate(pHudState, pHudData)
    pHudState = pHudState or "finished"
    pHudData = pHudData or "{}"
    SendNUIMessage(
        {
            openSection = "racing:hud:update",
            hudState = pHudState,
            hudData = pHudData
        }
    )
    
end

function ClearBlips()
    for i = 1, #SetBlips do
        RemoveBlip(SetBlips[i])
    end
    SetBlips = {}
    
end

function RunRace(identifier)
    local map = currentRaces[identifier].map
    local laps = currentRaces[identifier].laps
    local counter = currentRaces[identifier].counter
    local sprint = false

    if laps == 0 then
        laps = 1
        sprint = true
    end
    local myLap = 0

    local checkpoints = #customMaps[map]["checkpoints"]
    local mycheckpoint = 1
    local ped = GetPlayerPed(-1)

    SetBlipColour(SetBlips[1], 3)
    SetBlipScale(SetBlips[1], 1.6)

    TriggerEvent("DoLongHudText", "La carrera comienza en 3", 14)
    PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    Citizen.Wait(1000)
    TriggerEvent("DoLongHudText", "La carrera comienza en 2", 14)
    PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    Citizen.Wait(1000)
    TriggerEvent("DoLongHudText", "La carrera comienza en 1", 14)
    PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    Citizen.Wait(1000)
    PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    TriggerEvent("DoLongHudText", "GO!", 14)
    hudUpdate(
        "start",
        {
            isSprint = sprint,
            maxLaps = laps,
            maxCheckpoints = checkpoints
        }
    )

    while myLap < laps + 1 and racing do
        Wait(1)
        local plyCoords = GetEntityCoords(ped)

        if
            (Vdist(
                customMaps[map]["checkpoints"][mycheckpoint]["coords"]["x"],
                customMaps[map]["checkpoints"][mycheckpoint]["coords"]["y"],
                customMaps[map]["checkpoints"][mycheckpoint]["coords"]["z"],
                plyCoords.x,
                plyCoords.y,
                plyCoords.z
            )) < 30.0
        then
            --customMaps[map]["checkpoints"][mycheckpoint]["coords"]["dist"]

            SetBlipColour(SetBlips[mycheckpoint], 3)
            SetBlipScale(SetBlips[mycheckpoint], 1.0)

            PlaySound(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            mycheckpoint = mycheckpoint + 1

            SetBlipColour(SetBlips[mycheckpoint], 2)
            SetBlipScale(SetBlips[mycheckpoint], 1.6)
            SetBlipAsShortRange(SetBlips[mycheckpoint - 1], true)
            SetBlipAsShortRange(SetBlips[mycheckpoint], false)

            if mycheckpoint > checkpoints then
                mycheckpoint = 1
            end

            SetNewWaypoint(
                customMaps[map]["checkpoints"][mycheckpoint]["coords"]["x"],
                customMaps[map]["checkpoints"][mycheckpoint]["coords"]["y"]
            )

            if not sprint and mycheckpoint == 1 then
                SetBlipColour(SetBlips[1], 2)
                SetBlipScale(SetBlips[1], 1.6)
            end

            if not sprint and mycheckpoint == 2 then
                myLap = myLap + 1

                -- Uncomment these lines to make the checkpoints re-draw on each lap
                --ClearBlips()
                --RemoveCheckpoints()
                --LoadMapBlips(map)
                SetBlipColour(SetBlips[1], 3)
                SetBlipScale(SetBlips[1], 1.0)
                SetBlipColour(SetBlips[2], 2)
                SetBlipScale(SetBlips[2], 1.6)
            elseif sprint and mycheckpoint == 1 then
                myLap = myLap + 2
            end

            hudUpdate(
                "update",
                {
                    curLap = myLap,
                    curCheckpoint = (mycheckpoint - 1)
                }
            )
        end
    end

    hudUpdate(
        "finished",
        {
            eventId = identifier
        }
    )

    PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    TriggerEvent("DoLongHudText", "¡Has terminado!", 1)
    Wait(10000)
    racing = false
    hudUpdate("clear")
    ClearBlips()
    RemoveCheckpoints()

end

function EndRace()
    ClearBlips()
    RemoveCheckpoints()
end

function RemoveCheckpoints()
    for i = 1, #checkpointMarkers do
        SetEntityAsNoLongerNeeded(checkpointMarkers[i].left)
        DeleteObject(checkpointMarkers[i].left)
        SetEntityAsNoLongerNeeded(checkpointMarkers[i].right)
        DeleteObject(checkpointMarkers[i].right)
        checkpointMarkers[i] = nil
    end    
end

function FUCKK(num)
    local new = math.ceil(num * 100)
    new = new / 100
    return new    
end

function SaveMap(name,description)
    -- get distance here between checkpoints
    local distanceMap = 0.0
    for i = 1, #currentMap do
        if i == #currentMap then
            distanceMap =
                Vdist(
                currentMap[i]["x"],
                currentMap[i]["y"],
                currentMap[i]["z"],
                currentMap[1]["x"],
                currentMap[1]["y"],
                currentMap[1]["z"]
            ) + distanceMap
        else
            distanceMap =
                Vdist(
                currentMap[i]["x"],
                currentMap[i]["y"],
                currentMap[i]["z"],
                currentMap[i + 1]["x"],
                currentMap[i + 1]["y"],
                currentMap[i + 1]["z"]
            ) + distanceMap
        end
    end
    distanceMap = math.ceil(distanceMap)

    if #currentMap > 1 then
        TriggerEvent("DoLongHudText", "El mapa se esta procesando y deberia estar disponible en breve.", 2)
        TriggerServerEvent("racing-save-map", currentMap, name, description, distanceMap)
    else
        TriggerEvent("DoLongHudText", "Falla por falta de checkpoints", 2)
    end
    currentMap = {}
    creatingMap = false

end

RegisterNetEvent('racing-load-maps')
AddEventHandler('racing-load-maps', function(data)
    --currentRaces = data
end)

RegisterNUICallback('racing:events:list', function()
    SendNUIMessage(
        {
            openSection = "racing:events:list",
            races = currentRaces,
            canMakeMap = true
        }
    )    
end)

RegisterNUICallback('racing:events:highscore', function()
    TriggerServerEvent("racing-retreive-maps")
    Wait(300)
    local highScoreObject = {}
    for k, v in pairs(customMaps) do
        highScoreObject[k] = {
            fastestLap = v.fastest_lap,
            fastestName = v.fastest_name,
            fastestSprint = v.fastest_sprint,
            fastestSprintName = v.fastest_sprint_name,
            map = v.track_name,
            noOfRaces = v.races,
            mapDistance = v.distance
        }
    end

    SendNUIMessage(
        {
            openSection = "racing:events:highscore",
            highScoreList = highScoreObject
        }
    )

end)

RegisterNUICallback('racing:event:setup', function()
    ClearBlips()
    RemoveCheckpoints()
    TriggerServerEvent("racing-retreive-maps")
end)

Citizen.CreateThread(function()
    TriggerServerEvent("racing-retreive-maps")
end)

-- Fix
RegisterNUICallback('racing:event:leave', function()
    hudUpdate('clear')
    ClearBlips()
    RemoveCheckpoints()
    racing = false
end)

function LoadMapBlips(data)
    local checkpoints = data.checkpoints
    for index, checkpoint in pairs(checkpoints) do
        local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
        local retval, coords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
        local key = #SetBlips + 1
        checkpoint.blip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
        SetBlipAsFriendly(checkpoint.blip, true)
        SetBlipSprite(checkpoint.blip, 1)
        ShowNumberOnBlip(checkpoint.blip, index)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(tostring("Checkpoint " .. index))
        EndTextCommandSetBlipName(checkpoint.blip)
        SetBlips[key] = checkpoint.blip
    end    
end

-- Fix
RegisterNUICallback('racing:event:join', function(data)
    RemoveCheckpoints()
    local id = data.identifier
    local map = currentRaces[id]["map"]
    local ped = GetPlayerPed(-1)
    local plyCoords = GetEntityCoords(ped)

    if
        Vdist(
            customMaps[map]["checkpoints"][1]["coords"]["x"],
            customMaps[map]["checkpoints"][1]["coords"]["y"],
            customMaps[map]["checkpoints"][1]["coords"]["z"],
            plyCoords.x,
            plyCoords.y,
            plyCoords.z
        ) < 40
    then
        -- IF the race is OPEN and you are not in the race and youre not racing
        if currentRaces[id]["open"] and not JoinedRaces[id] and not racing then
            racing = true
            JoinedRaces[id] = true
            -- PUT LOGIC HERE
            TriggerServerEvent("racing-join-race", id)
            hudUpdate("starting")
            ShowText("Joining Race!")
            LoadMapBlips(customMaps[map])
        else
            -- IF youre in this race and youre not racing
            if (JoinedRaces[id] and not racing) then
                racing = true
                hudUpdate("starting")
            else
                ShowText("This race is closed or you are already in it!")
            end
        end
    else
        ShowText("You are too far away!")
    end

end)

-- Fix
RegisterNUICallback('racing:event:start', function(data)
    StartEvent(
        data.raceMap,
        data.raceLaps,
        data.raceCountdown,
        data.raceName,
        data.raceStartTime,
        data.mapCreator,
        data.mapDistance,
        data.mapDescription
    )

    Wait(500)
    SendNUIMessage(
        {
            openSection = "racing:events:list",
            races = currentRaces
        }
    )

end)

-- Fix this
RegisterNUICallback('race:completed', function(data)
    JoinedRaces[data.identifier] = nil
    TriggerServerEvent("race:completed2", data.fastestlap, data.overall, data.sprint, data.identifier)
    EndRace()    
end)

-- Racing:Map
RegisterNUICallback('racing:map:create', function()
    if not exports["StreetRaces"]:isRecordingRace() then
        ExecuteCommand("race record")
        TriggerEvent("DoLongHudText", "Se inicio la grabacion de los checkpoints, coloca tus checkpoints en el mapa", 1)
    else
        TriggerEvent("DoLongHudText", "¡La carrera ya ha sido grabada!", 2)
    end    
end)

RegisterNUICallback('racing:map:load', function(data)
    ClearBlips()
    RemoveCheckpoints()

    if (data.id ~= nil) then
        print("HERE")
        LoadMapBlips(customMaps[data.id]["map"])
    end

end)

RegisterNUICallback('racing:map:delete', function(data)
    ClearBlips()
    RemoveCheckpoints()
    if data.id == "0" then
        print("you suck")
    else
        TriggerServerEvent("racing-map-delete", customMaps[tonumber(data.id)]["dbid"])
    end
end)

RegisterNUICallback('racing:map:removeBlips', function()
    EndRace()
end)

RegisterNUICallback('racing:map:cancel', function()
    if exports["StreetRaces"]:isRecordingRace() then
        TriggerEvent("racing:cleanupRace")
        TriggerEvent("DoLongHudText", "Configuracion de carrera cancelada", 2)
    else
        TriggerEvent("DoLongHudText", "La carrera no se ha grabado...", 2)
    end    
end)

RegisterNUICallback('racing:map:save', function(data)
    if exports["StreetRaces"]:cpCount() then
        ExecuteCommand("race save " .. data.name .. " " .. GetPlayerName(PlayerPedId()))
        ExecuteCommand("race clear")
        TriggerEvent("DoLongHudText", "Se guardo la carrera" .. data.name, 1)
    else
        TriggerEvent("DoLongHudText", "No hay checkpoints agregados...", 2)
    end    
end)

RegisterNetEvent('racing:data:set')
AddEventHandler('racing:data:set', function(data)
    if (data.event == "map") then
        if (data.eventId ~= -1) then
            customMaps[data.eventId] = data.data
        else
            customMaps = data.data
            if (data.subEvent == nil or data.subEvent ~= "noNUI") then
                SendNUIMessage(
                    {
                        openSection = "racing-start",
                        maps = customMaps
                    }
                )
            end
        end
    elseif (data.event == "event") then
        if (data.eventId ~= -1) then
            currentRaces[data.eventId] = data.data
            if JoinedRaces[data.eventId] and racing and data.subEvent == "close" then
                RunRace(data.eventId)
            end
            SendNUIMessage(
                {
                    openSection = "racing:event:update",
                    eventId = data.eventId,
                    raceData = currentRaces[data.eventId]
                }
            )
        else
            currentRaces = data.data
            SendNUIMessage(
                {
                    openSection = "racing:event:update",
                    raceData = currentRaces
                }
            )
        end
    end    
end)
   
RegisterNetEvent('racing:clearFinishedRaces')
AddEventHandler('racing:clearFinishedRaces', function(id)
    if (JoinedRaces[id] ~= nil) then
        JoinedRaces[id] = nil
        ClearBlips()
        RemoveCheckpoints()
    end    
end)