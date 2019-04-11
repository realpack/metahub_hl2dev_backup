AddCSLuaFile 'cl_init.lua'
AddCSLuaFile 'sh_init.lua'
include 'sh_init.lua'

-- resource.AddFile 'sound/physics/flesh/flesh_break1.wav'

/*
hook("Initialize", "serversecure initialization", function()
	require("serversecure")

	--serversecure.EnableFirewallWhitelist(boolean) -- enable "firewall", any client not in the whitelist doesn't see the server
	--serversecure.WhitelistIP(ip_in_integer_format) -- add an IP to the whitelist
	--serversecure.RemoveIP(ip_in_integer_format) -- remove an IP from the whitelist
	--serversecure.WhitelistReset() -- reset the whitelist

--	serversecure.EnableFileValidation(true) -- validates files requested by clients for download

	serversecure.EnableThreadedSocket(true) -- receives packets from the game socket on another thread (as well as analyzing it)

	serversecure.EnablePacketValidation(true) -- validates packets for having correct types, size, content, etc.

	serversecure.EnableInfoCache(true) -- enable A2S_INFO response cache
	serversecure.SetInfoCacheTime(5) -- seconds for cache to live (default is 5 seconds)

	serversecure.EnableQueryLimiter(false) -- enable query limiter (similar to Source's one but all handled on the same place)
	--serversecure.SetMaxQueriesWindow(60) -- timespan over which to average query counts from IPs (default is 30 seconds)
	--serversecure.SetMaxQueriesPerSecond(1) -- maximum queries per second from a single IP (default is 1 per second)
	--serversecure.SetGlobalMaxQueriesPerSecond(50) -- maximum total queries per second (default is 60 per second)

	--serversecure.RefreshInfoCache()
end)

local highestcount = 0
timer.Create('PlayerStatCache', 10, 0, function()
	if serversecure and (#player.GetAll() > highestcount) then
		highestcount = #player.GetAll()
		print('serversecure: buffing stats')
		serversecure.RefreshInfoCache()
	end
end)

concommand.Add('ref', function(p) if (not p:IsPlayer()) or p:IsRoot() then serversecure.RefreshInfoCache() highestcount = #player.GetAll() end end)
concommand.Add('cacheon', function(p) if (not p:IsPlayer()) or p:IsRoot() then serversecure.EnableThreadedSocket(true) serversecure.EnablePacketValidation(true) serversecure.EnableInfoCache(true) serversecure.SetInfoCacheTime(999999) serversecure.RefreshInfoCache() end end)
concommand.Add('cacheoff', function(p) if (not p:IsPlayer()) or p:IsRoot() then serversecure.EnableThreadedSocket(false) serversecure.EnablePacketValidation(false) serversecure.EnableInfoCache(false) end end)
*/

-- resource.AddDir 'materials/sup/os/'
-- resource.AddDir 'materials/sup/hud/'

local t = {
		robot = 	ACT_GMOD_GESTURE_TAUNT_ZOMBIE,
		salute = 	ACT_GMOD_TAUNT_SALUTE,
		agree = 	ACT_GMOD_GESTURE_AGREE,
		becon = 	ACT_GMOD_GESTURE_BECON,
		bow = 	 	ACT_GMOD_GESTURE_BOW,
		cheer = 	ACT_GMOD_TAUNT_CHEER,
		dance = 	ACT_GMOD_TAUNT_DANCE,
		disagree = 	ACT_GMOD_GESTURE_DISAGREE,
		forward = 	ACT_SIGNAL_FORWARD,
		group = 	ACT_SIGNAL_GROUP,
		halt = 	 	ACT_SIGNAL_HALT,
		laugh = 	ACT_GMOD_TAUNT_LAUGH,
		muscle = 	ACT_GMOD_TAUNT_MUSCLE,
		pers = 	 	ACT_GMOD_TAUNT_PERSISTENCE,
		wave = 	 	ACT_GMOD_GESTURE_WAVE,
		zombie = 	ACT_GMOD_GESTURE_TAUNT_ZOMBIE,
		throw = 	ACT_GMOD_GESTURE_ITEM_THROW,
		place = 	ACT_GMOD_GESTURE_ITEM_PLACE,
		give = 	 	ACT_GMOD_GESTURE_ITEM_GIVE,
		drop = 	 	ACT_GMOD_GESTURE_ITEM_DROP,
		frenzy = 	ACT_GMOD_GESTURE_RANGE_FRENZY,
		attack = 	ACT_GMOD_GESTURE_RANGE_ZOMBIE_SPECIAL,
		melee = 	ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE,
		melee2 = 	ACT_HL2MP_GESTURE_RANGE_ATTACK_MELEE2,
		poke = 		ACT_HL2MP_GESTURE_RANGE_ATTACK_SLAM,
}

concommand.Add('act2', function(pl, cmd, args)
	if t[args[1]] then
		pl:DoAnimationEvent(t[args[1]])
	end
end)
