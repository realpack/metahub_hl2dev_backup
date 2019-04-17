-- Global vars
nw.Register 'TheLaws'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetGlobal()

nw.Register 'lockdown'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetGlobal()

nw.Register 'CPCode'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetGlobal()

-- Player Vars
nw.Register 'HasGunlicense'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register 'meta_radio'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register 'Name'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

nw.Register 'Money'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetLocalPlayer()

nw.Register 'Karma'
	:Write(net.WriteUInt, 7)
	:Read(net.ReadUInt, 7)
	:SetLocalPlayer()

nw.Register 'job'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

nw.Register 'Employee'
	:Write(net.WritePlayer)
	:Read(net.ReadPlayer)
	:SetLocalPlayer()

nw.Register 'Employer'
	:Write(net.WritePlayer)
	:Read(net.ReadPlayer)
	:SetPlayer()

nw.Register 'DisguiseTeam'
	:Write(net.WriteUInt, 6)
	:Read(net.ReadUInt, 6)
	:SetPlayer()

nw.Register 'DisguiseTime'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetLocalPlayer()

nw.Register 'ShareProps'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetLocalPlayer()

nw.Register 'Clothes'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetLocalPlayer()

nw.Register 'Model'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

nw.Register 'Gender'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register 'RPID'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register 'Stamina'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)
	:SetPlayer()

nw.Register 'Teams'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetLocalPlayer()

nw.Register 'StalkerAttack'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register 'Control_Capture'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)

nw.Register 'Control_Name'
	:Write(net.WriteString)
	:Read(net.ReadString)

nw.Register 'Control_Status'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)

nw.Register 'PoliceOnly'
	:Write(net.WriteBool)
	:Read(net.ReadBool)

nw.Register 'TerminalBreak'
	:Write(net.WriteBool)
	:Read(net.ReadBool)

nw.Register 'TerminalRepair'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)

nw.Register 'PropIsOwned'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:Filter(function(self)
		return self:CPPIGetOwner()
	end)
	:SetNoSync()

nw.Register 'PropGetOwner'
	:Write(net.WriteEntity)
	:Read(net.ReadEntity)
	:Filter(function(self)
		return self:CPPIGetOwner()
	end)
	:SetNoSync()

-- Combine Shits
nw.Register 'CPTerminal'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
	:SetGlobal()

nw.Register 'CPMask'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register 'CPProtocol'
	:Write(net.WriteString)
	:Read(net.ReadString)
	:SetPlayer()

-- Whitelist
nw.Register 'Whitelist'
	:Write(net.WriteTable)
	:Read(net.ReadTable)
    :SetGlobal()

-- Controls
nw.Register 'Control_Capture'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)

nw.Register 'CaptureFraction'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)

-- nw.Register 'Upgrades'
-- 	:Write(function(v)
-- 		net.WriteUInt(#v, 8)
-- 		for k, upgid in ipairs(v) do
-- 			net.WriteUInt(upgid, 8)
-- 		end
-- 	end)
-- 	:Read(function()
-- 		local ret = {}
-- 		for i=1, net.ReadUInt(8) do
-- 			local obj = rp.shop.Get(net.ReadUInt(8))
-- 			ret[obj:GetUID()] = true
-- 		end
-- 		return ret
-- 	end)
-- 	:SetLocalPlayer()

-- nw.Register 'Outfit'
-- 	:Write(net.WriteUInt, 6)
-- 	:Read(net.ReadUInt, 6)
-- 	:SetPlayer()
