function PLAYER:IsMayor()
	return rp.teams[self:Team()].mayor or false
end

function PLAYER:IsCP()
    local t = self:Team()
    local job = rp.teams[t]
    if not t or t == 0 then t = 1 end
	return job and (rp.cfg.TypesCanCP[job.type] or job.police or false)
end

if (SERVER) then
	function PLAYER:IsStalker()
		return self:Team() == TEAM_STALKER
	end

    rp.ArrestedPlayers = rp.ArrestedPlayers or {}
	function PLAYER:IsArrested()
		return (rp.ArrestedPlayers[self:SteamID64()] and rp.ArrestedPlayers[self:SteamID64()] == true) or false
	end
else
	function PLAYER:IsArrested()
		return (self:GetNetVar('ArrestedInfo') ~= nil)
	end
end

function PLAYER:IsWanted()
	return (self:GetNetVar('IsWanted') == true)
end

function PLAYER:GetWantedReason()
	return self:GetNetVar('WantedReason')
end

function PLAYER:GetArrestInfo()
	return self:GetNetVar('ArrestedInfo')
end


nw.Register 'IsWanted'
	:Write(net.WriteBool)
	:Read(net.ReadBool)
	:SetPlayer()

nw.Register('WantedReason', {
	Read 	= net.ReadString,
	Write 	= net.WriteString,
	LocalVar = true
})

nw.Register('ArrestedInfo', {
	Read 	= function()
		return {Reason = net.ReadString(), Release = net.ReadUInt(32)}
	end,
	Write 	= function(v)
		net.WriteString(v.Reason)
		net.WriteUInt(v.Release, 32)
	end,
	LocalVar = true
})

if SERVER then
	util.AddNetworkString("snd.startchat")
	util.AddNetworkString("snd.endchat")
	net.Receive("snd.endchat", function(len, ply)
		if not ply:isCP() or ply:Team() == TEAM_CRIMES then return end
		ply:EmitSound("npc/metropolice/vo/off"..math.random(1,4)..".wav")
	end)
	net.Receive("snd.startchat", function(len, ply)
		if not ply:isCP() or ply:Team() == TEAM_CRIMES then return end
		ply:EmitSound("npc/metropolice/vo/on"..math.random(1,2)..".wav")
	end)
end

if CLIENT then
	timer.Simple(2, function()
		hook.Add( "FinishChat", ".typing.end", function()
			if LocalPlayer():isCP() then
				net.Start("snd.endchat")
				net.SendToServer(LocalPlayer())
			end
		end )
		hook.Add( "StartChat", ".typing.start", function()
			if LocalPlayer():isCP() then
				net.Start("snd.startchat")
				net.SendToServer(LocalPlayer())
			end
		end )
	end)
end
