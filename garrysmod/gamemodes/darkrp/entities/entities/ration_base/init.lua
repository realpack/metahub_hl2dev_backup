AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)

	self:PhysWake()
end

function ENT:ExtraRationMoney(user)
    local extra_money = rp.cfg.ExtraRationMoney[user:Team()]
    if user and extra_money and extra_money ~= 0 then
        user:AddMoney(extra_money)
        -- meta.util.Notify('yellow', user, 'Зарплата: '..formatMoney(extra_money))
		rp.Notify(user, NOTIFY_GENERIC, 'Зарплата: '..rp.FormatMoney(extra_money))
    end
end

local function FindItem(cl)
	local next = false
	-- if not next then for _, it in pairs(rp.shipments) do if it.entity == cl or it.name == cl then next = it break end end end
	-- if not next then for _, it in pairs(rp.entities) do if it.ent == cl or it.name == cl then next = it break end end end
	if not next then for name, it in pairs(rp.Foods) do if name == rp.inv.Wl[cl] or it.name == cl then next = it next.name = name break end end end

	return next
end

function ENT:AddItem(user, name)
    -- print(name)
	-- local sh_data = FindItem(name)
    -- print(user, sh_data)


	-- for _, it in pairs(rp.shipments) do if it.name == name then item = it tp = 'ship' break end end
    local sh_data = false
 	if not sh_data then for key, it in pairs(rp.Foods) do if key == name then sh_data = it sh_data.baseclass = 'spawned_food' sh_data.name = name break end end end
	-- if not item then for _, it in pairs(rp.entities) do if it.name == name then item = it break end end end


    -- print(item)

    -- print(item)
    -- PrintTable(item)


    -- PrintTable(sh_data)
    if not sh_data then return end

    local inv = user:GetInv()
    local tab = {}
    -- tab.baseclass = sh_data.model
    tab.Class = 'spawned_food'
    tab.Model = sh_data.model
    tab.Title = sh_data.name
    tab.amount = sh_data.amount
    tab.thirst = sh_data.thirst

    net.Start("Pocket.AddItem")
        net.WriteUInt(ID, 32)
        net.WriteString(tab.Title)
        net.WriteString('')
        net.WriteString(tab.Model)
    net.Send(user)

    inv[ID] = tab

    ID = ID + 1

    return tab.Title

    -- user:SaveInv()
    -- user:SendInv()

    -- -- item.baseclass = 'spawned_food'

	-- -- local ent = ents.Create(item.baseclass)
	-- -- ent:SetPos(self:GetPos())
	-- -- if item.baseclass == 'spawned_food' then
	-- -- 	ent:SetModel(rp.Foods[name].model)
	-- -- 	ent.FoodEnergy = rp.Foods[name].amount
	-- -- 	ent.FoodThirst = rp.Foods[name].thirst
	-- -- 	ent.ItemOwner = pl
	-- -- end
	-- -- ent:Spawn()

	-- -- local p = user:GetInv()
	-- -- local tab, title, subtitle = GetEntityInfo(ent)
	-- -- local title = name

	-- -- net.Start("Pocket.AddItem")
	-- -- 	net.WriteUInt(ID, 32)
	-- -- 	net.WriteString(title)
	-- -- 	net.WriteString(subtitle)
	-- -- 	net.WriteString(tab.Model)
	-- -- net.Send(user)

	-- -- ent:Remove()

	-- -- p[ID] = tab

    -- -- print(name)

	-- -- user:SaveInv()

	-- -- self:Remove()

    -- print(2, sh_data.name)
	-- return sh_data.name
end

-- function ENT:OnTakeDamage(dmg)
-- 	self:Remove()
-- end

-- function ENT:Use(activator,caller)

--     self:Remove()
-- end
