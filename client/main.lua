function HUD:Toggle(state)
    SendNUIMessage({ type = "SHOW", value = state })
end

function HUD:SetHudColor()
    SendNUIMessage({ type = "SET_CONFIG_DATA", value = Config })
end

function HUD:Start(xPlayer)
    if not xPlayer then
        xPlayer = ESX.GetPlayerData()
    end
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

    self:Toggle(true)
end

-- Handlers
-- On script start
AddEventHandler("onResourceStart", function(resource)
    if GetCurrentResourceName() ~= resource then
        return
    end
    Wait(1000)
    HUD:Start()
end)

-- On player loaded
AddEventHandler("esx:playerLoaded", function(xPlayer)
    Wait(1000)
    HUD:Start(xPlayer)
end)

-- ForceLog or Logout
AddEventHandler("esx:onPlayerLogout", function()
    Wait(1000)
    HUD:Toggle(false)
end)
