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

	self:SetUseType( SIMPLE_USE )
  self:SetNetVar('Control_Capture',0)
end

function ENT:Use(pl)
  if table.HasValue(capture.TeamCP, pl:Team()) or table.HasValue(capture.TeamRabel, pl:Team()) then
    capture.StartCapture(pl, self:GetId())
  end
end
