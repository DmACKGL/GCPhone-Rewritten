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
    if (raceInfo[source] ~= nil) then
        data = {}
        data.event = data.raceInfo.eventName
        data.eventId = #races +1
        data.owner = source
        data.map = tracks[data.raceInfo.trackID]
        data.startTime = data.raceInfo.CST
        data.data = {
            open = true,
            counter = counter,
            left = GetGameTimer() + (counter*1000),
            map = map,
            raceName = raceName,
            laps = laps,
            startTime = startTime,
            mapDistance = 0,
            mapCreator = mapCreator,
            mapDescription = "XDD",
            identifier = uniqueid,
        }
        table.insert(races, data)
        TriggerClientEvent('racing:data:set', -1, data)
        return data
    end
    cb(false)
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
