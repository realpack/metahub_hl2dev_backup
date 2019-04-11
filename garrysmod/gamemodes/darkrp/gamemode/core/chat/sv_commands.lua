rp.commands = rp.commands or {}

function rp.AddCommand(cmd, func)
	rp.commands[cmd:lower()] = func
end

local function ConCommand(pl, cmd, args)
	-- if pl:IsPlayer() and not rp.data.IsLoaded(pl) then return end
	if not pl:IsPlayer() then return end
	if not args[1] then return end

	local cmd = '/' .. args[1]:lower()
	table.remove(args, 1)
	if rp.commands[cmd] then
		local arg_str = table.concat(args, ' ')
		hook.Call('PlayerRunRPCommand', nil, pl, cmd, args, arg_str)
		rp.commands[cmd](pl, arg_str, args)
	end
end
concommand.Add('rp', ConCommand)
concommand.Add('darkrp', ConCommand)
