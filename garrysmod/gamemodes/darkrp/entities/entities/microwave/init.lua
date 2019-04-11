AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

ENT.RemoveOnJobChange = true

ENT.MinPrice = 10
ENT.MaxPrice = 150

function ENT:Initialize()
	self:SetModel("models/props/cs_office/microwave.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	self:PhysWake()

	self.sparking = false
	self.damage = 100
	self:Setprice(self.MinPrice)
end

function ENT:PhysgunPickup(pl)
	return ((pl == self:Getowning_ent() and self:InSpawn()) or false)
end

function ENT:PhysgunFreeze(pl)
	return self:InSpawn()
end

function ENT:OnTakeDamage(dmg)
	local phys = self:GetPhysicsObject()
	if not phys:IsMoveable() then return end

	self.damage = self.damage - dmg:GetDamage()
	if (self.damage <= 0) then
		self:Destruct()
		self:Remove()
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)
end

function ENT:SalePrice(activator)
	local owner = self:Getowning_ent()
	local discounted = math.ceil(self.MinPrice * 0.82)

	if activator == owner then
		return 25
	else
		return self:Getprice()
	end
end

function ENT:Use(pl)
	if pl:IsBanned() or self.InUse then return end

	if pl:GetCount('Food') >= 15 then
		pl:Notify(NOTIFY_ERROR, rp.Term('FoodLimitReached'))
		return
	end

	local owner = self:Getowning_ent()
	local price = self:Getprice()

	if ((pl ~= owner) and (not pl:CanAfford(price))) or ((pl == owner) and (not pl:CanAfford(self.MinPrice))) then
		pl:Notify(NOTIFY_ERROR, rp.Term('CannotAfford'))
	elseif (pl == owner) then
		pl:Notify(NOTIFY_GENERIC, rp.Term('BoughtFoodProduction'), rp.FormatMoney(self.MinPrice))
		pl:TakeMoney(self.MinPrice)
		self.InUse = true
		self.sparking = true

		timer.Simple(1, function() self:CreateFood(pl) end)
	else
		local gain = price - self.MinPrice

		if (gain == 0) then
			owner:Notify(NOTIFY_ERROR, rp.Term('SoldFoodNoProf'))
			owner:AddKarma(3)
		else
			owner:Notify(NOTIFY_GENERIC, rp.Term('SoldFood'), rp.FormatMoney(gain))
			owner:AddMoney(gain)
			owner:AddKarma(1)
		end

		pl:Notify(NOTIFY_GENERIC, rp.Term('BoughtFood'), rp.FormatMoney(price))
		pl:TakeMoney(price)
		self.InUse = true
		self.sparking = true

		timer.Simple(1, function() self:CreateFood(pl) end)
	end
end

function ENT:CreateFood(pl)
	local foodPos = self:GetPos()
	local food = ents.Create("spawned_food")
	food:SetModel("models/props_junk/garbage_takeoutcarton001a.mdl")
	food:SetPos(Vector(foodPos.x,foodPos.y,foodPos.z + 23))
	food:Spawn()
	self.InUse = false
	self.sparking = false

	if IsValid(pl) then
		pl:_AddCount('Food', food)
	end
end

function ENT:Think()
	if self.sparking then
		local effectdata = EffectData()
		effectdata:SetOrigin(self:GetPos())
		effectdata:SetMagnitude(1)
		effectdata:SetScale(1)
		effectdata:SetRadius(2)
		util.Effect("Sparks", effectdata)
	end
end

function ENT:OnRemove()
	timer.Destroy(self:EntIndex())
	local ply = self:Getowning_ent()
	if not IsValid(ply) then return end
end