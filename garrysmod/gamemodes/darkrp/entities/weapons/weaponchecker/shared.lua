AddCSLuaFile()

if CLIENT then
    SWEP.PrintName = "Проверка на оружие"
    SWEP.Slot = 1
    SWEP.SlotPos = 9
    SWEP.DrawAmmo = false
    SWEP.DrawCrosshair = false
end

SWEP.Author = "MetaHub"
SWEP.Instructions = "Left click to weapon check\nRight click to confiscate weapons\nReload to give back the weapons"
SWEP.Contact = ""
SWEP.Purpose = ""
SWEP.IsDarkRPWeaponChecker = true

SWEP.ViewModelFOV = 62
SWEP.ViewModelFlip = false
SWEP.AnimPrefix  = "rpg"

SWEP.Spawnable = true
SWEP.AdminOnly = true
SWEP.Category = "DarkRP (Utility)"
SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = 0
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

function SWEP:Initialize()
    self:SetHoldType("normal")
end

function SWEP:SetupDataTables()
    self:NetworkVar("Bool", 0, "IsWeaponChecking")
    self:NetworkVar("Float", 0, "StartCheckTime")
    self:NetworkVar("Float", 1, "EndCheckTime")
    self:NetworkVar("Float", 2, "NextSoundTime")
    self:NetworkVar("Int", 0, "TotalWeaponChecks")
end

function SWEP:Deploy()
    return true
end

function SWEP:DrawWorldModel() end

function SWEP:PreDrawViewModel(vm)
    return true
end

function SWEP:GetStrippableWeapons(ent, callback)
  for _, v in ipairs(ent:GetWeapons()) do
    if not v:IsValid() then continue end
    local class = v:GetClass()

    if rp.cfg.weaponCheckerHideDefault and (table.HasValue(rp.cfg.DefaultWeapons, class) or table.HasValue(rp.cfg.AdminWeapons, class) or
      rp.teams[ent:Team()].weapons and table.HasValue(rp.teams[ent:Team()].weapons, class)) then
      continue
    end

    if rp.cfg.noStripWeapons[class] then continue end

    callback(v)
  end
end

function SWEP:PrimaryAttack()
    if self:GetIsWeaponChecking() then return end
    self:SetNextPrimaryFire(CurTime() + 0.3)

    self:GetOwner():LagCompensation(true)
    local trace = self:GetOwner():GetEyeTrace()
    self:GetOwner():LagCompensation(false)

    local ent = trace.Entity
    if not IsValid(ent) or not ent:IsPlayer() or ent:GetPos():DistToSqr(self:GetOwner():GetPos()) > 10000 then
        return
    end

    self:EmitSound("npc/combine_soldier/gear5.wav", 50, 100)
    self:SetNextSoundTime(CurTime() + 0.3)

    if not IsFirstTimePredicted() then return end

    local weps = {}
    self:GetStrippableWeapons(ent, function(wep)
        table.insert(weps, wep)
    end)

    hook.Call("playerWeaponsChecked", nil, self:GetOwner(), ent, weps)

    if not CLIENT then return end

    self:PrintWeapons(ent, "Оружие "..ent:Nick().." - ")
end

function SWEP:SecondaryAttack()

    if self:GetIsWeaponChecking() then return end

    self:SetNextSecondaryFire(CurTime() + 0.3)

    self:GetOwner():LagCompensation(true)
    local trace = self:GetOwner():GetEyeTrace()
    self:GetOwner():LagCompensation(false)

    local ent = trace.Entity
    if not IsValid(ent) or not ent:IsPlayer() or ent:GetPos():DistToSqr(self:GetOwner():GetPos()) > 10000 then
        return
    end

    self:SetIsWeaponChecking(true)
    self:SetStartCheckTime(CurTime())
    self:SetEndCheckTime(CurTime() + util.SharedRandom("DarkRP_WeaponChecker" .. self:EntIndex() .. "_" .. self:GetTotalWeaponChecks(), 5, 10))
    self:SetTotalWeaponChecks(self:GetTotalWeaponChecks() + 1)

    self:SetNextSoundTime(CurTime() + 0.5)

    if CLIENT then
        self.Dots = ""
        self.NextDotsTime = CurTime() + 0.5
    end
end

function SWEP:Reload()
    if CLIENT or CurTime() < (self.NextReloadTime or 0) then return end
    self.NextReloadTime = CurTime() + 1

    local trace = self:GetOwner():GetEyeTrace()

    local ent = trace.Entity
    if not IsValid(ent) or not ent:IsPlayer() or ent:GetPos():DistToSqr(self:GetOwner():GetPos()) > 10000 then
        return
    end

    if not ent.ConfiscatedWeapons then
        DarkRP.notify(self:GetOwner(), 1, 4, "У "..ent:Nick().." нет нелегального оружия")
        return
    else
        for _, v in pairs(ent.ConfiscatedWeapons) do
            local wep = ent:Give(v.class)
            ent:RemoveAllAmmo()
            ent:SetAmmo(v.primaryAmmoCount, v.primaryAmmoType, false)
            ent:SetAmmo(v.secondaryAmmoCount, v.secondaryAmmoType, false)

            wep:SetClip1(v.clip1)
            wep:SetClip2(v.clip2)

        end
        DarkRP.notify(self:GetOwner(), 2, 4, "Вы вернули "..ent:Nick().." конфискованное оружие")

        hook.Call("playerWeaponsReturned", nil, self:GetOwner(), ent, ent.ConfiscatedWeapons)
        ent.ConfiscatedWeapons = nil
    end
end

function SWEP:Holster()
    self:SetIsWeaponChecking(false)
    self:SetNextSoundTime(0)
    return true
end

function SWEP:Succeed()
    if not IsValid(self:GetOwner()) then return end
    self:SetIsWeaponChecking(false)

    local trace = self:GetOwner():GetEyeTrace()
    local ent = trace.Entity
    if not IsValid(ent) or not ent:IsPlayer() then return end

    if CLIENT then
        if not IsFirstTimePredicted() then return end
        self:PrintWeapons(ent, "Вы конфиковали нелегальное оружие")
        return
    end

    local stripped = {}

    self:GetStrippableWeapons(ent, function(wep)
        ent:StripWeapon(wep:GetClass())
        stripped[wep:GetClass()] = {
            class = wep:GetClass(),
            primaryAmmoCount = ent:GetAmmoCount(wep:GetPrimaryAmmoType()),
            primaryAmmoType = wep:GetPrimaryAmmoType(),
            secondaryAmmoCount = ent:GetAmmoCount(wep:GetSecondaryAmmoType()),
            secondaryAmmoType = wep:GetSecondaryAmmoType(),
            clip1 = wep:Clip1(),
            clip2 = wep:Clip2()
        }
    end)

    if not ent.ConfiscatedWeapons then
        if next(stripped) ~= nil then ent.ConfiscatedWeapons = stripped end
    else
        -- Merge stripped weapons into confiscated weapons
        for k,v in pairs(stripped) do
            if ent.ConfiscatedWeapons[k] then continue end

            ent.ConfiscatedWeapons[k] = v
        end
    end

    hook.Call("playerWeaponsConfiscated", nil, self:GetOwner(), ent, ent.ConfiscatedWeapons)

    if next(stripped) ~= nil then
        self:EmitSound("npc/combine_soldier/gear5.wav", 50, 100)
        self:SetNextSoundTime(CurTime() + 0.3)
    else
        self:EmitSound("ambient/energy/zap1.wav", 50, 100)
        self:SetNextSoundTime(0)
    end
end

function SWEP:PrintWeapons(ent, weaponsFoundPhrase)
    local result = {}
    local weps = {}
    self:GetStrippableWeapons(ent, function(wep)
        table.insert(weps, wep)
    end)

    for _, wep in ipairs(weps) do
        table.insert(result, wep:GetPrintName() and language.GetPhrase(wep:GetPrintName()) or wep:GetClass())
    end

    result = table.concat(result, ", ")

    if result == "" then
        self:GetOwner():ChatPrint("У "..ent:Nick().." нет нелегального оружия")
        return
    end

    self:GetOwner():ChatPrint(weaponsFoundPhrase)
    if string.len(result) >= 126 then
        local amount = math.ceil(string.len(result) / 126)
        for i = 1, amount, 1 do
            self:GetOwner():ChatPrint(string.sub(result, (i-1) * 126, i * 126 - 1))
        end
    else
        self:GetOwner():ChatPrint(result)
    end
end

function SWEP:Fail()
    self:SetIsWeaponChecking(false)
    self:SetHoldType("normal")
    self:SetNextSoundTime(0)
end

function SWEP:Think()
    if self:GetIsWeaponChecking() and self:GetEndCheckTime() ~= 0 then
        self:GetOwner():LagCompensation(true)
        local trace = self:GetOwner():GetEyeTrace()
        self:GetOwner():LagCompensation(false)
        if not IsValid(trace.Entity) or trace.HitPos:DistToSqr(self:GetOwner():GetShootPos()) > 10000 or not trace.Entity:IsPlayer() then
            self:Fail()
        end
        if self:GetEndCheckTime() <= CurTime() then
            self:Succeed()
        end
    end
    if self:GetNextSoundTime() ~= 0 and CurTime() >= self:GetNextSoundTime() then
        if self:GetIsWeaponChecking() then
            self:SetNextSoundTime(CurTime() + 0.5)
            self:EmitSound("npc/combine_soldier/gear5.wav", 100, 100)
        else
            self:SetNextSoundTime(0)
            self:EmitSound("npc/combine_soldier/gear5.wav", 50, 100)
        end
    end
    if CLIENT and self.NextDotsTime and CurTime() >= self.NextDotsTime then
        self.NextDotsTime = CurTime() + 0.5
        self.Dots = self.Dots or ""
        local len = string.len(self.Dots)
        local dots = {
            [0] = ".",
            [1] = "..",
            [2] = "...",
            [3] = ""
        }
        self.Dots = dots[len]
    end
end

function SWEP:DrawHUD()
    if self:GetIsWeaponChecking() and self:GetEndCheckTime() ~= 0 then
        self.Dots = self.Dots or ""
        local w = ScrW()
        local h = ScrH()
        local x, y, width, height = w / 2 - w / 10, h / 2, w / 5, h / 15
        local time = self:GetEndCheckTime() - self:GetStartCheckTime()
        local curtime = CurTime() - self:GetStartCheckTime()
        local status = math.Clamp(curtime / time, 0, 1)
        local BarWidth = status * (width - 16)
        local cornerRadius = math.Min(8, BarWidth / 3 * 2 - BarWidth / 3 * 2 % 2)

        draw.RoundedBox(8, x, y, width, height, Color(10, 10, 10, 120))
        draw.RoundedBox(cornerRadius, x + 8, y + 8, BarWidth, height - 16, Color(0, 0 + (status * 255), 255 - (status * 255), 255))
        draw.ShadowSimpleText("Ищем" .. self.Dots, "Trebuchet24", w / 2, y + height / 2, Color(255, 255, 255, 255), 1, 1)
    end
end
