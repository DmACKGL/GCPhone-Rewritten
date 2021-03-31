ESX = nil

function catch(what)
    return what[1]
 end
 
function try(what)
    status, result = pcall(what[1])
    if not status then
        what[2](result)
    end
    return result
end

local races = {}
local tracks = {}
local raceInfo = {}
local playerInfo = {}

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
    if playerInfo[source] ~= nil then
        data.userInfo = playerInfo[source]
    end
    cb(data)
end)

ESX.RegisterServerCallback('gcphone:startRace', function(source, cb, raceID)
	data.race[raceID].status = 1
    local data = {}
    data.code = true
    data.races = races
    data.tracks = tracks
    if playerInfo[source] ~= nil then
        data.userInfo = playerInfo[source]
    end
    cb(data)
end)



ESX.RegisterServerCallback('gcphone:createRace', function(source, cb, data)
    try {
        function()
            race = {}
            race.raceID = #races+1
            race.trackID = data.raceInfo.trackID
            race.eventName = data.raceInfo.eventName
            race.owner = source
            race.status = 0
            race.Laps = data.raceInfo.Laps
            race.money = data.raceInfo.money
            race.CST = data.raceInfo.CST
            race.reverse = data.raceInfo.reverse
            race.showPosition = data.raceInfo.showPosition
            race.sendNotification = data.raceInfo.sendNotification
            race.checkpoints = json.decode(tracks[race.trackID].checkpoints)
            race.checkpointsCount = #json.decode(tracks[race.trackID].checkpoints)
            race.players = {}
            playerInfo[2] = {}
            playerInfo[2].id = 2
            playerInfo[2].raceID = race.raceID
            playerInfo[2].alias = data.raceInfo.yourAlias
            playerInfo[2].checkpoint = 0
            playerInfo[2].position = 0
            playerInfo[2].owner = true
            table.insert(race.players, playerInfo[2])
            race.playersCount = #race.players
            table.insert(races, race)
            TriggerClientEvent('gcphone:racing:updateCurrentRace', 2, race)
            TriggerClientEvent('gcphone:racing:setRaces', -1, races)
            cb(true)
        end,
        catch {
            function()
                cb(false)
            end
        }
    }
end)

ESX.RegisterServerCallback('gcphone:joinRace', function(source, cb, data)
    local raceID = tonumber(data.raceID)
    print(ESX.DumpTable(races))
    print(ESX.DumpTable(races[raceID]))
    playerInfo[source] = {}
    playerInfo[source].id = source
    playerInfo[source].raceID = raceID
    playerInfo[source].alias = data.yourAlias
    playerInfo[source].checkpoint = 0
    playerInfo[source].position = 0
    playerInfo[source].owner = false
    local race = race[raceID]
    table.insert(race.players, playerInfo[source])
    print(ESX.DumpTable(playerInfo))
    print(ESX.DumpTable(races))
    TriggerClientEvent('gcphone:racing:updateCurrentRace', source, races[raceID])
    TriggerClientEvent('gcphone:racing:setRaces', -1, races)
    race.playersCount = #race.players
    local response = {}
    response.success = true
    response.races = races
    response.race = race
    cb(response)
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
