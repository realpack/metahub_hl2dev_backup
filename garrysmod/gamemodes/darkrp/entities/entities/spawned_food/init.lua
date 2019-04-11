AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

resource.AddFile('sound/vo/sandwicheat09.wav')

function ENT:Initialize()
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetCollisionGroup(COLLISION_GROUP_INTERACTIVE_DEBRIS)

	self:PhysWake()

	self.FoodEnergy = 100
    self.FoodThirst = 100
end

function ENT:OnTakeDamage(dmg)
	self:Remove()
end

function ENT:Use(activator,caller)
    local job = rp.teams[activator:Team()]
    if job and job.type and job.type ~= TEAMTYPE_SUP then
        activator:AddHunger(self.FoodEnergy or 100)
        activator:AddThirst(self.FoodThirst or 100)
        self:Remove()
    end
end
