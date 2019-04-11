include("shared.lua")

function ENT:Draw()
	self:DrawModel()
	
	local Pos = self:GetPos()
	local Ang = Angle(0,LocalPlayer():GetAngles().y+180,0)

	Ang:RotateAroundAxis(Ang:Forward(), 90)
	Ang:RotateAroundAxis(Ang:Right(), 270)

	cam.Start3D2D(Pos + Ang:Up() * -1 + Ang:Forward() *-8 + Ang:Right() * -15, Ang, 0.11)
		draw.WordBox( 0, 0, 0, "Охлаждение", "font_base", Color(0,123,255,255), Color(255,255,255,255) )
	cam.End3D2D()
end