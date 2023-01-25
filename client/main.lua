PLAYERLOADED = false
local firstSpawn = false

function HUD:Toggle(state)
    SendNUIMessage({ type = 'SHOW', value = state })
end

function HUD:SetHudColor()
    SendNUIMessage({ type = 'SET_CONFIG_DATA', value = Config })
end

function HUD:Start(xPlayer)
    if not xPlayer then xPlayer = ESX.GetPlayerData() end
    self:Toggle(true)
    self:SetHudColor()
    self:SlowThick()
    self:FastThick()

    if not Config.Disable.Status then
        self:StatusThread()
    end

    if not Config.Disable.Info then
        self:UpdateAccounts(xPlayer.accounts)
    end

    if Config.Disable.MinimapOnFoot then
        DisplayRadar(false)
    end
end

-- Handlers
    -- On script start
    AddEventHandler('onResourceStart', function(resource)
        if GetCurrentResourceName() ~= resource then return end
        Wait(1000)
        while not ESX.PlayerLoaded do Wait(200) end
        PLAYERLOADED = true
        HUD:Start()
    end)

    if not Config.MultiChar then
        AddEventHandler('esx:onPlayerSpawn', function(xPlayer)
            if not firstSpawn then return end
            while not ESX.PlayerLoaded do Wait(200) end
            firstSpawn = true
            PLAYERLOADED = true
            HUD:Start()
        end)
    else
        -- On player loaded
        AddEventHandler('esx:playerLoaded', function(xPlayer)
            PLAYERLOADED = true
            HUD:Start(xPlayer)
        end)

        -- ForceLog or Logout
        AddEventHandler('esx:onPlayerLogout', function()
            PLAYERLOADED = false
            HUD:Toggle(false)
        end)
    end

