setmetatable(net, {
	__call = function(self, name, func)
		return self.Receive(name, func)
	end
})

local IsValid 	= IsValid
local Entity 	= Entity
local WriteUInt = net.WriteUInt
local ReadUInt 	= net.ReadUInt

function net.WriteNibble(i)
	WriteUInt(i, 4)
end

function net.ReadNibble()
	return ReadUInt(4)
end

function net.WriteByte(i)
	WriteUInt(i, 8)
end

function net.ReadByte()
	return ReadUInt(8)
end

function net.WriteShort(i)
	WriteUInt(i, 16)
end

function net.ReadShort()
	return ReadUInt(16)
end

function net.WriteLong(i)
	WriteUInt(u, 32)
end

function net.ReadLong()
	return ReadUInt(i, 32)
end

function net.WritePlayer(pl)
	if IsValid(pl) then 
		WriteUInt(pl:EntIndex(), 7)
	else
		WriteUInt(0, 7)
	end
end

function net.ReadPlayer()
	local i = ReadUInt(7)
	if (not i) then return end
	return Entity(i)
end