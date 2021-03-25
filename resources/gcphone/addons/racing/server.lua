ESX = nil
local races = {}
local tracks = {}
local raceInfo = {}

TriggerEvent('esx:getSharedObject', function(obj)
    ESX = obj
end)

--[[
    NUI CALLBACKS
--]]

ESX.RegisterServerCallback('gcphone:getRaces', function(source, cb)
	local data = {}
    data.code = true
    data.races = races
    data.tracks = tracks
    data.raceInfo = nil
    if (raceInfo[source] ~= nil) then
        data.raceInfo = raceInfo[source]      
    end
    cb(data)
end)

-- Server side array of active races


Citizen.CreateThread(function()
    local result = MySQL.Sync.fetchAll("SELECT * FROM racing_tracks")
    if result[1] ~= nil then
        tracks = result
    else
        tracks = {}
    end
end)

-- Server event for creating a race
RegisterNetEvent("races:createRace_sv")
AddEventHandler("races:createRace_sv", function(amount, startDelay, mapID)
    print(amount, startDelay, mapID)
    print('SELECT * FROM racing_tracks WHERE id = '.. mapID)
    local result = MySQL.Sync.fetchAll("SELECT * FROM racing_tracks WHERE id = @mapID", {
        ['@mapID'] = mapID
    })
    ESX.DumpTable(result)
    if result[1] ~= nil then
        local race = {
            owner = source,
            amount = amount,
            startTime = GetGameTimer() + startDelay,
            startCoords = result[1].checkpoints[1],
            checkpoints = result[1].checkpoints,
            currentMap =  result[1].name,
            finishTimeout = config_sv.finishTimeout,
            players = {},
            prize = 0,
            finishTime = 0
        }
        table.insert(races, race)
    
        -- Send race data to all clients
        local index = #races
        TriggerClientEvent("races:createRace_cl", 
            -1, 
            index, 
            race.ammount, 
            race.startTime, 
            race.startCoords, 
            race.checkpoints, 
            race.currentMap)
    else
        print('Track Not Found')
    end
end)


RegisterNetEvent('racing-retreive-maps')
AddEventHandler('racing-retreive-maps', function()
    local playerRaces = nil
    local playersDataFile = "./racesystem_saveData.txt"
    local file = io.open(playersDataFile, "r")
    if file then
        local contents = file:read("*a")
        playerRaces = json.decode(contents);
        io.close(file)
    end
    data = {}
    data.event = "map"
    data.eventId = -1
    data.data = playerRaces
    data.subEvent = nil
    TriggerClientEvent('racing:data:set', source, data)
end)

-- Server event for saving recorded checkpoints as a race
RegisterNetEvent("races:saveRace_sv")
AddEventHandler("races:saveRace_sv", function(name, checkpoints)
    -- Cleanup data so it can be serialized
    for _, checkpoint in pairs(checkpoints) do
        checkpoint.blip = nil
        checkpoint.coords = {x = checkpoint.coords.x, y = checkpoint.coords.y, z = checkpoint.coords.z}
    end

    -- Get saved player races, add race and save
    playerRaces = {}
    playerRaces.name = name
    playerRaces.creator = GetPlayerName(source)
    playerRaces.track_name = name
    playerRaces.mapDescription = "nada"
    playerRaces.map = {}
    playerRaces.map.checkpoints = checkpoints

    savePlayerData(source, playerRaces)

    -- Send notification to player
    local msg = "You saved a race - Name : " .. name
end)

-- Saved player data and file
local playersData = nil
local playersDataFile = "./racesystem_saveData.txt"

-- Helper function for saving player data
function savePlayerData(source, data)
    -- Load data from file if not already initialized
    if playersData == nil then
        print("NIL")
        playersData = {}
        local file = io.open(playersDataFile, "r")
        if file then
            print(1)
            local contents = file:read("*a")
            playersData = json.decode(contents);
            io.close(file)
        end
    end

    -- Get player steamID from source and use as key to save player data
    --local playerId = string.sub(GetPlayerIdentifier(source, 0), 7, -1)
    playersData[data.name] = data

    -- Save file
    local file = io.open(playersDataFile, "w+")
    if file then
        print(2)
        local contents = json.encode(playersData)
        file:write(contents)
        io.close(file)
        print(3)
    end
    
end

