local cruiseControlStatus = false
local isPassenger = false
local isSeatbeltOn = false

local function SetCruiseControlState(state)
    cruiseControlStatus = state
end

exports("CruiseControlState", function(...)
    SetCruiseControlState(...)
end)

local function SetSeatbeltState(state)
    isSeatbeltOn = state
end

exports("SeatbeltState", function(...)
    SetSeatbeltState(...)
end)

if not Config.Disable.Vehicle then
    local inVehicle, vehicleType, playerPos = false, nil, nil
    local currentMileage = 0

    HUD.Data.Driver = false

    local values = {
        show = false,
        defaultIndicators = {},
    }

    local function driverCheck(currentVehicle)
        if not DoesEntityExist(currentVehicle) then
            return false
        end
        if GetPedInVehicleSeat(currentVehicle, -1) == PlayerPedId() then
            return true
        end
        return false
    end

    local function driverCheckThread(currentVehicle)
        CreateThread(function()
            while inVehicle do
                HUD.Data.Driver = driverCheck(currentVehicle)
                playerPos = GetEntityCoords(PlayerPedId()).xy

                if not Config.Default.PassengerSpeedo and not HUD.Data.Driver then
                    SendNUIMessage({ type = "VEH_HUD", value = { show = false } })
                    isPassenger = true
                end
                Wait(1000)
            end
        end)
    end

    local function slowInfoThread(currentVehicle)
        CreateThread(function()
            local oldPos = nil

            while inVehicle and DoesEntityExist(currentVehicle) do
                local engineHealth = math.floor(GetVehicleEngineHealth(currentVehicle) / 10)
                local _, lowBeam, highBeam = GetVehicleLightsState(currentVehicle)
                local lightState = false
                local indicator = GetVehicleIndicatorLights(currentVehicle)
                local indicatorLeft, indicatorRight = false, false
                local doorLockStatus = false
                local tempDoorLockStatus = GetVehicleDoorLockStatus(currentVehicle)

                -- Make sure engine health not going to minus
                if engineHealth < 0 then
                    engineHealth = 0
                end

                -- Set light state
                if lowBeam == 1 or highBeam == 1 then
                    lightState = true
                end

                -- Set indicator state
                if indicator == 1 or indicator == 3 then
                    indicatorLeft = true
                end
                if indicator == 2 or indicator == 3 then
                    indicatorRight = true
                end

                -- Set lock state
                if tempDoorLockStatus == 2 or tempDoorLockStatus == 3 then
                    doorLockStatus = true
                end

                if IsVehicleOnAllWheels(currentVehicle) then
                    if oldPos then
                        local distance = #(oldPos - playerPos)
                        if distance >= 10 then
                            currentMileage += Config.Default.Kmh and distance / 1000 or distance / 1620
                            currentMileage = ESX.Math.Round(currentMileage, 2)
                            oldPos = playerPos
                        end
                    else
                        oldPos = playerPos
                    end
                end

                values.fuel = { level = HUD:FuelExport() or 100, maxLevel = 100 }
                values.mileage = currentMileage
                values.kmh = Config.Default.Kmh
                values.damage = engineHealth
                values.vehType = vehicleType
                values.driver = HUD.Data.Driver
                values.defaultIndicators.seatbelt = isSeatbeltOn
                values.defaultIndicators.tempomat = cruiseControlStatus
                values.defaultIndicators.door = doorLockStatus
                values.defaultIndicators.light = lightState
                values.defaultIndicators.leftIndex = indicatorLeft
                values.defaultIndicators.rightIndex = indicatorRight

                Wait(200)
            end
        end)
    end

    local function fastInfoThread(currentVehicle)
        CreateThread(function()
            while inVehicle do
                local currentSpeed = GetEntitySpeed(currentVehicle)
                local engineRunning = GetIsVehicleEngineRunning(currentVehicle)
                local rpm

                if vehicleType == "LAND" or vehicleType == "MOTO" then
                    rpm = engineRunning and (GetVehicleCurrentRpm(currentVehicle) * 450) or 0
                else
                    rpm = math.ceil(ESX.PlayerData.coords.z)
                end

                values.speed = Config.Default.Kmh and math.floor(currentSpeed * 3.6) or math.floor(currentSpeed * 2.236936)
                values.rpm = rpm
                values.defaultIndicators.engine = engineRunning
                if not isPassenger then
                    SendNUIMessage({ type = "VEH_HUD", value = values })
                end
                Wait(50)
            end
        end)
    end

    local function activateVehicleHud(currentVehicle)
        values.show = true
        slowInfoThread(currentVehicle)
        fastInfoThread(currentVehicle)
    end

    AddEventHandler("esx:enteredVehicle", function(currentVehicle, currentPlate, currentSeat, displayName, netId)
        local vehicleClass = GetVehicleClass(currentVehicle)
        if vehicleClass == 13 then
            return
        end

        inVehicle = true
        HUD.Data.Driver = currentSeat == -1 or false
        HUD.Data.Vehicle = currentVehicle
        vehicleType = "LAND"

        if vehicleClass == 15 or vehicleClass == 16 then
            vehicleType = "AIR"
        elseif vehicleClass == 8 then
            vehicleType = "MOTO"
        end

        -- We have to check if he changed seat meantime
        driverCheckThread(currentVehicle)

        if Config.Disable.MinimapOnFoot then
            DisplayRadar(true)
        end

        activateVehicleHud(currentVehicle)

        if HUD.Data.Driver then
            TriggerServerEvent("esx_hud:EnteredVehicle", currentPlate, Config.Default.Kmh)
        end
    end)

    AddEventHandler("esx:exitedVehicle", function(currentVehicle, currentPlate, currentSeat, displayName, netId)
        inVehicle = false
        HUD.Data.Driver = false
        HUD.Data.Vehicle = nil
        vehicleType = nil
        values = {
            show = false,
            defaultIndicators = {},
        }
        SendNUIMessage({ type = "VEH_HUD", value = { show = false } })

        if Config.Disable.MinimapOnFoot then
            DisplayRadar(false)
        end

        if currentSeat == -1 then
            TriggerServerEvent("esx_hud:ExitedVehicle", currentPlate, currentMileage, Config.Default.Kmh)
        end
        currentMileage = 0
        isPassenger = false
    end)

    RegisterNetEvent("esx_hud:UpdateMileage", function(mileage)
        currentMileage = mileage
    end)

    AddEventHandler("esx_hud:UnitChanged", function(state)
        if state then
            currentMileage = currentMileage * 1.61
        else
            currentMileage = currentMileage / 1.61
        end
        currentMileage = ESX.Math.Round(currentMileage, 2)
    end)
end
