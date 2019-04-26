AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")
include("shared.lua")

function ENT:Initialize()
	self:SetModel('models/squad/sf_bars/sf_bar25x25x1.mdl')

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
end

function ENT:Use(activator, caller)
	if not (activator and IsValid(activator)) then return end
    if activator.IsHandcuffed then
        return
    end

	-- print(self,self:GetNVar('GetPlayerKidnapper'))

	self:GetNWEntity('GetPlayerKidnapper'):SetHandcuffed(true,activator)
	self:Remove()
end
