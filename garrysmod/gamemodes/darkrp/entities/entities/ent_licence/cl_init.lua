include('shared.lua')

local color_black = Color(0,0,0)

function ENT:Draw()
	self:DrawModel()

	local pos = self:GetPos()

	local ang = self:GetAngles()
	local mypos = LocalPlayer():GetPos()

	local dist = pos:Distance(mypos)

	if dist > 350 or (mypos - mypos):DotProduct(LocalPlayer():GetAimVector()) < 0 then
		return
	end

	color_black.a = 350 - dist

	cam.Start3D2D(pos + ang:Up() * 0.9, ang, 0.012)
		draw.SimpleText('Gun Licence', '3d2d', 0, -50, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.SimpleText('Press E', '3d2d', 0, 50, color_black, TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end