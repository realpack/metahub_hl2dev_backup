local PANEL = {}

function PANEL:Init()
	self:DockPadding(0,24,0,0)

	self.lblTitle:SetPos(5,3)
	self.lblTitle:SetColor(IGS.col.TEXT_HARD)

	self.btnClose:SetTextColor(IGS.col.HIGHLIGHTING)
	self.btnClose:SetText("✕")
	self.btnClose:SetSize(30, 24)
	self.btnClose.Paint = function() end

	self:SetBackgroundBlur(true)
	self:SetTitle("")

	-- self.btnClose:SetVisible(false)
	self.btnMaxim:SetVisible(false)
	self.btnMinim:SetVisible(false)

	self.lblTitle:SetFont("ui.20")
end

function PANEL:GetTitleHeight()
	return 24 -- close button H
end

function PANEL:Paint(w,h)
	if self.m_bBackgroundBlur then
		Derma_DrawBackgroundBlur(self, self.m_fCreateTime)
	end

	IGS.S.Frame(self,w,h)
	return true
end

function PANEL:PaintOver(w,h)
	IGS.S.Outline(self,w,h) -- через = не работало
end

function PANEL:Focus()
	local panels = {}
	self:SetBackgroundBlur(true)
	for k, v in ipairs(vgui.GetWorldPanel():GetChildren()) do
		if v:IsVisible() and (v ~= self) then
			panels[#panels + 1] = v
			v:SetVisible(false)
		end
	end
	self._OnClose = self.OnClose
	self.OnClose = function()
		for k, v in ipairs(panels) do
			if IsValid(v) then
				v:SetVisible(true)
			end
		end
		self:_OnClose()
	end
end

function PANEL:PerformLayout()
	self.lblTitle:SizeToContents()

	self.btnClose:SetPos(self:GetWide() - 30, 0)
end

vgui.Register("iFrame",PANEL,"DFrame")
-- IGS.UI()