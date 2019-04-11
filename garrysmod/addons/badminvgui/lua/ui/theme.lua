local SKIN 	= {
	PrintName 	= 'SUP',
	Author 	 	= 'Kirussell'
}

local color_sup 			= ui.col.SUP
local color_background 		= ui.col.Background
local color_outline 		= ui.col.Outline
local color_hover 			= ui.col.Hover
local color_button 			= ui.col.Button
local color_button_hover	= ui.col.ButtonHover
local color_close 			= ui.col.Close
local color_close_bg 		= ui.col.CloseBackground
local color_close_hover 	= ui.col.CloseHovered

local color_offwhite 		= ui.col.OffWhite
local color_flat_black 		= ui.col.FlatBlack
local color_black 			= ui.col.Black
local color_red 			= ui.col.Red

-- Frames    
function SKIN:PaintFrame(self, w, h)
    draw.StencilBlur(self, w, h)

    draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 150))

    draw.RoundedBox(0, 0, 0, w, 27, Color(100,100,100,150))

    surface.SetDrawColor(Color(0,0,0))
    surface.DrawOutlinedRect(0, 0, w, h)
end

function SKIN:PaintPanel(self, w, h)

end

function SKIN:PaintShadow() end


-- Buttons    
function SKIN:PaintButton(self, w, h)
	if (not self.m_bBackground) then return end

	self.m_colColor = col
	self.m_colMouseOver = col
	self.m_colDisabled = col
	self.m_colDepressed = col
	self.m_intAlpha = 255
	self.m_colWhite = Color( 255, 255, 255, 255 )
	self.m_colWhiteT = Color( 255, 255, 255, 100 )
	self.m_colGrey = Color( 100, 100, 100, 255 )
	self.m_intAlphaOverride = int
	self.m_colOverride = col
	self.m_colMouseOverOverride = col

	if self:GetDisabled() then
		if not self.m_colDisabled then
			surface.SetDrawColor( 40, 40, 40, self.m_intAlphaOverride or self.m_intAlpha *0.9 )
		else
			surface.SetDrawColor( self.m_colDisabled.r, self.m_colDisabled.g, self.m_colDisabled.b, self.m_colDisabled.a )
		end
		self:SetTextColor( color_white )
	elseif self.Depressed then
		if not self.m_colDepressed then
			surface.SetDrawColor( 55, 55, 55, self.m_intAlphaOverride or self.m_intAlpha *0.8 )
		else
			surface.SetDrawColor( self.m_colDepressed.r, self.m_colDepressed.g, self.m_colDepressed.b, self.m_colDepressed.a )
		end
		self:SetTextColor( color_white )
	elseif self.Hovered then
		if not self.m_colMouseOver then
			surface.SetDrawColor( 100, 100, 100, self.m_intAlphaOverride or self.m_intAlpha *0.7 )
		else
			surface.SetDrawColor( self.m_colMouseOver.r, self.m_colMouseOver.g, self.m_colMouseOver.b, self.m_colMouseOver.a )
		end
		self:SetTextColor( color_white )
	elseif self.m_bSelected then
		if not self.m_colSelected then
			surface.SetDrawColor( 100, 100, 100, self.m_intAlphaOverride or self.m_intAlpha *0.7 )
		else
			surface.SetDrawColor( self.m_colSelected.r, self.m_colSelected.g, self.m_colSelected.b, self.m_colSelected.a )
		end
		self:SetTextColor( color_white )
	else
		if not self.m_colColor then
			surface.SetDrawColor( 80, 80, 80, self.m_intAlphaOverride or self.m_intAlpha *0.6 )
		else
			surface.SetDrawColor( self.m_colColor.r, self.m_colColor.g, self.m_colColor.b, self.m_colColor.a )
		end
		self:SetTextColor( color_white )
	end

	surface.DrawRect( 0, 0, w, h )

	if self.m_matIcon then
		surface.SetDrawColor( 255, 255, 255, 255 )
		surface.SetMaterial( self.m_matIcon )
		surface.DrawTexturedRect( self.m_intTexX, self.m_intTexY, self.m_intTexW or w, self.m_intTexH or h )
	end

	if (not self.fontset) then
		self:SetFont('ui.20')
		self.fontset = true
	end
end

function SKIN:PaintAvatarImage(self, w, h)
	if self.Hovered then
		draw.Box(0, 0, w, h, color_hover)
	end
end


-- Close Button                                               
function SKIN:PaintWindowCloseButton(panel, w, h)
end


-- Scrollbar
function SKIN:PaintVScrollBar(self, w, h) end
function SKIN:PaintButtonUp(self, w, h) end
function SKIN:PaintButtonDown(self, w, h) end
function SKIN:PaintButtonLeft(self, w, h) end
function SKIN:PaintButtonRight(self, w, h) end

function SKIN:PaintScrollBarGrip(self, w, h)
	draw.Box(0, 0, w, h, color_sup)
end

function SKIN:PaintScrollPanel(self, w, h)
	draw.OutlinedBox(0, 0, w, h, color_background, color_outline)
end

function SKIN:PaintUIScrollBar(self, w, h)
	draw.Box(0, self.scrollButton.y, w, self.height, color_outline)
end


-- Slider
function SKIN:PaintUISlider(self, w, h)
	SKIN:PaintPanel(self, w, h)
	draw.Box(1, 1, self:GetValue() * w - self:GetValue() * 16, h - 2, Color(220,220,220,150))
end


-- Text Entry
function SKIN:PaintTextEntry(self, w, h)
	draw.OutlinedBox(0, 0, w, h, color_offwhite, color_outline)

	self:DrawTextEntryText(color_black, color_sup, color_black)
end


-- List View
function SKIN:PaintUIListView(self, w, h) 
	draw.OutlinedBox(0, 0, w, h, color_offwhite, color_outline)
end


function SKIN:PaintListView(self, w, h) 
	draw.OutlinedBox(0, 0, w, h, color_offwhite, color_outline)
end

function SKIN:PaintListViewLine(self, w, h) -- todo, just make a new control and never use this
	for k, v in ipairs(self.Columns) do
		if (self:IsSelected() or self:IsHovered()) then
			v:SetTextColor(color_black)
		else
			v:SetTextColor(color_white)
		end
	end
end


-- Checkbox
function SKIN:PaintCheckBox(self, w, h)
	draw.OutlinedBox(0, 0, w, h, color_background, (self:GetChecked() and color_outline or color_outline))

	if self:GetChecked() then 
		draw.Box(4, 4, w - 8, h - 8, color_white)
	end
end


-- Tabs
function SKIN:PaintTabButton(self, w, h)
	self:SetTextColor(color_white)
	-- draw.Box(1, 0, w/5, h, Color(150,150,150,150))
  draw.RoundedBoxOutlined( 2, 0, 0, w/5, h, Color(58, 60, 69, 200), Color(20,20,20,150) )
	if self.Hovered then
		draw.Box(1, 0, w, h, Color(100,100,100,100))
	else
		draw.Box(1, 0, w, h, Color(60,60,60,150))
	end
end

function SKIN:PaintTabListPanel(self, w, h)

end


-- ComboBox
function SKIN:PaintComboBox(self, w, h)
	if IsValid(self.Menu) and (not self.Menu.SkinSet) then
		self.Menu:SetSkin('SUP')
		self.Menu.SkinSet = true
	end

	self:SetTextColor(((self.Hovered or self.Depressed or self:IsMenuOpen()) and color_black or color_white))

	draw.OutlinedBox(0, 0, w, h, ((self.Hovered or self.Depressed or self:IsMenuOpen()) and color_button_hover or color_background), color_outline)
end

function SKIN:PaintComboDownArrow(self, w, h)
	surface.SetDrawColor(color_sup)
	draw.NoTexture()
	surface.DrawPoly({
		{x = 0, y = w * .5},
		{x = h, y = 0},
		{x = h, y = w}
	})
end


-- DMenu
function SKIN:PaintMenu(self, w, h)
end

function SKIN:PaintMenuOption(self, w, h)
	if (not self.FontSet) then
		self:SetFont('ui.22')
		self:SetTextInset(5, 0)
		self.FontSet = true
	end
	
	self:SetTextColor(color_white)

	draw.OutlinedBox(0, 0, w, h + 1, color_background, color_outline)
	
	if self.m_bBackground and (self.Hovered or self.Highlight) then
		draw.OutlinedBox(0, 0, w, h + 1, Color(50,50,50,150) , color_outline)
		self:SetTextColor(color_button_hover)
	end
end


-- DPropertySheet
local propbackground = Color(200, 200, 200)
local prophovered = ui.col.ButtonHover
local propactive = Color(color_sup.r, color_sup.g, color_sup.b - 20)

function SKIN:PaintPropertySheet(self, w, h)
--	draw.RoundedBox(0, self:GetActiveTab():GetTall(), w, h - self:GetActiveTab():GetTall(), Color(70,70,70))
end

function SKIN:PaintTab(self, w, h)
	local active = self:GetPropertySheet():GetActiveTab() == self
	
	if (active) then
		self:SetTextColor(propactive)
		draw.Box(0, 0, w, h, propbackground)
	elseif (self:IsHovered()) then
		self:SetTextColor(prophovered)
	else
		self:SetTextColor(propbackground)
	end
end

derma.DefineSkin('SUP', 'SUP\'s derma skin', SKIN)
