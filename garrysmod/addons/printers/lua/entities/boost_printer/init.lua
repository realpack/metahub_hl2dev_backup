include("shared.lua")
AddCSLuaFile("shared.lua")
AddCSLuaFile("cl_init.lua")

util.AddNetworkString( "UpdatePrinter" )

local function WorldToScreen(vWorldPos,vPos,vScale,aRot)
    local vWorldPos=vWorldPos-vPos
    vWorldPos:Rotate(Angle(0,-aRot.y,0))
    vWorldPos:Rotate(Angle(-aRot.p,0,0))
    vWorldPos:Rotate(Angle(0,0,-aRot.r))
    return vWorldPos.x/vScale,(-vWorldPos.y)/vScale
end

local function inrange(x, y, x2, y2, x3, y3)
	if x > x3 then return false end
	if y < y3 then return false end
	if x2 < x3 then return false end
	if y2 > y3 then return false end
	return true
end

function ENT:Initialize()
	self:SetModel("models/props_c17/consolebox01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetUseType( SIMPLE_USE )

	self.conf = boost_printers.list[self.printer_type]

	self.sound = CreateSound(self, Sound("ambient/levels/labs/equipment_printer_loop1.wav"))
	self.sound:SetSoundLevel(52)
	self.sound:PlayEx(1, 100)

	self.upgrade_price = self.conf.upgrade_price

	self:SetBattery(100)
	self:SetHeat(10)
	self:SetPrintSpeed(1)
	self:SetPrintedMoney(0)
	self:SetCooling(100)
	self:SetPrintRate(self:GetPrintSpeed() * self.conf.money )
end

function ENT:Use(ply)

	if ply:IsCP() then
		self:Remove()
		ply:AddMoney(400)
		rp.Notify(ply, NOTIFY_GENERIC, "Вы получили K400 за уничтожение принтера")
		return
	end

	local lookAtX,lookAtY = WorldToScreen(
		ply:GetEyeTrace().HitPos or Vector(0,0,0),
		self:GetPos() + self:GetAngles():Up() * 1.55, 0.2375,
		self:GetAngles()
	)

	if inrange(-31, -34, -17, -55, lookAtX, lookAtY) and ply:GetMoney() >= self.upgrade_price and self:GetPrintSpeed() < 9 then

		sound.Play( "buttons/button15.wav", self:GetPos(), 100, 100, 1 )
		ply:AddMoney( -self.upgrade_price )

		self:SetPrintSpeed(self:GetPrintSpeed() + 1)
		self:SetPrintRate(self:GetPrintSpeed() * self.conf.money )

		rp.Notify(ply, NOTIFY_GENERIC, "Принтер улучшен!")
	elseif self:GetPrintedMoney() > 0 then
		ply:AddMoney( self:GetPrintedMoney() )
		rp.Notify(ply, NOTIFY_GENERIC, "Вы подобрали K"..self:GetPrintedMoney())
		self:SetPrintedMoney(0)
	end
end

function ENT:OnTakeDamage(dmg)
	if self.burningup then return end

	self.damage = (self.damage or 100) - dmg:GetDamage()
	if self.damage <= 0 then
		self:Destruct()
	end
end

function ENT:OnRemove()
	if self.sound then
		self.sound:Stop()
	end
end

function ENT:Destruct()
	local vPoint = self:GetPos()
	local effectdata = EffectData()
	effectdata:SetStart(vPoint)
	effectdata:SetOrigin(vPoint)
	effectdata:SetScale(1)
	util.Effect("Explosion", effectdata)

	self:Remove()
end

function ENT:Think()
	if not self:CPPIGetOwner():IsValid() then
		self:Remove()
	end
end

function ENT:Think()
	if not self.time then self.time = CurTime() end
	if self.time > CurTime() then return end
	if not IsValid(self) then return end
	if not self.conf then return end

	self.time = CurTime() + math.random(self.conf.rate.min, self.conf.rate.max)

	if self:GetBattery() > 0 then

		self:SetPrintedMoney(self:GetPrintedMoney() + self:GetPrintSpeed() * self.conf.money )

		self:SetBattery(self:GetBattery() - self.conf.battery)

		if self:GetBattery() < 0 then self:SetBattery(0) end

		self:SetCooling(self:GetCooling() - self.conf.cooling)

		if self:GetCooling() < 0 then self:SetCooling(0) end

		if self:GetCooling() > 0 then
			self:SetHeat(self:GetHeat() - 5)
		else
			self:SetHeat(self:GetHeat() + self.conf.heat)
		end

		if self:GetHeat() > 100 then self:SetHeat(100) end
		if self:GetHeat() < 10 then self:SetHeat(10) end
	else
		self:SetHeat(self:GetHeat() - 20)
		if self:GetHeat() < 0 then self:SetHeat(0) end
	end

	if self:GetHeat() >= 100 then
		self:Destruct()
	end

end
