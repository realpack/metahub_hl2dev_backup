--[[-------------------------------------------------------------------------
	Модуль для расширения возможностей автодоната,
	позволяющий спавнить вещи прямо из спавн меню
---------------------------------------------------------------------------]]

IGS.ITEMS.SB = IGS.ITEMS.SB or {
	TOOLS = {},
	SENTS = {},
	SWEPS = {},
	VEHS  = {}
}


local STORE_ITEM = FindMetaTable("IGSItem")

-- Тулы
function STORE_ITEM:SetTool(sToolName)
	self:SetCategory("Инструменты")
	self:SetDescription("Разрешает использовать инструмент " .. sToolName)

	self.tool = self:Insert(IGS.ITEMS.SB.TOOLS, sToolName)
	return self
end

-- Энтити
function STORE_ITEM:SetEntity(sEntClass)
	self:SetCategory("Энтити (Предметы)")

	self.entity = self:Insert(IGS.ITEMS.SB.SENTS, sEntClass)
	return self
end

-- Пушки
function STORE_ITEM:SetWeapon(sWepClass,tAmmo)
	self:SetCategory("Оружие")
	self:SetDescription("Разрешает спавнить " .. sWepClass .. " через спавн меню в любое время")

	self:SetNetworked() -- для HasPurchase и отображения галочки

	self.ammo = tAmmo
	self.swep = self:Insert(IGS.ITEMS.SB.SWEPS, sWepClass)
	return self
end

if CLIENT then -- :SetWeapon only
hook.Add("IGS.OnItemInfoOpen","CheckGiveWeaponOnSpawn",function(ITEM, fr)
	if !(ITEM.swep and LocalPlayer():HasPurchase(ITEM:UID())) then return end

	ui.Create("DCheckBoxLabel",function(self)
		self:Dock(TOP)
		self:DockMargin(0,5,0,0)
		self:SetTall(20)

		local should_give = LocalPlayer():GetNWBool("igs.gos." .. ITEM:ID())
		self:SetValue(should_give)

		self:SetText("Выдавать при спавне")
		self.Label:SetTextColor(IGS.col.TEXT_SOFT)
		self.Label:SetFont("ui.15")

		function self:OnChange(give)
			net.Start("IGS.GiveOnSpawnWep")
				net.WriteIGSItem(ITEM)
				net.WriteBool(give)
			net.SendToServer()
		end
	end, fr.act)
end)

-- IGS.CloseUI()
-- IGS.UI()
-- IGS.WIN.Item("wep_weapon_ar2")

else -- SV
	util.AddNetworkString("IGS.GiveOnSpawnWep")

	local function bibuid(pl, ITEM)
		return "igs:gos:" .. pl:UniqueID() .. ":" .. ITEM:UID()
	end

	local function SetShouldPlayerReceiveWep(pl, ITEM, bGive)
		pl:SetNWBool("igs.gos." .. ITEM:ID(), bGive) -- gos GiveOnSpawn
		bib.setBool(bibuid(pl, ITEM), bGive)
	end

	local function GetShouldPlayerReceiveWep(pl, ITEM)
		return bib.getBool(bibuid(pl, ITEM))
	end

	net.Receive("IGS.GiveOnSpawnWep",function(_, pl)
		local ITEM,give = net.ReadIGSItem(),net.ReadBool()
		if !pl:HasPurchase(ITEM:UID()) or !ITEM.swep then return end -- байпас

		SetShouldPlayerReceiveWep(pl, ITEM, give)
		IGS.Notify(pl, ITEM:Name() .. (give and " " or " не ") .. "будет выдаваться при спавне")
	end)

	local function giveWeapons(pl, purchases, bUpdateData)
		for uid in pairs(purchases) do
			local ITEM = IGS.GetItemByUID(uid)
			if !ITEM.swep then continue end

			local give = GetShouldPlayerReceiveWep(pl, ITEM)
			if give then
				pl:Give(ITEM.swep)

				for type,count in pairs(ITEM.ammo or {}) do
					pl:SetAmmo(count,type)
				end

				if bUpdateData then
					-- nwbool
					SetShouldPlayerReceiveWep(pl, ITEM, true)
				end
			end
		end
	end

	hook.Add("PlayerLoadout", "IGS.GiveWeapons", function(pl)
		giveWeapons(pl, IGS.PlayerPurchases(pl))
	end)

	hook.Add("IGS.PlayerPurchasesLoaded", "IGS.MarkWeaponsToGiveOnSpawn", function(pl, purchases_)
		giveWeapons(pl, purchases_ or {}, true)
	end)
end


-- Машины
function STORE_ITEM:SetVehicle(sVehClass)
	self:SetCategory("Транспорт")

	self.vehicle = self:Insert(IGS.ITEMS.SB.VEHS, sVehClass)
	return self
end

-- /\ SHARED
if CLIENT then return end
-- \/ SERVER

local function f(p,t)
	local hasAccess = IGS.PlayerHasOneOf(p,t)
	if hasAccess then -- просто может быть и false, тогда хук замочится
		return true
	end
end

timer.Simple(0,function() -- для HOOK_HIGH
hook.Add("CanTool","IGS",function(pl,_,tool)
	return f(pl,IGS.ITEMS.SB.TOOLS[tool])
end, HOOK_HIGH)

hook.Add("PlayerSpawnSENT","IGS",function(pl,class) -- Ниже решение для машин, как сделать, чтобы не спавнили тучу. Сейчас реализовывать лень
	return f(pl,IGS.ITEMS.SB.SENTS[class])
end, HOOK_HIGH)

hook.Add("PlayerGiveSWEP","IGS",function(pl,class)
	local ITEM = IGS.PlayerHasOneOf(pl, IGS.ITEMS.SB.SWEPS[class]) -- hasAccess if ITEM returned
	if ITEM then
		timer.Simple(.1,function()
			for type,count in pairs(ITEM.ammo or {}) do
				pl:SetAmmo(count,type)
			end
		end)

		return true
	end
end, HOOK_HIGH)


--[[-------------------------------------------------------------------------
	Машины
---------------------------------------------------------------------------]]
local function getcount(pl,class)
	return pl:GetVar("vehicles_" .. class,0)
end

local function counter(pl,class,incr)
	pl:SetVar("vehicles_" .. class, getcount(pl,class) + (incr and 1 or -1))
end

-- разрешаем спавнить одну, но конструкция позволяет в будущем сделать поддержку спавна нескольких машин
local function canSpawn(pl,class)
	return getcount(pl,class) < 1
end

-- Считаем заспавненные и удаленные машины
hook.Add("PlayerSpawnedVehicle","IGS",function(pl,veh)
	if IGS.PlayerHasOneOf(pl, IGS.ITEMS.SB.VEHS[veh:GetVehicleClass()]) then -- чел покупал эту тачку, а теперь спавнит
		counter(pl,veh:GetVehicleClass(),true)

		veh:CallOnRemove("ChangeCounter",function(ent)
			if !IsValid(pl) then return end
			counter(pl,ent:GetVehicleClass(),false)
		end)
	end
end)

hook.Add("PlayerSpawnVehicle","IGS",function(pl, _, class) -- model, class, table
	if IGS.PlayerHasOneOf(pl,IGS.ITEMS.SB.VEHS[class]) then -- покупал машину
		local can = canSpawn(pl,class)
		if !can then
			IGS.Notify(pl,"У вас есть эта заспавненная машина")
		end

		return can
	end
end, HOOK_HIGH)
--[[-------------------------------------------------------------------------
	/Машины
---------------------------------------------------------------------------]]



-- DARKRP ONLY
hook.Add("canDropWeapon","IGS",function(pl,wep)
	-- Пушка не продается
	if !IsValid(wep) or !IGS.ITEMS.SB.SWEPS[wep:GetClass()] then return end

	-- Пушка продается и чел купил ее
	local ITEM = IGS.PlayerHasOneOf(pl, IGS.ITEMS.SB.SWEPS[wep:GetClass()])
	if ITEM then
		return false
	end

	-- Пушка продается, но чел ее не покупал
	-- Т.е. по сути возможность дропа контроллируется другими хуками
end, HOOK_HIGH)
end)
