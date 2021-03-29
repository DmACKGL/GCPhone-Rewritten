ESX = nil
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
    data.raceInfo = nil
    if (raceInfo[source] ~= nil) then
        data.raceInfo = raceInfo[source]      
    end
    cb(data)
end)


ESX.RegisterServerCallback('gcphone:createRace', function(source, cb, data)
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
    race.checkpoints = tracks[race.trackID].checkpoints
    race.checkpointsCount = #json.decode(tracks[race.trackID].checkpoints)
    race.players = {}
    race.players[source] = {}
    race.players[source].id = source
    race.players[source].alias = data.raceInfo.yourAlias
    race.players[source].checkpoint = 0
    race.players[source].position = 0
    playerInfo[source].raceID = race.raceID
    playerInfo[source].owner = true
    race.playersCount = #race.players
    table.insert(races, race)
    TriggerClientEvent('gcphone:racing:setRaces', -1, races)
    local response  ={}
    response.success = true
    response.raceID = race.raceID
    response.races = races
    response.race = race
    cb(response)
end)

ESX.RegisterServerCallback('gcphone:joinRace', function(source, cb, data)
    races[data.raceID].players[source] = {}
    races[data.raceID].players[source].id = source
    races[data.raceID].players[source].alias = data.yourAlias
    races[data.raceID].players[source].checkpoint = 0
    races[data.raceID].players[source].position = 0
    playerInfo[source].raceID = data.raceID
    playerInfo[source].owner = false
    TriggerClientEvent('gcphone:racing:setRaces', -1, races)
    local response  ={}
    response.success = true
    response.races = races
    response.race = race[data.raceID]
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
