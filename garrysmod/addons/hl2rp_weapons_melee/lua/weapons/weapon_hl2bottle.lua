
-----------------------------------------------------

AddCSLuaFile()

local BaseClass = baseclass.Get('weapon_hl2axe')

SWEP.Spawnable			= true
SWEP.Category = "Оружие Ближнего Боя"

SWEP.PrintName				= "Бутылка"

SWEP.ViewModel				= Model( "models/weapons/HL2meleepack/v_bottle.mdl" )
SWEP.WorldModel				= Model( "models/weapons/HL2meleepack/w_bottle.mdl" )

SWEP.HitSound = Sound( "GlassBottle.Break" )
SWEP.SwingSound = Sound( "WeaponFrag.Roll" )
SWEP.HitSoundElse = Sound("GlassBottle.Break")
SWEP.PushSound = Sound( "Flesh.ImpactSoft" )

SWEP.HitRate = 0.50
SWEP.DamageDelay = 0.2
SWEP.PushDelay = 1
SWEP.DamageMin = 10
SWEP.DamageMax = 20

SWEP.HitAngle = Angle(6, 4, 0.125)

SWEP.HoldType = "melee"

local td = {}
local tr, ent
function SWEP:Damage()
	td.start = self.Owner:GetShootPos()
	td.endpos = td.start + self.Owner:EyeAngles():Forward() * 50
	td.filter = self.Owner
	td.mins = Vector(-6, -6, -6)
	td.maxs = Vector(6, 6, 6)

	tr = util.TraceHull(td)

	if tr.Hit then
		ent = tr.Entity
		print(ent)

		if IsValid(ent) then
			if ent:IsPlayer() or ent:IsNPC() then

				if SERVER then
					ent:TakeDamage(math.random(self.DamageMin, self.DamageMax), self.Owner, self.Owner)
				end

				ParticleEffect("blood_impact_red_01", tr.HitPos, tr.HitNormal:Angle(), ent)
				self:EmitSound(self.HitSound, 80, 100)
			else
				if SERVER then
					ent:TakeDamage(math.random(self.DamageMin, self.DamageMax), self.Owner, self.Owner)

					if ent:GetClass() == "func_breakable_surf" then
						ent:Input("Shatter", NULL, NULL, "")
						self:EmitSound("physics/glass/glass_impact_bullet1.wav", 80, math.random(95, 105))
					end
				end

				self:EmitSound(self.HitSoundElse, 80, 100)
			end
		else
			self:EmitSound(self.HitSoundElse, 80, 100)
		end

		if SERVER then
			self.Owner:Give("weapon_hl2bottle")
			self.Owner:SelectWeapon("weapon_hl2brokenbottle")
			self.Owner:StripWeapon(self:GetClass())
		end
	end
end

function SWEP:Think()
	if self.DamageTime and CurTime() > self.DamageTime then
		if SERVER then
			self.Owner:LagCompensation(true)
		end

		self:Damage()

		if SERVER then
			self.Owner:LagCompensation(false)
		end

		self.DamageTime = nil
	elseif self.ThrowDelay && self.ThrowDelay > CurTime() then
		if SERVER then
			self.Owner:LagCompensation(true)
		end

		self:Throwbottle()

		if SERVER then
			self.Owner:LagCompensation(false)
		end
		self.Owner:StripWeapon(self:GetClass())
	end
end

function SWEP:SecondaryAttack()
	self.Weapon:SetNextPrimaryFire( CurTime() + 1 )
	self.Weapon:SetNextSecondaryFire( CurTime() + 1 )

	self.Owner:SetAnimation( PLAYER_ATTACK1 )

	self:EmitSound( self.SwingSound )

	local vm = self.Owner:GetViewModel()
	vm:SendViewModelMatchingSequence( vm:LookupSequence( "misscenter1" ) )
	if CLIENT then return end
	self.ThrowDelay = CurTime() + 1
	
end

function SWEP:Throwbottle()
	local ent = ents.Create( "prop_physics" )	
	ent:SetModel( "models/props_junk/garbage_glassbottle003a.mdl" )
	ent:SetPos( self.Owner:EyePos() + ( self.Owner:GetAimVector() * 20 ) )
	ent:SetAngles( self.Owner:EyeAngles() - Angle( 0, 50, 190 ) )
	ent:Spawn()

	local phys = ent:GetPhysicsObject();
 
	//local shot_length = tr.HitPos:Length();
	phys:ApplyForceCenter (self.Owner:GetAimVector()*2000 )
	phys:AddAngleVelocity(Vector( -250, -250, 0 ))

	timer.Simple(10, function()
		if IsValid(ent) then
			ent:Remove()
		end
	end)
end