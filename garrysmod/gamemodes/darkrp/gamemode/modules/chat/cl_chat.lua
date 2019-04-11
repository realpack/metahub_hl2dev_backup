include('sh_chat.lua')

local color_white = Color(235,235, 235)

local readFuncs = {
	[0]	=  function()
		return {net.ReadString()}
	end,
	[1]	= function()
		return {Color(net.ReadUInt(8), net.ReadUInt(8), net.ReadUInt(8))}
	end,
	[2]	= function()
		local pl = net.ReadPlayer()
		if (!IsValid(pl)) then return {Color(150, 150, 150), '(Unknown)', color_white, ': '} end
		return {team.GetColor(pl:GetJob()), pl:Name(), color_white, ': '}
	end,
	[3] = function()
		return {rp.chatcolors[net.ReadUInt(6)]}
	end
}

local function wasteUInt()
	net.ReadUInt(2)
end

local chatHandlers = {
	[CHAT_LOCAL] = function()
		local numArgs = net.ReadUInt(5)

		if (numArgs == 2) then -- normal
			wasteUInt()
			local pl = net.ReadPlayer()
			wasteUInt()
			local text = net.ReadString()

			if (IsValid(CHATBOX)) then CHATBOX.DoEmotes = pl:IsVIP() end
			chat.AddText(team.GetColor(pl:GetJob()), pl:Name(), color_white, ': ', text)

			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_LOCAL, pl, text)
		else -- whisper, yell, me
			wasteUInt()
			local prefixCol = readFuncs[3]()[1]
			wasteUInt()
			local prefix = net.ReadString()
			wasteUInt()
			local pl = net.ReadPlayer()
			wasteUInt()
			local text = net.ReadString()

			if IsValid(pl) then
				if (IsValid(CHATBOX)) then CHATBOX.DoEmotes = pl:IsVIP() end
				chat.AddText(prefixCol, prefix, pl:GetJobColor(), pl:Name(), color_white, ': ', text)

				hook.Call("ChatRoomMessage", GAMEMODE, CHAT_LOCAL, pl, prefix .. text)
			end
		end
	end,
	[CHAT_PM] = function()
		local numArgs = net.ReadUInt(5)

		wasteUInt()
		local prefixCol = readFuncs[3]()[1]
		wasteUInt()
		local plFrom = net.ReadPlayer()
		wasteUInt()
		local plTo = net.ReadPlayer()
		wasteUInt()
		local msg = net.ReadString()

		if (!IsValid(plFrom) or !IsValid(plTo)) then return end

		local prefix = "[PM" .. (plTo == LocalPlayer() and "] " or " > " .. plTo:Name() .. "] ")

		if (IsValid(CHATBOX)) then CHATBOX.DoEmotes = plFrom:IsVIP() end
		chat.AddText(prefixCol, prefix, plFrom:GetJobColor(), plFrom:Name(), color_white, ': ', msg)

		hook.Call("ChatRoomMessage", GAMEMODE, CHAT_PM, plFrom, plTo, msg)
	end,
	[CHAT_OOC] = function()
		local numArgs = net.ReadUInt(5)

		wasteUInt()
		local prefixCol = readFuncs[3]()[1]
		wasteUInt()
		local prefix = net.ReadString()
		wasteUInt()
		local pl = net.ReadPlayer()
		wasteUInt()
		local text = net.ReadString()

		if IsValid(pl) then
			if (IsValid(CHATBOX)) then CHATBOX.DoEmotes = pl:IsVIP() end
			chat.AddText(prefixCol, prefix, pl:GetJobColor(), pl:Name(), color_white, ': ', text)

			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_OOC, pl, text)
		end
	end,
	[CHAT_CROSSSERVER] = function()
		local numArgs = net.ReadUInt(5)

		wasteUInt()
		local prefixCol = readFuncs[1]()[1]
		wasteUInt()
		local prefix = net.ReadString()
		wasteUInt()
		local plCol = readFuncs[1]()[1]
		wasteUInt()
		local plName = net.ReadString()
		wasteUInt()
		local msgCol = readFuncs[1]()[1]
		wasteUInt()
		local msg = net.ReadString()

		chat.AddText(prefixCol, prefix, plCol, plName, msgCol, msg)

		if (plName == LocalPlayer():Name()) then
			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_CROSSSERVER, LocalPlayer(), msg)
		else
			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_CROSSSERVER, prefix .. plName, msg)
		end
	end,
	[CHAT_GROUP] = function()
		local numArgs = net.ReadUInt(5)

		wasteUInt()
		local prefixCol = readFuncs[1]()[1]
		wasteUInt()
		local prefix = net.ReadString()
		wasteUInt()
		local pl = net.ReadPlayer()
		wasteUInt()
		local msg = net.ReadString()

		if IsValid(pl) then
			if (IsValid(CHATBOX)) then CHATBOX.DoEmotes = pl:IsVIP() end
			chat.AddText(prefixCol, prefix, pl:GetJobColor(), pl:Name(), color_white, ': ', msg)

			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_GROUP, pl, msg)
		end
	end,
	[CHAT_ORG] = function()
		local numArgs = net.ReadUInt(5)

		wasteUInt()
		local prefixCol = readFuncs[1]()[1]
		wasteUInt()
		local prefix = net.ReadString()
		wasteUInt()
		local pl = net.ReadPlayer()
		wasteUInt()
		local msg = net.ReadString()

		if IsValid(pl) then
			if (IsValid(CHATBOX)) then CHATBOX.DoEmotes = pl:IsVIP() end
			chat.AddText(prefixCol, prefix, pl:GetJobColor(), pl:Name(), color_white, ': ', msg)

			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_ORG, pl, msg)
		end
	end,
	[CHAT_RADIO] = function()
		local numArgs = net.ReadUInt(5)

		wasteUInt()
		local prefixCol = readFuncs[3]()[1]
		wasteUInt()
		local prefix = net.ReadString()
		wasteUInt()
		local pl = net.ReadPlayer()
		wasteUInt()
		local msg = net.ReadString()

		if IsValid(pl) then
			if (IsValid(CHATBOX)) then CHATBOX.DoEmotes = pl:IsVIP() end
			chat.AddText(prefixCol, prefix, pl:GetJobColor(), pl:Name(), color_white, ': ', msg)

			hook.Call("ChatRoomMessage", GAMEMODE, CHAT_RADIO, (pl == LocalPlayer() and pl or prefix .. pl:Name()), msg)
		end
	end,
}

net('rp.ChatMessage', function()
	local chatType = net.ReadUInt(4)

	if (chatHandlers[chatType]) then
		chatHandlers[chatType]()
	else
		local tbl 	= {}
		local it 	= 1

		for i = 1, net.ReadUInt(5) do
			local tbl2 = readFuncs[net.ReadUInt(2)]()
			for k, v in ipairs(tbl2) do
				tbl[it] = tbl2[k]
				it = it + 1
			end
		end
		chat.AddText(unpack(tbl))
	end
end)

function rp.RunCommand(...)
	local args = {...}
	net.Start('rp.RunCommand')
		net.WriteUInt(#args, 4)
		for i = 1, #args do
			net.WriteString(tostring(args[i]))
		end
	net.SendToServer()
end
