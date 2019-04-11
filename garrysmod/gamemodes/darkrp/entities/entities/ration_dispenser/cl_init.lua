include('shared.lua')
 
function ENT:Draw()
	-- local position, angles = self:GetPos(), self:GetAngles()

	-- angles:RotateAroundAxis(angles:Forward(), 90)
	-- angles:RotateAroundAxis(angles:Right(), 270)

	-- cam.Start3D2D(position + self:GetForward()*7.6 + self:GetRight()*8.5 + self:GetUp()*3, angles, 0.1)
	-- 	render.PushFilterMin(TEXFILTER.NONE)
	-- 	render.PushFilterMag(TEXFILTER.NONE)

	-- 	draw.SimpleText((self:GetDisabled() and "OFFLINE" or (self:GetText() or "")), "font_base", 60, 30, Color(255, 255, 255), 1, 0)
	-- 	-- draw.RoundedBox(0,0,0,100,100,self.DispColor)

	-- 	render.PopFilterMin()
	-- 	render.PopFilterMag()
	-- cam.End3D2D()
end