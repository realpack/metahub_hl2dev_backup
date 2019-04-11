SWEP.Base                  = "weapon_base"
SWEP.Category              = "CID Cards"
SWEP.PrintName             = "id_card_base"
SWEP.Author                = "roni_sl"
SWEP.Spawnable             = false

SWEP.Weight                = 5

SWEP.Slot                  = 5
SWEP.SlotPos               = 1
SWEP.DrawAmmo              = false
SWEP.DrawCrosshair         = false

SWEP.HoldType              = "pistol"
SWEP.ViewModelFOV          = 70
SWEP.ViewModelFlip         = false
SWEP.ViewModel             = "models/bkeycardscanner/c_keycard.mdl"
SWEP.WorldModel            = ""
SWEP.UseHands              = true

SWEP.TextToSay = "предъявил CID карту гражданина"

SWEP.Primary = {
	Ammo = "none",
	ClipSize = -1,
	DefaultClip = -1,
	Automatic = false,
}
SWEP.Secondary = SWEP.Primary

function SWEP:Initialize()
	self:SetHoldType(self.HoldType)
end

function SWEP:PrimaryAttack()
	if SERVER then
        for _, pl in pairs(ents.FindInSphere(self:GetPos(), 300)) do
            if pl and IsValid(pl) and pl:IsPlayer() then
                -- pl:RunString('rp.names['..pl:SteamID()..'] = true', "RunString", false)
                pl:ConCommand( string.format('cid_addname "%s"', self.Owner:SteamID64()) )
            end
        end
    else
        RunConsoleCommand("say", "/me "..self.TextToSay..". ID #" ..self.Owner:GetNetVar('RPID'));
    end
	self:SetNextPrimaryFire(CurTime() + 2)
end

function SWEP:SecondaryAttack()
	-- if CLIENT then
	-- 	RunConsoleCommand("say", "/me убрал CID карту в задний карман");
	-- else
	-- 	self.Owner:Give("weapon_hands")
	-- 	self.Owner:SelectWeapon("weapon_hands")
	-- end
	-- self:SetNextPrimaryFire(CurTime() + 2)
end
