local cruiseActive, increasePressure, lastEngineHealth, currentCCSpeed, lastIdealPedalPressure = false, false, 0, 0, 0.0
local speedDiffTolerance = (0.5 / 3.6)

HUD.CruiseControl = {
    IsSteering = function(self)
        return GetVehicleSteeringAngle(HUD.Data.Vehicle) > 10.0
    end,
    Enable = function(self)
        if not HUD.Data.Driver then return end
        if HUD.Data.VehicleType == 'AIR' then return end
        if cruiseActive then self:Disable() return end

        cruiseActive = true
        lastEngineHealth = GetVehicleEngineHealth(HUD.Data.Vehicle)

        CreateThread(function()
            currentCCSpeed = self:CalculateSpeed() or 0

            if currentCCSpeed == 0 then cruiseActive = false return end
 
            TriggerEvent('esx_hud:CruiseControlStatus', true)
            ESX.ShowNotification(Translate('cruiseControlEnabled', 5000, 'info'))

            while cruiseActive do
                local engineHealth = GetVehicleEngineHealth(HUD.Data.Vehicle)

                if IsControlJustPressed(0, 72) or IsControlJustPressed(0, 76) then
                    self:Disable()
                end

                if lastEngineHealth and ((lastEngineHealth - engineHealth) > 10) then
                    self:Disable()
                else
                    lastEngineHealth = engineHealth
                end

                local curSpeed = self:CalculateSpeed() or 0
                if curSpeed == 0 then self:Disable() return end

                local diff = currentCCSpeed - curSpeed
                if diff > speedDiffTolerance then
                    local pedalPressure = 0.95

                    if self:IsSteering() then
                        pedalPressure = 0.4
                    end

                    if increasePressure then
                        lastIdealPedalPressure = lastIdealPedalPressure + 0.025
                        increasePressure = false
                    end

                    SetControlNormal(0, 71, pedalPressure)
                elseif diff > -(4 * speedDiffTolerance) then
                    self:ApplyIdealPedalPressure()
                else
                    lastIdealPedalPressure = 0.2
                end
                Wait(0)
            end
        end)
    end,
    Disable = function(self)
        if not HUD.Data.Driver then return end
        if not cruiseActive then return end
        cruiseActive = false
        currentCCSpeed = 0
        lastEngineHealth = 0
        lastIdealPedalPressure = 0.0
        TriggerEvent('esx_hud:CruiseControlStatus', false)
        ESX.ShowNotification(Translate('cruiseControlDisabled', 5000, 'info'))
    end,
    ChangeSpeed = function(self, state)
        if not HUD.Data.Driver then return end
        if not cruiseActive then return end

        local currentSpeed = self:CalculateSpeed()

        if state then
            if currentSpeed >= 120 then return end
            currentSpeed += 10
            currentCCSpeed = currentSpeed
        else
            if currentSpeed == 0 then return end
            currentSpeed += -10
            if currentSpeed < 0 then currentSpeed = 0 end
            currentCCSpeed = currentSpeed
        end
        local speed = Config.Default.Kmh and ' km /h' or ' mph'
        ESX.ShowNotification(Translate('speedChanged') .. currentCCSpeed .. speed, 5000, 'info')
    end,
    CalculateSpeed = function(self)
        if not HUD.Data.Driver then return end
        if not cruiseActive then return end

        local curSpeed = GetEntitySpeed(HUD.Data.Vehicle)
        return Config.Default.Kmh and math.floor(curSpeed * 3.6) or math.floor(curSpeed * 2.236936)
    end,
    ApplyIdealPedalPressure = function(self)
        if not HUD.Data.Driver then return end
        if not cruiseActive then return end

        if not increasePressure then
            increasePressure = true
        end
        SetControlNormal(0, 71, lastIdealPedalPressure)
    end
}

RegisterNetEvent('esx_hud:ExitedVehicle', HUD.CruiseControl.Disable)