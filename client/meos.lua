local QBCore = exports['qb-core']:GetCoreObject()

-- NUI Callback

RegisterNUICallback('FetchVehicleResults', function(data, cb)
    QBCore.Functions.TriggerCallback('qb-phone:server:GetVehicleSearchResults', function(result)
        if result ~= nil then
            for k, v in pairs(result) do
                QBCore.Functions.TriggerCallback('police:IsPlateFlagged', function(flagged)
                    v.isFlagged = flagged
                end, v.plate)
                Wait(50)
            end
        end
        cb(result)
    end, data.input)
end)

RegisterNUICallback('FetchVehicleScan', function(_, cb)
    local vehicle = QBCore.Functions.GetClosestVehicle()
    local plate = QBCore.Functions.GetPlate(vehicle)
    local vehname = GetDisplayNameFromVehicleModel(GetEntityModel(vehicle)):lower()
    QBCore.Functions.TriggerCallback('qb-phone:server:ScanPlate', function(result)
        QBCore.Functions.TriggerCallback('police:IsPlateFlagged', function(flagged)
            result.isFlagged = flagged
	    if QBCore.Shared.Vehicles[vehname] ~= nil then
                result.label = QBCore.Shared.Vehicles[vehname]['name']
            else
                result.label = 'Unknown brand..'
            end
            cb(result)
        end, plate)
    end, plate)
end)

-- Events

RegisterNetEvent('qb-phone:client:addPoliceAlert', function(alertData)
    if PlayerData.job.name == 'police' and PlayerData.job.onduty then
        SendNUIMessage({
            action = "AddPoliceAlert",
            alert = alertData,
        })
    end
end)