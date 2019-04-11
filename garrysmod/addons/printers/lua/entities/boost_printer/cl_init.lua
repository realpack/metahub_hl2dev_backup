include("shared.lua")

function ENT:Initialize()
	self.StarMaterial = Material( "icon16/star.png", "noclamp")
	self.conf = boost_printers.list[self.printer_type]
end

function ENT:GetOwnerName()
	local ply = self.ItemOwner

	return ply and ply.Name and ply:Name() or "Unknown"
end

function ENT:Draw()
	self:DrawModel()
	if self:GetPos():Distance(LocalPlayer():GetPos()) < 500 then -- How far people can see printer UI

		local Pos = self:GetPos()
		local Ang = self:GetAngles()

		Ang:RotateAroundAxis(Ang:Up(), 90)

		cam.Start3D2D(Pos + Ang:Up() * 10.8 + Ang:Forward() * -15 + Ang:Right() * -16.1, Ang, 0.11)
			draw.RoundedBox( 0, 0, 0, 275, 275, Color(20,20,20,255) )
			draw.RoundedBox( 0, 10, 59, 255, 60, Color(40,40,40,255) )
			draw.RoundedBox( 0, 10, 127, 120, 90, Color(40,40,40,255) )
			draw.RoundedBox( 0, 139, 127, 126, 90, Color(40,40,40,255) )
			draw.RoundedBox( 0, 0, 0, 275, 50, self.conf.color )
			surface.DrawOutlinedRect( 0, 0, 275, 275 )
			surface.DrawOutlinedRect( 1, 1, 273, 273 )
			draw.TexturedQuad({
				texture = surface.GetTextureID "gui/gradient_up",
				color = self.conf.gradient,
				x = 0,
				y = 0,
				w = 275,
				h = 50
			})
			surface.SetDrawColor(self.conf.color)
			draw.RoundedBox( 0, 0, 225, 275, 50, self.conf.color )
			draw.TexturedQuad({
				texture = surface.GetTextureID "gui/gradient_up",
				color = self.conf.gradient,
				x = 0,
				y = 225,
				w = 275,
				h = 50
			})
			draw.DrawText( self.conf.name, "font_base", 137.5, 10, Color(255,255,255,255), TEXT_ALIGN_CENTER )

			draw.DrawText(self:GetOwnerName(), "font_base", 137.5, 235, Color(255,255,255,255), TEXT_ALIGN_CENTER )
			draw.DrawText( "Скорость:", "font_base", 25, 60, Color(255,255,255,255), TEXT_ALIGN_LEFT )

			for i=0,8 do
				if self:GetPrintSpeed() > i then
					surface.SetMaterial( self.StarMaterial )
					surface.SetDrawColor( Color(255, 255, 255, 255) )
					surface.DrawTexturedRect( 25+20*i, 95, 16, 16 )
				else
					surface.SetMaterial( self.StarMaterial )
					surface.SetDrawColor( Color(20, 20, 20, 255) )
					surface.DrawTexturedRect( 25+20*i, 95, 16, 16 )
				end
			end

			draw.RoundedBox( 0, 210, 80, 46, 30, Color(0,150,0,255) )
			draw.RoundedBox( 0, 212, 82, 42, 26, Color(0,0,0,150) )

			draw.DrawText( "+++", "Trebuchet24", 218, 83, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			draw.RoundedBox( 0, 17, 160, 100, 50, Color(200,200,200,255) )
			draw.RoundedBox( 0, 21, 164, 92, 42, Color(60,60,60,255) )

			local Col2 = Color(0,140,0,255)
			local Col3 = Color(0,180,0,255)
			if self:GetBattery() > 0 and self:GetBattery() < 25 then
				Col2 = Color(140,0,0,255)
				Col3 = Color(180,0,0,255)
			elseif self:GetBattery() > 25 and self:GetBattery() < 50 then
				Col2 = Color(180,180,0,255)
				Col3 = Color(240,240,0,255)
			elseif self:GetBattery() > 50 then
				Col2 = Color(0,180,0,255)
				Col3 = Color(0,220,0,255)
			end

			surface.SetDrawColor(Col3)
			surface.DrawRect(21, 164, 0.92*self:GetBattery(), 42)
			draw.TexturedQuad
			{
				texture = surface.GetTextureID "gui/gradient_up",
				color = Col2,
				x = 21,
				y = 164,
				w = 0.92*self:GetBattery(),
				h = 42
			}

			draw.RoundedBox( 0, 117, 173, 5, 25, Color(200,200,200,255) )

			draw.RoundedBox( 0, 40, 160, 4, 50, Color(200,200,200,255) )
			draw.RoundedBox( 0, 65, 160, 4, 50, Color(200,200,200,255) )
			draw.RoundedBox( 0, 90, 160, 4, 50, Color(200,200,200,255) )
			draw.RoundedBox( 0, 10, 127, 120, 27, Color(0,0,0,120) )

			draw.DrawText( "Батарея: "..self:GetBattery().."%", "font_base_18",70, 132, Color(255,255,255,255), TEXT_ALIGN_CENTER )

			draw.RoundedBox( 0, 139, 167, 126, 50, self.conf.color )
			draw.RoundedBox( 0, 142, 170, 120, 44, Color(0,0,0,150) )
			draw.RoundedBox( 0, 139, 127, 126, 27, Color(0,0,0,120) )
			draw.DrawText( "Доход: "..self:GetPrintRate() .."K/мин.", "font_base_18",200, 132, Color(255,255,255,255), TEXT_ALIGN_CENTER )
			draw.DrawText( "K"..self:GetPrintedMoney(), "font_base", 155, 176, Color(255,255,255,255), TEXT_ALIGN_LEFT )
		cam.End3D2D()
		Ang:RotateAroundAxis(Ang:Forward(), 90)
		cam.Start3D2D(Pos + Ang:Up() * 16.4 + Ang:Forward() * -15 + Ang:Right() * -10.2, Ang, 0.11)
			draw.RoundedBox( 0, 0, 0, 275, 90, Color(40,40,40,255) )
			surface.SetDrawColor(self.conf.color)
			surface.DrawOutlinedRect( 5, 0, 200, 86)
			surface.DrawOutlinedRect( 6, 1, 198, 84)
			draw.RoundedBox( 0, 0, 0, 275, 35, Color(0,0,0,150) )
			draw.RoundedBox( 0, 11, 41, 188, 40, self.conf.color )
			draw.RoundedBox( 0, 16, 46, 175, 30, Color(40,40,40,255) )
			draw.TexturedQuad
			{
				texture = surface.GetTextureID "models/shadertest/shader3",
				color = Color(255,255,255,255),
				x = 16,
				y = 46,
				w = 1.78*self:GetCooling(),
				h = 30
			}

			draw.DrawText( "Охлаждение: "..self:GetCooling().."%", "Trebuchet24",100, 5, Color(255,255,255,255), TEXT_ALIGN_CENTER )
		cam.End3D2D()
		cam.Start3D2D(Pos + Ang:Up() * 16.9 + Ang:Forward() * 7.9 + Ang:Right() * -10.2, Ang, 0.11)
			draw.RoundedBox( 0, 0, 0, 70, 90, Color(40,40,40,255) )
			draw.RoundedBox( 0, 0, 0, 70, 25, Color(0,0,0,150) )
			surface.SetDrawColor(self.conf.color)
			surface.DrawOutlinedRect( 0, 0, 70, 90)
			surface.DrawOutlinedRect( 1, 1, 68, 88)

			draw.RoundedBox( 0, 5, 30, 15, 53, Color(200,200,200,255) )
			local Col = Color(0,0,255,255)
			if self:GetHeat() > 0 and self:GetHeat() < 30 then
				Col = Color(0,0,255,255)
			elseif self:GetHeat() > 30 and self:GetHeat() < 60 then
				Col = Color(255,255,0,255)
			elseif self:GetHeat() > 60 then
				Col = Color(255,0,0,255)
			end
			draw.RoundedBox( 0, 6, 82, 13, -0.51 * self:GetHeat(), Col)

			draw.DrawText( "ТЕМП", "font_base_18", 35,5, Color(255,255,255,255), TEXT_ALIGN_CENTER )
			draw.DrawText( "Горячо", "Default", 22,30, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			draw.DrawText( "Средне", "Default", 22,50, Color(255,255,255,255), TEXT_ALIGN_LEFT )
			draw.DrawText( "Холод", "Default", 22,70, Color(255,255,255,255), TEXT_ALIGN_LEFT )
		cam.End3D2D()
	end
end


net.Receive("UpdatePrinter",function()
	local Tabl = net.ReadTable()
	local Entity = net.ReadEntity()

	Entity.Battery = Tabl.Battery
	Entity.Heat = Tabl.Heat
	Entity.Speed = Tabl.Speed
	Entity.PrintedMoney = Tabl.PrintedMoney
	Entity.Cooling = Tabl.Cooling
	Entity.PrintRate = Tabl.PrintRate
	Entity.Name = Tabl.Name
end)
