local PANEL = {}

function PANEL:Init()
	self.Button = ui.Create('DButton', self)
	self.Button.OnMousePressed = function(s, mb) if (mb == MOUSE_LEFT) then s:GetParent():StartDrag() end end
	self.Button:SetText('')
	self:SetValue(0.5)
end

function PANEL:PerformLayout()
	self:SetTall(16)
	self.Button:SetSize(16, 16)
	self.Button:SetPos(self.Value * (self:GetWide() - 16), 0)
end

function PANEL:Paint(w, h)
	derma.SkinHook('Paint', 'UISlider', self, w, h)
end

function PANEL:Think()
	if (self.Dragging) then
		local mx, my = self:CursorPos()
		mx = math.Clamp(mx - self.OffX, 0, self:GetWide() - 16)

		if (self.Button.x != mx) then
			self:SetValue(mx / (self:GetWide() - 16))
			self:OnChange(self.Value)
		end

		if (!input.IsMouseDown(MOUSE_LEFT)) then
			self:EndDrag()
		end
	end
end

function PANEL:StartDrag()
	self.Dragging = true
	self.OffX = self.Button:CursorPos(MOUSE_LEFT)
end

function PANEL:EndDrag()
	self.Dragging = false
end

function PANEL:OnChange(val)
end

function PANEL:SetValue(val)
	self.Value = val
	self.Button:SetPos(val * (self:GetWide() - 16), 0)
end

function PANEL:GetValue()
	return self.Value
end

vgui.Register('ui_slider', PANEL, 'Panel')