local string 	= string
local IsValid 	= IsValid
local util 		= util

util.AddNetworkString('rp.toolEditor')

rp.pp = rp.pp or {
	ModelCache = {},
	Whitelist = {},
	BlockedTools = {},
}

local toolFuncs = {
	[0] = function(pl)
		return true
	end,
	[1] = PLAYER.IsVIP,
	[2] = PLAYER.IsAdmin,
	[3] = PLAYER.IsSuperAdmin,
    [4] = function(pl)
		-- return pl:GetUserGroup() == 'moderator' or pl:GetUserGroup() == 'founder'
        return false
	end,
}

local db = rp._Stats

function rp.pp.IsBlockedModel(mdl)
	mdl = string.lower(mdl or "")
	mdl = string.Replace(mdl, "\\", "/")
	mdl = string.gsub(mdl, "[\\/]+", "/")
	return not (rp.pp.Whitelist[mdl] == true)
end

function rp.pp.PlayerCanManipulate(pl, ent)

	if IsValid(ent:CPPIGetOwner()) and ent:CPPIGetOwner().propBuddies and ent:CPPIGetOwner().propBuddies[pl] then
		return true
	end

	return IsValid(ent:CPPIGetOwner())  and (ent:CPPIGetOwner() == pl) or pl:IsSuperAdmin()
end


local can_dupe = {
	['prop_physics'] = true,
	['keypad']		= true
}


function rp.pp.PlayerCanTool(pl, ent, tool)
    print(pl, ent, tool)
	-- if pl:IsBanned() then
	-- 	return false
	-- end

	local tool = tool:lower()

	if rp.pp.BlockedTools[tool] then
		local canTool = toolFuncs[rp.pp.BlockedTools[tool]](pl)
		if not canTool then
			rp.Notify(pl, NOTIFY_ERROR, rp.Term('CannotTool'), tool)
			return false
		end
	end

	local EntTable =
		(tool == "adv_duplicator" and pl:GetActiveWeapon():GetToolObject().Entities) or
		(tool == "advdupe2" and pl.AdvDupe2 and pl.AdvDupe2.Entities) or
		(tool == "duplicator" and pl.CurrentDupe and pl.CurrentDupe.Entities)

	if EntTable then
		for k, v in pairs(EntTable) do
			if not can_dupe[string.lower(v.Class)] then
				rp.Notify(pl, NOTIFY_ERROR, rp.Term('DupeRestrictedEnts'))
				return false
			end
		end
	end

	if ent:IsWorld() then
		return true
	elseif not IsValid(ent) then
		return false
	end

	local cantool = rp.pp.PlayerCanManipulate(pl, ent)

	if (cantool == true) then
		hook.Call('PlayerToolEntity', GAMEMODE, pl, ent, tool)
	end

	return cantool
end


--
-- Data
--
function rp.pp.WhitelistModel(mdl)
	db:Query('REPLACE INTO pp_whitelist VALUES(?);', mdl, function()
		rp.pp.Whitelist[mdl] = true
	end)
end

function rp.pp.BlacklistModel(mdl)
	db:Query('DELETE FROM pp_whitelist WHERE Model=?;', mdl, function()
		rp.pp.Whitelist[mdl] = nil
	end)
end

function rp.pp.AddBlockedTool(tool, rank)
	db:Query("REPLACE INTO pp_blockedtools VALUES(?, ?);", tool, rank, function()
		rp.pp.BlockedTools[tool] = rank
	end)
end

--
-- Load data
--

hook.Add('InitPostEntity', 'pp.InitPostEntity', function()
	-- Load whitelist
    print('load whitelist')
	db:Query('SELECT * FROM pp_whitelist;', function(data)
		for k, v in ipairs(data) do
            -- print(v.Model)
			rp.pp.Whitelist[v.Model] = true
		end

        -- print(rp.pp.Whitelist)


        timer.Simple(1, function()
            if rp.pp.Whitelist then
                nw.SetGlobal('Whitelist', rp.pp.Whitelist)
                nw.GetGlobal('Whitelist')
            end
        end)
	end)
	-- Load blocked tools
	db:Query('SELECT * FROM pp_blockedtools;', function(data)
		for k, v in ipairs(data) do
			rp.pp.BlockedTools[v.Tool] = v.Rank
		end
	end)
end)


--
-- Meta functions
--
function ENTITY:IsProp()
	return (self:GetClass() == 'prop_physics')
end

function ENTITY:CPPISetOwner(pl)
	self.pp_owner = pl
	self:SetNetVar('PropIsOwned', true)
    self:SetNetVar('PropGetOwner', pl)
end

function ENTITY:CPPIGetOwner()
	return self.pp_owner
end


--
-- Workarounds
--
PLAYER._AddCount = PLAYER._AddCount or PLAYER.AddCount
function PLAYER:AddCount(t, ent)
	if IsValid(ent) then
		ent:CPPISetOwner(self)
	end
	return self:_AddCount(t, ent)
end

ENTITY._SetPos = ENTITY._SetPos or ENTITY.SetPos
function ENTITY.SetPos(self, pos)
	if IsValid(self) and (not util.IsInWorld(pos)) and (not self:IsPlayer()) and (self:GetClass() ~= 'gmod_hands') then
		-- self:Remove()
		return
	end
	return self:_SetPos(pos)
end

local PHYS = FindMetaTable('PhysObj')
PHYS._SetPos = PHYS._SetPos or PHYS.SetPos
function PHYS.SetPos(self, pos)
	if IsValid(self) and (not util.IsInWorld(pos)) then
		--self:Remove()
		return
	end
	return self:_SetPos(pos)
end

ENTITY._SetAngles = ENTITY._SetAngles or ENTITY.SetAngles
function ENTITY:SetAngles(ang)
	if not ang then return self:_SetAngles(ang) end
	ang.p = ang.p % 360
	ang.y = ang.y % 360
	ang.r = ang.r % 360
	return self:_SetAngles(ang)
end

if undo then
	local AddEntity, SetPlayer, Finish =  undo.AddEntity, undo.SetPlayer, undo.Finish
	local Undo = {}
	local UndoPlayer
	function undo.AddEntity(ent, ...)
		if type(ent) ~= "boolean" and IsValid(ent) then table.insert(Undo, ent) end
		AddEntity(ent, ...)
	end

	function undo.SetPlayer(ply, ...)
		UndoPlayer = ply
		SetPlayer(ply, ...)
	end

	function undo.Finish(...)
		if IsValid(UndoPlayer) then
			for k,v in pairs(Undo) do
				v:CPPISetOwner(UndoPlayer)
			end
		end
		Undo = {}
		UndoPlayer = nil

		Finish(...)
	end
end

duplicator.BoneModifiers = {}
duplicator.EntityModifiers['VehicleMemDupe'] = nil
for k, v in pairs(duplicator.ConstraintType) do
	if (k ~= 'Weld') and (k ~= 'NoCollide') then
		duplicator.ConstraintType[k] = nil
	end
end

--
-- Commands
--
-- rp.AddCommand('/whitelist', function(pl, text, args)
-- 	if pl:IsSuperAdmin() then
-- 		local model = args[1]
-- 		if (not model) then return end

-- 		model = string.lower(model or "")
-- 		model = string.Replace(model, "\\", "/")
-- 		model = string.gsub(model, "[\\/]+", "/")

-- 		if rp.pp.IsBlockedModel(model) then
-- 			local pc_count =table.Count(rp.pp.ModelCache)
-- 			if (pc_count >= 100) then
-- 				pl:Notify(NOTIFY_ERROR, rp.Term('CacheFull'), pc_count)
-- 				return
-- 			end

-- 			local wl_count = table.Count(rp.pp.Whitelist)
-- 			if (wl_count >= 750) then
-- 				pl:Notify(NOTIFY_ERROR, rp.Term('WhitelistFull'), wl_count)
-- 				return
-- 			end

-- 			rp.pp.WhitelistModel(model)
-- 			rp.NotifyAll(NOTIFY_GENERIC, rp.Term('PropWhitelisted'), model, pl)
-- 		else
-- 			rp.pp.BlacklistModel(model)
-- 			rp.NotifyAll(NOTIFY_GENERIC, rp.Term('PropBlacklisted'), model, pl)
-- 		end
-- 	end
-- end)

-- rp.AddCommand('/shareprops', function(pl, text, args)
-- 	local targ = rp.FindPlayer(args[1])
-- 	if not IsValid(targ) then
-- 		rp.Notify(pl, NOTIFY_ERROR, rp.Term('PPTargNotFound'))
-- 		return
-- 	end

-- 	pl.propBuddies = pl.propBuddies or {}

-- 	if pl.propBuddies[targ] then
-- 		rp.Notify(pl, NOTIFY_GREEN, rp.Term('UnsharedPropsYou'), targ)
-- 		rp.Notify(targ, NOTIFY_GREEN, rp.Term('UnsharedProps'), pl)
-- 		pl.propBuddies[targ] = false
-- 	else
-- 		rp.Notify(pl, NOTIFY_GREEN, rp.Term('SharedPropsYou'), targ)
-- 		rp.Notify(targ, NOTIFY_GREEN, rp.Term('SharedProps'), pl)
-- 		pl.propBuddies[targ] = true
-- 	end

-- 	pl:SetNetVar('ShareProps', pl.propBuddies)
-- end)

-- rp.AddCommand('/tooleditor', function(pl, text, args)
-- 	if pl:IsSuperAdmin() then
-- 		net.Start('rp.toolEditor')
-- 			net.WriteTable(rp.pp.BlockedTools)
-- 		net.Send(pl)
-- 	end
-- end)

-- local ranks = {
-- 	[0] = 'user',
-- 	[1] = 'VIP',
-- 	[2] = 'Admin',
-- 	[3] = 'Globaladmin'
-- }
-- rp.AddCommand('/settoolgroup', function(pl, text, args)
-- 	if pl:IsSuperAdmin() then
-- 		if not args[1] or not args[2] then return end
-- 		rp.NotifyAll(NOTIFY_GENERIC, rp.Term('PPGroupSet'), args[1], ranks[tonumber(args[2])], pl)
-- 		rp.pp.AddBlockedTool(args[1], tonumber(args[2]))
-- 	end
-- end)


-- Overwrite
-- concommand.Add('gmod_admin_cleanup', function(pl, cmd, args)
-- 	if (not pl:IsRoot())  then
-- 		pl:Notify(NOTIFY_ERROR, rp.Term('CantAdminCleanup'))
-- 		return
-- 	end
-- 	if args[1] then
-- 		for k, v in ipairs(ents.GetAll()) do
-- 			if (v:GetClass() == args[1]) then
-- 				v:Remove()
-- 			end
-- 		end
-- 	end
-- end)
