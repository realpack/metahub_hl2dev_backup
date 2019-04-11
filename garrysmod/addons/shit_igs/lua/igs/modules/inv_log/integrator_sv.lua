hook.Add("IGS.PlayerBoughtGift",    "IL.Integration", function(owner, UID, invDbID)
	IGS.IL.Log(invDbID, UID, owner:SteamID64(), owner:SteamID64(), IGS.IL.NEW)
end)

hook.Add("IGS.PlayerActivatedGift", "IL.Integration", function(owner, UID, invDbID)
	IGS.IL.Log(invDbID, UID, owner:SteamID64(), owner:SteamID64(), IGS.IL.ACT)
end)

hook.Add("IGS.PlayerDroppedGift",   "IL.Integration", function(owner, UID, invDbID)
	IGS.IL.Log(invDbID, UID, owner:SteamID64(), owner:SteamID64(), IGS.IL.DROP)
end)

hook.Add("IGS.PlayerPickedGift",    "IL.Integration", function(owner, UID, invDbID, picker)
	if !IsValid(owner) then return end -- самодельный гифт
	IGS.IL.Log(invDbID, UID, owner:SteamID64(), picker:SteamID64(), IGS.IL.PICK)
end)
