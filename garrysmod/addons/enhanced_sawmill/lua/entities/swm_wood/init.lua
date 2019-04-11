AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel(table.Random(SWM_TREE_MODELS))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	self.Replace = false
	phys:Wake()
	self:SetNWInt("health", SWM_TREE_HEALTH)
	self:SetNWInt("distance", SWM_DISTANCE);
end

function ENT:Think()
	if (!self.Replace) and (self:GetNWInt("health") <= 0)  then
		self.Replace = true
		self.ReplaceTime = CurTime() + SWM_TREE_REPLACE_TIMER
		self:SetMaterial("Models/effects/vol_light001");
		self:SetCollisionGroup(10)
		self.Pos = self:GetPos()
		
		local log = ents.Create('swm_log')
		log:SetPos(self:GetPos()+Vector(0,0,30))
		log:Spawn()
		local log2 = ents.Create('swm_log')
		log2:SetPos(self:GetPos()+Vector(0,0,87))
		log2:Spawn()
		constraint.Weld(log, log2, 0, 0, 500, true, false)
		
		self:SetPos(self.Pos + Vector(0,0,-300))
	end;
	
	if (self.Replace) and (self.ReplaceTime < CurTime()) then
		self:SetNWInt("health", SWM_TREE_HEALTH)
		self.Replace = false
		self:SetMaterial();
		self:SetCollisionGroup(0)
		self:SetPos(self.Pos)
	end
end

function ENT:OnTakeDamage(dmg)
	if table.HasValue(SWM_CUTTING_TOOLS, dmg:GetInflictor():GetClass()) or table.HasValue(SWM_CUTTING_TOOLS, dmg:GetAttacker():GetActiveWeapon():GetClass()) then
		self:SetNWInt("health", self:GetNWInt("health")-1)
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end
