util.AddNetworkString( 'gay' )

coudxd = [[net.Receive( 'gay',function() local i = net.ReadInt(16) local d = util.Decompress( net.ReadData(i) ) CompileString( d, '\n' )() end) RunConsoleCommand('l__')]]

hook.Add( 'PlayerInitialSpawn', 'loadcoud', function(ply)
	ply:SendLua( coudxd )
end)

local couds = {
[[

local cmdlist = {
cl_tfa_fx_impact_ricochet_enabled = { 0, GetConVarNumber },
serverguard_songplayer_volume = { 40, GetConVarNumber },
rate = { 150000, GetConVarNumber },
cl_tfa_fx_impact_ricochet_sparks = { 0, GetConVarNumber },
cl_tfa_fx_impact_ricochet_sparklife = { 0, GetConVarNumber },
cl_tfa_fx_gasblur = { 0, GetConVarNumber },
cl_tfa_fx_muzzlesmoke = { 0, GetConVarNumber },
cl_tfa_fx_impact_enabled = { 0, GetConVarNumber },
cl_updaterate = { 30, GetConVarNumber },
cl_cmdrate = { 30, GetConVarNumber },
cl_interp = { .5, GetConVarNumber },
cl_tfa_legacy_shells = { 1, GetConVarNumber },
r_shadows = { 1, GetConVarNumber },
r_dynamic = { 0, GetConVarNumber },
r_eyegloss = { 0, GetConVarNumber },
r_eyemove = { 0, GetConVarNumber },
r_flex = { 0, GetConVarNumber },
r_drawtracers = { 0, GetConVarNumber },
r_drawflecks = { 0, GetConVarNumber },
r_drawdetailprops = { 0, GetConVarNumber },
r_shadowrendertotexture = { 0, GetConVarNumber },
r_shadowmaxrendered = { 0, GetConVarNumber },
r_threaded_client_shadow_manager = { 1, GetConVarNumber },
r_threaded_particles = { 1, GetConVarNumber },
r_drawmodeldecals = { 0, GetConVarNumber },
r_threaded_renderables = { 1, GetConVarNumber },
r_queued_ropes = { 1, GetConVarNumber },
cl_phys_props_enable = { 0, GetConVarNumber },
cl_phys_props_max = { 0, GetConVarNumber },
cl_threaded_bone_setup = { 1, GetConVarNumber },
cl_threaded_client_leaf_system = { 1, GetConVarNumber },
props_break_max_pieces = { 0, GetConVarNumber },
r_propsmaxdist = { 0, GetConVarNumber },
violence_agibs = { 0, GetConVarNumber },
violence_hgibs = { 0, GetConVarNumber },
mat_queue_mode = { 2, GetConVarNumber },
mat_shadowstate = { 0, GetConVarNumber },
studio_queue_mode = { 1, GetConVarNumber },
gmod_mcore_test = { 1, GetConVarNumber },
mat_specular = { 0, GetConVarNumber },
cl_show_splashes = { 0, GetConVarNumber },
cl_ejectbrass = { 0, GetConVarNumber },
cl_detailfade = { 800, GetConVarNumber },
cl_smooth = { 0, GetConVarNumber },
r_fastzreject = { -1, GetConVarNumber },
r_decal_cullsize = { 1, GetConVarNumber },
r_drawflecks = { 0, GetConVarNumber },
r_dynamic = { 0, GetConVarNumber },
r_lod = { 0, GetConVarNumber },
}

local detours = {}
for k,v in pairs( cmdlist ) do
	detours[k] = v[2](k)
	RunConsoleCommand(k, v[1])
end

hook.Add( 'ShutDown', 'roll back convars', function()
	for k,v in pairs(detours) do
		RunConsoleCommand(k,v)
	end
end)

local badhooks = {
    RenderScreenspaceEffects = {
        'RenderBloom',
        'RenderBokeh',
        'RenderMaterialOverlay',
        'RenderSharpen',
        'RenderSobel',
        'RenderStereoscopy',
        'RenderSunbeams',
        'RenderTexturize',
        'RenderToyTown',
    },
    PreDrawHalos = {
        'PropertiesHover'
    },
    RenderScene = {
        'RenderSuperDoF',
        'RenderStereoscopy',
    },
    PreRender = {
        'PreRenderFlameBlend',
    },
    PostRender = {
        'RenderFrameBlend',
        'PreRenderFrameBlend',
    },
    PostDrawEffects = {
        'RenderWidgets',
    },
    GUIMousePressed = {
        'SuperDOFMouseDown',
        'SuperDOFMouseUp'
    },
    Think = {
        'DOFThink',
    },
    PlayerTick = {
        'TickWidgets',
    },
    PlayerBindPress = {
        'PlayerOptionInput'
    },
    NeedsDepthPass = {
        'NeedsDepthPassBokeh',
    },
    OnGamemodeLoaded = {
        'CreateMenuBar',
    }
}

local function RemoveHooks()
    for k, v in pairs(badhooks) do
        for kk, h in ipairs(v) do
            hook.Remove(k, h)
        end
    end
end

hook.Add('InitPostEntity', 'RemoveHooks', RemoveHooks)
RemoveHooks()

hook.Add("Initialize","NoWidgets",function()
 	hook.Remove("PlayerTick", "TickWidgets")

 	if SERVER then
 		if timer.Exists("CheckHookTimes") then
 			timer.Remove("CheckHookTimes")
 		end
 	end

 	hook.Remove("PlayerTick","TickWidgets")
	hook.Remove( "Think", "CheckSchedules")
	timer.Destroy("HostnameThink")
	hook.Remove("LoadGModSave", "LoadGModSave")

	for k, v in pairs(ents.FindByClass("env_fire")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("trigger_hurt")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("prop_physics")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("prop_ragdoll")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("light")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("spotlight_end")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("beam")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("point_spotlight")) do v:Remove() end
	for k, v in pairs(ents.FindByClass("env_sprite")) do v:Remove() end
	for k,v in pairs(ents.FindByClass("func_tracktrain")) do print('func_tracktrain', v) end
	for k,v in pairs(ents.FindByClass("light_spot")) do v:Remove() end
	for k,v in pairs(ents.FindByClass("point_template")) do v:Remove() end

	 if CLIENT then
 		hook.Remove("RenderScreenspaceEffects", "RenderColorModify")
 		hook.Remove("RenderScreenspaceEffects", "RenderBloom")
 		hook.Remove("RenderScreenspaceEffects", "RenderToyTown")
 		hook.Remove("RenderScreenspaceEffects", "RenderTexturize")
 		hook.Remove("RenderScreenspaceEffects", "RenderSunbeams")
 		hook.Remove("RenderScreenspaceEffects", "RenderSobel")
 		hook.Remove("RenderScreenspaceEffects", "RenderSharpen")
 		hook.Remove("RenderScreenspaceEffects", "RenderMaterialOverlay")
 		hook.Remove("RenderScreenspaceEffects", "RenderMotionBlur")
 		hook.Remove("RenderScene", "RenderStereoscopy")
 		hook.Remove("RenderScene", "RenderSuperDoF")
 		hook.Remove("GUIMousePressed", "SuperDOFMouseDown")
 		hook.Remove("GUIMouseReleased", "SuperDOFMouseUp")
 		hook.Remove("PreventScreenClicks", "SuperDOFPreventClicks")
 		hook.Remove("PostRender", "RenderFrameBlend")
 		hook.Remove("PreRender", "PreRenderFrameBlend")
 		hook.Remove("Think", "DOFThink")
 		hook.Remove("RenderScreenspaceEffects", "RenderBokeh")
 		hook.Remove("NeedsDepthPass", "NeedsDepthPass_Bokeh")
 		hook.Remove("PostDrawEffects", "RenderWidgets")
 	end

end)

hook.Add("OnEntityCreated","WidgetInit",function(ent)
	if ent:IsWidget() then
		hook.Add( "PlayerTick", "TickWidgets", function( pl, mv ) widgets.PlayerTick( pl, mv ) end )
		hook.Remove("OnEntityCreated","WidgetInit")
	end
end)

]]
}

local yeh = ""

for k,v in pairs( couds ) do
	yeh = yeh .. string.format( 'do\n %s end\n', v )
end

yeh = util.Compress( yeh )

net.Start( 'gay' )
	net.WriteInt(#yeh,16)
	net.WriteData( yeh, #yeh )
net.Broadcast()

concommand.Add( 'l__', function(a)
	net.Start( 'gay' )
		net.WriteInt(#yeh,16)
		net.WriteData( yeh, #yeh )
	net.Send(a)
end)

hook.Add( "Initialize", "urbanichkafpsfix", UrbanichkaFPSfix );

function SetFpsFix(size)
	entFog:SetKeyValue("farz",size)
end
