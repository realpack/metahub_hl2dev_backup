
-----------------------------------------------------

AddCSLuaFile()

local BaseClass = baseclass.Get('weapon_hl2axe')

SWEP.Spawnable			= true
SWEP.Category = "Оружие Ближнего Боя"

SWEP.PrintName				= "Сковорода"

SWEP.ViewModel				= Model( "models/weapons/HL2meleepack/v_pan.mdl" )
SWEP.WorldModel				= Model( "models/weapons/HL2meleepack/w_pan.mdl" )

SWEP.HitSound = Sound( "Flesh.ImpactHard" )
SWEP.SwingSound = Sound( "WeaponFrag.Roll" )
SWEP.HitSoundElse = Sound("Metal_Box.ImpactHard")

SWEP.Push = false

SWEP.HitRate = 0.7
SWEP.DamageDelay = 0.2
SWEP.PushDelay = 1
SWEP.DamageMin = 12
SWEP.DamageMax = 18

SWEP.PushAngle = Angle(-5, -1, 0.125)
SWEP.HitAngle = Angle(-4, -4, 0.125)

SWEP.HoldType = "melee"

