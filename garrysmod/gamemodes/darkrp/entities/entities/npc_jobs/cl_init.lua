include("shared.lua")
local Menu

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():DistToSqr(LocalPlayer():GetPos()) < 512^2 then
		local Ang = LocalPlayer():GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), 90)

		cam.Start3D2D(self:GetPos()+self:GetUp()*78, Ang, 0.05)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				draw.ShadowSimpleText( self:GetTitle(), "font_base_84", 10, 0, Color(240,240,240), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				-- draw.ShadowSimpleText( 'Тут можно купить воздушную/наземную технику.', "font_base_54", -3, 70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
			render.PopFilterMin()
		cam.End3D2D()
	end
end

function NPCJobs_OpenMenu()
    if IsValid(Menu) then
        Menu:Remove()
    end

    local alpha_lerp
    local select_team = 1
    local npc_id = net.ReadString()

    Menu = vgui.Create( "DFrame" )
    Menu:SetSize(ScrW(),ScrH())
    Menu:Center()
    Menu:MakePopup()
    Menu:SetTitle('')
    Menu.Paint = function( self, w, h )
    	alpha = 230
		alpha_lerp = Lerp(FrameTime()*2,alpha_lerp or 0,alpha or 0) or 0
		local x, y = self:GetPos()
		draw.Blur( self )

        draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, alpha_lerp))
    end

    local Scroll = vgui.Create('DScrollPanel', Menu)
    Scroll:SetSize(600,Menu:GetTall()-200)
    Scroll:SetPos(Menu:GetWide()*.5 - Scroll:GetWide()*.5, 100)
    Scroll.Paint = function( self, w, h )
        -- draw.RoundedBox(0,0,0,w,h,Color(255, 73, 94, 90))
    end
    -- Scroll.GetVBar().Paint = function( self, w, h ) end

    Scroll.sbar = Scroll:GetVBar()
	Scroll.sbar.Paint = function( self, w, h ) end

	Scroll.sbar:SetWide(6)

	function Scroll.sbar:PerformLayout()
		local Wide = self:GetWide()
		local Scroll = self:GetScroll() / self.CanvasSize
		local BarSize = math.max( self:BarScale() * ( self:GetTall() - ( Wide * 2 ) ), 10 )
		local Track = self:GetTall() - BarSize
		Track = Track + 1

		Scroll = Scroll * Track

		self.btnGrip:SetPos( 0, Scroll )
		self.btnGrip:SetSize( Wide, BarSize )

		self.btnUp:SetPos( 0, 0, 0, 0 )
		self.btnUp:SetSize( 0, 0 )

		self.btnDown:SetPos( 0, self:GetTall() - 0, 0, 0 )
		self.btnDown:SetSize( 0, 0 )
	end
	Scroll.sbar.btnGrip.Paint = function( self, w, h ) draw.RoundedBox(0, 0, 0, w, h, Color(240, 240, 240, 90)) end



    -- local Panel = vgui.Create('DListLayout', Scroll)
    -- Panel:SetSize(600,0)
    -- Panel:SetPos(0,0)
    -- -- Panel:Dock( FILL )
    -- Panel.Paint = function( self, w, h )
    --     draw.RoundedBox(0,0,0,w,h,Color(255, 73, 94, 90))
    -- end

    local _, teams = SortedPairs(table.Copy(net.ReadTable()))
    teams = teams.KeyValues
    -- PrintTable(teams)

    -- SortedPairsByValue( teams )
    -- PrintTable(teams)

    -- table.sort( teams, function( a, b ) return a[1] > b[1] end )


    for i, data in pairs(teams) do
        local t = data.key
        local price = data.val

        local tm = rp.teams[t]

        local has_t = LocalPlayer():HasTeam(t)

        -- local team_panel = vgui.Create('DButton')
        local team_panel = Scroll:Add( "DButton" )
        team_panel:SetSize(Scroll:GetWide(),100)
        team_panel:SetText( '' )
        team_panel:Dock( TOP )
	    team_panel:DockMargin( 0, 0, 0, 5 )
        team_panel.Paint = function( self, w, h )
            h = h - 2
            w = w - 2

            local col = self:IsHovered() and Color(255, 255, 255, 5) or Color(0, 0, 0, 90)

            draw.RoundedBox(0,0,0,w,h,col)
            draw.SimpleText(tm.name, "font_base_22", 110, 10, tm.color, 0, 0)
            if has_t then
                draw.SimpleText('Куплено', "font_base_24", w - 20, 10, Color(92, 184, 92, 255), 2, 0)
            else
                draw.SimpleText(rp.FormatMoney(price), "font_base_24", w - 20, 10, Color(255, 68, 68, 255), 2, 0)
            end

            if tm.CustomCheckFailMsg then
                draw.SimpleText(tm.CustomCheckFailMsg, "font_base_12", w - 110, 10, Color(255, 255, 255, 120), 2, 0)
            end
        end

        team_panel.DoClick = function( self )
            if has_t then
                net.Start('NPCJobs_ChangeTeam')
                    net.WriteUInt(t, 32)
                    net.WriteString(npc_id)
                net.SendToServer()
            else
                net.Start('NPCJobs_BuyTeam')
                    net.WriteUInt(t, 32)
                    net.WriteString(npc_id)
                net.SendToServer()
            end
            Menu:Close()
        end

        local description = tm.description
        description = string.Replace(description, '\n', '')
        -- print(description)
        description = string.Wrap('Default', description, 450)
        description = string.Implode('\n', description)

        surface.SetFont('Default')
        local dw, dh = surface.GetTextSize(description)

        -- PrintTable(description)
        local team_text = Label( description, team_panel)

        team_text:SetAutoStretchVertical(true)
        team_text:SetWide(450)
        team_text:SetPos(110,33)

        -- local _, count_lines = description:gsub('\n', '\n')
        -- if count_lines > 5 then
        -- end

        team_text:SizeToContents()
        -- team_text.Paint = function( self, w, h )
        --     draw.RoundedBox(0,0,0,w,h,Color(255,255,255,30))
        -- end

        -- print(description)
        if tm.description and tm.description ~= '' and team_text:GetTall() >= 100 then
            team_panel:SetTall(team_text:GetTall()+44)
        end

        local team_model = vgui.Create('ModelImage', team_panel)
        team_model:SetSize(100,98)
        if tm.model then
            team_model:SetModel( istable(tm.model) and table.Random(tm.model) or tm.model  )
        else
            if LocalPlayer():GetNetVar('Model') then
                team_model:SetModel( LocalPlayer():GetNetVar('Model') )
            else
                team_model:Remove()
            end
        end

        -- Panel:Add( team_panel )
    end
end

net.Receive('NPCJobs_OpenMenu', NPCJobs_OpenMenu)
