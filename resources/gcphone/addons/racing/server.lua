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

--[[
    {
    "raceInfo": {
        "trackID": 1,
        "eventName": "Test",
        "yourAlias": "DmACK",
        "Laps": "5",
        "money": "5000",
        "CST": "10",
        "reverse": true,
        "showPosition": true,
        "sendNotification": true
    }
}:
]]

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
    race.players[''..source..''] = data.raceInfo.yourAlias
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


-- Server side array of active races


Citizen.CreateThread(function()
    local result = MySQL.Sync.fetchAll("SELECT * FROM racing_tracks")
    if result[1] ~= nil then
        tracks = result
    else
        tracks = {}
    end
end)
