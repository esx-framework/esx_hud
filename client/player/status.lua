if not Config.Disable.Status then
    local playerId = PlayerId()

    function HUD:StatusThread()
        local values = {} -- Use a local variable instead of a global one

        CreateThread(function()
            while ESX.PlayerLoaded do
                local ped = PlayerPedId()
                
                -- Get health and armor values
                values.healthBar = math.floor((GetEntityHealth(ped) - 100) / (GetEntityMaxHealth(ped) - 100) * 100)
                values.armorBar = GetPedArmour(ped)
                
                -- Get thirst and hunger values
                local data = ESX.GetPlayerData().get('statuses')
                for i = 1, #data do
                    if data[i].name == "thirst" then
                        values.drinkBar = math.floor(data[i].percent)
                    end
                    if data[i].name == "hunger" then
                        values.foodBar = math.floor(data[i].percent)
                    end
                end

                -- Get oxygen and stamina values
                local oxygen = math.floor(GetPlayerUnderwaterTimeRemaining(playerId) * 10)
                local stamina = math.floor(100 - GetPlayerSprintStaminaRemaining(playerId))
                stamina = math.min(100, math.max(0, stamina)) -- Ensure stamina is within [0, 100]

                -- If swimming underwater, show oxygen bar; otherwise, set it to 0
                values.oxygenBar = IsPedSwimmingUnderWater(ped) and oxygen or 0
                values.staminaBar = stamina

                SendNUIMessage({ type = "STATUS_HUD", value = values })
                Wait(200)
            end
        end)
    end
end
