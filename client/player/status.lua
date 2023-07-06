if not Config.Disable.Status then
    local values = {}
    local playerId = PlayerId()

    AddEventHandler("esx_status:onTick", function(data)
        local hunger, thirst
        for i = 1, #data do
            if data[i].name == "thirst" then
                thirst = math.floor(data[i].percent)
            end
            if data[i].name == "hunger" then
                hunger = math.floor(data[i].percent)
            end
        end

        local ped = PlayerPedId()

        values.healthBar = math.floor((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100) * 100)
        values.armorBar = GetPedArmour(ped)
        values.drinkBar = thirst
        values.foodBar = hunger
    end)

    function HUD:StatusThread()
        values = {}
        CreateThread(function()
            while ESX.PlayerLoaded do
                local oxygen, stamina
                oxygen = math.floor(GetPlayerUnderwaterTimeRemaining(playerId) * 10)
                stamina = math.floor(100 - GetPlayerSprintStaminaRemaining(playerId))
                if stamina == 0 then
                    stamina = 1
                end
                if stamina == 100 then
                    stamina = 0
                end
                values.oxygenBar = IsPedSwimmingUnderWater(PlayerPedId()) and oxygen or 0
                values.staminaBar = stamina
                SendNUIMessage({ type = "STATUS_HUD", value = values })
                Wait(200)
            end
        end)
    end
end
