include('shared.lua')

surface.CreateFont( "font_base_large", {
	font = "Arial",
	extended = true,
	size = 100,
	weight = 500,
})

function ENT:Draw()
	self:DrawModel()

	-- if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
	-- 	local Ang = LocalPlayer():GetAngles()

	-- 	Ang:RotateAroundAxis( Ang:Forward(), 90)
	-- 	Ang:RotateAroundAxis( Ang:Right(), 90)

	-- 	cam.Start3D2D(self:GetPos()+self:GetUp()*80, Ang, 0.05)
	-- 		render.PushFilterMin(TEXFILTER.ANISOTROPIC)
	-- 			draw.SimpleTextOutlined( 'Заведующий складом', "font_base_large", -3, 0, Color(173,236,168), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	-- 			draw.SimpleTextOutlined( 'Этому человеку надо отдать ящик, чтобы получить денег за доставку.', "font_base_54", -3, 100, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
	-- 		render.PopFilterMin()
	-- 	cam.End3D2D()
	-- end
end
