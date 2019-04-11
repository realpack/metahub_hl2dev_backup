include("shared.lua")

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()

	local owner = self:Getowning_ent()
	owner = (IsValid(owner) and owner:Nick()) or 'Никто'

	surface.SetFont("HUDNumber5")
	local text = "Руда: "..self:GetNWString("type")
	local TextWidth = surface.GetTextSize(text)

	Ang:RotateAroundAxis(Ang:Up(), 90)

	if LocalPlayer():GetPos():Distance(self:GetPos()) < self:GetNWInt("distance") then
		cam.Start3D2D(Pos+Ang:Up()*10+Ang:Right()*-0, Ang, 0.13)
			draw.RoundedBox( 0, -TextWidth*0.5, 0, TextWidth+8, 37, Color(255,25,0,170) )
			draw.RoundedBox( 0, -TextWidth*0.5+1, 1, TextWidth+6, 35, Color(0,0,0,170) )
			draw.SimpleTextOutlined( text, "HUDNumber5", -TextWidth*0.5 + 5, 0, Color(255,255,255,255), 0, 0, 1, Color(0,0,0) )
		cam.End3D2D()
	end
end
