AddCSLuaFile()

DEFINE_BASECLASS('baton_base')

if CLIENT then
	SWEP.PrintName = 'Unarrest Baton'
	SWEP.SlotPos = 5
	SWEP.Instructions = 'Left click to unarrest\nRight click to switch to arrest'
end

SWEP.Color = Color(0, 255, 0, 255)

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
	self._Reload.Sound = Sound('npc/combine_soldier/vo/coverme.wav')
end

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	
	BaseClass.PrimaryAttack(self)
	
	if CLIENT then return end

	self.Owner:LagCompensation(true)
		local ent = self.Owner:GetEyeTrace().Entity
	self.Owner:LagCompensation(false)
	
	if (not IsValid(ent)) or (not ent:IsPlayer()) or (self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance) or (not ent:IsArrested()) then
		return
	end

	ent:UnArrest(self.Owner)
	rp.Notify(ent, NOTIFY_GREEN, rp.Term('UnarrestBatonTarg'), self.Owner)
	rp.Notify(self.Owner, NOTIFY_GREEN, rp.Term('UnarrestBatonOwn'), ent)
end


function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) then return end
	
	if SERVER and self.Owner:HasWeapon('arrest_baton') then
		self.Owner:SelectWeapon('arrest_baton')
	end
	
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end
