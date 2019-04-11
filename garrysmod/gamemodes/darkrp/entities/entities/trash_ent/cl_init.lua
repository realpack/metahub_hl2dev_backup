include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

local start_time, over_time
net.Receive( "OpenTrashDerma", function()
    local duration = net.ReadInt(16)
	start_time = CurTime()
    over_time = start_time + duration
end)

net.Receive("TrashFail", function()
    start_time = nil
    over_time = nil
end)

hook.Add("HUDPaint", "Trash.HUDPaint", function()
    if not start_time or not over_time then return end
    if CurTime() > over_time then return end

    local scr_w, scr_h = ScrW(), ScrH()
    local w, h = 300, 50
    local x, y = (scr_w - w)/2, (scr_h-h)/2

    draw.RoundedBox(3, x, y, w, h, Color(0,0,0,150))
    draw.RoundedBox(3, x, y, w*(CurTime()-start_time)/(over_time-start_time), h, Color(48,161,134,200))
    draw.SimpleText("Looting...", "chatfont", scr_w/2, scr_h/2, color_white, 1, 1)
end)
