Citizen.CreateThread(function()
    local PlayerData = nil
    local loaded = false
    local prompts = {}
    local usagefuncs = {}
    local defaultdata = {
        name = "testprompt",
        objecttext = "World",
        actiontext = "Interact with something",
        holdtime = 5000,
        key = "E",
        -- position = vector3(0.0, 0.0, 0.0),
        params = {"test", "data"},
        usage = function(data)
            print("Proximity prompt got used, the following params got passed: " .. json.encode(data))
        end,
        drawdist = 3,
        usagedist = 1.5
    }

    RegisterNUICallback("triggercallback", function(data, cb)
        usagefuncs[data.name](prompts[data.name].params)
        cb()
    end)

    RegisterNUICallback("loaded", function(data, cb)
        loaded = true
        SendNUIMessage({
            action = "loaded"
        })
        cb()
    end)

    function AddNewPrompt(data)
        if data == nil then
            data = defaultdata
        end

        for i, v in pairs(defaultdata) do
            if data[i] == nil then
                data[i] = v
            end
        end

        data.timeheld = 0
        data.visible = false
        data.key = string.upper(data.key)
        data.isbeingpressed = false
        data.holding = false
        data.left = 0
        data.top = 0
        if data.position then
            data.position = vector3(data.position.x, data.position.y, data.position.z)
        end

        if Keys[data.key] ~= nil then
            if prompts[data.name] == nil then
                prompts[data.name] = data
                usagefuncs[data.name] = data.usage

                local data2 = data
                data2.usage = nil

                if loaded then
                    SendNUIMessage({
                        action = "addnewprompt",
                        data = data
                    })
                else
                    CreateThread(function()
                        while loaded == false do
                            Citizen.Wait(1000)
                        end
                        SendNUIMessage({
                            action = "addnewprompt",
                            data = data
                        })
                        return
                    end)
                end

                local subfuncs = {}
                function subfuncs:Remove()
                    prompts[data.name] = nil
                    SendNUIMessage({
                        action = "removeprompt",
                        name = data.name
                    })
                end

                function subfuncs:Delete()
                    prompts[data.name] = nil
                    SendNUIMessage({
                        action = "removeprompt",
                        name = data.name
                    })
                end

                function subfuncs:Update(values)
                    for i, v in pairs(values) do
                        if i == "key" then
                            prompts[data.name][i] = string.upper(v)
                        elseif i ~= "left" and i ~= "top" and i ~= "isbeingpressed" and i ~= "holding" and i ~=
                            "visible" and i ~= "timeheld" then
                            prompts[data.name][i] = v
                        end
                    end
                end

                return subfuncs
            else
                usagefuncs[data.name] = data.usage
                print(string.format(
                    "ZERIO-PROXIMITYPROMPT [WARN] - There is already a proximity prompt with the id \"%s\"", data.name))
            end
        else
            print(string.format(
                "ZERIO-PROXIMITYPROMPT [WARN] - The key \"%s\" doesn't exist. This warning is from the following prompt: \"%s\"",
                data.key, data.name))
        end
    end

    exports("AddNewPrompt", AddNewPrompt)

    while loaded == false do
        Citizen.Wait(100)
    end

    if GetResourceState("qb-core") ~= "missing" then
        QBCore = exports["qb-core"]:GetCoreObject()

        PlayerData = QBCore.Functions.GetPlayerData()
        if PlayerData and PlayerData.job then
            SendNUIMessage({
                action = "updatejob",
                job = PlayerData.job.name
            })
        end

        RegisterNetEvent("QBCore:Client:OnJobUpdate")
        AddEventHandler("QBCore:Client:OnJobUpdate", function()
            PlayerData = QBCore.Functions.GetPlayerData()
            SendNUIMessage({
                action = "updatejob",
                job = PlayerData.job.name
            })
        end)

        RegisterNetEvent("QBCore:Client:OnPlayerLoaded")
        AddEventHandler("QBCore:Client:OnPlayerLoaded", function()
            PlayerData = QBCore.Functions.GetPlayerData()
            SendNUIMessage({
                action = "updatejob",
                job = PlayerData.job.name
            })
        end)
    end

    if GetResourceState("es_extended") ~= "missing" then
        ESX = nil
        while ESX == nil do
            TriggerEvent("esx:getSharedObject", function(obj)
                ESX = obj
            end)
            Citizen.Wait(0)
        end

        PlayerData = ESX.GetPlayerData()
        if PlayerData and PlayerData.job then
            SendNUIMessage({
                action = "updatejob",
                job = PlayerData.job.name
            })
        end

        RegisterNetEvent("esx:setJob")
        AddEventHandler("esx:setJob", function()
            PlayerData = ESX.GetPlayerData()
            SendNUIMessage({
                action = "updatejob",
                job = PlayerData.job.name
            })
        end)

        RegisterNetEvent("esx:playerLoaded")
        AddEventHandler("esx:playerLoaded", function()
            PlayerData = ESX.GetPlayerData()
            SendNUIMessage({
                action = "updatejob",
                job = PlayerData.job.name
            })
        end)
    end

    while true do
        local plrpos = GetEntityCoords(PlayerPedId())
        local resx, resy = GetActiveScreenResolution()
        local idx = -1

        local noneInRange, noneOnScreen, lowestdist = true, true, math.huge
        local playerpos = GetEntityCoords(PlayerPedId())

        for i, v in pairs(prompts) do
            local v = prompts[i]
            local position = v.position
            if v.entity and not v.position then
                position = GetEntityCoords(v.entity)
            end

            local dist = #(plrpos - position)
            if lowestdist > dist then
                lowestdist = dist
            end
            if dist < v.drawdist then
                noneInRange = false
                local onscreen, x, y = World3dToScreen2d(position.x, position.y, position.z)
                if onscreen then
                    noneOnScreen = false
                    if IsPauseMenuActive() == false then
                        prompts[i].left = (x * resx) * 0.75
                        prompts[i].top = y * resy
                        prompts[i].visible = true
                        prompts[i].scale = (1 / dist)

                        if prompts[i].scale > 1 then
                            prompts[i].scale = 1
                        end
                        if prompts[i].scale < 0.5 then
                            prompts[i].scale = 0.5
                        end

                        if IsControlPressed(0, Keys[v.key]) and prompts[i].isbeingpressed == false and v.usagedist >
                            dist then
                            if prompts[i] then
                                prompts[i].isbeingpressed = true
                            end
                            Citizen.CreateThread(function()
                                local key = Keys[v.key]

                                SendNUIMessage({
                                    action = "startholding",
                                    idx = i
                                })

                                while true do
                                    if not IsControlPressed(0, key) then
                                        if prompts[i] then
                                            prompts[i].isbeingpressed = false
                                            SendNUIMessage({
                                                action = "stopholding",
                                                idx = i
                                            })

                                        end
                                        return
                                    end
                                    Citizen.Wait(100)
                                end
                            end)
                        end
                    else
                        prompts[i].visible = false
                    end
                else
                    prompts[i].visible = false
                end
            else
                prompts[i].visible = false
            end

            SendNUIMessage({
                action = "updateprompt",
                idx = i,
                data = {
                    visible = prompts[i].visible,
                    top = prompts[i].top,
                    left = prompts[i].left,
                    scale = prompts[i].scale
                }
            })
        end

        if noneOnScreen == false then
            Citizen.Wait(Config.RefreshRate)
        else
            Citizen.Wait(100)
        end

        if noneInRange == true then
            local time = lowestdist * 10
            if time > 1000 then
                time = 1000
            end
            Citizen.Wait(time)
        end
    end
end)
