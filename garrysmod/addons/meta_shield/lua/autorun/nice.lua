if (SERVER) then
	AddCSLuaFile()
	AddCSLuaFile("shield_config.lua")
	include("shield_config.lua")
	include("shield_server.lua")
else
	include("shield_config.lua")
end


btShield.blocker = btShield.blocker or {}

local function rayQuadIntersect(vOrigin, vDirection, vPlane, vX, vY)
	local vp = vDirection:Cross(vY)

	local d = vX:DotProduct(vp)

	if (d <= 0.0) then return end

	local vt = vOrigin - vPlane
	local u = vt:DotProduct(vp)
	if (u < 0.0 or u > d) then return end

	local v = vDirection:DotProduct(vt:Cross(vX))
	if (v < 0.0 or v > d) then return end

	return u / d,v / d
end

if (CLIENT) then
	local meta = FindMetaTable("Player")

	function meta:hasBallisticShield()
		return self:GetNWString("btShield.hasBali", false)
	end

	function meta:getCurrentShield()
		return self:GetNWString("btShield.class"), self:GetNWEntity("btShield.weapon")
	end
end

function btShield:addHook(a, b)
	hook.Add(a, "btShield_hook", b)
end

btShield:addHook("StartCommand", function(client, ucmd)
	if (client:hasBallisticShield() == true) then
		local curShield, weapon = client:getCurrentShield()

		-- if (IsValid(weapon)) then
		-- 	if (weapon:GetDTBool(0) != true) then
		-- 		if (ucmd:KeyDown(IN_DUCK)) then
		-- 			ucmd:RemoveKey(IN_DUCK)
		-- 		end
		-- 		if (ucmd:KeyDown(IN_SPEED)) then
		-- 			ucmd:RemoveKey(IN_SPEED)
		-- 		end
		-- 	end
		-- end
	end
end)

btShield:addHook("DoPlayerHasShield", function(client, weapon, curShield)
	local class = weapon:GetClass()

	if (IsValid(weapon)) then
		if (class != curShield[1]) then
			for k, v in ipairs(btShield.dualWield) do
				if (class == v) then
					return
				end
			end
		else
			return
		end
	end

	return !btShield.shieldList[class] and false
end)

if (CLIENT) then
	surface.CreateFont( "DisplayShield", {
		font = "Consolas",
		size = ScreenScale(12),
		extended = true,
		weight = 1000
	})

	surface.CreateFont( "DisplayShield2", {
		font = "Consolas",
		size = ScreenScale(10),
		extended = true,
		weight = 100
	})

	btShield.clModels = btShield.clModels or {}

	btShield:addHook("Think", function()
		if (btShield.clModels) then
			for idx, entity in pairs(btShield.clModels) do
				if (!IsValid(entity)) then
					if (!IsValid(entity.ownerEntity)) then
						entity:Remove()
					end

					btShield.clModels[idx] = nil
				end
			end
		end
	end)

	btShield:addHook("HUDPaint", function()
		local w, h = ScrW(), ScrH()
		local client = LocalPlayer()

		if (IsValid(client) and client:hasBallisticShield()) then
			local curShield, weapon = client:getCurrentShield()
			local info = btShield.shieldInfo[curShield]

			if (IsValid(weapon)) then
				draw.TextShadow({
					text = "Здоровье щита",
					font = "font_base",
					pos = {w/2, h/5 * 4},
					xalign = 1,
					yalign = 1,
					color = color_white
				}, 2, 255)

				draw.TextShadow({
					text = weapon:GetDTInt(0, info.game.health),
					font = "font_base_22",
					pos = {w/2, h/5 * 4 + ScreenScale(10)},
					xalign = 1,
					yalign = 1,
					color = color_white
				}, 2, 255)
			end
		end
	end)

	btShield:addHook("DrawShield", function(client)
		-- ONLY_FOR_DEVELOPERS = (RealTime() % 1 < 0.5)
		if (IsValid(client) and client:hasBallisticShield()) then
			local curShield, weapon = client:getCurrentShield()
			if (!IsValid(weapon)) then return end

            if not LocalPlayer():ShouldDrawLocalPlayer() and client == LocalPlayer() then
                return
            end

			if (curShield and weapon:GetDTBool(0, false) != true) then
					local sInfo = btShield.shieldInfo[curShield]

                    local ang_r, ang_b = sInfo.render.ang, sInfo.block.ang
                    local pos_r, pos_b = sInfo.render.pos, sInfo.block.pos
                    local bone = sInfo.bone

                    if table.KeyFromValue( btShield.dualWield, client:GetActiveWeapon():GetClass() ) ~= nil then
                        bone = 'ValveBiped.Bip01_Spine2'
                        ang_r = Angle(90,-90,-180)
                        pos_r = Vector(3,-45,-8)

                        ang_b = Angle(90,0,90)
                        pos_b = Angle(0,0,10)
                    end

					if (sInfo) then
						if (!IsValid(client.btShieldModel)) then
							client.btShieldModel = ClientsideModel(sInfo.model)
							client.btShieldModel:SetNoDraw(true)
							client.btShieldModel.ownerEntity = client
							table.insert(btShield.clModels, client.btShieldModel)
						else
							if (client.btShieldModel:GetModel() != sInfo.model) then
								client.btShieldModel:SetModel(sInfo.model)
							end

							local pos, ang = client:GetBonePosition(client:LookupBone(bone) or 1)
							if (!pos or !ang) then return end

							local tempAng = Angle(ang)
								ang:RotateAroundAxis(tempAng:Forward(), ang_r[1])
								ang:RotateAroundAxis(tempAng:Up(), ang_r[2])
								ang:RotateAroundAxis(tempAng:Right(), ang_r[3])
								pos = pos
								+ tempAng:Up() * pos_r[1]
								+ tempAng:Forward() * pos_r[2]
								+ tempAng:Right() * pos_r[3]
							tempAng = nil

							local weapon = client:GetActiveWeapon()
							if (!IsValid(weapon)) then return end

							if (LocalPlayer() == client and !client:ShouldDrawLocalPlayer() and btShield.shieldList[weapon:GetClass()] == curShield) then
								pos, ang = client:GetShootPos(), client:EyeAngles()

								local vel = client:GetVelocity():Length2D()
								local swayMeter = math.min(1, vel/client:GetWalkSpeed())

								local tempAng = Angle(ang)
									ang:RotateAroundAxis(tempAng:Forward(), sInfo.render.fang[1])
									ang:RotateAroundAxis(tempAng:Up(), sInfo.render.fang[2])
									ang:RotateAroundAxis(tempAng:Right(), sInfo.render.fang[3])

									pos = pos
									+ tempAng:Up() * sInfo.render.fpos[1] + tempAng:Up() * (math.sin(RealTime()*10) * .5 ) * swayMeter
									+ tempAng:Forward() * sInfo.render.fpos[2] + tempAng:Right() * (math.cos(RealTime()*5) * .5) * swayMeter
									+ tempAng:Right() * sInfo.render.fpos[3]
								tempAng = nil

								client.btShieldModel:SetRenderOrigin(pos)
								client.btShieldModel:SetRenderAngles(ang)
							else
								client.btShieldModel:SetRenderOrigin(pos)
								client.btShieldModel:SetRenderAngles(ang)
							end

							if (!client:GetNoDraw()) then
								client.btShieldModel:DrawModel()
							end

							btShield.blocker[client:EntIndex()] = client

							-- if LocalPlayer():IsUserGroup('founder') then
                            --     -- print(table.KeyFromValue( btShield.dualWield, weapon:GetClass() ) ~= nil)

                            --     -- print(client, weapon:GetClass(), table.GetKeys(btShield.shieldList)[weapon:GetClass()]  )
                            --     -- local bone = sInfo.bone
                            --     -- local pos2, ang2 = sInfo.block.pos, sInfo.block.ang

							-- 	local pos, ang = client:GetBonePosition(client:LookupBone(bone) or 1)
							-- 	local tempAng = Angle(ang)
							-- 		ang:RotateAroundAxis(tempAng:Forward(), ang_b[1])
							-- 		ang:RotateAroundAxis(tempAng:Up(), ang_b[2])
							-- 		ang:RotateAroundAxis(tempAng:Right(), ang_b[3])
							-- 		pos = pos
							-- 		+ tempAng:Up() * pos_b[1]
							-- 		+ tempAng:Forward() * pos_b[2]
							-- 		+ tempAng:Right() * pos_b[3]
							-- 	tempAng = nil
							-- 	cam.Start3D2D(pos, ang, 1)
							-- 		draw.RoundedBox(0, -sInfo.block.sizex/2, -sInfo.block.sizey/2, sInfo.block.sizex, sInfo.block.sizey, Color(255,255,255,10))
							-- 	cam.End3D2D()

							-- 	surface.SetDrawColor(255, 255, 255)
							-- 	render.DrawLine(pos, pos + ang:Forward() * 10, Color(255, 0, 0))
							-- 	render.DrawLine(pos, pos + ang:Right() * 10, Color(0, 255, 0))
							-- 	render.DrawLine(pos, pos + ang:Up() * 20, Color(0, 0, 255))
							-- end
						end
					end
			end
		end
	end)

	btShield:addHook("PreDrawTranslucentRenderables", function()
		local client = LocalPlayer()

		hook.Run("DrawShield", client)
	end)

	btShield:addHook("PostPlayerDraw", function(client)
		hook.Run("DrawShield", client)
	end)
end



btShield:addHook("EntityFireBullets", function(entity, bulletTable, attacker)
	local origin, direction
	origin = bulletTable.Src
	direction = bulletTable.Dir

	local vrej = hook.Run("EntityFireBulletCompatability", entity, bulletTable, attacker)
    -- print(entity)
    -- if entity == bulletTable.Attacker then return end

	if (btShield.blocker) then
		if (!IsFirstTimePredicted()) then return end

		for _, client in pairs(btShield.blocker) do
			if (client:hasBallisticShield() != true) then continue end
			local curShield, weapon = client:getCurrentShield()
			if (!IsValid(weapon)) then continue end
			if (weapon:GetDTBool(0) == true) then continue end
            if client ~= bulletTable.Attacker then
                -- print(client, bulletTable)
                -- PrintTable(bulletTable)

                local sInfo = btShield.shieldInfo[curShield]
                if (!sInfo) then continue end

                local ang_r, ang_b = sInfo.render.ang, sInfo.block.ang
                local pos_r, pos_b = sInfo.render.pos, sInfo.block.pos
                local bone = sInfo.bone

                if IsValid(client) and IsValid(client:GetActiveWeapon()) and table.KeyFromValue( btShield.dualWield, client:GetActiveWeapon():GetClass() ) ~= nil then
                    bone = 'ValveBiped.Bip01_Spine2'
                    ang_r = Angle(90,-90,0)
                    pos_r = Vector(0,40,0)

                    ang_b = Angle(90,0,90)
                    pos_b = Angle(0,0,10)
                end

                local pos, ang = client:GetBonePosition(client:LookupBone(bone) or 1)
                if (!pos or !ang) then continue end


                local tempAng = Angle(ang)
                    ang:RotateAroundAxis(tempAng:Forward(), ang_b[1])
                    ang:RotateAroundAxis(tempAng:Up(), ang_b[2])
                    ang:RotateAroundAxis(tempAng:Right(), ang_b[3])
                    pos = pos
                    + tempAng:Up() * pos_b[1]
                    + tempAng:Forward() * pos_b[2]
                    + tempAng:Right() * pos_b[3]
                tempAng = nil

                local f, r, u = ang:Up(), ang:Forward(), ang:Right()
                local a, b = pos, -f
                local w, h = sInfo.block.sizex, sInfo.block.sizey

                local hitPos = util.IntersectRayWithPlane(origin, direction, a, b)
                if (hitPos) then
                    local dd, du = r, u
                    b = b:Angle()
                    -- Declare the plane.
                    local plane = a
                    + u * h/2
                    + r * -w/2

                    local x = r * w
                    local y = u * -h
                    local tx, ty = rayQuadIntersect(origin, direction, plane, x, y)

                    if (tx and ty) then
                        hook.Run("OnBlockBullet", client, sInfo, hitPos, bulletTable)

                        if (vrej) then
                            return false
                        end

                        local dist = hitPos:Distance(origin)
                        bulletTable.Distance = dist * 0.9
                        bulletTable.Damage = 0
                        bulletTable.Callback = nil

                        return true
                    end
                end
            end
		end
	end

	return vrej
end)

btShield:addHook("OnBlockBullet", function(client, info, hitPos, bulletTable)
	local curShield, weapon = client:getCurrentShield()

	if (SERVER) then
		if (!SUPRESS_SHIELD_DAMAGE) then
			weapon:SetDTInt(0,  math.max(0, weapon:GetDTInt(0, info.game.health) - (bulletTable.Damage == 0 and 5 or bulletTable.Damage)))
		end
	end

	if (weapon:GetDTBool(0) != true and weapon:GetDTInt(0, info.game.health) <= 0) then
		weapon.nextHeal = weapon.nextHeal or CurTime()
		weapon.nextHeal = CurTime() + info.game.brokenRegenDelay
		weapon:SetDTBool(0, true)

		local effectdata = EffectData()
			effectdata:SetOrigin( hitPos )
			effectdata:SetNormal( -bulletTable.Dir )
			effectdata:SetMagnitude(1 )
			effectdata:SetScale( 1)
			effectdata:SetRadius( 1 )
		util.Effect( "cball_explode", effectdata )
	else
		weapon.nextHeal = weapon.nextHeal or CurTime()
		weapon.nextHeal = CurTime() + info.game.regenDelay
	end

	local effectdata = EffectData()
		effectdata:SetOrigin( hitPos )
		effectdata:SetNormal( -bulletTable.Dir )
		effectdata:SetMagnitude(1 )
		effectdata:SetScale( 1)
		effectdata:SetRadius( 1 )
	util.Effect( "MetalSpark", effectdata )

	weapon:EmitSound(btShield.blockSound[math.random(1, #btShield.blockSound)])
end)


-- /*
-- 	Vrej SNPC COMPATABILITY ADDITION
-- */
-- timer.Simple(1, function()
-- 	if (VJ) then
-- 		local function VJ_NPC_FIREBULLET(Entity,data,Attacker)
-- 			if IsValid(Entity) && !Entity:IsPlayer() && Entity.IsVJBaseSNPC == true && Entity:GetActiveWeapon() != NULL && Entity:VJ_GetEnemy(true) != nil then
-- 				local GetCurrentWeapon = Entity:GetActiveWeapon()
-- 				local EnemyDistance = 100
-- 				if Entity.VJ_IsBeingControlled == true then
-- 				EnemyDistance = Entity:GetPos():Distance(Entity.VJ_TheController:GetEyeTrace().HitPos) else
-- 				EnemyDistance = Entity:GetPos():Distance(Entity:GetEnemy():GetPos()) end

-- 				if Entity.VJ_IsBeingControlled == false then
-- 					data.Src = util.VJ_GetWeaponPos(Entity)
-- 				elseif Entity.VJ_IsBeingControlled == true && IsValid(Entity.VJ_TheController) then
-- 					data.Src = Entity.VJ_TheController:GetShootPos()
-- 				end

-- 				if Entity.VJ_IsBeingControlled == false then
-- 					local fSpread = ((EnemyDistance/23)*Entity.WeaponSpread)
-- 					if GetCurrentWeapon.IsVJBaseWeapon == true && GetCurrentWeapon.NPC_AllowCustomSpread == true then fSpread = fSpread *GetCurrentWeapon.NPC_CustomSpread end
-- 					fSpread = math.Clamp(fSpread,1,65)
-- 					data.Spread = Vector(fSpread,fSpread,0)
-- 				elseif Entity.VJ_IsBeingControlled == true && IsValid(Entity.VJ_TheController) then
-- 				end
-- 				if Entity.VJ_IsBeingControlled == false then
-- 					if Entity.WeaponUseEnemyEyePos == true then
-- 						data.Dir = (Entity:GetEnemy():EyePos()+Entity:GetEnemy():GetUp()*-5)-data.Src
-- 					else
-- 						data.Dir = (Entity:GetEnemy():GetPos()+Entity:GetEnemy():OBBCenter())-data.Src
-- 					end
-- 					Entity.WeaponUseEnemyEyePos = false
-- 				elseif Entity.VJ_IsBeingControlled == true && IsValid(Entity.VJ_TheController) then
-- 					data.Dir = Entity.VJ_TheController:GetAimVector()
-- 				end
-- 				Entity.Weapon_ShotsSinceLastReload = Entity.Weapon_ShotsSinceLastReload + 1

-- 				return true
-- 			end
-- 		end

-- 		hook.Add("EntityFireBullets","VJ_NPC_FIREBULLET", function() end)
-- 		hook.Add("EntityFireBulletCompatability","VJ_NPC_FIREBULLET", VJ_NPC_FIREBULLET)
-- 	end
-- end)

-- /*
-- 	TFA WEAPON PACK
-- 	SV EDITION COMPATABILITY ADDITION
-- 	https://steamcommunity.com/sharedfiles/filedetails/?id=831344258&searchtext=
-- */

-- local TracerName
-- local cv_forcemult = GetConVar("sv_tfa_force_multiplier")
-- local bullet = {}
-- bullet.Spread = Vector()

-- function TFABulletCompatability(self, damage, recoil, num_bullets, aimcone, disablericochet, bulletoverride)

-- 	if not IsFirstTimePredicted() and not game.SinglePlayer() then return end
-- 	num_bullets = num_bullets or 1
-- 	aimcone = aimcone or 0

-- 	if self.ProjectileEntity then
-- 		if SERVER then

-- 			for i = 1, num_bullets do
-- 				local ent = ents.Create(self.ProjectileEntity)
-- 				local dir
-- 				local ang = self.Owner:EyeAngles()
-- 				ang:RotateAroundAxis(ang:Right(), -aimcone / 2 + math.Rand(0, aimcone))
-- 				ang:RotateAroundAxis(ang:Up(), -aimcone / 2 + math.Rand(0, aimcone))
-- 				dir = ang:Forward()
-- 				ent:SetPos(self.Owner:GetShootPos())
-- 				ent.Owner = self.Owner
-- 				ent:SetAngles(self.Owner:EyeAngles())
-- 				ent.damage = self.Primary.Damage
-- 				ent.mydamage = self.Primary.Damage

-- 				if self.ProjectileModel then
-- 					ent:SetModel(self.ProjectileModel)
-- 				end

-- 				ent:Spawn()
-- 				ent:SetVelocity(dir * self.ProjectileVelocity)
-- 				local phys = ent:GetPhysicsObject()

-- 				if IsValid(phys) then
-- 					phys:SetVelocity(dir * self.ProjectileVelocity)
-- 				end

-- 				if self.ProjectileModel then
-- 					ent:SetModel(self.ProjectileModel)
-- 				end

-- 				ent:SetOwner(self.Owner)
-- 				ent.Owner = self.Owner
-- 			end
-- 		end
-- 		-- Source
-- 		-- Dir of bullet
-- 		-- Aim Cone X
-- 		-- Aim Cone Y
-- 		-- Show a tracer on every x bullets
-- 		-- Amount of force to give to phys objects
-- 	else
-- 		if self.Tracer == 1 then
-- 			TracerName = "Ar2Tracer"
-- 		elseif self.Tracer == 2 then
-- 			TracerName = "AirboatGunHeavyTracer"
-- 		else
-- 			TracerName = "Tracer"
-- 		end

-- 		if self.TracerName and self.TracerName ~= "" then
-- 			TracerName = self.TracerName
-- 		end


-- 		bullet.Attacker = self.Owner
-- 		bullet.Inflictor = self
-- 		bullet.Src = self.Owner:GetShootPos()
-- 		bullet.HullSize = self.Primary.HullSize or 0
-- 		bullet.Spread = Vector()
-- 		bullet.Tracer = self.TracerCount and self.TracerCount or 3
-- 		bullet.TracerName = TracerName
-- 		bullet.PenetrationCount = 0
-- 		bullet.AmmoType = self:GetPrimaryAmmoType()
-- 		bullet.Force = damage / 6 * math.sqrt(self.Primary.KickUp + self.Primary.KickDown + self.Primary.KickHorizontal) * cv_forcemult:GetFloat() * self:GetAmmoForceMultiplier()
-- 		bullet.Damage = damage
-- 		bullet.HasAppliedRange = false

-- 		if self.CustomBulletCallback then
-- 			bullet.Callback2 = self.CustomBulletCallback
-- 		end

-- 		bullet.Callback = function(a, b, c)
-- 			if IsValid(self) then
-- 				if bullet.Callback2 then
-- 					bullet.Callback2(a, b, c)
-- 				end

-- 				bullet:Penetrate(a, b, c, self)
-- 			end
-- 		end

-- 		for i = 1, num_bullets do
-- 			local dir = (self.Owner:EyeAngles() + self.Owner:GetViewPunchAngles() + Angle(math.Rand(-aimcone, aimcone), math.Rand(-aimcone, aimcone), 0) * 25):Forward()
-- 			bullet.Dir = dir
-- 			self.Owner:FireBullets(bullet)
-- 		end
-- 	end
-- end

-- local decalbul = {
-- 	Num = 1,
-- 	Spread = vector_origin,
-- 	Tracer = 0,
-- 	Force = 0.5,
-- 	Damage = 0.1
-- }

-- local maxpen
-- local penetration_max_cvar
-- local penetration_cvar
-- local ricochet_cvar
-- local cv_rangemod
-- local cv_decalbul
-- local rngfac
-- local mfac

-- function bullet:Penetrate(ply, traceres, dmginfo, weapon)
-- 	if not IsValid(weapon) then return end
-- 	local hitent = traceres.Entity

-- 	if not self.HasAppliedRange then
-- 		local bulletdistance = (traceres.HitPos - traceres.StartPos):Length()
-- 		local damagescale = bulletdistance / weapon.Primary.Range
-- 		damagescale = math.Clamp(damagescale - weapon.Primary.RangeFalloff, 0, 1)
-- 		damagescale = math.Clamp(damagescale / math.max(1 - weapon.Primary.RangeFalloff, 0.01), 0, 1)
-- 		damagescale = (1 - cv_rangemod:GetFloat() ) + (math.Clamp(1 - damagescale, 0, 1) * cv_rangemod:GetFloat() )
-- 		dmginfo:ScaleDamage(damagescale)
-- 		self.HasAppliedRange = true
-- 	end

-- 	dmginfo:SetDamageType(weapon.Primary.DamageType)

-- 	if SERVER and IsValid(ply) and ply:IsPlayer() and IsValid(hitent) and (hitent:IsPlayer() or hitent:IsNPC()) then
-- 		net.Start("tfaHitmarker")
-- 		net.Send(ply)
-- 	end

-- 	if weapon.Primary.DamageType ~= DMG_BULLET then
-- 		if ( dmginfo:IsDamageType(DMG_SHOCK) or dmginfo:IsDamageType(DMG_BLAST) ) and traceres.Hit and IsValid(hitent) and hitent:GetClass() == "npc_strider" then
-- 			hitent:SetHealth(math.max(hitent:Health() - dmginfo:GetDamage(), 2))

-- 			if hitent:Health() <= 3 then
-- 				hitent:Extinguish()
-- 				hitent:Fire("sethealth", "-1", 0.01)
-- 				dmginfo:ScaleDamage(0)
-- 			end
-- 		end

-- 		if dmginfo:IsDamageType(DMG_BURN) and traceres.Hit and IsValid(hitent) and not traceres.HitWorld and not traceres.HitSky and dmginfo:GetDamage() > 1 and hitent.Ignite then
-- 			hitent:Ignite(dmginfo:GetDamage() / 2, 1)
-- 		end

-- 		if dmginfo:IsDamageType(DMG_BLAST) and traceres.Hit and not traceres.HitSky then
-- 			local tmpdmg = dmginfo:GetDamage()
-- 			util.BlastDamage(weapon, weapon.Owner, traceres.HitPos, tmpdmg / 2, tmpdmg)
-- 			local fx = EffectData()
-- 			fx:SetOrigin(traceres.HitPos)
-- 			fx:SetNormal(traceres.HitNormal)

-- 			if tmpdmg > 90 then
-- 				util.Effect("Explosion", fx)
-- 			elseif tmpdmg > 45 then
-- 				util.Effect("cball_explode", fx)
-- 			else
-- 				util.Effect("ManhackSparks", fx)
-- 			end

-- 			dmginfo:ScaleDamage(0.15)
-- 		end
-- 	end

-- 	if penetration_cvar and not penetration_cvar:GetBool() then return end
-- 	-- if self:Ricochet(ply, traceres, dmginfo, weapon) then return end
-- 	maxpen = math.min(penetration_max_cvar and ( penetration_max_cvar:GetInt() - 1 ) or 1, weapon.Primary.MaxPenetration)
-- 	if self.PenetrationCount > maxpen then return end
-- 	local mult = weapon:GetPenetrationMultiplier(traceres.MatType)
-- 	penetrationoffset = traceres.Normal * math.Clamp(self.Force * mult, 0, 32)
-- 	local pentrace = {}
-- 	pentrace.endpos = traceres.HitPos
-- 	pentrace.start = traceres.HitPos + penetrationoffset
-- 	pentrace.mask = MASK_SHOT
-- 	pentrace.filter = {}
-- 	pentraceres = util.TraceLine(pentrace)
-- 	if (pentraceres.StartSolid or pentraceres.Fraction >= 1.0 or pentraceres.Fraction <= 0.0) then return end
-- 	self.Src = pentraceres.HitPos

-- 	if (self.Num or 0) <= 1 then
-- 		self.Spread = Vector(0, 0, 0)
-- 	end

-- 	self.Tracer = 0 --weapon.TracerName and 0 or 1
-- 	self.TracerName = ""
-- 	rngfac = math.pow(pentraceres.HitPos:Distance(traceres.HitPos) / penetrationoffset:Length(), 2)
-- 	mfac = math.pow(mult / 10, 0.35)
-- 	self.Force = Lerp(rngfac, self.Force, self.Force * mfac)
-- 	self.Damage = Lerp(rngfac, self.Damage, self.Damage * mfac)
-- 	self.Spread = self.Spread / math.sqrt(mfac)
-- 	self.PenetrationCount = self.PenetrationCount + 1
-- 	self.HullSize = 0
-- 	decalbul.Dir = -traceres.Normal * 64

-- 	if IsValid(ply) and ply:IsPlayer() then
-- 		decalbul.Dir = self.Attacker:EyeAngles():Forward() * (-64)
-- 	end

-- 	decalbul.Src = pentraceres.HitPos - decalbul.Dir * 4
-- 	decalbul.Damage = 0.1
-- 	decalbul.Force = 0.1
-- 	decalbul.Tracer = 0
-- 	decalbul.TracerName = ""
-- 	decalbul.Callback = DirectDamage
-- 	local fx = EffectData()
-- 	fx:SetOrigin(self.Src)
-- 	fx:SetNormal(self.Dir + VectorRand() * self.Spread)
-- 	fx:SetMagnitude(1)
-- 	fx:SetEntity(weapon)
-- 	util.Effect("tfa_penetrate", fx)

-- 	if IsValid(ply) then
-- 		if ply:IsPlayer() then
-- 			self.Dir = self.Attacker:EyeAngles():Forward()
-- 		end

-- 		timer.Simple(0, function()
-- 			if IsValid(ply) then
-- 				if cv_decalbul:GetBool() then
-- 					ply:FireBullets(decalbul)
-- 				end
-- 				ply:FireBullets(self)
-- 			end
-- 		end)
-- 	end
-- end

-- function bullet:Ricochet(ply, traceres, dmginfo, weapon)
-- 	-- if ricochet_cvar and not ricochet_cvar:GetBool() then return end
-- 	-- maxpen = math.min(penetration_max_cvar and penetration_max_cvar:GetInt() - 1 or 1, weapon.Primary.MaxPenetration)
-- 	-- if self.PenetrationCount > maxpen then return end
-- 	-- --[[
-- 	-- ]]
-- 	-- --
-- 	-- local matname = weapon:GetMaterialConcise(traceres.MatType)
-- 	-- local ricochetchance = 1
-- 	-- local dir = traceres.HitPos - traceres.StartPos
-- 	-- dir:Normalize()
-- 	-- local dp = dir:Dot(traceres.HitNormal * -1)

-- 	-- if matname == "glass" then
-- 	-- 	ricochetchance = 0
-- 	-- elseif matname == "plastic" then
-- 	-- 	ricochetchance = 0.01
-- 	-- elseif matname == "dirt" then
-- 	-- 	ricochetchance = 0.01
-- 	-- elseif matname == "grass" then
-- 	-- 	ricochetchance = 0.01
-- 	-- elseif matname == "sand" then
-- 	-- 	ricochetchance = 0.01
-- 	-- elseif matname == "ceramic" then
-- 	-- 	ricochetchance = 0.15
-- 	-- elseif matname == "metal" then
-- 	-- 	ricochetchance = 0.7
-- 	-- elseif matname == "default" then
-- 	-- 	ricochetchance = 0.5
-- 	-- else
-- 	-- 	ricochetchance = 0
-- 	-- end

-- 	-- ricochetchance = ricochetchance * 0.5 * weapon:GetAmmoRicochetMultiplier()
-- 	-- local riccbak = ricochetchance / 0.7
-- 	-- local ricothreshold = 0.6
-- 	-- ricochetchance = math.Clamp(ricochetchance + ricochetchance * math.Clamp(1 - (dp + ricothreshold), 0, 1) * 0.5, 0, 1)

-- 	-- if dp <= ricothreshold and math.Rand(0, 1) < ricochetchance then
-- 	-- 	self.Damage = self.Damage * 0.5
-- 	-- 	self.Force = self.Force * 0.5
-- 	-- 	self.Num = 1
-- 	-- 	self.Spread = vector_origin
-- 	-- 	self.Src = traceres.HitPos
-- 	-- 	self.Dir = ((2 * traceres.HitNormal * dp) + traceres.Normal) + (VectorRand() * 0.02)
-- 	-- 	self.Tracer = 0

-- 	-- 	if TFA.GetRicochetEnabled() then
-- 	-- 		local fx = EffectData()
-- 	-- 		fx:SetOrigin(self.Src)
-- 	-- 		fx:SetNormal(self.Dir)
-- 	-- 		fx:SetMagnitude(riccbak)
-- 	-- 		util.Effect("tfa_ricochet", fx)
-- 	-- 	end

-- 	-- 	timer.Simple(0, function()
-- 	-- 		if IsValid(ply) then
-- 	-- 			ply:FireBullets(self)
-- 	-- 		end
-- 	-- 	end)

-- 	-- 	self.PenetrationCount = self.PenetrationCount + 1

-- 	-- 	return true
-- 	-- end
--     return false
-- end

-- btShield:addHook("PostGamemodeLoaded", function()
-- 	local weaponList = weapons.GetStored("tfa_gun_base")
-- 	if (weaponList) then
-- 		weaponList.ShootBullet = TFABulletCompatability
-- 		cv_forcemult = GetConVar("sv_tfa_force_multiplier")
-- 		penetration_max_cvar = GetConVar("sv_tfa_penetration_limit")
-- 		penetration_cvar = GetConVar("sv_tfa_bullet_penetration")
-- 		-- ricochet_cvar = GetConVar("sv_tfa_bullet_ricochet")
-- 		cv_rangemod = GetConVar("sv_tfa_range_modifier")
-- 		cv_decalbul = GetConVar("sv_tfa_fx_penetration_decal")
-- 	end
-- end)



