--[[-------------------------------------------------------------------------
	Мгновенные изменения. СОКЕТ
---------------------------------------------------------------------------]]
local function getPlayer(dat)
	return player.GetBySteamID64( dat.SteamID64 )
end

-- Обновление статуса платежа
hook.Add("IGS.NewSocketMessage","PaymentStatus",function(d, method)
	if method ~= "payment.UpdateStatus" then return end

	local pl = getPlayer(d)
	if !pl then return end

	hook.Run("IGS.PaymentStatusUpdated",pl,d)
end)

-- Цена валюты и минимальное пополнение
hook.Add("IGS.NewSocketMessage","ProjectSettings",function(d, method)
	if method ~= "project.updateMoneySettings" then return end

	IGS.UpdateMoneySettings(d.minCharge,d.currencyPrice)
end)

-- Моментальная выдача услуги
hook.Add("IGS.NewSocketMessage","GivePurchase",function(d, method)
	if method ~= "purchase.store" then return end

	local pl = getPlayer(d)
	if !pl then return end

	local ITEM = IGS.GivePurchase(pl,d.Item) -- выдает покупку без сохранения в БД
	IGS.Notify(pl,"Вам выдана новая услуга: " .. ITEM:Name())
end)

-- Перенос услуги (в т.ч. отключение)
hook.Add("IGS.NewSocketMessage","MovePurchase",function(d, method)
	if method ~= "purchase.move" then return end

	local pl = getPlayer(d)
	if !pl then return end

	-- Просто перезагружаем данные
	-- Если перенос был на этот сервер, то услуга будет выдана (или забрана. С :HasPurchase)
	IGS.Notify(pl, "Перезагрузка списка покупок из-за переноса или отключения услуг")
	IGS.LoadPlayerPurchases(pl,function()
		IGS.Notify(pl,"Список перезагружен")
	end)
end)


local INV_ACTIONS = {
	["inventory.storeItem"]  = true,
	["inventory.deleteItem"] = true,
}

-- Забираем вещь с инвентаря
-- Добавление итема в инвентарь
hook.Add("IGS.NewSocketMessage","InventoryActions",function(d, method)
	if !INV_ACTIONS[method] then return end

	local pl = getPlayer(d)
	if !pl then return end

	IGS.Notify(pl, "Перезагрузка инвентаря")
	IGS.LoadInventory(pl,function()
		IGS.Notify(pl, "Инвентарь перезагружен")
	end)
end)


-- Отключаем сервер
hook.Add("IGS.NewSocketMessage","DisableServer",function(d, method)
	if method ~= "servers.disable" then return end

	local endl = ""
	if d.Server == IGS.SERVERS:ID() then
		IGS.SetReady(false)
	else
		endl = " на " .. IGS.SERVERS(d.Server)
	end

	IGS.NotifyAll("Автодонат временно отключен" .. endl)
end)
