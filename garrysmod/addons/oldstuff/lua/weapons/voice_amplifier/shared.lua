SWEP.ViewModel = "models/weapons/v_slam.mdl"
SWEP.WorldModel = "models/weapons/w_suitcase_passenger.mdl"
SWEP.HoldType = "normal"
SWEP.Spawnable = true
SWEP.AdminOnly = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= false
SWEP.Primary.Ammo		= "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		= "none"

SWEP.Category = "Вспомогательные Предметы"

function SWEP:SetupDataTables()
  self:NetworkVar("Bool",0,"AllTalk")
  self:NetworkVar("Int",0,"Distance")

  if SERVER then
    self:SetAllTalk(false)
    self:SetDistance(302500)
  end
end

list.Add( "NPCUsableWeapons", { class = "voice_amplifier",	title = "Amplifier" } )
