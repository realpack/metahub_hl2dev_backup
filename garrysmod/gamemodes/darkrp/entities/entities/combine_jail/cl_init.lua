include("shared.lua")
local Menu

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
		local Ang = LocalPlayer():GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), 90)

		cam.Start3D2D(self:GetPos()+self:GetUp()*80, Ang, 0.05)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				draw.SimpleTextOutlined( 'Тюремный надзиратель', "font_base_large", -3, 0, Color(59,89,152), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				draw.SimpleTextOutlined( 'Тут можно сажать людей в тюрму', "font_base_54", -3, 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
			render.PopFilterMin()
		cam.End3D2D()
	end
end

net.Receive('NPCJail_OpenMenu', function()
-- netstream.Hook("NPCJail_OpenMenu", function(data)
    if IsValid(Menu) then
        Menu:Remove()
    end

    local alpha_lerp
    local select_team = 1
	local citizens = net.ReadTable()

    Menu = vgui.Create( "DFrame" )
    Menu:SetSize(ScrW(),ScrH())
    Menu:Center()
    Menu:MakePopup()
    Menu:SetTitle('')
    Menu.Paint = function( self, w, h )
        local x, y = self:GetPos()
        draw.Blur( self )
    end

    local panel = vgui.Create('DScrollPanel',Menu)
    panel:SetSize(400,600)
    panel:SetPos(Menu:GetWide()*.5 - panel:GetWide()*.5, Menu:GetTall()*.5 - panel:GetTall()*.5)
    panel.Paint = function( self, w, h )
    end

    -- local jail = vgui.Create('DNumberWang', panel)
    -- jail:SetSize(80,20)
    -- jail:SetPos(320,0)
    -- jail:SetValue(1)
    -- jail:SetMax( #JAIL_VECTORS )

    for i, ply in pairs(citizens) do
        local btn = vgui.Create('DButton', panel)
        btn:SetSize(400,30)
        btn:SetPos(0,30*i-30)
        btn:SetText('')
        btn.Paint = function( self, w, h )
            draw.RoundedBox(0, 0, 0, w, h, Color( 90, 90, 90, 255 ))
            draw.SimpleText('Посадить '..ply:Name(), "font_base_22", 34, h/2, Color( 255, 255, 255, 255 ), 0, 1)
        end
        btn.DoClick = function()
            -- netstream.Start('NPCJail_GoPlayer',{target = ply, jail_id = jail:GetValue()})
			net.Start('NPCJail_GoPlayer')
				net.WriteEntity(ply)
				-- net.WriteString(jail_id)
			net.SendToServer()
			Menu:Close()
        end

		local Avatar = vgui.Create( "AvatarImage", btn )
		Avatar:SetSize( 30, 30 )
		Avatar:SetPos( 0, 0 )
		Avatar:SetPlayer( pl, 64 )
    end
end)
