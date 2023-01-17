isHidden = false
RegisterCommand('hud', function()
    HUD:Toggle(isHidden)
    isHidden = not isHidden
end, false)

RegisterCommand('togglehud', function()
    HUD:Toggle(isHidden)
    isHidden = not isHidden
end, false)

RegisterCommand('hudsettings', function ()
    SendNUIMessage({ type = 'OPEN_SETTINGS'})
    SetNuiFocus(true, true)
end, false)

if not Config.Disable.VehicleHandlers and not Config.Disable.Vehicle then
    local leftSignal, rightSignal = false, false

    ESX.RegisterInput('esx_hud:indicator:left', Translate('indicatorLeft'), "keyboard", "NUMPAD4", function()
        if not HUD.Data.Vehicle then return end
        if HUD.Data.VehicleType == 'AIR' then return end
        leftSignal = not leftSignal
        SetVehicleIndicatorLights(HUD.Data.Vehicle, 1, leftSignal)
    end)

    ESX.RegisterInput('esx_hud:indicator:right', Translate('indicatorRight'), "keyboard", "NUMPAD6", function()
        if not HUD.Data.Vehicle then return end
        if HUD.Data.VehicleType == 'AIR' then return end
        rightSignal = not rightSignal
        SetVehicleIndicatorLights(HUD.Data.Vehicle, 0, rightSignal)
    end)

    ESX.RegisterInput('esx_hud:toggleEngine', Translate('toggleEngine'), "keyboard", "N", function()
        if not HUD.Data.Vehicle then return end
        HUD.CruiseControl:Disable()
        local engineState = GetIsVehicleEngineRunning(HUD.Data.Vehicle)
        engineState = not engineState
        SetVehicleEngineOn(HUD.Data.Vehicle, engineState, true, true)
    end)
end

if not Config.Disable.CruiseControl and not Config.Disable.Vehicle then
    ESX.RegisterInput('esx_hud:cruisecontrol:Enable', Translate('cruiseControl'), "keyboard", "U", function()
        if not HUD.Data.Vehicle then return end
        HUD.CruiseControl:Enable()
    end)

    ESX.RegisterInput('esx_hud:cruisecontrol:IncreaseSpeed', Translate('increaseSpeed'), "keyboard", "ADD", function()
        if not HUD.Data.Vehicle then return end
        HUD.CruiseControl:ChangeSpeed(true)
    end)

    ESX.RegisterInput('esx_hud:cruisecontrol:DecreaseSpeed', Translate('decreaseSpeed'), "keyboard", "SUBTRACT", function()
        if not HUD.Data.Vehicle then return end
        HUD.CruiseControl:ChangeSpeed(false)
    end)
end