
hook.Add("IGS.CatchActivities","purchases",function(activity,sidebar)
	local bg = sidebar:AddPage("Активные покупки")


	--[[-------------------------------------------------------------------------
		Основная часть фрейма
	---------------------------------------------------------------------------]]
	ui.Create("ui_table",bg,function(pnl)
		pnl:Dock(FILL)
		pnl:DockMargin(5,5,5,5)

		pnl:SetTitle("Активные покупки")

		local multisv = IGS.SERVERS.TOTAL > 1
		if multisv then
			pnl:AddColumn("Сервер",100)
		else
			pnl:AddColumn("#",40)
		end

		pnl:AddColumn("Предмет")
		pnl:AddColumn("Куплен",90)
		pnl:AddColumn("Истечет",90)


		IGS.GetMyPurchases(function(d)
			if !IsValid(pnl) then return end -- Долго данные получались, фрейм успели закрыть

			IGS.AddTextBlock(bg.side,"Что тут?",
				#d == 0 and
					"Здесь будут отображаться ваши активные покупки\n\n" ..
					"Не самое ли подходящее время, чтобы совершить первую?\n\n" ..
					"Табличка сразу станет красивее. Честно-честно"
					or
					"Слева отображаются ваши активные услуги.\n\n" ..
					"Чем больше услуг, тем красивее эта табличка выглядит, а администрация более счастливая ;)"
			)

			IGS.AddButton(bg.side,"Купить плюшку",function()
				local random_ITEM = table.Random(IGS.GetItems())

				IGS.WIN.Item(random_ITEM:UID())
			end)

			for i,v in ipairs(d) do
				local sv_name = IGS.ServerName(v.serv)
				pnl:AddLine(
					-- v.id,
					multisv and sv_name or #d - i + 1,
					IGS.GetItemByUID(v.item):Name(),
					IGS.TimestampToDate(v.purchase) or "Никогда",
					IGS.TimestampToDate(v.expire)   or "Никогда"
				):SetTooltip("Имя сервера: " .. sv_name .. "\nID в системе: " .. v.id .. "\nОригинальное название: " .. v.item)
			end
		end)
	end)

	activity:AddTab("Покупки",bg,"materials/vgui/icons/fa32/list.png")
end)

-- IGS.UI()