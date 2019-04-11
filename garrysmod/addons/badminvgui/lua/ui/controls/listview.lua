local PANEL = {}

Derma_Hook(PANEL, 'Paint', 'Paint', 'UIListView')

function PANEL:Init()
	self.Rows = {}
	self:SetPadding(-1)
end

function PANEL:AddRow(value, disabled)
	local row = ui.Create('DButton', function(self)
		self:SetText(tostring(value))
		if (disabled == true) then 
			self:SetDisabled(true)
		end
	end)
	self:AddItem(row)
	self.Rows[#self.Rows + 1] = row
	row.DoClick = function()
		row.Active = true
		if IsValid(self.Selected) then
			self.Selected.Active = false
		end
		self.Selected = row
	end
	return row
end

function PANEL:AddSpacer(value)
	return self:AddRow(value, true)
end

function PANEL:GetSelected()
	return self.Selected
end

vgui.Register('ui_listview', PANEL, 'ui_scrollpanel')