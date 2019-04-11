-- local function Robbing(pl)
-- 	local RobAmount = math.random(50, 1000)
-- 	local Target = pl:GetEyeTrace().Entity

-- 	if !pl:Alive() then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouAreDead'))
-- 		return ""
-- 	end

-- 	if !IsValid(Target) or (pl:EyePos():DistToSqr(Target:GetPos()) > 28900) or !Target:IsPlayer() then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('GetCloser'))
-- 		return ""
-- 	end

-- 	if pl:Team() != TEAM_ANARCHIST then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CantDoThis'))
-- 		return ""
-- 	end

-- 	if pl.RobCooldown != nil && CurTime() < pl.RobCooldown then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('NeedToWait'), math.ceil(pl.RobCooldown-CurTime()))
-- 		return ""
-- 	end

-- 	pl.RobCooldown = (CurTime() + 180)

-- 	pl:EmitSound("npc/combine_soldier/gear5.wav", 50, 100)

-- 	if Target:IsCP() then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('BaitingRule'))
-- 		pl:Wanted(nil, "Robbing")
-- 		return ""
-- 	end

-- 	if Target:Team() == TEAM_HOBO or Target:Team() == TEAM_HOBOKING then
-- 		if math.random(1, 4) != 2 then
-- 			rp.Notify(pl, NOTIFY_ERROR, rp.Term('YouGotHerpes'))
-- 			GiveSTD(pl)
-- 			return ""
-- 		end
-- 		rp.Notify(pl, NOTIFY_GENERIC, rp.Term('FoundNothing'))
-- 		return ""
-- 	end

-- 	if !Target:CanAfford(1000) then
-- 		rp.Notify(pl, NOTIFY_GENERIC, rp.Term('FoundNothing'))
-- 		rp.Notify(Target, NOTIFY_ERROR, rp.Term('RobberyAttempt'))
-- 		return ""
-- 	end

-- 	if math.random(1, 2) != 2 then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('RobberyFailed'))
-- 		rp.Notify(Target, NOTIFY_ERROR, rp.Term('RobberyAttempt'))
-- 		return ""
-- 	end

-- 	for k,v in pairs(ents.FindInSphere(pl:GetPos(),200)) do
-- 		if v:IsPlayer() && v:IsCP() && !pl:IsWanted() then
-- 			pl:Wanted(nil, "Robbing")
-- 		end
-- 	end

-- 	Target:AddMoney(-RobAmount)
-- 	pl:AddMoney(RobAmount)
-- 	rp.Notify(pl, NOTIFY_GREEN, rp.Term('YouRobbed'), RobAmount)
-- 	rp.Notify(Target, NOTIFY_ERROR, rp.Term('YouAreRobbed'))

-- 	return ""
-- end
-- rp.AddCommand("/rob", Robbing)
