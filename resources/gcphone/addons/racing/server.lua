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

ESX.RegisterServerCallback('gcphone:startRace', function(source, cb, data)
    TriggerClientEvent('gcphone:racing:startRace', -1, data.raceID)
    cb(true)
end)



ESX.RegisterServerCallback('gcphone:createRace', function(source, cb, data)
    try {
        function()
            local alias = data.raceInfo.yourAlias
            local raceID = #races+1
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
            table.insert(races, race)
            TriggerClientEvent('gcphone:racing:setRaces', -1, races)
            TriggerClientEvent('gcphone:racing:updateCurrentRace', source, raceID)
            TriggerClientEvent('gcphone:racing:updateJoinedRaces', source, raceID, true)
            TriggerClientEvent('gcphone:racing:NUIsetRaces', -1)
            local data = {}
            data.success = true
            data.eventID = raceID
            data.alias = alias
            cb(data)
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
    if races[data.raceID] then
        playerInfo = {}
        playerInfo.id = source
        playerInfo.alias = data.yourAlias
        playerInfo.checkpoint = 0
        playerInfo.position = 0
        local index = #races[data.raceID].players+1
        races[data.raceID].players[index] = playerInfo
        TriggerClientEvent('gcphone:racing:setRaces', -1, races)
        TriggerClientEvent('gcphone:racing:NUIsetRaces', -1)
        TriggerClientEvent('gcphone:racing:updateCurrentRace', source, raceID)
        TriggerClientEvent('gcphone:racing:updateJoinedRaces', source, raceID, true)
        local response = {}
        response.success = true
        response.eventID = data.raceID
        response.playerIndex = index
        cb(response)
    else
        cb(false)
    end
end)

Citizen.CreateThread(function()
    local result = MySQL.Sync.fetchAll("SELECT * FROM racing_tracks")
    if result[1] ~= nil then
        tracks = result
    else
        tracks = {}
    end
end)
