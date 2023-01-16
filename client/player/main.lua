local PlayerLoaded, inPause = false, false
local WeaponList = {}
local bool, ammoInClip = false, 0

function HUD.GetLocation(self)
    local PPos = self.Data.Position
    local streetHash = GetStreetNameAtCoord(PPos.x, PPos.y, PPos.z)
    local streetName = GetStreetNameFromHashKey(streetHash)
    return streetName
end

function HUD.UpdateAccounts(self, accounts)
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

function HUD.SetPlayerId(self)
    self.Data.PlayerId = PlayerId()
    self.Data.ServerId = GetPlayerServerId(self.Data.PlayerId)
end

function HUD.SlowThick(self)
    CreateThread(function()
        while PlayerLoaded do
            self.Data.Ped = PlayerPedId()
            self.Data.Position = GetEntityCoords(self.Data.Ped)
            self.Data.InVehicle = IsPedInAnyVehicle(self.Data.Ped, false) and GetEntityHealth(self.Data.Ped) > 0

            if not Config.Disable.Position then
                self.Data.Location = self:GetLocation()
            end

            if not Config.Disable.Weapon then
                self.Data.Weapon.Active, self.Data.Weapon.CurrentWeapon = GetCurrentPedWeapon(self.Data.Ped, false)
                if self.Data.Weapon.CurrentWeapon == 0 then self.Data.Weapon.Active = false end
                if self.Data.Weapon.Active then
                    self.Data.Weapon.MaxAmmo = (GetAmmoInPedWeapon(self.Data.Ped, self.Data.Weapon.CurrentWeapon)-ammoInClip)
                    self.Data.Weapon.Name = WeaponList[self.Data.Weapon.CurrentWeapon].label and WeaponList[self.Data.Weapon.CurrentWeapon].label or false
                    self.Data.Weapon.isWeaponMelee = not WeaponList[self.Data.Weapon.CurrentWeapon].ammo
                    self.Data.Weapon.Image = string.gsub(WeaponList[self.Data.Weapon.CurrentWeapon].name, "WEAPON_", "")
                    self.Data.Weapon.Image = string.lower(self.Data.Weapon.Image)
                end
            end

            if IsPauseMenuActive() and not inPause and not isHidden then
                inPause = true
                self:Toggle(not inPause)
            elseif not IsPauseMenuActive() and inPause and not isHidden then
                inPause = false
                self:Toggle(not inPause)
            end

            if not ENTEREDVEHICLETRIGGERED and self.Data.InVehicle then
                TriggerEvent('esx_hud:EnteredVehicle')
                ENTEREDVEHICLETRIGGERED = true
            end

            Wait(1000)
        end
    end)
end

function HUD.FastThick(self)
    CreateThread(function()
        while PlayerLoaded do
            if not Config.Disable.Voice then
                self.Data.isTalking = NetworkIsPlayerTalking(self.Data.PlayerId)
            end

            if self.Data.Weapon.Active then
                bool, ammoInClip = GetAmmoInClip(self.Data.Ped, self.Data.Weapon.CurrentWeapon)
                self.Data.Weapon.CurrentAmmo = ammoInClip
            end
            local values = {
                playerId = self.Data.ServerId,
                onlinePlayers = self.Data.onlinePlayers,
                serverLogo = Config.ServerLogo or 'https://esx.s3.fr-par.scw.cloud/blanc-800x800.png',
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
    Wait(100)
    PlayerLoaded = true

    if not Config.Disable.Weapon then
        local tempWeaponList = ESX.GetWeaponList()
        for i = 1, #tempWeaponList do
            WeaponList[GetHashKey(tempWeaponList[i].name)] = {name = tempWeaponList[i].name, label = tempWeaponList[i].label, ammo = tempWeaponList[i].ammo and true or false}
        end
    end
end)

-- On player loaded
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerLoaded = true

    if not Config.Disable.Weapon then
        local tempWeaponList = ESX.GetWeaponList()
        for i = 1, #tempWeaponList do
            WeaponList[GetHashKey(tempWeaponList[i].name)] = {name = tempWeaponList[i].name, label = tempWeaponList[i].label, ammo = tempWeaponList[i].ammo and true or false}
        end
    end
end)

-- On player dropped
AddEventHandler('esx:onPlayerLogout', function()
    PlayerLoaded = false
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
