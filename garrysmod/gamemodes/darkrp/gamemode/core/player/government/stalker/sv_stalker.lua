util.AddNetworkString('LostSignalCP')

local time = CurTime()
hook.Add( "PlayerTick", "keypress_use_hi", function( ply, key )
	if time > CurTime() and ply:Team() ~= TEAM_STALKER then return end
	time = CurTime() + 0.1

	local st = ply:GetNWBool('StalkerAttack')
	if ply:KeyDown( IN_ATTACK ) then
		ply:SetNWBool('StalkerAttack', true)
	else
		ply:SetNWBool('StalkerAttack', false)
	end
end )

timer.Create( 'TerminalRepair', .5, 0, function()
	for _, ply in pairs( player.GetAll() ) do
		if ply:Team() ~= TEAM_STALKER then return end

		local trace = ply:GetEyeTrace()

		if ply:GetNWBool('StalkerAttack') and trace.Entity:GetClass() == 'combine_terminal' then
			local ent = trace.Entity
			if ent:GetNetVar('TerminalBreak') then
				ent:SetNetVar('TerminalRepair', (ent:GetNetVar('TerminalRepair') or 0) + 1 )

				if ent:GetNetVar('TerminalRepair') >= 100 then
					ent:SetNetVar('TerminalBreak', false)
					ent:SetNetVar('TerminalRepair', 0)
				end
			end
		end
	end
end )

timer.Create( 'TerminalBreaks', 120, 0, function()
    local enginers = 0
    for _, t in pairs(rp.cfg.CanBrokenTerminal) do
        enginers = enginers + team.NumPlayers(t)
    end
    if enginers == 0 then
        for _, ent in pairs(ents.FindByClass('combine_terminal')) do
            if math.random(1,10) % 10 == 1 then
                ent:SetNetVar('TerminalBreak', true)
            end
        end
    end
end )
