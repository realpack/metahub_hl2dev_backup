
-----------------------------------------------------
AddCSLuaFile()

if CLIENT then
	SWEP.DrawCrosshair = false
	SWEP.PrintName = "Патрульный Пистолет"
	SWEP.CSMuzzleFlashes = true
	
	SWEP.AimPos = Vector (-6.0266, -1.0035, 2.9003)
	SWEP.AimAng = Vector (0.5281, -1.3165, 0.8108)
	
	SWEP.SprintPos = Vector (5.041, 0, 3.6778)
	SWEP.SprintAng = Vector (-17.6901, 10.321, 0)
	
	SWEP.ZoomAmount = 5
	SWEP.ViewModelMovementScale = 0.85
	SWEP.Shell = "smallshell"
	
	SWEP.IconLetter = "d"
	SWEP.IconFont = "WeaponIcons"
	
	--SWEP.MuzzleEffect = "swb_pistol_large"
	--SWEP.MuzzlePosMod = {x = 6.5, y =	30, z = -2}
	--SWEP.PosBasedMuz = true
end

SWEP.SpeedDec = 12
SWEP.BulletDiameter = 9.1
SWEP.CaseLength = 33

SWEP.PlayBackRate = 2
SWEP.PlayBackRateSV = 2

SWEP.Kind = WEAPON_PISTOL
SWEP.AutoSpawnable = true
SWEP.AllowDrop = true
SWEP.AmmoEnt = "item_ammo_revolver_ttt"

SWEP.Slot = 1
SWEP.SlotPos = 0
SWEP.NormalHoldType = "pistol"
SWEP.RunHoldType = "normal"
SWEP.FireModes = {"semi"}
SWEP.Base = "swb_base"
SWEP.Category = "Оружейная"

SWEP.Author			= "Spy"
SWEP.Contact		= ""
SWEP.Purpose		= ""
SWEP.Instructions	= ""

SWEP.ViewModelFOV	= 55
SWEP.ViewModelFlip	= false
SWEP.ViewModel			= "models/weapons/c_pistol.mdl"
SWEP.WorldModel			= "models/weapons/w_pistol.mdl"

SWEP.Spawnable			= true
SWEP.AdminSpawnable		= true

SWEP.Primary.ClipSize		= 15
SWEP.Primary.DefaultClip	= 60
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo			= "Pistol"

SWEP.FireDelay = 0.1
SWEP.FireSound = Sound("Weapon_Pistol.Single")
SWEP.Primary.Reload 		= Sound("Weapon_Pistol.Reload")
SWEP.Recoil = 1.2
SWEP.Chamberable = false

SWEP.HipSpread = 0.038
SWEP.AimSpread = 0.0075
SWEP.VelocitySensitivity = 1.1
SWEP.MaxSpreadInc = 0.06
SWEP.SpreadPerShot = 0.0055
SWEP.SpreadCooldown = 0.1
SWEP.Shots = 1
SWEP.Damage = 37
SWEP.DeployTime = 1

function SWEP:ReloadSound()
	self.Weapon:EmitSound(self.Primary.Reload)
end