ENTEREDVEHICLETRIGGERED = false

HUD = {
    Start = function(self, xPlayer)
        if not xPlayer then xPlayer = ESX.GetPlayerData() end 
        self:SetPlayerId()
        self:SetHudColor()
        self:SlowThick()
        self:FastThick()
        self:Toggle(true)
        if not Config.Disable.Info then
            self:UpdateAccounts(xPlayer.accounts)
        end
        if Config.Disable.MinimapOnFoot then
            DisplayRadar(false)
        end
    end,
    Toggle = function(self, state)
        SendNUIMessage({ type = 'SHOW', value = state })
    end,
    SetHudColor = function(self)
        SendNUIMessage({ type = 'SET_CONFIG_DATA', value = Config })
    end,
    Data = {
        Weapon = {},
        Money = {},
        onlinePlayers = 0
    }
}

-- Handlers
-- On script start
AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    Wait(100)
    HUD:Start()
end)

-- On player loaded
AddEventHandler('esx:playerLoaded', function(xPlayer)
    HUD:Start(xPlayer)
end)

-- On player dropped
AddEventHandler('esx:onPlayerLogout', function()
    HUD:Toggle(false)
end)

-- Events
RegisterNetEvent('esx_hud:ChangePlayerCount', function(OnlinePlayers)
    HUD.Data.onlinePlayers = OnlinePlayers
end)

-- NuiCallback
RegisterNUICallback('closePanel', function(data,cb)
    SetNuiFocus(false, false)
    cb('ok')
end)

RegisterNUICallback('unitChanged', function(state, cb)
    if HUD.Data.Vehicle and HUD.Data.Driver then
        if Config.Default.Kmh ~= state.unit then
            TriggerEvent('esx_hud:UnitChanged', state.unit)
        end
    end
    Config.Default.Kmh = state.unit
    cb('ok')
end)

RegisterNUICallback('minimapSettingChanged', function (state,cb)
    Config.Disable.MinimapOnFoot = state.changed
    if IsPedOnFoot(HUD.Data.Ped) ~= 1 then return cb('ok') end
    DisplayRadar(not state.changed)
    cb('ok')
end)

RegisterNUICallback('notify', function (data,cb)
    local state = data.state
    if state.reset then
        ESX.ShowNotification(Translate('settingsResetSuccess', 5000, 'info'))
        cb('ok')
        return
    end
    ESX.ShowNotification(Translate('settingsSaveSuccess', 5000, 'info'))
    cb('ok')
end)