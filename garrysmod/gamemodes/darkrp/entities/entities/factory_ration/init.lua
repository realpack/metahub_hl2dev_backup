AddCSLuaFile( "cl_init.lua" )
AddCSLuaFile( "shared.lua" )

include('shared.lua')

function ENT:Initialize()

	self:SetModel( "models/weapons/w_packate.mdl" )
	self:PhysicsInit( SOLID_VPHYSICS )
	self:SetMoveType( MOVETYPE_VPHYSICS )
	self:SetSolid( SOLID_VPHYSICS )
	self:SetUseType(SIMPLE_USE)

    local phys = self:GetPhysicsObject()
	if (phys:IsValid()) then
		phys:Wake()
	end

	self:SetFood(0)
	self:SetWater(0)
	timer.Simple(45, function() if IsValid(self) then self:Remove() end end)
end

function ENT:Touch( ent )
	if ent:GetClass() == "factory_food" then
		if self:GetFood() < 1 then
			ent:Remove()
			self:EmitSound("items/medshot4.wav")
			self:SetFood(self:GetFood() + 1)
		end
	elseif ent:GetClass() == "factory_water" then
		if self:GetWater() < 3 then
			ent:Remove()
			self:EmitSound("items/medshot4.wav")
			self:SetWater(self:GetWater() + 1)
		end
	end
end

util.AddNetworkString("rationSuccess")
net.Receive("rationSuccess", function(l, p)
	rp.Notify(p, NOTIFY_GENERIC, "Вы собрали рацион, осталось выполнить обработку.")
	p.usedEnt:Ready()
	p.usedEnt = nil
end)

util.AddNetworkString("gmt.rationDone")
net.Receive("gmt.rationDone", function(l, p)
	local ent = p.usedEnt
	ent:Done(p)
	p.usedEnt = nil
end)

util.AddNetworkString("rationPack")
function ENT:Use(activator)
	if self:GetDone() then
		activator.usedEnt = self
		activator:SendLua("Progress(LocalPlayer(), 4, 'Обработка', 'rationDone')")
	else
		if (self:GetFood() == 1) and (self:GetWater() == 3) then
			activator.usedEnt = self
			net.Start("rationPack")
			net.Send(activator)
		else
			rp.Notify(activator, NOTIFY_GENERIC, "Необходимо заполнить рацион двумя банками воды и одной пачкой еды.")
		end
	end
end

function ENT:Done(p)
	p:AddMoney(90)
	rp.Notify(p, NOTIFY_GENERIC, "Вы собрали рацион и получили награду: 90 Крон")
	p:SendLua("surface.PlaySound('items/suitchargeok1.wav')")
	self:Remove()
end

function ENT:Ready()
	self:SetDone(true)
	self:SetModel("models/weapons/w_packatc.mdl")
end
