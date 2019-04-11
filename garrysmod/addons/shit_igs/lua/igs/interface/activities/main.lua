local null = function() end
local etoGlavnayaVkladkaBlya = true

hook.Add("IGS.CatchActivities","main",function(activity,sidebar)
	-- Зона прокрутки последних покупок http://joxi.ru/12MQQBlfzPnw2J
	local bg = sidebar:AddPage("Последние покупки")

	-- Панель тегов и готовая кнопка сброса фильтров
	local tagspan = ui.Create("Panel",bg)
	tagspan:SetWide(activity:GetWide())
	tagspan.Paint = function(s,w,h)
		IGS.S.Panel(s,w,h,nil,nil,nil,true)
	end

	-- сетка https://img.qweqwe.ovh/1487714173294.png
	bg.tags = ui.Create("DIconLayout",tagspan,function(tags)
		tags:SetWide(activity:GetWide() - 5 - 5)
		tags:SetPos(5,5)
		tags:SetSpaceX(10)
		tags:SetSpaceY(10)
		tags.Paint = null

		function tags:AddTag(sName,doClick)
			local tag = ui.Create("iButton")
			tag:SetTall(18)
			tag:SetText(" " .. sName .. " ") -- пробелы для расширения кнопки
			tag:SizeToContents()
			tag.DoClick = doClick

			self:Add(tag)

			tags:InvalidateLayout(true) -- tags:GetTall()
			tagspan:SetTall(tags:GetTall() + 5 + 5)

			local y = tagspan:GetTall()
			if bg.banner then
				y = y + 5
				bg.banner:SetPos(5,y)
				y = y + bg.banner:GetTall() + 5
			end

			-- Расхождение вот тут:
			-- https://img.qweqwe.ovh/1493840355855.png
			y = y - 10

			bg.categs:SetTall(activity:GetTall() - y - activity.tabBar:GetTall())
			bg.categs:SetPos(0,y)
			return tag
		end
	end)

	local filtered = {}
	for i = 1,#IGS.C.Banners.LIST do
		if IGS.C.Banners.LIST[i].Filter(LocalPlayer()) ~= false then
			filtered[#filtered + 1] = IGS.C.Banners.LIST[i]
		end
	end

	if #filtered > 0 then
		local banner = filtered[math.random(#filtered)]

		bg.banner = ui.Create("wmat_ui",bg,function(b)
			b:SetSize(activity:GetWide() - 5 - 5,banner.Tall)
			b:SetURL(banner.URL)
		end)

		ui.Create("DButton",bg.banner,function(bbg)
			bbg:SetSize(bg.banner:GetSize())
			bbg:SetText("")
			bbg.Paint = null
			bbg.DoClick = banner.Action
		end)
	end

	bg.categs = ui.Create("panels_layout_list",bg) -- center panel
	bg.categs:DisableAlignment(true)
	bg.categs:SetWide(activity:GetWide())


	-- category = true
	local cats = {}

	local function addItems(fItemsFilter,fGroupFilter)
		local rows = {}

		for name,GROUP in pairs( IGS.GetGroups() ) do
			if fGroupFilter and fGroupFilter(GROUP) == false then continue end

			local pnl = ui.Create("igs_group"):SetGroup(GROUP)
			pnl.category = GROUP:Items()[1].item:Category() -- предполагаем, что в одной группе будут итемы одной категории

			table.insert(rows,pnl)
		end

		-- не (i)pairs, потому что какой-то ID в каком-то очень редком случае может отсутствовать
		-- если его кто-то принудительно занилит, чтобы убрать итем например.
		-- Хотя маловероятно, но все же
		for _,ITEM in pairs(IGS.GetItems()) do
			if fItemsFilter and fItemsFilter(ITEM) == false then continue end
			if ITEM:Group() then continue end -- группированные итемы засунуты в группу выше
			if ITEM.isnull  then continue end -- пустышка

			local pnl = ui.Create("igs_item"):SetItem(ITEM)
			pnl.category = ITEM:Category()

			table.insert(rows,pnl)
		end

		for _,pnl in ipairs(rows) do
			bg.categs:Add(pnl,pnl.category or "Разное").title:SetTextColor(IGS.col.TEXT_HARD) -- http://joxi.ru/Y2LqqyBh5BODA6
			cats[pnl.category or "Разное"] = true
		end
	end
	addItems()



	--[[-------------------------------------------------------------------------
		Теги (Быстрый выбор категории)
	---------------------------------------------------------------------------]]
	bg.tags:AddTag("Сброс фильтров",function() bg.categs:Clear() addItems() end)
		:SetActive(true)

	for categ in pairs(cats) do
		bg.tags:AddTag(categ,function(self)
			bg.categs:Clear()

			-- Гавнище
			addItems(function(ITEM)
				return self.categ == "Разное" and !ITEM:Category() or (ITEM:Category() == self.categ)
			end,function(GROUP)
				return self.categ == "Разное" and !GROUP:Items()[1].item:Category() or (GROUP:Items()[1].item:Category() == self.categ)
			end)
		end).categ = categ
	end



	--[[-------------------------------------------------------------------------
		Список последних покупок в сайдбаре
	---------------------------------------------------------------------------]]
	IGS.GetLatestPurchases(function(dat)
		if !IsValid(activity) then return end

		for _,v in ipairs(dat) do
			local b = ui.Create("Panel")
			b:SetTall(IGS.SERVERS.TOTAL > 1 and 100 or 100 - 20)
			b:DockPadding(5,5,5,5)

			local ITEM = IGS.GetItemByUID(v.item)
			if !ITEM then continue end -- подчистить таблицу и удалить предохранитель

			local pnl = ui.Create("Panel",b)
			pnl:Dock(FILL)
			pnl:DockPadding(5,5,5,5)
			pnl.Paint = IGS.S.RoundedPanel
			function pnl:AddRow(sName,value)
				local row = ui.Create("Panel",pnl)
				row:Dock(TOP)
				row:SetTall(20)
				--:DockMargin(5,5,0,5)
				--row.Paint = IGS.S.RoundedPanel

				-- key
				ui.Create("DLabel",row,function(name)
					name:Dock(LEFT)
					name:SetWide(55)
					name:SetText(sName)
					name:SetFont("ui.18")
					name:SetTextColor(IGS.col.TEXT_HARD)
					name:SetContentAlignment(6)
				end)

				ui.Create("DLabel",row,function(name)
					name:Dock(FILL)
					name:SetText(value)
					name:SetFont("ui.18")
					name:SetTextColor(IGS.col.TEXT_SOFT)
					name:SetContentAlignment(4)
				end)
			end

			-- Заголовок услуги. Легко превращается в лейбу
			ui.Create("DButton",b,function(name)
				name:Dock(TOP)
				name:SetTall(20)
				name:SetText(ITEM:Name())
				name:SetFont("ui.18")
				name:SetTextColor(IGS.col.HIGHLIGHTING)
				name:SetContentAlignment(4)
				name.Paint = null
				name.DoClick = function()
					IGS.WIN.Item(v.item)
				end
			end)

			pnl:AddRow("Купил: ",v.nick or "NoName")
			if IGS.SERVERS.TOTAL > 1 then
				pnl:AddRow("На: ",IGS.ServerName(v.serv))
			-- else
			-- 	pnl:AddRow("UID: ",v.item)
			end
			pnl:AddRow("До: ",IGS.TimestampToDate(v.expire) or "навсегда")

			bg.side:AddItem(b)
		end
	end)

	activity:AddTab("Услуги",bg,"materials/vgui/icons/fa32/dollar.png",etoGlavnayaVkladkaBlya)
end)

-- IGS.UI()