AddCSLuaFile("cl_init.lua")
AddCSLuaFile("shared.lua")
include("shared.lua")

util.AddNetworkString(ControllableManhack.manhackEntityClassName .. ".ClientStartControlling")
util.AddNetworkString(ControllableManhack.manhackEntityClassName .. ".ClientStopControlling")
util.AddNetworkString(ControllableManhack.manhackEntityClassName .. ".ClientDestroyed")
util.AddNetworkString(ControllableManhack.manhackEntityClassName .. ".ClientSelfDestructing")
util.AddNetworkString(ControllableManhack.manhackEntityClassName .. ".ClientManhackDeath")

function ENT:Initialize()
    self:SetModel("models/combine_scanner.mdl")
    self:SetUseType(self.UseType)
    self:PhysicsInit(SOLID_VPHYSICS)
	self:SetMoveType(MOVETYPE_VPHYSICS)
	self:SetSolid(SOLID_VPHYSICS)
    self:PrecacheGibs()

    local phys = self:GetPhysicsObject()

    if IsValid(phys) then
        phys:Wake()
        phys:EnableGravity(false)
    end

    self.yawOffset = 0
    self.panelPoseValue = 0
    self.isCharging = false
    self.isSelfDestructing = false
    self.rebelHate = ControllableManhack.ConVarHateRebel()
    self.combineHate = ControllableManhack.ConVarHateCombine()
    self.shadowControl = {
        pos = self:GetPos(),
        angle = self:GetAngles(),
        secondstoarrive = 0.1,
        maxangular = 1000000,
        maxangulardamp = 1000000,
        maxspeed = 0,
        maxspeeddamp = 0,
        dampfactor = 1,
        teleportdistance = 0
    }

    local health = ControllableManhack.ConVarHealth()

    self:StartMotionController()
    self:SetMaxHealth(health)
    self:SetHealth(health)
    self:AddFlags(FL_OBJECT)
    self:SetupEntityRelationships()
    self:DoDeploySequence()
end

function ENT:Use(activator, caller)
    if ControllableManhack.ConVarRetrieveAllowed() then
        if IsValid(caller) and caller:IsPlayer() then
            local playerController = self:GetPlayerController()

            if IsValid(playerController) and playerController == caller and not self:GetControlActive() then
                self:EmitSound(self.SoundRetire)
                SafeRemoveEntity(self)

                if not ControllableManhack.ConVarAmmoInfinite() and ControllableManhack.ConVarAmmoRetrieve() then
                    caller:GiveAmmo(1, ControllableManhack.manhackAmmoName)
                end
            end
        end
    end
end

function ENT:Think()
    if self.soundEngine1 then
        self.soundEngine1:ChangePitch(self.PitchStart + math.min(self:GetVelocity():Length() * self.PitchMultiplier, self.MaxPitchAdd))
    end

    if self.isCharging and self.panelPoseValue ~= 90 then
        self.panelPoseValue = 90
    elseif not self.isCharging and self.panelPoseValue ~= 0 then
        self.panelPoseValue = 0
    end

    if self:GetPoseParameter("Panel1") ~= self.panelPoseValue then
        self:SetPanelPoseParameter(self.panelPoseValue)
    end

    local playerController = self:GetPlayerController()

    if IsValid(playerController) and self:GetControlActive() and playerController:GetMoveType() ~= MOVETYPE_NOCLIP and not ControllableManhack.IsPlayerGrounded(playerController) then
        self:EmitSound(self.SoundActive)
        self:StopControlling()
    end
end

function ENT:UseOtherEntity(ent)
    local playerController = self:GetPlayerController()

    if ent.Use and IsValid(playerController) then
        ent:Use(playerController, self, USE_ON, 0)
    else
        ent:Fire("use", "1", 0)
    end
end

function ENT:PhysicsCollide(collisionData, physicsObject)
    --These two are different for some reason so I just use the lowest one
    local speed = math.min(collisionData.Speed, collisionData.OurOldVelocity:Length())

    --Deal damage to self if hit hard enough
    if speed >= self.SelfCollideDamageRequiredSpeed then
        local damageInfo = DamageInfo()
        damageInfo:SetDamage(math.max((speed - self.SelfCollideDamageRequiredSpeed) * self.SelfCollideDamageMultiplier), 0)
        damageInfo:SetAttacker(self)
        damageInfo:SetInflictor(self)
        damageInfo:SetReportedPosition(collisionData.HitPos)
        damageInfo:SetDamagePosition(collisionData.HitPos)
        damageInfo:SetDamageForce(self:GetVelocity())
        damageInfo:SetDamageType(DMG_CRUSH)
        self:TakeDamageInfo(damageInfo)
    end

    --If blades collided
    if math.abs(self:GetUp():Dot(collisionData.HitNormal)) < self.CollideLessThanDot then
        local playerController = self:GetPlayerController()

        if self:GetSequence() ~= self:LookupSequence(self.SequenceDeploy) then
            --Bounce back
            physicsObject:ApplyForceCenter(-collisionData.HitNormal * self.SelfCollideForce)

            if IsValid(collisionData.HitEntity) then
                local physicsObject = collisionData.HitEntity:GetPhysicsObject()
                local collideForce = math.random(self.CollideForce.Min, self.CollideForce.Max)

                if IsValid(physicsObject) then
                    --Apply force to entity that was hit
                    physicsObject:ApplyForceOffset((collisionData.HitPos - self:GetPos()):GetNormalized() * collideForce, collisionData.HitPos)
                end

                --Deal damage to entity that was hit

                local damageAmount = self.isCharging and math.random(self.CollideChargeDamage.Min, self.CollideChargeDamage.Max) or math.random(self.CollideDamage.Min, self.CollideDamage.Max)

                --Deal less damage when incapacitated
                if self.isIncapacitated then
                    damageAmount = damageAmount * self.IncapacitatedDamageMultiplier
                end

                damageAmount = math.Round(damageAmount)

                local damageInfo = DamageInfo()
            	damageInfo:SetDamage(damageAmount)
            	damageInfo:SetAttacker(IsValid(playerController) and playerController or self)
            	damageInfo:SetInflictor(self)
                damageInfo:SetReportedPosition(collisionData.HitPos)
                damageInfo:SetDamagePosition(collisionData.HitPos)
                damageInfo:SetDamageForce(collisionData.HitNormal * collideForce)
            	damageInfo:SetDamageType(DMG_SLASH)
            	collisionData.HitEntity:TakeDamageInfo(damageInfo)

                --Make npcs angery when hit

                if collisionData.HitEntity.AddEntityRelationship and collisionData.HitEntity.Disposition then
                    --Used to get default relationships
                    local tempManhack = ents.Create("npc_cscanner")
                    local relationship = collisionData.HitEntity:Disposition(tempManhack)

                    --If attacked a rebel
                    if (relationship == D_HT or relationship == D_FR) and not self.rebelHate then
                        self.rebelHate = true

                        self:SetupEntityRelationships()
                    --If attacked a combine
                    elseif (relationship == D_LI or relationship == D_NU) and not self.combineHate then
                        self.combineHate = true

                        self:SetupEntityRelationships()
                    end

                    SafeRemoveEntity(tempManhack)
                end
            end

            --Effects
            if IsValid(collisionData.HitEntity) then
                local model = collisionData.HitEntity:GetModel()

                if model and self.CollideBloodTypes[ControllableManhack.UtilGetSurfaceProperty(model)] then
                    self:MakeBlood(collisionData.HitPos)
                else
                    self:MakeSparks(collisionData.HitPos, -collisionData.HitNormal)
                end
            else
                self:MakeSparks(collisionData.HitPos, -collisionData.HitNormal)
            end

            --Use entities that was hit
            if ControllableManhack.ConVarCollideUse() and IsValid(playerController) and self:GetControlActive() then
                local entsToUse = {
                    [collisionData.HitEntity] = true
                }

                for entIndex, ent in pairs(ents.FindInSphere(collisionData.HitPos, self.CollideUseRadius)) do
                    entsToUse[ent] = true
                end

                entsToUse[self] = false

                for entToUse, shouldUse in pairs(entsToUse) do
                    if shouldUse and IsValid(entToUse) and not entToUse:IsVehicle() and not entToUse:IsNPC() then
                        if ControllableManhack.ConVarCollideUseWhitelist() then
                            for compareIndex, Compare in pairs(self.CollideUseWhiteListFunctions) do
                                if Compare(self, entToUse) then
                                    self:UseOtherEntity(entToUse)

                                    break
                                end
                            end
                        else
                            self:UseOtherEntity(entToUse)
                        end
                    end
                end
            end

            self:Incapacitate()
        end
    end
end

function ENT:PhysicsUpdate(physicsObject)
    local playerController = self:GetPlayerController()

    if IsValid(playerController) and self:GetControlActive() then
        local direction = Vector(0, 0, 0)
        local angle = playerController:EyeAngles()
        angle.y = angle.y + self.yawOffset

        if playerController:KeyDown(IN_BACK) then
            direction = direction - angle:Forward()
        end

        if playerController:KeyDown(IN_FORWARD) then
            direction = direction + angle:Forward()
        end

        if playerController:KeyDown(IN_MOVELEFT) then
            direction = direction - angle:Right()
        end

        if playerController:KeyDown(IN_MOVERIGHT) then
            direction = direction + angle:Right()
        end

        if playerController:KeyDown(IN_DUCK) then
            direction = direction + Vector(0, 0, -1)
        end

        if playerController:KeyDown(IN_JUMP) then
            direction = direction + Vector(0, 0, 1)
        end

        --Clamp the direction so it is not possible to get a speed boost by pressing multiple keys at once
        direction = Vector(
            math.Clamp(direction.x, -1, 1),
            math.Clamp(direction.y, -1, 1),
            math.Clamp(direction.z, -1, 1)
        )

        physicsObject:ApplyForceCenter(direction * (playerController:KeyDown(IN_SPEED) and self.MoveFastForce or self.MoveForce))
    end

    --Brake
    physicsObject:ApplyForceCenter(-self:GetVelocity() * 0.1)
    --Move up and down slightly
    physicsObject:ApplyForceCenter(Vector(0, 0, math.sin(CurTime()) * self.MoveSinForce))

    if self.isSelfDestructing then
        physicsObject:ApplyForceCenter(VectorRand() * self.MoveSelfDestructForce)
    end
end

function ENT:PhysicsSimulate(phys, deltatime)
    local playerController = self:GetPlayerController()

    if IsValid(playerController) and self:GetControlActive() then
        self.shadowControl.pos = self:GetPos()
        self.shadowControl.angle = playerController:EyeAngles()
        self.shadowControl.angle.y = self.shadowControl.angle.y + self.yawOffset
        self.shadowControl.angle.p = math.Clamp(self.shadowControl.angle.p, -self.AnglePitchLimit, self.AnglePitchLimit)
    end

    self.shadowControl.deltatime = deltatime

    phys:Wake()
    phys:ComputeShadowControl(self.shadowControl)
end

function ENT:OnRemove()
    self:StopControlling()

    if self.soundEngine1 then
        self.soundEngine1:Stop()
    end

    if self.soundBlade then
        self.soundBlade:Stop()
    end

    SafeRemoveEntity(self.bullseye)
    SafeRemoveEntity(self.smokeTrail)
end

function ENT:OnTakeDamage(damageInfo)
    local physicsObject = self:GetPhysicsObject()

    if IsValid(physicsObject) then
        physicsObject:ApplyForceCenter(damageInfo:GetDamageForce() * self.SelfTakeDamageForce)
    end

    self:SetHealth(self:Health() - damageInfo:GetDamage())

    if self:Health() <= 0 then
        local attacker = damageInfo:GetAttacker()
        local inflictor = damageInfo:GetInflictor()

        if IsValid(attacker) and IsValid(inflictor) then
            if attacker:IsPlayer() or attacker:IsNPC() then
                local activeWeapon = attacker:GetActiveWeapon()

                if attacker == inflictor and IsValid(activeWeapon) then
                    inflictor = activeWeapon
                end

                if attacker:IsPlayer() then
                    if not IsValid(self.damageInfoPlayer) or (IsValid(self.damageInfoPlayer) and self.damageInfoPlayer ~= attacker) then
                        net.Start("PlayerKilledNPC")
        				net.WriteString(self:GetClass())
        				net.WriteString(inflictor:GetClass())
        				net.WriteEntity(attacker)
                        net.Broadcast()
                    end
                else
                    net.Start("NPCKilledNPC")
                	net.WriteString(self:GetClass())
                	net.WriteString(inflictor:GetClass())
                	net.WriteString(attacker:GetClass())
                    net.Broadcast()
                end
            elseif attacker == self and inflictor == self then
                net.Start("NPCKilledNPC")
                net.WriteString(self:GetClass())
                net.WriteString(self:GetClass())
                net.WriteString(self:GetClass())
                net.Broadcast()
            end
        end

        net.Start(ControllableManhack.manhackEntityClassName .. ".ClientDestroyed")
        net.WriteVector(self:GetPos())
        net.Broadcast()

        self:GibBreakClient(damageInfo:GetDamageForce() * 0.01)
        self:EmitSound(self.SoundDie)

        SafeRemoveEntity(self)
    elseif self:Health() <= 12 then
        self:CreateSmokeTrail()
    end
end

function ENT:UpdateTransmitState()
    return self.TransmitState
end

function ENT:MakeBlood(position)
    local blood = ents.Create("env_blood")
    blood:SetKeyValue("spawnflags", 8)
    blood:SetKeyValue("spraydir", math.random(-500, 500) .. " " .. math.random(-500, 500) .. " " .. math.random(-500, 500))
    blood:SetKeyValue("amount", 250.0)
    blood:SetCollisionGroup(COLLISION_GROUP_WORLD)
    blood:SetPos(position);
    blood:Spawn();
    blood:Fire("EmitBlood");

    self:EmitSound(self.SoundSlice)
end

function ENT:MakeSparks(position, normal)
    local effectData = EffectData()
    effectData:SetOrigin(position)
    effectData:SetNormal(normal)
    util.Effect("ManhackSparks", effectData)

    self:EmitSound(self.SoundGrind)
end

-- function ENT:Charge()
--     if not self.isCharging then
--         self.isCharging = true
--         self:EmitSound(self.SoundChargeStart)

--         timer.Simple(self.ChargeTime, function()
--             if IsValid(self) then
--                 self.isCharging = false
--                 self:EmitSound(self.SoundChargeEnd)
--             end
--         end)
--     end
-- end

function ENT:SetPanelPoseParameter(poseValue)
    self:SetPoseParameter("Panel1", poseValue)
    self:SetPoseParameter("Panel2", poseValue)
    self:SetPoseParameter("Panel3", poseValue)
    self:SetPoseParameter("Panel4", poseValue)
end

--Incapacitate for a short time. Manhack will be unable to do damage while incapacitated. Blades will be visible.
function ENT:Incapacitate()
    self:SetBodygroup(1, 1)

    self.isIncapacitated = true

    timer.Create(self:GetHookIdentifier("Incapacitated"), self.IncapacitatedDelay, 1, function()
        if IsValid(self) then
            self:SetBodygroup(1, 0)

            self.isIncapacitated = false
        end
    end)
end

--Setup relationships for all spawned npcs
function ENT:SetupEntityRelationships()
    --Used to get default relationships
    local tempManhack = ents.Create("npc_cscanner")

    for npcIndex, npc in pairs(ents.FindByClass("npc_*")) do
        if npc.AddEntityRelationship and npc.Disposition then
            local relationship = npc:Disposition(tempManhack)

            --If npc is a rebel
            if relationship == D_HT or relationship == D_FR then
                npc:AddEntityRelationship(self, self.rebelHate and relationship or D_LI, 99)
            --If npc is a combine
            elseif relationship == D_LI or relationship == D_NU then
                npc:AddEntityRelationship(self, self.combineHate and D_HT or relationship, 99)
            end
        end
    end

    SafeRemoveEntity(tempManhack)
end

--Do the deploy sequence
function ENT:DoDeploySequence()
    self.soundEngine1 = CreateSound(self, self.SoundEngine1)
    self.soundBlade = CreateSound(self, self.SoundBlade)

    local sequenceID, sequenceDuration = self:PlaySequence(self.SequenceDeploy)

    timer.Simple(0.4, function()
        if IsValid(self) then
            self:EmitSound(self.SoundUnpack)

            self.soundEngine1:Play()
            self.soundEngine1:ChangeVolume(0, 0)
            self.soundEngine1:ChangeVolume(1, 3)

            if ControllableManhack.ConVarBladeSound() then
                self.soundBlade:Play()
                self.soundBlade:ChangeVolume(0, 0)
                self.soundBlade:ChangeVolume(0.5, 3)
            end
        end
    end)

    timer.Simple(sequenceDuration, function()
        if IsValid(self) then
            self:SetBodygroup(1, 1)
            self:PlaySequence("Fly")
        end
    end)

    timer.Simple(sequenceDuration + 0.5, function()
        if IsValid(self) then
            self:SetBodygroup(1, 0)
            self:SetBodygroup(2, 1)
        end
    end)
end

--Create small smoke that will follow the manhack
function ENT:CreateSmokeTrail()
    if not self.smokeTrail then
        self.smokeTrail = ents.Create("env_smoketrail")
        self.smokeTrail:SetKeyValue("effects", 1)
        self.smokeTrail:SetKeyValue("endsize", 32)
        self.smokeTrail:SetKeyValue("friction", 1)
        self.smokeTrail:SetKeyValue("gravity", 0)
        self.smokeTrail:SetKeyValue("health", 0)
        self.smokeTrail:SetKeyValue("lifetime", 0.5)
        self.smokeTrail:SetKeyValue("ltime", 0)
        self.smokeTrail:SetKeyValue("max_health", 0)
        self.smokeTrail:SetKeyValue("maxdirectedspeed", 0)
        self.smokeTrail:SetKeyValue("maxspeed", 25)
        self.smokeTrail:SetKeyValue("mindirectedspeed", 0)
        self.smokeTrail:SetKeyValue("minspeed", 15)
        self.smokeTrail:SetKeyValue("opacity", 0.5)
        self.smokeTrail:SetKeyValue("renderfx", 0)
        self.smokeTrail:SetKeyValue("rendermode", 0)
        self.smokeTrail:SetKeyValue("shadowcastdist", 0)
        self.smokeTrail:SetKeyValue("spawnflags", 0)
        self.smokeTrail:SetKeyValue("spawnradius", 5)
        self.smokeTrail:SetKeyValue("spawnrate", 20)
        self.smokeTrail:SetKeyValue("speed", 0)
        self.smokeTrail:SetKeyValue("startsize", 8)
        self.smokeTrail:SetKeyValue("texframeindex", 0)
    	self.smokeTrail:SetPos(self:GetPos())
    	self.smokeTrail:SetParent(self)
    	self.smokeTrail:Spawn()
    	self.smokeTrail:Activate()
    end

    return self.smokeTrail
end

--Put the PlayerController in control of the manhack
function ENT:StartControlling()
    local playerController = self:GetPlayerController()

    if IsValid(playerController)  then
        self.oldEyeAngles = playerController:EyeAngles()
        self.yawOffset = self:GetAngles().y - self.oldEyeAngles.y

        net.Start(ControllableManhack.manhackEntityClassName .. ".ClientStartControlling")
        net.WriteEntity(self)
        net.WriteFloat(self.yawOffset)
        net.Send(playerController)

        self.oldHullDuckMins, self.oldHullDuckMaxs = playerController:GetHullDuck()
        playerController:SetHullDuck(playerController:GetHull())

        -- self:HookAdd("KeyPress", "KeyActions", function(ply, key)
            -- if ply == playerController then
            --     if key == IN_ATTACK then
            --         self:Charge()
            --     elseif key == IN_ATTACK2 then
            --         self:EmitSound(self.SoundActive)
            --         self:StopControlling()
            --     end
            -- end
        -- end)

        self:HookAdd("Move", "PreventOwnerMovement", function(ply, moveData)
        	if ply == playerController then
                return true
            end
        end)

        self:HookAdd("SetupPlayerVisibility", "AddToPVS", function(player)
            AddOriginToPVS(self:GetPos())
        end)

        self:HookAdd("AllowPlayerPickup", "DisallowPickup", function(ply, ent)
            if ply == playerController then
                return false
            end
        end)

        self:HookAdd("PlayerFootstep", "MuteFootsteps", function(ply, pos, foot, sound, volume, filter)
            if ply == playerController then
                return true
            end
        end)

        self:HookAdd("PlayerUse", "DisallowUse", function(ply, ent)
            if ply == playerController then
                return false
            end
        end)

        self:EmitSound(self.SoundActive)
        self:SetControlActive(true)
    end
end

--Stop PlayerController from controlling the manhack
function ENT:StopControlling()
    self:HookRemove("KeyPress", "KeyActions")
    self:HookRemove("Move", "PreventOwnerMovement")
    self:HookRemove("SetupPlayerVisibility", "AddToPVS")
    self:HookRemove("AllowPlayerPickup", "DisallowPickup")
    self:HookRemove("PlayerFootstep", "MuteFootsteps")
    self:HookRemove("PlayerUse", "DisallowUse")

    local playerController = self:GetPlayerController()

    if IsValid(playerController) then
        net.Start(ControllableManhack.manhackEntityClassName .. ".ClientStopControlling")
        net.WriteEntity(self)
        net.Broadcast()

        if self.oldHullDuckMins and self.oldHullDuckMaxs then
            playerController:SetHullDuck(self.oldHullDuckMins, self.oldHullDuckMaxs)
        end

        local activeWeapon = playerController:GetActiveWeapon()

        if IsValid(activeWeapon) and activeWeapon:GetClass() == "weapon_controllable_manhack" then
            --Needed so the weapon will not trigger secondary instantly
            activeWeapon:SetNextSecondaryFire(CurTime() + 0.1)
        end

        if self.oldEyeAngles and self:GetControlActive() then
            playerController:SetEyeAngles(self.oldEyeAngles)
        end
    end

    self.shadowControl.angle.p = 0

    self:SetControlActive(false)
end

--Create explosion and self destruct
function ENT:Explode()
    if ControllableManhack.ConVarSelfDestructExplosion() then
        local explode = ents.Create("env_explosion")
        explode:SetPos(self:GetPos() + self:OBBCenter())
        explode:SetOwner(self.damageInfoPlayer)
        explode:Spawn()
        explode:SetKeyValue("iMagnitude", self.ExplosionSize)
        explode:Fire("Explode", 0, 0)
    end

    local damageInfo = DamageInfo()
    damageInfo:SetDamage(self:Health())
    damageInfo:SetAttacker(IsValid(self.damageInfoPlayer) and self.damageInfoPlayer or self)
    damageInfo:SetInflictor(self)
    damageInfo:SetReportedPosition(self:GetPos())
    damageInfo:SetDamagePosition(self:GetPos())
    damageInfo:SetDamageForce(Vector(0, 0, 0))
    --I use DMG_DIRECT instead of DMG_BlAST here because I want to make sure it gets destroyed without any damage modifications
    damageInfo:SetDamageType(DMG_DIRECT)
    self:TakeDamageInfo(damageInfo)

    SafeRemoveEntity(self)
end

--Start self destructing
function ENT:SelfDestruct()
    self.damageInfoPlayer = self:GetPlayerController()

    self:StopControlling()
    self:SetPlayerController(NULL)

    if not ControllableManhack.ConVarSelfDestructInstant() then
        self:EmitSound(self.SoundStunned)

        net.Start(ControllableManhack.manhackEntityClassName .. ".ClientSelfDestructing")
        net.WriteEntity(self)
        net.Broadcast()
    end

    self.isSelfDestructing = true

    local damageInfo = DamageInfo()
    damageInfo:SetDamage(self:Health() - 1)
    damageInfo:SetAttacker(self)
    damageInfo:SetInflictor(self)
    damageInfo:SetReportedPosition(self:GetPos())
    damageInfo:SetDamagePosition(self:GetPos())
    damageInfo:SetDamageForce(Vector(0, 0, 0))
    damageInfo:SetDamageType(DMG_DIRECT)
    self:TakeDamageInfo(damageInfo)

    timer.Simple(ControllableManhack.ConVarSelfDestructInstant() and 0 or self.SelfDestructDelay, function()
        if IsValid(self) then
            self:Explode()
        end
    end)
end

--Setup entity relationship on newly spawned npcs/entities
hook.Add("OnEntityCreated", ControllableManhack.manhackEntityClassName .. ".SetupEntityRelationship", function(ent)
	if ent:GetClass() ~= "npc_cscanner" and ent.AddEntityRelationship and ent.Disposition then
        --Used to get default relationships
        local tempManhack = ents.Create("npc_cscanner")

        for manhackIndex, manhack in pairs(ents.FindByClass(ControllableManhack.manhackEntityClassName)) do
            local relationship = ent:Disposition(tempManhack)

            --If npc is a rebel
            if relationship == D_HT or relationship == D_FR then
                ent:AddEntityRelationship(manhack, manhack.rebelHate and relationship or D_LI, 99)
            --If npc is a combine
            elseif relationship == D_LI or relationship == D_NU then
                ent:AddEntityRelationship(manhack, manhack.combineHate and D_HT or relationship, 99)
            end
        end

        SafeRemoveEntity(tempManhack)
	end
end)

hook.Add("PlayerDeath", ControllableManhack.manhackEntityClassName .. ".SelfDestuctWhenOwnerDies", function(victim, inflictor, attacker)
    local manhack = ControllableManhack.GetManhackForPlayer(victim)

    if IsValid(manhack) then
        if ControllableManhack.ConVarSelfDestructDeath() then
            manhack:SelfDestruct()
        else
            manhack:StopControlling()
        end
    end
end)

hook.Add("PlayerDisconnected", ControllableManhack.manhackEntityClassName .. ".SelfDestuctWhenOwnerDisconnected", function(ply)
    local manhack = ControllableManhack.GetManhackForPlayer(ply)

    if IsValid(manhack) then
        manhack:SelfDestruct()
    end
end)
