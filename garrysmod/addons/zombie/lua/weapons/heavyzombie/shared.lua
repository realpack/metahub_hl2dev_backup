AddCSLuaFile("shared.lua")

if CLIENT then
	SWEP.PrintName        = "Зомбайн"
	SWEP.Category         = "Zombies"
	SWEP.DrawAmmo         = false
	SWEP.DrawCrosshair    = true
	SWEP.ViewModelFOV     = 70
	SWEP.ViewModelFlip    = false
	SWEP.CSMuzzleFlashes  = false
	SWEP.IconLetter       = "J"
end

SWEP.Spawnable            = true
SWEP.AdminSpawnable       = true
SWEP.HoldType             = "knife"
SWEP.Author               = "ErrolLiamP"
SWEP.Purpose              = "Kill Humans"
SWEP.Instructions         = "Left click = Attack and Right click = Screech"

SWEP.ViewModel = ""
SWEP.WorldModel           = ""
SWEP.UseHands             = true

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = true
SWEP.Primary.Ammo = "none"
SWEP.Primary.Delay = 1.6

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = -1
SWEP.Secondary.Automatic = true
SWEP.Secondary.Ammo = "none"

function SWEP:Precache()
	util.PrecacheModel(self.ViewModel)

    util.PrecacheSound("npc/zombie/zombie_voice_idle1.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle2.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle3.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle4.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle5.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle6.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle7.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle8.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle9.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle10.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle11.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle12.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle13.wav")
    util.PrecacheSound("npc/zombie/zombie_voice_idle14.wav")
    util.PrecacheSound("npc/zombie/claw_strike1.wav")
    util.PrecacheSound("npc/zombie/claw_strike2.wav")
    util.PrecacheSound("npc/zombie/claw_strike3.wav")
    util.PrecacheSound("npc/zombie/claw_miss1.wav")
    util.PrecacheSound("npc/zombie/claw_miss2.wav")
    util.PrecacheSound("npc/zombie/zo_attack1.wav")
    util.PrecacheSound("npc/zombie/zo_attack2.wav")
end

function SWEP:Initialize()
	self:Precache()
    self:SetWeaponHoldType(self.HoldType)
    self:SetDeploySpeed(1)
end

function SWEP:NormalSpeed()
	if self.Owner:IsValid() then
		self.Owner:SetColor(Color(255, 255, 255, 255))
		self.Owner:SetRunSpeed(self.default_r_speed or 260)
		self.Owner:SetWalkSpeed(self.default_w_speed or 200)
	end
end

function SWEP:CustomSpeed() -- New speed
	if self.Owner:IsValid() then
		self.default_w_speed = self.default_w_speed or self.Owner:GetWalkSpeed()
		self.default_r_speed = self.default_r_speed or self.Owner:GetRunSpeed()
		self.Owner:SetColor(Color(155, 255, 155, 255))
		self.Owner:SetRunSpeed(200)
		self.Owner:SetWalkSpeed(150)
	end
end

function SWEP:Deploy()
	if self.Owner:IsValid() then
	self:CustomSpeed() -- call the custom speed funciton above

	self:SendWeaponAnim(ACT_VM_DEPLOY)
	timer.Simple(1.1, function(wep) self:SendWeaponAnim(ACT_VM_IDLE) end)
	end
	return true;
end

function SWEP:Holster()
	if self.Owner:IsValid() then
		self:NormalSpeed()
	end
	return true
end

function SWEP:Think()
    if not self.NextHit or CurTime() < self.NextHit then return end
    self.NextHit = nil

    local pl = self.Owner

    local vStart = pl:EyePos() + Vector(0, 0, -10)
    local trace = util.TraceLine({start=vStart, endpos = vStart + pl:GetAimVector() * 71, filter = pl, mask = MASK_SHOT})

    local ent
    if trace.HitNonWorld then
        ent = trace.Entity
    elseif self.PreHit and self.PreHit:IsValid() and not (self.PreHit:IsPlayer() and not self.PreHit:Alive()) and self.PreHit:GetPos():Distance(vStart) < 110 then
        ent = self.PreHit
        trace.Hit = true
    end

    if trace.Hit then
        pl:EmitSound("npc/zombie/claw_strike"..math.random(1, 3)..".wav")
    end

    pl:EmitSound("npc/zombie/claw_miss"..math.random(1, 2)..".wav")
    self.PreHit = nil

    if ent and ent:IsValid() and not (ent:IsPlayer() and not ent:Alive()) then
            local damage = 200
            local phys = ent:GetPhysicsObject()
            if phys:IsValid() and not ent:IsNPC() and phys:IsMoveable() then
                local vel = damage * 487 * pl:GetAimVector()

                phys:ApplyForceOffset(vel, (ent:NearestPoint(pl:GetShootPos()) + ent:GetPos() * 2) / 3)
                ent:SetPhysicsAttacker(pl)
            end
            if not CLIENT and SERVER then
            ent:TakeDamage(damage, pl, self)
        end
    end
end

SWEP.NextSwing = 0
function SWEP:PrimaryAttack()
    if CurTime() < self.NextSwing then return end

	local attack = math.random(1,2)
	if attack == 1 then self:SendWeaponAnim(ACT_VM_SECONDARYATTACK) else
	if attack == 2 then self:SendWeaponAnim(ACT_VM_HITCENTER) end
end

	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_RANGE_ZOMBIE)

    self.Owner:EmitSound("npc/zombie/zo_attack"..math.random(1, 2)..".wav")
	timer.Simple(1.4, function(wep) self:SendWeaponAnim(ACT_VM_IDLE) end)
    self.NextSwing = CurTime() + self.Primary.Delay
    self.NextHit = CurTime() + 1
    local vStart = self.Owner:EyePos() + Vector(0, 0, -10)
    local trace = util.TraceLine({start=vStart, endpos = vStart + self.Owner:GetAimVector() * 65, filter = self.Owner, mask = MASK_SHOT})
    if trace.HitNonWorld then
        self.PreHit = trace.Entity
    end
end

SWEP.NextMoan = 0
function SWEP:SecondaryAttack()
    if CurTime() < self.NextMoan then return end

	self.Owner:DoAnimationEvent(ACT_GMOD_GESTURE_TAUNT_ZOMBIE)

    if SERVER and not CLIENT then
        self.Owner:EmitSound("npc/zombie/zombie_voice_idle"..math.random(1, 14)..".wav")
    end
    self.NextMoan = CurTime() + 3
end

if CLIENT then
	function SWEP:DrawHUD()
		local ply = LocalPlayer()

		local x, y = ScrW()-200, ScrH()-50

		draw.ShadowSimpleText("ЛКМ - Ударить", "font_base_18", x, y, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
		draw.ShadowSimpleText("ПКМ - Кричать", "font_base_18", x, y+20, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	end
end
