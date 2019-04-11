IGS.nw.Register("igs_lvl")
	:Write(net.WriteUInt,7) -- 127
	:Read(function()
		return IGS.LVL.Get(net.ReadUInt(7))
	end)
:SetLocalPlayer()


IGS.nw.Register("igs_balance")
	:Write(net.WriteDouble)
	:Read(net.ReadDouble)
:SetLocalPlayer() --:SetHook("OnIGSBalanceChanged")


IGS.nw.Register("igs_total_transactions")
	:Write(net.WriteUInt,17) -- 131071
	:Read(net.ReadUInt,17)
:SetLocalPlayer()


IGS.nw.Register("igs_purchases"):Write(function(v)
	net.WriteUInt(#v, 9) -- 511

	for _,id in ipairs(v) do
		net.WriteUInt(id,9)
	end
end):Read(function()

	local res = {}
	for _ = 1,net.ReadUInt(9) do
		local uid = IGS.GetItemByID( net.ReadUInt(9) ):UID()
		res[uid] = res[uid] and (res[uid] + 1) or 1
	end

	return res
end):SetLocalPlayer():SetHook("IGS.PlayerPurchasesLoaded")


-- https://img.qweqwe.ovh/1492003125937.png
IGS.nw.Register("igs_settings")
	:Write(function(t)
		net.WriteUInt(t[1],10) -- minimal charge (max 1023)
		net.WriteDouble(t[2])  -- currecy price
	end)
	:Read(function()
		return {
			net.ReadUInt(10), -- charge
			net.ReadDouble(), -- price
		}
	end)
:SetGlobal():SetHook("IGS.OnSettingsUpdated")

IGS.nw.Register("igs_ready") -- можно переключать во время работы сервера
	:Write(net.WriteBool)
	:Read(net.ReadBool)
:SetGlobal()

function IGS.GetReady()
	return IGS.nw.GetGlobal("igs_ready") == true
end

if SERVER then
	function IGS.SetReady(b)
		b = b ~= false -- nil = true
		-- if b == IGS.GetReady() then return end -- думаю, можно раскомментить

		IGS.nw.SetGlobal("igs_ready",b)
		hook.Run("IGS.OnReady",b)
	end

	local first_time_trigger = true -- не позволяет выполниться IGS.GetMinCharge() и IGS.GetCurrencyPrice(), поскольку будет ошибка из-за nil внутри net вара
	function IGS.UpdateMoneySettings(iMinCharge,iCurrencyPrice)
		iMinCharge     = tonumber(iMinCharge)
		iCurrencyPrice = tonumber(iCurrencyPrice)

		-- Кеш старых данных
		local min_charge = first_time_trigger and 0 or IGS.GetMinCharge()
		local cur_price  = first_time_trigger and 0 or IGS.GetCurrencyPrice()
		first_time_trigger = nil

		local min_charge_changed = min_charge ~= iMinCharge
		local cur_price_changed  = cur_price  ~= iCurrencyPrice

		if min_charge_changed or cur_price_changed then
			IGS.nw.SetGlobal("igs_settings",{
				iMinCharge,
				iCurrencyPrice
			})

			hook.Run("IGS.OnSettingsUpdated")

			-- Может измениться сразу две вещи
			if min_charge_changed then
				IGS.NotifyAll("Изменена минимальная сумма пополнения: " .. ("(%s > %s руб)"):format(min_charge,iMinCharge))
			end

			if cur_price_changed then
				IGS.NotifyAll("Стоимость донат валюты изменена с " .. cur_price .. " до " .. iCurrencyPrice .. " руб за единицу")
			end
		end
	end
end