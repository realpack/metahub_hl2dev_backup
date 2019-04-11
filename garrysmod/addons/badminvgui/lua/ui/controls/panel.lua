local PANEL = {}

-- Derma_Hook(PANEL, 'Paint', 'Paint', 'Panel')

function PANEL:DockToFrame()
	local p = self:GetParent()
	local x, y = p:GetDockPos()
	self:SetPos(x, y)
	self:SetSize(p:GetWide() - 10, p:GetTall() - (y + 5))
end

function PANEL:Paint(w,h)
	draw.Box(0, 0, w/5, h, Color(100,100,100,100))
	if self.Hovered then
		draw.Box(0, 0, w, h, Color(100,100,100,100))
	else
		draw.Box(0, 0, w, h, Color(60,60,60,150))
	end
end

vgui.Register('ui_panel', PANEL, 'Panel')
