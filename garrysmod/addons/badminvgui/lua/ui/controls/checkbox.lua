local PANEL = {}

function PANEL:SetText(txt)
	self.Label = self.Label or ui.Create('DLabel', function(self)
		self:SetFont('ui.18')
	end, self)
	
	self.Label:SetText(txt)
end

function PANEL:PerformLayout() end

function PANEL:SetConVar(var)
	self.Button.DoClick = function()
		self.Button:Toggle()
		cvar.SetValue(var, not cvar.GetValue(var))
	end
	self.Label:SetMouseInputEnabled(true)
	self.Label.OnMousePressed = self.Button.DoClick
	self:SetValue(cvar.GetValue(var) and 1 or 0)
	self:SetTextColor(rp.col.ButtonText)
end

function PANEL:SizeToContents()
	self.Button:SetSize(16, 16)
	local w, h = 16, 16
	
	if (self.Label) then
		self.Label:SizeToContents()
		w = w + 5 + self.Label:GetWide()
		h = math.max(h, self.Label:GetTall())
		
		self.Label:SetPos(21, (h - self.Label:GetTall()) * 0.5 - 1)
	end
	
	self:SetSize(w, h)
end

vgui.Register('ui_checkbox', PANEL, 'DCheckBoxLabel')