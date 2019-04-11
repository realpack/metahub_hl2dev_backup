AddCSLuaFile('cl_init.lua')
AddCSLuaFile('shared.lua')
include('shared.lua')

ENT.SeizeReward = 100
ENT.WantReason = 'Money Printing Devices'
ENT.LazyFreeze = true

function ENT:Initialize()
	self:SetModel('models/props_junk/PlasticCrate01a.mdl')
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetUseType(SIMPLE_USE)
	
	self:PhysWake()
end

function ENT:Use(pl)
	if pl:IsBanned() then return end

	if (self:Getmoney() > 0) then
		rp.Notify(pl, NOTIFY_GREEN, rp.Term('PlayerTookMoneyBasket'), rp.FormatMoney(self:Getmoney()))
		pl:AddMoney(self:Getmoney())
		self:Setmoney(0)
		self.SeizeReward = 100
	end
end

function ENT:Touch(ent)
	if ent:GetClass() ~= 'spawned_money' or self.hasMerged or ent.hasMerged then return end
	ent.hasMerged = true
	ent:Remove()
	self:Setmoney(self:Getmoney() + ent:Getamount())
	self.SeizeReward = self:Getmoney()
end