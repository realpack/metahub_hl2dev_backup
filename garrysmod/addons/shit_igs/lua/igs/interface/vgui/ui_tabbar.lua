local PANEL = {}

local barTall = 50
local btnWide = 70

function PANEL:Init()
	self.activity = ui.Create("multipanel",self)

	self.tabBar = ui.Create("Panel",self)
	self.tabBar:SetTall(barTall)
	self.tabBar.Paint = function(s,w,h)
		surface.SetDrawColor(IGS.col.TAB_BAR)
		surface.DrawRect(0,0,w,h) -- bg

		surface.SetDrawColor(IGS.col.HARD_LINE)
		surface.DrawLine(0,0,w,0) -- upper line
	end

	self.btnsPan = ui.Create("DIconLayout",self.tabBar)
	self.btnsPan.Paint = function() end

	self.Buttons = {}
end

function PANEL:SetActiveTab(num)
	for i,btn in ipairs(self.Buttons) do
		btn.Active = num == i -- для подсветки
	end

	self.activity:SetActivePanel(num)
end

function PANEL:GetActiveTab()
	return self.activity:GetActivePanel()
end

function PANEL:AddTab(sTitle,panel,sIcon,bActive)
	local ID = self.activity:AddPanel(panel,bActive)

	local button = ui.Create("DButton",function(btn)
		btn:SetSize(btnWide, 50)
		btn:SetText("")

		btn:SetFont("ui.24")

		btn.DoClick = function(s)
			self:SetActiveTab(s.ID)
		end

		--[[-------------------------------------------------------------------------
			TODO Сделать отрисовку скина через скин хук
			чтобы можно было юзать компонент не только в IGS без порчи дизайна
			В bar.Paint тоже
		---------------------------------------------------------------------------]]
		btn.Paint = function(s,w,h)
			if s.Active then
				surface.SetDrawColor(IGS.col.HIGHLIGHTING)
				surface.SetTextColor(IGS.col.HIGHLIGHTING)
			else
				surface.SetDrawColor(IGS.col.HIGHLIGHT_INACTIVE)
				surface.SetTextColor(IGS.col.HIGHLIGHT_INACTIVE)
			end

			if sIcon then
				surface.SetMaterial( Material(sIcon) )
				surface.DrawTexturedRect(w / 2 - 32 / 2,3,32,32)
			end

			if sTitle then
				surface.SetFont("ui.15")

				local tw = surface.GetTextSize(sTitle)
				surface.SetTextPos(w / 2 - tw / 2,32 + 3)

				surface.DrawText( sTitle )
			end
		end

		btn.ID     = ID
		btn.Tab    = panel
		btn.Active = bActive
	end)

	function button:Name()
		return sTitle
	end

	self.btnsPan:Add(button)
	table.insert(self.Buttons, button)

	-- self:PerformLayout()
	self.btnsPan:SetSize(#self.Buttons * btnWide,barTall)
	self.btnsPan:SetPos((self:GetWide() - self.btnsPan:GetWide()) / 2)


	return button
end

function PANEL:PerformLayout()
	self.tabBar:SetWide(self:GetWide())
	self.tabBar:SetPos(0,self:GetTall() - self.tabBar:GetTall())

	self.activity:SetSize(self.tabBar:GetWide(),self:GetTall() - barTall)
end

function PANEL:Paint(w,h)
	draw.RoundedBox(0,0,0,w,h,IGS.col.ACTIVITY_BG)
end

vgui.Register("ui_tabbar", PANEL, "Panel")
-- IGS.UI()