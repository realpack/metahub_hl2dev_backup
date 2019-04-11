SWEP.PrintName              = "Лопата"
SWEP.Author                 = "Silhouhat"
SWEP.Purpose                = "City Worker"
SWEP.Instructions           = "LMB to clear rubble"

SWEP.Category               = "City Worker"
SWEP.Spawnable              = false

SWEP.Primary.ClipSize		= -1
SWEP.Primary.DefaultClip	= -1
SWEP.Primary.Automatic		= true
SWEP.Primary.Ammo		    = "none"

SWEP.Secondary.ClipSize		= -1
SWEP.Secondary.DefaultClip	= -1
SWEP.Secondary.Automatic	= false
SWEP.Secondary.Ammo		    = "none"

SWEP.Weight			        = 5
SWEP.AutoSwitchTo		    = false
SWEP.AutoSwitchFrom		    = false

SWEP.Slot			        = 2
SWEP.SlotPos			    = 1
SWEP.DrawAmmo			    = false
SWEP.DrawCrosshair		    = true

SWEP.ViewModel			    = "models/props_junk/shovel01a.mdl"
SWEP.WorldModel			    = "models/props_junk/shovel01a.mdl"

function SWEP:Initialize()
    self:SetHoldType( "melee2" )
end

function SWEP:PrimaryAttack()
    if CLIENT then return end
    if not IsFirstTimePredicted() then return end

    self:SetNextPrimaryFire( CurTime() + 1 )

    local ent = self.Owner:GetEyeTrace().Entity
    if not IsValid( ent ) then return end
    if ent:GetClass() != "cityworker_rubble" then return end
    if ent:GetPos():Distance( self.Owner:GetPos() ) > 200 then return end

    CITYWORKER.Begin( self.Owner, ent )
end

function SWEP:SecondaryAttack()
    return
end

function SWEP:Reload()
    return
end

function SWEP:DrawWorldModel()
    if not IsValid( self.Owner ) then return end

    local pos, ang = self.Owner:GetBonePosition( self.Owner:LookupBone( "ValveBiped.Bip01_R_Hand" ) )
    local offsetPos = ang:Right() * 1 + ang:Forward() * 2 + ang:Up() * 5

    ang:RotateAroundAxis( ang:Right(), 0 )
    ang:RotateAroundAxis( ang:Forward(), 180 )
    ang:RotateAroundAxis( ang:Up(), 0 )

    self:SetRenderOrigin( pos + offsetPos )
    self:SetRenderAngles( ang )

    self:DrawModel()
end

function SWEP:GetViewModelPosition( pos, ang )
    pos = pos + ang:Right() * 20 + ang:Forward() * 35 + ang:Up() * -18

    ang:RotateAroundAxis( ang:Up(), 0 )
    ang:RotateAroundAxis( ang:Right(), 180 )

    return pos, ang
end