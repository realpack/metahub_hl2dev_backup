AddCSLuaFile()

SWEP.Base = 'weapon_rp_base'

if SERVER then
	--resource.AddFile('models/code_gs/weapons/c_slap_unfinished.mdl')
	resource.AddFile('models/code_gs/weapons/v_pimpslap.mdl')
	--resource.AddFile('sound/code_gs/pimphand/slap.wav')
else
	SWEP.PrintName		= 'Pimp Hand'
	SWEP.Instructions	= 'Left click to slap\nRight click to cough'
	SWEP.Purpose 		= 'Keep your hoes in check'
	SWEP.SlotPos		= 5
end

SWEP.Spawnable		= true

SWEP.ViewModel		= Model('models/code_gs/pimphand/v_pimpslap.mdl')
SWEP.ViewModelFOV	= 75
SWEP.UseHands 		= false

SWEP.Primary.Sound = Sound('code_gs/pimphand/slap.wav')

local AnimDelay		= .7

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	
	self.Secondary.Sound = {
		Sound('ambient/voices/cough1.wav'),
		Sound('ambient/voices/cough2.wav'),
		Sound('ambient/voices/cough3.wav'),
		Sound('ambient/voices/cough4.wav')
	}
end

function SWEP:Deploy()
	local check = (IsValid(self.Owner) and self.Owner:IsSuperAdmin()) and true or false
	self.Primary.Force = check and 100000 or 400
	self.Primary.Delay = check and AnimDelay or 5
	self.Secondary.Delay = check and AnimDelay or 5
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	
	if timer.Exists("ResetAnim") then timer.Remove("ResetAnim") end
	timer.Create("ResetAnim", AnimDelay, 1, function() if not IsValid(self) then return end self:SendWeaponAnim(ACT_VM_IDLE) end)
	
	if SERVER then
	
		self.Owner:LagCompensation(true)
			local tr = util.TraceHull({
				start = self.Owner:GetShootPos(),
				endpos = self.Owner:GetShootPos() + (self.Owner:GetAimVector() * 40),
				mins = Vector(-8, -8, -8),
				maxs = Vector(8, 8, 8),
				filter = self.Owner
			})
		self.Owner:LagCompensation(false)

		local EmitSound = Sound('Weapon_Knife.Slash')
		self.Owner:AnimRestartGesture(GESTURE_SLOT_ATTACK_AND_RELOAD, ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE)

		if IsFirstTimePredicted() then
			self:SendWeaponAnim(ACT_VM_PRIMARYATTACK_2)
		end

		if tr.Hit then
			local ent = tr.Entity
			local valid = IsValid(ent)
			local player = valid and ent:IsPlayer()
			local phys = valid and ent:GetClass() == 'prop_physics'
			if valid and (player or phys) then
				if player then
					EmitSound = self.Primary.Sound
				else
					EmitSound = Sound('Default.ImpactSoft')
				end

				local pos = tr.StartPos
				local dmginfo = DamageInfo()
					dmginfo:SetDamage(0)
					dmginfo:SetDamagePosition(pos)
					dmginfo:SetDamageType(DMG_CLUB)
					dmginfo:SetInflictor(self)
					dmginfo:SetAttacker(self.Owner)

					local vec = (tr.HitPos - pos):GetNormal()
					local force = self.Primary.Force
					if player then -- SetVelocity is more practical for players
						ent:SetVelocity(vec * force)
					else
						dmginfo:SetDamageForce(vec * force)
					end

				ent:TakeDamageInfo(dmginfo)
			else
				EmitSound = Sound('Default.ImpactSoft')
			end
		end
		
		self.Owner:EmitSound(EmitSound)
	end
	
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)
	if self:GetNextSecondaryFire() >= CurTime() + AnimDelay then return end
	self:SetNextSecondaryFire(CurTime() + AnimDelay)
end

function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) then return end
	
	if timer.Exists("ResetAnim") then timer.Remove("ResetAnim") end
	timer.Create("ResetAnim", AnimDelay, 1, function() if not IsValid(self) then return end self:SendWeaponAnim(ACT_VM_IDLE) end)
	
	if SERVER then
		self:SendWeaponAnim(ACT_VM_RECOIL1)
		self.Owner:EmitSound(self.Secondary.Sound[math.random(1,4)], 100)
	end
	
	self:SetNextSecondaryFire(CurTime() + self.Secondary.Delay)
	if self:GetNextPrimaryFire() >= CurTime() + AnimDelay then return end
	self:SetNextPrimaryFire(CurTime() + AnimDelay)
end