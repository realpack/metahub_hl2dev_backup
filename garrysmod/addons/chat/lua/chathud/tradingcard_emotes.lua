hook.Add("HUDPaint", "chathud_steam_emotes_init", function()
	hook.Remove("HUDPaint", "chathud_steam_emotes_init")
	local t  = GetSteamEmoticonCache and chathud and chathud.config and chathud.config.shortcuts
	if t then
		for name,_ in next,GetSteamEmoticonCache() do
			if not tonumber(name) then
				t[name] = t[name] or "<se=" .. name .. ">"
			end
		end				print(1)
	end
end)