
-----------------------------------------------------

AddCSLuaFile()

local BaseClass = baseclass.Get('weapon_hl2axe')

SWEP.Spawnable			= true
SWEP.Category = "Оружие Ближнего Боя"

SWEP.PrintName				= "Крюк Мясника"

SWEP.ViewModel				= Model( "models/weapons/HL2meleepack/v_hook.mdl" )
SWEP.WorldModel				= Model( "models/weapons/HL2meleepack/w_hook.mdl" )
SWEP.ViewModelFOV			= 67

SWEP.HitSound = Sound( "Flesh.Break" )
SWEP.SwingSound = Sound( "WeaponFrag.Roll" )
SWEP.HitSoundElse = Sound("Canister.ImpactHard")

SWEP.HitRate = 1.25
SWEP.DamageDelay = 0.4
SWEP.PushDelay = 1
SWEP.DamageMin = 50
SWEP.DamageMax = 80

SWEP.PushAngle = Angle(-5, -1, 0.125)
SWEP.HitAngle = Angle(-4, -4, 0.125)

SWEP.HoldType = "melee2"