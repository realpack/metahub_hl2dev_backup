include('sh_init.lua')

-- surface.CreateFont("3d2d",{font = "Tahoma",size = 130,weight = 1700,shadow = true, antialias = true})
-- surface.CreateFont("Trebuchet22", {size = 22,weight = 500,antialias = true,shadow = false,font = "Trebuchet MS"})

timer.Create("CleanBodys", 60, 0, function()
	RunConsoleCommand('r_cleardecals')
	for k, v in ipairs(ents.FindByClass("class C_ClientRagdoll")) do
		v:Remove()
	end
	for k, v in ipairs(ents.FindByClass("class C_PhysPropClientside")) do
		v:Remove()
	end
end)

hook('InitPostEntity', function()
	LocalPlayer():ConCommand('stopsound; cl_updaterate 16; cl_cmdrate 16;')
end)

local GUIToggled = false
local mouseX, mouseY = ScrW() / 2, ScrH() / 2
function GM:ShowSpare1()
	GUIToggled = not GUIToggled

	if GUIToggled then
		gui.SetMousePos(mouseX, mouseY)
	else
		mouseX, mouseY = gui.MousePos()
	end
	gui.EnableScreenClicker(GUIToggled)
end

local FKeyBinds = {
	["gm_showhelp"] = "ShowHelp",
	["gm_showteam"] = "ShowTeam",
	["gm_showspare1"] = "ShowSpare1",
	["gm_showspare2"] = "ShowSpare2"
}

function GM:PlayerBindPress(ply, bind, pressed)
	local bnd = string.match(string.lower(bind), "gm_[a-z]+[12]?")
	if bnd and FKeyBinds[bnd] and GAMEMODE[FKeyBinds[bnd]] then
		GAMEMODE[FKeyBinds[bnd]](GAMEMODE)
	end
	return
end

concommand.Remove('act')
