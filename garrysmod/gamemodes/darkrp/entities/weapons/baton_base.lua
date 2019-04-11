AddCSLuaFile()

SWEP.Base = 'weapon_rp_base'

if CLIENT then
	SWEP.PrintName = 'Baton Base'
	SWEP.Slot = 1
	SWEP.SlotPos = 3
	SWEP.DrawCrosshair = true
end

SWEP.Color = Color(255, 255, 255, 255)

SWEP.ViewModel = Model('models/weapons/v_stunbaton.mdl')
SWEP.WorldModel = Model('models/weapons/w_stunbaton.mdl')

SWEP.Primary.Sound = Sound('Weapon_StunStick.Swing')

SWEP.UseHands = false

SWEP.HitDistance = 100

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self._Reload.Sound = Sound('npc/metropolice/vo/administer.wav')
end

function SWEP:Deploy()
	if not IsValid(self.Owner) then return false end

	-- self:SetColor(self.Color)
	-- self:SetMaterial('models/shiny')

	-- local vm = self.Owner:GetViewModel()
	-- if IsValid(vm) then
	-- 	vm:SetColor(self.Color)
	-- 	vm:SetMaterial('models/shiny')
	-- 	vm:SendViewModelMatchingSequence(vm:LookupSequence('idle01'))
	-- end

	return true
end

function SWEP:PrimaryAttack()
	self:SetNextPrimaryFire(CurTime() + self.Primary.Delay)

	self:SetHoldType('melee')

	timer.Simple(0.3, function()
		if IsValid(self) then
			self:SetHoldType('normal')
			local vm = self.Owner:GetViewModel()
			if IsValid(vm) then
				vm:SendViewModelMatchingSequence(vm:LookupSequence('idle01'))
			end
		end
	end)

	self.Owner:SetAnimation(PLAYER_ATTACK1)
	self.Weapon:EmitSound(self.Primary.Sound)
	self.Weapon:SendWeaponAnim(ACT_VM_HITCENTER)
end

function SWEP:Reload()
	if not IsValid(self.Owner) or not self:CanReload() then return end

	self:SetNextReload(CurTime() + self._Reload.Delay)

	self:SetHoldType('melee')

	timer.Simple(1, function()
		if not IsValid(self) then return end
		self:SetHoldType('normal')
	end)

	if not SERVER then return end
	self.Owner:EmitSound(self._Reload.Sound)
end

function SWEP:OnRemove(wep)
	if not IsValid(self.Owner) then return true end

	if IsValid(wep) and string.find(wep:GetClass(), "baton", 0, true) then return true end

	self:SetColor(Color(255, 255, 255, 255))
	self:SetMaterial('')

	local vm = self.Owner:GetViewModel()
	if IsValid(vm) then
		vm:SetColor(Color(255, 255, 255, 255))
		vm:SetMaterial('')
	end
end

function SWEP:Holster(wep)
	self:OnRemove(wep)
	return true
end
