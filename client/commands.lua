HUD.Data.hudHidden = false
RegisterCommand("hud", function()
    HUD:Toggle(HUD.Data.hudHidden)
    HUD.Data.hudHidden = not HUD.Data.hudHidden
end, false)

RegisterCommand("togglehud", function()
    HUD:Toggle(HUD.Data.hudHidden)
    HUD.Data.hudHidden = not HUD.Data.hudHidden
end, false)

RegisterCommand("hudsettings", function()
    SendNUIMessage({ type = "OPEN_SETTINGS" })
    SetNuiFocus(true, true)
end, false)

if not Config.Disable.VehicleHandlers and not Config.Disable.Vehicle then
    local leftSignal, rightSignal = false, false

    ESX.RegisterInput("esx_hud:indicator:left", Translate("indicatorLeft"), "keyboard", "LEFT", function()
        if not HUD.Data.Vehicle then
            return
        end
        if HUD.Data.VehicleType == "AIR" then
            return
        end
        leftSignal = not leftSignal
        SetVehicleIndicatorLights(HUD.Data.Vehicle, 1, leftSignal)

        local isAttached, trailer = GetVehicleTrailerVehicle(HUD.Data.Vehicle)
        if isAttached and DoesEntityExist(trailer) then
            SetVehicleIndicatorLights(trailer, 1, leftSignal)
        end
    end)

    ESX.RegisterInput("esx_hud:indicator:right", Translate("indicatorRight"), "keyboard", "RIGHT", function()
        if not HUD.Data.Vehicle then
            return
        end
        if HUD.Data.VehicleType == "AIR" then
            return
        end
        rightSignal = not rightSignal
        SetVehicleIndicatorLights(HUD.Data.Vehicle, 0, rightSignal)

        local isAttached, trailer = GetVehicleTrailerVehicle(HUD.Data.Vehicle)
        if isAttached and DoesEntityExist(trailer) then
            SetVehicleIndicatorLights(trailer, 0, rightSignal)
        end
    end)

    ESX.RegisterInput("esx_hud:indicator:Hazard", Translate("indicatorHazard"), "keyboard", "UP", function()
        if not HUD.Data.Vehicle then
            return
        end
        if HUD.Data.VehicleType == "AIR" then
            return
        end
        if leftSignal ~= rightSignal then
            leftSignal = true
            rightSignal = true
        else
            leftSignal = not leftSignal
            rightSignal = not rightSignal
        end
        SetVehicleIndicatorLights(HUD.Data.Vehicle, 0, rightSignal)
        SetVehicleIndicatorLights(HUD.Data.Vehicle, 1, leftSignal)

        local isAttached, trailer = GetVehicleTrailerVehicle(HUD.Data.Vehicle)
        if isAttached and DoesEntityExist(trailer) then
            SetVehicleIndicatorLights(trailer, 0, rightSignal)
            SetVehicleIndicatorLights(trailer, 1, leftSignal)
        end
    end)

    local seatsToWindow ={
        [0] = 0,
        [1] = 1,
        [2] = 2,
        [3] = 3,
        [4] = 3,
    }

    ESX.RegisterInput("esx_hud:windowRoll", Translate("windowRoll"), "keyboard", "Down", function()
        if not HUD.Data.Vehicle then
            return
        end
        if HUD.Data.VehicleType == "AIR" then
            return
        end

        local maxSeats = GetVehicleMaxNumberOfPassengers(HUD.Data.Vehicle)
        if maxSeats > 4  then
            return
        end

        local seat = ESX.PlayerData.seat
        local window = seatsToWindow[seat - 1]

        if not window then
            return
        end

        if IsVehicleWindowIntact(HUD.Data.Vehicle, window) then
            RollDownWindow(HUD.Data.Vehicle, window)
        else
            RollUpWindow(HUD.Data.Vehicle, window)
        end
    end)

    ESX.RegisterInput("esx_hud:toggleEngine", Translate("toggleEngine"), "keyboard", "N", function()
        if not HUD.Data.Vehicle then
            return
        end
        local engineState = GetIsVehicleEngineRunning(HUD.Data.Vehicle)
        engineState = not engineState
        SetVehicleEngineOn(HUD.Data.Vehicle, engineState, false, true)
    end)
end
