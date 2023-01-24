-- if not Config.Disable.Status then
--     AddEventHandler('esx_status:onTick', function(data)
--         local hunger, thirst, oxygen, stamina
--         for i = 1, #data do
--             if data[i].name == 'thirst' then thirst = math.floor(data[i].percent) end
--             if data[i].name == 'hunger' then hunger = math.floor(data[i].percent) end
--         end

--         oxygen = math.floor(GetPlayerUnderwaterTimeRemaining(HUD.Data.PlayerId) * 10)
--         stamina = math.floor(100 - GetPlayerSprintStaminaRemaining(HUD.Data.PlayerId))
--         if stamina == 0 then stamina = 1 end
--         if stamina == 100 then stamina = 0 end

--         local values = {
--             healthBar = math.floor((GetEntityHealth(HUD.Data.Ped)/2)),
--             armorBar = GetPedArmour(HUD.Data.Ped),
--             drinkBar = thirst,
--             foodBar= hunger,
--             oxygenBar= IsPedSwimmingUnderWater(HUD.Data.Ped) and oxygen or 0,
--             staminaBar= stamina
--         }

--         SendNUIMessage({ type = 'STATUS_HUD', value = values })
--     end)
-- end