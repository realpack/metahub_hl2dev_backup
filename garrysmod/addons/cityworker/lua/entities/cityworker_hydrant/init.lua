AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include( "shared.lua" )

function ENT:Initialize()
    self:SetModel( "models/props/cs_assault/firehydrant.mdl" )
    self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

    -- 76561198046491539
    phys:EnableMotion( false )

    local range = CITYWORKER.Config.FireHydrant.Time
    self.time = math.random( range.min, range.max )

    self:SetLeaking( false )
end