AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

local Chance
function Chance(ore) 
	while type(ore) == "table" do
		if ore[5] < math.Rand(0, 1) then
			return ore
		else
			return Chance(table.Random(MGS_ORE_TYPES))
		end
	end
end

function ENT:Initialize()
	self:SetModel(table.Random(MGS_ORE_MODELS))
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.Ore = Chance(table.Random(MGS_ORE_TYPES))
	self:SetNWInt("ore", 1)
	self:SetNWInt("distance", MGS_DISTANCE)
	self:SetNWInt("price", self.Ore[3])
	self:SetNWInt("mass", self.Ore[4])
	self:SetNWInt("time", self.Ore[6])
	self:SetNWString("type", self.Ore[1])
	self.Touched = false
	self.RemovingTime = CurTime() + MGS_ORE_REMOVE_TIME
	self:SetColor(self.Ore[2])
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end

function ENT:Think()
	if !self.Touched and self.RemovingTime <= CurTime() then
		self:Remove()
	end
end
