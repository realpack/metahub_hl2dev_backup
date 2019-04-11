--I know the folder "heroine" isn't right but I wanted the files to overwrite instead of having two files, heroine and heroin. So I just kept it as-is.

AddCSLuaFile("shared.lua")
include("shared.lua")


ENT.MODEL = "models/props_junk/garbage_glassbottle002a.mdl"


ENT.LASTINGEFFECT = 20; --how long the high lasts in seconds, short because it's heroine.


function ENT:High(activator,caller)
    --make you invincible
    if not self:Realistic() then
        activator:GodEnable()
        activator:SetHealth(1)
    end

    self:Say(activator, "Это моя нога! Моя нога и мой глаз!")
end

--heroine is bad, so you die when your high is over (you have to take more to NOT die, kind of like an "addiction")
local function HeroinDeath()
	for id,pl in pairs(player.GetAll())do
	
		if pl:GetNWFloat("durgz_heroine_high_end") < CurTime() && pl:GetNWFloat("durgz_heroine_high_end") + 0.5 > CurTime() && pl:GetNWFloat("durgz_heroine_high_start") != 0 then
			pl.DURGZ_MOD_DEATH = "durgz_heroine"
			pl.DURGZ_MOD_OVERRIDE = pl:Nick().." died because of their Heroin dependence.";
			pl:Kill()
			pl:GodDisable()
			pl:SetNWFloat("durgz_heroine_high_start", 0)
			pl:SetNWFloat("durgz_heroine_high_end", 0)
		end
		
	end
end
hook.Add("Think", "durgz_heroine_die", HeroinDeath)
