ENT.Base = "base_entity"
ENT.Type = "anim"

ENT.PrintName = "Controllable Manhack"
ENT.Author = "Thomas"
ENT.Information = "Used for the controllable manhack weapon"
ENT.Category = "Fun + Games"

ENT.Spawnable   = false
ENT.AdminOnly   = false

ENT.RenderGroup = RENDERGROUP_TRANSLUCENT
ENT.Model = Model("models/manhack.mdl")
ENT.UseType = SIMPLE_USE
ENT.ChargeTime = 1.4
ENT.AnglePitchLimit = 40
ENT.TransmitState = TRANSMIT_ALWAYS

ENT.SoundEngine1 = Sound("NPC_Manhack.EngineSound1")
ENT.SoundBlade = Sound("NPC_Manhack.BladeSound")
ENT.SoundActive = Sound("NPC_CombineCamera.Active")
ENT.SoundStunned = Sound("NPC_Manhack.Stunned")
ENT.SoundSlice = Sound("NPC_Manhack.Slice")
ENT.SoundGrind = Sound("NPC_Manhack.Grind")
ENT.SoundChargeStart = Sound("NPC_Manhack.ChargeAnnounce")
ENT.SoundChargeEnd = Sound("NPC_Manhack.ChargeEnd")
ENT.SoundUnpack = Sound("NPC_Manhack.Unpack")
ENT.SoundRetire = Sound("NPC_CeilingTurret.Retire")
ENT.SoundDie = Sound("NPC_Manhack.Die")

ENT.SequenceDeploy = "Deploy"

ENT.ThirdPersonDistance = 70
ENT.ThirdPersonHullSize = 4

ENT.SelfDestructDelay = 2
ENT.ExplosionSize = 60

ENT.MoveForce = 15
ENT.MoveFastForce = 30
ENT.MoveSinForce = 0.4
ENT.MoveSelfDestructForce = 10

ENT.CollideDamage = {
	Min = 3,
	Max = 5
}
ENT.CollideChargeDamage = {
	Min = 6,
	Max = 10
}
ENT.CollideForce = {
	Min = 800,
	Max = 1200
}
ENT.CollideBloodTypes = {
	flesh = true;
	zombieflesh = true;
	alienflesh = true;
	antlion = true;
	hunter = true;
}
ENT.SelfTakeDamageForce = 0.4
ENT.CollideUseRadius = 8
ENT.SelfCollideForce = 500
ENT.SelfCollideDamageRequiredSpeed = 500
ENT.SelfCollideDamageMultiplier = 0.08
ENT.CollideLessThanDot = 0.8
ENT.CollideUseWhiteListClasses = {
	["C_BaseEntity"] = true;
	["instant"] = true;
	["prop_physics"] = true;
	["prop_dynamic"] = true;
}
ENT.CollideUseWhiteListFunctions = {
	function(self, ent)
		return self.CollideUseWhiteListClasses[ent:GetClass()]
	end;
	function(self, ent)
		return string.find(ent:GetClass(), "button")
	end;
	function(self, ent)
		return string.find(ent:GetClass(), "door")
	end;
	function(self, ent)
		local className = "gmod_wire_"

		return string.Left(ent:GetClass(), #className) == className
	end;
	function(self, ent)
		local className = "func_"

		return string.Left(ent:GetClass(), #className) == className
	end;
}

ENT.IncapacitatedDelay = 1
ENT.IncapacitatedDamageMultiplier = 0.6

ENT.PitchStart = 100
ENT.PitchMultiplier = 0.2
ENT.MaxPitchAdd = 50

ENT.OverlayMaterial = "effects/combine_binocoverlay"
ENT.ColorModify = {
	[ "$pp_colour_addr" ] = 0.4,
	[ "$pp_colour_addg" ] = 0,
	[ "$pp_colour_addb" ] = 0,
	[ "$pp_colour_brightness" ] = 0,
	[ "$pp_colour_contrast" ] = 1,
	[ "$pp_colour_colour" ] = 1,
	[ "$pp_colour_mulr" ] = 0,
	[ "$pp_colour_mulg" ] = 0,
	[ "$pp_colour_mulb" ] = 0
}

ENT.HUDTextOffset = {
	x = 180,
	y = 0
}
ENT.HUDTextFont = "font_base_22"
ENT.HUDTextColor = Color(200, 200, 200, 190)
ENT.HUDTextOutlineColor = Color(0, 0, 0)
ENT.HudTextOutlineSize = 2
ENT.HUDTextYSpacing = 30
ENT.HUDTextSeperatorXSpacing = 10
ENT.HUDTextSeperator = "="
ENT.HUDTexts = {
	{
		name = "HEALTH",
		GetValue = function(self, manhack)
			return manhack:Health()
		end
	};
	{
		name = "VELOCITY",
		GetValue = function(self, manhack)
			return math.Round(manhack:GetVelocity():Length())
		end
	};
	{
		name = "CHARGE_MODE",
		GetValue = function(self, manhack)
			return manhack:IsCharging() and "ON" or "OFF"
		end
	};
	{
		name = "PROXIMITY",
		seconds = 1,
		GetValue = function(self, manhack)
			local trace = util.TraceLine({
				start = manhack:GetPos(),
				endpos = manhack:GetPos() + manhack:GetVelocity() * self.seconds,
				filter = manhack
			})

			return trace.Hit and "WARN" or "SAFE"
		end
	};
	{
		name = "COORDINATE",
		GetValue = function(self, manhack)
			local position = manhack:GetPos()

			return "[" .. math.Round(position.x, 1) .. "," .. math.Round(position.y, 1) .. "," .. math.Round(position.z, 1) .. "]"
		end
	};
	{
		name = "ROTATION",
		GetValue = function(self, manhack)
			local angle = manhack:GetAngles()

			return "[" .. math.Round(angle.p) .. "," .. math.Round(angle.y) .. "," .. math.Round(angle.r) .. "]"
		end
	};
}
ENT.HUDShowTargetDistance = 500
ENT.HUDTargetCircleSize = 200
ENT.HUDTargetCircleColor = Color(200, 200, 200, 190)
ENT.HUDTargetCircleMaterial = Material("particle/Particle_Ring_Wave_Additive")
ENT.HUDTargetTextHP = "HP "
ENT.HUDTargetYSpacing = 12
ENT.HUDWhitelist = {
	CHudGMod = true;
	CHudChat = true;
	NetGraph = true;
	CHudMenu = true;
}

ENT.GlowSprite1Offset = Vector(0, 1.2, 5)
ENT.GlowSprite2Offset = Vector(0, 0, 3)
ENT.GlowSprite1Bone = "Manhack.MH_ControlBodyUpper"
ENT.GlowSprite2Bone = "Manhack.MH_ControlCamera"
ENT.GlowSpriteMaterial = Material("sprites/glow04_noz")
ENT.GlowSpriteColorSelfDesctructing = Color(200, 200, 200, 190)
ENT.GlowSpriteColorDeploy = Color(255, 150, 0)
ENT.GlowSpriteColorActive = Color(200, 200, 200, 190)
ENT.GlowSpriteColorInactive = Color(255, 255, 255)

ENT.ClientPlayerModelSequence = "idle_camera"
ENT.ClientGlassesBone = "ValveBiped.Bip01_Head1"
ENT.ClientGlassesModel = Model("models/props_combine/combinebutton.mdl")
ENT.ClientGlassesScale = 0.7
ENT.ClientGlassesOffsetPos = Vector(5.082, -7.292, -0.405)
ENT.ClientGlassesOffsetAngle = Angle(0, -90, 90)

function ENT:SetupDataTables()
	self:NetworkVar("Entity", 0, "PlayerController")
	self:NetworkVar("Bool", 0, "ControlActive")
end

--Play a sequence and return sequence info
function ENT:PlaySequence(name)
    local sequenceID, sequenceDuration = self:LookupSequence(name)
    self:ResetSequence(sequenceID)
    self:ResetSequenceInfo()
    self:SetSequence(sequenceID)

    return sequenceID, sequenceDuration
end

--Get the name for a non entity hook
function ENT:GetHookIdentifier(identifier)
    return ControllableManhack.manhackEntityClassName .. "[" .. self:EntIndex() .. "]" .. "." .. identifier
end

--Add a non entity hook to the entity
function ENT:HookAdd(eventName, identifier, Func)
    hook.Add(eventName, self:GetHookIdentifier(identifier), Func)
end

--Remove a non entity hook from the entity
function ENT:HookRemove(eventName, identifier)
    local hookIdentifier = self:GetHookIdentifier(identifier)

	hook.Remove(eventName, hookIdentifier, Func)

	--Workaround for how the WAC addon steals hooks
	if ControllableManhack.ConVarFixConflicts() and wac and wac.stolenHooks and wac.stolenHooks[eventName] and wac.stolenHooks[eventName][hookIdentifier] then
		wac.stolenHooks[eventName][hookIdentifier] = nil
	end
end

--Add a non entity override hook to the entity
function ENT:HookAddOverride(eventName, identifier, Func)
    ControllableManhack.AddOverrideHook(eventName, self:GetHookIdentifier(identifier), Func)
end

--Remove a non entity override hook from the entity
function ENT:HookRemoveOverride(eventName, identifier)
	ControllableManhack.RemoveOverrideHook(eventName, self:GetHookIdentifier(identifier), Func)
end
