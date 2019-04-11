-- Для предложения совершения покупок в определенных ситуациях
-- /igsitem group_premium_30d


if SERVER then
	local function RunCommand(c)
		return function(pl,arg)
			pl:RunCommand(c,arg)
		end
	end

	IGS.WIN = IGS.WIN or {}
	IGS.WIN.Item    = RunCommand("IGSItem")
	IGS.WIN.Group   = RunCommand("IGSGroup")
	IGS.WIN.Deposit = RunCommand("IGSDeposit")
end

-- ДОЛЖНО БЫТТЬ ПОД SERVER, ПОТОМУ ЧТО ЕСЛИ В RunOnClient ПОЙДЕТ nil, ТО КОМАНДА НЕ БУДЕТ РАБОТАТЬ
local function strCMD(c,cb)
	return cmd(c):RunOnClient(cb):AddParam(cmd.STRING)
end

strCMD("IGSItem",IGS.WIN.Item)
strCMD("IGSDeposit",IGS.WIN.Deposit)
strCMD("IGSGroup",IGS.WIN.Group)

--[[----------------------------------------------
-- AMD():RunCommand("igsdeposit",10)
-- IGS.WIN.Deposit(AMD(),50)
-- prt(cmd.GetTable["igsdeposit"])
-- cmd.GetTable["igsdeposit"].ClientCallback(50)
------------------------------------------------]]