local PANEL = {}

Derma_Hook(PANEL, 'Paint', 'Paint', 'Panel')

function PANEL:Init()
	self:SetPadding(5)
	self:SetSpacing(5)
	
	self:Populate()
end

function PANEL:Populate() -- do the hack do the hack
	self:Reset()

	for k, v in pairs(cvar.GetTable()) do
		local title = ((self.State == 'All') and v:GetMetadata('Menu')) or (self.State and ((v:GetMetadata('State') or "") == self.State) and v:GetMetadata('Menu'))
		if title then
			local typ = v:GetMetadata('Type') or 'bool'
			if (typ == 'bool') then
				local chk = ui.Create('ui_checkbox', function(self)
					self:SetText(title)
					self:SetConVar(v:GetName())
					self:SizeToContents()
				end)
			
				self:AddItem(chk)
			elseif (typ == 'number') then
				self:AddItem(ui.Create('DLabel', function(self)
					self:SetFont('ui.18')
					self:SetColor(ui.col.ButtonText)
					self:SetText(title)
					self:SizeToContents()
					self:SetTall(14)
				end))
				self:AddItem(ui.Create('ui_slider', function(self)
					self:SetValue(v:GetValue())
					self.OnChange = function(s, val) v:SetValue(val) end
					self:SetWide(150)
				end))
			end
		end
	end
end

function PANEL:SetState(state)
	self.State = state
	self:Populate()
end

function PANEL:DockToFrame()
	local p = self:GetParent()
	local x, y = p:GetDockPos()
	self:SetPos(x, y)
	self:SetSize(p:GetWide() - 10, p:GetTall() - (y + 5))
end

vgui.Register('ui_settingspanel', PANEL, 'ui_scrollpanel')