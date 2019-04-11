include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or 'Никто'

	local TIMER;
	local width = self:GetNWInt("width");
	if (self:GetNWInt('timer') < CurTime()) then
		TIMER = 0
	else
		TIMER = self:GetNWInt('timer')-CurTime()
	end

	surface.SetFont("HUDNumber5")

	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	local TextAng = Ang

	local process = "Прогресс: "..string.ToMinutesSeconds(TIMER)
	local color
	if (TIMER > 0) then
		color = {150, 50}
	else
		color = {0 ,150}
	end

	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(Pos+Ang:Right()*-20+Ang:Up()*13+Ang:Forward()*-3.5, Ang, 0.15)
			draw.SimpleTextOutlined( "Переработка", "HUDNumber5", 0, 0, Color(255,255,255,255), 0, 0, 1, Color(0,0,0,150) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-14.5+Ang:Up()*13+Ang:Forward()*-2.5, Ang, 0.07)
			draw.RoundedBox( 0, -6, -5, width+2, 52, Color(0,255,0,color[1]) )
			draw.RoundedBox( 0, -5, -4, width, 50, Color(0,0,0,color[2]) )
			draw.SimpleTextOutlined( process, "HUDNumber5", 0, 5, Color(255,255,255,255), 0, 0, 1, Color(0,0,0,150) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-9+Ang:Up()*14+Ang:Forward()*-5.5, Ang, 0.09)
			draw.RoundedBox( 0, -5, -19, 227, 125, Color(0,0,0,150) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-9+Ang:Up()*14+Ang:Forward()*-5.5, Ang, 0.06)
			draw.SimpleTextOutlined( "[Информация]", "HUDNumber5", 75, -14, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
			draw.SimpleTextOutlined( "Вес: "..self:GetNWInt("fullmass").."kg", "HUDNumber5", 0, 24, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
			draw.SimpleTextOutlined( "Доход: "..self:GetNWInt("giveAmount").."$", "HUDNumber5", 0, 65, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
			draw.SimpleTextOutlined( "Ожидание: "..string.ToMinutesSeconds(self:GetNWInt("getOres")*MGS_CRUSH_TIME), "HUDNumber5", 0, 110, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
		cam.End3D2D()

		local Vector1 = self:LocalToWorld( Vector( 0, -40, -15 ) )
		local Vector2 = self:LocalToWorld( Vector( 0, -40, 35 ) )

		render.SetMaterial( Material( "cable/redlaser" ) )
		render.DrawBeam( Vector1, Vector2, 5, 1, 1, Color( 255, 255, 255, 255 ) )
	end
end
