include('shared.lua')

surface.CreateFont( "gmt.factory.n", {
	font = "Play",
	extended = true,
	size = 40,
	weight = 500,
} )

function ENT:Draw()
	self:DrawModel()

	local Pos = self:GetPos()
	local Ang = self:GetAngles()
	Ang:RotateAroundAxis(Ang:Up(), -90)
	Ang:RotateAroundAxis(Ang:Forward(), 90)

		local clr = rp.col.Blue
		if self:GetDisabled() then
			clr = rp.col.Red
		elseif self:GetDispensing() then
			clr = rp.col.Purple
		end
	cam.Start3D2D(Pos + Ang:Up() * 24, Ang, 0.06)
		draw.RoundedBox(0, -145, -105, 300, 50, Color(15,15,15, 150))
		draw.RoundedBox(0, -139, -99, 300-12, 50-12, Color(clr.r,clr.g,clr.b, 55))
		-- draw.ShadowSimpleText(self.PrintName, "font_base_24", -139+(300-12)/2, -99+(50-12)/2+2, Color(5,5,5), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
		draw.ShadowSimpleText(self.PrintName, "font_base_24", -139+(300-12)/2, -99+(50-12)/2, Color(255,255,255), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER)
	cam.End3D2D()
end
