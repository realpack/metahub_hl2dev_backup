/****************************************************************************
	Игровая валюта для DarkRP
	Срок нет смысла указывать
	Для удобства суммы объединены в группу (Не категорию)
****************************************************************************/
local GROUP = IGS.NewGroup("Игровая валюта")
local STORE_ITEM = FindMetaTable("IGSItem")
function STORE_ITEM:SetMetaMoney(iSum)
	self:SetDescription("Мгновенно и без проблем пополняет баланс игровой валюты на " .. string.Comma(iSum) .. " валюты")
	self:SetOnActivate(function(pl) pl:AddMoney(iSum) end)
	self:SetStackable(true) -- а нужно?

	self.dpr_money = iSum
	return self
end


GROUP:AddItem(
 	IGS("20 000 Крон", "120k_deneg"):SetMetaMoney(20000)
 	:SetPrice(200) -- 200 руб
)
GROUP:AddItem(
 	IGS("100 000 Крон", "150k_deneg"):SetMetaMoney(100000)
 	:SetPrice(400) -- 400 руб
)

GROUP:AddItem(
 	IGS("449 999 Крон", "200k_deneg"):SetMetaMoney(450000)
 	:SetPrice(600) -- 600 руб
)

GROUP:AddItem(
 	IGS("999 999 Крон", "500k_deneg"):SetMetaMoney(1000000)
 	:SetPrice(800) -- 800 руб
)

GROUP:AddItem(
 	IGS("1 999 999 Крон", "1200k_deneg"):SetMetaMoney(2000000)
 	:SetPrice(1100) -- 1100 руб
)

--[[-------------------------------------------------------------------------
	Группы прав
---------------------------------------------------------------------------]]
local superadmin_description = [[
Возможности:
● ДОСТУП К ПРОФЕССИИ СИНТЕТИЧЕСКОГО СОЛДАТА
● ДОСТУП К МАРИО РОДЖЕРСУ
● ДОСТУП К ЕВА БОРДЖЕР
● ДОСТУП К СИНЕГЛАЗОМУ

]]

local owner_description = [[
Возможности:
● ДОСТУП К СЕРЖАНТУ МАКТАВИШ
● ДОСТУП К МАЙОР ОВЕРБЕК


EUCLID

- Полёт
- Невидимость
- Бессмертие
- Регулирование НПЦ

]]
local afina_description = [[
Возможности:
● ДОСТУП К КРЕМАТОРУ
● ДОСТУП К НЕИЗВЕСТНОМУ
● ДОСТУП К МАРИИ БЕККЕР

KETER

- Полёт
- Невидимость
- Бессмертие
- Регулирование НПЦ
- Изменение модели
- Выдача предупреждений в случае нарушений
- Слежка
]]
local thaumiel_description = [[
Возможности:
● ДОСТУП К ЭЛИТНОЙ ЕДИНИЦЕ СИНТЕТИЧЕСКОГО СОЛДАТА
● ДОСТУП К НЕЙТАНУ ДРЕЙКУ
● ДОСТУП К ВАЛЕРИИ ЛЕВАЛЬД

AFINA

- Полёт
- Невидимость
- Бессмертие
- Регулирование НПЦ
- Изменение модели
- Выдача предупреждений в случае нарушений
- Все виды телепортаций
- Кик
- Слежка
]]
local apollo_description = [[
THAUMIEL

- Полёт
- Невидимость
- Бессмертие
- Регулирование НПЦ
- Изменение модели
- Выдача предупреждений в случае нарушений
- Все виды телепортаций
- Кик + Бан
- Слежка
- Возможность помогать в проведении ивентов, а после, с разрешения модераторов, проводить ивенты самому

]]

for group,t in pairs({
	["euclid"] = {
		name  = "Евклид",
		alias = "EUCLID",
		desc  = superadmin_description,
		image = "https://i.imgur.com/mBMcpgq.jpg",
		icon =  "https://i.ibb.co/q53Jqkd/EUCLID.jpg",
		weight = 2,
		{50,30}, -- 50
		{140}, -- 200
	},
	["keter"] = {
		name   = "Кетер",
		alias  = "KETER",
		desc   = owner_description,
		image  = "https://i.imgur.com/fQpcfvR.jpg",
		icon   = "https://i.ibb.co/VmPdSrV/KETER.jpg",
		weight = 3,
		{300,30}, -- 300
		{500}, -- 500
	},
	["afina"] = {
		name   = "Афина",
		alias  = "AFINA",
		desc   = afina_description,
		image  = "https://i.imgur.com/fQpcfvR.jpg",
		icon   = "https://i.ibb.co/sq9fJPt/AFINA.jpg",
		weight = 4,
		{600,30}, -- 600
		{800}, -- 800
	},
	["thaumiel"] = {
		name   = "Таумиель",
		alias  = "THAUMIEL",
		desc   = thaumiel_description,
		image  = "https://i.imgur.com/fQpcfvR.jpg",
		icon   = "https://i.ibb.co/DLKhnnD/THAUMIEL.jpg",
		weight = 5,
		{900,30}, -- 900
		{1100}, -- 1100
	},
	["apollo"] = {
		name   = "Аполлион",
		alias  = "APOLLO",
		desc   = apollo_description,
		image  = "https://i.imgur.com/fQpcfvR.jpg",
		icon   = "https://i.ibb.co/sVR1PG3/APPOLION.jpg",
		weight = 6,
		{1300,30}, -- 1300
		{1500}, -- 1500
	},
	-- ["jedi"] = {
	-- 	name  = "Орден Джедаев",
	-- 	alias = "Покупка Джедая",
	-- 	desc  = jedi_description,
	-- 	weight = 1,
	-- 	{420}, -- 600
	-- },
}) do
	local GROUP = IGS.NewGroup(t["name"])
	GROUP:SetIcon(t["icon"])

	for _,v in ipairs(t) do
	local ITEM = IGS(t["name"],"group_" .. group .. "_" .. (v[2] or "~") .. "d") -- group_premium_15d
		:SetPrice(v[1])
		:SetTerm(v[2])
		:SetCategory(IGS_CAT_SETS)
		:SetDescription(t["desc"])
		:SetIcon(t["icon"])
		:SetImage(t["image"])
		:SetOnActivate(function(pl)
			serverguard.player:SetRank(pl, group, 0, true)
			pl.IGSSGWeight = t["weight"]
		end)
		:SetValidator(function(pl)
			if pl.IGSSGWeight then
				return t["weight"] < pl.IGSSGWeight
			else
				return serverguard.player:GetRank(pl) == group, true
			end
		end)

	GROUP:AddItem(ITEM,t["alias"])
	end
end
