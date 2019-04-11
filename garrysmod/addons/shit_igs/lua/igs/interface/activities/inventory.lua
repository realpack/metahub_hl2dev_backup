local function loadTab(activity,sidebar,dat)
	local bg = sidebar:AddPage("Действия над итемом")
	IGS.AddTextBlock(bg.side, nil, #dat > 0 and
		"Выберите предмет, чтобы получить по нему список действий" or

		"Купленные предметы будут находится здесь." ..
		"\n\nБлагодаря инвентарю вы можете поделиться покупкой со своим другом, у которого не хватает денег на покупку услуги. " ..
			"Просто купите ее вместо него и бросьте на пол. После активации предмета он появится у него в инвентаре." ..
		"\n\nДобрые саморитяне используют инвентарь для устраивания классных конкурсов. " ..
			"Они набивают свой инвентарь предметами, а затем при каких-то условиях их раздают"
	)

	bg.OnRemove = function()
		hook.Remove("IGS.OnSuccessPurchase","UpdateInventoryView")
	end

	local act_tall = activity:GetTall() - activity.tabBar:GetTall()

	local infpan = ui.Create("igs_iteminfo",bg,function(p)
		p:SetSize(300,act_tall) -- Dock(LEFT) SetWide(300)
		p:SetPos(0,0)
		p:SetIcon()
		p:SetName("")
		p:SetDescription("Здесь будет отображена информация о вашей покупке, когда вы ее сделаете")
	end)

	local scr = ui.Create("iScroll",bg)
	scr:SetSize(activity:GetWide() - infpan:GetWide(),act_tall)
	scr:SetPos(infpan:GetWide(),0) -- Dock(FILL)

	IGS.AddTextBlock(scr,"Ваш инвентарь","Что-то тут пустовато. Надо бы купить че-нить, правда?")

	scr:AddItem( ui.Create("DIconLayout",function(icons)
		icons:SetWide(scr:GetWide())
		icons:SetSpaceX(2)
		icons:SetSpaceY(2)
		icons.Paint = function() end

		local function removeFromCanvas(itemPan)
			bg.side:Reset()
			infpan:Reset()
			itemPan:Remove()
		end

		function icons:AddItem(ITEM,dbID,isGlobal,iAmount)
			iAmount = 1

			local item = icons:Add("igs_item")
			item:SetSize(icons:GetWide(),60)
			item:SetIcon(ITEM:ICON())
			item:SetName(ITEM:Name())
			item:SetSign("Действует " .. IGS.TermToStr(ITEM:Term()) .. (isGlobal and "\nНа всех серверах сразу" or ""))
			item.DoClick = function()
				infpan:Reset()
				infpan:SetIcon(ITEM:ICON())
				infpan:SetName(ITEM:Name())
				infpan:SetImage(ITEM:IMG())
				infpan:SetSubNameButton(ITEM:Group() and ITEM:Group():Name(), function()
					IGS.WIN.Group(ITEM:Group():UID())
				end)
				infpan:SetDescription(ITEM:Description())
				infpan:SetInfo(IGS.FormItemInfo(ITEM))


				bg.side:Reset()

				local function actText(i)
					return ("Активировать" .. (i == 1 and "" or " (%i/%i)")):format(i, 5) -- ITEM:InStack()
				end

				local act_btn = IGS.AddButton(bg.side, "",function()
					local uses_left = iAmount
					IGS.ProcessActivate(dbID,function(err)
						if err then return end

						uses_left = uses_left - 1

						if uses_left ~= 0 then
							act_btn:SetText(actText(uses_left))
						else
							removeFromCanvas(item)
						end
					end)
				end).button
				act_btn:SetActive(true)
				act_btn:SetText(actText(iAmount))

				-- if !IGS.C.Inv_AllowDrop then return end
				IGS.AddButton(bg.side,"Бросить на пол",function()
					IGS.DropItem(dbID,function()
						removeFromCanvas(item)
					end)
				end)
			end
		end

		for _,v in ipairs(dat) do
			icons:AddItem( IGS.GetItemByUID(v.data.uid), v.id, v.data.global, v.data.amount )
		end

		hook.Add("IGS.OnSuccessPurchase","UpdateInventoryView",function(ITEM, _, invDbID)
			icons:AddItem(ITEM, invDbID, ITEM:IsGlobal()) -- TODO добавить ITEM:GetInStack()
		end)


	end) )

	scr:AddItem(ui.Create("Panel",function(end_margin)
		end_margin:SetTall(5)
	end))

	activity:AddTab("Инвентарь",bg,"materials/vgui/icons/fa32/cart-plus.png")
end

hook.Add("IGS.CatchActivities","inventory",function(activity,sidebar)
	if !IGS.C.Inv_Enabled then return end

	IGS.GetInventory(function(items)
		if !IsValid(sidebar) then return end
		loadTab(activity,sidebar,items)
	end)
end)

-- IGS.UI()