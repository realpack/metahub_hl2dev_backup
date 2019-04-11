AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

local CAMERA_MODEL = "models/dav0r/camera.mdl"

/*---------------------------------------------------------
   Name: Initialize
---------------------------------------------------------*/
function ENT:Initialize()
	self:SetModel( CAMERA_MODEL )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:DrawShadow( false )
	
	// Don't collide with the player
	self:SetCollisionGroup( COLLISION_GROUP_WEAPON )
	
	local phys = self:GetPhysicsObject()
	
	if (phys:IsValid()) then
		phys:Sleep()
	end
end

function ENT:SetTracking( Ent, LPos )
	if ( Ent:IsValid() ) then
		self:SetMoveType( MOVETYPE_NONE )
		self:SetSolid( SOLID_BBOX )
	else
		self:SetMoveType( MOVETYPE_VPHYSICS )
		self:SetSolid( SOLID_VPHYSICS )
	end
	
	self:NextThink( CurTime() )
	
	self.dt.vecTrack = LPos;
	self.dt.entTrack = Ent
end

function ENT:SetLocked( locked )
	if ( locked == 1 ) then
		self.PhysgunDisabled = true
		
		local phys = self:GetPhysicsObject()
		if ( phys:IsValid() ) then
			phys:EnableMotion( false )
		end
	else
		self.PhysgunDisabled = false
	end
	
	self.locked = locked
end

/*---------------------------------------------------------
   Name: OnTakeDamage
---------------------------------------------------------*/
function ENT:OnTakeDamage( dmginfo )
	self:TakePhysicsDamage( dmginfo )
end

/*---------------------------------------------------------
   Name: OnRemove
---------------------------------------------------------*/
function ENT:OnRemove()
	// Pick a random camera to use if this one gets removed
	if ( RenderTargetCameraProp != self.Entity ) then return end

	local Cameras = ents.FindByClass( "gmod_rtcameraprop" )
	if ( #Cameras == 0 ) then return end
	local CameraIdx = math.random( #Cameras )

	if ( CameraIdx == self.Entity ) then
		if ( #Cameras != 0 ) then return end
		self:OnRemove()
	end

	local Camera = Cameras[ CameraIdx ]
	UpdateRenderTarget( Camera )
end

/*---------------------------------------------------------
   Numpad control functions
   These are layed out like this so it'll all get saved properly
---------------------------------------------------------*/
local function RTCamera_Use( pl, ent )
	if (!ent:IsValid()) then return false end

	UpdateRenderTarget( ent )

	return true
end

// register numpad functions
numpad.Register( "RTCamera_Use", RTCamera_Use )