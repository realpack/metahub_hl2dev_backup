include("shared.lua")

function SWEP:DrawHUD()
	draw.ShadowSimpleText("ЛКМ - Связать", "font_base_18", ScrW()-200, ScrH()-50, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	draw.ShadowSimpleText("ПКМ - Развязать", "font_base_18", ScrW()-200, ScrH()-30, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
	draw.ShadowSimpleText("ALT+E - Привязать к стене", "font_base_18", ScrW()-200, ScrH()-10, color_white, TEXT_ALIGN_LEFT, TEXT_ALIGN_BOTTOM)
end
