local PANEL = {}

local dock = 5

function PANEL:Init()
	self.head = ui.Create("Panel",self)
	self.head:SetTall(100)
	self.head:Dock(TOP)
	self.head:DockPadding(dock,dock,dock,dock)
	self.head.Paint = function(s,w,h)
		IGS.S.Panel(s,w,h, nil,nil,nil,true)
	end

	self.scroll = ui.Create("iScroll",self)
	self.scroll:Dock(FILL)
end

function PANEL:SetName(sName)
	self.name = self.name or ui.Create("DLabel",self.head,function(lbl)
		lbl:Dock(TOP)
		--lbl:SetTall(22)
		lbl:SetFont("ui.22")
		lbl:SetTextColor(IGS.col.TEXT_HARD)
		lbl:SetWrap(true)
		lbl:SetAutoStretchVertical(true)
		lbl:SizeToContents()
	end)

	self.name:SetText(sName)
end

-- Добавляет иконку рядом с названием инфо панели
function PANEL:SetIcon(sIco, bIsModel) -- url, Material or Model path
	-- bIsModel = true
	-- sIco = "models/weapons/w_npcnade.mdl"

	self.icon_bg = self.icon_bg or ui.Create("Panel",self.head,function(bg)
		bg.Paint = IGS.S.RoundedPanel
		bg:SetWide(self.head:GetTall() - dock * 2)
		bg:Dock(LEFT)
		bg:DockPadding(3,3,3,3)
		bg:DockMargin(0,0,dock,0)

		bg:InvalidateParent(true) -- true bg:GetSize()
	end)

	if IsValid(self.icon) and
		((self.model and !bIsModel) or   -- Если раньше была установлена моделька, а сейчас надо поставить иконку
		(!self.model and bIsModel)) then -- Наоборот. Нужно поставить модельку, но стаяла картинка

		self.icon:Remove()
		self.icon = nil
	end

	self.model = bIsModel and sIco
	self.icon  = self.icon or (bIsModel and ui.Create("DModelPanel",self.icon_bg,function(mdl)
		mdl:SetSize(self.icon_bg:GetSize())
		mdl:SetModel(sIco)

		local mn, mx = mdl.Entity:GetRenderBounds()
		local size = 0
		size = math.max(size, math.abs(mn.x) + math.abs(mx.x))
		size = math.max(size, math.abs(mn.y) + math.abs(mx.y))
		size = math.max(size, math.abs(mn.z) + math.abs(mx.z))

		mdl:SetFOV(30)
		mdl:SetCamPos(Vector(size, size, size))
		mdl:SetLookAt((mn + mx) * 0.5)
		mdl.LayoutEntity = function() return false end

	end)) or ui.Create("wmat_ui",self.icon_bg,function(ico)
		ico:SetSize(self.icon_bg:GetSize())
		ico.AutoSize = false
	end) -- НЕ моделька (Ссылка на иконку)


	if bIsModel then
		self.icon:SetModel(sIco)
	else
		self.icon:SetURL(sIco) -- nil = сброс
	end
end

-- Кнопка под названием инфо панели
function PANEL:SetSubNameButton(sName,func)
	if !sName then return end

	self.sub = self.sub or ui.Create("DButton",self.head,function(btn)
		btn:Dock(TOP)
		btn:SetTall(20)
		btn:SetFont("ui.20")
		btn:SetTextColor(IGS.col.TEXT_SOFT)
		btn:SetContentAlignment(4)
		btn.DoClick = func
		btn.Paint = function() end
	end)

	self.sub:SetText(sName .. "⯈")
end

-- Создает невидимую панельку вот тут:
-- https://img.qweqwe.ovh/1486589180000.png
function PANEL:CreateActivity()
	self.activity = self.activity or ui.Create("Panel",self.head,function(btn)
		btn:Dock(FILL)
	end)

	return self.activity
end

-- Описание, информация, картинка
function PANEL:AddPanel(sTitle,panel)
	-- https://img.qweqwe.ovh/1486595573943.png
	local background = ui.Create("Panel",function(bg)
		bg:DockPadding(10,0,10,0) -- отступы по краям внутри скролла
		bg.Paint = function(s,w,h) -- линия снизу посередине панели https://img.qweqwe.ovh/1491948928484.png
			surface.SetDrawColor(IGS.col.SOFT_LINE)
			surface.DrawLine(10,h - 1,w - 10,h - 1)
		end
	end) -- для отступов

	local y = panel:GetTall() -- с доками не вышло, пришлось сетить вручную

	ui.Create("DLabel",background,function(title)
		title:Dock(TOP)
		title:SetTall(22)
		title:DockMargin(0,10,0,5)
		title:SetText(sTitle)
		title:SetFont("ui.22")
		title:SetTextColor(IGS.col.TEXT_HARD)

		y = y + 22 + 5 + 5
	end)

	panel:SetParent(background)
	panel:Dock(TOP)

	self.scroll:AddItem(background)

	background:SetTall(y + 5 + 10) -- 5 хз че, а 10 - отступ от текста к бортику снизу
end

function PANEL:Reset()
	self.scroll:Reset()

	if self.name then
		self.name:SetText("")
	end

	if self.sub then
		self.sub:SetText("")
	end

	if self.icon then
		self.icon:SetURL() -- IGS.C.DefaultIcon
	end
end


--[[-------------------------------------------------------------------------
Не обязательные методы. Их тут не должно быть с точки зрения правильности кода
Но так как я панель больше нигде, кроме IGS не юзаю, то мне так будет удобнее
---------------------------------------------------------------------------]]
-- Добавляет панель с описанием
function PANEL:SetDescription(sDescription)
	if self.description then return end

	local pnl = ui.Create("Panel")

	self:InvalidateParent(true)
	local w = self:GetWide()
	local txt = string.Wrap("ui.15", sDescription, w - 10 - 10)
	local y   = 0

	for i,line in ipairs(txt) do
		ui.Create("DLabel",pnl,function(d)
			d:SetPos(0,y)
			d:SetSize(w,15)
			d:SetFont("ui.15")
			d:SetTextColor(IGS.col.TEXT_SOFT)
			d:SetText(line)

			y = y + 15
		end)
	end

	pnl:SetTall(y)
	self:AddPanel("Описание",pnl)
end

function PANEL:SetInfo(tInf)
	local pnl = ui.Create("Panel")
	local y = 0

	for k,v in pairs(tInf) do
		local line_bg = ui.Create("Panel",pnl)
		line_bg:SetTall(15)
		line_bg:Dock(TOP)

		ui.Create("DLabel",line_bg,function(key)
			key:Dock(LEFT)
			key:SetWide(80)
			key:SetFont("ui.15")
			key:SetTextColor(IGS.col.TEXT_SOFT)
			key:SetText(k)
			key:SetContentAlignment(6)
		end)

		ui.Create("DLabel",line_bg,function(key)
			key:Dock(FILL)
			key:SetFont("ui.15")
			key:SetTextColor(IGS.col.TEXT_HARD)
			key:SetText("  " .. v)
			key:SetContentAlignment(4)
		end)

		y = y + 15
	end

	pnl:SetTall(y)
	self:AddPanel("Информация",pnl)
end

-- Добавляет панель с указанным изображением
function PANEL:SetImage(sUrl)
	if !sUrl then return end

	self:InvalidateParent(true) -- self:GetWide()

	local pnl = ui.Create("wmat_ui")
	pnl:SetSize(self:GetWide(),self:GetWide() / 5 * 2) -- соотношение 5:2
	pnl:SetURL(sUrl)

	self:AddPanel("Изображение",pnl)
end

vgui.Register("igs_iteminfo",PANEL,"Panel")

-- IGS.WIN.Item("group_premium_15d")

