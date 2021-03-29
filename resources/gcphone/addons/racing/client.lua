--[[
    NUI
--]]

RegisterNUICallback('getRaces', function (data, cb)
    cb(
        ESX.TriggerServerCallback('gcphone:getRaces', function(data)
            print(ESX.DumpTable(data))
            cb(data)
        end)
    )
end)

RegisterNUICallback('createRace', function (data, cb)
    cb(
        ESX.TriggerServerCallback('gcphone:createRace', function(res)
            print(res)
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
    cb(
        ESX.TriggerServerCallback('gcphone:createRace', function(res)
            cb(res)
        end, data)
    )
end)


-- Send races to -1
RegisterNetEvent('gcphone:racing:setRaces')
AddEventHandler('gcphone:racing:setRaces', function (data)
    SendNUIMessage({event = 'updateRacingRaces', data = data})
end)

--[[
    Core
--]]
local racing = false
