include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

local mat_can = Material("metahub/can.png", "smooth noclamp")
local mat_ration = Material("metahub/ration.png", "smooth noclamp")
local food_mat = Material("metahub/food.png", "smooth noclamp")
net.Receive("rationPack", function()

	local int = 0
	local base = vgui.Create("DLabel")
		base:SetSize(ScrW(), ScrH())
		base:SetPos(0,0)
		base:SetAlpha(0)
		base:AlphaTo(255, 0.3, 0)
		base:MakePopup()
		base:SetText("")
		function base:Paint()
			draw.Blur(self, 5)
			draw.RoundedBox(0, 0, 0, self:GetWide(), self:GetTall(), Color(255,255,255,255))
		end

	local can = vgui.Create("DButton", base)
		can:SetSize(128, 128)
		can:SetText("")
		can:SetPos(ScrW()/2+256, ScrH()/2-128)
		function can:Paint(w, h)
			draw.Icon(0, 0, w, h, mat_can, color_white)
		end
		function can:DoClick()
			can:MoveTo(ScrW()/2-56, ScrH()/2-56, 0.3, 0)
			timer.Simple(0.15, function()
				int = int + 1
				surface.PlaySound("physics/plastic/plastic_barrel_impact_soft"..math.random(1,3)..".wav")
			end)
			timer.Simple(0.3, function() can:Remove() end)
		end

	local can = vgui.Create("DButton", base)
		can:SetSize(128, 128)
		can:SetText("")
		can:SetPos(ScrW()/2+256, ScrH()/2)
		function can:Paint(w, h)
			draw.Icon(0, 0, w, h, mat_can, color_white)
		end
		function can:DoClick()
			can:MoveTo(ScrW()/2-56, ScrH()/2-56, 0.3, 0)
			timer.Simple(0.15, function()
				int = int + 1
				surface.PlaySound("physics/plastic/plastic_barrel_impact_soft"..math.random(1,3)..".wav")
			end)
			timer.Simple(0.3, function() can:Remove() end)
		end

	local food = vgui.Create("DButton", base)
		food:SetSize(256, 256)
		food:SetText("")
		food:SetPos(ScrW()/2-256-256, ScrH()/2-128)
		function food:Paint(w, h)
			draw.Icon(0, 0, w, h, food_mat, color_white)
		end
		function food:DoClick()
			food:MoveTo(ScrW()/2-128, ScrH()/2-128, 0.3, 0)
			timer.Simple(0.15, function()
				int = int + 1
				surface.PlaySound("physics/plastic/plastic_barrel_impact_soft"..math.random(1,3)..".wav")
			end)
			timer.Simple(0.3, function() food:Remove() end)
		end

	local label = vgui.Create("DLabel", base)
		label:SetSize(512, 512)
		label:SetText("")
		label:Center()
		function label:Paint(w, h)
			draw.Icon(0, 0, w, h, mat_ration, color_white)
		end
		function label:Think()
			if int == 3 then
				int = 4
				surface.PlaySound("buttons/bell1.wav")

				label:SizeTo(400, 400, 0.3, 0)
				label:MoveTo(ScrW()/2-200, ScrH()/2-200, 0.3, 0)
				base:AlphaTo(0, 0.3, 0)
				timer.Simple(0.3, function() base:Remove() end)

				net.Start("rationSuccess") net.SendToServer(LocalPlayer())
			end
		end


		-- timer.Simple(3, function() base:Remove() end)

end)
