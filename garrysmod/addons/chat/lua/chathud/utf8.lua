local select        = select

local string_byte   = string.byte
local string_gmatch = string.gmatch
local string_gsub   = string.gsub
local string_sub    = string.sub

utf8 = {}

-- Taken from http://cakesaddons.googlecode.com/svn/trunk/glib/lua/glib/unicode/utf8.lua
function utf8.byte(char, offset)
	if char == "" then return -1 end
	offset = offset or 1
	
	local byte = string_byte(char, offset)
	local length = 1
	if byte >= 128 then
		-- multi-byte sequence
		if byte >= 240 then
			-- 4 byte sequence
			length = 4
			if #char < 4 then return -1, length end
			byte = (byte % 8) * 262144
			byte = byte + (string_byte(char, offset + 1) % 64) * 4096
			byte = byte + (string_byte(char, offset + 2) % 64) * 64
			byte = byte + (string_byte(char, offset + 3) % 64)
		elseif byte >= 224 then
			-- 3 byte sequence
			length = 3
			if #char < 3 then return -1, length end
			byte = (byte % 16) * 4096
			byte = byte + (string_byte(char, offset + 1) % 64) * 64
			byte = byte + (string_byte(char, offset + 2) % 64)
		elseif byte >= 192 then
			-- 2 byte sequence
			length = 2
			if #char < 2 then return -1, length end
			byte = (byte % 32) * 64
			byte = byte + (string_byte(char, offset + 1) % 64)
		else
			-- this is a continuation byte
			-- invalid sequence
			byte = -1
		end
	else
		-- single byte sequence
	end
	return byte, length
end

-- Taken from http://cakesaddons.googlecode.com/svn/trunk/glib/lua/glib/unicode/utf8.lua
function utf8.length(str)
	local _, length = string_gsub(str, "[^\128-\191]", "")
	return length
end

-- Taken from http://www.curse.com/addons/wow/utf8/546587
function utf8.sub(str, i, j)
	j = j or -1

	local pos = 1
	local bytes = #str
	local length = 0

	-- only set l if i or j is negative
	local l = (i >= 0 and j >= 0) or utf8.length(str)
	local start_char = (i >= 0) and i or l + i + 1
	local end_char   = (j >= 0) and j or l + j + 1

	-- can't have start before end!
	if start_char > end_char then
		return ""
	end

	-- byte offsets to pass to string.sub
	local start_byte, end_byte = 1, bytes

	while pos <= bytes do
		length = length + 1

		if length == start_char then
			start_byte = pos
		end

		pos = pos + select(2, utf8.byte(str, pos))

		if length == end_char then
			end_byte = pos - 1
			break
		end
	end

	return string_sub(str, start_byte, end_byte)
end

-- Taken from http://www.curse.com/addons/wow/utf8/546587
function utf8.totable(str)
	local tbl = {}
	
	for uchar in string_gmatch(str, "([%z\1-\127\194-\244][\128-\191]*)") do
		tbl[#tbl + 1] = uchar
	end
	
	return tbl
end