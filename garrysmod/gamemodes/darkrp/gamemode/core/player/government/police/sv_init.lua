rp.ArrestedPlayers = rp.ArrestedPlayers or {}

function AddLineTerminal(msg)
    local tbl = nw.GetGlobal('CPTerminal') or {}
    table.insert(tbl, msg)
    if #tbl >= 11 then
        table.remove(tbl, 1)
    end

    nw.SetGlobal('CPTerminal', tbl)
end

function PLAYER:IsWarranted()
	return (self.HasWarrant == true)
end

function PLAYER:Warrant(actor, reason)
	self.HasWarrant = true
	timer.Simple(rp.cfg.WarrantTime, function()
		if IsValid(self) then
			self:UnWarrant()
		end
	end)
	rp.FlashNotifyAll('Warrant', rp.Term('Warranted'), self, reason, (IsValid(actor) and actor or 'Auto Warrant'))
	hook.Call('PlayerWarranted', GAMEMODE, self, actor, reason)
end

function PLAYER:UnWarrant(actor)
	rp.Notify(self, NOTIFY_GREEN, rp.Term('WarrantExpired'))
	self.HasWarrant = nil
	hook.Call('PlayerUnWarranted', GAMEMODE, self, actor)
end

function PLAYER:Wanted(actor, reason)
	self.CanEscape = nil
	self:SetNetVar('IsWanted', true)
	self:SetNetVar('WantedReason', reason)
	timer.Create('Wanted' .. self:SteamID64(), rp.cfg.WantedTime, 1, function()
		if IsValid(self) then
			self:UnWanted()
		end
	end)
	-- rp.FlashNotifyAll('Wanted', rp.Term('Wanted'), self, reason, (IsValid(actor) and actor or 'Auto Want'))

    rp.NotifyAll(NOTIFY_ERROR, string.format( '%s начал розыск игрока %s, Причина: %s.', actor:Name(), self:Name(), reason ))
	AddLineTerminal(string.format( '%s начал розыск %s, Причина: %s.', actor:Name(), self:Name(), reason ))

	hook.Call('PlayerWanted', GAMEMODE, self, actor, reason)
end

function PLAYER:UnWanted(actor)
	self:SetNetVar('IsWanted', nil)
	self:SetNetVar('WantedReason', nil)
	timer.Destroy('Wanted' .. self:SteamID64())
	hook.Call('PlayerUnWanted', GAMEMODE, self, actor)
end

local jails = rp.cfg.JailPos[game.GetMap()]
function PLAYER:Arrest(actor, reason)
	-- local time = rp.Karma(self, rp.cfg.ArrestTimeMax, rp.cfg.ArrestTimeMin)
	timer.Create('Arrested' .. self:SteamID64(), 120, 1, function()
		if IsValid(self) then
			self:UnArrest()
		end
	end)

	self:SetNetVar('ArrestedInfo', {Reason = (reason or self:GetWantedReason()), Release = CurTime() + time})
	if self:IsWanted() then self:UnWanted() end

	rp.ArrestedPlayers[self:SteamID64()] = true

	self:StripWeapons()
	self:SetHunger(100)
	self:SetHealth(100)
	self:SetArmor(0)

	rp.NotifyAll('Arrested', rp.Term('Arrested'), self)
	hook.Call('PlayerArrested', GAMEMODE, self, actor)

	self:SetPos(util.FindEmptyPos(jails[math.random(#jails)]))
	self.CanEscape = true

    AddLineTerminal(string.format( '%s арестовал %s.', actor:Name(), self:Name() ))
end

function PLAYER:UnArrest(actor)
	self:SetNetVar('ArrestedInfo', nil)
	timer.Destroy('Arrested' .. self:SteamID64())
	rp.ArrestedPlayers[self:SteamID64()] = nil
	timer.Simple(0.3, function() -- fucks up otherwise
		local _, pos = GAMEMODE:PlayerSelectSpawn(self)
		self:SetPos(pos)
		self:SetHealth(100)
		hook.Call('PlayerLoadout', GAMEMODE, self)
		rp.NotifyAll('UnArrested', rp.Term('UnArrested'), self)
		hook.Call('PlayerUnArrested', GAMEMODE, self, actor)
	end)

	AddLineTerminal(string.format( '%s выпустил %s', actor:Name(), self:Name() ))
end


-- Commands
-- rp.AddCommand('/911', function(pl, text)
-- 	if (text == '') then return end
-- 	for k, v in ipairs(player.GetAll()) do
-- 		if v:IsCP() or (v == pl) then
-- 			rp.Chat(CHAT_NONE, v, Color(255,255,51), '[911]', pl, text)
-- 		end
-- 	end
-- end)

util.AddNetworkString('Combine_SendRpCode')

util.AddNetworkString('Combine_WantedPlayer')
util.AddNetworkString('Combine_ToggleShield')
util.AddNetworkString('Combine_SendProtocol')
util.AddNetworkString('Combine_ForceStalker')
util.AddNetworkString('Combine_SendUpCode')

net.Receive('Combine_SendUpCode', function(len, ply)
    -- local reason = net.ReadString()
	local code = net.ReadString()
    if not ply:Alive() then return end
	if not ply:IsCP() and not ply:IsMayor() then return end

	if not rp.cfg.CPUpCodes[code] then return end

	-- if not rp.cfg.CanManageCode[pl:Team()] then return end
	-- if not table.HasValue(table.GetKeys(rp.cfg.AliveCodes), code) and code ~= '' then return end

	for _, pl in pairs(player.GetAll()) do
		if pl:IsCP() then
			CreateMark( pl, ply:GetPos(), code, rp.cfg.CPUpCodes[code], 'icon16/arrow_in.png', 25 )
		end
	end

	-- nw.SetGlobal('CPCode', code)
	-- rp.NotifyAll(NOTIFY_GREEN, string.format('%s объявил %s.', pl:Name(), rp.cfg.AliveCodes[code].text) )
end)

function PLAYER:MakeStalker()
    self:SetTeam(TEAM_STALKER)
    self:Spawn()

    timer.Simple(rp.cfg.TimerStalker, function()
        self:SetTeam(TEAM_CITIZEN)
        self:Spawn()
    end)

    self:StripWeapons()
end

net.Receive('Combine_ForceStalker', function(len, pl)
    local targ = rp.FindPlayer(net.ReadString())

	if not pl:IsCP() or not targ:IsCP() or pl == targ then return end
	if IsValid(targ) then
		targ:MakeStalker()
	end
end)

rp.combine_codes = {}
net.Receive('Combine_SendRpCode', function(len, pl)
    -- local reason = net.ReadString()
    if not pl:Alive() then return end
	local code = net.ReadString()
	if not pl:IsCP() and not pl:IsMayor() then return end
    if rp.combine_codes[pl:SteamID()] then return end

	if not rp.cfg.CanManageCode[pl:Team()] then return end
	if not table.HasValue(table.GetKeys(rp.cfg.AliveCodes), code) and code ~= '' then return end

    local i = table.insert(rp.combine_codes, pl:SteamID())
    timer.Simple(10, function()
        table.remove(rp.combine_codes, i)
    end)
    if code == 'red' then
        BroadcastLua( "surface.PlaySound('gmtech_dispatch/1/jw.mp3')" )
    elseif code == 'yellow' then
        BroadcastLua( "surface.PlaySound('gmtech_dispatch/1/ld.mp3')" )
    elseif code == 'work' then
        BroadcastLua( "surface.PlaySound('gmtech_dispatch/1/wp.mp3')" )
    end
	nw.SetGlobal('CPCode', code)
	rp.NotifyAll(NOTIFY_GREEN, string.format('%s объявил %s.', pl:Name(), rp.cfg.AliveCodes[code].text) )
end)

net.Receive('Combine_WantedPlayer', function(len, pl)
    local targ = rp.FindPlayer(net.ReadString())
    local reason = tostring(net.ReadString())
	if not pl:IsCP() and not pl:IsMayor() then return end
	if not IsValid(targ) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), targ:Name())
	elseif targ:IsWanted() then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerAlreadyWanted'), targ:Name())
	else
		targ:Wanted(pl, reason)
	end
end)

net.Receive('Combine_ToggleShield', function(len, pl)
    local index = net.ReadUInt(32)
    local ent = ents.GetByIndex(index)

    local bool = not ent:GetNetVar('PoliceOnly')

	if not pl:IsCP() and not pl:IsMayor() then return end
    ent:SetNetVar('PoliceOnly', bool )

    AddLineTerminal(string.format( '%s переключил силовой щит #%s на %s', pl:Name(), index, bool and 'Включен' or 'Выключен' ))
end)

net.Receive('Combine_SendProtocol', function(len, pl)
    if not pl:Alive() then return end
    local prot = net.ReadUInt(32)
	local targ = rp.FindPlayer(net.ReadString())

	if not pl:IsCP() and not pl:IsMayor() and rp.cfg.SupProtocols[prot] then return end
	if not rp.cfg.SupCommander[pl:Team()] or rp.teams[targ:Team()].type ~= rp.cfg.SupTeamType then return end
	prot = rp.cfg.SupProtocols[prot]

	targ:SetNetVar('CPProtocol', prot)
end)

function DoorActivate(ply, key)
    if key == IN_USE then
        local kek = {}
        kek.start = ply:GetPos()
        kek.endpos = ply:GetShootPos() + ply:GetAimVector() * 64
        kek.filter = ply

        local trace = util.TraceLine(kek)
        local target = trace.Entity
        if target and target:IsValid() and (target:GetClass() == "func_door" or target:GetClass() == "prop_door_rotating" or target:GetClass() == "prop_dynamic") then
            -- print(target,target:DoorGetGroup())
            if (ply:IsCP() and target:DoorGetGroup() == 'Гражданская Оборона') then
                target:Fire("Open")
            end
        end
    end
end
hook.Add( "KeyPress", "hl2rp_door_activate", DoorActivate )


-- rp.AddCommand('/want', function(pl, text, args)
-- 	if not pl:IsCP() and not pl:IsMayor() or not args[1] or not args[2] then return end
-- 	local targ = rp.FindPlayer(args[1])
-- 	if not IsValid(targ) then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), args[1])
-- 	elseif targ:IsWanted() then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerAlreadyWanted'), args[1])
-- 	else
-- 		local reason = table.concat(args, ' ', 2)
-- 		targ:Wanted(pl, reason)
-- 	end
-- end)

-- rp.AddCommand('/quickwant', function(pl, text, args)
-- 	if not pl:IsCP() and not pl:IsMayor() then return end
-- 	local targ = pl:GetEyeTrace(pl).Entity
-- 	if not IsValid(targ) or not targ:IsPlayer() or targ:IsWanted() then return end
-- 	targ:Wanted(pl, 'Quickwanted')
-- end)

-- rp.AddCommand('/unwant', function(pl, text, args)
-- 	if not pl:IsCP() and not pl:IsMayor() then return end
-- 	local targ = rp.FindPlayer(args[1])
-- 	if not IsValid(targ) then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), args[1])
-- 	elseif not targ:IsWanted() then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerNotWanted'), args[1])
-- 	else
-- 		targ:UnWanted(pl)
-- 	end
-- end)

-- rp.AddCommand('/warrant', function(pl, text, args)
-- 	if not pl:IsCP() and not pl:IsMayor() or not args[1] or not args[2] then return end
-- 	local targ = rp.FindPlayer(args[1])
-- 	if not IsValid(targ) then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), args[1])
-- 	elseif targ:IsWarranted() then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerAlreadyWarranted'), args[1])
-- 	else
-- 		local reason = table.concat(args, ' ', 2)
-- 		for k, v in pairs(rp.teams) do
-- 			if v.mayor then
-- 				mayors = team.GetPlayers(k)
-- 			end
-- 		end
-- 		if (#mayors > 1) and not pl:IsMayor() then
-- 			GAMEMODE.ques:Create(pl:Name() .. ' has requested a search warrant on ' .. targ:Name() .. ' for ' ..  reason, targ:EntIndex() .. 'warrant', mayors[1], 40, function(ret)
-- 				if IsValid(targ) and tobool(ret) then
-- 					rp.Notify(pl, NOTIFY_GREEN, rp.Term('WarrantRequestAcc'))
-- 					targ:Warrant(pl, reason)
-- 				else
-- 					rp.Notify(pl, NOTIFY_ERROR, rp.Term('WarrantRequestDen'))
-- 				end
-- 			end, pl, targ, reason)
-- 		else
-- 			targ:Warrant(pl, reason)
-- 			rp.Notify(pl, NOTIFY_GREEN, rp.Term('WarrantRequestAcc'))
-- 		end
-- 	end
-- end)

-- rp.AddCommand('/unwarrant', function(pl, text, args)
-- 	if not pl:IsCP() and not pl:IsMayor() or not args[1] then return end
-- 	local targ = rp.FindPlayer(args[1])
-- 	if not IsValid(targ) then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('WantedPlayerNotFound'), args[1])
-- 	elseif not targ:IsWarranted() then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PlayerNotWarranted'), args[1])
-- 	else
-- 		targ:UnWarrant(pl)
-- 	end
-- end)


local bounds = rp.cfg.Jails[game.GetMap()]
if bounds then
	hook('PlayerThink', function(pl)
		if IsValid(pl) and pl:IsArrested() and pl.CanEscape and (not pl:InBox(bounds[1], bounds[2])) then
			rp.ArrestedPlayers[pl:SteamID64()] = nil
			pl:SetNetVar('ArrestedInfo', nil)
			timer.Destroy('Arrested' .. pl:SteamID64())

			pl:Wanted(nil, 'Jail Escapee')

			hook.Call('PlayerLoadout', GAMEMODE, pl)
		end
	end)
end

hook('PlayerEntityCreated', function(pl)
	if pl:IsArrested() then
		pl:Arrest(nil, 'Disconnecting to avoid arrest')
	end
end)

hook('PlayerDeath', function(pl, killer, dmginfo)
	if (!killer:IsPlayer()) then return end

	if (pl ~= killer) and (killer ~= game.GetWorld()) then
		if killer:IsCP() and not pl:IsCP() then
			AddLineTerminal(string.format( '%s ампутировал %s.', killer:Name(), pl:Name() ))
		end

		if pl:IsWanted() and killer:IsCP() then
			pl:UnWanted()
		end
	end
end)
