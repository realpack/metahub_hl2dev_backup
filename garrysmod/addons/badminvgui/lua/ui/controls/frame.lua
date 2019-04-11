local PANEL = {}

AccessorFunc( PANEL, 'm_bIsMenuComponent', 		'IsMenu', 			FORCE_BOOL )
AccessorFunc( PANEL, 'm_bDraggable', 			'Draggable', 		FORCE_BOOL )
AccessorFunc( PANEL, 'm_bSizable', 				'Sizable', 			FORCE_BOOL )
AccessorFunc( PANEL, 'm_bScreenLock', 			'ScreenLock', 		FORCE_BOOL )
AccessorFunc( PANEL, 'm_bDeleteOnClose', 		'DeleteOnClose', 	FORCE_BOOL )
AccessorFunc( PANEL, 'm_bPaintShadow', 			'PaintShadow', 		FORCE_BOOL )

AccessorFunc( PANEL, 'm_iMinWidth', 			'MinWidth' )
AccessorFunc( PANEL, 'm_iMinHeight', 			'MinHeight' )

AccessorFunc( PANEL, 'm_bBackgroundBlur', 		'BackgroundBlur', 	FORCE_BOOL )

function PANEL:Init()
	self:SetFocusTopLevel( true )

	self.btnClose = vgui.Create('DButton', self)
	self.btnClose:SetZPos(9999)
	self.btnClose:SetFont("Marlett")
	self.btnClose:SetText("r")
	self.btnClose:SetTextColor(color_white)
	self.btnClose.Paint = function(s, w, h)
		local col = Color(200, 0, 0, 150)

		if s.Depressed then
			col = Color(128, 0, 0, 200)
		elseif s.Hovered then
			col = Color(200, 0, 0, 255)
		end
		draw.RoundedBoxEx(4, 0, 0, w, h, col, false, false, true, true)
	end
	self.btnClose.DoClick = function() self:Remove() end

	self.lblTitle = ui.Create( 'DLabel', self )
	self.lblTitle:SetColor(ui.col.White)
	self.lblTitle:SetFont('ui.22')

	self:SetDraggable( true )
	self:SetSizable( false )
	self:SetScreenLock( false )
	self:SetDeleteOnClose( true )
	self:SetTitle( 'Window' )
	self:SetSkin('core')

	self:SetMinWidth( 50 )
	self:SetMinHeight( 50 )

	-- This turns off the engine drawing
	self:SetPaintBackgroundEnabled( false )
	self:SetPaintBorderEnabled( false )

	self.m_fCreateTime = SysTime()

	self:DockPadding( 5, 24 + 5, 5, 5 )

	self:SetAlpha(0)
	self:FadeIn(0.2)

	hook('Think', self, function()
		if self.HandleMovement then
			self:HandleMovement()
		end
		if (self.animation) then
			self.animation:Run()
		end
	end)
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
	self.OnClose = function(self)
		for k, v in ipairs(panels) do
			if IsValid(v) then
				v:SetVisible(true)
			end
		end
		self:_OnClose()
	end
end

function PANEL:ShowCloseButton( bShow )
	self.btnClose:SetVisible( bShow )
end

function PANEL:SetTitle( strTitle )
	self.lblTitle:SetText( strTitle )
end

function PANEL:GetTitleHeight()
	return 33 -- 28 + 5px padding
end

function PANEL:GetDockPos()
	return 5, self:GetTitleHeight()
end

function PANEL:Center()
	self:InvalidateLayout( true )
	self:SetPos( ScrW()/2 - self:GetWide()/2, ScrH()/2 - self:GetTall()/2 )
end 

function PANEL:Close(cback)
	if (self:GetDeleteOnClose()) then
		self.Think = function() end -- You'll break shit if you continue to run
	end

	self:FadeOut(0.2, function()
		if (self:GetDeleteOnClose()) then
			self:Remove()
		else
			self:SetVisible(false)
		end

		if cback then cback() end
	end)

	self:OnClose()
end

function PANEL:OnClose()

end

function PANEL:Think()

end

function PANEL:IsActive()
	if ( self:HasFocus() ) then return true end
	if ( vgui.FocusedHasParent( self ) ) then return true end

	return false
end

function PANEL:HandleMovement()
	local mousex = math.Clamp( gui.MouseX(), 1, ScrW()-1 )
	local mousey = math.Clamp( gui.MouseY(), 1, ScrH()-1 )

	if ( self.Dragging ) then

		local x = mousex - self.Dragging[1]
		local y = mousey - self.Dragging[2]

		-- Lock to screen bounds if screenlock is enabled
		if ( self:GetScreenLock() ) then

			x = math.Clamp( x, 0, ScrW() - self:GetWide() )
			y = math.Clamp( y, 0, ScrH() - self:GetTall() )

		end

		self:SetPos( x, y )

	end

	if ( self.Sizing ) then
		local x = mousex - self.Sizing[1]
		local y = mousey - self.Sizing[2]
		local px, py = self:GetPos()

		if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > ScrW() - px and self:GetScreenLock() ) then x = ScrW() - px end
		if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > ScrH() - py and self:GetScreenLock() ) then y = ScrH() - py end

		self:SetSize( x, y )
		self:SetCursor( 'sizenwse' )
		return
	end

	if ( self.Hovered && self.m_bSizable &&
		 mousex > ( self.x + self:GetWide() - 20 ) &&
		 mousey > ( self.y + self:GetTall() - 20 ) ) then

		self:SetCursor( 'sizenwse' )
		return
	end

	if ( self.Hovered && self:GetDraggable() && mousey < ( self.y + 24 ) ) then
		self:SetCursor( 'sizeall' )
		return
	end

	self:SetCursor( 'arrow' )

	-- Don't allow the frame to go higher than 0
	if ( self.y < 0 ) then
		self:SetPos( self.x, 0 )
	end
end

function PANEL:Paint( w, h )
	if ( self.m_bBackgroundBlur ) then
		Derma_DrawBackgroundBlur( self, self.m_fCreateTime )
	end

	derma.SkinHook( 'Paint', 'Frame', self, w, h )
	return true
end

function PANEL:OnMousePressed()
	if ( self.m_bSizable ) then
		if ( gui.MouseX() > ( self.x + self:GetWide() - 20 ) &&
			gui.MouseY() > ( self.y + self:GetTall() - 20 ) ) then

			self.Sizing = { gui.MouseX() - self:GetWide(), gui.MouseY() - self:GetTall() }
			self:MouseCapture( true )
			return
		end
	end

	if ( self:GetDraggable() && gui.MouseY() < (self.y + 24) ) then
		self.Dragging = { gui.MouseX() - self.x, gui.MouseY() - self.y }
		self:MouseCapture( true )
		return
	end
end

function PANEL:OnMouseReleased()
	self.Dragging = nil
	self.Sizing = nil
	self:MouseCapture( false )
end

function PANEL:FadeIn(speed, cback)
	self.animation = Derma_Anim('Fade Panel', self, function(panel, animation, delta, data)
		panel:SetAlpha(delta * 255)
		if (animation.Finished) then
			self.animation = nil
			if cback then cback() end
		end
	end)

	if (self.animation) then
		self.animation:Start(speed)
	end
end

function PANEL:FadeOut(speed, cback)
	self.animation = Derma_Anim('Fade Panel', self, function(panel, animation, delta, data)
		panel:SetAlpha(255 - (delta * 255))
		if (animation.Finished) then
			self.animation = nil
			if cback then cback() end
		end
	end)

	if (self.animation) then
		self.animation:Start(speed)
	end
end

function PANEL:PerformLayout()
	self.lblTitle:SizeToContents()
	self.lblTitle:SetPos(5, 3)
	self.btnClose:SetPos(self:GetWide() - 60 - 8, 1)
	self.btnClose:SetSize(60, 20)
end

derma.DefineControl('ui_frame', 'A simple window', PANEL, 'EditablePanel')


PANEL = vgui.GetControlTable('ui_frame')

local SetSize = PANEL.SetSize
PANEL.SetSize = function(self, w, h)
	if (w <= 1) then
		w = w * ScrW()
	end
	if (h <= 1) then
		h = h * ScrH()
	end
	SetSize(self, w, h)
end

local SetWide = PANEL.SetWide
PANEL.SetWide = function(self, w)
	if (w <= 1) then
		w = w * ScrH()
	end
	SetWide(self, w)
end

local SetTall = PANEL.SetTall
PANEL.SetTall = function(self, h)
	if (h <= 1) then
		h = h * ScrH()
	end
	SetTall(self, h)
end
