include 'markup.lua'

chathud = {
	font_translate = {
		-- usage
		-- chathud.font_translate.chathud_default = "my_font"
		-- to override fonts
	},
	config = {
		max_width = 500,
		max_height = 1200,
		height_spacing = 3,
		history_life = 20,
		
		extras = {
			["!!!!"] = {type = "font", val = "Trebuchet24"},
			["!!!!!11"] = {type = "font", val = "DermaLarge"},
		},

		shortcuts = {}
		
	},
	fonts = {
		default = {
			name = "chathud_default",
			data = {
				font = "Verdana",
				size = 36,
				weight = 600,
				antialias = true,
				shadow = true,
				prettyblur = 1,
			} ,
		},
		
		chatprint = {
			name = "chathud_chatprint",
			color = Color(201, 255, 41, 255),
			data = {
				font = "Verdana",
				size = 16,
				weight = 600,
				antialias = true,
				shadow = true,
				prettyblur = 1,
			},
		},
	}
}

for _, v in pairs(file.Find("materials/icon16/*.png", "GAME")) do
	chathud.config.shortcuts[v:gsub("(%.png)$","")] = "<texture=materials/icon16/" .. v .. ",16>"
end

for name, data in pairs(chathud.fonts) do
	surface.CreateFont(data.name, data.data)
end

local chathud_show = CreateClientConVar("cl_chathud_show", "1", true, false)
local height_mult = CreateClientConVar("cl_chathud_height_mult", "0.76", true, false)
local width_mult = CreateClientConVar("cl_chathud_width_mult", "0.3", true, false)
local you_show = CreateClientConVar("cl_chathud_you", "0", true, false)

chathud.markup =  Markup()
chathud.markup:SetEditable(false)
chathud.life_time = 20

local last_draw = 0

if surface.DrawFlag then
	CHATHUD_TAGS.flag =
	{
		arguments = {"gb"},
		
		draw = function(markup, self, x,y, flag)
			surface.DrawFlag(flag, x, y - 12)
		end,
	}
end

function chathud.AddText(...)

	if last_draw < RealTime() then return end

	if chathud_show:GetBool() then
		chathud.cleared = false
	else
		if not chathud.cleared then
			chathud.markup:Clear()
			chathud.cleared = true
		end
		return
	end

	local params = {...}
	local args = {}

	local last_param = params[#params]

	if last_param and type(last_param) == "string" and last_param[1] == ":" then
		params[#params] = ":"
		local color = Color(255, 255, 255, 255)
		if params[#params - 1] then
			local prev = params[#params - 1]
			if type(prev) == "table" and prev.r and prev.g and prev.b and prev.a then
				color = prev
			end
		end

		table.insert(params, color)
		table.insert(params, last_param:sub(2))
	end
		
	for k,v in pairs(params) do
		local t = type(v)
		if t == "Player" then
			table.insert(args, team.GetColor(v:Team()))
			table.insert(args, v:Nick())
			table.insert(args, Color(255, 255, 255, 255))
		elseif t == "string" then
		
			if v == " sh" or v:find("%ssh%s") then
				chathud.markup:TagPanic()
			end
		
			v = v:gsub("<remember=(.-)>(.-)</remember>", function(key, val)
				chathud.config.shortcuts[key] = val
			end)
		
			v = v:gsub("(:[%a%d]-:)", function(str)
				str = str:sub(2, -2)
				if chathud.config.shortcuts[str] then
					return chathud.config.shortcuts[str]
				end
			end)
			
			for pattern, font in pairs(chathud.config.extras) do
				if v:find(pattern, nil, true) then
					table.insert(args, font)
				end
			end
						
			table.insert(args, v)
		else
			table.insert(args, v)
		end
	end
   
	local markup = chathud.markup

	markup:BeginLifeTime(chathud.life_time)
		-- this will make everything added here get removed after said life time
		markup:AddFont("markup_default") -- also reset the font just in case
		markup:AddTable(args, hook.Run("CanRunAnnoyingTags", chathud.GetPlayer()))
		markup:AddTagStopper()
		markup:AddString("\n")
	markup:EndLifeTime()
	
	markup:SetMaxWidth(ScrW() * width_mult:GetFloat())
end
function chathud.hook_AddText(...)
	chathud.AddText(...)
	return true
end
function chathud.Draw()
	if not chathud_show:GetBool() then return end
	
	local markup = chathud.markup
	
	local w, h = ScrW(), ScrH()
	local x, y = 30, h * height_mult:GetFloat()
	
	y = y - markup.height

	markup:Draw(x, y, w, h)
	
	last_draw = RealTime() + 3
end

function chathud.MouseInput(button, press, x, y)
	if not chathud_show:GetBool() then return end
	
	chathud.markup:OnMouseInput(button, press, x, y)
end

do -- wip
	function chathud.GetPlayer()
		return chathud.current_player or NULL
	end

	-- kinda hacky but it should work
	hook.Add("PlayerSay", "chathud", function(ply)
		chathud.current_player = ply
		timer.Simple(0, function() chathud.current_player = NULL end)
	end)

	hook.Add("OnPlayerChat", "chathud", function(ply)
		chathud.current_player = ply
		timer.Simple(0, function() chathud.current_player = NULL end)
	end)
end

do -- chat input
	hook.Add("ChatText", "chathud", function(_, _, msg)
		chathud.AddText(
			{type = "font", val = chathud.fonts.chatprint.name},
			chathud.fonts.chatprint.color,
			tostring(msg)
		)
	end)
end

if false then -- input
	local translate = {
		[MOUSE_LEFT] = "button_1",
		[MOUSE_RIGHT] = "button_2",
	}

	hook.Add("GUIMousePressed", "chathud", function(button)
		if vgui.GetHoveredPanel() or vgui.GetKeyboardFocus() then return end
		
		button = translate[button]
		if button then
			chathud.MouseInput(button, true, gui.MousePos())
		end
	end)

	hook.Add("GUIMouseReleased", "chathud", function(button)
		if vgui.GetHoveredPanel() or vgui.GetKeyboardFocus() then return end
	
		button = translate[button]
		if button then
			chathud.MouseInput(button, false, gui.MousePos())
		end
	end)
end

do -- drawing
	hook.Add("HUDShouldDraw", "chathud", function(name)
		if name == "CHudChat" and chathud_show:GetBool() then
			return false
		end
	end)

	hook.Add("HUDPaint", "chathud", function()
	
		-- NEED: lua/includes/extensions/chat_addtext_hack.lua
		if chathud_show:GetBool() then
			_G.PrimaryChatAddText = chathud.hook_AddText
		else
			-- NEED: lua/includes/extensions/chat_addtext_hack.lua
			_G.PrimaryChatAddText = nil
		end
		
		chathud.Draw()
		if you_show:GetBool() then
			chathud.config.shortcuts["you"] = LocalPlayer():Nick()
		elseif not you_show:GetBool() and chathud.config.shortcuts["you"] then
			chathud.config.shortcuts["you"] = nil
		end
	end)
end