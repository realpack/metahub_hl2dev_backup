SWEP.Author						= "Tader & Syntax_Error752"
SWEP.Category					= "Оружейная"
SWEP.Purpose					= "Bring forth flames upon your enemies!"
SWEP.Instructions				= "Left-Click: Fire\nReload: Regenerate Fuel"
SWEP.Spawnable					= true
SWEP.AdminSpawnable				= true

/*if ( CLIENT ) then
	SWEP.WepSelectIcon = surface.GetTextureID("HUD/syndod/killicons/m2")
	
	killicon.Add( "weapon_752_m2_flamethrower", "HUD/syndod/killicons/m2", Color( 255, 80, 0, 255 ) )
end
*/
SWEP.ViewModel					= "models/weapons/syndod/v_m2.mdl"
SWEP.WorldModel					= "models/weapons/sanic/w_m2.mdl"
SWEP.ViewModelFOV      			= 50

SWEP.HoldType					= "smg"
SWEP.Primary.Automatic			= true
SWEP.Primary.ClipSize			= -1
SWEP.Primary.DefaultClip		= -1
SWEP.Primary.Ammo				= "none"
SWEP.Secondary.ClipSize			= 75
SWEP.Secondary.DefaultClip		= 50
SWEP.Secondary.Automatic		= true
SWEP.Secondary.Ammo				= "ar2"
SWEP.ReloadDelay 				= 0
--Player:GiveAmmo( 50, "ar2", true )
function SWEP:Initialize()
	
	self:SetWeaponHoldType( self.HoldType )
	
end

function SWEP:Precache()

	util.PrecacheSound("ambient/machines/keyboard2_clicks.wav")

	util.PrecacheSound("ambient/machines/thumper_dust.wav")
	util.PrecacheSound("ambient/fire/mtov_flame2.wav")
	util.PrecacheSound("ambient/fire/ignite.wav")

	util.PrecacheSound("vehicles/tank_readyfire1.wav")

end

function SWEP:PrimaryAttack()

	if (SERVER) then
		if (self.Owner:GetAmmoCount("ar2") < 1) || (self.ReloadDelay == 1) then
			self:RunoutReload()
		return end
	end

	if (self.Owner:GetAmmoCount("ar2") > 0) && (self.ReloadDelay == 0) then
		self.Owner:RemoveAmmo( 1, self.Weapon:GetSecondaryAmmoType() )
		self.Owner:MuzzleFlash()
		self.Weapon:SetNextPrimaryFire( CurTime() + 0.08 )
		if (SERVER) then
			local trace = self.Owner:GetEyeTrace()
			local Distance = self.Owner:GetPos():Distance(trace.HitPos)
			if Distance < 1350 then
				local Ignite = function()
					if !self:IsValid() then return end
					local flame = ents.Create("point_hurt")
					flame:SetPos(trace.HitPos)
					flame:SetOwner(self.Owner)
					flame:SetKeyValue("DamageRadius",128)
					flame:SetKeyValue("Damage",20)
					flame:SetKeyValue("DamageDelay",0.32)
					flame:SetKeyValue("DamageType",8)
					flame:Spawn()
					flame:Fire("TurnOn","",0) 
					flame:Fire("kill","",0.72)
					if trace.HitWorld then
						local nearbystuff = ents.FindInSphere(trace.HitPos, 100)
						
						for _, stuff in pairs(nearbystuff) do
							if stuff != self.Owner then
								if stuff:GetPhysicsObject():IsValid() && !stuff:IsNPC() && !stuff:IsPlayer() then
									if !stuff:IsOnFire() then stuff:Ignite(math.random(16,32), 100) timer.Simple(10, function() if stuff:GetClass() == "prop_ragdoll" then stuff:Remove() end end) end
								end
								if stuff:IsPlayer() then
									if stuff:GetPhysicsObject():IsValid() then
										stuff:Ignite(1, 100)
									end
								end
								
								if stuff:IsNPC() then
									if stuff:GetPhysicsObject():IsValid() then
										local npc = stuff:GetClass()
										if npc == "npc_antlionguard" || npc == "npc_hunter" || npc == "npc_kleiner" || npc == "npc_gman" || npc == "npc_eli" || npc == "npc_alyx" || npc == "npc_mossman" || npc == "npc_breen" || npc == "npc_monk" || npc == "npc_vortigaunt" || npc == "npc_citizen" || npc == "npc_rebel" || npc == "npc_barney" || npc == "npc_magnusson" then
											stuff:Fire("Ignite","",1)
										end
										stuff:Ignite(math.random(12,16), 100)
									end
								end
							end
						end
					end
					
					if trace.Entity:IsValid() then
						if trace.Entity:GetPhysicsObject():IsValid() && !trace.Entity:IsNPC() && !trace.Entity:IsPlayer() then
							if !trace.Entity:IsOnFire() then trace.Entity:Ignite(math.random(16,32), 100) timer.Simple(10, function() if trace.Entity:GetClass() == "prop_ragdoll" then trace.Entity:Remove() end end) end
						end
						
						if trace.Entity:IsPlayer() then
							if trace.Entity:GetPhysicsObject():IsValid() then trace.Entity:Ignite(math.random(1,2), 100) end
						end
						
						if trace.Entity:IsNPC() then
							if trace.Entity:GetPhysicsObject():IsValid() then
								local npc = trace.Entity:GetClass()
								if npc == "npc_antlionguard" || npc == "npc_hunter" || npc == "npc_kleiner" || npc == "npc_gman" || npc == "npc_eli" || npc == "npc_alyx" || npc == "npc_mossman" || npc == "npc_breen" || npc == "npc_monk" || npc == "npc_vortigaunt" || npc == "npc_citizen" || npc == "npc_rebel" || npc == "npc_barney" || npc == "npc_magnusson" then
									trace.Entity:Fire("Ignite","",1)
								end
								trace.Entity:Ignite(math.random(12,16), 100)
							end
						end
					end
					
					if (SERVER) then
						local firefx = EffectData()
						firefx:SetOrigin(trace.HitPos)
						util.Effect("effect_flamer_fire",firefx,true,true)
					end
				end
				timer.Simple(Distance/800, Ignite)
			end
		end
	end
end

function SWEP:SecondaryAttack()
end

function SWEP:Deploy()
	self.Weapon:SendWeaponAnim(ACT_VM_DRAW)
	if (SERVER) then
		self.Owner:EmitSound( "ambient/machines/keyboard2_clicks.wav", 42, 100 )
	end
	return true
end

function SWEP:Think()
	if self.Owner:KeyReleased(IN_ATTACK) && (self.Owner:GetAmmoCount("ar2") > 1) && (self.ReloadDelay != 1) then
		if (SERVER) then
			self.Owner:EmitSound( "ambient/fire/mtov_flame2.wav", 24, 100 )
		end
	end
	
	if (self.Owner:GetAmmoCount("ar2") > 0) && (self.ReloadDelay == 0) then
		if self.Owner:KeyPressed(IN_ATTACK) then
			if (SERVER) then
				self.Owner:EmitSound( "ambient/machines/thumper_dust.wav", 46, 100 )
				--self.Owner:EmitSound( "ambient/fire/mtov_flame2.wav", 46, 100 )
			end
		end
		
		if self.Owner:KeyDown(IN_ATTACK) then
			if (SERVER) then
				self.Owner:EmitSound( "ambient/fire/mtov_flame2.wav", math.random(27,35), math.random(32,152) )
			end
			local trace = self.Owner:GetEyeTrace()
			if (SERVER) then
				local flamefx = EffectData()
				flamefx:SetOrigin(trace.HitPos)
				flamefx:SetStart(self.Owner:GetShootPos())
				flamefx:SetAttachment(1)
				flamefx:SetEntity(self.Weapon)
				util.Effect("effect_flamer_fire",flamefx,true,true)
			end
		end

	end
end

function SWEP:Reload()
	if (self.Owner:GetAmmoCount("ar2") > 74) || (self.ReloadDelay == 1) then return end
	
	self.ReloadDelay = 1
	if (SERVER) then
		self.Owner:EmitSound( "vehicles/tank_readyfire1.wav", 30, 100 )
	end
	timer.Simple(1.82, function() if self:IsValid() then self:ReloadSelf() end end)
end

function SWEP:RunoutReload()
	if (self.Owner:GetAmmoCount("ar2") > 74) || (self.ReloadDelay == 1) then return end

	self.ReloadDelay = 1
	if (SERVER) then
		self.Owner:EmitSound( "ambient/machines/thumper_dust.wav", 48, 100 )
		self.Owner:EmitSound( "vehicles/tank_readyfire1.wav", 30, 100 )
	end
	timer.Simple(1.82, function() if self:IsValid() then self:ReloadSelf() end end)
end

function SWEP:ReloadSelf()
	if !self then return end
	if !self:IsValid() then return end
	
	if (SERVER) then
		local ammo = math.Clamp( (75 - self.Owner:GetAmmoCount("ar2")), 0, 75)
		self.Owner:GiveAmmo(ammo, "ar2")
	end
	self.ReloadDelay = 0
	if self.Owner:KeyDown(IN_ATTACK) then
		if (SERVER) then
			self.Owner:EmitSound( "ambient/machines/thumper_dust.wav", 46, 100 )
		end
	end
end
