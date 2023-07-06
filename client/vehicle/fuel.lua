if not Config.Disable.Vehicle then
    if GetResourceState("ox_fuel") == "started" then
        function HUD:FuelExport()
            return ESX.Math.Round(GetVehicleFuelLevel(HUD.Data.Vehicle), 2)
        end
    elseif GetResourceState("LegacyFuel") == "started" then
        function HUD:FuelExport()
            return ESX.Math.Round(exports["LegacyFuel"]:GetFuel(HUD.Data.Vehicle), 2)
        end
    else
        function HUD:FuelExport()
            return false
        end
        TriggerServerEvent("esx_hud:ErrorHandle", "Setup your custom fuel resource at: client/vehicle/fuel.lua")
    end
end
