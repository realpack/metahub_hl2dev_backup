
-----------------------------------------------------

AddCSLuaFile()

local BaseClass = baseclass.Get('weapon_hl2axe')

SWEP.Spawnable			= true
SWEP.Category = "Оружие Ближнего Боя"

SWEP.PrintName				= "Кастрюля"

SWEP.ViewModel				= Model( "models/weapons/HL2meleepack/v_pot.mdl" )
SWEP.WorldModel				= Model( "models/weapons/HL2meleepack/w_pot.mdl" )

SWEP.Push = false

SWEP.HitSound = Sound( "Flesh.ImpactHard" )
SWEP.SwingSound = Sound( "WeaponFrag.Roll" )
SWEP.HitSoundElse = Sound("Canister.ImpactHard")

SWEP.HitRate = 0.4
SWEP.DamageDelay = 0.2
SWEP.DamageMin = 30
SWEP.DamageMax = 50

SWEP.PushAngle = Angle(-5, -1, 0.125)
SWEP.HitAngle = Angle(-4, -4, 0.125)

SWEP.HoldType = "melee"