local PANEL = {}

surface.CreateFont("tasks.20", {
	font = "Play",
	size = 17,
	extended = true,
	weight = 100
})

surface.CreateFont("tasks.24", {
	font = "Play",
	size = 22,
	extended = true,
	weight = 500
})

surface.CreateFont("tasks.28", {
	font = "Play",
	size = 26,
	extended = true,
	weight = 500
})

local blur = Material('pp/blurscreen')
local function DrawBlur(panel, amount) -- Thanks nutscript/penguin
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blur)
	for i = 1, 3 do
		blur:SetFloat('$blur', (i / 3) * (amount or 6))
		blur:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

function PANEL:Init()
	self.btnMaxim:SetVisible(false)
	self.btnMinim:SetVisible(false)
    self.btnClose.Paint = function() end
	self.lblTitle:SetFont("tasks.20")
	self:SetDraggable(true)
	self:SetAlpha(0)
	self:AlphaTo(255, 0.25, 0)
end

function PANEL:Close()
	self:AlphaTo(0, 0.25, 0, function()
		self:Remove()
	end)
end

local function DrawBox(x, y, w, h, col)
	surface.SetDrawColor(col)
	surface.DrawRect(x, y, w, h)
end

local function DrawOutline(w, h, col)
	surface.SetDrawColor(col)
	surface.DrawOutlinedRect(0, 0, w, h)
end

function PANEL:Paint(w, h)
    DrawBox(0, 0, w, h, Color(52, 73, 94, 255))
	DrawBlur(self, 2)
	DrawBox(0, 0, w, 30, Color(52, 73, 94))

	local buttonW, buttonH = 30, 30
	local buttonX = w - buttonW
	local buttonY = 0

	DrawBox(w - buttonW, 0, 29, 29, Color(200, 50, 50))

	local lineSize = 15
	local overAllSize = lineSize
	local lineX = buttonX + ((buttonW / 2) - (overAllSize / 2))
	local lineY = buttonY + ((buttonW / 2) - (overAllSize / 2))
	surface.SetDrawColor(Color(255, 255, 255, 255))
	surface.DrawLine(lineX,
					 lineY,  
					 lineX + lineSize,
					 lineY + lineSize) 

	surface.DrawLine(lineX + lineSize,
					 lineY,  
					 lineX,
					 lineY + lineSize) 

	DrawOutline(w, h, color_white)
    DrawOutline(w, 30, color_white)
end

function PANEL:PerformLayout()
	self:SetSize(self:GetWide(), self:GetTall())
	self.lblTitle:SizeToContents()
	self.lblTitle:SetPos(5, 5)
	self.btnClose:SetPos(self:GetWide() - 30, 0)
	self.btnClose:SetSize(30, 30)
end
vgui.Register("tasks.frame", PANEL, "DFrame")