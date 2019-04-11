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
	self:SetNWInt("wood", 0)
	self:SetNWInt("distance", SWM_DISTANCE)
	self:SetPos(self:GetPos() + Vector(0,0,20))
	self.jailWall = true
	self.CanUse = true
end

function ENT:Touch(hitEnt)
	if not IsValid(hitEnt) then return end
	
	if (self.CanUse) then
		if (hitEnt:GetClass() == "swm_log") and (self:GetNWInt("wood") < SWM_CART_MAX_LOGS) then
			if (hitEnt:GetNWInt("wood") > 0) then
				if (self:GetNWInt("wood") >= 6) then
					local Ang = self:GetAngles()
					hitEnt:SetAngles(Angle(55, Ang.y, Ang.r))
					hitEnt:SetNWInt("wood", hitEnt:GetNWInt("wood")-1)
					hitEnt:SetParent(self)
					hitEnt:Remove()
				else 
					local Ang = self:GetAngles()
					if (self:GetNWInt("wood") == 0) then 
						hitEnt:SetPos(self:GetPos() + Ang:Right()*10 + Ang:Up()*9 + Ang:Forward()*8)
						self:SetNWEntity("wood1", hitEnt)
					end;
					if (self:GetNWInt("wood") == 1) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*0 + Ang:Up()*9 + Ang:Forward()*8)
						self:SetNWEntity("wood2", hitEnt)
					end;
					if (self:GetNWInt("wood") == 2) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*-10 + Ang:Up()*9 + Ang:Forward()*8)
						self:SetNWEntity("wood3", hitEnt)
					end;
					if (self:GetNWInt("wood") == 3) then 
						hitEnt:SetPos(self:GetPos() + Ang:Right()*10 + Ang:Up()*19 + Ang:Forward()*8)
						self:SetNWEntity("wood4", hitEnt)
					end;
					if (self:GetNWInt("wood") == 4) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*0 + Ang:Up()*19 + Ang:Forward()*8)
						self:SetNWEntity("wood5", hitEnt)
					end;
					if (self:GetNWInt("wood") == 5) then
						hitEnt:SetPos(self:GetPos() + Ang:Right()*-10 + Ang:Up()*19 + Ang:Forward()*8)
						self:SetNWEntity("wood6", hitEnt)
					end;
					hitEnt:SetAngles(Angle(55, Ang.y, Ang.r))
					hitEnt:SetNWInt("wood", hitEnt:GetNWInt("wood")-1)
					hitEnt:SetCollisionGroup(4)
					hitEnt:SetParent(self)
				end;
				hitEnt.Touched = true
				self:SetNWInt("wood", 1+self:GetNWInt("wood"))
			end;
		else 
			if (hitEnt:GetClass() == "swm_log") then
				hitEnt:SetPos(self:GetPos()+Vector(20,20,20))
			end
		end
	end
end

function ENT:OnRemove()
	if not IsValid(self) then return end
end
