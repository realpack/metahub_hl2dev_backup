hook.Add('InitPostEntity','ControlPoints_InitPostEntity',function()
    timer.Create('ControlPoints_Timer',1,0,function()
        for k, ent in pairs(ents.FindByClass('control_point')) do
            local buff = .01* ent:GetNWInt( "Time" )
            local insphere = ents.FindInSphere(ent:GetPos(), ent:GetNWInt('Radius'))
            local fraction_id = ent:GetNWString('Team')
            local players = {}

            local name = ent:GetNWString('Name')
            local reward = ent:GetNWString('Reward') or 0
            for _, pl in pairs(insphere) do
                if pl and IsValid(pl) and pl:IsPlayer() and rp.teams[pl:Team()] and rp.teams[pl:Team()].control and pl:Alive() and pl:GetMoveType() ~= MOVETYPE_NOCLIP then
                    local pl_fraction = rp.teams[pl:Team()].control
                    players[pl_fraction] = players[pl_fraction] or {}
                    table.insert(players[pl_fraction], pl)

                    -- if fraction_id == pl_fraction then
                    --     meta.util.Notify('blue', pl, string.format('За удержание точки %s республика выделила вам дополнительное жалование в размере %s', name, formatMoney(reward) ))
                    --     pl:PS_GivePoints(reward)
                    -- end
                end
            end

            for _, fraction_players in pairs(players) do
                -- if pl and IsValid(pl) and pl:IsPlayer() and pl:Alive() and pl:GetMoveType() ~= MOVETYPE_NOCLIP then
                for _, pl in pairs(fraction_players) do
                    local job = rp.teams[pl:Team()]
                    local pl_fraction = job.control
                    local occupied = ent:GetNWInt( "Occupied" )

                    local can_occupied = true
                    for fr, _ in pairs(rp.cfg.controlpoints_teams) do
                        players[fr] = players[fr] or {}
                        if fr ~= 0 and fr ~= pl_fraction then
                            if ent:GetNWInt( "CountOccupied" ) then
                                if #players[fr] >= #players[pl_fraction] then
                                    can_occupied = false
                                    break
                                end
                            else
                                if #players[fr] >= 1 then
                                    can_occupied = false
                                    break
                                end
                            end
                        end
                    end

                    if ent:GetNWBool( "CountBuff" ) and #players[pl_fraction] > 1 then
                        buff = buff* (#players[pl_fraction]*.2)
                    end

                    ent:SetNWBool( "Challenging", not can_occupied )

                    if fraction_id == 0 then
                        if occupied <= 1 then
                            ent:SetNWInt( "Occupied", occupied + buff )
                        else
                            ent:SetNWInt( "Team", pl_fraction )
                        end
                    elseif ent:GetNWInt( "Team" ) ~= pl_fraction and can_occupied then
                        if occupied > 0 and #players[pl_fraction] > 3 then
                            ent:SetNWInt( "Occupied", occupied - buff )
                        else
                            if ent:GetNWBool( "MomentOccupied" ) then
                                ent:SetNWInt( "Team", pl_fraction )
                            else
                                ent:SetNWInt( "Team", 0 )
                            end
                        end
                    elseif ent:GetNWInt( "Team" ) == pl_fraction and can_occupied then
                        if occupied < 1 then
                            ent:SetNWInt( "Occupied", occupied + buff )
                        elseif occupied > 1 then
                            ent:SetNWInt( "Occupied", 1 )
                        end
                    end

                    if occupied > 1 then
                        ent:SetNWInt( "Occupied", 1 )
                    end
                end
            end
        end
    end)
end)
