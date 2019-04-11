include("shared.lua")
ENT.RenderGroup = RENDERGROUP_OPAQUE

function ENT:Draw()
	self:DrawModel()

	if self:GetPos():Distance(LocalPlayer():GetPos()) < 1000 then
		local Ang = LocalPlayer():GetAngles()

		Ang:RotateAroundAxis( Ang:Forward(), 90)
		Ang:RotateAroundAxis( Ang:Right(), 90)

		cam.Start3D2D(self:GetPos()+self:GetUp()*85, Ang, 0.05)
			render.PushFilterMin(TEXFILTER.ANISOTROPIC)
				draw.ShadowSimpleText( 'Сомнительный Парень', "font_base_84", -3, 0, Color(245,176,65), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
				draw.ShadowSimpleText( 'По слухам скупает мет', "font_base_54", -3, 70, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color(0, 0, 0, 255))
			render.PopFilterMin()
		cam.End3D2D()
	end
end