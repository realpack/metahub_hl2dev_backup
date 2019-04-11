local istable = istable

local doorClasses = {
	['func_door'] = true,
	['func_door_rotating'] = true,
	['prop_door_rotating'] = true,
	--['prop_dynamic'] = true,
}

function ENTITY:IsDoor()
	return (doorClasses[self:GetClass()] or false)
end

function ENTITY:DoorIsOwnable()
	return (self:GetNetVar('DoorData') == nil) and (self:GetNetVar('DoorData') ~= false)
end

function ENTITY:DoorOwnedBy(pl)
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Owner == pl) or false)
end

function ENTITY:DoorOrgOwned()
	return (istable(self:GetNetVar('DoorData')) and self:GetNetVar('DoorData').OrgOwn or false)
end

function ENTITY:DoorCoOwnedBy(pl)
	if (self:DoorGetGroup() ~= nil) then
		return (rp.teamDoors[self:DoorGetGroup()][pl:Team()] or false)
	end

	-- if IsValid(self:DoorGetOwner()) and self:DoorGetOwner():GetOrg() and self:DoorOrgOwned() and (pl:GetOrg() == self:DoorGetOwner():GetOrg()) then
	-- 	return true
	-- end

	return (istable(self:GetNetVar('DoorData')) and table.HasValue(self:GetNetVar('DoorData').CoOwners or {}, pl) or false)
end

function ENTITY:DoorGetTitle()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Title) or nil)
end

function ENTITY:DoorGetOwner()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Owner) or nil)
end

function ENTITY:DoorGetCoOwners()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').CoOwners) or nil)
end

function ENTITY:DoorGetTeam()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Team) or nil)
end

function ENTITY:DoorGetGroup()
	return (istable(self:GetNetVar('DoorData')) and (self:GetNetVar('DoorData').Group) or nil)
end

nw.Register('DoorData')
