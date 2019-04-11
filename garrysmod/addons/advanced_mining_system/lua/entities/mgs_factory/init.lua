AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_lab/reciever_cart.mdl")
	
	timer.Simple(0.5, function()
		local prop1 = ents.Create("mgs_factory_part1")
		prop1:SetPos(self:GetPos() + self:GetAngles():Up()*34 + self:GetAngles():Right()*26)
		prop1:SetAngles(self:GetAngles())
		prop1:Spawn()
		prop1:Activate()
		prop1:SetParent(self)
		prop1:SetSolid(SOLID_VPHYSICS)
	end)
	timer.Simple(0.5, function()	
		local prop2 = ents.Create("mgs_factory_part2")
		prop2:SetPos(self:GetPos() + self:GetAngles():Up()*-30 + self:GetAngles():Right()*26)
		prop2:SetAngles(self:GetAngles())
		prop2:Spawn()
		prop2:Activate()
		prop2:SetParent(self)
		prop2:SetSolid(SOLID_VPHYSICS)
	end)
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	self:SetNWInt("ore", 0)
	self:SetNWInt("distance", MGS_DISTANCE);
	self:SetNWInt("width", 205)
	self:SetNWInt("getOres", 0)
	self:SetNWInt("vectorx", -25)
	self:SetNWInt("vectory", -20)
	self:SetPos(self:GetPos())
	self.CanUse = true
	self.JailWall = true
end

function ENT:Touch(hitEnt)
	if not IsValid(hitEnt) then return end
	
	if self.CanUse then
		if (hitEnt:GetClass() == "mgs_cart") and (hitEnt:GetNWInt("ore") > 0) and (!hitEnt:IsPlayerHolding()) then
			hitEnt:SetPos(self:GetPos() + self:GetAngles():Right()*40 + self:GetAngles():Up()*-6)
			hitEnt:SetAngles(self:GetAngles())
			hitEnt:SetParent(self)
			self.CanUse = false
			if (MGS_NEW_TIME) then	
				self:SetNWInt("fulltime", math.Round(hitEnt:GetNWInt("fulltime")))
				self.Time = CurTime() + self:GetNWInt("fulltime")
				self.SumTime = self:GetNWInt("fulltime")
			else
				self.SumTime = MGS_CRUSH_TIME * hitEnt:GetNWInt("ore")
				self.Time = CurTime() + self.SumTime
			end
			self.GiveAmount = math.Round(hitEnt:GetNWInt("fullprice"))
			self:SetNWInt("giveAmount", math.Round(hitEnt:GetNWInt("fullprice")))
			self:SetNWInt("fullmass", math.Round(hitEnt:GetNWInt("fullmass")))
			self:SetNWInt("timer", self.Time)
			self:SetNWEntity("cart", hitEnt)
			self:SetNWInt("getOres", hitEnt:GetNWInt("ore"))
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

		if (MGS_CRUSH_EFFECT) and (self.EffectTime <= CurTime()) then
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
				cart:SetNWInt("ore", 0)
				cart:SetParent()
				cart:SetPos(self:GetPos() + selfAng:Right()*90)
				cart.CanUse = true
				
				local ore1 = cart:GetNWEntity("ore1")
				local ore2 = cart:GetNWEntity("ore2")
				local ore3 = cart:GetNWEntity("ore3")
				local ore4 = cart:GetNWEntity("ore4")
				local ore5 = cart:GetNWEntity("ore5")
				local ore6 = cart:GetNWEntity("ore6")
				if (ore1 != NULL) then ore1:Remove() end
				if (ore2 != NULL) then ore2:Remove() end
				if (ore3 != NULL) then ore3:Remove() end
				if (ore4 != NULL) then ore4:Remove() end
				if (ore5 != NULL) then ore5:Remove() end
				if (ore6 != NULL) then ore6:Remove() end
				
				self.CanUse = true
				self:SetNWInt("getOres", 0)
				self:SetNWInt("giveAmount", 0)
				self:SetNWInt("fullmass", 0)
				self:SetNWInt("fulltime", 0)
				
				local amount = self.GiveAmount
				if (MGS_SAFEMODE) then 
					local owner = cart:Getowning_ent()
					if (MGS_GM_VERSION <= 2.4) then
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
