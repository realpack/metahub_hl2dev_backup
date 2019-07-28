local fr
local cmenu

local mat_chest = Material('meta_ui/metaui/chest_loot.png', 'noclamp smooth')
local mat_skills = Material('meta_ui/metaui/skills.png', 'noclamp smooth')

function GM:ShowSpare2()
	if IsValid(fr) then fr:SetVisible(false) end

    colorModify["$pp_colour_colour"] = 0
	local w, h = ScrW(), ScrH()

	fr = vgui.Create('DFrame')
    fr:SetTitle( '' )
    fr:SetSize(w, h)
    -- fr:ShowCloseButton( false )
    fr:MakePopup()
    fr:Center()

    fr.Created = SysTime();
    fr.Closed = nil;
    fr.Alpha = 0;


    fr.Paint = function( self, w, h )
        self.Alpha = (math.Clamp(SysTime() - self.Created, 0, 0.15) - math.Clamp(SysTime() - (self.Closed or math.huge), 0, 0.15)) / 0.15;
        draw.Blur(self)
        draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, self.Alpha * 200))

		draw.SimpleText('Магазин', "font_base_24", w*.5 + 36, h*.5 - 276, Color( 255, 255, 255, 255 ), 0, 0)
		draw.Icon( w*.5 + 4, h*.5 - 282, 32, 32, mat_chest, color_white )

		draw.SimpleText('Персонаж', "font_base_24", w*.5 -300 + 30, h*.5 - 276, Color( 255, 255, 255, 255 ), 0, 0)
		draw.Icon( w*.5 -300 - 4, h*.5 - 282, 32, 32, mat_skills, color_white )
    end

    fr.OnClose = function( self )
        colorModify["$pp_colour_colour"] = .5
    end

    local keydown = false
    function fr:Think()
        if input.IsKeyDown(KEY_F4) and keydown then
            fr.Closed = SysTime();
            timer.Simple(.1, function()
                if not (fr and IsValid(fr)) then return end
                fr:Close()
                if not (cmenu and IsValid(cmenu)) then return end
                cmenu:Remove()
            end)
        elseif (not input.IsKeyDown(KEY_F4)) then
            keydown = true
        end
    end

    local line_h = 20

    local ppanel = vgui.Create('DPanel', fr)
    ppanel:SetSize(300,500)
    ppanel:SetPos(fr:GetWide()*.5 - ppanel:GetWide() - 4, fr:GetTall()*.5 - ppanel:GetTall()*.5)
    ppanel.Paint = function( self, w, h )
        local health = LocalPlayer():Health() <= 100 and LocalPlayer():Health() or 100
        local armor = LocalPlayer():Armor() <= 255 and LocalPlayer():Armor() or 255
        local hunger = LocalPlayer():GetHunger() <= 100 and LocalPlayer():GetHunger() or 100
        local thirst = LocalPlayer():GetThirst() <= 100 and LocalPlayer():GetThirst() or 100
        draw.RoundedBox(0, 0, h-(1+line_h), w, line_h, Color(0,0,0,fr.Alpha * 40))
        draw.RoundedBox(0, 0, h-(1+line_h), (health/100)*w, line_h, Color(214,45,32,fr.Alpha * 190))
        draw.SimpleText('Здоровье: '..health, "font_base_small", 4, h-(2+line_h/2), Color( 255, 255, 255, fr.Alpha * 120 ), 0, 1)

        local issup = rp.teams[LocalPlayer():Team()].type == TEAMTYPE_SUP or LocalPlayer():Team() == TEAM_HERO4
        local hunger_title = issup and 'Энергия: ' or 'Голод: '

        draw.RoundedBox(0, 0, h-(1+line_h)*2, w, line_h, Color(0,0,0,fr.Alpha * 40))
        draw.RoundedBox(0, 0, h-(1+line_h)*2, (hunger/100)*w, line_h, Color(255,167,0,fr.Alpha * 190))
        draw.SimpleText(hunger_title..hunger..'%', "font_base_small", 4, h-(line_h*2)+(line_h/2)-2, Color( 255, 255, 255, fr.Alpha * 120 ), 0, 1)

        if not issup then
            draw.RoundedBox(0, 0, h-(1+line_h)*3, w, line_h, Color(0,0,0,fr.Alpha * 40))
            draw.RoundedBox(0, 0, h-(1+line_h)*3, (thirst/100)*w, line_h, Color(66,139,202,fr.Alpha * 190))
            draw.SimpleText('Жажда: '..thirst..'%', "font_base_small", 4, h-(line_h*3)+(line_h/2)-2, Color( 255, 255, 255, fr.Alpha * 120 ), 0, 1)
        else
            draw.SimpleText('(Пополнять около терминалов)', "font_base_12", w-2, h-(line_h*2)+(line_h/2), Color( 255, 255, 255, fr.Alpha * 120 ), 2, 1)
            h = h + line_h
        end

        draw.RoundedBox(0, 0, h-(1+line_h)*4, w, line_h, Color(0,0,0,fr.Alpha * 40))
        draw.RoundedBox(0, 0, h-(1+line_h)*4, (armor/255)*w, line_h, Color(66,139,202,fr.Alpha * 190))
        draw.SimpleText('Броня: '..math.Round(armor/2.55)..'%', "font_base_small", 4, h-(line_h*4)+(line_h/2)-2, Color( 255, 255, 255, fr.Alpha * 120 ), 0, 1)

        h = h -((line_h+2)*4)

        draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,fr.Alpha * 45))
        local tm = LocalPlayer():Team()
        local team_name = team.GetName(tm)
        local col = team.GetColor(tm)

        surface.SetFont('font_base_22')
        local wt, ht = surface.GetTextSize(team_name)
        draw.RoundedBox(0, 74, 10, wt + 8,ht,Color(0, 0, 0, fr.Alpha * 45))
        draw.SimpleText(team.GetName(tm), "font_base_22", 78, 10, Color(col.r, col.g, col.b, fr.Alpha * 160), 0, 0)

        local money = rp.FormatMoney(LocalPlayer():GetMoney())
        local wm, hm = surface.GetTextSize(money)
        draw.RoundedBox(0, 74, 36, wm + 8,hm,Color(0, 0, 0, fr.Alpha * 45))
        draw.SimpleText(rp.FormatMoney(LocalPlayer():GetMoney()), "font_base_22", 78, 36, Color(92,184,92, fr.Alpha * 160), 0, 0)
    end

    local spanel = vgui.Create('DCategoryList', fr)
    spanel:SetSize(300,500)
    spanel:SetPos(fr:GetWide()*.5 + 4, fr:GetTall()*.5 - spanel:GetTall()*.5)
    spanel.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,fr.Alpha * 45))
    end
	-- print(spanel:GetVBar())
	spanel:GetVBar():SetWide(0)

    -- ppanel

    local pos_cloth = {
        [4] = 1,
        [3] = 3,
        [2] = 2,
        [1] = 4,
    }

    local clothes = LocalPlayer():GetNetVar('Clothes')

    for body, pos in pairs(pos_cloth) do
        local cpanel = vgui.Create('DPanel', ppanel)
        cpanel:SetSize(60,60)
        cpanel:SetPos( 10, 10 + 62*(pos-1) )
        cpanel.Paint = function( self, w, h )
            draw.RoundedBox(0, 0, 0, w, h, Color(0,0,0,40))
        end

        if istable(clothes) and clothes[body] then
            local cloth = clothes[body]
            local btn = vgui.Create('DModelPanel', cpanel)
            btn:SetSize(60,60)
            btn:SetPos( 0, 0 )
            btn:SetText( '' )
            btn:SetModel( cloth.model )

            btn:SetLookAt(Vector(0, 0, 0))
            btn:SetCamPos(Vector(110,-10,90))
            btn:SetFOV(6)

            btn.DoClick = function( self, w, h )
                cmenu = DermaMenu()

                local option = cmenu:AddOption( "Снять", function()
                    RunConsoleCommand('rp', 'dropclothe', body)
                    fr:Close()
                end)

                local childrens = cmenu:GetCanvas():GetChildren()
                for k, option in pairs(childrens) do
                    option:SetTextColor(Color(240, 240, 240, 255))
                    option.Paint = function( self, w, h )
                        if self:IsHovered() then
                            draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,20))
                        end
                    end
                end

                cmenu:Open()

                cmenu.Paint = function( self, w, h )
                    draw.RoundedBox( 0, 0, 0, w, h, Color(50, 50, 50, 190) )
                end
            end
        end
    end

    local DModel = vgui.Create("DModelPanel", ppanel)
    DModel:SetSize(ppanel:GetWide()/1.4,350)
    DModel:SetPos(74,44)

    DModel:SetLookAt(Vector(0, 0, 35))
    DModel:SetCamPos(Vector(110,-10,40))
    DModel:SetFOV(25)
    DModel:SetAnimated( true )
    DModel:SetModel(LocalPlayer():GetNetVar('Model') or LocalPlayer():GetModel(), LocalPlayer():GetSkin())
    -- if LocalPlayer().GetModel and LocalPlayer():GetModel() and LocalPlayer():GetModel() ~= '' then
    --     DModel:SetModel(LocalPlayer():GetModel())
    -- end
    -- local model = LocalPlayer():GetModel()
    -- timer.Simple(.1, function()
    --     print(model)
    --     DModel:SetModel(model)
    -- end)

    DModel:GetEntity():SetSkin(LocalPlayer():GetSkin())
    DModel:GetEntity():SetBodygroup(1, LocalPlayer():GetBodygroup( 1 ))
    DModel:GetEntity():SetBodygroup(2, LocalPlayer():GetBodygroup( 2 ))
    DModel:GetEntity():SetBodygroup(3, LocalPlayer():GetBodygroup( 3 ))
    DModel:GetEntity():SetBodygroup(4, LocalPlayer():GetBodygroup( 4 ))
    DModel:GetEntity():SetBodygroup(5, LocalPlayer():GetBodygroup( 5 ))
    DModel:GetEntity():SetBodygroup(6, LocalPlayer():GetBodygroup( 6 ))
    DModel:GetEntity():SetBodygroup(7, LocalPlayer():GetBodygroup( 7 ))

    DModel.Angles = Angle(0,0,0)
    function DModel:DragMousePress()
        self.PressX, self.PressY = gui.MousePos()
        self.Pressed = true
    end
    function DModel:DragMouseRelease()
        self.Pressed = false
    end
    local rnd = math.random(1,4)
    if DModel and DModel.Entity and IsValid(DModel.Entity) then
        local seq = DModel.Entity:LookupSequence("pose_standing_0"..rnd)
        if seq and DModel.Entity.LookupSequence and DModel.Entity.SetSequence then
            DModel.Entity:SetSequence(seq)
        end
    end
    function DModel:LayoutEntity( ent )
        if not IsValid(ent) then return end
        if ( self.bAnimated ) then
            self:RunAnimation()
        end

        if ( self.Pressed ) then
            local mx, my = gui.MousePos()
            self.Angles = self.Angles - Angle( 0, ( self.PressX or mx ) - mx, 0 )

            self.PressX, self.PressY = gui.MousePos()
        end

        ent:SetAngles( self.Angles )
    end

    -- spanel

    local function DrawDModel(pnl,model)
        local pmodel = vgui.Create('ModelImage', pnl)
        pmodel:SetPos(0,0)
        pmodel:SetSize(24,24)
        pmodel:SetModel(model)

        return pmodel
    end

    local function PaintItemButton( pnl, w, h, name, price )
        local col = Color(0, 0, 0, fr.Alpha * 40)
        if pnl:IsHovered() then
            col = Color(255, 255, 255, fr.Alpha * 5)
        end

        draw.RoundedBox(0, 0, 0, w, h, col)
        draw.SimpleText(name, "font_notify", 26, h*.5, Color(255,255,255, fr.Alpha * 240), 0, 1)

        draw.SimpleText(rp.FormatMoney(tonumber(price or 0)), "font_notify", w-2, h*.5, Color(92,184,92, fr.Alpha * 160), 2, 1)
    end

    local entities = spanel:Add( "" )

    local rpanel = vgui.Create('DPanel')
    rpanel.Paint = function( self, w, h ) end

    local count = 0
	for k, v in ipairs(rp.entities) do
		if (v.allowed[LocalPlayer():Team()] == true) and v.cmd then
			count = count + 1

            local button = vgui.Create('DButton', rpanel)
            button:SetSize(spanel:GetWide()-4, 24)
            button:SetPos(0,1+(count-1)*25)
            button:SetText( '' )
            button.DoClick = function() RunConsoleCommand('rp', v.cmd:sub(2)) end

            local model = DrawDModel(button,v.model)
            button.Paint = function( self, w, h ) PaintItemButton( self, w, h, v.name, v.price ) end
        end
    end

    entities.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, 20, Color(0, 0, 0, 45))
        draw.SimpleText(string.format("Предметы (%d)",count), "font_base_small", 4, 10, color_white, 0, 1)
    end

    entities:SetContents( rpanel )

    local crates = spanel:Add( "" )

    local rpanel = vgui.Create('DPanel')
    rpanel.Paint = function( self, w, h ) end

    local count = 0
	for k, v in ipairs(rp.shipments) do
		if (v.allowed[LocalPlayer():Team()] == true) then
			count = count + 1

            local button = vgui.Create('DButton', rpanel)
            button:SetSize(spanel:GetWide()-4, 24)
            button:SetPos(0,1+(count-1)*25)
            button:SetText( '' )
            button.DoClick = function() RunConsoleCommand('rp', 'buyshipment', v.name) end

            local model = DrawDModel(button,v.model)
            button.Paint = function( self, w, h ) PaintItemButton( self, w, h, v.name, v.price ) end
        end
    end

    crates.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, 20, Color(0, 0, 0, 45))
        draw.SimpleText(string.format("Ящики (%d)",count), "font_base_small", 4, 10, color_white, 0, 1)
    end

    crates:SetContents( rpanel )

    local ammo = spanel:Add( "" )

    local rpanel = vgui.Create('DPanel')
    rpanel.Paint = function( self, w, h ) end

    local count = 0
	for k, v in ipairs(rp.ammoTypes) do
		count = count + 1

        local button = vgui.Create('DButton', rpanel)
        button:SetSize(spanel:GetWide()-4, 24)
        button:SetPos(0,1+(count-1)*25)
        button:SetText( '' )
        button.DoClick = function() RunConsoleCommand('rp', 'buyammo', v.ammoType) end

        local model = DrawDModel(button,v.model)
        button.Paint = function( self, w, h ) PaintItemButton( self, w, h, v.ammoType, v.price ) end
    end

    ammo.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, 20, Color(0, 0, 0, 45))
        draw.SimpleText(string.format("Боеприпасы (%d)",count), "font_base_small", 4, 10, color_white, 0, 1)
    end

    ammo:SetContents( rpanel )


    if LocalPlayer():GetJobTable().cook then
        local food = spanel:Add( "" )

        local rpanel = vgui.Create('DPanel')
        rpanel.Paint = function( self, w, h ) end

        local count = 1
        for k, v in ipairs(rp.Foods) do
            local button = vgui.Create('DButton', rpanel)
            button:SetSize(spanel:GetWide()-4, 24)
            button:SetPos(0,1+(count-1)*25)
            button:SetText( '' )
            button.DoClick = function() RunConsoleCommand('rp', 'buyfood', v.name) end

            local model = DrawDModel(button,v.model)
            button.Paint = function( self, w, h ) PaintItemButton( self, w, h, v.name, v.price ) end

            count = count + 1
        end

        food.Paint = function( self, w, h )
            draw.RoundedBox(0, 0, 0, w, 20, Color(0, 0, 0, 45))
            draw.SimpleText(string.format("Еда (%d)",count), "font_base_small", 4, 10, color_white, 0, 1)
        end


        food:SetContents( rpanel )
    end
end
