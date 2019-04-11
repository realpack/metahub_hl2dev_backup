IGS.ITEMS.ULX = IGS.ITEMS.ULX or {
	GROUPS = {},
	PEX    = {}
}


local STORE_ITEM = FindMetaTable("IGSItem")

function STORE_ITEM:SetULXGroup(sUserGroup, iGroupWeight)
	self:SetCategory("ULX (Админка)")

	self:SetCanActivate(function(pl) -- global, invDbID
		if pl:IsUserGroup(sUserGroup) then
			return "У вас уже действует эта услуга"
		end
	end)
	self:SetOnActivate(function(pl)
		RunConsoleCommand("ulx", "adduserid", pl:SteamID(), sUserGroup)
		pl.IGSULXWeight = iGroupWeight
	end)
	self:SetValidator(function(pl)
		if pl.IGSULXWeight then
			return iGroupWeight < pl.IGSULXWeight
		else
			return pl:IsUserGroup(sUserGroup)
		end
	end)


	self.ulx_group = self:Insert(IGS.ITEMS.ULX.GROUPS, sUserGroup)
	return self
end

function STORE_ITEM:SetULXCommandAccess(cmd,tag) -- "ulx model","^", например
	self:SetCategory("ULX (Админка)")

	self:SetOnActivate(function(pl)
		-- Как бы объяснить. Короче, кажется ULX оверрайдит мои изменения при входе на серверю Вот так вот
		-- А еще в DarkRP на таймере в 1 сек висит GM.Config.DefaultPlayerGroups
		-- timer.Simple(2,function()
			-- Потому что сука в документации ULX написано одно,
			-- а на деле ХУК ULib.HOOK_COMMAND_CALLED не работает
			if !tag then
				table.insert(ULib.ucl.authed[ pl:UniqueID() ].allow, cmd)
			else
				ULib.ucl.authed[ pl:UniqueID() ].allow[cmd] = tag
			end
		-- end)
	end)
	-- self:SetValidator(function(pl)
	-- 	return ULib.ucl.query(pl,"ulx " .. cmd)
	-- end)
	self:SetValidator(function() -- установка при входе на сервер
		return false,true -- второе true глушит сообщение о восстановлении
	end)


	self.ulx_command = self:Insert(IGS.ITEMS.ULX.PEX, cmd)
	return self
end


if CLIENT then return end

local function checkGroups(pl)
	local hasAccess = IGS.PlayerHasOneOf(pl, IGS.ITEMS.ULX.GROUPS[ pl:GetUserGroup() ])
	if hasAccess == nil then return end  -- не отслеживается

	if hasAccess then
		return -- если имеется хоть одна покупка, то не снимаем права
	end

	RunConsoleCommand("ulx","removeuserid",pl:SteamID())
end

local function hasPexAccess(pl, cmd)
	local pex = IGS.ITEMS.ULX.PEX[cmd]
	if !pex then return true end -- команда не отслеживается (Нет в автодонате)

	for _,ITEM in ipairs(pex) do
		if pl:HasPurchase( ITEM:UID() ) then
			return true
		end
	end

	return false
end

local function checkPermissions(pl)
	local user = ULib.ucl.authed[ pl:UniqueID() ]
	if !user then IGS.dprint(" юзера нет") return end

	-- prt(user)

	local changed -- чтобы не сейвить огромную таблицу в цикле
	-- Вид ucl таблицы https://img.qweqwe.ovh/1523035793058.png
	for k,v in pairs(user.allow or {}) do -- не уверен, что allow обязательно есть
		local cmd = isnumber(k) and v or k
		IGS.dprint(" cmd", cmd)

		if !hasPexAccess(pl, cmd) then
			IGS.dprint("  нет прав на " .. cmd)
			user.allow[k] = nil
			changed = true
		end
	end

	if changed then
		IGS.dprint("   Обновляем таблицу ucl.saveUsers()")
		ULib.ucl.saveUsers()
	end

	-- prt(user)
end

hook.Add("IGS.PlayerPurchasesLoaded", "ULXGroupsAndPEX", function(pl)
	if next(IGS.ITEMS.ULX.GROUPS) then -- группы продаются
		checkGroups(pl)
	end

	if next(IGS.ITEMS.ULX.PEX) then -- права продаются
		IGS.dprint("Чек прав игрока: " .. tostring(pl))
		checkPermissions(pl)
	end
end)


-- Потому что сука в документации ULX написано одно, а на деле ХУК ULib.HOOK_COMMAND_CALLED не работает
-- hook.Add(ULib.HOOK_COMMAND_CALLED,"IGS.PexAccess",function(pl,cmd,args)
-- 	if true then return true end

-- 	local pex = IGS.ITEMS.ULX.PEX[cmd]
-- 	if !pex then return end -- команда не отслеживается (Нет в автодонате)

-- 	for _,ITEM in ipairs(pex) do
-- 		if pl:HasPurchase( ITEM:UID() ) then
-- 			return true
-- 		end
-- 	end
-- end)
