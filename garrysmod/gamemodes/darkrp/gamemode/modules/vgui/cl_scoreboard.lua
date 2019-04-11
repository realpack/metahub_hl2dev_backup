local HeightLine = 26


local mat_wrench = Material('icons/wrench.png', 'noclamp smooth')
local mat_star = Material('icons/star.png', 'noclamp smooth')
local mat_key = Material('icons/key.png', 'noclamp smooth')
local mat_case = Material('icons/case.png', 'noclamp smooth')
local mat_hammer = Material('icons/hammer.png', 'noclamp smooth')
local mat_lines = Material('icons/lines.png', 'noclamp smooth')

local tblIconsGroups = {
	['founder'] = { col = Color(220,220,220,255), symbol = 'Основатель' },
    ['serverstaff'] = { col = Color(190,190,190,255), symbol = 'Персонал Сервера' },
    ['moderator'] = { col = Color(190,190,190,255), symbol = 'Модератор' },
	['apollo'] = { col = Color(190,190,190,255), symbol = 'Апполион'},
    ['thaumiel'] = { col = Color(190,190,190,255), symbol = 'Таумиель'},
    ['afina'] = { col = Color(190,190,190,255), symbol = 'Афина'},
    ['sponsor'] = { col = Color(190,190,190,255), symbol = 'Афина'},
    ['premium'] = { col = Color(190,190,190,255), symbol = 'Кетер'},
    ['keter'] = { col = Color(190,190,190,255), symbol = 'Кетер'},
    ['euclid'] = { col = Color(190,190,190,255), symbol = 'Евклид'},
    ['commander'] = { col = Color(190,190,190,255), symbol = 'Коммандер'},
	-- ['admin'] = { col = Color(190,190,190,255), symbol = '★', name = 'Администратор' },
	-- ['superadmin'] = { col = Color(190,190,190,255), symbol = '★', name = 'Главный Администратор' }
}

local function get_admins_count()
	local count = 0
	for k,v in pairs(player.GetAll()) do
		if v:IsAdmin() then count = count + 1 end
	end

	return count
end

team.SetColor( 0, Color(131,138,142) )
team.SetColor( 1001, Color(131,138,142) )

local MainPanel, Main
local alpha, alpha_lerp = 0, 0
function ScoreboardOpen()
	if not IsValid(Main) then
        alpha = 230

		LocalPlayer().Scoreboard = true
		Main = vgui.Create("DFrame")
		Main:SetSize(ScrW(),ScrH())
		Main:SetPos((ScrW()-Main:GetWide())/2,(ScrH()-Main:GetTall())/2)
		Main:SetTitle('')

        Main.Created = SysTime();
        Main.Closed = nil;
        Main.Alpha = 0;

		-- Main:Center()
		Main:SetDraggable(false)
		Main:ShowCloseButton(false)
		Main.Paint = function( self, w, h )
            self.Alpha = (math.Clamp(SysTime() - self.Created, 0, 0.15) - math.Clamp(SysTime() - (self.Closed or math.huge), 0, 0.15)) / 0.15;
            draw.Blur(self)
            draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, self.Alpha * 200))
		end


        MainPanel = vgui.Create('DScrollPanel', Main)
        MainPanel:SetSize(Main:GetWide()/1.4,Main:GetTall()/1.2)
        MainPanel:SetPos(Main:GetWide()*.5 - MainPanel:GetWide()*.5, Main:GetTall()*.5 - MainPanel:GetTall()*.5)

        local line_front = markup.Parse(string.format('<font=font_base_22><colour=255, 255, 255, 255>Сейчас играет <colour=175, 175, 175, 255>%s</colour> из <colour=175, 175, 175, 255>%s</colour> игроков. Текущая карта <colour=175, 175, 175, 255>%s</colour></colour></font>',
            #player.GetAll(),
            game.MaxPlayers(),
            game.GetMap()
        ))
        MainPanel.Paint = function( self, w, h )
            line_front:Draw( 0, 0, 0, 0 )
            -- draw.SimpleText('Сейчас играет '..#player.GetAll()..' из '..game.MaxPlayers()..' игроков. Текущая карта '..game.GetMap(), "font_base_22", 0, 0, color_white, 0, 0)
        end

        MainPanel.VBar:SetWide(0)

        local layout = vgui.Create( "DListLayout", MainPanel )
        layout:SetSize( MainPanel:GetWide(), MainPanel:GetTall() )
        layout:SetPos( 0, 30 )
        -- layout:SetSpace( 2 )

        --Draw a background so we can see what it's doing
        -- layout:SetPaintBackground( true )
        -- layout:SetBackgroundColor( Color( 0, 100, 100 ) )

        -- layout:MakeDroppable( "unique_name" ) -- Allows us to rearrange children

        local players = player.GetAll()
        table.sort(players, function(a, b)
			return a:Team() < b:Team()
		end)

        for i, pl in pairs(players) do
            local PlayerPanel = vgui.Create('DButton')
            PlayerPanel:SetTall(30)
            PlayerPanel:SetWide(MainPanel:GetWide())
            PlayerPanel:SetText('')
            PlayerPanel.Paint = function( self, w, h )
                if not pl or not IsValid(pl) then
                    return
                end

                local pcol = team.GetColor(pl:Team())
                h = 28
                if pl and pcol then
                    draw.RoundedBox(0,0,0,w,h,Color(110, 110, 110, 250))

                    -- local rpid = pl:GetRPID()
                    -- rpid = (rpid and rpid ~= '') and ' '..rpid..'' or '   ----  '

                    -- local tm = pl:Team()
                    -- local rank = pl:GetNWString('meta_rank')

                    -- surface.SetFont('font_base_22')
                    -- local wrt, _ = surface.GetTextSize(' '..rpid)

                    -- draw.RoundedBox(0, 28, 0, wrt, h, Color(pcol.r-12,pcol.g-12,pcol.b-12,255))

                    surface.SetFont('font_base_22')
                    local wgr = 0

                    -- local gender_string = pl:GetNetVar('Gender') == 0 and 'М' or 'Ж'
                    -- if tblIconsGroups[pl:GetUserGroup()] then
                    --     surface.SetFont('font_base_24')
                    --     wgr, _ = surface.GetTextSize(gender_string..' ')

                    --     draw.RoundedBox(0, 28, 0, wgr+5, h, Color( 0, 0, 0, 60 ))

                    --     draw.SimpleText(gender_string, "font_base_24", 33+1, h/2+1, Color( 0, 0, 0, 60 ), 0, 1)
                    --     draw.SimpleText(gender_string, "font_base_24", 33, h/2, Color( 255, 255, 255, 250 ), 0, 1)
                    -- end

                    local name = pl:Name()
                    draw.SimpleText(name, "font_base_22", 36+wgr+1, h/2+1, Color( 0, 0, 0, 60 ), 0, 1)
                    draw.SimpleText(name, "font_base_22", 36+wgr, h/2, Color( 255, 255, 255, 250 ), 0, 1)

                    surface.SetFont('font_base_22')
                    local wn, _ = surface.GetTextSize(name)

                    if not LocalPlayer():IsAdmin() then
                        local oldname = '( '..pl:SteamName()..' )'
                        draw.SimpleText(oldname, "font_base_22", 37+wgr+wn +1, h/2 +1, Color( 0, 0, 0, 60 ), 0, 1)
                        draw.SimpleText(oldname, "font_base_22", 37+wgr+wn, h/2, Color( 195, 195, 195, 255 ), 0, 1)
                    end


                    -- surface.SetFont('font_base_22')
                    -- local wt, _ = surface.GetTextSize(name)

                    if LocalPlayer():IsAdmin() then
                        local team_name = team.GetName(pl:Team())
                        draw.SimpleText('[ '..team_name..' ]', "font_base_18", w/2+1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
                        draw.SimpleText('[ '..team_name..' ]', "font_base_18", w/2, h/2, Color( 255, 255, 255, 230 ), 1, 1)
                    end



                    local tname = tm == 0 or tm == 1001 and 'Не выбрал персонажа' or team.GetName(tm)
                    tname = tname == true and 'Нету' or team.GetName(tm)
                    draw.SimpleText(tname, "font_base_22", w/2 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
                    draw.SimpleText(tname, "font_base_22", w/2 , h/2, Color( 255, 255, 255, 255 ), 1, 1)

                    if rank then
                        draw.SimpleText(rank, "font_base_22", w/3 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
                        draw.SimpleText(rank, "font_base_22", w/3 , h/2, Color( 255, 255, 255, 255 ), 1, 1)
                    end

                    if tblIconsGroups[pl:GetUserGroup()] then
                        local group_data = tblIconsGroups[pl:GetUserGroup()]
                        -- PrintTable(group_data)
                        surface.SetFont('font_base_22')
                        wgr, _ = surface.GetTextSize(group_data.symbol..' ')

                        draw.SimpleText(group_data.symbol, "font_base_22", w/1.3 +1, h/2+1, Color( 0, 0, 0, 60 ), 1, 1)
                        draw.SimpleText(group_data.symbol, "font_base_22", w/1.3, h/2, group_data.col, 1, 1)
                    end


                    if self:IsHovered() then

                        draw.RoundedBox(0,0,0,w,h,Color(230, 230, 230, 4))
                    end
                end

                draw.RoundedBox(0, w-10+1, 4+1, 6, 20, Color(0,0,0,60))
                draw.RoundedBox(0, w-17+1, 9+1, 6, 15, Color(0,0,0,60))
                draw.RoundedBox(0, w-24+1, 14+1, 6, 10, Color(0,0,0,60))

                local pg = pl:Ping()
                local pgcol = pl:Ping() < 100 and Color(119,184,0) or pg < 200 and Color(255,165,0) or Color(214,45,32)
                draw.RoundedBox(0, w-10, 4, 6, 20, pgcol)
                draw.RoundedBox(0, w-17, 9, 6, 15, pgcol)
                draw.RoundedBox(0, w-24, 14, 6, 10, pgcol)

                draw.SimpleText(pg, "font_base_22", w - 30 +1, h/2+1, Color( 0, 0, 0, 60 ), 2, 1)
                draw.SimpleText(pg, "font_base_22", w - 30 , h/2, Color( 255, 255, 255, 255 ), 2, 1)
            end

            PlayerPanel.DoClick = function( self )
 				if not IsValid(pl) then return end
				local rankData = serverguard.ranks:GetRank(serverguard.player:GetRank(LocalPlayer()))
				local commands = serverguard.command:GetTable()

				local bNoAccess = true
				local menu = DermaMenu(Main);
				menu:SetSkin("serverguard");
				menu:AddOption("Открыть профиль Steam", function()
					pl:ShowProfile()
				end):SetIcon("icon16/group_link.png");
				menu:AddSpacer()
				menu:AddOption("Скопировать SteamID", function()
					SetClipboardText(pl:SteamID());
				end):SetIcon("icon16/page_copy.png");
				menu:AddOption("Скопировать SteamID64", function()
					SetClipboardText(pl:SteamID64());
				end):SetIcon("icon16/page_copy.png");
				menu:AddOption("Скопировать ник", function()
					SetClipboardText(pl:Name());
				end):SetIcon("icon16/page_copy.png");

				menu:AddSpacer()
				local sub_commands = menu:AddSubMenu("Администрирование")
				for unique, data in pairs(commands) do
					if (data.ContextMenu and (!data.permissions or serverguard.player:HasPermission(LocalPlayer(), data.permissions))) then
						data:ContextMenu(pl, sub_commands, rankData); bNoAccess = false;
					end;
				end;
				menu:Open();
            end

            local Avatar = vgui.Create( "AvatarImage", PlayerPanel )
            Avatar:SetSize( 28, 28 )
            Avatar:SetPos( 0, 0 )
            Avatar:SetPlayer( pl, 64 )

            -- local DermaCheckbox = vgui.Create( "DCheckBox", PlayerPanel )
            -- DermaCheckbox:SetPos( PlayerPanel:GetWide()-DermaCheckbox:GetWide()-2, 2 )
            -- DermaCheckbox:SetValue( 0 )
            -- DermaCheckbox.Paint = function( self, w, h )
            --     draw.RoundedBox(4,0,0,w,h,color_white)
            --     if DermaCheckbox:GetChecked() then
            --         draw.RoundedBox(4,2,2,w-4,w-4,Color(119,184,0))
            --     end
            -- end


            layout:Add( PlayerPanel )
        end
	end
end

function ScoreboardClose()
	if IsValid(Main) then
        Main.Closed = SysTime();
		Main:Close()
		LocalPlayer().Scoreboard = false
        gui.EnableScreenClicker(false)
	end
end

function GM:ScoreboardShow()
	ScoreboardOpen()

	if IsValid(Main) then
		Main:Show()
		-- Main:MakePopup()
        gui.EnableScreenClicker(true)
		Main:SetKeyboardInputEnabled(true)
	end
end

function GM:ScoreboardHide()
    if MainPanel and IsValid(MainPanel) then
        MainPanel:Remove()
    end
	if IsValid(Main) then
        Main:SetKeyboardInputEnabled(false)
        LocalPlayer().Scoreboard = false

        alpha = 0
        Main.Closed = SysTime();
        timer.Simple(.1, function()
		    ScoreboardClose()
        end)
        gui.EnableScreenClicker(false)
	end
end

hook.Add('OnReloaded','CloseScoreboard_OnReloaded',function()
    if MainPanel and IsValid(MainPanel) then
        MainPanel:Remove()
    end
    if Main and IsValid(Main) then
        Main:Remove()
    end
    ScoreboardClose()
end)

if MainPanel and IsValid(MainPanel) then
    MainPanel:Remove()
end
if Main and IsValid(Main) then
    Main:Remove()
end
