AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()
	self:SetModel("models/props_wasteland/laundry_cart002.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
	local phys = self:GetPhysicsObject()
	phys:Wake()
	self:SetNWInt("ore", 0)
	self:SetNWInt("distance", MGS_DISTANCE)
	self:SetPos(self:GetPos() + Vector(0,0,20))
	self.jailWall = true
	self.CanUse = true
end

function ENT:Touch(hitEnt)
	if not IsValid(hitEnt) then return end
	
	if (self.CanUse) then
		if (hitEnt:GetClass() == "mgs_ore") and (self:GetNWInt("ore") < 10) then
			if (hitEnt:GetNWInt("ore") > 0) then
				if (self:GetNWInt("ore") >= 6) then
					local Ang = self:GetAngles()
					hitEnt:SetAngles(Angle(55, Ang.y, Ang.r))
					hitEnt:SetNWInt("ore", hitEnt:GetNWInt("ore")-1)
					if (self:GetNWInt("ore") == 6) then
						self:SetNWInt("fullprice", self:GetNWInt("fullprice")+hitEnt:GetNWInt("price")*hitEnt:GetNWInt("mass"))
						self:SetNWInt("fullmass", self:GetNWInt("fullmass")+hitEnt:GetNWInt("mass"))
						self:SetNWInt("fulltime", self:GetNWInt("fulltime")+hitEnt:GetNWInt("time"))
					end;
					if (self:GetNWInt("ore") == 7) then
						self:SetNWInt("fullprice", self:GetNWInt("fullprice")+hitEnt:GetNWInt("price")*hitEnt:GetNWInt("mass"))
						self:SetNWInt("fullmass", self:GetNWInt("fullmass")+hitEnt:GetNWInt("mass"))
						self:SetNWInt("fulltime", self:GetNWInt("fulltime")+hitEnt:GetNWInt("time"))
					end;
					if (self:GetNWInt("ore") == 8) then
						self:SetNWInt("fullprice", self:GetNWInt("fullprice")+hitEnt:GetNWInt("price")*hitEnt:GetNWInt("mass"))
						self:SetNWInt("fullmass", self:GetNWInt("fullmass")+hitEnt:GetNWInt("mass"))
						self:SetNWInt("fulltime", self:GetNWInt("fulltime")+hitEnt:GetNWInt("time"))
					end;
					if (self:GetNWInt("ore") == 9) then
						self:SetNWInt("fullprice", self:GetNWInt("fullprice")+hitEnt:GetNWInt("price")*hitEnt:GetNWInt("mass"))
						self:SetNWInt("fullmass", self:GetNWInt("fullmass")+hitEnt:GetNWInt("mass"))
						self:SetNWInt("fulltime", self:GetNWInt("fulltime")+hitEnt:GetNWInt("time"))
					end;
					hitEnt:SetParent(self)
					hitEnt:Remove()
				else 
					local Ang = self:GetAngles()
					if (self:GetNWInt("ore") == 0) then 
						hitEnt:SetPos(self:GetPos() + Ang:Right()*7 + Ang:Up()*-3 + Ang:Forward()*-17)
						self:SetNWEntity("ore1", hitEnt)
						self:SetNWInt("fullprice", hitEnt:GetNWInt("price")*hitEnt:GetNWInt("mass"))
						self:SetNWInt("fullmass", hitEnt:GetNWInt("mass"))
						self:SetNWInt("fulltime", hitEnt:GetNWInt("time"))
					end;
					if (self:GetNWInt("ore") == 1) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*-7 + Ang:Up()*-3 + Ang:Forward()*-17)
						self:SetNWEntity("ore2", hitEnt)
						self:SetNWInt("fullprice", self:GetNWInt("fullprice")+hitEnt:GetNWInt("price")*hitEnt:GetNWInt("mass"))
						self:SetNWInt("fullmass", self:GetNWInt("fullmass")+hitEnt:GetNWInt("mass"))
						self:SetNWInt("fulltime", self:GetNWInt("fulltime")+hitEnt:GetNWInt("time"))
					end;
					if (self:GetNWInt("ore") == 2) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*7 + Ang:Up()*-3 + Ang:Forward()*0)
						self:SetNWEntity("ore3", hitEnt)
						self:SetNWInt("fullprice", self:GetNWInt("fullprice")+hitEnt:GetNWInt("price")*hitEnt:GetNWInt("mass"))
						self:SetNWInt("fullmass", self:GetNWInt("fullmass")+hitEnt:GetNWInt("mass"))
						self:SetNWInt("fulltime", self:GetNWInt("fulltime")+hitEnt:GetNWInt("time"))
					end;
					if (self:GetNWInt("ore") == 3) then 
						hitEnt:SetPos(self:GetPos() + Ang:Right()*-7 + Ang:Up()*-3 + Ang:Forward()*0)
						self:SetNWEntity("ore4", hitEnt)
						self:SetNWInt("fullprice", self:GetNWInt("fullprice")+hitEnt:GetNWInt("price")*hitEnt:GetNWInt("mass"))
						self:SetNWInt("fullmass", self:GetNWInt("fullmass")+hitEnt:GetNWInt("mass"))
						self:SetNWInt("fulltime", self:GetNWInt("fulltime")+hitEnt:GetNWInt("time"))
					end;
					if (self:GetNWInt("ore") == 4) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*7 + Ang:Up()*-3 + Ang:Forward()*20)
						self:SetNWEntity("ore5", hitEnt)
						self:SetNWInt("fullprice", self:GetNWInt("fullprice")+hitEnt:GetNWInt("price")*hitEnt:GetNWInt("mass"))
						self:SetNWInt("fullmass", self:GetNWInt("fullmass")+hitEnt:GetNWInt("mass"))
						self:SetNWInt("fulltime", self:GetNWInt("fulltime")+hitEnt:GetNWInt("time"))
					end;
					if (self:GetNWInt("ore") == 5) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*-7 + Ang:Up()*-3 + Ang:Forward()*20)
						self:SetNWEntity("ore6", hitEnt)
						self:SetNWInt("fullprice", self:GetNWInt("fullprice")+hitEnt:GetNWInt("price")*hitEnt:GetNWInt("mass"))
						self:SetNWInt("fullmass", self:GetNWInt("fullmass")+hitEnt:GetNWInt("mass"))
						self:SetNWInt("fulltime", self:GetNWInt("fulltime")+hitEnt:GetNWInt("time"))
					end;
					hitEnt:SetAngles(Angle(55, Ang.y, Ang.r))
					hitEnt:SetNWInt("ore", hitEnt:GetNWInt("ore")-1)
					hitEnt:SetCollisionGroup(4)
					hitEnt:PhysicsInit(0)
					hitEnt:SetNWInt("distance", 0)
					hitEnt:SetParent(self)
				end;
				hitEnt.Touched = true
				self:SetNWInt("ore", 1+self:GetNWInt("ore"))
			end;
		else 
			if (hitEnt:GetClass() == "mgs_ore") then
				hitEnt:SetPos(self:GetPos()+Vector(20,20,20))
			end
		end
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end
