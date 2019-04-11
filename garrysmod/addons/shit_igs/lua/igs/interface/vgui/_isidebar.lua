local PANEL = {}

function PANEL:Init()
	-- Херня справа от лэйаута с услугами http://joxi.ru/52aQQ8Efzov120
	-- Вид без нее: http://joxi.ru/eAO44lGcXORlro
	self.sidebar = ui.Create("Panel",self,function(sbar)
		sbar:Dock(FILL)
	end)

	-- Верхняя часть http://joxi.ru/5mdWW05tzW6Wr1
	self.header = ui.Create("Panel",self.sidebar,function(header)
		header:SetTall(40)
		header:Dock(TOP)
	end)
end

-- Заголовок сайдбара "Последние покупки" и т.д.
function PANEL:SetTitle(sTitle)
	self.title = self.title or ui.Create("DLabel",self.header,function(title)
		title:Dock(BOTTOM)
		title:SetTall(24)
		title:SetFont("ui.19")
		title:SetTextColor(IGS.col.TEXT_HARD)
		title:SetContentAlignment(8)
	end)

	self.title:SetText(sTitle)

	return self.title
end

vgui.Register("multi_sidebar",PANEL,"Panel")
--IGS.UI()