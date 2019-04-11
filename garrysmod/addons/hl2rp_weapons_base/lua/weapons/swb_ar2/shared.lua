
-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "AR2"
	SWEP.CSMuzzleFlashes = true
	SWEP.FadeCrosshairOnAim = false
	
	SWEP.AimPos = Vector(-3.743, -2.346, 1.539)
	SWEP.AimAng = Vector (0, 0, 0)

	
	SWEP.SprintPos = Vector(9.071, 0, 1.6418)
	SWEP.SprintAng = Vector(-12.9765, 26.8708, 0)
	
	SWEP.IconLetter = "l"
	SWEP.IconFont = "WeaponIcons"
	
	SWEP.MuzzleEffect = "swb_rifle_med"
end

SWEP.Base = 'swb_base'
SWEP.PlayBackRate = 30
SWEP.PlayBackRateSV = 12
SWEP.SpeedDec = 15
SWEP.BulletDiameter = 9
SWEP.CaseLength = 19

SWEP.Kind = WEAPON_HEAVY
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true

SWEP.Slot = 2
SWEP.SlotPos = 1
SWEP.NormalHoldType = "ar2"
SWEP.RunHoldType = "passive"
SWEP.FireModes = {"auto", "semi"}
SWEP.Category = "Оружейная"

SWEP.Author			= "aStonedPenguin"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 50
SWEP.ViewModel 			= "models/weapons/c_irifle.mdl"
SWEP.WorldModel 			= "models/weapons/w_irifle.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 30
SWEP.Primary.DefaultClip	= 90
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo			= "AR2"

SWEP.FireDelay = 0.1
SWEP.FireSound = Sound("Weapon_AR2.Single")
SWEP.Recoil = 0.3

SWEP.HipSpread = 0.03
SWEP.AimSpread = 0.001
SWEP.VelocitySensitivity = 1.2
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.002
SWEP.SpreadCooldown = 0.13
SWEP.Shots = 1
SWEP.Damage = 60
SWEP.DeployTime = 1

SWEP.Tracer = 'AR2Tracer'
