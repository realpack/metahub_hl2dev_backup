local context_left, context_right
local sup_panel

local function OpenContextMenu()

    local contextoptions = {
        { text = 'Выбросить деньги', func = function( self )
            Derma_StringRequest("Выкинуть деньги.", "Сколько денег вы хотите сбросить?", "", function(s)
                RunConsoleCommand("say", "/dropmoney " .. s)
            end)
        end, icon = Material('icon16/money.png') },
        { text = 'Передать деньги', func = function( self )
            Derma_StringRequest("Передать деньги.", "Сколько денег вы хотите передать?", "", function(s)
                RunConsoleCommand("say", "/addmoney " .. s)
            end)
        end, icon = Material('icon16/money.png') },
        { text = 'Выбросить оружие', func = function( self )
            -- Derma_StringRequest("Выкинуть деньги.", "Сколько денег вы хотите сбросить?", "", function(s)
                RunConsoleCommand("say", "/drop " .. LocalPlayer():GetActiveWeapon():GetClass())
            -- end)
        end, icon = Material('icon16/link.png') },
        { text = 'Донат', func = function( self )
            -- Derma_StringRequest("Выкинуть деньги.", "Сколько денег вы хотите сбросить?", "", function(s)
                 RunConsoleCommand("say", "/donate")
            -- end)
        end, icon = Material('icon16/coins.png') },
        { text = 'Рандом', func = function( self )
            -- Derma_StringRequest("Выкинуть деньги.", "Сколько денег вы хотите сбросить?", "", function(s)
                RunConsoleCommand("say", "/roll")
            -- end)
        end, icon = Material('icon16/sport_8ball.png') },
		{ text = 'Продать все двери', func = function( self )
            -- Derma_StringRequest("Выкинуть деньги.", "Сколько денег вы хотите сбросить?", "", function(s)
              RunConsoleCommand("say", "/sellall")
                -- netstream.Start('DoorSaleAll',nil)
            -- end)
        end, icon = Material('icon16/door.png') },
        { text = 'Награды', func = function( self )
            -- Derma_StringRequest("Выкинуть деньги.", "Сколько денег вы хотите сбросить?", "", function(s)
                RunConsoleCommand("say", "/tasks")
            -- end)
        end, icon = Material('icon16/rosette.png') },
        { text = 'Контент Сервера', func = function( self )
            gui.OpenURL( 'https://steamcommunity.com/workshop/filedetails/?id=1554992606' )
        end, icon = Material('icon16/link.png') },
        { text = 'Дискорд Сервера', func = function( self )
            gui.OpenURL( 'https://discord.gg/DRrZCdr' )
        end, icon = Material('icon16/link.png') },
        { text = 'Основные правила', func = function( self )
            gui.OpenURL( 'https://docs.google.com/document/d/1igeD8p3n_ebRnpMgcD6qMbkQBR5K6zpFkoTc3ctKQBY/preview' )
        end, icon = Material('icon16/link.png') },
        { text = 'Правила профессий', func = function( self )
            gui.OpenURL( 'https://docs.google.com/document/d/1jr6t06BH54W1rZparRhujVyV3A9cW2D9tBS3hD15VBo/preview' )
        end, icon = Material('icon16/link.png') },
    }

    if LocalPlayer():IsCP() then
        table.insert(contextoptions, { text = 'Снять/Надеть маску', func = function( self )
            RunConsoleCommand("say", "/mask")
        end, icon = Material('icon16/cog_error.png') })
    end

    if LocalPlayer():IsLoyal() then
        table.insert(contextoptions, { text = 'Вызвать ГО', func = function( self )
            RunConsoleCommand("say", "/sendloyal")
        end, icon = Material('icon16/shield.png') })
    end

	if rp.cfg.CanManageCode[LocalPlayer():Team()] then
        table.insert(contextoptions, { text = 'Объявить красный код', func = function( self )
            net.Start('Combine_SendRpCode')
				net.WriteString('red')
			net.SendToServer()
        end, icon = Material('icon16/flag_red.png') })
		table.insert(contextoptions, { text = 'Объявить желтый код', func = function( self )
            net.Start('Combine_SendRpCode')
				net.WriteString('yellow')
			net.SendToServer()
        end, icon = Material('icon16/flag_yellow.png') })
		table.insert(contextoptions, { text = 'Объявить рабочию фазу', func = function( self )
            net.Start('Combine_SendRpCode')
				net.WriteString('work')
			net.SendToServer()
        end, icon = Material('icon16/flag_blue.png') })
		table.insert(contextoptions, { text = 'Объявить зеленый код', func = function( self )
            net.Start('Combine_SendRpCode')
				net.WriteString('')
			net.SendToServer()
        end, icon = Material('icon16/flag_green.png') })
	end

	table.insert(contextoptions, { text = 'Очистить метки', func = function( self )
		rp.marks = {}
	end, icon = Material('icon16/layers.png') })

	local gps = {
        ['Регистрация в Городе'] = function()
            return Vector('806.701965 -2817.922119 752.0312500')
        end,
		['Цитадель'] = function()
			return Vector('3253.933594 696.443726 992.031250')
		end,
        ['Почта / Посылки'] = function()
            return Vector('928.696289 -1357.399658 788.299133')
        end,
        ['Офис ГСР'] = function()
            return Vector('4677.180664 694.036438 1040.031250')
        end,
        ['Завод Сити 18'] = function()
            return Vector('731.828613 151.818115 816.639771')
        end,
        ['Жилой Блок'] = function()
            return Vector('-1550.860840 -96.398201 757.363403')
        end,
        ['Центр Лояльности'] = function()
            return Vector('-651.749695 -1403.625000 745.714233')
        end,
        ['КПП D2'] = function()
            return Vector('-1030.447144 1791.348755 916.748657')
        end,
        ['Запретное Метро'] = function()
            return Vector('4170.765137 2850.187500 732.067200')
        end,
	}

	for name, func in pairs(gps) do
		table.insert(contextoptions, { text = string.format('Показать где "%s"', name), func = function( self )
			CreateMark( func(), name, '', 'icon16/arrow_in.png', 30 )
		end, icon = Material('icon16/arrow_in.png') })
	end

    context_left = vgui.Create('DPanel', g_ContextMenu)

    context_left:SetSize(900, 500)
    context_left:SetPos(-context_left:GetWide(),ScrH()*.5 - context_left:GetTall()*.5)
    context_left:MoveTo(10,ScrH()*.5 - context_left:GetTall()*.5, 0.1, 0)
	context_left.Paint = function( self, w, h ) end

    dlist = vgui.Create('DListLayout', context_left)
    dlist:SetSize(200,context_left:GetTall())
	dlist:SetPos(260, 0)
    dlist.Paint = function( self, w, h )
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0,130))
    end

    for k, tbl in pairs(contextoptions) do
        local btn = vgui.Create('DButton')
        btn:SetSize(200,20)
        btn:SetText('')
        btn.Paint = function( self, w, h )
            -- surface.SetDrawColor(130, 130, 130, 30)
            -- surface.DrawLine(0, h-1, w, h-1)

            draw.Icon(2,2,16,16,tbl.icon,color_white)
            draw.SimpleText(tbl.text, "font_base_small", 22, 3, Color( 240, 240, 240, 255 ), 0)

            if self:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,10))
            end
        end

        btn.DoClick = tbl.func
        dlist:Add( btn )
    end

    local type = rp.teams[LocalPlayer():Team()].type
    if not (rp.cfg and rp.cfg.VoiceCommands and rp.cfg.VoiceCommands[type]) then
		dlist:SetPos(0, 0)
	else
		scroll = vgui.Create('DScrollPanel', context_left)
		scroll:SetSize(250,context_left:GetTall())
		scroll.Paint = function( self, w, h ) end

		scroll.sbar = scroll:GetVBar()
		scroll.sbar.Paint = function( self, w, h ) draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 80)) end

		scroll.sbar:SetWide(6)

		function scroll.sbar:PerformLayout()
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
		scroll.sbar.btnGrip.Paint = function( self, w, h ) draw.RoundedBox(0, 0, 0, w, h, Color(200, 200, 200, 190)) end

		dlist = vgui.Create('DListLayout', scroll)
		dlist:SetSize(250,context_left:GetTall())
		dlist.Paint = function( self, w, h )
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,130))
		end

        for i, tbl in pairs(rp.cfg.VoiceCommands[type]) do
            local btn = vgui.Create('DButton')
            btn:SetSize(250,20)
            btn:SetText('')
            btn.Paint = function( self, w, h )
                -- surface.SetDrawColor(130, 130, 130, 30)
                -- surface.DrawLine(0, h-1, w, h-1)

                -- draw.Icon(4,4,16,16,tbl.icon,color_white)
                draw.SimpleText(i..'. '..tbl.title, "font_base_small", 5, 3, Color( 240, 240, 240, 255 ), 0)

                if self:IsHovered() then
                    draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,10))
                end
            end

            btn.DoClick = function( self )
                -- netstream.Start('SendVoiceCommand',snd)
                net.Start('Chat_PlayerSounds')
                    net.WriteString(tbl.sound)
                net.SendToServer()
            end

            dlist:Add( btn )
        end
    end

	if LocalPlayer():IsCP() then
		cpcodes = vgui.Create('DListLayout', context_left)
		cpcodes:SetSize(300,context_left:GetTall())
		if rp.cfg and rp.cfg.VoiceCommands and rp.cfg.VoiceCommands[type] then
			cpcodes:SetPos(470, 0)
		else
			cpcodes:SetPos(210, 0)
		end
		cpcodes.Paint = function( self, w, h )
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,130))
		end

		for name, text in pairs(rp.cfg.CPUpCodes) do
			local btn = vgui.Create('DButton')
			btn:SetSize(300,20)
			btn:SetText('')
			btn.Paint = function( self, w, h )
				draw.SimpleText(name, "font_base_small", 3, 3, Color( 240, 240, 240, 255 ), 0, 0)
				draw.SimpleText(text, "font_base_12", w-3, 3, Color( 190, 190, 190, 255 ), 2, 0)

				if self:IsHovered() then
					draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,10))
				end
			end

			btn.DoClick = function( self )
				net.Start('Combine_SendUpCode')
					net.WriteString(name)
				net.SendToServer()
			end
			cpcodes:Add( btn )
		end
	end

	if rp.cfg.SupCommander[LocalPlayer():Team()] then
		sup_panel = vgui.Create('DListLayout', context_left)
		sup_panel:SetSize(200,context_left:GetTall())
		if rp.cfg and rp.cfg.VoiceCommands and rp.cfg.VoiceCommands[type] then
			sup_panel:SetPos(780, 0)
		else
			sup_panel:SetPos(520, 0)
		end
		sup_panel.Paint = function( self, w, h )
			draw.RoundedBox(0,0,0,w,h,Color(0,0,0,130))
		end

		for k, pl in pairs(player.GetAll()) do
			local job = rp.teams[pl:Team()]
			if job.type == rp.cfg.SupTeamType then
				local btn = vgui.Create('DButton')
				btn:SetSize(200,20)
				btn:SetText('')
				btn.Paint = function( self, w, h )
					draw.SimpleText(pl:Name(), "font_base_small", 3, 3, Color( 240, 240, 240, 255 ), 0, 0)
					-- draw.SimpleText(pl:GetNetVar('CPProtocol'), "font_base_small", w-3, 3, Color( 240, 240, 240, 255 ), 2, 0)

					if self:IsHovered() then
						draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,10))
					end
				end

				btn.DoClick = function( self )
					local menu = DermaMenu()
					for i, p in pairs(rp.cfg.SupProtocols) do
						local opt = menu:AddOption( p, function()
							net.Start('Combine_SendProtocol')
								net.WriteUInt(i, 32)
								net.WriteString(pl:SteamID())
							net.SendToServer()
						end )
                        if pl:GetNetVar('CPProtocol') == p then
                            opt:SetIcon('icon16/tick.png')
                        end
					end
					menu:Open()
				end
				sup_panel:Add( btn )
			end
		end
	end

    ThirdMenu = vgui.Create('DFrame', g_ContextMenu)
    ThirdMenu:SetSize(200,220)
    ThirdMenu:SetPos(ScrW(), 10)
    ThirdMenu:MoveTo(ScrW()-ThirdMenu:GetWide()-10, 10, 0.1, 0)
    ThirdMenu:SetDraggable(false)
    ThirdMenu:ShowCloseButton(false)
    ThirdMenu:SetTitle('')
    ThirdMenu.Paint = function( self, w, h ) end

    local max_x, max_y = 120, 100
    local Slider = vgui.Create( "DSlider", ThirdMenu )
    Slider:SetSize( 200, 200 )
    Slider:SetPos( 0, 0 )
    Slider:SetLockX()
    Slider:SetLockY()
    Slider:SetSlideY(tonumber(thirtperson.z:GetString()))
    Slider:SetSlideX(tonumber(thirtperson.y:GetString()))
    Slider.Knob:SetSize(14,14)
    Slider.Knob.Paint = function( self, w, h )
        -- local col = self.Depressed and Color(0,165,255,255) or (self:IsHovered() and Color(190,190,190,255) or color_white)
        local col = self.Depressed and Color(0,165,255,255) or Color(0,165,255,230)
        draw.RoundedBox(0,0,0,w,h,col)
    end
    Slider.Paint = function( self, w, h )
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0,120))
        local y, z = self:GetSlideX(), self:GetSlideY()
        surface.SetDrawColor(Color(255,255,255,30))
        surface.DrawLine(y*w,0,y*w,h)
        surface.DrawLine(0,z*h,w,z*h)

        surface.DrawLine(0,w*.5,w,w*.5)
        surface.DrawLine(h*.5,0,h*.5,h)
        draw.SimpleText(' '..y*100, "DermaDefault", y*w, 0, color_white, 1, 0)
        draw.SimpleText(' '..z*100, "DermaDefault", h, z*h, color_white, 2, 1)

        thirtperson.y:SetString(y)
        thirtperson.z:SetString(z)
    end
    local ZSlider = vgui.Create( "DNumSlider", ThirdMenu )
    ZSlider:SetSize( 200, 20 )
    ZSlider:SetPos( 0, ThirdMenu:GetTall() - ZSlider:GetTall() )
    ZSlider.Paint = function( self, w, h )
        draw.RoundedBox(0,0,0,w,h,Color(0,0,0,120))
        surface.SetDrawColor(Color(255,255,255,30))
        surface.DrawLine(0,1,w,1)
    end

    ZSlider:SetConVar('thirtperson_x')
    ZSlider:SetMin( 40 )
    ZSlider:SetMax( 200 )
    ZSlider:SetDecimals( 0 )

    ZSlider.PerformLayout = function()
        ZSlider:GetTextArea():SetWide(0)
        ZSlider.Label:SetWide(0)
        ZSlider.Slider:SetPos(0,0)
        ZSlider.Slider.Knob:SetSize(18,18)
        ZSlider.Slider.Paint = function( self, w, h ) end
        ZSlider.Slider.Knob.Paint = function( self, w, h )
            local col = self.Depressed and Color(0,165,255,255) or Color(0,165,255,230)
            local pos_x = ZSlider:GetValue() == ZSlider:GetMax() and 0 or (ZSlider:GetValue() == ZSlider:GetMin() and 0 or 0)

            draw.RoundedBox(0,pos_x,1,w,h,col)
        end
    end
end


function GM:OnContextMenuClose()
    gui.EnableScreenClicker(false)
    if ( IsValid(ThirdMenu) ) then
        ThirdMenu:Close()
	end
    if ( IsValid( g_ContextMenu ) ) then
		g_ContextMenu:Close()
	end
    if ( IsValid( context_left ) ) then
		context_left:Remove()
	end

	LocalPlayer().context_menu = false
end

function GM:OnContextMenuOpen()
    -- Let the gamemode decide whether we should open or not..
	if ( !hook.Call( "ContextMenuOpen", GAMEMODE ) ) then return end

	if ( IsValid( g_ContextMenu ) && !g_ContextMenu:IsVisible() ) then
		g_ContextMenu:Open()
	end

    gui.EnableScreenClicker(true)
	OpenContextMenu()
	LocalPlayer().context_menu = true
end

hook.Add('OnReloaded','ContextMenu_OnReloaded',function()
    gui.EnableScreenClicker(false)
    if ( IsValid(ThirdMenu) ) then
        ThirdMenu:Close()
	end
    if ( IsValid( g_ContextMenu ) ) then
		g_ContextMenu:Close()
	end
    if ( IsValid( context_left ) ) then
		context_left:Remove()
	end
end)
