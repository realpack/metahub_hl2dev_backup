local m

local function purchase(ITEM,at_all,buy_button)
	IGS.Purchase(ITEM:UID(),at_all,function(errMsg,dbID)
		if !IsValid(buy_button) then return end

		if errMsg then
			IGS.ShowNotify(errMsg, "Ошибка покупки")
			return
		end

		buy_button.purchased = buy_button.purchased or 0
		buy_button.purchased = buy_button.purchased + 1

		if ITEM:IsStackable() then
			buy_button:SetText("Куплено " .. buy_button.purchased .. " шт")
		else
			if IsValid(m) then
				m:Remove()
			end

			if !IGS.C.Inv_Enabled then
				IGS.ShowNotify("Спасибо за покупку. Это было просто, правда? :)", "Успешная покупка")
				return
			end

			IGS.BoolRequest("Успешная покупка",
				"Спасибо за покупку. Она находится в вашем /donate инвентаре.\n\nАктивировать ее сейчас?",
			function(yes)
				if !yes then return end

				IGS.ProcessActivate(dbID)
			end)
		end

	end)
end






local function move(f, x, sp, cb)
	local _,y = f:GetPos()
	f:MoveTo(x,y, sp,nil,nil,cb)
end

local function shakeFrame(f, amplitude, speed, cb)
	if !IsValid(f) then return end

	local x = f:GetPos()
	move(f, x + amplitude, speed, function()
		move(f, x - amplitude, speed, function()
			move(f, x, speed, cb)
		end)
	end)
end

function IGS.WIN.Item(uid)
	local ITEM = IGS.GetItemByUID(uid)
	if IsValid(m) then
		if m.item_uid == uid then -- попытка повторного открытия того же фрейма

			m:MoveToFront()
			shakeFrame(m, 20, .1)

			return
		end

		-- Открытия другого
		m:Remove()
		m = nil
	end

	m = ui.Create("iFrame",function(self)
		self:SetSize(330,550)
		self:Center()
		self:MakePopup()
		self:SetTitle(ITEM:Name())

		self.item_uid  = uid -- для предотвращения повторного открытия двух одинаковых фреймов
	end)


	ui.Create("igs_iteminfo",m,function(p)

		--[[-------------------------------------------------------------------------
			Очень не красивый, но очень полезный код
			Заставляет ползунок помигать для заметности
		---------------------------------------------------------------------------]]
		local viewed = tonumber( bib.get("igs:items_viewed",0) )
		bib.set("igs:items_viewed",viewed + 1)

		-- Если мигали 3+ раза, то больше не надо
		if viewed < 3 then
			local oldThink = p.scroll.scrollBar.Think
			timer.Simple(.5,function() -- 0.5 = время, которое скролл будет мигать
				if !IsValid(p) then return end

				p.scroll.scrollBar.Think = oldThink
			end)

			p.scroll.scrollBar.Think = function(s,w,h) --           \/ скорость мигания
				p.scroll.scrollBar.addWidth = (math.sin( CurTime() * 20 ) + 1) / 2 * 8 -- 8 лимит ширины скролла
				p.scroll.scrollBar:InvalidateLayout()
			end
		end
		-----------------------------------------------------------------------------



		p:Dock(FILL)
		p:SetIcon(ITEM:ICON())
		p:SetName("Действует " .. IGS.TermToStr(ITEM:Term()))
		p:SetImage(ITEM:IMG())
		p:SetSubNameButton(ITEM:Group() and ITEM:Group():Name(), function()
			IGS.WIN.Group(ITEM:Group():UID())
		end)
		p:SetDescription( ITEM:Description() )
		p:SetInfo(IGS.FormItemInfo(ITEM))

		m.act = p:CreateActivity() -- панелька для кастом эллементов
		m.buy = ui.Create("iButton", m.act, function(buy)
			local cur_price = ITEM:PriceInCurrency()

			buy:Dock(TOP)
			buy:SetTall(20)
			buy:SetText( "Купить за " .. PL_IGS(cur_price) )
			buy:SetActive( IGS.CanAfford(LocalPlayer(), cur_price) )
			buy.DoClick = function(s)
				if !s:IsActive() then
					local need = cur_price - LocalPlayer():IGSFunds()

					IGS.BoolRequest(
						"Недостаточно денег",
						("Вам не хватает %s для покупки %s.\nЖелаете мгновенно, в два клика пополнить счет?"):format( PL_IGS(need), ITEM:Name()),
						function(yes)
							if !yes then return end

							IGS.WIN.Deposit(need,true)
						end
					):ShowCloseButton(true)

					return
				end

				-- Мгновенное действие, например, покупка валюты
				-- Такие действия невозможно совершать сразу на всех серверах
				if ITEM:Term() == 0 or ITEM:IsGlobal() or !IGS.C.EnableMultiServerDiscount or IGS.SERVERS.ENABLED == 1 then
					purchase(ITEM,false,s) -- /\ или отключена покупка на нескольких серверах сразу

					return
				end

				local currency_price = ITEM:PriceInCurrency()
				local multiprice     = IGS.MultiServerDiscount(currency_price)
				local econom         = PL_IGS(currency_price * IGS.SERVERS.ENABLED - multiprice)
				local modal = IGS.BoolRequest(
					"Выгодное предложение!",
					"Вы можете купить " .. ITEM:Name() .. " сразу на " .. IGS.SERVERS.ENABLED .. " наших серверах за " .. PL_IGS(multiprice) .. ", сэкономив при этом " .. econom,
					function(yes) purchase(ITEM,yes,s) end
				)

				modal:ShowCloseButton(true)
				modal.btnOK:SetText("Купить на всех")
				modal.btnCan:SetText("Только на этом")
			end
		end)
	end)

	hook.Run("IGS.OnItemInfoOpen", ITEM, m)
end

-- IGS.WIN.Item("permission_model_30d")