
-----------------------------------------------------
ENT.Type = "anim"
ENT.Base = "base_anim"
ENT.PrintName = "Textscreen"
ENT.Author = "SammyServers"
ENT.Spawnable = false
ENT.AdminSpawnable = false

for i = 1, 3 do
	nw.Register("Font" .. i, {
		Read = function() return net.ReadUInt(5) end,
		Write = function(v) return net.WriteUInt(v, 5) end
	})

	nw.Register("Text" .. i, {
		Read = net.ReadString,
		Write = net.WriteString
	})

	nw.Register("size" .. i, {
		Read = function() return net.ReadUInt(8) end,
		Write = function(v) return net.WriteUInt(v, 8) end
	})

	nw.Register("r" .. i, {
		Read = function() return net.ReadUInt(8) end,
		Write = function(v) return net.WriteUInt(v, 8) end
	})

	nw.Register("g" .. i, {
		Read = function() return net.ReadUInt(8) end,
		Write = function(v) return net.WriteUInt(v, 8) end
	})

	nw.Register("b" .. i, {
		Read = function() return net.ReadUInt(8) end,
		Write = function(v) return net.WriteUInt(v, 8) end
	})

	nw.Register("a" .. i, {
		Read = function() return net.ReadUInt(8) end,
		Write = function(v) return net.WriteUInt(v, 8) end
	})
end