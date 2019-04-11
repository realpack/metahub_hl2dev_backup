local STORE_ITEM = FindMetaTable("IGSItem")

-- Возволяет настроить максимальное количество ПОКУПОК одного предмета
-- Работает только для одного сервера, независимо от того, указан ли bGlobal
function STORE_ITEM:SetMaxPurchases(iLimit)
	return self:SetMeta("purchasesLimit", iLimit)
end

if CLIENT then return end

local function bibKey(pl,ITEM)
	return "igs:purchases:" .. pl:UniqueID() .. ":" .. ITEM:UID()
end

hook.Add("IGS.CanPlayerBuyItem", "purchasesLimit", function(pl, ITEM) -- bGlobal
	local limit = ITEM:GetMeta("purchasesLimit")
	if limit and bib.getNum(bibKey(pl, ITEM),0) >= limit then
		return false, "Этот предмет можно купить только " .. limit .. " раз(а)"
	end
end)

hook.Add("IGS.OnSuccessPurchase", "purchasesLimit", function(pl, ITEM) -- bGlobal, iID
	local limit = ITEM:GetMeta("purchasesLimit")
	if limit then
		local key = bibKey(pl, ITEM)
		bib.setNum(key, bib.getNum(key,0) + 1)
		IGS.Notify(pl, "Вы купили " .. ITEM:Name() .. " " .. bib.getNum(key,0) .. " раз из " .. limit)
	end
end)

/*
IGS("Тестовый итем", "test", 5)
	:SetPerma()
	:SetCategory("IGS_CAT_DECOR")
	:SetDescription("Джигурда")
	:SetStackable()
	:SetMaxPurchases(3)
