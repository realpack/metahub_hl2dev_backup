--
local pda


local function OpenNewPanel( x, y, w, h, title )
    local fr2 = vgui.Create('DFrame', pda)
    fr2:SetSize(w,h)
    fr2:SetPos(x,24+y)
    fr2:SetTitle( '' )
    fr2:SetScreenLock( true )
    fr2:ShowCloseButton( false )
    fr2.Paint = function( self, w, h )
        draw.RoundedBox(4,0,0,w,h,Color(0,0,0,90))

        x, y = 1, 1
        w, h = w-1, h-1
        draw.RoundedBoxEx(4,x,y,w,24,Color(67,67,67,255), true, true, false, false)
        draw.RoundedBoxEx(4,x,x+24,w,h-24,Color(77,77,77,255), false, false, true, true)

        draw.SimpleText(title, "font_base_small", w/2, 4, Color( 255, 255, 255, 255 ), 1, 0)
    end
    fr2:SetSizable( true )

    local close = vgui.Create('DButton',fr2)
    close:SetSize(20,20)
    close:SetPos(2,2)
    close:SetText('')
    close.Paint = function( self, w, h )
        -- draw.RoundedBoxEx(4,0,0,w,24,Color(214,45,32,255), true, true, true, true)

        DrawSimpleCircle( w/2, h/2, 7.2, self:IsHovered() and Color(214,45,32,200) or Color(214,45,32,255) )
    end
    close.DoClick = function( self )
        fr2:Close()
    end

    -- local close = vgui.Create('DButton',fr2)
    -- close:SetSize(20,20)
    -- close:SetPos(20,2)
    -- close:SetText('')
    -- close.Paint = function( self, w, h )
    --     -- draw.RoundedBoxEx(4,0,0,w,24,Color(214,45,32,255), true, true, true, true)

    --     DrawSimpleCircle( w/2, h/2, 7.2, self:IsHovered() and Color(255,165,0,200) or Color(255,165,0,255) )
    -- end
    -- close.DoClick = function( self )
    --     fr2:Close()
    -- end

    function fr2:Think()
        local parent = self:GetParent()

        local mousex = math.Clamp( gui.MouseX(), 1, ScrW() - 1 )
        local mousey = math.Clamp( gui.MouseY(), 1, ScrH() - 1 )

        if ( self.Dragging ) then

            local x = mousex - self.Dragging[1]
            local y = mousey - self.Dragging[2]

            -- Lock to screen bounds if screenlock is enabled
            if ( self:GetScreenLock() ) then
                x = math.Clamp( x, 0, parent:GetWide() - self:GetWide() )
                y = math.Clamp( y, 0, parent:GetTall() - self:GetTall() )
            end

            self:SetPos( x, y )
            self:RequestFocus()
        end

        if ( self.Sizing ) then

            local x = mousex - self.Sizing[1]
            local y = mousey - self.Sizing[2]
            local px, py = self:GetPos()

            if ( x < self.m_iMinWidth ) then x = self.m_iMinWidth elseif ( x > parent:GetWide() - px && self:GetScreenLock() ) then x = parent:GetWide() - px end
            if ( y < self.m_iMinHeight ) then y = self.m_iMinHeight elseif ( y > parent:GetTall() - py && self:GetScreenLock() ) then y = parent:GetTall() - py end

            self:SetSize( x, y )
            close:SetPos(self:GetWide()-close:GetWide(),0)
            self:SetCursor( "sizenwse" )
            return

        end

        local screenX, screenY = self:LocalToScreen( 0, 0 )

        if ( self.Hovered && self.m_bSizable && mousex > ( screenX + self:GetWide() - 20 ) && mousey > ( screenY + self:GetTall() - 20 ) ) then

            self:SetCursor( "sizenwse" )
            return

        end

        if ( self.Hovered && self:GetDraggable() && mousey < ( screenY + 24 ) ) then
            self:SetCursor( "sizeall" )
            return
        end

        self:SetCursor( "arrow" )

        -- Don't allow the frame to go higher than 0
        if ( self.y < 0 ) then
            self:SetPos( self.x, 0 )
        end
    end

    return fr2
end

local bg = Material("models/props_combine/combine_interface_disp", "noclamp smooth")

local function OpenPDAMenu()
    if pda then
        pda:Remove()
    end


    pda = vgui.Create('DFrame')
    pda:SetSize(ScrW(),ScrH())
    pda:MakePopup()
    pda:SetTitle('')
    pda:Center()
    pda:SetDraggable(false)
    pda:ShowCloseButton()

    -- pda:SetPos(0,0)
    pda.Paint = function( self, w, h )
        -- draw.RoundedBox(0,0,0,w,24,Color(40,40,40,255))
        draw.Icon(0,0,w,h, bg, color_white)
        draw.RoundedBox(0,0,0,w,h,Color(47,137,252,90))
    end

    local icons =  vgui.Create( "DListLayout", pda )
    icons:SetSize( 74, 74 )
    icons:SetPos( 70, 24+70 )
    icons:SetZPos( -32768 )

    function CreateNewIcon(title, icon, cback)
        local btn = vgui.Create('DButton')
        btn:SetSize(74,74)
        btn:SetText('')
        btn.title = title
        btn.icon = icon
        btn.Paint = function( self, w, h )
            draw.Icon(12,4,w-24,h-24, self.icon, color_white)
            draw.ShadowSimpleText(self.title, 'font_base_12', w/2, h-18, color_white, 1, 0 )
        end

        btn.DoClick = function( self )
            cback( self )
        end

        icons:Add( btn )
    end

    local db = true
    CreateNewIcon('База данных', Material('icon16/database.png'), function( self )
        if db then
            local em = OpenNewPanel( 200, 80, 300, 600, 'База данных' )
            db = false
            em.OnClose = function()
                db = true
            end

            local layot_players =  vgui.Create( "DListLayout", em )
            layot_players:SetSize( 300, em:GetTall() )
            layot_players:SetPos( 0, 24 )
            em:SetZPos( 32768 )

            local loyal_types = rp.cfg.LoyalTypes
            for k, pl in pairs(player.GetAll()) do
                local job = rp.teams[pl:Team()]
                if loyal_types[job.type] then
                    local ldata = loyal_types[job.type]

                    local btn = vgui.Create('DButton')
                    btn:SetSize(layot_players:GetWide(),26)
                    btn:SetText('')

                    btn.Paint = function( self, w, h)
						if k % 2 == 1 then draw.RoundedBox(0,0,0,w,h,Color(255,255,255,1)) end

                        draw.SimpleText('ID: '..pl:GetNetVar("RPID"), "DermaDefault", 8, h/2, Color( 255, 255, 255, 255 ), 0, 1)
                        draw.SimpleText(ldata.text, "DermaDefault", w-8, h/2, ldata.col, 2, 1)
                    end

                    layot_players:Add(btn)
                end
            end
        end
    end)

    -- CreateNewIcon('Snake', Material('icon16/link.png'), function( self )
    --     local em = OpenNewPanel( 200, 80, 600, 600, 'Snake' )

    --     local panel = vgui.Create('DPanel', em)
    --     panel:SetSize(em:GetWide(),em:GetTall()-24)
    --     panel:SetPos(0,24)
    --     panel.Paint = function( self, w, h ) end

    --     local snake_line = 2

    --     local snake = {}

    --     for i = 1, snake_line do
    --         snake[i] = vgui.Create('DPanel', panel)
    --         snake[i]:SetSize(20,20)
    --         snake[i]:SetPos(0,0)
    --         snake[i].Paint = function( self, w, h )
    --             draw.RoundedBox(0, 0, 0, w, h, color_white)
    --             draw.SimpleText(i, "DermaDefault", w/2, h/2, Color( 0, 0, 0, 255 ), 1, 1)
    --         end
    --     end

    --     local dir = { x = 0, y = 0 }
    --     local last_key = KEY_D
    --     snake[1].Think = function()
    --         if input.IsKeyDown( KEY_W ) and last_key ~= KEY_S then
    --             dir = { x = 0, y = -1 }
    --             last_key = KEY_W
    --         elseif input.IsKeyDown( KEY_S ) and last_key ~= KEY_W then
    --             dir = { x = 0, y = 1 }
    --             last_key = KEY_S
    --         elseif input.IsKeyDown( KEY_D ) and last_key ~= KEY_A then
    --             dir = { x = 1, y = 0 }
    --             last_key = KEY_D
    --         elseif input.IsKeyDown( KEY_A ) and last_key ~= KEY_D then
    --             dir = { x = -1, y = 0 }
    --             last_key = KEY_A
    --         end
    --     end

    --     local function IsBreak()
    --         for i = 2, snake_line do
    --             if snake[i] and IsValid(snake[i]) and snake[1]:GetPos() == snake[i]:GetPos() then
    --                 return true
    --             end
    --         end
    --         return false
    --     end

    --     timer.Create('SnakeTimer', .1, 0, function()
    --         if snake[1] and IsValid(snake[1]) then
    --             if IsBreak() then
    --                 snake_line = 1
    --                 snake[1]:SetPos(0,0)
    --                 snake[1].next_pos = nil
    --                 return
    --             end

    --             local x, y = snake[1]:GetPos()
    --             local next_pos = {x = x+(dir.x*20), y = y+(dir.y*20)}
    --             for i = 1, snake_line do
    --                 local x, y = snake[i]:GetPos()
    --                 snake[i].next_pos = { x = x, y = y }
    --                 if snake[i-1] and IsValid(snake[i-1]) then
    --                     local x, y = snake[i-1]:GetPos()
    --                     if snake[i-1].next_pos and istable(snake[i-1].next_pos) then
    --                         x, y = snake[i-1].next_pos.x, snake[i-1].next_pos.y
    --                     end
    --                     snake[i]:SetPos(x, y)
    --                 end
    --             end
    --             snake[1]:SetPos(next_pos.x, next_pos.y)
    --         else
    --             timer.Destroy('SnakeTimer')
    --         end
    --     end)

    --     -- timer.Create('SnakeTimer_Test', .5, 0, function()
    --     --     snake_line = snake_line + 1

    --     --     snake[snake_line] = vgui.Create('DPanel', panel)
    --     --     snake[snake_line]:SetSize(20,20)
    --     --     snake[snake_line]:SetPos(x, y)
    --     --     snake[snake_line].Paint = function( self, w, h )
    --     --         draw.RoundedBox(0, 0, 0, w, h, color_white)
    --     --         draw.SimpleText(snake_line, "DermaDefault", w/2, h/2, Color( 0, 0, 0, 255 ), 1, 1)
    --     --     end
    --     -- end)
    -- end)

    CreateNewIcon('Розыск', Material('icon16/application_form_edit.png'), function( self )
        local em = OpenNewPanel( 200, 80, 460, 600, 'Розыск' )
        local layot_players =  vgui.Create( "DListLayout", em )
        layot_players:SetSize( em:GetWide(), em:GetTall() )
        layot_players:SetPos( 0, 24 )
        em:SetZPos( 32768 )

        for k, pl in pairs(player.GetAll()) do
            local job = rp.teams[pl:Team()]

            local button = vgui.Create('DButton')
            button:SetSize(layot_players:GetWide(),26)
            button:SetText('')

            local text, send
            button.Paint = function( self, w, h)
				if k % 2 == 1 then draw.RoundedBox(0,0,0,w,h,Color(255,255,255,1)) end
                if text then
                    draw.RoundedBox(0,0,0,w,h,Color(255,255,255,5))
                end

                if pl:IsWanted() and pl:GetWantedReason() then
                    draw.SimpleText('Причина розыска: '..pl:GetWantedReason(), "DermaDefault", w/2, 13, rp.col.Red, 1, 1)
                end

                draw.SimpleText(pl:Name(), "DermaDefault", 8, 13, Color( 255, 255, 255, 255 ), 0, 1)
                draw.SimpleText(team.GetName(pl:Team()), "DermaDefault", w-8, 13, team.GetColor(pl:Team()), 2, 1)
                if text then
                    draw.SimpleText('Причина: ', "DermaDefault", 8, 26+13, Color( 255, 255, 255, 255 ), 0, 1)
                end
            end
            button.DoClick = function( self )
                if not pl:IsWanted() then
                    if text then
                        text:Remove()
                        send:Remove()

                        button:SetTall(button:GetTall()/2)
                        text = nil
                    else
                        text = vgui.Create( "DTextEntry", button ) -- create the form as a child of frame
                        text:SetSize( 160, 26 )
                        text:SetPos( button:GetWide() - text:GetWide()-80, 26 )
                        button:SetTall(button:GetTall()*2)

                        send = vgui.Create('DButton', button)
                        send:SetSize( 80, 26 )
                        send:SetPos( button:GetWide() - send:GetWide(), 26 )
                        send:SetText('Объявить')
                        send.DoClick = function( self )
                            net.Start('Combine_WantedPlayer')
                                net.WriteString(pl:SteamID())
                                net.WriteString(text:GetValue())
                            net.SendToServer()
                        end
                    end
                end
                -- text:SetText( "" )
            end

            layot_players:Add(button)
        end
    end)

	if rp.cfg.CanManageStalker[LocalPlayer():Team()] then
		CreateNewIcon('Персонал', Material('icon16/user_gray.png'), function( self )
			local em = OpenNewPanel( 200, 80, 460, 600, 'Персонал' )
			local layot_players =  vgui.Create( "DListLayout", em )
			layot_players:SetSize( em:GetWide(), em:GetTall() )
			layot_players:SetPos( 0, 24 )
			em:SetZPos( 32768 )

			for k, pl in pairs(player.GetAll()) do
				if not pl:IsCP() or pl == LocalPlayer() then return end

				local job = rp.teams[pl:Team()]

				local panel = vgui.Create('DPanel')
				panel:SetSize(layot_players:GetWide(),26)
				panel.Paint = function( self, w, h)
					if k % 2 == 1 then draw.RoundedBox(0,0,0,w,h,Color(255,255,255,1)) end
					draw.SimpleText(pl:Name(), "DermaDefault", 8, 13, Color( 255, 255, 255, 255 ), 0, 1)
					draw.SimpleText(team.GetName(pl:Team()), "DermaDefault", w-8-130, 13, team.GetColor(pl:Team()), 2, 1)
				end

				local button = vgui.Create('DButton', panel)
				button:SetSize(130,26)
				button:SetPos(panel:GetWide()-button:GetWide(), 0)
				button:SetText('Сделать Сталкером')

				button.DoClick = function( self )
					net.Start('Combine_ForceStalker')
						net.WriteString(pl:SteamID())
					net.SendToServer()
				end

				layot_players:Add(panel)
			end
		end)
	end

    CreateNewIcon('Силовые щиты', Material('icon16/shield.png'), function( self )
        local em = OpenNewPanel( 200, 80, 460, 600, 'Силовые щиты' )
        local layot_shields =  vgui.Create( "DListLayout", em )
        layot_shields:SetSize( em:GetWide(), 24 )
        layot_shields:SetPos( 0, 24 )
        em:SetZPos( 32768 )

        for k, ent in pairs(ents.FindByClass('forcefield')) do
            local button = vgui.Create('DButton')
            button:SetSize(layot_shields:GetWide(),26)
            button:SetText('')

            local text, send
            button.Paint = function( self, w, h)
				if k % 2 == 1 then draw.RoundedBox(0,0,0,w,h,Color(255,255,255,1)) end
                draw.SimpleText('Силовое поле #'..ent:EntIndex(), "DermaDefault", 8, 13, Color( 255, 255, 255, 255 ), 0, 1)
                local po = ent:GetNetVar('PoliceOnly')
                draw.SimpleText(po and 'Закрыто' or 'Открыто', "DermaDefault", w-8, 13, po and rp.col.Red or rp.col.Green, 2, 1)
            end
            button.DoClick = function( self )
                net.Start('Combine_ToggleShield')
                    net.WriteUInt(ent:EntIndex(), 32)
                net.SendToServer()
            end

            layot_shields:Add(button)
        end
    end)

    CreateNewIcon('Терминал', Material('icon16/application_osx_terminal.png'), function( self )
        local em = OpenNewPanel( 200, 80, 700, 360, 'Терминал' )
        local panel = vgui.Create( "RichText", em )
        panel:Dock( FILL )
        panel.Paint = function( self, w, h )
            draw.RoundedBox(0, 0, 0, w, h, Color(10,10,10,200))
        end

        panel.Think = function( self )
            -- self:SetText( string.Implode('\n', nw.GetGlobal('CPTerminal')) )
			self:SetText( '' )
			if nw.GetGlobal('CPTerminal') then
				for _, text in pairs(nw.GetGlobal('CPTerminal')) do
					self:AppendText( text..'\n' )
				end
			end
            -- self:SetText( "#ServerBrowser_ESRBNotice" )
        end

        em:SetZPos( 32768 )
    end)

    CreateNewIcon('Выйти', Material('icon16/door.png'), function( self )
        pda:Close()
    end)
end

net.Receive('Combine_TerminalOpenMenu', OpenPDAMenu)
