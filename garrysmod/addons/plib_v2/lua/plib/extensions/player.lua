function player.FindByInfo(info)
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

local PLAYER = FindMetaTable('Player')

function PLAYER:Timer(name, time, reps, callback, failure)
	name = self:SteamID64() .. '-' .. name
	timer.Create(name, time, reps, function()
		if IsValid(self) then
			callback(self)
		else
			if (failure) then
				failure()
			end
			
			timer.Destroy(name)
		end
	end)
end

function PLAYER:DestroyTimer(name)
	timer.Destroy(self:SteamID64() .. '-' .. name)
end