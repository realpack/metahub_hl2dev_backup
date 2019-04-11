AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/reciever_cart.mdl")
	
	timer.Simple(0.5, function()
		local prop1 = ents.Create("swm_sawmill_part1")
		prop1:SetPos(self:GetPos() + self:GetAngles():Up()*34 + self:GetAngles():Right()*26)
		prop1:SetAngles(self:GetAngles())
		prop1:Spawn()
		prop1:Activate()
		prop1:SetParent(self)
		prop1:SetSolid(SOLID_VPHYSICS)
	end)
	timer.Simple(0.5, function()	
		local prop2 = ents.Create("swm_sawmill_part2")
		prop2:SetPos(self:GetPos() + self:GetAngles():Up()*-30 + self:GetAngles():Right()*26)
		prop2:SetAngles(self:GetAngles())
		prop2:Spawn()
		prop2:Activate()
		prop2:SetParent(self)
		prop2:SetSolid(SOLID_VPHYSICS)
	end)
	timer.Simple(0.5, function()	
		local Angles = self:GetAngles()
		Angles:RotateAroundAxis(Angles:Forward(), 90)
		
		local prop3 = ents.Create("swm_sawmill_part3")
		prop3:SetPos(self:GetPos() + self:GetAngles():Right()*40 + self:GetAngles():Up()*15)
		prop3:SetAngles(Angles)
		prop3:Spawn()
		prop3:Activate()
		prop3:SetParent(self)
		self:SetNWEntity("saw", prop3)
	end)	
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetNWInt("wood", 0)
	self:SetNWInt("distance", SWM_DISTANCE);
	self:SetNWInt("width", 205)
	self:SetNWInt("getWoods", 0)
	self:SetPos(self:GetPos())
	self.CanUse = true
	self.JailWall = true
end

function ENT:Touch(hitEnt)
	if not IsValid(hitEnt) then return end
	
	if self.CanUse then
		if (hitEnt:GetClass() == "swm_cart") and (hitEnt:GetNWInt("wood") > 0) and (!hitEnt:IsPlayerHolding()) then
			hitEnt:SetPos(self:GetPos() + self:GetAngles():Right()*40 + self:GetAngles():Up()*-6)
			hitEnt:SetAngles(self:GetAngles())
			hitEnt:SetParent(self)
			self.CanUse = false
			self.SumTime = SWM_SAW_TIME * hitEnt:GetNWInt("wood")
			self.Time = CurTime() + self.SumTime
			self.GiveAmount = hitEnt:GetNWInt("wood") * SWM_LOG_PRICE
			self:SetNWInt("timer", self.Time)
			self:SetNWEntity("cart", hitEnt)
			self:SetNWInt("getWoods", hitEnt:GetNWInt("wood"))
			self.EffectTime = CurTime() + 1
			hitEnt.CanUse = false
		end
	end
end

function ENT:Think()
	if !self.CanUse then
		local width = ((100/self.SumTime)*(205/100))/10
		self:SetNWInt("width", self:GetNWInt("width") - width);
		self:NextThink(CurTime()+0.1)
		
		local saw = self:GetNWEntity("saw")
		local Angles = saw:GetAngles()
		Angles:RotateAroundAxis(Angles:Up(), CurTime()*10)
		saw:SetAngles(Angles)
		
		if (SWM_SAW_EFFECT) and (self.EffectTime <= CurTime()) then
			self:EmitSound("physics/wood/wood_box_impact_hard"..math.random(1, 3)..".wav");	
					
			local effectData = EffectData();
			effectData:SetStart(self:GetPos()+self:GetAngles():Right()*40);
			effectData:SetOrigin(self:GetPos()+self:GetAngles():Right()*40);
			effectData:SetScale(8);	
			util.Effect("GlassImpact", effectData, true, true);
			self.EffectTime = CurTime() + 1
		end;
		
		if self.Time <= CurTime() then
			self:SetNWInt("width", 205);
			local cart = self:GetNWEntity("cart")
			if (cart != NULL) then
				local selfAng = self:GetAngles()
				cart:SetNWInt("wood", 0)
				cart:SetParent()
				cart:SetPos(self:GetPos() + selfAng:Right()*90)
				cart.CanUse = true
				
				local log1 = cart:GetNWEntity("wood1")
				local log2 = cart:GetNWEntity("wood2")
				local log3 = cart:GetNWEntity("wood3")
				local log4 = cart:GetNWEntity("wood4")
				local log5 = cart:GetNWEntity("wood5")
				local log6 = cart:GetNWEntity("wood6")
				if (log1 != NULL) then log1:Remove() end
				if (log2 != NULL) then log2:Remove() end
				if (log3 != NULL) then log3:Remove() end
				if (log4 != NULL) then log4:Remove() end
				if (log5 != NULL) then log5:Remove() end
				if (log6 != NULL) then log6:Remove() end
				
				self.CanUse = true
				self:SetNWInt("getWoods", 0)
				
				local amount = self.GiveAmount
				if (SWM_SAFEMODE) then 
					local owner = cart:Getowning_ent()
					if (SWM_GM_VERSION <= 2.4) then
						owner:AddMoney(amount or 0)
					else
						owner:addMoney(amount or 0)
					end
					self.GiveAmount = 0
				else
					local Angles = self:GetAngles()
					DarkRP.createMoneyBag(self:GetPos() + Angles:Up()*-16.5, amount)
				end
				self.GiveAmount = 0
			else
				self.CanUse = true
				self.GiveAmount = 0
			end
		end
		return true
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end
