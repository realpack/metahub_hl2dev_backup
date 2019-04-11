AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function SWEP:PrimaryAttack()
	-- print(self.Owner)
	local player = self.Owner
	local trace = player:GetEyeTrace()

	local target = trace.Entity

	local bool = not target.IsHandcuffed
	if bool and target.GetPlayerHandcuffed then return end

	if target and IsValid(target) and target:IsPlayer() and not target.IsHandcuffed then
		if target:GetPos():DistToSqr(player:GetPos()) < 13000 then
			target:ProgressCuffed(true,player)
		end
	end

	self:SetNextPrimaryFire(CurTime()+1)

	return
end

function SWEP:SecondaryAttack()
	local player = self.Owner
	local trace = player:GetEyeTrace()

	local target = trace.Entity

	if target.GetPlayerHandcuffed and target.GetPlayerHandcuffed ~= player and target.GetPlayerHandcuffed:GetClass() == 'handcuffs_point' then return end

	if target and IsValid(target) and target:IsPlayer() then
		target:ProgressCuffed(false, target.GetPlayerHandcuffed)
	end

	return
end
