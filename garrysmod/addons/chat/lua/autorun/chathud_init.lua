
-----------------------------------------------------
if CLIENT then
	hook.Add("HUDPaint", "chathud_init", function()
		hook.Remove("HUDPaint", "chathud_init")
		include("chathud/utf8.lua")
		include("chathud/pretty_text.lua")
		include("chathud/expression.lua")
		include("chathud/markup.lua")
		include("chathud/chathud.lua")
		include("chathud/tradingcard_emotes.lua")
	end)
end

if SERVER then
	AddCSLuaFile("chathud/utf8.lua")
	AddCSLuaFile("chathud/pretty_text.lua")
	AddCSLuaFile("chathud/expression.lua")
	AddCSLuaFile("chathud/markup.lua")
	AddCSLuaFile("chathud/chathud.lua")
	AddCSLuaFile("chathud/tradingcard_emotes.lua")

	resource.AddFile("resource/fonts/DejaVuSans.ttf")
end