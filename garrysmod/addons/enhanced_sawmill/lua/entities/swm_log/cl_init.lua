include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or "Неизвестен"

	local TIMER;
	if (self:GetNWInt('timer') < CurTime()) then
		TIMER = 0
	else 
		TIMER = (self:GetNWInt('timer')-CurTime())
	end
	
	surface.SetFont("HUDNumber5")
	local text = "Stored:"
	local text2 = "Gasoline: "..self:GetNWInt("water")
	local text3 = "Coca Leafs: "..self:GetNWInt("leafs")
	local TextWidth = surface.GetTextSize(text)
	local TextWidth2 = surface.GetTextSize(text2)
	local TextWidth3 = surface.GetTextSize(text3)
	local text4 = "Needs:"
	local text5 = "Gasoline: "..self:GetNWInt("need_water")
	local text6 = "Coca Leafs: "..self:GetNWInt("need_leafs")
	local TextWidth4 = surface.GetTextSize(text4)
	local TextWidth5 = surface.GetTextSize(text5)
	local TextWidth6 = surface.GetTextSize(text6)

	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	
	local TextAng = Ang
	local width = self:GetNWInt('width')
	
	local color
	if (TIMER > 0) then
		color = {150, 50}
	else
		color = {0 ,150}
	end
	
	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(Pos+Ang:Right()*-20+Ang:Up()*15+Ang:Forward()*-7, Ang, 0.1)
			draw.SimpleTextOutlined( "Stage 1", "HUDNumber5", 26, 0, Color(255,255,255,255), 0, 0, 1, Color(0,0,0,150) )
		cam.End3D2D()
		
		cam.Start3D2D(Pos+Ang:Right()*-15+Ang:Up()*15+Ang:Forward()*-7, Ang, 0.08)
			draw.RoundedBox( 0, -6, -5, width, 47, Color(0,255,0,color[1]) )
			draw.RoundedBox( 0, -5, -4, TextWidth3+30, 45, Color(0,0,0,color[2]) )
			draw.SimpleTextOutlined( "Process: "..string.ToMinutesSeconds(TIMER), "HUDNumber5", 0, 0, Color(255,255,255,255), 0, 0, 1, Color(0,0,0,150) )
		cam.End3D2D()

		cam.Start3D2D(Pos+Ang:Right()*-9+Ang:Up()*15+Ang:Forward()*-7, Ang, 0.09)
			draw.RoundedBox( 0, -5, -19, TextWidth3+9, 115, Color(0,0,0,150) )
			draw.SimpleTextOutlined( text, "HUDNumber5", 40, -14, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
			draw.SimpleTextOutlined( text2, "HUDNumber5", 0, 24, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
			draw.SimpleTextOutlined( text3, "HUDNumber5", 0, 60, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
		cam.End3D2D()
		
		cam.Start3D2D(Pos+Ang:Right()*2+Ang:Up()*15+Ang:Forward()*-7, Ang, 0.09)
			draw.RoundedBox( 0, -5, -19, TextWidth6+9, 115, Color(0,0,0,150) )
			draw.SimpleTextOutlined( text4, "HUDNumber5", TextWidth4*0.5, -14, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
			draw.SimpleTextOutlined( text5, "HUDNumber5", 0, 24, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
			draw.SimpleTextOutlined( text6, "HUDNumber5", 0, 60, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
		cam.End3D2D()
	end
end
