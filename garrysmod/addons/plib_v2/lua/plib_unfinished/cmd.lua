cmd = setmetatable({}, {
	__call = function(self, name, callback)
		return self.Add(name, callback)
	end,
	
})
cmd.GetTable = setmetatable({}, {
	__call = function(self)
		return self
	end
})

local cmd_mt = {
	__tostring = function(self)
		return self.Name
	end
}
cmd_mt.__index 	= cmd_mt
cmd_mt.__concat = cmd_mt.__tostring
_R.cmd 			= cmd_mt

local concommands = {}
local params = {}

if (SERVER) then
	util.AddNetworkString 'cmd.Run'
end


-- Parsing
function cmd.AddParam(name, parse, autocomplete)
	local id = #params + 1
	cmd[name:upper()] = id
	params[id] = {
		Parse = parse,
		AutoComplete = autocomplete
	}
	return id
end

function cmd.ParseString(caller, cmd, arg_string)
	local args = string.ExplodeQuotes(arg_string)

	if (#args < #cmd:GetParams()) then
		hook.Call('cmd.OnCommandError', nil, caller, cmd, 'To many arguments!', args)
	end

	local parsed_args = {}
	for k, v in ipairs(cmd:GetParams()) do
		local arg, err, used = params[v.Type].Parse(caller, cmd, args[1], arg, k)

		if (arg == false) then
			hook.Call('cmd.OnCommandError', nil, caller, cmd, err, args)
		elseif (hook.Call('cmd.ParsedArgument', nil, caller, cmd, arg) ~= nil) then 
			break 
		end

		for i = 1, (used or 1) do
			table.remove(args, i)
		end

		parsed_args[#parsed_args + 1] = arg
	end
end

-- Defualt parsers
local function playercomplete(cmd, arg, args, step)
	local ret = {}
	if (arg ~= nil) and string.IsSteamID(arg) then 
		ret = {arg}
	else
		for _, pl in ipairs(player.GetAll()) do
			if (arg ~= nil) and string.find(pl:Name():lower(), arg:lower()) then
				ret[#ret + 1] = pl:Name()
			elseif (arg == nil) then
				ret[#ret + 1] = pl:Name()
			end
		end
	end
	return ret
end
cmd.AddParam('PLAYER_STEAMID', function(caller, cmd, arg, args, step)
	local result = player.FindByInfo(arg)
	if (result == nil) and (not string.IsSteamID(arg)) then
		return false, 'Player \'' ..  arg .. '\' not found!'
	end
	return true, result
end, playercomplete)

cmd.AddParam('PLAYER_ENTITY', function(caller, cmd, arg, args, step)
	local result = player.FindByInfo(arg)
	if (result == nil) then
		return false, 'Player \'' ..  arg .. '\' not found!'
	end
	return true, result
end, playercomplete)

cmd.AddParam('PLAYER_ENTITY_MULTI', function(caller, cmd, arg, args, step)
	local results = {}
	for i = 1, (#args - #cmd:GetParams() + 1) do
		local result = player.FindByInfo(args[i])
		if (result == nil) then
			return false, 'Player \'' ..  args[i] .. '\' not found!'
		else
			results[#results + 1] = result
		end
	end
	return true, results, #results
end, playercomplete)

cmd.AddParam('STRING', function(caller, cmd, arg, args, step)
	local results = ''
	local c = (#args - #cmd:GetParams() + 1)
	for i = 1, c do
		results = results .. args[i]
	end
	return true, results, c
end, function(cmd, arg, args, step)
	return {arg}
end)

cmd.AddParam('NUMBER', function(caller, cmd, arg, args, step)
	return true, tonumber(arg)
end, function(cmd, arg, args, step)
	return {arg}
end)


-- Commands
function cmd.Add(name, callback)
	local c = setmetatable({
		Name  		= name:lower():gsub(' ', ''),
		NiceName 	= name,
		Params		= {},
		CanRun 		= function() end,
		Callback	= callback or function() end
	}, cmd_mt)
	cmd.GetTable[c.Name] = c
	return c
end

function cmd.Get(name)
	return cmd.GetTable[name]
end

function cmd.Remove(name)
	cmd.GetTable[name] = nil
end

function cmd.Run(caller, name, str_args)
	local cmd = cmd.Get(name)
	local args = cmd.ParseString(caller, cmd, str_args)

	local succ, msg = (hook.Call('cmd.CanRunCommand', nil, caller, cmd, msg, args) or cmd:CanRun(caller, unpack(args)) or cmd:Run(caller, unpack(args)))
print(succ, msg)
	if (succ == false) then
		hook.Call('cmd.OnCommandError', nil, caller, cmd, msg, args)
	elseif (succ == nil) or (succ == true) then
		hook.Call('cmd.OnCommandRun', nil, caller, cmd, msg, args)
	end
	return succ, msg
end


-- Set
function cmd_mt:SetConCommand(name)
	name = name:lower()
	self.ConCommand = name
	if (not concommands[name]) then
		concommands[name] = true
		if (SERVER) then
			concommand.Add('_' .. name, function(pl, cmd, args, str)
				if (not args[1]) then 
					cmd = args[1]
					table.remove(args, 1)
					for i = 1, #args do
						if (string.upper(tostring(v)) == 'STEAM_0') and (args[i + 4]) then
							args[i] = table.concat(args, '', i, i + 4)
							for _ = 1, 4 do
								table.remove(args, i + 1)
							end
							break
						end
					end
					print('adwawd')
					cmd.Run(pl, cmd, args)
				end
			end)
		else
			concommand.Add(name, function(pl, cmd, args, str)
				print('cl')
				LocalPlayer():ConCommand('_' .. name .. ' ' .. str)
			end, function(cmd, str)
				-- Auto complete
			end)
		end
	end
	return self
end

function cmd_mt:AddParam(type, opts)
	self.Params[#self.Params + 1] = {
		Type = type,
		Opts = opts or {}
	}
	return self
end

function cmd_mt:RunOnClient(callback)
	self.ClientCallback = callback
	return self
end


-- Get
function cmd_mt:GetName()
	return self.Name
end

function cmd_mt:GetNiceName()
	return self.NiceName
end

function cmd_mt:GetConCommand()
	return self.ConCommand
end

function cmd_mt:GetParams()
	return self.Params
end

-- Internal
function cmd_mt:Run(caller, ...)
	if caller:IsPlayer() and self.ClientCallback then
		local args = {...}
		net.Start('cmd.Run')
			net.WriteUInt(#args, 4)
			for k, v in ipairs(args) do
				net.WriteType(v)
			end
		net.Send(caller)
	end
	return self.Callback(caller, ...)
end

if (CLIENT) then
	net.Receive('cmd.Run', function()
		local args = {}
		for i = 1, net.ReadUInt(4) do
			args[i] = net.ReadType()
		end
		self.ClientCallback(unpack(args))
	end)
end









---
require 'cmd'

PrintTable(cmd)
PrintTable(FindMetaTable('cmd'))

local function c(...)
	return cmd(...):SetConCommand 'cmd'
end

c('Test', function(pl)
	print 'ran test command sv'
end)
:RunOnClient(function()
	print 'ran test command cl'
end)


c('Test2', function(pl, targ)
	print('ran test command2', targ)
end)
:AddParam(cmd.PLAYER_ENTITY)


c('Test3', function(pl, targs)
	print('ran test command3')
	PrintTable(targs)
end)
:AddParam(cmd.PLAYER_ENTITY_MULTI)

c('Test4', function(pl, msg)
	print('ran test command4', msg)
end)
:AddParam(cmd.STRING)


hook.Add('cmd.CanRunCommand', function(...)
	print(...)
end)
hook.Add('cmd.OnCommandError', function(...)
	print(...)
end)
hook.Add('cmd.OnCommandRun', function(...)
	print(...)
end)
hook.Add('cmd.ParsedArgument', function(...)
	print(...)
end)