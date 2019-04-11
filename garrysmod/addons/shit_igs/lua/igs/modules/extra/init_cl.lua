list.Set("DesktopWindows", "IGS",{
	title     = "Автодонат",
	icon      = "icon16/money_add.png",
	init      = function(icon, window)
		IGS.UI()
	end
})




local should_play = math.random(2) == 1 -- шанс того, что звук будет вообще воспроизводиться 50/50
local recently_played -- если сверху true, то воспроизводим не чаще, чем раз в 5 минут
hook.Add("IGS.OnItemInfoOpen","OpenItemSong",function(ITEM)
	-- Любой итем
	if should_play and !recently_played then
		IGS.Play("VI_EVREY") -- вы еврей? Щас узнаем

		recently_played = true
		timer.Create("recently_played_remover",300,1,function() recently_played = nil end) -- гамно
	end
end)


hook.Add("IGS.OnSuccessPurchase","PostPurchaseSong",function(ITEM)
	if ITEM:IsStackable() and math.random(4) == 1 then
		IGS.Play("NALOGI_PIVO")
	end
end)







--[[------------------------------------------------------
	Отобразится при первом открытии менюшки пополнения счета
	https://img.qweqwe.ovh/1492376581692.png - вот так
	Доступные шаблоны:

	{currency_name}  - название валюты (Алкобаксы)
	{currency_sign}  - сокращение валюты (Alc)
	{currency_price} - цена единицы валюты (5)
--------------------------------------------------------]]
IGS.C.AboutCurrencyText = [[
Автодонат имеет свою собственную валюту - {currency_name} ({currency_sign}). Это, как доллары, но в игре. Все цены в /donate магазине указаны в этой валюте.

Сейчас 1 {currency_sign} стоит {currency_price} руб, но цена может немного вырасти или упасть в зависимости от некоторых факторов.

Таким образом, если купить {currency_name} на 1000 руб, завтра может оказаться, что это самое количество будет стоить уже, например, 1200 руб и вы купили их с выгодой (купили за 1000 то, что теперь другие должны покупать за 1200)
]]


function IGS.WIN.AboutCurrency(bHideClose)
	local t = IGS.C.AboutCurrencyText:gsub("{currency_name}",IGS.C.CURRENCY_NAME)
		:gsub("{currency_sign}",IGS.C.CURRENCY_SIGN)
		:gsub("{currency_price}",IGS.GetCurrencyPrice())

	local modal = IGS.ShowNotify(t,"Лучше прочтите")

	if !bHideClose then return end
	modal.btnOK:SetVisible(false)
	timer.Simple(7,function()
		if IsValid(modal) then
			modal.btnOK:SetVisible(true)
		end
	end)
end


local function getReadCurrencyInfoStatus() -- true, если прочитано
	return bib.get("igs:currency_read") == "1"
end

local function setReadCurrencyInfoStatus(bRead)
	bib.set("igs:currency_read", bRead and 1 or 0)
end


hook.Add("IGS.OnDepositWinOpen","CurrencyInfo",function()
	if !IGS.IsCurrencyEnabled() then return end -- донат валюта отключена

	-- Ни разу не пополнял и не видел подсказки
	if !IGS.isUser(LocalPlayer()) and !getReadCurrencyInfoStatus() then
		timer.Simple(0,function() -- чтобы не оказаться позади iFrame
			IGS.WIN.AboutCurrency(true)
			setReadCurrencyInfoStatus(true)
		end)
	end
end)

-- IGS.UI()