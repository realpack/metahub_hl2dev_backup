local PANEL = {}

function PANEL:Init()
	-- categ_name > categpan
	self.list = {}
end

-- Одиночное добавление
function PANEL:Add(panel,sCategory)
	local cat = sCategory or "Разное"

	if !self.list[cat] then
		self.list[cat] = ui.Create("panels_layout",self)
		self.list[cat]:SetWide(650)
		self.list[cat]:SetName(sCategory)
		self.list[cat]:DisableAlignment(self.disabled_align)

		self:AddItem(self.list[cat])
	end

	self.list[cat]:Add(panel)

	return self.list[cat]
end

-- Отключает центрирование эллементов во всех панелях лэйаута
function PANEL:DisableAlignment(bDisable)
	self.disabled_align = bDisable
end

function PANEL:Clear()
	for categ,panel in pairs(self.list) do
		panel:Remove()
	end

	self:Init()
end

vgui.Register("panels_layout_list", PANEL, "iScroll")
-- IGS.UI()