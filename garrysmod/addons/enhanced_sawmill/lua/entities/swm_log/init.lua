AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_docks/channelmarker_gib01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetNWInt("wood", 1)
	self.Touched = false
	self.RemovingTime = CurTime() + SWM_LOG_REMOVE_TIME
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end

function ENT:Think()
	if !self.Touched and self.RemovingTime <= CurTime() then
		self:Remove()
	end
end
