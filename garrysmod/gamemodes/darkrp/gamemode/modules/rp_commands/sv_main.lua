local colors = rp.chatcolors

/*---------------------------------------------------------
 Shipments
 ---------------------------------------------------------*/
local function DropWeapon(pl)

	local ent = pl:GetActiveWeapon()
	if not IsValid(ent) then
		return
	end

	local canDrop = hook.Call("CanDropWeapon", GAMEMODE, pl, ent)

	if not canDrop then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotDropWeapon'))
		return
	end

	timer.Simple(1, function()
		if IsValid(pl) and IsValid(ent) and ent:GetModel() then
			pl:DropDRPWeapon(ent)
		end
	end)
end
rp.AddCommand("/drop", DropWeapon)

local function SetPrice(pl, args)
	if args == "" then
		return ""
	end

	local a = tonumber(args)
	if not a then
		return ""
	end

	local tr = util.TraceLine({
		start = pl:EyePos(),
		endpos = pl:EyePos() + pl:GetAimVector() * 85,
		filter = pl
	})

	if not IsValid(tr.Entity) then rp.Notify(pl, NOTIFY_ERROR, rp.Term('LookAtEntity')) return "" end


	if IsValid(tr.Entity) and tr.Entity.MaxPrice and (tr.Entity.ItemOwner == pl) then
		tr.Entity:Setprice(math.Clamp(a, tr.Entity.MinPrice, tr.Entity.MaxPrice))
	else
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotSetPrice'))
	end

	return ""
end
rp.AddCommand("/price", SetPrice)
rp.AddCommand("/setprice", SetPrice)

local function BuyPistol(ply, args)
	if args == "" then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('InvalidArg'))
		return ""
	end
	if ply:IsArrested() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotPurchaseItem'))
		return ""
	end

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)

	local class = nil
	local model = nil

	local shipment
	local price = 0
	for k,v in pairs(rp.shipments) do
		if v.seperate and (string.lower(v.name) == string.lower(args) or string.lower(v.entity) == string.lower(args)) and GAMEMODE:CustomObjFitsMap(v) then
			shipment = v
			class = v.entity
			model = v.model
			price = v.pricesep
            bodygroup = v.bodygroup
			local canbuy = false

			if v.allowed[ply:Team()] then
				canbuy = true
			end

			if v.customCheck and not v.customCheck(ply) then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term(v.CustomCheckFailMsg) or rp.Term('CannotPurchaseItem'))
				return ""
			end

			if not canbuy then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotPurchaseItem'))
				return ""
			end
		end
	end

	if not class then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ItemUnavailable'))
		return ""
	end

	if not ply:CanAfford(price) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
		return ""
	end

	local weapon = ents.Create(rp.clothes[class] and "spawned_clothe" or "spawned_weapon")
	weapon:SetModel(model)
	weapon.weaponclass = class
    weapon.bodygroup = bodygroup
	weapon.ShareGravgun = true
	weapon:SetPos(tr.HitPos)
	weapon.ammoadd = weapons.Get(class) and weapons.Get(class).Primary.DefaultClip
	weapon.nodupe = true
	weapon:Spawn()

	if shipment.onBought then
		shipment.onBought(ply, shipment, weapon)
	end
	hook.Call("playerBoughtPistol", nil, ply, shipment, weapon)

	if IsValid( weapon ) then
		ply:AddMoney(-price)
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('RPItemBought'), args, rp.FormatMoney(price))
	else
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('UnableToItem'))
	end

	return ""
end
rp.AddCommand("/buy", BuyPistol, 0.2)

local function DropClothe(ply, args)
	if args == "" then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('InvalidArg'))
		return ""
	end
	if ply:IsArrested() then
		return ""
	end

    local clothes = ply:GetNetVar('Clothes')

    local index = tonumber(args)
    local entity = clothes[index].entity

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)

	local class = nil
	local model = nil

	local shipment
	for k, v in pairs(rp.shipments) do
		if v.seperate and string.lower(v.entity) == entity and GAMEMODE:CustomObjFitsMap(v) then
			shipment = v
			class = v.entity
			model = v.model
            bodygroup = v.bodygroup
		end
	end

	local clothe = ents.Create("spawned_clothe")
	clothe:SetModel(model)
	clothe.weaponclass = class
    clothe.bodygroup = bodygroup
	clothe.ShareGravgun = true
	clothe:SetPos(tr.HitPos)
	clothe.nodupe = true
	clothe:Spawn()


    ply:SetBodygroup(index, 0)
    clothes[index] = nil
    ply:SetNetVar('Clothes', clothes)
    rp.data.SetClothes(ply, pon.encode(clothes))

	return ""
end
rp.AddCommand("/dropclothe", DropClothe, 0.2)

local function BuyShipment(ply, args)
	if args == "" then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('InvalidArg'))
		return ""
	end

	if ply.LastShipmentSpawn and ply.LastShipmentSpawn > (CurTime() - 1) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ShipmentCooldown'))
		return ""
	end
	ply.LastShipmentSpawn = CurTime()

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)

	if ply:IsArrested() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotPurchaseItem'))
		return ""
	end

	local found = false
	local foundKey
	for k,v in pairs(rp.shipments) do
		if string.lower(args) == string.lower(v.name) and not v.noship and GAMEMODE:CustomObjFitsMap(v) then
			found = v
			foundKey = k
			local canbecome = false

			for a,b in pairs(v.allowed) do
				if ply:Team() == a then
					canbecome = true
				end
			end

			if v.customCheck and not v.customCheck(ply) then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term(v.CustomCheckFailMsg) or rp.Term('CannotPurchaseItem'))
				return ""
			end

			if not canbecome then
				rp.Notify(ply, NOTIFY_ERROR, rp.Term('IncorrectJob'))
				return ""
			end
		end
	end

	if not found then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ItemUnavailable'))
		return ""
	end

	local cost = found.price

	if not ply:CanAfford(cost) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
		return ""
	end

	local crate = ents.Create(found.shipmentClass or "spawned_shipment")

	crate:SetPos(Vector(tr.HitPos.x, tr.HitPos.y, tr.HitPos.z))
	crate:Spawn()
	if found.shipmodel then
		crate:SetModel(found.shipmodel)
	end
	crate:SetContents(foundKey, found.amount)

	if rp.shipments[foundKey].onBought then
		rp.shipments[foundKey].onBought(ply, rp.shipments[foundKey], weapon)
	end
	hook.Call("playerBoughtShipment", nil, ply, rp.shipments[foundKey], weapon)

	if IsValid( crate ) then
		ply:AddMoney(-cost)
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('RPItemBought'), args, rp.FormatMoney(cost))

		hook.Call('PlayerBoughtItem', GAMEMODE, ply, rp.shipments[foundKey].name .. ' Shipment', cost, ply:GetMoney())
	else
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('UnableToItem'))
	end

	return ""
end
rp.AddCommand("/buyshipment", BuyShipment)

local function BuyAmmo(ply, args)
	if args == "" then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('InvalidArg'))
		return ""
	end

	if ply:IsArrested() then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotPurchaseItem'))
		return ""
	end

	local found
	for k,v in pairs(rp.ammoTypes) do
		if v.ammoType == args then
			found = v
			break
		end
	end

	if not found or (found.customCheck and not found.customCheck(ply)) then
		rp.Notify(ply, NOTIFY_ERROR, found and rp.Term(found.CustomCheckFailMsg) or rp.Term('ItemUnavailable'))
		return ""
	end

	if not ply:CanAfford(found.price) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
		return ""
	end

	rp.Notify(ply, NOTIFY_GREEN, rp.Term('RPItemBought'), found.name, rp.FormatMoney(found.price))
	ply:AddMoney(-found.price)

	ply:GiveAmmo(found.amountGiven, found.ammoType)

	return ""
end
rp.AddCommand("/buyammo", BuyAmmo, 1)

-- local function BuyHealth(ply)
-- 	local cost = 500

-- 	if not ply:Alive() then
-- 		return ""
-- 	end
-- 	if not ply:CanAfford(cost) then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
-- 		return ""
-- 	end
-- 	if not rp.teams[ply:Team()] or not rp.teams[ply:Team()].medic then
-- 		local foundMedics = false
-- 		for k,v in pairs(rp.teams) do
-- 			if v.medic and team.NumPlayers(k) > 0 then
-- 				foundMedics = true
-- 				break
-- 			end
-- 		end
-- 		if foundMedics then
-- 			rp.Notify(ply, NOTIFY_ERROR, rp.Term('MedicExists'))
-- 			return ""
-- 		end
-- 	end
-- 	if ply.StartHealth and ply:Health() >= ply.StartHealth then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('HealthIsFull'))
-- 		return ""
-- 	end
-- 		if ply.NextBuyHealth != nil && ply.NextBuyHealth >= CurTime() then
-- 			rp.Notify(ply, NOTIFY_ERROR, rp.Term('NeedToWait'), math.Round(ply.NextBuyHealth - CurTime(), 0))
-- 		return
-- 	end
-- 	ply.NextBuyHealth = CurTime() + 30
-- 	ply.StartHealth = ply.StartHealth or 100
-- 	ply:AddMoney(-cost)
-- 	rp.Notify(ply, NOTIFY_GREEN, rp.Term('RPItemBought'), 'health', rp.FormatMoney(cost))
-- 	ply:SetHealth(ply.StartHealth)
-- 	return ""
-- end
-- rp.AddCommand("/buyhealth", BuyHealth)

-- /*---------------------------------------------------------
--  Jobs
--  ---------------------------------------------------------*/
-- rp.AddCommand('/agenda', function(pl, text, args)
-- 	if rp.agendas[pl:Team()] and (rp.agendas[pl:Team()].manager == pl:Team()) then
-- 		nw.SetGlobal('Agenda;' .. pl:Team(), text)
-- 	else
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('IncorrectJob'))
-- 	end
-- 	return ""
-- end)

-- local function ChangeJob(ply, args)
-- 	if args == "" then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('InvalidArg'))
-- 		return ""
-- 	end

-- 	if ply:IsArrested() then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotJob'))
-- 		return ""
-- 	end

-- 	if ply.LastJob and 10 - (CurTime() - ply.LastJob) >= 0 then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('NeedToWait'), math.ceil(10 - (CurTime() - ply.LastJob)))
-- 		return ""
-- 	end
-- 	ply.LastJob = CurTime()

-- 	if not ply:Alive() then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotJob'))
-- 		return ""
-- 	end

-- 	local len = string.len(args)

-- 	if len < 3 then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('JobLenShort'), 2)
-- 		return ""
-- 	end

-- 	if len > 25 then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('JobLenLong'), 26)
-- 		return ""
-- 	end

-- 	local canChangeJob, message, replace = hook.Call("canChangeJob", nil, ply, args)
-- 	if canChangeJob == false then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotJob'))
-- 		return ""
-- 	end

-- 	local job = replace or args
-- 	rp.NotifyAll(NOTIFY_GENERIC, rp.Term('ChangeJob'), ply, (string.match(job, '^h?[AaEeIiOoUu]') and 'an' or 'a'), job)

-- 	ply:SetNetVar('job', job)
-- 	return ""
-- end
-- rp.AddCommand("/job", ChangeJob)

-- local function FinishDemote(vote, choice)
-- 	local target = vote.target

-- 	target.IsBeingDemoted = nil
-- 	if choice == 1 then
-- 		target:TeamBan()
-- 		if target:Alive() then
-- 			target:ChangeTeam(rp.DefaultTeam, true)
-- 		else
-- 			target.demotedWhileDead = true
-- 		end

-- 		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('PlayerDemoted'), target)
-- 	else
-- 		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('PlayerNotDemoted'), target)
-- 	end
-- end

-- local function Demote(ply, args)
-- 	local tableargs = string.Explode(" ", args)
-- 	if #tableargs == 1 then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('DemotionReason'))
-- 		return ""
-- 	end
-- 	local reason = ""
-- 	for i = 2, #tableargs, 1 do
-- 		reason = reason .. " " .. tableargs[i]
-- 	end
-- 	reason = string.sub(reason, 2)
-- 	if string.len(reason) > 99 then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('DemoteReasonLong'), 100)
-- 		return ""
-- 	end
-- 	local p = rp.FindPlayer(tableargs[1])
-- 	if p == ply then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('DemoteSelf'))
-- 		return ""
-- 	end

-- 	local canDemote, message = hook.Call("CanDemote", GAMEMODE, ply, p, reason)
-- 	if canDemote == false then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('UnableToDemote'))
-- 		return ""
-- 	end

-- 	if p then
-- 		if ply:GetTable().LastVoteCop and CurTime() - ply:GetTable().LastVoteCop < 80 then
-- 			rp.Notify(ply, NOTIFY_ERROR, rp.Term('NeedToWait'),  math.ceil(80 - (CurTime() - ply:GetTable().LastVoteCop)))
-- 			return ""
-- 		end
-- 		if not rp.teams[p:Team()] or rp.teams[p:Team()].candemote == false then
-- 			rp.Notify(ply, NOTIFY_ERROR, rp.Term('UnableToDemote'))
-- 		else
-- 			rp.Chat(CHAT_NONE, p, colors.Yellow, '[DEMOTE] ', ply, 'I want to demote you. Reason: ' .. reason)

-- 			rp.NotifyAll(NOTIFY_GENERIC, rp.Term('DemotionStarted'), ply, p)
-- 			p.IsBeingDemoted = true

-- 			hook.Call('playerDemotePlayer', GAMEMODE, ply, p, reason)

-- 			GAMEMODE.vote:create(p:Nick() .. ":\nDemotion nominee:\n"..reason, "demote", p, 20, FinishDemote,
-- 			{
-- 				[p] = true,
-- 				[ply] = true
-- 			}, function(vote)
-- 				if not IsValid(vote.target) then return end
-- 				vote.target.IsBeingDemoted = nil
-- 			end)
-- 			ply:GetTable().LastVoteCop = CurTime()
-- 		end
-- 		return ""
-- 	else
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CantFindPlayer'), tostring(args))
-- 		return ""
-- 	end
-- end
-- rp.AddCommand("/demote", Demote)

-- /*---------------------------------------------------------
-- Talking
--  ---------------------------------------------------------*/
-- local function PM(pl, text, args)
-- 	local namepos = string.find(text, " ")
-- 	if not namepos then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('InvalidArg'))
-- 		return ""
-- 	end

-- 	local name = string.sub(text, 1, namepos - 1)
-- 	local msg = string.sub(text, namepos + 1)
-- 	if msg == "" then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('InvalidArg'))
-- 		return ""
-- 	end
-- 	local targ = rp.FindPlayer(name)

-- 	if targ then
-- 		--rp.Chat(CHAT_PM, pl, colors.Yellow, '[PM > ' .. targ:Name() .. '] ', pl, msg)
-- 		--rp.Chat(CHAT_PM, targ, colors.Yellow, '[PM] ', pl, msg)

-- 		rp.Chat(CHAT_PM, {pl, targ}, colors.Yellow, pl, targ, msg)
-- 		targ.LastPM = pl
-- 	else
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CantFindPlayer'), tostring(name))
-- 	end

-- 	return ""
-- end
-- rp.AddCommand("/pm", PM)

-- rp.AddCommand("/re", function(pl, text, args)
-- 	local targ = pl.LastPM
-- 	local msg = table.concat(args, ' ')
-- 	if IsValid(targ) then
-- 		--rp.Chat(CHAT_PM, pl, colors.Yellow, '[PM > ' .. targ:Name() .. '] ', pl, msg)
-- 		--rp.Chat(CHAT_PM, targ, colors.Yellow, '[PM] ', pl, msg)

-- 		rp.Chat(CHAT_PM, {pl, targ}, colors.Yellow, pl, targ, msg)
-- 		targ.LastPM = pl
-- 	else
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('NoPMResponder'))
-- 	end

-- end)

local function Whisper(pl, text, args)
	if text == '' then
		return
	end
	rp.LocalChat(CHAT_LOCAL, pl, 90, colors.Purple, '[Шепчет] ', pl, text)
end
rp.AddCommand("/w", Whisper)
rp.AddCommand("/whisper", Whisper)

local function Yell(pl, text, args)
	if text == '' then
		return
	end
	rp.LocalChat(CHAT_LOCAL, pl, 600, colors.Red, '[Кричит] ', pl, text)
end
rp.AddCommand("/y", Yell)
rp.AddCommand("/yell", Yell)

local function NonRP(pl, text, args)
	if text == '' then
		return
	end
	rp.LocalChat(CHAT_NONE, pl, 300, Color(122,199,76), '[LOOC] ', pl, text)
end
rp.AddCommand("/l", NonRP)
rp.AddCommand("/nrp", NonRP)

local function Me(pl, text, args)
	if text == '' then
		return
	end
	rp.LocalChat(CHAT_NONE, pl, 600, team.GetColor(pl:Team()), pl:Name() .. ' ', text)
end
rp.AddCommand("/me", Me)

local function OOC(pl, text, args)
	if text == '' then
		return
	end
	rp.GlobalChat(CHAT_OOC, colors.OOC, '[OOC] ', pl, text)
end
rp.AddCommand("//", OOC)
rp.AddCommand("/ooc", OOC)

local function PlayerAdvertise(pl, text, args)
	if text == '' then
		return
	end
	local cost = 30
	if pl:CanAfford(cost) then
		pl:AddMoney(-cost)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('RPItemBought'), 'advertising', rp.FormatMoney(cost))
		rp.GlobalChat(CHAT_NONE, colors.Orange, '[Объявление] ', pl, text)
	else
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotAfford'))
	end

end
rp.AddCommand("/advert", PlayerAdvertise, 1.5)
rp.AddCommand("/ad", PlayerAdvertise, 1.5)

-- local function MayorBroadcast(pl, text, args)
-- 	if text == '' or not pl:IsMayor() then
-- 		return
-- 	end
-- 	rp.GlobalChat(CHAT_NONE, colors.Red, '[Broadcast] ', pl, text)
-- end
-- rp.AddCommand("/broadcast", MayorBroadcast)
-- rp.AddCommand("/b", MayorBroadcast)

-- local function SetRadioChannel(pl, text, args)
-- 	if tonumber(text) == nil or tonumber(text) < 0 or tonumber(text) > 100 then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('ChannelLimit'))
-- 		return
-- 	end
-- 	rp.Notify(pl, NOTIFY_GREEN, rp.Term('ChannelSet'), tonumber(text))
-- 	pl.RadioChannel = tonumber(text)
-- end
-- rp.AddCommand("/channel", SetRadioChannel)

-- local function SayThroughRadio(pl, text, args)
-- 	if text == '' then
-- 		return
-- 	elseif not pl.RadioChannel then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('ChannelNotSet'))
-- 	end

-- 	table.foreach(player.GetAll(), function(_, v)
-- 		if v.RadioChannel and v.RadioChannel == pl.RadioChannel then
-- 			rp.Chat(CHAT_RADIO, v, colors.Grey, '[Channel ' .. v.RadioChannel .. '] ', pl, text)
-- 		end
-- 	end)
-- end
-- rp.AddCommand("/radio", SayThroughRadio)
-- rp.AddCommand("/r", SayThroughRadio)

-- local function GroupMsg(pl, text, args)
-- 	if text == '' then return end
-- 	rp.groupChat(pl, text)
-- end
-- rp.AddCommand("/g", GroupMsg)
-- rp.AddCommand("/group", GroupMsg)

/*---------------------------------------------------------
 Money
 ---------------------------------------------------------*/
local function GiveMoney(ply, text, args)
	if text == "" then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('InvalidArg'))
		return ""
	end

	if not tonumber(text) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('InvalidArg'))
		return ""
	end
	local trace = ply:GetEyeTrace()

	if IsValid(trace.Entity) and trace.Entity:IsPlayer() and trace.Entity:GetPos():DistToSqr(ply:GetPos()) < 22500 then
		local amount = math.floor(tonumber(text))

		if amount < 1 then
			rp.Notify(ply, NOTIFY_ERROR, rp.Term('GiveMoneyLimit'))
			return
		end

		if not ply:CanAfford(amount) then
			rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
			return ""
		end

		if not ply:CanAfford(amount) then
			rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
			return ""
		end

		rp.data.PayPlayer(ply, trace.Entity, amount)

		rp.Notify(trace.Entity, NOTIFY_GREEN, rp.Term('PlayerGaveCash'), ply, rp.FormatMoney(amount))
		rp.Notify(ply, NOTIFY_GREEN, rp.Term('YouGaveCash'), trace.Entity, rp.FormatMoney(amount))
	else
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('MustLookAtPlayer'))
	end
	return ""
end
rp.AddCommand("/give", GiveMoney, 0.2)
rp.AddCommand("/addmoney", GiveMoney, 0.2)

local function DropMoney(ply, args)
	if args == "" then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('InvalidArg'))
		return ""
	end

	if not tonumber(args) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('InvalidArg'))
		return ""
	end
	local amount = math.floor(tonumber(args))

	if amount <= 1 then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('DropMoneyLimit'))
		return ""
	end

	if not ply:CanAfford(amount) then
		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
		return ""
	end

	ply:AddMoney(-amount)

	hook.Call('PlayerDropRPMoney', GAMEMODE, ply, amount, ply:GetMoney())

	local trace = {}
	trace.start = ply:EyePos()
	trace.endpos = trace.start + ply:GetAimVector() * 85
	trace.filter = ply

	local tr = util.TraceLine(trace)
	rp.SpawnMoney(tr.HitPos, amount)

	return ""
end
rp.AddCommand("/dropmoney", DropMoney, 0.3)
rp.AddCommand("/moneydrop", DropMoney, 0.3)

util.AddNetworkString('ToggleRevertMask')

local function MaskRevert(ply, args)
    local job = rp.teams[ply:Team()]
	if ply and job.mask_group then
		local mask = not ply:GetNetVar('CPMask')
		ply:SetNetVar('CPMask',mask)

		-- print(meta.jobs[ply:Team()].mask_group)
		ply:SetBodygroup(2,mask and job.mask_group or 0)

		-- ply:ConCommand(mask and 'say /me достал маску из сумки, и надел на лицо.' or 'say /me отщелкнул механизм на маске, и положил ее в сумку.')
		-- ply:ConCommand('meta me test')
		rp.Notify(ply, NOTIFY_GENERIC, mask and 'Вы надели маску.' or 'Вы сняли маску.' )

		ply:EmitSound('player/suit_sprint.wav', 75, 100, 1, CHAN_AUTO)

        -- netstream.Start(ply,'ToggleRevertMask',nil)
        net.Start('ToggleRevertMask')
        net.Send(ply)
	else
		rp.Notify(ply, NOTIFY_ERROR, 'У вас нету маски')
    end
end
rp.AddCommand("/mask", MaskRevert, 0)

local function SendLoyal(ply, args)
	if ply:IsLoyal() then
    	for _, pl in pairs(player.GetAll()) do
            if pl:IsCP() or ply == pl then
                CreateMark( pl, ply:GetPos(), ply:Name(), 'Вызов от лоялиста', 'icon16/shield.png', 45 )
            end
        end
        rp.Notify(ply, NOTIFY_GENERIC, 'Вы вызвали Гражданскую Оборону. Оставайтесь на месте')
    end
end
rp.AddCommand("/sendloyal", SendLoyal, 0)


-- local function CreateCheque(ply, args)
-- 	local argt = string.Explode(" ", args)
-- 	local recipient = rp.FindPlayer(argt[1])
-- 	local amount = tonumber(argt[2]) or 0

-- 	if not recipient then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ChequeArg1'))
-- 		return ""
-- 	end

-- 	if amount <= 1 then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('ChequeArg2'))
-- 		return ""
-- 	end

-- 	if not ply:CanAfford(amount) then
-- 		rp.Notify(ply, NOTIFY_ERROR, rp.Term('CannotAfford'))
-- 		return ""
-- 	end

-- 	if IsValid(ply) and IsValid(recipient) then
-- 		ply:AddMoney(-amount)

-- 		local trace = {}
-- 		trace.start = ply:EyePos()
-- 		trace.endpos = trace.start + ply:GetAimVector() * 85
-- 		trace.filter = ply

-- 		local tr = util.TraceLine(trace)
-- 		local Cheque = ents.Create("darkrp_cheque")
-- 		Cheque:SetPos(tr.HitPos)
-- 		Cheque:Setowning_ent(ply)
-- 		Cheque:Setrecipient(recipient)

-- 		Cheque:Setamount(math.Min(amount, 2147483647))
-- 		Cheque:Spawn()

-- 		hook.Call('PlayerDropRPCheck', GAMEMODE, ply, recipient, Cheque:Getamount(), ply:GetMoney())
-- 	end

-- 	return ""
-- end
-- rp.AddCommand("/cheque", CreateCheque, 0.3)
-- rp.AddCommand("/check", CreateCheque, 0.3) -- for those of you who can't spell


-- local function MakeZombieSoundsAsHobo(ply)
-- 	if not ply.nospamtime then
-- 		ply.nospamtime = CurTime() - 2
-- 	end
-- 	if not rp.teams[ply:Team()] or not rp.teams[ply:Team()].hobo or CurTime() < (ply.nospamtime + 1.3) or (IsValid(ply:GetActiveWeapon()) and ply:GetActiveWeapon():GetClass() ~= "weapon_bugbait") then
-- 		return
-- 	end
-- 	ply.nospamtime = CurTime()
-- 	local ran = math.random(1,3)
-- 	if ran == 1 then
-- 		ply:EmitSound("npc/zombie/zombie_voice_idle"..tostring(math.random(1,14))..".wav", 100,100)
-- 	elseif ran == 2 then
-- 		ply:EmitSound("npc/zombie/zombie_pain"..tostring(math.random(1,6))..".wav", 100,100)
-- 	elseif ran == 3 then
-- 		ply:EmitSound("npc/zombie/zombie_alert"..tostring(math.random(1,3))..".wav", 100,100)
-- 	end
-- end
-- concommand.Add("_hobo_emitsound", MakeZombieSoundsAsHobo)


-- local no = {
-- 	['weapon_physgun'] 	= true,
-- 	['weapon_gravgun'] 	= true,
-- 	['gmod_tool']		= true
-- }

-- rp.AddCommand("/destroy", function(pl, text, args)
-- 	local active = pl:GetActiveWeapon():GetClass()
-- 	if no[active] then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotDestroyWeapon'))
-- 		return
-- 	end
-- 	pl:StripWeapon(active)
-- end)
