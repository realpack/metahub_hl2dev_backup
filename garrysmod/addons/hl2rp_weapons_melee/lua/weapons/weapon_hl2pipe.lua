
-----------------------------------------------------

AddCSLuaFile()

local BaseClass = baseclass.Get('weapon_hl2axe')

SWEP.Spawnable			= true
SWEP.Category = "Оружие Ближнего Боя"

SWEP.PrintName				= "Труба"

SWEP.ViewModel				= Model( "models/weapons/HL2meleepack/v_pipe.mdl" )
SWEP.WorldModel				= Model( "models/props_canal/mattpipe.mdl" )

SWEP.Push = false

SWEP.HitSound = Sound( "Flesh.ImpactHard" )
SWEP.SwingSound = Sound( "WeaponFrag.Roll" )
SWEP.HitSoundElse = Sound("Canister.ImpactHard")

SWEP.HitRate = 0.8
SWEP.DamageDelay = 0.2
SWEP.DamageMin = 10
SWEP.DamageMax = 20

SWEP.HitAngle = Angle(6, 6, 0.125)

SWEP.HoldType = "melee"
