if TRIGON then return end

surface.CreateFont("ui.40", {font = "roboto", extended = true, size = 40, weight = 500})
surface.CreateFont("ui.24", {font = "roboto", extended = true, size = 24, weight = 400})
surface.CreateFont("ui.22", {font = "roboto", extended = true, size = 22, weight = 400})
surface.CreateFont("ui.20", {font = "roboto", extended = true, size = 20, weight = 400})
surface.CreateFont("ui.19", {font = "roboto", extended = true, size = 19, weight = 400})
surface.CreateFont("ui.18", {font = "roboto", extended = true, size = 18, weight = 400})
surface.CreateFont("ui.17", {font = "roboto", extended = true, size = 15, weight = 550})
surface.CreateFont("ui.15", {font = "roboto", extended = true, size = 15, weight = 550})


ui = ui or {}
function ui.Create(t, f, p)
	local parent

	if     !isfunction(f) then parent = f
	elseif !isfunction(p) then parent = p end

	local v = vgui.Create(t, parent)


	if isfunction(f) then f(v, parent) elseif isfunction(p) then p(v, f) end

	return v
end


-- Чтобы не открывало F1 менюшку даркрпшевскую ебучую
hook.Add("DarkRPFinishedLoading","SupressDarkRPF1",function()
	if IGS.C.MENUBUTTON ~= KEY_F1 then return end

	function GM:ShowHelp() end
end)