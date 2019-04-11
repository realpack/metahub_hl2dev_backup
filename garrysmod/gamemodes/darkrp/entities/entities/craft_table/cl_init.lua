include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

function FindItem(cl)
	local next = false
	if not next then for _, it in pairs(rp.shipments) do if it.entity == cl or it.name == cl then next = it break end end end
	if not next then for _, it in pairs(rp.entities) do if it.ent == cl or it.name == cl then next = it break end end end
	if not next then for name, it in pairs(rp.Foods) do if name == rp.inv.Wl[cl] or it.name == cl then next = it next.name = name break end end end

	return next
end

local mat_craft = Material('materials/meta_ui/metaui/tools.png', 'smooth noclamp')
local CraftMenu
net.Receive('OpenCraftMenu', function()
    local alpha, alpha_lerp

    if CraftMenu or IsValid(CraftMenu) then
        CraftMenu:Remove()
    end

	CraftMenu = vgui.Create("DFrame")
	CraftMenu:SetSize(ScrW(),ScrH())
	CraftMenu:SetPos(0,0)
	CraftMenu:ShowCloseButton(false)
	CraftMenu:SetDraggable(false)
	CraftMenu:SetTitle("")

    CraftMenu.Process = .5
	CraftMenu.Paint = function( self, w, h )
		alpha = 230
		alpha_lerp = Lerp(FrameTime()*2,alpha_lerp or 0,alpha or 0) or 0
		local x, y = self:GetPos()
		-- draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), (alpha_lerp/100) )
        draw.Blur(self)
        draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, alpha_lerp))

        draw.Icon( 340, 194, 26, 26, mat_craft, color_white )
        draw.SimpleText('Рецепты: ', "font_base_24", 330+42, 194, color_white, 0, 0)
	end

	CraftMenu:MakePopup()

    local Close = vgui.Create( "DButton", CraftMenu )
    Close:SetSize( 30, 30 )
    Close:SetText('')
    Close:SetPos( CraftMenu:GetWide()-Close:GetWide()-18, 18 )
    Close.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, Color(191, 67, 57))
        draw.SimpleText('X', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
    end

    Close.DoClick = function( self )
        CraftMenu:Remove()
    end

    local layout = vgui.Create( "DListLayout", CraftMenu )
    layout:SetSize( 300, 400 )
    layout:SetPos( 20, 50 )

    local pits = {}

    local button_craft = vgui.Create('DButton', CraftMenu)
    button_craft:SetPos(330, 152);
    button_craft:SetText('')
    button_craft:SetDisabled(true)
    button_craft:SetSize(300, 30);
    button_craft.Item = false
    button_craft.Paint = function( self, w, h )
        local col = Color(51,102,255, 120)
        local item = button_craft.Item and FindItem(button_craft.Item) or false
        local title = item and 'Скрафтить "'..tostring(item.name or item.title)..'"' or 'Нужны материалы'
        draw.RoundedBox(0, 0, 0, w, h, col)
        draw.SimpleText(title, "font_base_18", w/2, h/2, color_white, 1, 1)

        if self:GetDisabled() then
            draw.RoundedBox(0, 0, 0, w, h, Color(90,90,90,170))
        end
    end
    button_craft.DoClick = function( self )
        if self.Item then
            net.Start('CraftItem')
                net.WriteString(self.Item)
            net.SendToServer()
        end
    end

    local function CheckCraft()
        local crafts = {}
        for craft_cl, recipe in pairs(rp.cfg.CraftRecipes) do
            crafts[craft_cl] = crafts[craft_cl] or {}

            for cl, count in pairs(recipe) do
                for _, pnl in pairs(pits) do
                    crafts[craft_cl][cl] = crafts[craft_cl][cl] or false
                    if crafts[craft_cl][cl] == false and pnl.Item == cl and pnl.Count == count then
                        crafts[craft_cl][cl] = true
                    end
                end
            end
        end

        local craft_recipe = false
        for item, data in pairs(crafts) do
            if not table.HasValue(data, false) then
                craft_recipe = item
            end
        end

        button_craft.Item = craft_recipe
        if craft_recipe then
            button_craft:SetDisabled(false)
        else
            button_craft:SetDisabled(true)
        end
    end

    local inv = table.Copy(rp.inv.Data)
    local btn = {}

    local key = 1
    local function LayoutAddButton(it)
        btn[key] = vgui.Create('DButton')
        btn[key]:SetSize( 200, 24 )
        btn[key]:SetText('')
        btn[key].Paint = function( self, w, h )
            local col = Color(0, 0, 0, 120)
            if self:IsHovered() then
                col = Color(255, 255, 255, 5)
            end
            if not (!it.SubTitle or it.SubTitle == "") then
                draw.SimpleText(it.SubTitle, "font_base_18", w-2, h*.5, color_white, 2, 1)
            end
            draw.RoundedBox(0, 0, 0, w, h, col)

            local title = it.Title or it.name or it.title
            draw.SimpleText(title, "font_base_18", 26, h*.5, color_white, 0, 1)
        end

        btn[key].DoClick = function( self )
            for i = 1, rp.cfg.CraftLimits do

                local item = FindItem(it.Title or it.name)
                local cl = item.ent or item.entity or item.class or item.name or it.Title
                local model = item.model
                if not pits[i].Item or pits[i].Item == cl then
                    if model == 'models/items/item_item_crate.mdl' then
                        model = item.model
                    end

                    if it.SubTitle and it.SubTitle ~= '' then
                        local number = false
                        for s in string.gmatch( it.SubTitle, "([0-9]*)" ) do
                            if tonumber(s) then
                                number = tonumber(s)
                            end
                        end

                        if number and number > 0 then
                            it.SubTitle = string.Replace( it.SubTitle, number, tostring(number - 1) )
                            pits[i].Item = cl
                            pits[i]:SetModel(model)
                            pits[i].btn:SetTooltip( it.Title or it.name )
                            local modelinfo = util.GetModelInfo( model )
                            local norminfo = util.KeyValuesToTablePreserveOrder( modelinfo.KeyValues )
                            local volume = norminfo[1]['Value'][8]['Value']

                            pits[i]:SetFOV(volume/6)

                            pits[i].Count = pits[i].Count + 1

                            if number == 1 then
                                table.remove(inv, key)
                                self:Remove()
                            end
                        end
                    else
                        pits[i].Item = cl
                        pits[i]:SetModel(model)
                        pits[i].btn:SetTooltip( it.Title or it.name )
                        local modelinfo = util.GetModelInfo( model )
                        local norminfo = util.KeyValuesToTablePreserveOrder( modelinfo.KeyValues )
                        local volume = norminfo[1]['Value'][8]['Value']

                        pits[i]:SetFOV(volume/6)

                        pits[i].Count = pits[i].Count + 1

                        table.remove(inv, key)
                        self:Remove()
                    end

                    CheckCraft() -- check for craft

                    break
                end
            end
        end

        icon = vgui.Create('ModelImage', btn[key])
        icon:SetMouseInputEnabled(false);

        icon:SetPos(0, 0);
        icon:SetSize(24, 24);
        icon:SetModel(it.Model or it.model)

        layout:Add( btn[key] )

        key = key + 1
    end

    for _, it in pairs(inv) do
        LayoutAddButton(it)
    end

    for i = 1, rp.cfg.CraftLimits do
        pits[i] = vgui.Create('DModelPanel', CraftMenu)
        pits[i]:SetPos(330 + (i-1)*102, 50);
        pits[i]:SetSize(100, 100);
        pits[i].Count = 0
        pits[i].Item = false
        pits[i]:SetModel( '' )

        pits[i]:SetLookAt(Vector(0, 0, 0))
        pits[i]:SetCamPos(Vector(110,-90,60))
        pits[i]:SetFOV(10)

        local btn = vgui.Create('DButton', pits[i])
        btn:SetSize( 100, 100 )
        btn:SetText('')
        btn.Paint = function( self, w, h )
            local col = Color(0, 0, 0, 120)
            if self:IsHovered() then
                col = Color(255, 255, 255, 5)
            end
            draw.RoundedBox(0, 0, 0, w, h, col)
            if pits[i].Count > 0 then
                draw.SimpleText(pits[i].Count..'x', "font_base_18", 4, 4, color_white, 0, 0)
            end
        end

        pits[i].btn = btn

        btn.DoClick = function( self )
            if pits[i].Item then
                LayoutAddButton(FindItem(pits[i].Item))

                pits[i].Count = pits[i].Count - 1
                if pits[i].Count <= 0 then
                    pits[i].Item = false
                    pits[i]:SetModel( '' )
                    pits[i].btn:SetTooltip( nil )

                end

                CheckCraft() -- check for craft
            end
        end

        pits[i].OverlayFade = 0
        pits[i].LayoutEntity = function( Entity ) return false end
    end

    local reps = vgui.Create('DScrollPanel', CraftMenu)
    reps:SetSize( rp.cfg.CraftLimits*102, 300 )
    reps:SetPos( 330, 224 )
    reps.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 120))
    end

    local layout = vgui.Create('DListLayout', reps)
    layout:SetSize( reps:GetWide()-4, reps:GetTall() )
    layout:SetPos( 4, 4 )
    layout.Paint = function( self, w, h ) end

    for class, need in pairs(rp.cfg.CraftRecipes) do
        local craft = vgui.Create('DPanel')
        craft:SetSize( craft:GetWide(), 64 )

        local i = 1
        for cl, count in pairs(need) do
            local it = FindItem(cl)
            local panel = vgui.Create('DModelPanel', craft)
            panel:SetSize( 60, 60 )
            panel:SetPos( (i-1)*62, 0 )

            panel:SetModel(it.model)
            panel:SetLookAt(Vector(0, 0, 0))
            panel:SetCamPos(Vector(110,-90,60))
            panel:SetFOV(10)

            local btn = vgui.Create('DButton', panel)
            btn:SetSize( 60, 60 )
            btn:SetPos( 0, 0 )
            btn:SetText('')
            btn.Paint = function( self, w, h )
                -- draw.SimpleText(it.name, "font_base_12", 4, 4, color_white, 0, 0)
                draw.SimpleText(count..'x', "font_base_small", 4, 4, color_white, 0, 0)
                draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 90))
            end
            btn:SetToolTip(it.name)

            i = i + 1
        end

        craft.Paint = function( self, w, h )
            draw.SimpleText('>', "font_base_45", 62*(i-.5), h/2, Color( 255, 255, 255, 190 ), 1, 1)
        end

        local it = FindItem(class)

        local panel = vgui.Create('DModelPanel', craft)
        panel:SetSize( 60, 60 )
        panel:SetPos( 62*i, 0 )

        print(class)
        PrintTable(it)
        panel:SetModel(it.model)
        panel:SetLookAt(Vector(0, 0, 0))
        panel:SetCamPos(Vector(110,-90,60))
        panel:SetFOV(10)

        local btn = vgui.Create('DButton', panel)
        btn:SetSize( 60, 60 )
        btn:SetPos( 0, 0 )
        btn:SetText('')
        btn.Paint = function( self, w, h )
            -- draw.SimpleText(it.name, "font_base_12", 4, 4, color_white, 0, 0)
            -- draw.SimpleText(count..'x', "font_base_small", 4, 4, color_white, 0, 0)
            draw.RoundedBox(0, 0, 0, w, h, Color(0, 0, 0, 90))
        end
        btn:SetToolTip(it.name)

        layout:Add(craft)
    end
end)
