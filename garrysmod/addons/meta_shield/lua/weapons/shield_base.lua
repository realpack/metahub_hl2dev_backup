AddCSLuaFile()

if (CLIENT) then
	SWEP.PrintName = "Small Combine Shield"
	SWEP.Slot = 1
	SWEP.SlotPos = 2
	SWEP.DrawAmmo = false
	SWEP.DrawCrosshair = false
    SWEP.Icon = "vgui/ttt/icon_nades" -- most generic icon I guess
end

SWEP.Kind = WEAPON_HEAVY
SWEP.CanBuy = nil
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true
SWEP.IsSilent = false

SWEP.Category = "Riot Shields - Black Tea"
SWEP.Author = "Black Tea"
SWEP.Instructions = "Just hold and Block some shit"
SWEP.Purpose = "Just hold and Block some shit"
SWEP.Drop = false
SWEP.typeShield = "genericShield"

SWEP.HoldType = "shotgun"

SWEP.ViewModelFOV = 47
SWEP.ViewModelFlip = false
SWEP.AnimPrefix	 = "shotgun"

SWEP.ViewTranslation = 4

SWEP.Primary.ClipSize = -1
SWEP.Primary.DefaultClip = -1
SWEP.Primary.Automatic = false
SWEP.Primary.Ammo = ""
SWEP.Primary.Damage = 7.5
SWEP.Primary.Delay = 0.7

SWEP.Secondary.ClipSize = -1
SWEP.Secondary.DefaultClip = 0
SWEP.Secondary.Automatic = false
SWEP.Secondary.Ammo = ""

SWEP.ViewModel = Model("models/weapons/c_arms_animations.mdl")
SWEP.WorldModel = Model("models/pg_props/pg_weapons/pg_cp_shield_w.mdl")

SWEP.UseHands = true
SWEP.LowerAngles = Angle(15, -10, -20)

SWEP.FireWhenLowered = true

function SWEP:Precache()
end

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self:SetDTBool(0, false)

	local wep, realWep
	for k, v in pairs(btShield.shieldList) do
		if (k == self:GetClass()) then
			local info = btShield.shieldInfo[v]
			if (info) then
				self:SetDTInt(0, info.game.health)
			end

			break
		end
	end
end

function SWEP:Deploy()
	local client = self.Owner

	if (IsValid(client)) then
		for k, v in pairs(btShield.shieldList) do
			if (k != self:GetClass()) then
				if (client:HasWeapon(k)) then
					local weapon = client:GetWeapon(k)

					if (IsValid(weapon)) then
						weapon:Remove()
					end
				end
			end
		end
	end
end

function SWEP:PrimaryAttack()
end

function SWEP:OnLowered()
end

function SWEP:Holster(nextWep)
	self:OnLowered()

	return true
end

function SWEP:SecondaryAttack()
	self.Owner:LagCompensation(true)
		local data = {}
			data.start = self.Owner:GetShootPos()
			data.endpos = data.start + self.Owner:GetAimVector()*72
			data.filter = self.Owner
			data.mins = Vector(-8, -8, -30)
			data.maxs = Vector(8, 8, 10)
		local trace = util.TraceHull(data)
		local entity = trace.Entity
	self.Owner:LagCompensation(false)

	if (SERVER and IsValid(entity)) then
		self.Owner:SetAnimation(PLAYER_ATTACK1)
		self.Owner:ViewPunch(Angle(-20, math.random(-15, 15), math.random(-10, 10)))
		local pushed

		if (entity:IsPlayer()) then
			local direction = self.Owner:GetAimVector() * 300
			direction.z = 0

			entity:SetVelocity(direction)

			pushed = true
		else
			local physObj = entity:GetPhysicsObject()

			if (IsValid(physObj)) then
				physObj:SetVelocity(self.Owner:GetAimVector() * 180)
			end

			pushed = true
		end

		if (pushed) then
			self:SetNextSecondaryFire(CurTime() + 1.5)
			self:SetNextPrimaryFire(CurTime() + 1.5)
			self.Owner:EmitSound("weapons/crossbow/hitbod"..math.random(1, 2)..".wav")

			local model = string.lower(self.Owner:GetModel())
			local owner = self.Owner
		end
	end
end

function SWEP:DrawViewModel()
end

function SWEP:DrawWorldModel()
    if (!IsValid(self.Owner)) then
        self:DrawModel()
    end
end
