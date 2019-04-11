include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Eye1 = EyeAngles()
	local Ang = Angle(0, Eye1.y, 0)

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or 'Никто'

	surface.SetFont("HUDNumber5")
	local text = "Целостность: "..(100/MGS_ROCK_HEALTH)*self:GetNWInt("health").."%"
	local TextWidth = surface.GetTextSize(text)
	local width = ((TextWidth+10)/100)*((100/MGS_ROCK_HEALTH)*self:GetNWInt("health"))

	Ang:RotateAroundAxis(Ang:Up(), 90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 180)
	local TextAng = Ang

	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(Pos+Ang:Up()*60+Ang:Right()*-60, Ang, 0.13)
			draw.RoundedBox( 0, -TextWidth*0.5 , -1, width, 37, Color(255,25,0,170) )
			draw.RoundedBox( 0, -TextWidth*0.5 +1, 0, TextWidth+8, 35, Color(0,0,0,170) )
			draw.SimpleTextOutlined( text, "HUDNumber5", -TextWidth*0.5 + 5, 0, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
		cam.End3D2D()
	end
end
