surface.CreateFont('ui.40', {font = 'roboto', size = 40, weight = 500})
surface.CreateFont('ui.39', {font = 'roboto', size = 39, weight = 500})
surface.CreateFont('ui.38', {font = 'roboto', size = 38, weight = 500})
surface.CreateFont('ui.37', {font = 'roboto', size = 37, weight = 500})
surface.CreateFont('ui.36', {font = 'roboto', size = 36, weight = 500})
surface.CreateFont('ui.35', {font = 'roboto', size = 35, weight = 500})
surface.CreateFont('ui.34', {font = 'roboto', size = 34, weight = 500})
surface.CreateFont('ui.33', {font = 'roboto', size = 33, weight = 500})
surface.CreateFont('ui.32', {font = 'roboto', size = 32, weight = 500})
surface.CreateFont('ui.31', {font = 'roboto', size = 31, weight = 500})
surface.CreateFont('ui.30', {font = 'roboto', size = 30, weight = 500})
surface.CreateFont('ui.29', {font = 'roboto', size = 29, weight = 500})
surface.CreateFont('ui.28', {font = 'roboto', size = 28, weight = 500})
surface.CreateFont('ui.27', {font = 'roboto', size = 27, weight = 400})
surface.CreateFont('ui.26', {font = 'roboto', size = 26, weight = 400})
surface.CreateFont('ui.25', {font = 'roboto', size = 25, weight = 400})
surface.CreateFont('ui.24', {font = 'roboto', size = 24, weight = 400})
surface.CreateFont('ui.23', {font = 'roboto', size = 23, weight = 400})
surface.CreateFont('ui.22', {font = 'roboto', size = 22, weight = 400})
surface.CreateFont('ui.20', {font = 'roboto', size = 20, weight = 400})
surface.CreateFont('ui.19', {font = 'roboto', size = 19, weight = 400})
surface.CreateFont('ui.18', {font = 'roboto', size = 18, weight = 400})
surface.CreateFont('ui.17', {font = 'roboto', size = 15, weight = 550})
surface.CreateFont('ui.15', {font = 'roboto', size = 15, weight = 550})


local vguiFucs = {
	['DTextEntry'] = function(self, p)
		self:SetFont('ui.20')
	end,	
	['DLabel'] = function(self, p)
		self:SetFont('ui.22')
		self:SetColor(ui.col.White)
	end,
	['DButton'] = function(self, p)
		self:SetFont('ui.20')
	end,
	['DComboBox'] = function(self, p)
		self:SetFont('ui.22')
	end,
}

timer.Simple(0, function()
	vgui.GetControlTable('DButton').SetBackgroundColor = function(self, color)
		self.BackgroundColor = color
	end
end)

function ui.Create(t, f, p)
	local parent
	if (not isfunction(f)) and (f ~= nil) then
		parent = f
	elseif not isfunction(p) and (p ~= nil) then
		parent = p
	end

	local v = vgui.Create(t, parent)
	v:SetSkin('core')

	if vguiFucs[t] then vguiFucs[t](v, parent) end

	if isfunction(f) then f(v, parent) elseif isfunction(p) then p(v, f) end

	return v
end

function ui.Label(txt, font, x, y, parent)
	return ui.Create('DLabel', function(self, p)
		self:SetText(txt)
		self:SetFont(font)
		self:SetTextColor(ui.col.White)
		self:SetPos(x, y)
		self:SizeToContents()
		self:SetWrap(true)
		self:SetAutoStretchVertical(true)
	end, parent)
end

function ui.DermaMenu(p)
	local m = DermaMenu(p)
	m:SetSkin('core')
	return m
end

function ui.StringRequest(title, text, default, cback)
	local m = ui.Create('ui_frame', function(self)
		self:SetTitle(title)
		self:ShowCloseButton(false)
		self:SetWide(ScrW() * .3)
		self:MakePopup()
	end)
	
	local txt = string.Wrap('ui.18', text, m:GetWide() - 10)
	local y = m:GetTitleHeight() + 5

	for k, v in ipairs(txt) do
		local lbl = ui.Create('DLabel', function(self, p)
			self:SetText(v)
			self:SetFont('ui.18')
			self:SizeToContents()
			self:SetPos((p:GetWide() - self:GetWide()) / 2, y)
			y = y + self:GetTall()
		end, m)
	end
	
	local tb = ui.Create('DTextEntry', function(self, p) 
		self:SetPos(5, y + 5)
		self:SetSize(p:GetWide() - 10, 25)
		self:SetValue(default or '')
		y = y + self:GetTall() + 10
		self.OnEnter = function(s)
			p:Close()
			cback(self:GetValue())
		end
	end, m)

	local btnOK = ui.Create('DButton', function(self, p)
		self:SetText('Да')
		self:SetPos(5, y)
		self:SetSize(p:GetWide()/2 - 7.5, 25)
		self.DoClick = function(s)
			p:Close()
			cback(tb:GetValue())
		end
	end, m)

	local btnCan = ui.Create('DButton', function(self, p)
		self:SetText('Отмена')
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

function ui.PlayerReuqest(players, cback)
	if isfunction(players) then
		cback = players
		players = player.GetAll()
	end
	local m = ui.Create('ui_frame', function(self)
		self:SetTitle('Выберите игрока')
		self:SetSize(.2, .3)
		self:Center()
		self:MakePopup()
	end)
	local scr
	local x, y = m:GetDockPos()
	local tb = ui.Create('DTextEntry', function(self, p) 
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, 25)
		y = y + self:GetTall() + 5

		self.OnChange = function(s)
			scr:AddPlayers(self:GetValue())
		end

		self:RequestFocus()
	end, m)

	scr = ui.Create('ui_scrollpanel', function(self, p)
		self:SetPos(x, y)
		self:SetSize(p:GetWide() - 10, p:GetTall() - y - 5)

		function self:AddPlayer(pl)
			local p = ui.Create('DButton', function(self, p)
				self:SetTall(30)
				self:SetText(pl:Name())
				self:SetTextColor(ui.col.White)
				function self:Paint(w, h)
					if (not IsValid(pl)) then
						self:Remove()
						return
					end
					local col = pl.GetJobColor and pl:GetJobColor() or team.GetColor(pl:Team())
					col = Color(col.r,col.g,col.b,150)
					draw.OutlinedBox(0,0,w,h,col,ui.col.Outline)
				end
				function self:DoClick()
					if IsValid(pl) then
						m:Close()
						cback(pl)
					end
				end
			end)
			ui.Create('ui_avatarbutton', function(self, p)
				self:SetPos(2,2)
				self:SetSize(26, 26)
				self:SetPlayer(pl)
			end, p)
			self:AddItem(p)
		end
		function self:AddPlayers(inf)
			self:Reset()
			for k, v in ipairs(players) do
				if (v ~= LocalPlayer()) then
					if inf and string.find(v:Name():lower(), inf:lower(), 1, true) then
						self:AddPlayer(v)
					elseif (not inf) then
						self:AddPlayer(v)
					end
				end
			end
		end
		self:AddPlayers()
	end, m)

	m:Focus()
	return m
end

function ui.With(...)
	local arr = {...}
	return setmetatable({}, {
		__index = function(_, key)
			if arr[1][key] then
				return function(self, ...)
					if (self == _) then
						for k, v in ipairs(arr) do
							v[key](v, ...)
						end
					else
						error 'expected method call not function member invocation'
					end
					return self
				end
			elseif (key == 'Set') then
				return function(self, key, val)
					for k, v in ipairs(arr) do
						v[key] = val
					end
					return self
				end
			end
		end
	})
end






concommand.Add('ui_test',function()
	local fr = ui.Create('ui_frame', function(self, p)
		self:SetTitle('Test Panel')
		self:SetSize(1000, 500)
		self:Center()
		self:MakePopup()
	end)

	local tabs = ui.Create('ui_tablist', function(self)
		self:DockToFrame()
	end, fr)

	local scroll = ui.Create('ui_scrollpanel', function(self, p)
		self:SetSpacing(2)
	end)

	tabs:AddTab('Misc', scroll, true)


	local cont = ui.Create 'ui_panel'
	tabs:AddTab('List', cont)

	ui.Create('ui_listview', function(self, p)
		self:SetSize(300, 450)
		for i = 1, 35 do
			if i ~= 1 and i ~= 10 and i ~= 20 then
				self:AddRow('Row ' .. i)
			else
				self:AddSpacer('Spacer ' .. i)
			end
		end
	end, cont)

	for i =1, 5 do
		tabs:AddTab('Test ' .. i, ui.Create('ui_panel'))
	end

	for i = 1, 10 do 
		scroll:AddItem(ui.Create('DButton', function(self, p)
			self:SetText('test' .. i)
			self:SetTall(55)
			self.DoClick = function()
				local m = ui.DermaMenu(self)
				for i = 1, 5 do
					m:AddOption('Test ' .. i)
				end
				m:Open()
			end
		end))
	end
	scroll:AddItem(ui.Create('ui_panel', function(self, p)
		self:SetTall(55)
		for i = 1, 9 do
			ui.Create('ui_avatarbutton', function(self, p)
				self:SetPos(2 + (i -1) * 52,2)
				self:SetSize(50,50)
				self:SetPlayer(LocalPlayer())
			end, self)
		end
	end))

	scroll:AddItem(ui.Create('ui_panel', function(self, p)
		self:SetTall(55)
		ui.Create('ui_slider', function(self, p)
			self:SetPos(5, 5)
			self:SetWide(250)
		end, self)
	end))

	scroll:AddItem(ui.Create('ui_panel', function(self, p)
		self:SetTall(55)
		ui.Create('DTextEntry', function(self, p)
			self:SetPos(5, 5)
			self:SetSize(250, 25)
		end, self):SetValue('Sample Text')
	end))

	local s = ui.Create('ui_settingspanel')
	s:SetState('RPMenu')
	s:SetTall(200)
	scroll:AddItem( s)


	
end)
