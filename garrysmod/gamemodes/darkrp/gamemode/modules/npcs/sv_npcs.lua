util.AddNetworkString('NPCJobs_BuyTeam')
util.AddNetworkString('NPCJobs_ChangeTeam')

net.Receive('NPCJobs_BuyTeam', function(len, pl)
    local team_index = net.ReadUInt(32)
    local price

    local npc_id = net.ReadString()
    local npc = nil

    if not (pl and IsValid(pl) and pl:IsPlayer()) then return end

    for _, ent in pairs(ents.FindByClass('npc_jobs')) do
        if ent.npc_id == npc_id and ent.jobs[team_index] then
            npc = ent
            price = ent.jobs[team_index]
        end
    end

    local job = rp.teams[team_index]

    if job.customCheck and not job.customCheck(pl) then
		rp.Notify(pl, NOTIFY_ERROR, job.CustomCheckFailMsg)
		return false
	end

    -- print(pl, 123)
    if job.needteam and job.needteam ~= nil and pl:GetNetVar('Teams')[job.needteam] ~= true then
        local tm
        for k, v in pairs(rp.teams) do
            if job.needteam == v.command then
                tm = v
            end
        end
        if tm then
            rp.Notify(pl, NOTIFY_ERROR, string.format('Вы должны сначала купить "%s"',tm.name))
            return false
        end
	end
    -- print(pl, 123, npc, price)

    if npc and price then
        if pl:HasTeam(team_index) then
            pl:Notify(NOTIFY_ERROR, 'Вы уже купили эту профессию.')
        else
            if pl:CanAfford(price) then
                pl:Notify( NOTIFY_GENERIC, string.format('Вы купили профессию "%s" за %s.',job.name,rp.FormatMoney(price)) )

                local player_teams = pl:GetNetVar('Teams') or {}
                player_teams[job.command] = true
                rp.data.SetTeams(pl, pon.encode(player_teams), function(old_teams)
                    pl:SetNetVar('Teams', player_teams)
                    pl:AddMoney(-price)
                end)
            else
                rp.Notify(pl, NOTIFY_ERROR, 'У вас не хватает денег')
            end
        end
    end
end)

net.Receive('NPCJobs_ChangeTeam', function(len, pl)
    local team_index = net.ReadUInt(32)

    if pl:HasTeam(team_index) then
        pl:ChangeTeam(team_index)
    end
end)
