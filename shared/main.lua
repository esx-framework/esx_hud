HUD = {}
HUD.Data = {
    OnlinePlayers = 0,
    Weapon = {},
    Money = {}
}

Config.MultiChar = GetResourceState('esx_multicharacter'):find('start')

-- CreateThread(function ()
--     while true do
--         -- print(json.encode(HUD.Data,{indent=true}))
--         -- print(Config.Default.ServerLogo)
--         Wait(1000)
--     end
-- end)