--[[-------------------------------------------------------------------------
	Отображение ТОП пополнения
---------------------------------------------------------------------------]]
local SUM,TIME,SID,NAME =
	"igs:hugecharge_sum",
	"igs:hugecharge_time",
	"igs:hugecharge_sid",
	"igs:hugecharge_name"


local function resetHugeCharge()
	bib.delete(SUM)
	bib.delete(TIME)
	bib.delete(SID)
	bib.delete(NAME)

	-- cprint("Сбросили")
end

local function setHugeCharge(sum, sid, nick)
	bib.set(SUM,  sum)
	bib.set(TIME, os.time()) --+ 60*60*24*2) -- +2 дня
	bib.set(SID,  sid)
	bib.set(NAME, nick)
end

local function getHugeCharge(bSumOnly)
	if bSumOnly then -- микрооптимизация
		return tonumber(bib.get(SUM))
	end

	return {
		sum  = tonumber(bib.get(SUM)),
		time = tonumber(bib.get(TIME)),
		sid  = bib.get(SID),
		nick = bib.get(NAME)
	}
end

-- print(getHugeCharge())
-- setHugeCharge(1,AMD():SteamID64(),"_AMD_")




-- Если есть запись о предыдущем рекорде и сейчас час/день/неделя/месяц меньше, чем было в предыдущей записи
-- значит день/неделя/месяц/год начались сначала и пора удалять эту запись, чтобы начать учет сначала
local prev_rec = getHugeCharge()
-- cprint(os.date(IGS.C.TopDon_Periodicity))
-- cprint(os.date(IGS.C.TopDon_Periodicity,prev_rec.time))

if prev_rec and os.date(IGS.C.TopDon_Periodicity) < os.date(IGS.C.TopDon_Periodicity,prev_rec.time) then
	resetHugeCharge()
end



local function charge(pl, sum)
	sum = tonumber(sum)

	if sum > (getHugeCharge(true) or 0) then
		local pr = getHugeCharge() -- Previous Record

		local s = pr.nick and IGS.C.TopDon_TextRecord or IGS.C.TopDon_TextFirstDon

		-- Не первый донат
		if pr.nick then
			local s32 = util.SteamIDFrom64(pr.sid)

			s = s
			:gsub("$nick_prev", ("%s(%s)"):format(pr.nick,s32) )
			:gsub("$sum_prev",pr.sum)
		end

		s = s
		:gsub("$nick",pl:Nick())
		:gsub("$sum",sum)

		IGS.NotifyAll(s)

		setHugeCharge(sum,pl:SteamID64(),pl:Nick())
	end
end

-- charge(AMD(),6)


hook.Add("IGS.PaymentStatusUpdated","TopDonateEcho",function(pl, dat)
	if IGS.C.TopDon_Echo and dat.method == "pay" then
		charge(pl,dat.orderSum)
	end
end)
