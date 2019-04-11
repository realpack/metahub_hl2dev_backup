

local meta = FindMetaTable("Player")
function meta:hasBallisticShield()
	local weapon = self:GetActiveWeapon()
	if (!IsValid(weapon)) then return false end

	local wep
	for k, v in pairs(btShield.shieldList) do
		if (self:HasWeapon(k)) then
			if (SERVER) then
				wep = {k, v}
			end

			break
		end
	end

	return (wep and (hook.Run("DoPlayerHasShield", self, weapon, wep) != false))
end

function meta:getCurrentShield()
	local wep, realWep
	for k, v in pairs(btShield.shieldList) do
		if (self:HasWeapon(k)) then
			wep = v
			realWep = self:GetWeapon(k)
			break
		end
	end

	local wwep = self:GetActiveWeapon()
	if (IsValid(wwep)) then
		if (btShield.shieldList[wwep:GetClass()]) then
			return btShield.shieldList[wwep:GetClass()], wwep
		end
	end

	return wep, realWep
end

function btShield:addHook(a, b)
	hook.Add(a, "btShield_hook", b)
end

btShield:addHook("Think", function()
	if (btShield.blocker) then
		for idx, entity in pairs(btShield.blocker) do
			if (!IsValid(entity)) then
				btShield.blocker[idx] = nil
			end
		end
	end
end)

btShield:addHook("PlayerPostThink", function(client)
	if (IsValid(client) and client:hasBallisticShield() == true) then

		btShield.blocker[client:EntIndex()] = client
		local curShield, weapon = client:getCurrentShield()

		if (client:GetNWBool("btShield.hasBali") != true) then
			client:SetNWBool("btShield.hasBali", true)
		end

		client:SetNWEntity("btShield.weapon", weapon)
		client:SetNWString("btShield.class", curShield)

		if (!weapon.nextHeal or weapon.nextHeal < CurTime()) then
			local info = btShield.shieldInfo[curShield]

			if (info) then
				local health = weapon:GetDTInt(0, info.game.health)
				if (health < info.game.health) then
					weapon:SetDTInt(0,  math.min(health + info.game.regenHealth, info.game.health))

					weapon.nextHeal = weapon.nextHeal or CurTime()
					weapon.nextHeal = CurTime() + 0.5
				end

				if (health > 0) then
					weapon:SetDTBool(0, false)
				end
			end

		end
	else
		if (client:GetNWBool("btShield.hasBali", false) != false) then
			client:SetNWBool("btShield.hasBali", false)
		end

		if (client:GetNWEntity("btShield.weapon")) then
			client:SetNWEntity("btShield.weapon", nil)
		end
		if (client:SetNWString("btShield.class")) then
			client:SetNWString("btShield.class", nil)
		end
	end
end)
