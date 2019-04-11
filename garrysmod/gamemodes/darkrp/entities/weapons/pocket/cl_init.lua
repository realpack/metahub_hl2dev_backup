include("pocket_controls.lua")
include("pocket_vgui.lua")
include("shared.lua")

SWEP.PrintName = "Чемодан"
SWEP.Slot = 1
SWEP.SlotPos = 1
SWEP.DrawAmmo = false
SWEP.DrawCrosshair = false
SWEP.FrameVisible = false

function SWEP:PrimaryAttack()
	return
end

function SWEP:SecondaryAttack()
	rp.inv.EnableMenu();

	return
end

function SWEP:DrawHUD()
    if thirdperson_enabled then return end

	-- surface.SetDrawColor(color_white)
	-- surface.DrawRect(ScrW()*.5, ScrH()*.5-4, 1, 9)
	-- surface.DrawRect(ScrW()*.5-4, ScrH()*.5, 9, 1)

    -- draw.Arc( {x=ScrW()*.5,y=ScrH()*.5}, 0, 360, 4, 60, 4, Color(0,0,0,130) )
    draw.Arc( {x=ScrW()*.5,y=ScrH()*.5}, 0, 360, 4, 60, 1, Color(255,255,255,130) )
    draw.Arc( {x=ScrW()*.5,y=ScrH()*.5}, 0, 360, 5, 60, 1, Color(0,0,0,130) )
end
