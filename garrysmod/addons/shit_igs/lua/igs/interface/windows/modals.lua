function IGS.BoolRequest(title, text, cback)
	local m = ui.Create("iFrame", function(self)
		self:SetTitle(title)
		self:ShowCloseButton(false)
		self:SetWide(ScrW() * .2)
		self:MakePopup()
	end)

	local txt = string.Wrap("ui.18", text, m:GetWide() - 10)
	local y = m:GetTitleHeight() + 5

	for _,line in ipairs(txt) do
		ui.Create("DLabel", function(self, p)
			self:SetText(line)
			self:SetFont("ui.18")
			self:SetTextColor(IGS.col.TEXT_HARD)
			self:SizeToContents()
			self:SetPos((p:GetWide() - self:GetWide()) / 2, y)
			y = y + self:GetTall() + 2
		end, m)
	end

	y = y + 5
	m.btnOK = ui.Create("iButton", function(self, p)
		self:SetText("Да")
		self:SetPos(5, y)
		self:SetSize(p:GetWide() / 2 - 7.5, 25)
		self.DoClick = function(s)
			p:Close()
			cback(true)
		end
	end, m)

	m.btnCan = ui.Create("iButton", function(self, p)
		self:SetText("Нет")
		self:SetPos(p.btnOK:GetWide() + 10, y)
		self:SetSize(p.btnOK:GetWide(), 25)
		self:RequestFocus()
		self.DoClick = function(s)
			p:Close()
			cback(false)
		end
		y = y + self:GetTall() + 5
	end, m)

	m:SetTall(y)
	m:Center()

	m:Focus()
	return m
end

function IGS.StringRequest(title, text, default, cback)
	local m = ui.Create("iFrame", function(self)
		self:SetTitle(title)
		self:ShowCloseButton(false)
		self:SetWide(ScrW() * .3)
		self:MakePopup()
	end)

	local txt = string.Wrap("ui.18", text, m:GetWide() - 10)
	local y = m:GetTitleHeight() + 5

	for k, v in ipairs(txt) do
		ui.Create("DLabel", function(self, p)
			self:SetText(v)
			self:SetFont("ui.18")
			self:SetTextColor(IGS.col.TEXT_HARD)
			self:SizeToContents()
			self:SetPos((p:GetWide() - self:GetWide()) / 2, y)
			y = y + self:GetTall()
		end, m)
	end

	y = y + 5
	local tb = ui.Create("DTextEntry", function(self, p)
		self:SetPos(5, y + 5)
		self:SetSize(p:GetWide() - 10, 25)
		self:SetValue(default or '')
		y = y + self:GetTall() + 10
		self.OnEnter = function(s)
			p:Close()
			cback(self:GetValue())
		end
	end, m)

	local btnOK = ui.Create("iButton", function(self, p)
		self:SetText("ОК")
		self:SetPos(5, y)
		self:SetSize(p:GetWide() / 2 - 7.5, 25)
		self:SetActive(true)
		self.DoClick = function(s)
			p:Close()
			cback(tb:GetValue())
		end
	end, m)

	ui.Create("iButton", function(self, p)
		self:SetText("Отмена")
		self:SetPos(btnOK:GetWide() + 10, y)
		self:SetSize(btnOK:GetWide(), 25)
		self:RequestFocus()
		self.DoClick = function(s)
			m:Close()
		end
		y = y + self:GetTall() + 5
	end, m)

	m:SetTall(y)
	m:Center()

	m:Focus()
	return m
end


local null = function() end
function IGS.ShowNotify(sText, sTitle, fOnClose)
	local m = IGS.BoolRequest(sTitle or "[IGS] Оповещение", sText, fOnClose or null)
	m.btnCan:Remove() -- оставляем только 1 кнопку

	local _,y = m.btnOK:GetPos()
	m.btnOK:SetText("ОК")
	m.btnOK:SetPos((m:GetWide() - m.btnOK:GetWide()) / 2, y)

	return m
end

function IGS.WIN.ActivateCoupon()
	IGS.StringRequest("Активация купона",
		"Если у вас есть донат купон, то введите его ниже",
	nil,function(val)
		IGS.UseCoupon(val,function(errMsg)
			if errMsg then
				IGS.ShowNotify(errMsg, "Ошибка активации купона")
			else
				IGS.ShowNotify("Деньги начислены на ваш счет. Можете посмотреть на это в транзакциях, переоткрыв донат меню", "Успешная активации купона")
			end
		end)
	end)
end


function IGS.OpenURL(url,title)
	if !IGS.C.UseCustomBrowser then
		gui.OpenURL(url)
		return
	end

	local w,h = ScrW() * .9, ScrH() * .9

	local fr = ui.Create("iFrame", function(self)
		self:SetSize(w, h)
		self:SetTitle(title or url)
		self:Center()
		self:MakePopup()
	end)

	fr.html = ui.Create("iHTML", function(self)
		self:SetPos(5, 32)
		self:SetSize(w - 10, h - 37)
		self:OpenURL(url)
	end, fr)

	return fr
end


-- IGS.ShowNotify(("test "):rep(10), nil, function()
-- 	print("Нотификашка закрылась")
-- end)

-- IGS.UI()