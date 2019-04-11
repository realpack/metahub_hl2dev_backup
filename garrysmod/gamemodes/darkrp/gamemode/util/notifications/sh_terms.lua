rp.Terms 		= rp.Terms 		or {}
rp.TermsMap 	= rp.TermsMap 	or {}
rp.TermsStore	= rp.TermsStore	or {}

local c = 0
hook('PostGamemodeLoaded', 'rp.terms.PostGamemodeLoaded', function()
	for k, v in SortedPairsByMemberValue(rp.TermsStore, 'Name', false) do
		rp.TermsMap[v.Name] = c 
		rp.Terms[c] = v.Message
		c = c + 1
	end
end)

function rp.AddTerm(name, message)
	local k = rp.TermsMap[name] or (#rp.TermsStore + 1)
	rp.TermsStore[k] = {
		Name = name,
		Message = message,
	}
end

function rp.Term(name)
	return rp.TermsMap[name]
end

function rp.WriteTerm(id, ...)
	net.WriteUInt(id, 9) -- Will need to raise this later
	for k, v in ipairs({...}) do
		local t = type(v)
		if (t == 'Player') then
			net.WriteUInt(0,2)
			net.WritePlayer(v)
		elseif (t == 'Entity') then
			net.WriteUInt(1,2)
			net.WriteEntity(v)
		else
			net.WriteUInt(2,2)
			net.WriteString(tostring(v))
		end
	end
end

function rp.ReadTerm()
	local msg = rp.Terms[net.ReadUInt(9)]
	return msg:gsub('#', function()
		local t = net.ReadUInt(2)
		if (t == 0) then 
			local v = net.ReadPlayer()
			if (not IsValid(v)) then return 'Unknown' end
			return v:Name()
		elseif (t == 1) then
			local v = net.ReadEntity()
			if (not IsValid(v)) then return 'Invalid Entity' end
			return (v.PrintName and v.PrintName or v:GetClass())
		end
		return net.ReadString()
	end)
end

function rp.WriteMsg(msg, ...)
	local replace = {...}
	local count = 0
	msg = msg:gsub('#', function()
		count = count + 1
		local v = replace[count]
		local t = type(v)
		if (t == 'Player') then 
			if (not IsValid(v)) then return 'Unknown' end
			return v:Name()
		elseif (t == 'Entity') then
			if (not IsValid(v)) then return 'Invalid Entity' end
			return (v.PrintName and v.PrintName or v:GetClass())
		end
		return v
	end)
	net.WriteString(msg)
end

rp.ReadMsg = net.ReadString