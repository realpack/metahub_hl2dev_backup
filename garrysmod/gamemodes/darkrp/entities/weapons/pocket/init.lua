AddCSLuaFile("cl_init.lua")
AddCSLuaFile("pocket_controls.lua")
AddCSLuaFile("pocket_vgui.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

util.AddNetworkString("Pocket.Load")
util.AddNetworkString("Pocket.RemoveItem")
util.AddNetworkString("Pocket.AddItem")
util.AddNetworkString("Pocket.AdminDelete")
util.AddNetworkString("Pocket.TakeFromBody")

local wl = rp.inv.Wl

local Ents = {} // If the server doesn't have the entity you pocketed we'll create an alternative instead
Ents["ngii_a_cooler"] = "armor_piece_full"
Ents["ngii_a_overclocker"] = "armor_piece_full"
Ents["ngii_a_storagebox"] = "armor_piece_full"

Ents["sp_cooler_low"] = "armor_piece_full"
Ents["sp_cooler_medium"] = "armor_piece_full"
Ents["sp_cooler_high"] = "armor_piece_full"
Ents["sp_cooler_premium"] = "armor_piece_full"

Ents["sp_overclocker_low"] = "armor_piece_full"
Ents["sp_overclocker_medium"] = "armor_piece_full"
Ents["sp_overclocker_high"] = "armor_piece_full"
Ents["sp_overclocker_premium"] = "armor_piece_full"

Ents["sp_storage_low"] = "armor_piece_full"
Ents["sp_storage_medium"] = "armor_piece_full"
Ents["sp_storage_high"] = "armor_piece_full"
Ents["sp_storage_premium"] = "armor_piece_full"

Ents["sp_supply_low"] = "armor_piece_full"
Ents["sp_supply_medium"] = "armor_piece_full"
Ents["sp_supply_high"] = "armor_piece_full"
Ents["sp_supply_premium"] = "armor_piece_full"

Ents['sp_cooler'] = "armor_piece_full"
Ents['sp_overclocker'] = "armor_piece_full"
Ents['sp_storage'] = "armor_piece_full"
Ents['sp_supply'] = "armor_piece_full"

/*
local model_translations = {
	['models/weapons/3_snip_awp.mdl'] 			= 'models/weapons/w_snip_awp.mdl',
	['models/weapons/3_rif_ak47.mdl']			= 'models/weapons/w_rif_ak47.mdl',
	['models/weapons/3_pist_deagle.mdl']		= 'models/weapons/w_pist_deagle.mdl',
	['models/weapons/3_rif_famas.mdl']			= 'models/weapons/w_rif_famas.mdl',
	['models/weapons/3_pist_fiveseven.mdl']		= 'models/weapons/w_pist_fiveseven.mdl',
	['models/weapons/3_smg_p90.mdl']			= 'models/weapons/w_smg_p90.mdl',
	['models/weapons/3_pist_glock18.mdl']		= 'models/weapons/w_pist_glock18.mdl',
	['models/weapons/3_snip_g3sg1.mdl']			= 'models/weapons/w_snip_g3sg1.mdl',
	['models/weapons/3_smg_mp5.mdl']			= 'models/weapons/w_smg_mp5.mdl',
	['models/weapons/3_smg_ump45.mdl']			= 'models/weapons/w_smg_ump45.mdl',
	['models/weapons/3_rif_galil.mdl']			= 'models/weapons/w_rif_galil.mdl',
	['models/weapons/3_smg_mac10.mdl']			= 'models/weapons/w_smg_mac10.mdl',
	['models/weapons/3_mach_m249para.mdl']		= 'models/weapons/w_mach_m249para.mdl',
	['models/weapons/3_shot_m3super90.mdl']		= 'models/weapons/w_shot_m3super90.mdl',
	['models/weapons/3_pist_p228.mdl']			= 'models/weapons/w_pist_p228.mdl',
	['models/weapons/3_snip_sg550.mdl']			= 'models/weapons/w_snip_sg550.mdl',
	['models/weapons/3_rif_sg552.mdl']			= 'models/weapons/w_rif_sg552.mdl',
	['models/weapons/3_rif_aug.mdl']			= 'models/weapons/w_rif_aug.mdl',
	['models/weapons/3_snip_scout.mdl']			= 'models/weapons/w_snip_scout.mdl',
	['models/weapons/3_smg_tmp.mdl']			= 'models/weapons/w_smg_tmp.mdl',
	['models/weapons/3_shot_xm1014.mdl']		= 'models/weapons/w_shot_xm1014.mdl',
	['models/weapons/3_rif_m4a1.mdl']			= 'models/weapons/w_rif_m4a1.mdl',
	['models/weapons/3_pist_usp.mdl']			= 'models/weapons/w_pist_usp.mdl',
	['models/weapons/3_357.mdl']				= 'models/weapons/w_357.mdl',
	['models/weapons/2_c4_planted.mdl']			= 'models/weapons/w_c4_planted.mdl'
}
*/

local model_translations = {
	['models/weapons/w_snip_awp.mdl']			= 'models/weapons/3_snip_awp.mdl',
	['models/weapons/w_rif_ak47.mdl']			= 'models/weapons/3_rif_ak47.mdl',
	['models/weapons/w_pist_deagle.mdl']		= 'models/weapons/3_pist_deagle.mdl',
	['models/weapons/w_rif_famas.mdl']			= 'models/weapons/3_rif_famas.mdl',
	['models/weapons/w_pist_fiveseven.mdl']	 	= 'models/weapons/3_pist_fiveseven.mdl',
	['models/weapons/w_smg_p90.mdl']			= 'models/weapons/3_smg_p90.mdl',
	['models/weapons/w_pist_glock18.mdl']		= 'models/weapons/3_pist_glock18.mdl',
	['models/weapons/w_snip_g3sg1.mdl']			= 'models/weapons/3_snip_g3sg1.mdl',
	['models/weapons/w_smg_mp5.mdl']			= 'models/weapons/3_smg_mp5.mdl',
	['models/weapons/w_smg_ump45.mdl']			= 'models/weapons/3_smg_ump45.mdl',
	['models/weapons/w_rif_galil.mdl']			= 'models/weapons/3_rif_galil.mdl',
	['models/weapons/w_smg_mac10.mdl']			= 'models/weapons/3_smg_mac10.mdl',
	['models/weapons/w_mach_m249para.mdl']	  	= 'models/weapons/3_mach_m249para.mdl',
	['models/weapons/w_shot_m3super90.mdl']	 	= 'models/weapons/3_shot_m3super90.mdl',
	['models/weapons/w_pist_p228.mdl']			= 'models/weapons/3_pist_p228.mdl',
	['models/weapons/w_snip_sg550.mdl']			= 'models/weapons/3_snip_sg550.mdl',
	['models/weapons/w_rif_sg552.mdl']			= 'models/weapons/3_rif_sg552.mdl',
	['models/weapons/w_rif_aug.mdl']			= 'models/weapons/3_rif_aug.mdl',
	['models/weapons/w_snip_scout.mdl']			= 'models/weapons/3_snip_scout.mdl',
	['models/weapons/w_smg_tmp.mdl']			= 'models/weapons/3_smg_tmp.mdl',
	['models/weapons/w_shot_xm1014.mdl']	    = 'models/weapons/3_shot_xm1014.mdl',
	['models/weapons/w_rif_m4a1.mdl']			= 'models/weapons/3_rif_m4a1.mdl',
	['models/weapons/w_pist_usp.mdl']			= 'models/weapons/3_pist_usp.mdl',
	['models/weapons/w_c4_planted.mdl']			= 'models/weapons/2_c4_planted.mdl',
	['models/weapons/3_357.mdl']				= 'models/weapons/w_357.mdl',
}

PLAYER = FindMetaTable('Player')

function PLAYER:GetInv()
	return rp.inv.Data[self:SteamID64()] or {}
end

function PLAYER:SaveInv()
	rp.data.SetPocket(self:SteamID64(), pon.encode(self:GetInv()))
end

function PLAYER:SendInv()
	net.Start("Pocket.Load")
		net.WriteTable(self:GetInv())
	net.Send(self)
end


if !ID then ID = 1 end

local function GetEntityInfo(ent)
	local c = ent:GetClass()

	local tab = {}
	tab.Class = c
	tab.Model = ent:GetModel()

	local title = "Pocketed Entity"
	local subtitle = ""

	if (c == "spawned_shipment") then
		tab.contents = ent.dt.contents
		tab.count = ent.dt.count
		if ent.dt.count > 0 then
			title = rp.shipments[tab.contents].name
			subtitle = "В ящике " .. tab.count .. " шт."
		else
			title = "Empty Shipment"
		end
	elseif (c == "spawned_food") then
		tab.FoodEnergy = ent.FoodEnergy
        tab.FoodThirst = ent.FoodThirst
		title = "Еда"
		subtitle = "Голод: " .. tab.FoodEnergy .. ', Жажда: '.. tab.FoodThirst
	elseif (c == "spawned_weapon") then
		tab.weaponclass = ent.weaponclass
		if ent.number then tab.number = ent.number end

		for k, v in pairs(rp.shipments) do
			if (v.entity == ent.weaponclass) then
				title = v.name
			end
		end
	elseif (c == "spawned_clothe") then
        tab.weaponclass = ent.weaponclass
		tab.bodygroup = ent.bodygroup

        for k, v in pairs(rp.shipments) do
			if (v.entity == ent.weaponclass) then
				title = v.name
			end
		end

		if ent.number then tab.number = ent.number end
	elseif (c == "drug") then
		tab.drugPrice = ent:GetDTInt(0)
		title = "Drug"
	else
		title = wl[c]
	end

    tab.Title = title

	return tab, title, subtitle
end

local function Finalize(ent, tab, owner)
	local c = ent:GetClass()

	tab.Model = model_translations[tab.Model] or tab.Model

	if (c == "spawned_shipment") then
		ent:SetContents(tab.contents, tab.count)
	elseif (c == "spawned_food") then
		ent:SetModel(tab.Model)
		ent.FoodEnergy = tab.FoodEnergy
        ent.FoodThirst = tab.FoodThirst
	elseif (c == "spawned_weapon") then
		ent:SetModel(tab.Model)
		ent.weaponclass = tab.weaponclass

		if tab.number then
			ent.number = tab.number
		end
	elseif (c == "spawned_clothe") then
		ent:SetModel(tab.Model)

		ent.bodygroup = tab.bodygroup
        ent.weaponclass = tab.weaponclass

		if tab.number then
			ent.number = tab.number
		end
	elseif (c == "drug") then
		ent:SetDTInt(0, tab.drugPrice)
		ent:SetDTEntity(1, owner)
	end

	ent:Spawn()
end

rp.AddCommand('/invdrop', function(p, s, a)
	if (not rp.data.IsLoaded(p)) then return end
	local pock = p:GetInv()

	a[1] = tonumber(a[1])

	if (pock[a[1]]) then
		local item = pock[a[1]]

		local ent_class = Ents[item.Class] and Ents[item.Class] or item.Class

		local ent = ents.Create(ent_class)
		local trace = {}
			trace.start = p:EyePos()
			trace.endpos = trace.start + p:GetAimVector() * 85
			trace.filter = p
		local tr = util.TraceLine(trace)
		ent:SetPos(tr.HitPos + Vector(0, 0, 10))
        ent.bodygroup = item.bodygroup or nil

        -- PrintTable(item)
        -- print(weapons.Get( ent_class ))

        if weapons.Get( ent_class ) == nil then
            timer.Simple(60,function()
                if ent and IsValid(ent) then
                    ent:Remove()
                end
            end)
        end

		Finalize(ent, item, p)
	end

	p:GetInv()[a[1]] = nil
	p:SaveInv()
	net.Start("Pocket.RemoveItem")
		net.WriteUInt(a[1], 32)
	net.Send(p)
end)

function SWEP:Reload()
	if CLIENT then return end
	if self.Owner:HasWeapon("keys") then
		self.Owner:SelectWeapon("keys")
	end
end

function SWEP:PrimaryAttack()
	if (not rp.data.IsLoaded(self.Owner)) then return end

	if CLIENT then return end
	self.Weapon:SetNextPrimaryFire(CurTime() + 0.2)
	local tr = self.Owner:GetEyeTrace()
	local ent = tr.Entity
	if (!IsValid(ent)) then return end
	if (self.Owner:EyePos():Distance(tr.HitPos) > 65) then return end
	local ph = ent:GetPhysicsObject()
	if (!ph:IsValid()) then return end

	if (!wl[ent:GetClass()]) then
		-- self.Owner:ChatPrint("You can not put " .. ent:GetClass() .. " in your pocket.")
        rp.Notify(self.Owner, NOTIFY_GREEN, "Вы не можете положить " .. tostring((ent.PrintName and ent.PrintName ~= '') and ent.PrintName or ent:GetClass()) .. " в свой чемодан")
		return
	end

	local Limit = rp.cfg.InvLimit
	-- local Upg = self.Owner:GetUpgradeCount("pocket_space_2")
	-- if Upg then
	-- 	Limit = Limit + (2 * Upg)
	-- end

	local p = self.Owner:GetInv()
	if (table.Count(p) >= Limit) then
        rp.Notify(self.Owner, NOTIFY_GREEN, "В вашем чемодане нету места")
		return
	end

	local tab, title, subtitle = GetEntityInfo(ent)

	net.Start("Pocket.AddItem")
		net.WriteUInt(ID, 32)
		net.WriteString(title)
		net.WriteString(subtitle)
		net.WriteString(tab.Model)
	net.Send(self.Owner)

	ent:Remove()

	p[ID] = tab

	self.Owner:SaveInv()

	ID = ID + 1
end

-- net.Receive("Pocket.AdminDelete", function(len, pl)
-- 	if (!pl:IsSuperAdmin()) then return end

-- 	local targ = net.ReadEntity()
-- 	local id = net.ReadUInt(32)
-- 	local inv = targ:GetInv()

-- 	if (!inv[id]) then return end

-- 	local item = inv[id]
-- 	local itemName = (item.contents and rp.shipments[item.contents].name .. ' (Count: ' .. item.count .. ')') or rp.inv.Wl[item.Class]

-- 	targ:GetInv()[id] = nil
-- 	targ:SaveInv()
-- 	net.Start("Pocket.RemoveItem")
-- 		net.WriteUInt(id, 32)
-- 	net.Send(targ)

-- 	ba.notify(targ, '# has force removed # from your pocket.', pl, itemName)
-- 	ba.notify(pl, 'Removed # from #\'s pocket.', itemName, targ)
-- end)

net.Receive("Pocket.TakeFromBody", function(len, pl)
  local ply = net.ReadEntity()
  local id = net.ReadUInt(32)
  local targ = net.ReadEntity()
  local content = targ.deathinv
  local user = net.ReadEntity()

  net.Start("Pocket.AddItem")
    net.WriteUInt(id, 32)
    net.WriteString(content[id].Title)
    net.WriteString(content[id].subtitle or "")
    net.WriteString(content[id].Model)
  net.Send(user)

  user:GetInv()[id] = content[id]
  user:SaveInv()

  content[id] = nil


end)
