--[[
    Core
--]]

racing = false
currentRace = nil
SetBlips = {}
checkpointMarkers = {}


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

RegisterNUICallback('createRace', function (data, cb)
    cb(
        ESX.TriggerServerCallback('gcphone:createRace', function(res)
            cb(res)
        end, data)
    )
end)

RegisterNUICallback('joinRace', function (data, cb)
    cb(
        ESX.TriggerServerCallback('gcphone:joinRace', function(res)
            cb(res)
        end, data)
    )
end)


RegisterNUICallback('racingSetGPS', function (data, cb)
    if racing then
        SetNewWaypoint(currentRace.checkpoints[1].coords.x, currentRace.checkpoints[1].coords.y)
        cb(true)
    end
    cb(false)
end)

RegisterNUICallback('racingStartRace', function (data, cb)
    TriggerEvent('gcphone:racing:startRace')
    cb(true)
end)


-- update Races
RegisterNetEvent('gcphone:racing:setRaces')
AddEventHandler('gcphone:racing:setRaces', function (data)
    SendNUIMessage({event = 'updateRacingRaces', data = data})    
end)

--[[
    Events
]]

-- Update Client Race
RegisterNetEvent('gcphone:racing:updateCurrentRace')
AddEventHandler('gcphone:racing:updateCurrentRace', function (data)
    currentRace = data
    racing = true
    checkpoints = data.checkpoints
    for index, checkpoint in pairs(checkpoints) do
        local waypointCoords = GetBlipInfoIdCoord(GetFirstBlipInfoId(8))
        local retval, coords = GetClosestVehicleNode(waypointCoords.x, waypointCoords.y, waypointCoords.z, 1)
        local key = #SetBlips+1
        checkpoint.blip = AddBlipForCoord(checkpoint.coords.x, checkpoint.coords.y, checkpoint.coords.z)
        SetBlipAsFriendly(checkpoint.blip, true)
        SetBlipSprite(checkpoint.blip, 1)
        ShowNumberOnBlip(checkpoint.blip, index)
        BeginTextCommandSetBlipName("STRING");
        AddTextComponentString(tostring("Checkpoint " ..index))
        EndTextCommandSetBlipName(checkpoint.blip)
        SetBlips[key] = checkpoint.blip
    end
end)

RegisterNetEvent('gcphone:racing:startRace')
AddEventHandler('gcphone:racing:startRace', function ()
    startRace()
end)

--[[
    Functions
]]

function startRace()
    local myLap = 0
    local mycheckpoint = 1
    local ped = GetPlayerPed(-1)

    local plyCoords = GetEntityCoords(ped)

    SetBlipColour(SetBlips[1], 3)
    SetBlipScale(SetBlips[1], 1.6)

    ESX.ShowNotification("La carrera comienza en 3")
    PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    Citizen.Wait(1000)
    ESX.ShowNotification("La carrera comienza en 2")
    PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    Citizen.Wait(1000)
    ESX.ShowNotification("La carrera comienza en 1")
    PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    Citizen.Wait(1000)
    PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    ESX.ShowNotification("Go!")
    SendNUIMessage({event = 'updateRacingStatus', data = 1})

    while myLap < tonumber(currentRace.Laps) and racing do
        Citizen.Wait(1)
        local plyCoords = GetEntityCoords(ped)
    
        if
            (Vdist(
                currentRace.checkpoints[mycheckpoint]["coords"]["x"],
                currentRace.checkpoints[mycheckpoint]["coords"]["y"],
                currentRace.checkpoints[mycheckpoint]["coords"]["z"],
                plyCoords.x,
                plyCoords.y,
                plyCoords.z
            )) < 30.0
        then
            SetBlipColour(SetBlips[mycheckpoint], 3)
            SetBlipScale(SetBlips[mycheckpoint], 1.0)
    
            PlaySound(-1, "CHECKPOINT_NORMAL", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
            mycheckpoint = mycheckpoint + 1
    
            SetBlipColour(SetBlips[mycheckpoint], 2)
            SetBlipScale(SetBlips[mycheckpoint], 1.6)
            SetBlipAsShortRange(SetBlips[mycheckpoint - 1], true)
            SetBlipAsShortRange(SetBlips[mycheckpoint], false)
    
            if mycheckpoint > #currentRace.checkpoints then
                mycheckpoint = 1
            end
    
            SetNewWaypoint(
                currentRace.checkpoints[mycheckpoint]["coords"]["x"],
                currentRace.checkpoints[mycheckpoint]["coords"]["y"]
            )
    
            if not sprint and mycheckpoint == 1 then
                SetBlipColour(SetBlips[1], 2)
                SetBlipScale(SetBlips[1], 1.6)
            end
    
            if mycheckpoint == #currentRace.checkpoints then
                myLap = myLap + 1
    
                -- Uncomment these lines to make the checkpoints re-draw on each lap
                --ClearBlips()
                --RemoveCheckpoints()
                --LoadMapBlips(map)
                SetBlipColour(SetBlips[1], 3)
                SetBlipScale(SetBlips[1], 1.0)
                SetBlipColour(SetBlips[2], 2)
                SetBlipScale(SetBlips[2], 1.6)
            end
            print(mycheckpoint)
            SendNUIMessage({event = 'updateRacingCurrentLap', data = myLap})
            SendNUIMessage({event = 'updateRacingCurrentCheckpoint', data = mycheckpoint})
        end
    end
    
    PlaySound(-1, "3_2_1", "HUD_MINI_GAME_SOUNDSET", 0, 0, 1)
    ESX.ShowNotification("¡Has terminado!")
    Wait(10000)
    SendNUIMessage({event = 'updateRacingActive', data = false})
    racing = false
    ClearBlips()
    RemoveCheckpoints()
end

function ClearBlips()
    for i = 1, #SetBlips do
        RemoveBlip(SetBlips[i])
    end
    SetBlips = {}
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
  