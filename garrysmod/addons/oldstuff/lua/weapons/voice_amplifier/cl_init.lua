include("shared.lua")

SWEP.PrintName = "Громкоговоритель"
SWEP.Author = "Dannelor"
SWEP.Purpose = "Amplifies the distance a players voice can be heard."
SWEP.Instructions = "Select swep and change settings"

SWEP.BobScale = 0
SWEP.SwayScale = 0
SWEP.BounceWeaponIcon = false

SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.slot = 5
SWEP.WepSelectIcon = surface.GetTextureID("VGUI/entities/voice_amplifier")

function SWEP:PostDrawViewModel(vm,wep,ply)
  cam.Start3D()
    local dis = math.sqrt(self:GetDistance())
    local AllTalk = self:GetAllTalk()
    render.SetColorMaterial()
    render.DrawSphere(ply:GetPos(),AllTalk and -200 or -dis,20,20,AllTalk and Color(255,0,0,40) or Color(0,255,0,40))
  cam.End3D()
end
