local cl_drawcameras = CreateConVar( "cl_drawcameras", "1" )

include('shared.lua')

ENT.Spawnable			= false
ENT.AdminSpawnable		= false

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self.ShouldDrawInfo 	= false
end

/*---------------------------------------------------------
   Name: Draw
---------------------------------------------------------*/
function ENT:Draw()
	if ( cl_drawcameras:GetBool() == 0 ) then return end

	// Don't draw the camera if we're taking pics
	local ply = LocalPlayer()
	local wep = ply:GetActiveWeapon()
	if ( wep:IsValid() ) then 
		local weapon_name = wep:GetClass()
		if ( weapon_name == "gmod_camera" ) then return end
	end

	self:DrawModel()
end

/*---------------------------------------------------------
   Name: Think
   Desc: Client Think - called every frame
---------------------------------------------------------*/
function ENT:Think()
	self:TrackEntity( self.dt.entTrack, self.dt.vecTrack )
end