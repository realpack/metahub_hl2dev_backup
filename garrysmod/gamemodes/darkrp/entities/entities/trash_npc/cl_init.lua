include("shared.lua")
local Menu

surface.CreateFont( "font_base_large", {
	font = "Arial",
	extended = true,
	size = 100,
	weight = 500,
})

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
		local Ang = LocalPlayer():GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), 90)

		cam.Start3D2D(self:GetPos()+self:GetUp()*80, Ang, 0.05)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				draw.SimpleTextOutlined( 'Сбыватель мусора', "font_base_large", -3, 0, Color(173,236,168), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined( 'Ему можно сбывать мусор и получать за это деньги', "font_base_54", -3, 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
			render.PopFilterMin()
		cam.End3D2D()
	end
end


net.Receive('NPCTrash_OpenMenu', function()
    if IsValid(Menu) then
        Menu:Remove()
    end

    local target = net.ReadEntity()

    local items = {}
    for _, item in pairs(rp.inv.Data) do
		for c, l in pairs(rp.inv.Wl) do
			if l == item.Title then
				item.Class = c
			end
		end

        if rp.cfg.Trash[item.Class] then
            table.insert(items, item)
        end
    end

    local alpha, alpha_lerp
    local select_team = 1

    Menu = vgui.Create( "DFrame" )
    Menu:SetSize(ScrW(),ScrH())
    Menu:Center()
    Menu:MakePopup()
    Menu:SetTitle('')
    Menu.Paint = function( self, w, h )
		alpha = 230
		alpha_lerp = Lerp(FrameTime()*2,alpha_lerp or 0,alpha or 0) or 0
		local x, y = self:GetPos()
		-- draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), (alpha_lerp/100) )
		draw.Blur(self)

		draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, alpha_lerp))

    end

    local panel = vgui.Create('DPanel',Menu)
    panel:SetSize(400,600)
    panel:SetPos(Menu:GetWide()*.5 - panel:GetWide()*.5, Menu:GetTall()*.5 - panel:GetTall()*.5)


    local panel_wide, panel_tall = panel:GetWide(), panel:GetTall()
    panel.Paint = function( self, w, h )
        -- draw.RoundedBox( 5, 0, 0, w, h, Color(130, 130, 130, 190) )
        -- draw.RoundedBox( 4, 1, 1, w-2, h-2, Color(60, 60, 60, 255) )

        -- draw.RoundedBoxEx( 4, 1, 1, w-2, 40, Color(65, 65, 65, 255), true, true, false, false )

        -- surface.SetDrawColor(130, 130, 130, 190)
        -- surface.DrawLine(0,40,w,40)

        draw.RoundedBox(0,0,40,w,h-40,Color(0,0,0,alpha_lerp/3))
        -- draw.RoundedBox(0,0,40,7,h-40,Color(0,0,0,alpha_lerp/3))

        -- if #items > 0 then
        --     local isfull = (#items/rp.cfg.InvLimit)*h
        --     draw.RoundedBox(0,0,h-isfull+40,7,isfull-40,Color(190,190,190,255))
        -- end

        -- draw.RoundedBox(0,0,40,7,(13/h),Color(190,190,190,alpha_lerp/3))

        draw.SimpleText('Инвентарь', "font_base_24", w*.5, 10, Color( 240, 240, 240, 255 ), 1)


        -- draw.SimpleText('Имя и фамилия персонажа:', "DermaDefault", panel_wide - right_side_wide + 6, 35, Color( 240, 240, 240, 255 ))
    end

    local DScrollPanel = vgui.Create("DScrollPanel", panel)
    DScrollPanel:SetPos(1, 41)
    DScrollPanel:SetSize(panel:GetWide()-2,panel:GetTall()-40)

    DScrollPanel.sbar = DScrollPanel:GetVBar()
    DScrollPanel.sbar.Paint = function( self, w, h ) end

    DScrollPanel.sbar:SetWide(6)

    function DScrollPanel.sbar:PerformLayout()
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
    DScrollPanel.sbar.btnGrip.Paint = function( self, w, h ) draw.RoundedBox(0, 0, 0, w, h, Color(130, 130, 130, 190)) end


	-- local sale_all = vgui.Create('DButton', Menu)
	-- sale_all:SetSize(panel:GetWide()-162,30)
	-- sale_all:SetPos(Menu:GetWide()*.5 - panel:GetWide()*.5, Menu:GetTall()*.5 + panel:GetTall()*.5 + 2)
	-- sale_all:SetText('')

	-- sale_all.Paint = function( self, w, h )
	-- 	draw.RoundedBox(0, 0, 0, w, h, Color(157, 71, 158, 255))
	-- 	draw.SimpleText('Продать все ', "font_base_22", w*.5, h*.5, Color( 240, 240, 240, 255 ), 1, 1 )
	-- end
	-- sale_all.DoClick = function()
	-- 	netstream.Start("NPCTrash_SaleAllItems", {npc = target});
	-- 	Menu:Close()
	-- end

	local close = vgui.Create('DButton', Menu)
	close:SetSize(160,30)
	close:SetPos(Menu:GetWide()*.5 - panel:GetWide()*.5, Menu:GetTall()*.5 + panel:GetTall()*.5 + 2)
	close:SetText('')

	close.Paint = function( self, w, h )
		draw.RoundedBox(0, 0, 0, w, h, Color(214, 45, 32, 255))
		draw.SimpleText('Закрыть', "font_base_22", w*.5, h*.5, Color( 240, 240, 240, 255 ), 1, 1 )
	end
	close.DoClick = function()
		Menu:Close()
	end
    -- DScrollPanel.Paint = function( self, w, h )
    -- 	-- draw.RoundedBox( 0, 0, 0, w, h, Color(130, 0, 130, 190) )
    -- end

    local btn_items = {}
    for k, item in pairs(items) do
        -- local item = FindItem(item.ID)

        btn_items[k] = vgui.Create('DButton', DScrollPanel)
        btn_items[k]:SetSize(DScrollPanel:GetWide(),24)
        btn_items[k]:SetPos(0,(24*k)-24)

        btn_items[k]:SetText('')

        btn_items[k].DoClick = function()
            local menu = DermaMenu()

            local option = menu:AddOption( "Продать за "..rp.FormatMoney(rp.cfg.Trash[item.Class]), function()
                -- netstream.Start("NPCTrash_SaleItem", {npc = target, item_id = item.ID});
				net.Start('NPCTrash_SaleItem')
					net.WriteString(item.ID)
					net.WriteEntity(target)
				net.SendToServer()

                Menu:Close()
            end)
            option.Icon = Material('metahub/cart.png')

            local childrens = menu:GetCanvas():GetChildren()
            for k, option in pairs(childrens) do
                local row_bottom = k == #childrens and true or false
                local row_top = k == 1 and true or false

                option:SetTextColor(Color(240, 240, 240, 255))
                option.Paint = function( self, w, h )
                    if not row_bottom then
                        surface.SetDrawColor(130, 130, 130, 30)
                        -- surface.DrawLine(0, h-1, w, h-1)
                    end

                    draw.Icon(6,2,16,16,self.Icon,color_white)

                    if self:IsHovered() then
                        draw.RoundedBoxEx(4, 0, 0, w, h, Color(255,255,255,20), row_top, row_top, row_bottom, row_bottom)
                    end
                end
            end

            menu:Open()

            menu.Paint = function( self, w, h )
                draw.RoundedBox( 4, 0, 0, w, h, Color(50, 50, 50, 255) )
            end
        end

        btn_items[k].Paint = function( self, w, h )
            -- draw.Icon(4,4,16,16,item.Icon,Color(190,190,190,190))
            draw.SimpleText(item.Title, "font_notify", 3, 3, Color( 240, 240, 240, 255 ), 0)

            -- draw.SimpleText(item.Name, "font_notify", 20, 0, Color( 240, 240, 240, 255 ), 0)

            if self:IsHovered() then
                draw.RoundedBox(0, 0, 0, w, h, Color(255,255,255,20))
            end

            surface.SetDrawColor(130, 130, 130, 30)
            -- surface.DrawLine(0, h-1, w, h-1)
        end
    end

end)
