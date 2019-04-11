pcolor = {
	White 	= Color(255,255,255), -- todo, more colors?
	Black 	= Color(0,0,0),
	Red 	= Color(255,0,0),
	Green 	= Color(0,255,0),
	Blue 	= Color(0,0,255),
	Yellow 	= Color(255,255,0)
}

local Color 	 	= Color
local tonumber 		= tonumber
local string_format = string.format
local string_match 	= string.match
local bit_band		= bit.band
local bit_rshift 	= bit.rshift

function pcolor.ToHex(col)
	return string_format('#%02X%02X%02X', col.r, col.g, col.b)
end

function pcolor.FromHex(hex)
	local r, g, b = string_match(hex, '#(..)(..)(..)')
	return Color(tonumber(r, 16), tonumber(g, 16), tonumber(b, 16))
end

function pcolor.EncodeRGB(col)
	return (col.r * 0x100 + col.g) * 0x100 + col.b
end

function pcolor.DecodeRGB(num)
	return Color(bit_band(bit_rshift(num, 16), 0xFF), bit_band(bit_rshift(num, 8), 0xFF), bit_band(num, 0xFF))
end

function pcolor.EncodeRGBA(col)
	return ((col.a * 0x100 + col.r) * 0x100 + col.g) * 0x100 + col.b
end

function pcolor.DecodeRGBA(num)
	return Color(bit_band(rshift(num, 16), 0xFF), bit_band(rshift(num, 8), 0xFF), bit_band(num, 0xFF), bit_band(rshift(num, 24), 0xFF))
end