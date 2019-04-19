if CLIENT then
    rp.names = rp.names or {}
end

PLAYER.SteamName = PLAYER.SteamName or PLAYER.Name
function PLAYER:Name()
    if self and self:Team() and rp.cfg.NickNameRegex[self:Team()] then
        return self:IsAdmin() and string.format(rp.cfg.NickNameRegex[self:Team()]..' ['..self:SteamName()..']', team.GetName(self:Team()), self:GetNetVar("RPID")) or string.format(rp.cfg.NickNameRegex[self:Team()], team.GetName(self:Team()), self:GetNetVar("RPID"))
    end

    if CLIENT and LocalPlayer() ~= self then
        if not rp.names[self:SteamID()] then
            return LocalPlayer():IsAdmin() and '['..self:SteamName()..']' or 'Незнакомец'
        end
        return LocalPlayer():IsAdmin() and (self:GetNetVar('Name')..' ['..self:SteamName()..']' or self:SteamName()) or (self:GetNetVar('Name') or self:SteamName()) or "Unknown"
    end
    return (self:GetNetVar('Name') or self:SteamName() or "Unknown")
end
PLAYER.Nick 	= PLAYER.Name
PLAYER.GetName 	= PLAYER.Name

function PLAYER:GetMoney()
	return (self:GetNetVar('Money') or rp.cfg.StartMoney)
end

function PLAYER:GetKarma()
	return (self:GetNetVar('Karma') or rp.cfg.StartKarma)
end

local math_floor 	= math.floor
local math_min 		= math.min
function rp.Karma(pl, min, max) -- todo, remove this
	return pl:Karma(min, max)
end

function PLAYER:Karma(min, max)
	return math_floor(min + ((max - min) * (self:GetKarma()/100)))
end

function PLAYER:Wealth(min, max)
	return math_min(math_floor(min + ((max - min) * (self:GetMoney()/25000000))), max)
end

function PLAYER:HasLicense()
	return (self:GetNetVar('HasGunlicense') or self:GetJobTable().hasLicense)
end

function PLAYER:HasTeam(index)
    local data = rp.teams[index]
    local player_teams = self:GetNetVar('Teams') or nil
    if data.needbuy then
        if player_teams and player_teams[data.command] then
            return true
        end
    else
        return true
    end
	return false
end

if CLIENT then
    net.Receive('ToggleRevertMask', function()
        LocalPlayer().overlay = not LocalPlayer().overlay
    end)
end
