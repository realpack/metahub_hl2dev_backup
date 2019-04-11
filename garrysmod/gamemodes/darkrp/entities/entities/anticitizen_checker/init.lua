AddCSLuaFile( "cl_init.lua" ) -- Make sure clientside
AddCSLuaFile( "shared.lua" )  -- and shared scripts are sent.

include('shared.lua')

function ENT:Initialize()
	self:SetModel('models/maxofs2d/cube_tool.mdl')

	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )

	-- Wake the physics object up
	local phys = self.Entity:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:EnableMotion( false )
		phys:Wake()
	end
end

function ENT:Think()
	for _, ply in pairs(ents.FindInSphere(self:GetPos(), 300)) do
		if ply and IsValid(ply) and ply:IsPlayer() and (ply:Team() == TEAM_CITIZEN or ply:Team() == TEAM_CITIZEN24) then
			local pos, ang = ply:GetPos(), ply:EyeAngles()
            local health, armor = ply:Health(), ply:Armor()

			ply:SetTeam(TEAM_ANTICITIZEN)
			ply:Spawn()

			ply:SetPos(pos)
			ply:SetEyeAngles(ang)
			ply:SetBodygroup(1, 1)

            ply:SetHealth(health)
            ply:SetArmor(armor)

			meta.util.Notify('red', ply, 'Вы находитесь на територии повстанческого движения, теперь вы анти гражданин.')
		end
	end
end
