AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel('models/props_combine/combine_interface002.mdl')

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	self:SetUseType( SIMPLE_USE )

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end

    self:SetCustomCollisionCheck( true )
end

function ENT:Use(activator, caller)
	-- if not (activator and IsValid(activator)) then return end

    -- local kid = self:GetNVar('GetPlayerKidnapper')
    -- if kid then
	--     kid:SetHandcuffed(true,activator)
    -- end
	-- self:Remove()
end
