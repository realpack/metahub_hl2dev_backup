AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
    if self.Model then
        self:SetModel(self.Model)
    end

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)

	self:PhysWake()
end

function ENT:Use(activator, caller)
	if type(self.PlayerUse) == "function" then
		local val = self:PlayerUse(activator, caller)
		if val ~= nil then return val end
	elseif self.PlayerUse ~= nil then
		return self.PlayerUse
	end

	local class = self.weaponclass
    local item = nil

    -- PrintTable(rp.shipments)
    for _, it in pairs(rp.shipments) do
        if it.entity == class then
            item = it
        end
    end

    if item.bodygroup then
        local bodygroup = item.bodygroup

        local clothes = activator:GetNetVar('Clothes') or {}

        if clothes[bodygroup.key] then
            rp.Notify(activator, NOTIFY_ERROR, 'На этой части тела уже что-то надето.')
            return
        end

        local item_tosave = {}

        item_tosave.name = item.name
        item_tosave.model = item.model
        item_tosave.bodygroup = item.bodygroup
        item_tosave.entity = item.entity

        clothes[bodygroup.key] = item_tosave
        activator:SetBodygroup(bodygroup.key, bodygroup.value)

        activator:SetNetVar('Clothes', clothes)
        rp.data.SetClothes(activator, pon.encode(clothes))
    end

    self:Remove()

	-- local weapon = ents.Create(class)

	-- if not weapon:IsValid() then return false end

	-- if not weapon:IsWeapon() then
	-- 	weapon:SetPos(self:GetPos())
	-- 	weapon:SetAngles(self:GetAngles())
	-- 	weapon:Spawn()
	-- 	weapon:Activate()
	-- 	self:Remove()
	-- 	return
	-- end

	-- local CanPickup = hook.Call("PlayerCanPickupWeapon", GAMEMODE, activator, weapon)
	-- if not CanPickup then return end
	-- weapon:Remove()

	-- activator:Give(class)
	-- weapon = activator:GetWeapon(class)

	-- if self.clip1 then
	-- 	weapon:SetClip1(self.clip1)
	-- 	weapon:SetClip2(self.clip2 or -1)
	-- end

	-- activator:GiveAmmo(self.ammoadd or 0, weapon:GetPrimaryAmmoType())

	-- self:Remove()
end
