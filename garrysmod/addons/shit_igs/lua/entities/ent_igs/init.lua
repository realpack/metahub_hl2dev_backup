AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

function ENT:Initialize()
	-- self:SetModel("models/props_junk/Shoe001a.mdl") -- ботинок
	self:SetModel("models/christmas_gift2/christmas_gift2.mdl") -- подарок

	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	self:PhysWake()
end



function ENT:Use(activator, caller, usetype, value)
	if caller:IsPlayer() then
		self:PlayerUse(caller)
	end
end

function ENT:PlayerUse(pl)
	if self.Busy or self.Removed then -- хз нужно ли именно здесь, но я добавил
		IGS.Notify(pl,"Предмет в процессе перемещения в инвентарь")
		IGS.Notify(pl,"Если процесс бесконечный, то поскорее сделайте доказательства и сообщите администратору")
		return
	end
	self.Busy = true

	local UID = self:GetUID()
	IGS.AddToInventory(function(invDbID)
		self.Removed = true
		self:Remove()

		IGS.Notify(pl,"Предмет помещен в /donate инвентарь")

		-- вставлять новый ID не совсем корректно
		-- Думаю, надо кешировать тот ИД, что был при покупке
		hook.Run("IGS.PlayerPickedGift", self:Getowning_ent(), UID, invDbID, pl)
	end, pl, UID, self:GetGlobal())
end

function IGS.CreateGift(sUid, plOwner, bIsGlobal, vPos, iAmount)
	assert(sUid, "Item UID expected")

	local ent = ents.Create("ent_igs")

	if vPos then
		ent:SetPos(vPos)
	end

	ent:SetUID(sUid)
	ent:SetGlobal(bIsGlobal)
	ent:Setowning_ent(plOwner)
	ent:SetAmount(iAmount)

	if vPos then
		ent:Spawn()
	end

	return ent
end
