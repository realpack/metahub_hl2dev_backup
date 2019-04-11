draw = {}

local surface_SetFont 				= surface.SetFont
local surface_GetTextSize 			= surface.GetTextSize
local surface_SetTextPos 			= surface.SetTextPos
local surface_SetTextColor 			= surface.SetTextColor
local surface_DrawText 				= surface.DrawText
local surface_SetDrawColor 			= surface.SetDrawColor
local surface_DrawRect 				= surface.DrawRect
local surface_SetTexture 			= surface.SetTexture
local surface_DrawTexturedRectUV	= surface.DrawTexturedRectUV
local surface_DrawTexturedRect 		= surface.DrawTexturedRect

local string_gmatch = string.gmatch
local string_find 	= string.find
local math_ceil 	= math.ceil
local math_max 		= math.max
local tostring 		= tostring
local Color 		= Color

local Tex_Corner8 	= surface.GetTextureID('gui/corner8')
local Tex_Corner16 	= surface.GetTextureID('gui/corner16')
local Tex_white 	= surface.GetTextureID('vgui/white')

TEXT_ALIGN_LEFT		= 0
TEXT_ALIGN_CENTER	= 1
TEXT_ALIGN_RIGHT	= 2
TEXT_ALIGN_TOP		= 3
TEXT_ALIGN_BOTTOM	= 4


function draw.GetFontHeight(font)
	surface_SetFont(font)
	local w, h = surface_GetTextSize('W')
	return h
end

function draw.SimpleText(text, font, x, y, colour, xalign, yalign)
	surface_SetFont(font)

	local w, h = surface_GetTextSize(text)

	if (xalign == 1) then
		x = x - (w * .5)
	elseif (xalign == 2) then
		x = x - w
	end
	
	if (yalign == 1) then
		y = y - (h * .5)
	elseif (yalign == 4) then
		y = y - h
	end
	
	surface_SetTextPos(x, y)
	surface_SetTextColor(colour.r, colour.g, colour.b, colour.a)
	surface_DrawText(text)
	
	return w, h
end

local SimpleText = draw.SimpleText
function draw.SimpleTextOutlined(text, font, x, y, colour, xalign, yalign, outlinewidth, outlinecolour)
	local steps = (outlinewidth * .75)
	if (steps < 1)  then steps = 1 end
	
	for _x = -outlinewidth, outlinewidth, steps do
		for _y = -outlinewidth, outlinewidth, steps do
			SimpleText(text, font, x + (_x), y + (_y), outlinecolour, xalign, yalign)
		end
	end
	
	return SimpleText(text, font, x, y, colour, xalign, yalign)
end

function draw.DrawText(text, font, x, y, colour, xalign)
	local curX = x
	local curY = y
	local curString = ''
	
	surface_SetFont(font)
	local sizeX, lineHeight = surface_GetTextSize('\n')
	local tabWidth = 50
	
	for str in string_gmatch(text, '[^\n]*') do
		if #str > 0 then
			if string_find(str, '\t') then -- there's tabs, some more calculations required
				for tabs, str2 in string_gmatch(str, '(\t*)([^\t]*)') do
					curX = math_ceil((curX + tabWidth * math_max(#tabs - 1,0)) / tabWidth) * tabWidth
					
					if #str2 > 0 then
						SimpleText(str2, font, curX, curY, colour, xalign)
					
						local w, _ = surface_GetTextSize(str2)
						curX = curX + w
					end
				end
			else -- there's no tabs, this is easy
				SimpleText(str, font, curX, curY, colour, xalign)
			end
		else
			curX = x
			curY = curY + (lineHeight * .5)
		end
	end
end

function draw.RoundedBoxEx(bordersize, x, y, w, h, color, a, b, c, d)
	x = math_ceil(x)
	y = math_ceil(y)
	w = math_ceil(w)
	h = math_ceil(h)

	surface_SetDrawColor(color.r, color.g, color.b, color.a)
	
	-- Draw as much of the rect as we can without textures
	surface_DrawRect(x + bordersize, y, w - bordersize * 2, h)
	surface_DrawRect(x, y + bordersize, bordersize, h-bordersize * 2)
	surface_DrawRect(x + w - bordersize, y + bordersize, bordersize, h - bordersize * 2)
	
	local tex = Tex_Corner8
	if (bordersize > 8) then tex = Tex_Corner16 end
	
	surface_SetTexture(tex)
	
	if a then
		surface_DrawTexturedRectUV(x, y, bordersize, bordersize, 0, 0, 1, 1)
	else
		surface_DrawRect(x, y, bordersize, bordersize)
	end
	
	if b then
		surface_DrawTexturedRectUV(x + w -bordersize, y, bordersize, bordersize, 1, 0, 0, 1)
	else
		surface_DrawRect(x + w - bordersize, y, bordersize, bordersize)
	end
 
	if c then
		surface_DrawTexturedRectUV(x, y + h -bordersize, bordersize, bordersize, 0, 1, 1, 0)
	else
		surface_DrawRect(x, y + h - bordersize, bordersize, bordersize)
	end
 
	if d then
		surface_DrawTexturedRectUV(x + w -bordersize, y + h -bordersize, bordersize, bordersize, 1, 1, 0, 0)
	else
		surface_DrawRect(x + w - bordersize, y + h - bordersize, bordersize, bordersize)
	end
end

local RoundedBoxEx = draw.RoundedBoxEx
function draw.RoundedBox(bordersize, x, y, w, h, color)
	return RoundedBoxEx(bordersize, x, y, w, h, color, true, true, true, true)
end

local RoundedBox = draw.RoundedBox
function draw.WordBox(bordersize, x, y, text, font, color, fontcolor)
	surface_SetFont(font)
	local w, h = surface_GetTextSize(text)
	
	RoundedBox(bordersize, x, y, w+bordersize * 2, h + bordersize * 2, color)
	
	surface_SetTextColor(fontcolor.r, fontcolor.g, fontcolor.b, fontcolor.a)
	surface_SetTextPos(x + bordersize, y + bordersize)
	surface_DrawText(text)
	
	return w + bordersize * 2, h + bordersize * 2
end

function draw.Text(tab)
	local font 		= tab.font 		or 'DermaDefault'
	local x 		= tab.pos[1]	or 0
	local y 		= tab.pos[2]	or 0
	local xalign 	= tab.xalign 	or 0
	local yalign 	= tab.yalign 	or 3
	
	surface_SetFont(font)
	
	local w, h = surface_GetTextSize(tab.text)
	
	if (xalign == 1) then
		x = x - (w * .5)
	end
	
	if (xalign == 2) then
		x = x - w
	end
	
	if (yalign == 1) then
		y = y - (h * .5)
	end
	
	surface_SetTextPos(x, y)
	surface_SetTextColor(tab.color.r, tab.color.g, tab.color.b, tab.color.a)
	surface_DrawText(tab.text)
	
	return w, h
end

local Text = draw.Text
function draw.TextShadow(tab, distance, alpha)
	local color = tab.color
	local pos 	= tab.pos
	tab.color = Color(0,0,0,alpha)
	tab.pos = {pos[1] + distance, pos[2] + distance}

	Text(tab)
	
	tab.color = color
	tab.pos = pos
	
	return Text(tab)
end

function draw.TexturedQuad(tab)
	surface_SetTexture(tab.texture)
	surface_SetDrawColor(color.r, color.g, color.b, color.a)
	surface_DrawTexturedRect(tab.x, tab.y, tab.w, tab.h)
end

function draw.NoTexture()
	surface_SetTexture(Tex_white)
end
