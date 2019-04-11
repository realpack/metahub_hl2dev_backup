AddCSLuaFile()

DEFINE_BASECLASS('baton_base')

if CLIENT then
	SWEP.PrintName = 'Arrest Baton'
	SWEP.SlotPos = 4
	SWEP.Instructions = 'Left click to arrest\nRight click to switch to unarrest'
end

SWEP.Color = Color(255, 0, 0, 255)

function SWEP:PrimaryAttack()
	if not IsValid(self.Owner) then return end
	
	BaseClass.PrimaryAttack(self)
	
	if CLIENT then return end

	self.Owner:LagCompensation(true)
		local ent = self.Owner:GetEyeTrace().Entity
	self.Owner:LagCompensation(false)
	
	if not IsValid(ent) or (self.Owner:GetPos():Distance(ent:GetPos()) > self.HitDistance) then return end
	
	if ent.SeizeReward and ent.WantReason and self.Owner:IsCP() then
		local owner = ent.ItemOwner
		if IsValid(owner) and not ent.ItemOwner:IsWanted() then 
			ent.ItemOwner:Wanted(self.Owner, ent.WantReason) 
		end
		ent:Remove()
		self.Owner:AddMoney(ent.SeizeReward)
		rp.Notify(self.Owner, NOTIFY_GREEN, rp.Term('ArrestBatonBonus'), rp.FormatMoney(ent.SeizeReward))
		return
	end

	if not ent:IsPlayer() or not ent:IsWanted() then
		return
	end

	timer.Simple(0, function()
		if IsValid(self) then
			ent:Arrest(self.Owner)
		end
	end)
	
	rp.Notify(ent, NOTIFY_ERROR, rp.Term('ArrestBatonArrested'), self.Owner)
	self.Owner:AddKarma(2)
	rp.Notify(self.Owner, NOTIFY_GREEN, rp.Term('ArrestBatonYouArrested'), ent)
end

function SWEP:SecondaryAttack()
	if not IsValid(self.Owner) then return end
	
	if SERVER and self.Owner:HasWeapon('unarrest_baton') then
		self.Owner:SelectWeapon('unarrest_baton')
	end
	
	self:SetNextSecondaryFire(CurTime() + self.Primary.Delay)
end