AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(table.Random(MGS_ROCK_MODELS))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self.Replace = false
	self:SetNWInt("health", MGS_ROCK_HEALTH)
	self:SetNWInt("distance", MGS_DISTANCE)
end

function ENT:Think()
	if (!self.Replace) and (self:GetNWInt("health") <= 0)  then
		local ores = math.Rand(1, MGS_CREATE_ORE)
		for i=1, math.Round(ores) do
			local ore = ents.Create("mgs_ore")
			ore:SetPos(self:GetPos() + Vector(math.Rand(1,20), math.Rand(1,20),20))
			ore:Spawn()
		end
		self.Replace = true
		self.ReplaceTime = CurTime() + MGS_ROCK_REPLACE_TIMER
		self.Pos = self:GetPos()
		self:SetPos(self:GetPos() + Vector(math.Rand(1,20), math.Rand(1,20),20))
    self:SetNWInt("health", MGS_ROCK_HEALTH)
	end;
	
	if (self.Replace) and (self.ReplaceTime < CurTime()) then
		self:SetNWInt("health", MGS_ROCK_HEALTH)
		self.Replace = false
		self:SetPos(self.Pos)
	end
end

function ENT:OnTakeDamage(dmg)
	if table.HasValue(MGS_MINING_TOOLS, dmg:GetInflictor():GetClass()) or table.HasValue(MGS_MINING_TOOLS, dmg:GetAttacker():GetActiveWeapon():GetClass()) and (self:GetNWInt("health") > 0) then
		self:SetNWInt("health", self:GetNWInt("health")-1)
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end
