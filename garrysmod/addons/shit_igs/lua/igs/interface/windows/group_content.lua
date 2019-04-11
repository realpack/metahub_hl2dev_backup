local function getSpacePanel()
	return ui.Create("Panel",function(self)
		self:Dock(TOP)
		self:SetTall(3)
	end)
end

function IGS.WIN.Group(sGroupUID)
	local GROUP = IGS.GetGroup(sGroupUID)

	return ui.Create("iFrame",function(bg)
		bg:SetTitle(GROUP:Name())
		bg:MakePopup()

		bg.scroll = ui.Create("iScroll",bg)
		bg.scroll:Dock(FILL)
		bg.scroll:SetPadding(6)



		bg.scroll:AddItem( getSpacePanel() ) -- из-за паддинга #1

		local cellW,cellH -- не изменяется в зависимости от контента
		for _,v in pairs(GROUP:Items()) do
			local ITEM = v.item
			local name = v.name or ITEM:Name()

			local it = ui.Create("igs_item"):SetItem(ITEM)
			it:SetName(name)

			if !cellW then
				cellW,cellH = it:GetSize()
			end

			it:SetSize(cellW * 1.3, cellH)
			it.DoClick = function()
				bg:Remove()
				IGS.WIN.Item(ITEM:UID())
			end

			bg.scroll:AddItem(it)
		end

		bg.scroll:AddItem( getSpacePanel() ) -- из-за паддинга #2



		bg:SetSize(cellW * 1.3, 300)
		bg:Center()
	end)
end

-- IGS.UI()