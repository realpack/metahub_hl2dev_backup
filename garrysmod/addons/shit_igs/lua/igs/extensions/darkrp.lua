IGS.ITEMS.DRP = IGS.ITEMS.DRP or {
	ITEMS = {},
	JOBS  = {}
}


local STORE_ITEM = FindMetaTable("IGSItem")

-- Делает итем в магазине покупаемым только за донат
-- Это может быть ящик оружия, отдельная пушка или даже отдельная энтити
function STORE_ITEM:SetDarkRPItem(sEntClass)
	self.dpr_item = self:Insert(IGS.ITEMS.DRP.ITEMS, sEntClass)
	return self
end

-- Доступ к профессиям только тем, кто ее покупал
function STORE_ITEM:SetDarkRPTeam(itTeams)
	local tTeams = istable(itTeams) and itTeams or {itTeams}
	self.dpr_teams = self:Insert(IGS.ITEMS.DRP.JOBS, tTeams, true)
	return self
end

function STORE_ITEM:SetDarkRPMoney(iSum)
	self:SetDescription("Мгновенно и без проблем пополняет баланс игровой валюты на " .. string.Comma(iSum) .. " валюты")
	self:SetOnActivate(function(pl) pl:addMoney(iSum,"IGS") end)
	self:SetStackable(true) -- а нужно?

	self.dpr_money = iSum
	return self
end



local function canBuyItem(pl, tItem, sHook)
	local hasAccess = IGS.PlayerHasOneOf(pl, IGS.ITEMS.DRP.ITEMS[tItem.entity or tItem.ent]) -- ent для энтити, entity для шипментов
	if hasAccess == nil then return end -- не отслеживается

	if hasAccess then
		return !sHook and true or DarkRP.hooks[sHook](DarkRP.hooks, pl,tItem)
	end

	-- Чтобы не нужно было изначально запрещать вручную в конфигах шипментов и т.д.
	return pl:IsSuperAdmin(), false, "Это для донатеров (/donate)"
end

hook.Add("canBuyShipment", "IGS", function(pl, tItem)
	return canBuyItem(pl, tItem, "canBuyShipment")
end)

hook.Add("canBuyPistol", "IGS", function(pl, tItem)
	return canBuyItem(pl, tItem, "canBuyPistol")
end)

hook.Add("canBuyCustomEntity", "IGS", function(pl, tItem)
	-- 3 arg nil т.к. в DRP нет такого хука
	-- https://img.qweqwe.ovh/1528097550183.png
	return canBuyItem(pl, tItem, nil)
end)


hook.Add("playerCanChangeTeam","IGS",function(pl, iTeam) -- bForce
	local hasAccess = IGS.PlayerHasOneOf(pl, IGS.ITEMS.DRP.JOBS[iTeam])
	if hasAccess == nil then return end -- не отслеживается

	if hasAccess then
		return true
	end

	local can,err = hook.Run("IGS.playerCanChangeTeam", pl, iTeam)
	if can != nil then -- true, false
		return can,err
	end

	-- nil (хук не использован)
	return pl:IsAdmin(), "Это для донатеров (/donate)"
end)
