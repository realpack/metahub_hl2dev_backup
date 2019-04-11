function string.Apostrophe(str)
	local len = str:len()
	
	if (str:sub(len, len):lower() == "s") then
		return "\'"
	else
		return "\'s"
	end
end

function string.AOrAn(str)
	return str:match("^h?[AaEeIiOoUu]") and "an" or "a"
end

function string.Random(chars)
	local str = ''
	for i = 1, (chars or 10) do
		str = str .. string.char(math.random(97, 122))
	end
	return str
end

function string.HtmlSafe(str)
    return str:gsub("&", "&amp;"):gsub("<", "&lt;"):gsub(">", "&gt;")
end

function string.ExplodeQuotes(str) -- Re-do this one of these days
	str = ' ' .. str .. ' '
	local res = {}
	local ind = 1
	while true do
		local sInd, start = str:find('[^%s]', ind)
		if not sInd then break end
		ind = sInd + 1
		local quoted = str:sub(sInd, sInd):match('["\']') and true or false
		local fInd, finish = str:find(quoted and '["\']' or '[%s]', ind)
		if not fInd then break end
		ind = fInd + 1
		local str = str:sub(quoted and sInd + 1 or sInd, fInd - 1)
		res[#res + 1] = str
	end
	return res
end

function string.IsSteamID(str)
	return str:match("^STEAM_%d:%d:%d+$")
end

local formatHex = "%%%02X"

function string.URLEncode(str)
	return str:gsub("([^%w%-%_%.%~])", function( hex ) 
		return formatHex:format( hex:byte() ) 
	end )
end

function string.URLDecode(str)
	return str:gsub( "+", " " ):gsub( "%%(%x%x)", function( hex )
		return string.char( tonumber( hex, 16 ) )
	end )
end

function string.StripPort(ip)
	local p = string.find(ip, ':')
	if (not p) then return ip end
	return string.sub(ip, 1, p - 1)
end

function string.FromNumbericIP(ip)
	ip = tonumber(ip)
	return bit.rshift(bit.band(ip, 0xFF000000), 24) .. '.' .. bit.rshift(bit.band(ip, 0x00FF0000), 16) .. '.' .. bit.rshift(bit.band(ip, 0x0000FF00), 8) .. '.' .. bit.band(ip, 0x000000FF)
end

if (SERVER) then return end

local surface_SetFont 		= surface.SetFont
local surface_GetTextSize 	= surface.GetTextSize
local string_Explode 		= string.Explode
local ipairs 				= ipairs

function string.Wrap(font, text, width)
	surface_SetFont(font)
	
	local sw = surface_GetTextSize(' ')
	local ret = {}
	
	local w = 0
	local s = ''

	local t = string_Explode('\n', text)

	for i = 1, #t do
		local t2 = string_Explode(' ', t[i], false)
		for i2 = 1, #t2 do
			local neww = surface_GetTextSize(t2[i2])
			
			if (w + neww >= width) then
				ret[#ret + 1] = s
				w = neww + sw
				s = t2[i2] .. ' '
			else
				s = s .. t2[i2] .. ' '
				w = w + neww + sw
			end
		end
		ret[#ret + 1] = s
		w = 0
		s = ''
	end
	
	if (s ~= '') then
		ret[#ret + 1] = s
	end

	return ret
end