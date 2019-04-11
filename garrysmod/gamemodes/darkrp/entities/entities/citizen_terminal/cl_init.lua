include('shared.lua')

function ENT:DrawTranslucent()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
		local Ang = LocalPlayer():GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), 90)

		-- print(self:GetNetVar('TerminalRepair'))

		cam.Start3D2D(self:GetPos()+self:GetUp()*60, Ang, 0.05)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				draw.SimpleTextOutlined( 'Гражданский Терминал', "font_base_large", -3, 0, rp.col.Blue, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined( 'Здесь можно изменить модель или ник. ', "font_base_54", -3, 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
			render.PopFilterMin()
		cam.End3D2D()
	end

end

net.Receive('Citizen_TerminalOpenMenu', function()
	local scrw, scrh = ScrW(), ScrH()

	local frame = vgui.Create('DFrame')
    frame:SetTitle( '' )
    frame:SetSize(scrw, scrh)
    -- frame:ShowCloseButton( false )
    frame:MakePopup()
    frame:Center()

    frame.Created = SysTime();
    frame.Closed = nil;
    frame.Alpha = 0;

    frame.Paint = function( self, w, h )
        self.Alpha = (math.Clamp(SysTime() - self.Created, 0, 0.15) - math.Clamp(SysTime() - (self.Closed or math.huge), 0, 0.15)) / 0.15;
        draw.Blur(self)
        draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, self.Alpha * 200))
    end

	local panel = vgui.Create('DPanel', frame)
	panel:SetSize(420,352+30)
	panel:SetPos(scrw*.5 - panel:GetWide()*.5, scrh*.5 - panel:GetTall()*.5)
	panel.Paint = function( self, w, h )
		draw.SimpleText('Как вас зовут:', "font_base_18", 0, 4, Color( 255, 255, 255, 255 ), 0, 0)
	end

	local entry = vgui.Create('DTextEntry', panel)
	entry:SetSize(200,24)
	entry:SetPos(110,0)
	entry.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, Color(230,230,230,255))

		surface.SetDrawColor(0,0,0,90)
		surface.DrawOutlinedRect(0, 0, w, h)
		self:DrawTextEntryText(Color(47,47,47,255), Color(0,165,255,255), Color(47,47,47,255))
	end

	entry:SetText( LocalPlayer():GetNetVar('Name') )

	local changename = vgui.Create('DButton', panel)
	changename:SetSize(150,24)
	changename:SetPos(panel:GetWide()*.5 - changename:GetWide() - 2,panel:GetTall() - 24)
	changename:SetText('')
	changename.Paint = function( self, w, h )
		local col = rp.col.Green
		col = self:IsHovered() and Color(col.r+10,col.g+10,col.b+10) or Color(col.r,col.g,col.b)
		draw.RoundedBox(0, 0, 0, w, h, col)

		draw.SimpleText(string.format('Сохранить (%s)',rp.FormatMoney(rp.cfg.ChangeNamePrice)), "font_base_18", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1 )

		surface.SetDrawColor(0,0,0,90)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	local cancel = vgui.Create('DButton', panel)
	cancel:SetSize(100,24)
	cancel:SetPos(panel:GetWide()*.5 + 2,panel:GetTall() - 24)
	cancel:SetText('')
	cancel.Paint = function( self, w, h )
		local col = rp.col.Red
		col = self:IsHovered() and Color(col.r+10,col.g+10,col.b+10) or Color(col.r,col.g,col.b)
		draw.RoundedBox(0, 0, 0, w, h, col)

		draw.SimpleText('Отмена', "font_base_18", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1 )

		surface.SetDrawColor(0,0,0,90)
		surface.DrawOutlinedRect(0, 0, w, h)
	end

	cancel.DoClick = function( self )
		frame:Close()
	end

	local DScrollPanel = vgui.Create( "DScrollPanel", panel )
	DScrollPanel:SetSize(420,300)
	DScrollPanel:SetPos(0,26+20)

	DScrollPanel.sbar = DScrollPanel:GetVBar()
	DScrollPanel.sbar.Paint = function( self, w, h ) end

	DScrollPanel.sbar:SetWide(0)


	local List = vgui.Create( "DIconLayout", DScrollPanel )
	List:Dock( FILL )
	List:SetSpaceY( 5 )
	List:SetSpaceX( 5 )

    local gender = tostring(LocalPlayer():GetNetVar('Gender') == 1 and 0 or 1)
	local player_model = LocalPlayer():GetNetVar('Model')

    for gender, models in pairs(rp.cfg.DefaultModels) do
        for _, model in pairs(models) do
            local ListItem = List:Add( "SpawnIcon" )
            ListItem:SetSize( 64, 64 )
            ListItem:SetModel( model )

            local Button = vgui.Create( "DButton", ListItem )
            Button:SetSize( 64, 64 )
            Button:SetPos( 0, 0 )

            Button:SetText( '' )
            Button.DoClick = function()
                player_model = model
            end
            Button.Paint = function( self, w, h )
                if ListItem:GetModelName() == player_model then
                    draw.RoundedBox(4, 0, 0, w, h, Color(255,255,255,40))
                end
            end
        end
    end

	changename.DoClick = function( self )
		net.Start('Citizen_ChangeCharacter')
			net.WriteString(entry:GetText())
			net.WriteString(player_model)
		net.SendToServer()
		frame:Close()
	end
end)
