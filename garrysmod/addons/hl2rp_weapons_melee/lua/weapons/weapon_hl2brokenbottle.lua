
-----------------------------------------------------

AddCSLuaFile()

local BaseClass = baseclass.Get('weapon_hl2axe')

SWEP.Spawnable			= true
SWEP.Category = "Оружие Ближнего Боя"

SWEP.PrintName				= "Розочка"

SWEP.ViewModel				= Model( "models/weapons/HL2meleepack/v_brokenbottle.mdl" )
SWEP.WorldModel				= Model( "models/weapons/HL2meleepack/w_brokenbottle.mdl" )

SWEP.HitSound = Sound( "Flesh_Bloody.ImpactHard" )
SWEP.SwingSound = Sound( "WeaponFrag.Roll" )
SWEP.HitSoundElse = Sound("GlassBottle.ImpactHard")
SWEP.Push = false

SWEP.HitRate = 0.4
SWEP.DamageDelay = 0.2
SWEP.PushDelay = 1
SWEP.DamageMin = 20
SWEP.DamageMax = 30

SWEP.PushAngle = Angle(-5, -1, 0.125)
SWEP.HitAngle = Angle(-4, -4, 0.125)

SWEP.HoldType = "knife"