AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString('Combine_TerminalOpenMenu')

function ENT:Initialize()
	self:SetModel( "models/props_combine/combine_interface003.mdl" )

    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end

	self:SetNetVar('TerminalBreak', false)
	self:SetNetVar('TerminalRepair', 0)

	self:SetUseType( SIMPLE_USE )
end

function ENT:Use(ply)
    if ply:IsCP() and not self:GetNetVar('TerminalBreak') then
        net.Start('Combine_TerminalOpenMenu')
        net.Send(ply)
    end
end
