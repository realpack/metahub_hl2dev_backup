-- Many things in garrysmod could be implemented faster but not everything needs a complete recode like the hook library so we'll chuck it here.

-- Net
do 
	local IsValid 	= IsValid
	local Entity 	= Entity
	local Color 	= Color
	local WriteUInt = net.WriteUInt
	local ReadUInt 	= net.ReadUInt

	function net.WriteEntity(ent)
		if IsValid(ent) then 
			WriteUInt(ent:EntIndex(), 12)
		else
			WriteUInt(0, 12)
		end
	end

	function net.ReadEntity()
		local i = ReadUInt(12)
		if (not i) then return end
		return Entity(i)
	end

	function net.WriteColor(c)
		WriteUInt(c.r, 8)
		WriteUInt(c.g, 8)
		WriteUInt(c.b, 8)
		WriteUInt(c.a, 8)
	end

	function net.ReadColor()
		return Color(ReadUInt(8), ReadUInt(8), ReadUInt(8), ReadUInt(8))
	end
end


if (SERVER) then return end

-- Surface
do
	local SetFont 		= surface.SetFont
	local GetTextSize 	= surface.GetTextSize

	local Font 			= 'TargetID'
	local SizeCache 	= {}

	function surface.SetFont(font)
		Font = font
		return SetFont(font)
	end
	 
	function surface.GetTextSize(text)
		if (not SizeCache[Font]) then
			SizeCache[Font] = {}
		end
		   
		if (not SizeCache[Font][text]) then
			local x, y = GetTextSize(text)
			SizeCache[Font][text] = {
				x = x, 
				y = y
			}
			return x, y
		end
		   
		return SizeCache[Font][text].x, SizeCache[Font][text].y
	end
	 
	timer.Create('PurgeFontCache', 1200, 0, function()
		SizeCache = {}
	end)
end
