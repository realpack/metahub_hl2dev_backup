function rp.FindPlayer(info)
	if not info or (info == '') then return end
	info = tostring(info)
	for _, pl in ipairs(player.GetAll()) do
		if (info == pl:SteamID()) then
			return pl
		elseif (info == pl:SteamID64()) then
			return pl
		elseif string.find(string.lower(pl:Name()), string.lower(info), 1, true) ~= nil then
			return pl
		end
	end
end