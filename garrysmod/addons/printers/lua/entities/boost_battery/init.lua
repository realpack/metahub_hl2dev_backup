include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

function ENT:Initialize()
	self:SetModel("models/Items/car_battery01.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self.Hit = 0
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		self:Remove()
	end
end

function ENT:StartTouch( hitEnt )
	if string.StartWith( hitEnt:GetClass(), "boost_printer" ) and self.Hit == 0 and hitEnt:GetBattery() < 100 then
		self:Remove()
		self.Hit = 1

		hitEnt:SetBattery(hitEnt:GetBattery() + boost_printers.BatteryAdd)
		if hitEnt:GetBattery() > 100 then hitEnt:SetBattery(100) end
	end
end

function ENT:Use(ply)
	if(ply:IsPlayer())then
		ply:AddItem(FindItem('meta_boost_battery'))
		self:Remove()
	end
end
