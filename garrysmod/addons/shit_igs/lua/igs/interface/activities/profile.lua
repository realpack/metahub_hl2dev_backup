-- Профиль, где транзакции и прогресс до след. бонуса, а также место в топе донатеров за месяц, бизнес левел
-- Прототип https://pp.vk.me/c638927/v638927381/1ec19/nQnaytZDxls.jpg (Вышло совсем не как задумано)
-- Стоимость услуги по текущему курсу

local LP
hook.Add("IGS.CatchActivities","profile",function(activity,sidebar)
	LP = LP or LocalPlayer()

	local bg = sidebar:AddPage("Информация профиля")
	local ava_bg = ui.Create("Panel",function(self)
		local y = 5

		-- Аватар
		local sw     = bg.side:GetWide() -- 220
		local margin = (sw - 184) / 2
		ui.Create("AvatarImage",self,function(ava)
			ava:SetSize(184,184)
			ava:SetPos(margin,y)
			ava:SetPlayer(LP,184)

			y = y + 184
		end)

		-- Ник
		ui.Create("DLabel",self,function(nick)
			nick:SetSize(sw,24)
			nick:SetPos(0,y)
			nick:SetFont("ui.24")
			nick:SetTextColor(IGS.col.HIGHLIGHTING)
			nick:SetText(LP:Nick())
			nick:SetContentAlignment(5)

			y = y + nick:GetTall()
		end)

		-- Стимайди
		ui.Create("DLabel",self,function(sid)
			sid:SetSize(sw,18)
			sid:SetPos(0,y)
			sid:SetFont("ui.18")
			sid:SetTextColor(IGS.col.TEXT_SOFT)
			sid:SetText("(" .. LP:SteamID() .. ")")
			sid:SetContentAlignment(5)

			y = y + sid:GetTall() + 10
		end)

		function self:AddRow(sName,sVal)
			local row_bg = ui.Create("Panel",self)
			row_bg:SetSize(sw,20) -- 20, как и размер шрифта
			row_bg:SetPos(0,y)

			-- Key
			local n = ui.Create("DLabel",row_bg,function(name)
				name:SetSize(80,row_bg:GetTall())
				name:SetPos(0,0)
				name:SetFont("ui.17")
				name:SetTextColor(IGS.col.TEXT_SOFT)
				name:SetText(sName)
				name:SetContentAlignment(6)
			end)

			-- Value
			for i,line in ipairs(string.Wrap("ui.18",sVal,sw - n:GetWide() - 5)) do
				ui.Create("DLabel",row_bg,function(val)
					val:SetSize(sw - n:GetWide() - 5,n:GetTall())
					val:SetPos(n:GetWide() + 5,(i - 1) * val:GetTall())
					val:SetFont("ui.18")
					val:SetTextColor(IGS.col.TEXT_HARD)
					val:SetText(line)

					y = y + val:GetTall()
					row_bg:SetTall(row_bg:GetTall() + val:GetTall())
				end)
			end

			self:SetTall(y + 5)
		end

		self:SetTall(y + 5)
	end)

	local lvl = IGS.PlayerLVL(LP)
	local mybal  = LP:IGSFunds()
	local next_lvl = !lvl and IGS.LVL.MAP[1] or lvl:GetNext()

	ava_bg:AddRow("Статус",lvl and lvl:Name() or "Никто :(")
	if next_lvl then
		local next_desc = next_lvl:Description()

		ava_bg:AddRow("След. статус", next_lvl:Name() .. (next_desc and ("\n\n%s"):format(next_desc) or ""))
		ava_bg:AddRow("Нужно", next_lvl:Cost() - IGS.RealPrice( IGS.TotalTransaction(LP) ) .. " руб")
	end

	bg.side:AddItem(ava_bg)

	--[[-------------------------------------------------------------------------
		Основная часть фрейма
	---------------------------------------------------------------------------]]
	ui.Create("ui_table",bg,function(pnl)
		pnl:Dock(FILL)
		pnl:DockMargin(5,5,5,5)

		pnl:SetTitle("Транзакции")

		local multisv = IGS.SERVERS.TOTAL > 1
		if multisv then
			pnl:AddColumn("Сервер",100)
		else
			pnl:AddColumn("#",40)
		end

		pnl:AddColumn("Сумма",60)
		pnl:AddColumn("Баланс",60)
		pnl:AddColumn("Действие")
		pnl:AddColumn("Дата",130)

		-- Обновление списка транзакций и информации в сайдбаре
		IGS.GetMyTransactions(function(dat)
			if !IsValid(pnl) then return end -- Долго данные получались

			for i,v in ipairs(dat) do
				-- Если покупка, то пишем ее название или пишем с чем связана транзакция
				local note =
					v.note:StartWith("P: ") and IGS.GetItemByUID(v.note:sub(4)):Name() or
					v.note:StartWith("A: ") and ("Пополнение счета (" .. v.note:sub(4) .. ")") or
					v.note:StartWith("C: ") and ("Купон " .. v.note:sub(4,13) .. "...") or
					v.note

				pnl:AddLine(
					-- v.id,
					multisv and IGS.ServerName(v.serv) or #dat - i + 1,
					v.sum,
					math.Truncate(mybal,2), -- не представляю как, но временами получались очень большие копейки
					note,
					IGS.TimestampToDate(v.date,true)
				):SetTooltip(("%s\n\nID транзакции в системе: %i%s"):format(
					note,
					v.id,
					note ~= v.note and ("\nОригинальная отметка: " .. v.note) or ""
				))

				mybal = mybal - v.sum
			end

			local spent = IGS.isUser(LP) and (IGS.TotalTransaction(LP) - mybal) or 0

			local first = dat[ #dat ]
			ava_bg:AddRow("## Операций",#dat .. " шт.")
			ava_bg:AddRow("∑ Операций",IGS.SignPrice(spent))
			ava_bg:AddRow("1 Операция",first and IGS.TimestampToDate(first.date) or "Не было")

			IGS.AddButton(bg.side,"Активировать купон",IGS.WIN.ActivateCoupon) --.button:SetActive(true)

			bg.side:AddItem(ui.Create("Panel",function(s)
				s:SetTall(5)
			end))

		end)
	end)

	activity:AddTab("Профиль",bg,"materials/vgui/icons/fa32/user.png")
end)

-- IGS.UI()