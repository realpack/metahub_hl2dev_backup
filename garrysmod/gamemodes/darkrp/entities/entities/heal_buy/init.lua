AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    self:SetModel("models/healthvial.mdl")

    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( true )
		phys:Wake()
	end

	self:SetUseType( SIMPLE_USE )
end

function ENT:Use(activator,caller)
    local hp = activator:Health()
    local max_hp = rp.teams[activator:Team()].health or 100
    hp = hp+30 > max_hp and max_hp or hp+30

	activator:SetHealth(hp)
    self:Remove()
end
