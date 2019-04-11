local Tag="chatbox"
module(Tag,package.seeall)


if SERVER then AddCSLuaFile() return end


local L = translation and translation.L or function(s) return s end

local chatbox_font_input = CreateClientConVar("chatbox_font_input","DermaDefault",true)
local last = "hudselectiontext"
function GetInputFont()
	local font = chatbox_font_input:GetString()
	
	if last ~= font then
		local ok,err = pcall(surface.SetFont,font)
		if not ok then
			RunConsoleCommand("chatbox_font_input",last)
			font = last
			Msg"Chat: "print("Invalid font, reverting to",last)
		end
		last = font
	end

	return font
end

------------------------------------------------------

-- Config Panel

------------------------------------------------------

local PANEL={}

	function PANEL:Init()
		self.asd=vgui.Create('DPanelList',self)
		self.asd:Dock(FILL)
		self.asd:EnableVerticalScrollbar(true)
		self:InitControls()
	end

	function PANEL:InitControls()

		local this=self.asd

		local function TITLE(txt)

			local cat = vgui.Create("DCollapsibleCategory" , self)
			cat:SetLabel(L(txt))
			cat:SetTall(128)
			cat:SetExpanded(false)
			this:AddItem(cat)
			self=cat
			cat.AddItem=function(cat,ctrl)
				ctrl:SetParent(cat)
				ctrl:Dock(TOP)
			end

			

			return cat

		end

				

		local function checkbox(cvar,text)

			

			if GetConVar(cvar)==nil then return end

			

			local check = vgui.Create( "DMenuOptionCVar" , self )

			

			check:SetText(L(text))

			check:SetTooltip("CVar: "..cvar)

			check:SetConVar	(cvar)

			self:AddItem(check)

			check:GetParent().OpenSubMenu=function()end

			return check

			

		end

		

		local function spacer(size)

			size=size or 8

			local space = vgui.Create( "EditablePanel" , self )

			space:SetTall(size)

			self:AddItem(space)

		end

			

		

		local function fontsel(cvar,name)

			local c=vgui.Create('DCollapsibleCategory',self)

			c:SetLabel(L(name))

			c:SetExpanded(false)

			c:DockMargin(10,0,10,0)

			self:AddItem(c)

			c.animSlide = Derma_Anim( "Anim", c, function(self, anim, delta, data )

				

				self:InvalidateLayout()

				self:GetParent():InvalidateLayout()

				self:GetParent():GetParent():InvalidateLayout()

				

				if ( anim.Started ) then

					data.To = self:GetTall()

				end

				

				if ( anim.Finished ) then

					return

				end



				if ( self.Contents ) then self.Contents:SetVisible( true ) end

				

				self:SetTall( Lerp( delta, data.From, data.To ) )

				 

			end )

			

			local function add(font)

				local c=c:Add(font)

				c:SetFont(font)

				if font==GetConVarString(cvar) then

					c:SetSelected(true)

				end

				c.DoClick=function()

					RunConsoleCommand(cvar,font)

				end

			end

			add("Trebuchet24")

			add("ChatFont")

			add("TargetID")

			add("TargetIDSmall")

			add("DefaultFixedDropShadow")

			add("BudgetLabel")

			add("Default")

			add("DefaultFixed")

			add("DermaDefault")

			

			return c

			

		end



		

		

		

		TITLE			'Chat'.Header:SetImage 'icon16/comment.png'

			checkbox		('chatbox_show_ime',			"IME")
			checkbox("coh_enabled", "Показывать мой текст над головой")

			spacer()

			checkbox		('chat_timestamps_history',		"Timestamps (chat history)")

			spacer()

			checkbox		('chatbox_use_peek',			"Visual autocomplete")

			checkbox		('chatsounds_autocomplete',		"Autocomplete chat sounds")

			checkbox		('chatbox_nickcomplete',		"Autocomplete nicknames")

			spacer()

			

			checkbox		('chat_devmode',				"Lua")

			checkbox		('chatbox_logging',				"Logging")

			spacer()

			fontsel("chatbox_history_font","History Font")

			fontsel("chatbox_font_input","Input Font")

		

		TITLE			'Chat HUD'.Header:SetImage 'icon16/comments.png'

			

			checkbox		('cl_chathud_callengine',			"Chat in console")

			spacer()

			checkbox		('ms_lobby_party_fun_cmds',				"Text decorations")

			checkbox		('chathud_image_url',		"HUD Image Viewer")

			

		local NumSlider = vgui.Create( "DNumSlider", self )

			NumSlider:SetDark(true)

			NumSlider:SetText( L"Chat height" )

			NumSlider:SetMin( 0 )

			NumSlider:SetMax( 1 )

			NumSlider:SetDecimals( 2 )

			NumSlider:SetConVar( "cl_chathud_height_mult" )

			self:AddItem(NumSlider)

		

		local NumSlider = vgui.Create( "DNumSlider", self )

			NumSlider:SetDark(true)

			NumSlider:SetText( L"Chat width" )

			NumSlider:SetMin( 0 )

			NumSlider:SetMax( 1 )

			NumSlider:SetDecimals( 2 )

			NumSlider:SetConVar( "cl_chathud_width_mult" )

			self:AddItem(NumSlider)



		

		TITLE			'Audio'.Header:SetImage 'icon16/sound.png'

			checkbox		('snd_mute_losefocus',			"Out of game mute")

	

		local NumSlider = vgui.Create( "DNumSlider", DermaPanel )

			NumSlider:SetDark(true)

			NumSlider:SetText( L"Global Volume" )

			NumSlider:SetMin( 0 )

			NumSlider:SetMax( 1 )

			NumSlider.lastval=-1

			NumSlider.OnValueChanged=function(NumSlider,val)

				-- make it so volume changing in console won't beep this...

				val=val and tonumber(val)

				if not val then return end

				if NumSlider.lastval and  NumSlider.lastval<0 then NumSlider.lastval=nil return end

				if not NumSlider.lastval then NumSlider.lastval=val return end

				if val==NumSlider.lastval then return end

				NumSlider.lastval=val

				timer.Create("volumebeep",0.3,1,function()

					surface.PlaySound"buttons/button8.wav"

				end)

			end

			NumSlider:SetDecimals( 2 )

			NumSlider:SetConVar( "volume" )

		self:AddItem(NumSlider)



		local NumSlider = vgui.Create( "DNumSlider", DermaPanel )

			NumSlider:SetDark(true)

			NumSlider:SetText( L"Voice Volume" )

			NumSlider:SetMin( 0 )

			NumSlider:SetMax( 1 )

			NumSlider.lastval=-1

			NumSlider.OnValueChanged=function(NumSlider,val)

				val=val and tonumber(val)

				if not val then return end

				if NumSlider.lastval and  NumSlider.lastval<0 then NumSlider.lastval=nil return end

				if not NumSlider.lastval then NumSlider.lastval=val return end

				if val==NumSlider.lastval then return end

				NumSlider.lastval=val

				timer.Create("volumebeep",0.3,1,function()

					LocalPlayer():ConCommand("stopsound",true)

					timer.Simple(0.2,function()

						LocalPlayer():EmitSound("vo/npc/male01/startle01.wav",100*val)

					end)

				end)

			end

			NumSlider:SetDecimals( 2 )

			NumSlider:SetConVar( "voice_scale" )

		self:AddItem(NumSlider)

		

		local NumSlider = vgui.Create( "DNumSlider", DermaPanel )

			NumSlider:SetDark(true)

			NumSlider:SetText( (L"PlayX Media Volume" ))

			NumSlider:SetMin( 0 )

			NumSlider:SetMax( 100 )

			NumSlider:SetDecimals( 2 )

			NumSlider:SetConVar( "playx_volume" )

			self:AddItem(NumSlider)





		--------------------

		

		TITLE "Performance / Graphics".Header:SetImage 'icon16/monitor.png'

			checkbox		('cl_drawownshadow',		"Draw own shadow")

			checkbox		('r_shadows',		"Shadows (FPS!!!)")

			spacer(12)

			checkbox		('r_3dsky',		"3D Sky")

			spacer(12)

			checkbox		('cl_draw_snow',		"Snow")

			checkbox		('cl_error_cleanser',		"Hide ERROR props")

			checkbox		('cl_death_effects',		"Death Effects")

			checkbox		('r_WaterDrawReflection',		"Water Reflection")

			checkbox		('r_WaterDrawRefraction',		"Water Refraction")

		

			

		TITLE "PM".Header:SetImage 'icon16/group.png'

			checkbox		('chat_pm_disable',		"Disable")

			checkbox		('chat_pm_friendsonly',		"Friends only")

			spacer()

			checkbox		('pm_hud',		"PM in chat")

			spacer()

			checkbox		('pm_hud_notify',		"Notify Text")

			checkbox		('pm_hud_notify_sound',		"Notify Sound")

			spacer()

			checkbox		('chat_pmmode',		"Team chat -> PM")



		TITLE "Game".Header:SetImage 'icon16/joystick.png'

		

			checkbox("cl_showhints","Hints")

			spacer()

			checkbox("cl_showfps","Show FPS 1")

			checkbox("cl_showfps","Show FPS 2"):SetValueOn"2"

			spacer()

			checkbox("developer","Developer mode")

			checkbox("developer","Developer mode 2"):SetValueOn"2"

			spacer()

			checkbox("net_graph","Net Debug 1")

			checkbox("net_graph","Net Debug 2"):SetValueOn"2"

			checkbox("net_graph","Net Debug 3"):SetValueOn"3"

			checkbox("net_graph","Net Debug 4"):SetValueOn"4"





		

		if ctp then

			

			TITLE"Third person".Header:SetImage 'icon16/camera.png'

			

			

				local panel = vgui.Create("DCheckBoxLabel" , self)

				panel:SetText(L"Enable")

				panel:SetDark(true)

				function panel.OnChange(_, bool)

					if bool then

						ctp:Enable()

					else

						ctp:Disable()

					end

				end

			self:AddItem(panel)

		end



		--------------------

		

		if PlayX then



			TITLE	"Media Player".Header:SetImage 'icon16/music.png'

	

				checkbox("playx_enabled","Enable")

				checkbox("playx_proximity_enable","Distance autoplay")

						

			local NumSlider = vgui.Create( "DNumSlider", DermaPanel )

				NumSlider:SetDark(true)

				NumSlider:SetText( (L"Volume" ))

				NumSlider:SetMin( 0 )

				NumSlider:SetMax( 100 )

				NumSlider:SetDecimals( 2 )

				NumSlider:SetConVar( "playx_volume" )

				self:AddItem(NumSlider)

		end

		

		hook.Run("ChatboxConfig",{

									self=self,

									title=TITLE,

									checkbox=checkbox,

									spacer=spacer,

									this=this,

									fontsel=fontsel,

								 }

				)



	end





vgui.Register( Tag..'_config', PANEL, "DPanel" )