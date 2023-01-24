PLAYERLOADED = false
local firstSpawn = false

-- Handlers
    -- On script start
    AddEventHandler('onResourceStart', function(resource)
        if GetCurrentResourceName() ~= resource then return end
        while not ESX.PlayerLoaded do Wait(200) end
        PLAYERLOADED = true
        -- #TODO: Start Hud
    end)

    if not Config.MultiChar then
        AddEventHandler('esx:onPlayerSpawn', function(xPlayer)
            if not firstSpawn then return end
            while not ESX.PlayerLoaded do Wait(200) end
            firstSpawn = true
            PLAYERLOADED = true
            -- #TODO: Start Hud
        end)
    else
        -- On player loaded
        AddEventHandler('esx:playerLoaded', function(xPlayer)
            PLAYERLOADED = true
            -- #TODO: Start Hud
        end)

        -- ForceLog or Logout
        AddEventHandler('esx:onPlayerLogout', function()
            PLAYERLOADED = false
            -- #TODO: Reset hud
        end)
    end