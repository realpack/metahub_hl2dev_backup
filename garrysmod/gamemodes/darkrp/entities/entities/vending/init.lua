AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")

include("shared.lua")

function ENT:Initialize()

	self:SetModel("models/props_interiors/VendingMachineSoda01a.mdl")
	self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)

	self:SetUseType(SIMPLE_USE)

	-- local phys = self:GetPhysicsObject()
	-- if ( IsValid( phys ) ) then phys:Wake() end

end

usetime = true
function ENT:AcceptInput( name, pPlayer )
	if name == "Use" && pPlayer:IsPlayer() then
		if !IsValid(pPlayer) then return end
		if pPlayer:GetMoney() >= 100 then
			if usetime then
				self:EmitSound("buttons/lever3.wav", 70, 100)
				pPlayer:AddMoney(-100)
				timer.Simple(1,function()
					self:EmitSound("HL1/fvox/hiss.wav", 75, 100)

					local Pos = self:GetPos()
					local Ang = self:GetAngles()

					Ang:RotateAroundAxis( Ang:Forward(), 90 )
					Ang:RotateAroundAxis( Ang:Right(), 90 )
					Ang:RotateAroundAxis( Ang:Up(), 0 )

					local ent = ents.Create("spawned_food")
                    ent:SetModel('models/props_junk/PopCan01a.mdl')
					ent:SetPos(Pos + Ang:Up() * -13 + Ang:Right() * 16 + Ang:Forward() * 3 )
					ent:SetAngles(Angle(0,0,90))
					ent:SetBodygroup(1,math.random(1,3))
                    ent.FoodEnergy = 20
                    ent.FoodThirst = 20


                    ent.ItemOwner = pPlayer
					ent:Spawn()

					timer.Simple(30,function()
						if ent and IsValid(ent) then
							ent:Remove()
						end
					end)
				end)
				usetime = false
			end
			timer.Simple(3,function()
				usetime = true
			end)
		else
			pPlayer:ChatPrint("Not enough money.")
		end
		-- self:Remove()
	end
end

function ENT:Think() end
