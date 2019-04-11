SWEP.PrintName 					= 'Руки в наручниках'
SWEP.Slot                       = 1
SWEP.SlotPos                    = 4
SWEP.DrawAmmo 					= false
SWEP.DrawCrosshair 				= false

SWEP.Author 					= 'pack'
SWEP.Instructions				= ''
SWEP.Contact 					= ''
SWEP.Purpose 					= ''

SWEP.ViewModel                  = ""
SWEP.WorldModel                 = ""

SWEP.ViewModelFOV 				= 70
SWEP.ViewModelFlip 				= false

SWEP.Spawnable 					= false
SWEP.Category 					= 'MetaHub Weapons'
SWEP.Primary.ClipSize 			= -1
SWEP.Primary.DefaultClip 		= 0
SWEP.Primary.Automatic 			= false
SWEP.Primary.Ammo 				= ''

SWEP.Secondary.ClipSize 		= -1
SWEP.Secondary.DefaultClip 		= 0
SWEP.Secondary.Automatic 		= false
SWEP.Secondary.Ammo 			= ''

SWEP.HoldType                   = "normal"

function SWEP:Deploy()
	self:SetHoldType(self.HoldType)
end
