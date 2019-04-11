CreateConVar("igs_version", IGS.Version, FCVAR_NOTIFY)

--[[-------------------------------------------------------------------------
	Чат команды
---------------------------------------------------------------------------]]
local c = cmd("igs",IGS.UI)
for command in pairs(IGS.C.COMMANDS) do
	c:AddAlias(command)
end



--[[-------------------------------------------------------------------------
	Полезные функции. Могут пригодиться
---------------------------------------------------------------------------]]
-- Сумма всех настоящих пополнений игрока в Alc. Полезно для выяснения платежеспособности
function IGS.GetChargesSum(s64, fCallback)
	IGS.GetTransactions(function(transactions)
		local total_charges = 0
		for _,tra in ipairs(transactions) do
			-- Пополнение
			if tra.Note and tra.Note:StartWith("A: ") then
				total_charges = total_charges + tra.Sum
			end
		end

		fCallback(total_charges)
	end, s64)
end
-- IGS.GetChargesSum(player.GetAll()[1]:SteamID64(),print)




--[[-------------------------------------------------------------------------
	Консольная команда начисления денег
---------------------------------------------------------------------------]]
local n = function(pl, msg)
	if IsValid(pl) then
		IGS.Notify(pl,msg)
	else
		print(msg)
	end
end

concommand.Add("addfunds",function(pl,_,_,argss)
	if IsValid(pl) and !pl:IsSuperAdmin() then return end

	local _,endpos, sid,amount = argss:find("^(STEAM_%d:%d:%d+) (%d+)")

	if !endpos then
		return n(pl,"Формат команды нарушен\nПример: addfunds STEAM_0:1:2345678 10 А вот это отметка транзакции")
	end

	-- Мы ведь в валюте счет должны пополнить, а не рублях
	amount = IGS.PriceInCurrency(amount)
	local note = argss:sub(endpos + 2)

	local targ = player.GetBySteamID(sid)
	if targ then
		targ:AddIGSFunds(amount,note,function()
			n(pl,"Транзакция успешно проведена. Баланс игрока: " .. PL_IGS(targ:IGSFunds()))
		end)

	-- Игрок оффлайн
	else
		IGS.Transaction(util.SteamIDTo64(sid),amount,note,function(id)
			n(pl,"Транзакция успешно проведена, но игрок не на сервере")
		end)

	end
end)


--[[-------------------------------------------------------------------------
	Открытие интерфейса кнопкой на клаве
---------------------------------------------------------------------------]]
-- http://wiki.garrysmod.com/page/Enums/KEY
hook.Add("PlayerButtonDown","IGS.UI",function(pl, iButton)
	if iButton == IGS.C.MENUBUTTON then
		cmd.Run(pl,"igs",{})
	end
end)
