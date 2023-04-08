-- [[ QBCore Data ]] --
local QBCore = exports['qb-core']:GetCoreObject()

-- [[ Variables ]] --
local pedSpawned = false
local createdPeds = {}

-- [[ Resource Metadata ]] --
AddEventHandler('onResourceStop', function (resource)
    if resource == GetCurrentResourceName() then
        DeletePeds()
    end
end)

-- [[ Threads ]] --
CreateThread(function()
    for k, v in pairs(Config.Peds) do
        if pedSpawned then
            return
        end

        for k, v in pairs(Config.Peds) do
            if not createdPeds[k] then
                createdPeds[k] = {}
            end

            local current = v['Ped']
            current = type(current) == 'string' and joaat(current) or current
            RequestModel(current)

            while not HasModelLoaded(current) do
                Wait(0) 
            end

            createdPeds[k] = CreatePed(0, current, v["Coords"].x, v["Coords"].y, v["Coords"].z - 1, v["Coords"].w, false, false)

            TaskStartScenarioInPlace(createdPeds[k], v["Scenario"], true)
            SetEntityInvincible(createdPeds[k], true)
            SetBlockingOfNonTemporaryEvents(createdPeds[k], true)
            FreezeEntityPosition(createdPeds[k], true)

            exports['qb-target']:AddTargetEntity(createdPeds[k], {
                options = {
                    {
                        icon = v["Icon"],
                        label = v["Label"],
                        type = v['Type'],
                        event = v['Event'],
                    },
                    {
                        icon = v["Icon2"],
                        label = v["Label2"],
                        type = v['Type2'],
                        event = v['Event2'],
                    },
                },
                distance = 2.0
            })
        end

        pedSpawned = true
    end
end) -- Spawns the Starting Ped

-- [[ Functions for End of Life ]] -- 
function DeletePeds()
    if pedSpawned then
        for k, v in pairs(createdPeds) do
            DeletePed(v)
        end
    end
end -- Delete Peds after resource restart
