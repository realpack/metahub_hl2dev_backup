local PANEL = {}



function PANEL:Init()

	self.tabList = ui.Create('ui_scrollpanel', function(list)

		list:SetSize(150, 0)

		list:Dock(LEFT)

		list:SetPadding(-1)

	end, self)

	self.Buttons = {}

end



function PANEL:SetActiveTab(num)

	for k, v in ipairs(self.Buttons) do

		v.Active = (num == k)

		

		if (v.Tab:IsVisible()) then

			v.Tab:Dock(NODOCK)

			v.Tab:SetVisible(false)

		end

		

		if (num == k) then

			v.Tab:SetVisible(true)

			v.Tab:DockMargin(0, 0, 0, 0)

			v.Tab:Dock(FILL)

		end

	end

end



function PANEL:AddTab(title, tab, icon)

	tab.Paint = function(tab, w, h) end

	tab:SetSize(self:GetWide() - 150, self:GetTall())

	tab:SetVisible(false)

	tab:SetParent(self)

	tab:SetSkin(self:GetSkin().PrintName)



	local button = ui.Create('DButton', function(btn)

		btn:SetSize(0, 35)

		btn:SetText('')

		btn:SetFont('font_base_24')

		btn:SetTextColor(ui.col.White)

		btn.DoClick = function(s)
			self:SetActiveTab(s.ID)
		end

		btn.Paint = function(btn, w, h)

			derma.SkinHook('Paint', 'TabButton', btn, w, h)

			draw.ShadowSimpleText(title, 'font_base_18', w/4, h*0.2, ui.col.white, TEXT_ALIGN_LEFT, 0)
			if icon then
				surface.SetDrawColor( 255, 255, 255, 255 )
				surface.SetMaterial(Material(icon,'noclamp smooth'))
				surface.DrawTexturedRect( w/30, h*0.2, 20, 20 )
			end
		end

		

		btn.Tab = tab

	end)



	self.tabList:AddItem(button)

	button.ID = table.insert(self.Buttons, button)

	

	if (active) then

		self:SetActiveTab(button.ID)

	end

end

local fr

function PANEL:AddButton(title, func)

	local button = ui.Create('DButton', function(btn)

		btn:SetSize(0, 35)

		btn:SetText(title)

		

		btn:SetFont('ui.24')

		btn:SetTextColor(ui.col.White)

		

		btn.DoClick = function(self)

			func(self)

		end

		

		btn.Paint = function(btn, w, h)

			derma.SkinHook('Paint', 'TabButton', btn, w, h)

		end

	end)

	

	self.tabList:AddItem(button)

	table.insert(self.Buttons, btn)

	

	fr = self

end



function PANEL:DockToFrame()

	local p = self:GetParent()

	local x, y = p:GetDockPos()

	y = y - 6

	self:SetPos(0, y)

	self:SetSize(p:GetWide(), p:GetTall() - y)

end



function PANEL:Paint(w, h)

	derma.SkinHook('Paint', 'TabListPanel', self, w, h)

end



vgui.Register('ui_tablist', PANEL, 'Panel')
