
local bool, ammoInClip = false, 0
local WeaponList = {}

function HUD:GetLocation()
    local PPos = GetEntityCoords(PlayerPedId())
    local streetHash = GetStreetNameAtCoord(PPos.x, PPos.y, PPos.z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    return streetName
end

function HUD:UpdateAccounts(accounts)
    if not Config.Disable.Money then
        if accounts == nil then return end
        for _, data in pairs(accounts) do
            if data.name == 'bank' then
                self.Data.Money.bank = data.money
            elseif data.name == 'money' then
                self.Data.Money.cash = data.money
            end
        end
    end
end

function HUD:GetWeapons()
    local tempWeaponList = ESX.GetWeaponList()
    for i = 1, #tempWeaponList do
        WeaponList[GetHashKey(tempWeaponList[i].name)] = {name = tempWeaponList[i].name, label = tempWeaponList[i].label, ammo = tempWeaponList[i].ammo and true or false}
    end
end

function HUD:SlowThick()
    CreateThread(function()
        while not ESX.PlayerLoaded do Wait(200) end
        while ESX.PlayerLoaded do
            self.Data.Position = GetEntityCoords(PlayerPedId())

            if not Config.Disable.Position then
                self.Data.Location = self:GetLocation()
            end

            if not Config.Disable.Weapon then
                self.Data.Weapon.Active, self.Data.Weapon.CurrentWeapon = GetCurrentPedWeapon(PlayerPedId(), false)
                if self.Data.Weapon.CurrentWeapon == 0 then self.Data.Weapon.Active = false end
                if self.Data.Weapon.Active then
                    self.Data.Weapon.MaxAmmo = (GetAmmoInPedWeapon(PlayerPedId(), self.Data.Weapon.CurrentWeapon)-ammoInClip)
                    self.Data.Weapon.Name = WeaponList[self.Data.Weapon.CurrentWeapon].label and WeaponList[self.Data.Weapon.CurrentWeapon].label or false
                    self.Data.Weapon.isWeaponMelee = not WeaponList[self.Data.Weapon.CurrentWeapon].ammo
                    self.Data.Weapon.Image = string.gsub(WeaponList[self.Data.Weapon.CurrentWeapon].name, "WEAPON_", "")
                    self.Data.Weapon.Image = string.lower(self.Data.Weapon.Image)
                end
            end

            Wait(1000)
        end
    end)
end

function HUD:FastThick()
    CreateThread(function()
        while not ESX.PlayerLoaded do Wait(200) end
        while ESX.PlayerLoaded do
            if not Config.Disable.Voice then
                self.Data.isTalking = NetworkIsPlayerTalking(PlayerId())
            end

            if self.Data.Weapon.Active then
                bool, ammoInClip = GetAmmoInClip(PlayerPedId(), self.Data.Weapon.CurrentWeapon)
                self.Data.Weapon.CurrentAmmo = ammoInClip
            end
            local values = {
                playerId = GetPlayerServerId(PlayerId()),
                onlinePlayers = self.Data.OnlinePlayers,
                serverLogo = Config.Default.ServerLogo,
                moneys = { bank = self.Data.Money.bank or 0, money = self.Data.Money.cash or 0 },
                weaponData = {
                    use =  self.Data.Weapon.Active,
                    image = self.Data.Weapon.Image or 'pistol',
                    name = self.Data.Weapon.Name or 'Pistol',
                    isWeaponMelee = self.Data.Weapon.isWeaponMelee,
                    currentAmmo = self.Data.Weapon.CurrentAmmo or 0,
                    maxAmmo = self.Data.Weapon.MaxAmmo or 0
                },
                streetName = self.Data.Location or 'Noname street',
                voice = {mic = self.Data.isTalking or false, radio = self.Data.isTalkingOnRadio, range = self.Data.VoiceRange}
            }

            SendNUIMessage({ type = 'HUD_DATA', value = values })
            Wait(200)
        end
    end)
end

-- Handlers
-- On script start
AddEventHandler('onResourceStart', function(resource)
    if GetCurrentResourceName() ~= resource then return end
    while not ESX.PlayerLoaded do Wait(200) end
    if not Config.Disable.Weapon then HUD:GetWeapons() end
end)

-- On player loaded
AddEventHandler('esx:playerLoaded', function(xPlayer)
    while not ESX.PlayerLoaded do Wait(200) end
    if not Config.Disable.Weapon then HUD:GetWeapons() end
end)

AddEventHandler('esx:pauseMenuActive', function(state)
    if HUD.Data.hudHidden then return end
    HUD:Toggle(not state)
end)

RegisterNetEvent('esx_hud:UpdatePlayerCount', function(playerCount)
    HUD.Data.OnlinePlayers = playerCount
end)

--Cash and Bank handler
if not Config.Disable.Money then
    RegisterNetEvent('esx:setAccountMoney', function(account)
        if account.name == 'money' then
            HUD.Data.Money.cash = account.money
        elseif account.name == 'bank' then
            HUD.Data.Money.bank = account.money
        end
    end)
end