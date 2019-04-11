AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'shared.lua'
include 'shared.lua'

function ENT:Initialize()
	self:SetModel('models/props_wasteland/interior_fence002e.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	self:PhysWake()
	self:SetMode(1)

	self:SetMaterial('phoenix_storms/gear')

	self:CPPISetOwner(self.ItemOwner)
end
/*
function ENT:PhysgunPickup(pl)
	return (pl == self.ItemOwner)
end

function ENT:PhysgunFreeze(pl)
	return (pl == self.ItemOwner)
end
*/
function ENT:Pass()
	self:SetMode(2)
	self:EmitSound('HL1/fvox/bell.wav')
	timer.Simple(0.75, function()
		if IsValid(self) then
			self:SetMode(1)
		end
	end)
end

function ENT:Alarm()
	self:SetMode(3)
	for i = 1, 3 do
		timer.Simple(i - 1, function()
			if IsValid(self) then
				self:EmitSound('ambient/alarms/klaxon1.wav')
				if (i == 3) then
					self:SetMode(1)
				end
			end
		end)
	end
end

local vec = Vector(0,0,30)
function ENT:Think()
	local cen = self:OBBCenter()
	local real = self:LocalToWorld(Vector(cen.x, cen.y, self:OBBMins().z)) + vec

	for k, v in ipairs(ents.FindInSphere(self:GetPos(), 35)) do
		if v:IsPlayer() and ((not v.LastChecked) or (v.LastChecked <= CurTime())) and (v:GetPos():Distance(real) < 35) then
			v.LastChecked = CurTime() + 2
			for k, v in ipairs(v:GetWeapons()) do
				if v:IsIllegalWeapon() then
					self:Alarm()
					self:NextThink(CurTime() + 2)
					return
				end
			end
			self:Pass()
			self:NextThink(CurTime() + 1)
		end
	end
end