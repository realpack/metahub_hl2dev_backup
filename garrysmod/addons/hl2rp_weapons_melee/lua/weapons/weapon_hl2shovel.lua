
-----------------------------------------------------

AddCSLuaFile()

local BaseClass = baseclass.Get('weapon_hl2axe')

SWEP.Spawnable			= true
SWEP.Category = "Оружие Ближнего Боя"

SWEP.PrintName				= "Лопата"

SWEP.ViewModel				= Model( "models/weapons/HL2meleepack/v_shovel.mdl" )
SWEP.WorldModel				= Model( "models/weapons/HL2meleepack/w_shovel.mdl" )
SWEP.ViewModelFOV			= 67

SWEP.HitSound = Sound( "Flesh.ImpactHard" )
SWEP.SwingSound = Sound( "WeaponFrag.Roll" )
SWEP.HitSoundElse = Sound("Canister.ImpactHard")

SWEP.HitRate = 1.25
SWEP.DamageDelay = 0.4
SWEP.DamageMin = 24
SWEP.DamageMax = 40

SWEP.PushAngle = Angle(-10, -1, 0.125)
SWEP.HitAngle = Angle(-4, -4, 0.125)

SWEP.HoldType = "melee2"