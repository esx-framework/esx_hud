if not Config.Disable.Vehicle then
    local cruiseControlStatus = false
    local currentMileage = 0

    local function isDriver()
        if GetPedInVehicleSeat(HUD.Data.Vehicle, -1) == HUD.Data.Ped then
            return true
        end
        return false
    end

    AddEventHandler('esx_hud:EnteredVehicle', function ()
        HUD.Data.Vehicle = GetVehiclePedIsIn(HUD.Data.Ped, false)
        HUD.Data.Plate = GetVehicleNumberPlateText(HUD.Data.Vehicle)
        HUD.Data.Driver = isDriver()
        local vehicleClass = GetVehicleClass(HUD.Data.Vehicle)
        --handle cycles
            if vehicleClass == 15 or vehicleClass == 16 then HUD.Data.VehicleType = 'AIR' else HUD.Data.VehicleType = 'LAND' end
                if Config.Disable.PassengerSpeedo and not HUD.Data.Driver then return end

                if HUD.Data.Driver then
                    TriggerServerEvent('esx_hud:EnteredVehicle', HUD.Data.Plate, Config.Default.Kmh)
                end

                if Config.Disable.MinimapOnFoot then
                    DisplayRadar(true)
                end

                local oldPos = nil
                while HUD.Data.InVehicle do
                    HUD.Data.Driver = isDriver() -- Check if meantime he changed seat

                    if vehicleClass ~= 13 then
                        local currentSpeed = GetEntitySpeed(HUD.Data.Vehicle)
                        local engineHealth = math.floor(GetVehicleEngineHealth(HUD.Data.Vehicle) / 10)
                        local engineRunning = GetIsVehicleEngineRunning(HUD.Data.Vehicle)
                        local _, lowBeam, highBeam = GetVehicleLightsState(HUD.Data.Vehicle)
                        local lightState = false
                        local indicator = GetVehicleIndicatorLights(HUD.Data.Vehicle)
                        local indicatorLeft, indicatorRight = false, false
                        local doorLockStatus = false
                        local tempDoorLockStatus = GetVehicleDoorLockStatus(HUD.Data.Vehicle)
                        local rpm = engineRunning and (GetVehicleCurrentRpm(HUD.Data.Vehicle) * 450) or 0
                        
                        if HUD.Data.VehicleType == 'AIR' then
                            rpm = math.ceil(HUD.Data.Position.z * 0.5)
                        end

                        if HUD.Data.VehicleType == 'AIR' then
                            rpm = math.ceil(HUD.Data.Position.z)
                        end

                        if engineHealth < 0 then engineHealth = 0 end

                        if lowBeam == 1 or highBeam == 1 then
                            lightState = true
                        end

                        if indicator == 1 or indicator == 3 then
                            indicatorLeft = true
                        end

                        if indicator == 2 or indicator == 3 then
                            indicatorRight = true
                        end

                        if tempDoorLockStatus == 2 or tempDoorLockStatus == 3 then
                            doorLockStatus = true
                        end

                        if IsVehicleOnAllWheels(HUD.Data.Vehicle) then
                            if oldPos then
                                local distance = #(oldPos.xy - HUD.Data.Position.xy)
                                if distance >= 10 then
                                    currentMileage += Config.Default.Kmh and distance/1000 or distance/1620
                                    currentMileage = ESX.Math.Round(currentMileage, 2)
                                    oldPos = HUD.Data.Position
                                end
                            else
                                oldPos = HUD.Data.Position
                            end
                        end

                        local values = {
                            show = true,
                            fuel = { level = HUD:FuelExport() or 100, maxLevel = 100 },
                            mileage = currentMileage,
                            kmh = Config.Default.Kmh,
                            speed = Config.Default.Kmh and math.floor(currentSpeed * 3.6) or math.floor(currentSpeed * 2.236936),
                            rpm = rpm,
                            damage = engineHealth,
                            vehType = HUD.Data.VehicleType,
                            driver = HUD.Data.Driver,
                            defaultIndicators = {
                                tempomat = cruiseControlStatus,
                                door = doorLockStatus,
                                light = lightState,
                                engine = engineRunning,
                                leftIndex = indicatorLeft,
                                rightIndex = indicatorRight,
                            }
                        }

                            SendNUIMessage({ type = 'VEH_HUD', value = values })
                    end
                    Wait(100)
                end
            if Config.Disable.MinimapOnFoot then
                DisplayRadar(false)
            end

            if HUD.Data.Driver then
                TriggerServerEvent('esx_hud:ExitedVehicle', HUD.Data.Plate, currentMileage, Config.Default.Kmh)
            end

            HUD.Data.Vehicle = nil
            HUD.Data.VehicleType = nil
            HUD.Data.Plate = nil
            HUD.Data.Driver = nil
            currentMileage = 0
            ENTEREDVEHICLETRIGGERED = false
            SendNUIMessage({ type = 'VEH_HUD', value = { show = false } })
    end)

    RegisterNetEvent('esx_hud:CruiseControlStatus', function(state)
        cruiseControlStatus = state
    end)

    RegisterNetEvent('esx_hud:CurrentMileage', function(mileage)
        currentMileage = mileage
    end)

    RegisterNetEvent('esx_hud:UnitChanged', function(state)
        if state then
            currentMileage = currentMileage * 1.61
        else
            currentMileage = currentMileage / 1.61
        end
        currentMileage = ESX.Math.Round(currentMileage, 2)
    end)
end
