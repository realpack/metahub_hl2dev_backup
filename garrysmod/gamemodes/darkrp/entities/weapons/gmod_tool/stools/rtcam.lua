TOOL.Category		= "Render"
TOOL.Name			= "#tool.rtcam.name"
TOOL.Command		= nil
TOOL.ConfigName		= nil

TOOL.ClientConVar[ "locked" ] 	= "0"
TOOL.ClientConVar[ "key" ] 		= "0"

if CLIENT then
	language.Add("tool.rtcam.name", "RT Camera")
	language.Add("tool.rtcam.desc", "Place a camera")
	language.Add("tool.rtcam.0", "Left click to place a camera, Right click to place a camera that looks at you")
	language.Add("tool.rtcam.draw", "Show monitor on HUD")
	language.Add("tool.rtcam.key", "Camera key")
	language.Add("tool.rtcam.locked", "Static Camera")
end


cleanup.Register( "cameras" )

GAMEMODE.RTCameraList = GAMEMODE.RTCameraList or {}

TOOL.LeftClickAutomatic = false
TOOL.RightClickAutomatic = false
TOOL.RequiresTraceHit = false

-- Global to hold the render target camera entity
RenderTargetCamera = nil
RenderTargetCameraProp = nil

function TOOL:LeftClick( trace )
	if CLIENT then return end
	
	local key = self:GetClientNumber( "key" )
	if (key == -1) then return false end
	
	local ply = self:GetOwner()
	local locked = self:GetClientNumber( "locked" )
	local pid = ply:UniqueID()

	GAMEMODE.RTCameraList[ pid ] = GAMEMODE.RTCameraList[ pid ] or {}
	local CameraList = GAMEMODE.RTCameraList[ pid ]
	
	local Pos = trace.StartPos -- + trace.Normal * 16
	
	-- If the camera already exists then just move it into position
	if (CameraList[ key ] and CameraList[ key ] != NULL ) then
		local ent = CameraList[ key ]
		
		-- Remove all constraints
		constraint.RemoveAll( ent )
	
		ent:SetPos( Pos )
		ent:SetAngles( ply:EyeAngles() )
		
		local phys = ent:GetPhysicsObject()
		if (phys:IsValid()) then phys:Sleep() end
		
		ent:SetLocked( locked )
		ent:SetTracking( NULL,Vector(0))

		if !RenderTargetCamera then UpdateRenderTarget( camera ) end

		return false, ent
	end
	
	local camera = ents.Create( "gmod_rtcameraprop" )
	
	if (!camera:IsValid()) then return false end
		
	camera:SetAngles( ply:EyeAngles() )
	camera:SetPos( Pos )
	camera:Spawn()
	
	camera:SetKey( key )
	camera:SetPlayer( ply )
	camera:SetLocked( locked )

	numpad.OnDown( ply, key, "RTCamera_Use", camera )
	
	camera:SetTracking( NULL, Vector(0) )
	
	undo.Create("RT Camera")
		undo.AddEntity( camera )
		undo.SetPlayer( ply )
	undo.Finish()
	
	ply:AddCleanup( "cameras", camera )
	
	CameraList[ key ] = camera

	if !RenderTargetCamera || #ents.FindByClass( "gmod_rtcameraprop" ) == 1 then UpdateRenderTarget( camera ) end
	
	return false, camera
end

-- Global Function to update the render target
function UpdateRenderTarget( ent )
	if ( !ent || !ent:IsValid() ) then return end

	if ( !RenderTargetCamera || !RenderTargetCamera:IsValid() ) then
	
		RenderTargetCamera = ents.Create( "point_camera" )
		RenderTargetCamera:SetKeyValue( "GlobalOverride", 1 )
		RenderTargetCamera:Spawn()
		RenderTargetCamera:Activate()
		RenderTargetCamera:Fire( "SetOn", "", 0.0 )

	end
	Pos = ent:LocalToWorld( Vector( 12,0,0 ) )
	RenderTargetCamera:SetPos(Pos)
	RenderTargetCamera:SetAngles(ent:GetAngles())
	RenderTargetCamera:SetParent(ent)

	RenderTargetCameraProp = ent
end

function TOOL:RightClick( trace )
	_, camera = self:LeftClick( trace )
	
	if CLIENT then return false end

	if ( !camera || !camera:IsValid() ) then return end
	
	if ( trace.Entity:IsWorld() ) then
		trace.Entity = self:GetOwner()
		trace.HitPos = self:GetOwner():GetPos()
	end

	camera:SetTracking( trace.Entity, trace.Entity:WorldToLocal( trace.HitPos ))
	
	return false
end

if CLIENT then
	local rtcam_draw = CreateClientConVar( "rtcam_draw", "0", false, false )
	local RTWindow = nil
	local rtTexture = surface.GetTextureID( "pp/rt" )
	local rtSize = { 
		x = 25, 
		y = 25, 
		w = ScrW() * 0.25, 
		h = ScrW() * 0.25
	}

	local function OpenRTWindow( player, command, arguments )
		LocalPlayer():ConCommand( "rtcam_draw 1" )
		
		if (RTWindow) then
			RTWindow:SetVisible( true )
		return end
		
		RTWindow = vgui.Create( "DFrame" )
		RTWindow:SetTitle( "Render Target" )
		RTWindow:SetPos( rtSize.x, rtSize.y )
		RTWindow:SetSize( rtSize.w, rtSize.h )
		RTWindow:SetBackgroundBlur( true )
		RTWindow:SetDeleteOnClose( false )
		RTWindow:SetScreenLock( true )
		RTWindow:SetSizable( true )
		RTWindow:SetVisible( true )
		RTWindow:MakePopup()
	end
	concommand.Add( "rtcam_window", OpenRTWindow )

	local function DrawRTTexture()
		if rtcam_draw:GetBool() == false then
			if (RTWindow and RTWindow:IsVisible()) then
				RTWindow:SetVisible( false )
			end
			return
		end

		if RTWindow and RTWindow:IsVisible() then
			-- grab pos and size from window
			rtSize.x, rtSize.y = RTWindow:GetPos()
			rtSize.w, rtSize.h = RTWindow:GetSize()
		else
			-- draw render target
			surface.SetTexture( rtTexture )
			surface.SetDrawColor( 255, 255, 255, 255 )
			surface.DrawTexturedRect( rtSize.x , rtSize.y, rtSize.w, rtSize.h )
			-- draw border
			surface.SetDrawColor( 0, 0, 0, 220 )
			surface.DrawOutlinedRect( rtSize.x - 1 , rtSize.y - 1, rtSize.w + 2, rtSize.h + 2 )
		end
	end
	hook.Add( "HUDPaint", "DrawRTTexture", DrawRTTexture )

	function TOOL:DrawToolScreen( w, h )
		surface.SetTexture( rtTexture )
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.DrawTexturedRect( 0, 26, w, h - 48 ) 
	end
end

function TOOL.BuildCPanel( panel )
	panel:AddControl( "Checkbox", { 
		Label = "#tool.rtcam.draw", 
		Command = "rtcam_draw"
	} )
	panel:AddControl( "Button", {
		Label = "Place RT Monitor", 
		Command = "rtcam_window"
	} )
	panel:AddControl("Numpad", {
		Label = "#tool.rtcam.key",
		Command = "rtcam_key",
		ButtonSize = "22"
	} )
	panel:AddControl( "Checkbox", { 
		Label = "#tool.rtcam.locked", 
		Command = "rtcam_locked"
	} )
end