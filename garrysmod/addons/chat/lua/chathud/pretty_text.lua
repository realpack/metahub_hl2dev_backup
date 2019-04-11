local R,G,B,A = 255, 255, 255, 255
local X, Y = 0, 0
local FONT = "???"

local cache = {}

surface.pretty_fonts = surface.pretty_fonts or {}

surface._ptSetTextPos = surface._ptSetTextPos or surface.SetTextPos
function surface.SetTextPos(x, y, ...)
	X = x
	Y = y
	return surface._ptSetTextPos(x, y, ...)
end


surface._ptSetTextColor = surface._ptSetTextColor or surface.SetTextColor
function surface.SetTextColor(r, g, b, a, ...)
	if type(r) == "table" then
		R = r.r or R
		G = r.g or G
		B = r.b or B
		A = r.a or A
	else
		R = r or R
		G = g or G
		B = b or B
		A = a or A
	end
	
	return surface._ptSetTextColor(r, g, b, a, ...)
end

surface._ptSetFont = surface._ptSetFont or surface.SetFont
function surface.SetFont(str, ...)
	FONT = str
	return surface._ptSetFont(str, ...)
end

surface._ptDrawText = surface._ptDrawText or surface.DrawText
function surface.DrawText(str, ...)
	if FONT and surface.pretty_fonts[FONT] then
		--if str:gsub("%s", "") == "" then return end -- cache? cache in string library?
		
 		local info = surface.pretty_fonts[FONT]
				
		surface._ptSetFont(info.name)
			
		info.blurcolor.a = A
		
		surface._ptSetTextColor(info.blurcolor)
		
		for i = 1, info.passes do
			surface._ptSetTextPos(X, Y) -- this resets for some reason after drawing
			surface._ptDrawText(str, ...)
		end

		surface._ptSetFont(FONT)
		surface._ptSetTextColor(R, G, B, A)
		surface._ptSetTextPos(X, Y)
		surface._ptDrawText(str, ...)
	else
		return surface._ptDrawText(str, ...)
	end
end

surface._ptGetTextSize = surface._ptGetTextSize or surface.GetTextSize
function surface.GetTextSize(str, ...)
	if FONT and surface.pretty_fonts[FONT] then
		--if str:gsub("%s", "") == "" then return end -- cache? cache in string library?
 		local info = surface.pretty_fonts[FONT]
				
		surface._ptSetFont(info.name)
		local w, h = surface._ptGetTextSize(str, ...)
		surface._ptSetFont(FONT)
		
		return w, h
	else
		return surface._ptGetTextSize(str, ...)
	end
end

surface._ptCreateFont = surface._ptCreateFont or surface.CreateFont
function surface.CreateFont(name, info, ...)
	
	if type(info) == "table" and info.prettyblur then
		local info = table.Copy(info)
			info.additive = false
			info.blursize = info.prettyblur
			info.blurcolor = info.blurcolor or Color(0, 0, 0, 255)
			info.passes = info.passes or 3
			info.name = name .. "_pretty_text"
		surface.pretty_fonts[name] = info
		
		surface._ptCreateFont(info.name, info, ...)
	end

	return surface._ptCreateFont(name, info, ...)
end