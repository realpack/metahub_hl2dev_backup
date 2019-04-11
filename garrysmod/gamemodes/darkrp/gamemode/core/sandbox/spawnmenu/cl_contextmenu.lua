
local PANEL = {}

AccessorFunc( PANEL, "m_bHangOpen", "HangOpen" )


function PANEL:Init()

	--
	-- This makes it so that when you're hovering over this panel
	-- you can `click` on the world. Your viewmodel will aim etc.
	--
	self:SetWorldClicker( true )

	self.Canvas = vgui.Create( "DCategoryList", self )
	self.m_bHangOpen = false

end


function PANEL:Open()

	self:SetHangOpen( false )

    self.Created = SysTime();
    self.Closed = nil;
    self.Alpha = 0;

	-- If the spawn menu is open, try to close it..
	if ( g_SpawnMenu:IsVisible() ) then
		g_SpawnMenu:Close( true )
	end

	if ( self:IsVisible() ) then return end

	CloseDermaMenus()

	self:MakePopup()
	self:SetVisible( true )
	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled( true )

	RestoreCursorPosition()

	local bShouldShow = true;

	-- TODO: Any situation in which we shouldn't show the tool menu on the context menu?

	-- Set up the active panel..
	if ( bShouldShow && IsValid( spawnmenu.ActiveControlPanel() ) ) then

		self.OldParent = spawnmenu.ActiveControlPanel():GetParent()
		self.OldPosX, self.OldPosY = spawnmenu.ActiveControlPanel():GetPos()
		spawnmenu.ActiveControlPanel():SetParent( self )
		self.Canvas:Clear()
		self.Canvas:AddItem( spawnmenu.ActiveControlPanel() )
		self.Canvas:Rebuild()
		self.Canvas:SetVisible( true )

	else

		self.Canvas:SetVisible( false )

	end

	self:InvalidateLayout( true )

end


function PANEL:Close( bSkipAnim )

    self.Closed = SysTime();

	if ( self:GetHangOpen() ) then
		self:SetHangOpen( false )
		return
	end

	RememberCursorPosition()

	CloseDermaMenus()

	self:SetKeyboardInputEnabled( false )
	self:SetMouseInputEnabled( false )

	self:SetAlpha( 255 )
	self:SetVisible( false )
	self:RestoreControlPanel()

end


-- function PANEL:Think()
--     self.Alpha = (math.Clamp(SysTime() - self.Created, 0, 0.1) - math.Clamp(SysTime() - (self.Closed or math.huge), 0, 0.1)) / 0.1;
--     print(self.Alpha)
-- end

function PANEL:PerformLayout()

	self:SetPos( 0, 0 )
	self:SetSize( ScrW(), ScrH() )
    self:SetZPos( -32768 )
    self.Paint = function( self, w, h )
        -- self.Alpha = (math.Clamp(SysTime() - self.Created, 0, 0.1) - math.Clamp(SysTime() - (self.Closed or math.huge), 0, 0.1)) / 0.1;
        draw.Blur(self)
        -- draw.RoundedBox(0,0,0,w,h,Color(40, 60, 94, self.Alpha * 150))

    end

    self.OnClose = function()
        self.Closed = SysTime();
    end

	self.Canvas:SetWide( 311 )
	-- self.Canvas:SetPos( ScrW() - self.Canvas:GetWide() - 10, ScrH() - self.Canvas:GetTall() - 10 )
    self.Canvas:SetPos( ScrW() - self.Canvas:GetWide() - 10, ScrH() - self.Canvas:GetTall() - 10 )

	if ( IsValid( spawnmenu.ActiveControlPanel() ) ) then

		spawnmenu.ActiveControlPanel():InvalidateLayout( true )

		local Tall = spawnmenu.ActiveControlPanel():GetTall() + 10
		local MaxTall = ScrH() * 0.5
		if ( Tall > MaxTall ) then Tall = MaxTall end

		self.Canvas:SetTall( Tall )
		self.Canvas.y = ScrH() - 50 - Tall

	end

	self.Canvas:InvalidateLayout( true )

end


function PANEL:StartKeyFocus( pPanel )

	self:SetKeyboardInputEnabled( true )
	self:SetHangOpen( true )

end


function PANEL:EndKeyFocus( pPanel )

	self:SetKeyboardInputEnabled( false )

end


function PANEL:RestoreControlPanel()

	-- Restore the active panel
	if ( !spawnmenu.ActiveControlPanel() ) then return end
	if ( !self.OldParent ) then return end

	spawnmenu.ActiveControlPanel():SetParent( self.OldParent )
	spawnmenu.ActiveControlPanel():SetPos( self.OldPosX, self.OldPosY )

	self.OldParent = nil

end

--
-- Note here: EditablePanel is important! Child panels won't be able to get
-- keyboard input if it's a DPanel or a Panel. You need to either have an EditablePanel
-- or a DFrame (which is derived from EditablePanel) as your first panel attached to the system.
--
vgui.Register( "ContextMenu", PANEL, "EditablePanel" )


function CreateContextMenu()

	if ( IsValid( g_ContextMenu ) ) then
		g_ContextMenu:Remove()
		g_ContextMenu = nil
	end

	g_ContextMenu = vgui.Create( "ContextMenu" )
	g_ContextMenu:SetVisible( false )

	--
	-- We're blocking clicks to the world - but we don't want to
	-- so feed clicks to the proper functions..
	--
	g_ContextMenu.OnMousePressed = function( p, code )
		hook.Run( "GUIMousePressed", code, gui.ScreenToVector( gui.MousePos() ) )
	end
	g_ContextMenu.OnMouseReleased = function( p, code )
		hook.Run( "GUIMouseReleased", code, gui.ScreenToVector( gui.MousePos() ) )
	end

	hook.Run( "ContextMenuCreated", g_ContextMenu )

end


function GM:OnContextMenuOpen()

	-- Let the gamemode decide whether we should open or not..
	if ( !hook.Call( "ContextMenuOpen", GAMEMODE ) ) then return end

	if ( IsValid( g_ContextMenu ) && !g_ContextMenu:IsVisible() ) then
		g_ContextMenu:Open()
	end

end


function GM:OnContextMenuClose()

	if ( IsValid( g_ContextMenu ) ) then
		g_ContextMenu:Close()
	end

end
