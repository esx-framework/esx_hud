if not Config.Disable.Vehicle then
    CreateThread(function()
        local success, result = pcall(MySQL.query.await, 'SELECT mileage FROM owned_vehicles')
        if not success then
            MySQL.query('ALTER TABLE owned_vehicles ADD COLUMN `mileage` FLOAT(10) DEFAULT 0; ')
        end
    end)

    HUD.Mileage = {
        Load = function(self, plate, playerId, kmh)
            MySQL.single('SELECT mileage FROM owned_vehicles WHERE plate = ?', { plate }, function(data)
                local mileage, owned
                if data then
                    mileage, owned = data.mileage, true
                    if kmh then
                        mileage = mileage * 1.61
                    end
                else
                    mileage, owned = math.random(100, 10000), false
                end
                self:Create(plate, mileage, owned, playerId)
            end)
        end,
        Save = function(self)
            if next(self.Data) then
                local parameters = {}
                for plate, data in pairs(self.Data) do
                    if data.owned then
                        parameters[#parameters + 1] = { data.mileage, plate }
                    end
                end

                if next(parameters) then
                    MySQL.prepare('UPDATE `owned_vehicles` SET `mileage` = ? WHERE `plate` = ?', parameters)
                end
            end
        end,
        Create = function(self, plate, mileage, owned, playerId)
            self.Data[plate] = {mileage = mileage, owned = owned}
            self:SendDataToClient(mileage, playerId)
        end,
        Update = function(self, plate, mileage, playerId, kmh)
            if kmh then
                mileage = mileage / 1.61
            end
            self.Data[plate].mileage = mileage
            if playerId then
                self:SendDataToClient(mileage, playerId)
            end
        end,
        Exist = function(self, plate, playerId, kmh)
            if self.Data[plate] then
                local milage = self.Data[plate].mileage
                if kmh then
                    milage = self.Data[plate].mileage * 1.61
                end
                self:SendDataToClient(milage, playerId) 
                return 
            end
            self:Load(plate, playerId, kmh)
        end,
        SendDataToClient = function(self, mileage, playerId)
            TriggerClientEvent('esx_hud:CurrentMileage', playerId, mileage)
        end,
        Data = {}
    }

    RegisterNetEvent('esx_hud:EnteredVehicle', function(plate, kmh)
        local playerId = source
        HUD.Mileage:Exist(plate, playerId, kmh)
    end)

    RegisterNetEvent('esx_hud:ExitedVehicle', function(plate, mileage, kmh)
        TriggerClientEvent('esx_hud:ExitedVehicle', source)
        HUD.Mileage:Update(plate, mileage, source, kmh)
    end)

    CreateThread(function()
        while true do
            Wait(1000*60*5)
            HUD.Mileage:Save()
        end
    end)

    AddEventHandler('onResourceStop', function(resourceName)
        if GetCurrentResourceName() ~= resourceName then return end
        Wait(100)
        HUD.Mileage:Save()
    end)
end