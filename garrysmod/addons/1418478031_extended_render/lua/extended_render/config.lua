if CLIENT then
	
	CreateClientConVar( "r_extended_enable", 						1, 		true, true )
	CreateClientConVar( "r_extended_update_enable", 				1, 		true, true )
	CreateClientConVar( "r_extended_update_interval", 				0.2, 	true, true )
	CreateClientConVar( "r_extended_limit", 						200, 	true, true )
	CreateClientConVar( "r_extended_sun_lensflare", 				1, 		true, true )
	CreateClientConVar( "r_extended_brightness", 					1, 		true, true )
	CreateClientConVar( "r_extended_glow", 							1, 		true, true )
	CreateClientConVar( "r_extended_trail", 						1, 		true, true )
	CreateClientConVar( "r_extended_light_entities", 				1, 		true, true )
	CreateClientConVar( "r_extended_light_weapons", 				1, 		true, true )
	CreateClientConVar( "r_extended_motion_blur_multiplier", 		5.0, 	true, true )
	
	concommand.Add( "r_extended_reset", function( ply, cmd, args )
		ExtendedRender:Initialization()
		
		for i, ent in pairs( ents.GetAll() ) do
			ExtendedRender.Parts:Setup( ent )
		end
	end )
	
	language.Add( "extended_render", "Extended" )
	language.Add( "extended_render.render", "Render" )
	language.Add( "extended_render.sounds", "Sounds" )
	language.Add( "extended_render.entities", "Draw Entites" )
	language.Add( "extended_render.decals", "Draw Decals" )
	language.Add( "extended_render.particles", "Draw Particles" )
	language.Add( "extended_render.ropes", "Draw Ropes" )
	language.Add( "extended_render.displacement_maps", "Draw Displacement Maps" )
	language.Add( "extended_render.fog", "Disable Fog" )
	language.Add( "extended_render.3dskybox", "Draw 3D Skybox" )
	language.Add( "extended_render.skybox", "Draw Skybox" )
	language.Add( "extended_render.water", "Draw Water" )
	language.Add( "extended_render.color_correction", "Draw Map Color Correction" )
	language.Add( "extended_render.beams", "Draw Light Beams" )
	language.Add( "extended_render.specular", "Draw Specular" )
	language.Add( "extended_render.bumpmap", "Draw Bumpmap" )
	language.Add( "extended_render.brightness", "Draw Soft Brightness" )
	language.Add( "extended_render.sunflare", "Draw Sun Lens Flare" )
	language.Add( "extended_render.weapons_light", "Draw Weapons Light" )
	language.Add( "extended_render.entities_light", "Draw Entities Light" )
	language.Add( "extended_render.glow", "Draw Glow" )
	language.Add( "extended_render.trail", "Draw Glow Trail" )
	language.Add( "extended_render.fullbright", "Lighting Mode" )
	language.Add( "extended_render.lod", "LOD" )
	language.Add( "extended_render.projected_shadows_filter", "Projected Shadows Filter" )
	language.Add( "extended_render.flash_light_fov", "Flash Light FOV" )
	language.Add( "extended_render.motion_blur", "Motion Blur" )
	
	hook.Add("PopulateToolMenu", "ExtendedRender_Main_Utilities", function()		
		spawnmenu.AddToolMenuOption("Utilities", "User", "extended_render_options", "Render", "", "", function( panel )
			panel:SetName("Render")
			panel:AddControl("Header", {
				Text = "",
				Description = "Configuration menu for client drawing."
			})

			panel:AddControl("ComboBox", {
				MenuButton = 1,
				Folder = "ExtendedRender",
				Options = {
					[ "#preset.default" ] = {
						r_lod = "0",
						mat_fullbright = "0",
						r_drawentities = "1",
						r_drawparticles = "1",
						r_drawropes = "1",
						r_drawdecals = "1",
						r_drawdisp = "1",
						r_3dsky = "1",
						r_drawskybox = "1",
						r_DrawBeams = "1",
						r_flashlightfov = "60",
						r_projectedtexture_filter = "-1",
						fog_override = "0",
						mat_drawwater = "1",
						mat_colorcorrection = "1",
						mat_specular = "1",
						mat_bumpmap = "1",
						r_extended_sun_lensflare = "1",
						r_extended_brightness = "1",
						r_extended_glow = "1",
						r_extended_trail = "1",
						r_extended_light_entities = "1",
						r_extended_light_weapons = "1",
						r_extended_motion_blur_multiplier = "5.0"
					}
				},
				CVars = {}
			})

			panel:AddControl("Checkbox", {
				Label = "#extended_render.entities",
				Command = "r_drawentities"
			})

			panel:AddControl("Checkbox", {
				Label = "#extended_render.decals",
				Command = "r_drawdecals"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.particles",
				Command = "r_drawparticles"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.ropes",
				Command = "r_drawropes"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.displacement_maps",
				Command = "r_drawdisp"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.fog",
				Command = "fog_override"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.3dskybox",
				Command = "r_3dsky"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.skybox",
				Command = "r_drawskybox"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.water",
				Command = "mat_drawwater"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.color_correction",
				Command = "mat_colorcorrection"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.beams",
				Command = "r_DrawBeams"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.specular",
				Command = "mat_specular"
			})
			
			panel:ControlHelp("Changing this parameter will cause game freeze")
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.bumpmap",
				Command = "mat_bumpmap"
			})
			
			panel:ControlHelp("Changing this parameter will cause game freeze")
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.sunflare",
				Command = "r_extended_sun_lensflare"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.brightness",
				Command = "r_extended_brightness"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.glow",
				Command = "r_extended_glow"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.trail",
				Command = "r_extended_trail"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.entities_light",
				Command = "r_extended_light_entities"
			})
			
			panel:AddControl("Checkbox", {
				Label = "#extended_render.weapons_light",
				Command = "r_extended_light_weapons"
			})
			
			panel:AddControl("Slider", {
				Label = "#extended_render.fullbright",
				Command = "mat_fullbright",
				Min = 0,
				Max = 2
			})

			panel:AddControl("Slider", {
				Label = "#extended_render.lod",
				Command = "r_lod",
				Min = -1,
				Max = 5
			})
			
			panel:AddControl("Slider", {
				Label = "#extended_render.projected_shadows_filter",
				Command = "r_projectedtexture_filter",
				Min = -1,
				Max = 100
			})
			
			panel:AddControl("Slider", {
				Label = "#extended_render.flash_light_fov",
				Command = "r_flashlightfov",
				Min = 0,
				Max = 175
			})

			panel:AddControl("Slider", {
				Label = "#extended_render.motion_blur",
				Command = "r_extended_motion_blur_multiplier",
				Min = 0,
				Max = 30.0
			})
		end)
	end)
end