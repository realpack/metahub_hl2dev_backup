AddCSLuaFile()
DEFINE_BASECLASS( "trash_base" )

ENT.Spawnable = false

function ENT:Initialize()
    self:SetModel("models/props_c17/FurnitureDrawer001a_Chunk03.mdl")

	if not SERVER then return end
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
