util.AddNetworkString('rp.keysMenu')

function ENTITY:DoorIndex()
	return (self:EntIndex() - game.MaxPlayers())
end

function ENTITY:DoorLock(locked)
	self.Locked = locked
	if (locked == true) then
		self:Fire('lock', '', 0)
	elseif (locked == false) then
		self:Fire('unlock', '', 0)
	end
end

function ENTITY:DoorOwn(pl)
	pl:SetVar('doorCount', (pl:GetVar('doorCount') or 0) + 1, false, false)
	self:SetNetVar('DoorData', {Owner = pl})
end

function ENTITY:DoorUnOwn()
	if IsValid(self:DoorGetOwner()) then
		self:DoorGetOwner():SetVar('doorCount', (self:DoorGetOwner():GetVar('doorCount') or 0) - 1, false, false)
	end
	self:DoorLock(false)
	self:SetNetVar('DoorData', nil)
end

function ENTITY:DoorCoOwn(pl)
	local data = self:GetNetVar('DoorData') or {}
	data.CoOwners =  data.CoOwners or {}
	data.CoOwners[#data.CoOwners + 1] = pl
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorUnCoOwn(pl)
	local data = self:GetNetVar('DoorData') or {}
	table.RemoveByValue(data.CoOwners or {}, pl)
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorSetOrgOwn(bool)
	local data = self:GetNetVar('DoorData') or {}
	data.OrgOwn = bool
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorSetTitle(title)
	local data = self:GetNetVar('DoorData') or {}
	data.Title = title
	self:SetNetVar('DoorData', data)
end

function ENTITY:DoorSetTeam(t)
	self:SetNetVar('DoorData', {Team = t})
end

function ENTITY:DoorSetGroup(g)
	self:SetNetVar('DoorData', {Group = g})
end

function ENTITY:DoorSetOwnable(ownable)
	if (ownable == true) then
		self:SetNetVar('DoorData', false)
	elseif (ownable == false) then
		self:SetNetVar('DoorData', nil)
	end
end

function PLAYER:DoorUnOwnAll()
	for k, v in ipairs(ents.GetAll()) do
		if IsValid(v) and v:IsDoor() then
			if v:DoorOwnedBy(self) then
				v:DoorUnOwn()
			elseif v:DoorCoOwnedBy(self) then
				v:DoorUnCoOwn(self)
			end
		end
	end
end

//
// Load door data
//
local db = rp._Stats

local function loadDoorData()
	for k, v in ipairs(ents.GetAll()) do
		if v:IsDoor() then
			v:Fire('unlock', '', 0)
			v.Locked = false
		end
	end
	db:Query('SELECT * FROM rp_doordata WHERE Map="' .. string.lower(game.GetMap()) .. '";', function(data)
		for k, v in ipairs(data or {}) do
            -- print(v.Index + game.MaxPlayers())
			local ent = Entity(v.Index + game.MaxPlayers())
			if IsValid(ent) then
				if (v.Title ~= nil) and (v.Title ~= 'NULL') then -- fuck you if you rethink im redoing the door data
					ent:DoorSetTitle(v.Title)
				end

				if (v.Team ~= nil) and (v.Team ~= 'NULL') then
					ent:DoorSetTeam(tonumber(v.Team))
				end

				if (v.Group ~= nil) and (v.Group ~= 'NULL') then
					ent:DoorSetGroup(v.Group)
				end

				if (v.Ownable ~= nil) and (v.Team == nil or v.Team == 'NULL') and (v.Group == nil or v.Group == 'NULL') then
					ent:DoorSetOwnable(tobool(v.Ownable))
				end

				if (v.Locked ~= nil) and (v.Locked ~= 'NULL') then
					ent:DoorLock(tobool(v.Locked))
				end
			end
		end
	end)
end
hook('InitPostEntity', 'DoorData_InitPostEntity', loadDoorData)
hook('PostCleanupMap', 'DoorData_PostCleanupMap', loadDoorData)

local function storeDoorData(ent)
	db:Query('REPLACE INTO rp_doordata(`Index`,`Map`,`Title`,`Team`,`Group`,`Ownable`,`Locked`) VALUES(?,?,?,?,?,?,?)', ent:DoorIndex(), string.lower(game.GetMap()), ent:DoorGetTitle() or 'NULL', ent:DoorGetTeam() or 'NULL', ent:DoorGetGroup() or 'NULL', (ent:DoorIsOwnable() and 0 or 1), (ent.Locked and 1 or 0))
end


//
// Admin Commands
//
rp.AddCommand('/setownable', function(pl, text, args)
	if pl:IsSuperAdmin() then
		local ent = pl:GetEyeTrace().Entity
		if IsValid(ent) and ent:IsDoor() then
			ent:DoorSetOwnable(ent:DoorIsOwnable())
			storeDoorData(ent)
		end
	end
end)

rp.AddCommand('/setteamown', function(pl, text, args)
	if pl:IsSuperAdmin() then
		local ent = pl:GetEyeTrace().Entity
		if IsValid(ent) and ent:IsDoor() then
			ent:DoorUnOwn()
			ent:DoorSetTeam(tonumber(args[1]))
			storeDoorData(ent)
		end
	end
end)

rp.AddCommand('/setgroupown', function(pl, text, args)
	if pl:IsSuperAdmin() then
		local ent = pl:GetEyeTrace().Entity
		if IsValid(ent) and ent:IsDoor() then
			ent:DoorUnOwn()
			ent:DoorSetGroup(text)
			storeDoorData(ent)
		end
	end
end)

rp.AddCommand('/setlocked', function(pl, text, args)
	if pl:IsSuperAdmin() then
		local ent = pl:GetEyeTrace().Entity
		if IsValid(ent) and ent:IsDoor() then
			rp.Notify(pl, NOTIFY_GENERIC, (ent.Locked and rp.Term('DoorUnlocked') or rp.Term('DoorLocked')))
			ent:DoorLock(not ent.Locked)
			storeDoorData(ent)
		end
	end
end)


//
// Commands
//
rp.AddCommand('/buydoor', function(pl, text, args)
	if (pl:GetVar('doorCount') or 0) >= 8 then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('MaxDoors'))
		return
	end

	local cost = pl:Wealth(rp.cfg.DoorCostMin, rp.cfg.DoorCostMax)

	if not pl:CanAfford(cost) then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotAfford'))
		return
	end

	local ent = pl:GetEyeTrace().Entity
    print(IsValid(ent), ent:IsDoor(), ent:DoorIsOwnable(), (ent:GetPos():DistToSqr(pl:GetPos()) < 712^2))
	if IsValid(ent) and ent:IsDoor() and (not ent:DoorGetOwner() ~= nil) and (ent:GetPos():DistToSqr(pl:GetPos()) < 712^2) then
		pl:TakeMoney(cost)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorBought'), rp.FormatMoney(cost))
		ent:DoorOwn(pl)
	end
end)

rp.AddCommand('/addcoowner', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity
	local co = rp.FindPlayer(args[1])

	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (co ~= nil) and (co ~= pl) and not ent:DoorCoOwnedBy(co) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorOwnerAdded'), co)
		rp.Notify(co, NOTIFY_GREEN, rp.Term('DoorOwnerAddedYou'), pl)
		ent:DoorCoOwn(co)
	end
end)

rp.AddCommand('/removecoowner', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity
	local co = rp.FindPlayer(args[1])

	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (co ~= nil) and ent:DoorCoOwnedBy(co) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorOwnerRemoved'), co)
		rp.Notify(co, NOTIFY_GREEN, rp.Term('DoorOwnerRemovedYou'), pl)
		ent:DoorUnCoOwn(co)
	end
end)

rp.AddCommand('/selldoor', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		pl:AddMoney(rp.cfg.DoorCostMin)
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorSold'), rp.FormatMoney(rp.cfg.DoorCostMin))
		ent:DoorUnOwn(pl)
	end
end)

rp.AddCommand('/settitle', function(pl, text, args)
	if (text == '') then return end
	local ent = pl:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) then
		rp.Notify(pl, NOTIFY_GENERIC, rp.Term('DoorTitleSet'))
		ent:DoorSetTitle(string.sub(text, 1, 25))
	end
end)

rp.AddCommand('/orgown', function(pl, text, args)
	local ent = pl:GetEyeTrace().Entity
	if IsValid(ent) and ent:IsDoor() and ent:DoorOwnedBy(pl) and (ent:GetPos():DistToSqr(pl:GetPos()) < 13225) and pl:GetOrg() then
		rp.Notify(pl, NOTIFY_GENERIC, (ent:DoorOrgOwned() and rp.Term('OrgDoorDisabled') or rp.Term('OrgDoorEnabled')))
		ent:DoorSetOrgOwn(not ent:DoorOrgOwned())
	end
end)

rp.AddCommand('/sellall', function(pl, text, args)
	if (pl:GetVar('doorCount') or 0) <= 0 then
		rp.Notify(pl, NOTIFY_ERROR, rp.Term('NoDoors'))
		return
	end
	local count = pl:GetVar('doorCount')
	local amt = (count * rp.cfg.DoorCostMin)
	pl:DoorUnOwnAll()
	pl:AddMoney(amt)
	rp.Notify(pl, NOTIFY_GREEN, rp.Term('DoorsSold'), count, rp.FormatMoney(amt))
end)
