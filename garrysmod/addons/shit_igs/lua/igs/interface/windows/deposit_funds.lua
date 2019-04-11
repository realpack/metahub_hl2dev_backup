local function niceSum(i, iFallback)
	return math.Truncate(tonumber(i) or iFallback, 2)
end


local m
function IGS.WIN.Deposit(iRealSum)
	if IsValid(m) then return end -- не даем открыть 2 фрейма
	iRealSum = tonumber(iRealSum)

	hook.Run("IGS.OnDepositWinOpen",iRealSum)

	local cd = !IGS.IsCurrencyEnabled() -- cd = currency disabled. Bool
	local realSum = iRealSum and niceSum(iRealSum) or IGS.GetMinCharge()

	m = ui.Create("iFrame",function(self)
		self:SetSize(450,400)
		self:Center()

		-- Вы, конечно, можете удалить наш копирайт. Чтобы вы не перенапряглись, я даже подготовил чуть ниже строчку для этого
		-- Но прежде, чем ты это сделаешь, ответь себе на вопрос. Нахуя? Так мешает?
		self:SetTitle("Автодонат от gm-donate.ru")
		-- self:SetTitle("Владелец этого сервера мразь, не ценящая чужой труд")

		self:MakePopup()
		-- self:Focus()
		-- self:SetBackgroundBlur(false)

		--[[-------------------------------------
			Левая колонка. Реальная валюта
		---------------------------------------]]
		ui.Create("DLabel",self,function(real)
			real:SetSize(cd and 450 or 180,25)
			real:SetPos(cd and 0 or 10,self:GetTitleHeight())
			real:SetText(cd and "Введите ниже сумму пополнения счета" or "Рубли")
			real:SetFont("ui.22")
			real:SetTextColor(IGS.col.HIGHLIGHTING)
			real:SetContentAlignment(2)
		end)

		self.real_m = ui.Create("DTextEntry",self)
		self.real_m:SetPos(10,50)
		self.real_m:SetSize(cd and 450 - 10 - 10 or 180,30)
		self.real_m:SetNumeric(true)
		self.real_m.OnChange = function(s)
			if cd then return end
			self.curr_m:SetValue(IGS.PriceInCurrency( niceSum(s:GetValue(),0) )) -- бля
		end
		self.real_m.Think = function(s)
			if cd then
				self.purchase:SetText(
					"Пополнить счет на " .. niceSum(self.real_m:GetValue(),0) .. " руб"
				)
			else
				self.purchase:SetText(
					"Пополнить на " .. IGS.SignPrice( niceSum(self.curr_m:GetValue(),0) ) ..
					" за " .. niceSum(self.real_m:GetValue(),0) .. " руб"
				)
			end
		end

		--[[-------------------------------------
			Середина. Знак равности и кнопка покупки
		---------------------------------------]]
		if !cd then
			ui.Create("DLabel",self,function(eq)
				eq:SetSize(50,30)
				eq:SetPos(200,50)
				eq:SetText("=")
				eq:SetFont("ui.40")
				eq:SetTextColor(IGS.col.TEXT_HARD)
				eq:SetContentAlignment(5)
			end)
		end

		self.purchase = ui.Create("iButton",self,function(p)
			local _,ry = self.real_m:GetPos()

			p:SetSize(400,40)
			p:SetActive(true) -- выделяет синим
			p:SetPos((self:GetWide() - p:GetWide()) / 2,ry + self.real_m:GetTall() + 10)

			p.DoClick = function()
				local want_money = niceSum(self.real_m:GetValue())
				if !want_money then
					self.log:AddRecord("Указана некорректная сумма пополнения", false)
					return

				elseif want_money < realSum then
					self.log:AddRecord("Минимальная сумма пополнения " .. PL_MONEY(realSum), false)
					return
				end

				self.log:AddRecord("Запрос цифровой подписи запроса от сервера...")

				IGS.GetPaymentURL(want_money,function(url)
					local f = IGS.OpenURL(url,"Процедура пополнения счета")
					if f then -- будет nil, если оверлей браузер включен
						f:SetBackgroundBlur(false)
					end

					self.log:AddRecord("Подпись получена. начинаем процесс оплаты")

					timer.Simple(.7,function()
						self.log:AddRecord("Счет пополнится моментально или после перезахода")
					end)
				end)
			end
		end)

		--[[-------------------------------------
			Правая колонка. Донат валюта
		---------------------------------------]]
		if !cd then
			ui.Create("DLabel",self,function(curr)
				curr:SetSize(180,25)
				curr:SetPos(self:GetWide() - 10 - curr:GetWide(),self:GetTitleHeight())
				curr:SetText(IGS.C.CURRENCY_NAME)
				curr:SetFont("ui.22")
				curr:SetTextColor(IGS.col.HIGHLIGHTING)
				curr:SetContentAlignment(2)
			end)

			self.curr_m = ui.Create("DTextEntry",self)
			self.curr_m:SetPos(self:GetWide() - 10 - self.real_m:GetWide(),50)
			self.curr_m:SetSize(self.real_m:GetWide(),self.real_m:GetTall())
			self.curr_m:SetNumeric(true)
			self.curr_m.OnChange = function(s)
				self.real_m:SetValue(IGS.RealPrice( niceSum(s:GetValue(),0) )) -- тоже бля
			end
		end

		--[[-------------------------------------------------------------------------
			Должно быть после self.curr_m
		---------------------------------------------------------------------------]]
		self.real_m:SetValue( realSum )
		self.real_m:OnChange()


		--[[-------------------------------------------------------------------------
			Все подряд
		---------------------------------------------------------------------------]]
		self.log = ui.Create("iScroll",self,function(log)
			log:SetSize(250,200)
			log:SetPos(10,self:GetTall() - log:GetTall() - 10)
			-- https://img.qweqwe.ovh/1487171563683.png
			function log:AddRecord(text,pay)
				local col =
					(pay == true  and IGS.col.LOG_SUCCESS) or
					(pay == false and IGS.col.LOG_ERROR)   or IGS.col.LOG_NORMAL

				-- Платеж или Ошибка
				if pay or pay == false then
					self:GetParent():RequestFocus()
					self:GetParent():MakePopup()
				end

				return log:AddItem( ui.Create("Panel",log,function(bg)
					text = "> " .. os.date("%H:%M:%S",os.time()) .. "\n" .. text

					local y = 2
					for i,line in ipairs(string.Wrap("ui.18",text,log:GetWide() - 0 - 0)) do
						ui.Create("DLabel",bg,function(l)
							l:SetPos(0,y)
							l:SetText(line)
							l:SetFont("ui.18")
							l:SizeToContents()
							l:SetTextColor(i == 1 and IGS.col.HIGHLIGHTING or col)
							--               /\ первой строкой идет дата (\n)

							y = y + l:GetTall()
						end)
					end

					bg:SetTall(y + 2)
					log:ScrollTo(log:GetCanvas():GetTall())
				end) )
			end
		end)

		local log_t = ui.Create("DLabel",self,function(log_title)
			local log_x,log_y = self.log:GetPos()

			log_title:SetSize(self.log:GetWide(),22)
			log_title:SetPos(log_x,log_y - log_title:GetTall())
			log_title:SetText("Лог операций")
			log_title:SetTextColor(IGS.col.HIGHLIGHTING)
			log_title:SetFont("ui.22")
			log_title:SetContentAlignment(1)
		end)

		-- Линия над логом и кнопкой
		local _,log_t_y = log_t:GetPos()
		ui.Create("DPanel", function(line)
			line:SetPos(10, log_t_y - 2 - 10)
			line:SetSize(self:GetWide() - line:GetPos() * 2, 2)
			line.Paint = function(s, w, h)
				draw.RoundedBox(0,0,0,w,h,IGS.col.SOFT_LINE)
			end
		end, self)


		local coupon = ui.Create("iButton",function(btn)
			local _,log_y = self.log:GetPos()

			btn:SetSize(170, 30)
			btn:SetPos(self:GetWide() - 10 - btn:GetWide(),log_y - 20)
			btn:SetText("Активировать купон")
			btn.DoClick = function()
				IGS.WIN.ActivateCoupon()
			end
		end, self)


		-- ui.Create("DLabel",self,function(btns_title)
		-- 	local coup_x,coup_y = coupon:GetPos()

		-- 	btns_title:SetSize(coupon:GetWide(),30)
		-- 	btns_title:SetPos(coup_x,coup_y + coupon:GetTall() + 0)
		-- 	btns_title:SetText("Все автоматизировано")
		-- 	btns_title:SetTextColor(IGS.col.TEXT_HARD)
		-- 	btns_title:SetFont("ui.18")
		-- 	-- btns_title:SetContentAlignment(3)
		-- end)

		local function log(delay,text,status)
			timer.Simple(delay,function()
				if !IsValid(self.log) then return end
				self.log:AddRecord(text, status)
			end)
		end

		log(0,"Открыт диалог пополнения счета",nil)
		log(math.random(3),"Соединение установлено!",true) -- пустышка, которая добавляет чувство безопасностти сделке
		log(math.random(20,40),"Деньги будут зачислены мгновенно и автоматически",nil)
	end)

	return m
end


hook.Add("IGS.PaymentStatusUpdated","UpdatePaymentStatus",function(dat)
	local extra_inf = IGS.IsCurrencyEnabled() and (" (" .. PL_MONEY( IGS.RealPrice(dat.orderSum) ) .. ")") or ""

	local text =
		dat.method == "check" and ("Проверка возможности платежа через " .. dat.paymentType) or
		dat.method == "pay"   and ("Начислено " .. PL_IGS(dat.orderSum) ..  extra_inf) or
		dat.method == "error" and ("Ошибка пополнения счета: " .. dat.errorMessage) or
		"С сервера пришел неизвестный метод " .. tostring(dat.method) .. " и возникла ошибка"

	if !IsValid(m) then
		IGS.ShowNotify(text,"Обновление статуса платежа")
		return
	end

	local pay = nil
	if dat.method == "pay" then
		pay = true
	elseif dat.method == "error" then
		pay = false
	end

	m.log:AddRecord(text,pay)
end)



-- if IsValid(IGS_CHARGE) then
-- 	IGS_CHARGE:Remove()
-- end

-- IGS_CHARGE = IGS.WIN.Deposit()
-- local p = IGS_CHARGE
-- -- timer.Simple(1,function()
-- -- 	p.log:AddRecord("Kek lol heh mda", false)
-- -- end)

-- timer.Simple(600,function()
-- 	if IsValid(p) then
-- 		p:Remove()
-- 		p = nil
-- 	end
-- end)