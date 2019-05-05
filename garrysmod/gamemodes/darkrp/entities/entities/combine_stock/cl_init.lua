include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

local StockMenu
local icon_lock = Material("metahub/lock.png", 'noclamp smooth')
local icon_skull = Material("metahub/skull.png", 'noclamp smooth')

-- netstream.Hook( "OpenStockMenu", function( data )
net.Receive('OpenStockMenu', function()
    local alpha, alpha_lerp

	StockMenu = vgui.Create("DFrame")
	StockMenu:SetSize(ScrW(),ScrH())
	StockMenu:SetPos(0,0)
	-- StockMenu:ShowCloseButton(false)
	StockMenu:SetDraggable(false)
	StockMenu:SetTitle("")

    timer.Create('StockMenu_Timer', 30, 1, function()
        if StockMenu and IsValid(StockMenu) then
            StockMenu:Remove()
        end
    end)

    StockMenu.Process = .5
	StockMenu.Paint = function( self, w, h )
		alpha = 230
		alpha_lerp = Lerp(FrameTime()*2,alpha_lerp or 0,alpha or 0) or 0
		local x, y = self:GetPos()
		-- draw.DrawBlur( x, y, self:GetWide(), self:GetTall(), (alpha_lerp/100) )
        draw.Blur(self)

		draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, alpha_lerp))

        draw.RoundedBox(0,10,10,1000,20,Color(0, 0, 0, alpha_lerp/3))
        draw.RoundedBox(0,10,10,1000*StockMenu.Process,20,Color(255, 255, 255, alpha_lerp))

        draw.SimpleText('Время на попытку: '..timer.TimeLeft('StockMenu_Timer'), "font_base_18", 10, 30, Color( 255, 255, 255, 255 ), 0, 0)
	end



	StockMenu:MakePopup()

    local Close = vgui.Create( "DButton", StockMenu )
    Close:SetSize( 30, 30 )
    Close:SetText('')
    Close:SetPos( StockMenu:GetWide()-Close:GetWide()-18, 18 )
    Close.Paint = function( self, w, h )
        draw.RoundedBox(0, 0, 0, w, h, Color(191, 67, 57))
        draw.SimpleText('X', "font_base_22", w/2, h/2, Color( 255, 255, 255, 255 ), 1, 1)
    end

    Close.DoClick = function( self )
        StockMenu:Remove()
    end

    local Checker = {}
    for i = 1, 5 do
        Checker[i] = vgui.Create('DButton', StockMenu)
        Checker[i]:SetPos(math.random(40,StockMenu:GetWide()-40), math.random(40,StockMenu:GetTall()-40))
        Checker[i]:SetSize(32,32)
        Checker[i]:SetText('')

        Checker[i].rotate = math.random(1,100)
        Checker[i].dir = Checker[i].rotate % 2 == 1


        Checker[i].DoClick = function( self )
            -- Checker[i]:SetPos(math.random(40,StockMenu:GetWide()-40), math.random(40,StockMenu:GetTall()-40))
            Checker[i]:MoveTo(math.random(40,StockMenu:GetWide()-40), math.random(40,StockMenu:GetTall()-40), .1, 0)
            StockMenu.Process = Checker[i].dir and StockMenu.Process + .05 or StockMenu.Process - .05
        end

        Checker[i].Paint = function( self, w, h )
            -- draw.RoundedBox(0, 0, 0, w, h, Color(191, 67, 57))
            self.rotate = self.dir and self.rotate-.2 or self.rotate+.2
            local col = self:IsHovered() and (self.dir and Color(255,0,0) or Color(0,255,0)) or color_white

            surface.SetDrawColor(col)
            surface.SetMaterial(icon_lock)
            surface.DrawTexturedRectRotated(w/2,h/2,24,24,self.rotate)
        end

        timer.Create('StockChecker_'..i, 5, 0, function()
            timer.Simple(math.random(1,4), function()
                if Checker[i] and IsValid(Checker[i]) then
                    -- Checker[i]:DoClick(Checker[i])
                    Checker[i]:MoveTo(math.random(40,StockMenu:GetWide()-40), math.random(40,StockMenu:GetTall()-40), .1, 0)
                    Checker[i].rotate = math.random(1,100)
                    Checker[i].dir = Checker[i].rotate % 2 == 1

                    if StockMenu.Process <= 0 then
                        StockMenu:Remove()
                        -- netstream.Start( "HackStockMenu", nil )
                        net.Start('HackStockMenu')
                        net.SendToServer()
                    end
                end
            end)
        end)
    end
end)
