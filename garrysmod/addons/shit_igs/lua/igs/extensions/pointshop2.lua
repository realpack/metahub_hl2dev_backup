local STORE_ITEM = FindMetaTable("IGSItem")


function STORE_ITEM:SetPremiumPoints(iAmount)
	self:SetCategory("Поинты")
	self:SetDescription("Мгновенно начисляет на счет " .. iAmount .. " премиум поинтов")
	self:SetStackable(true)
	self:SetOnActivate(function(pl)
		pl:PS2_AddPremiumPoints(iAmount)
	end)

	self.ps2_prempoints = iAmount
	return self
end

function STORE_ITEM:SetPoints(iAmount)
	self:SetCategory("Поинты")
	self:SetDescription("Мгновенно начисляет на счет " .. iAmount .. " обычных поинтов")
	self:SetStackable(true)
	self:SetOnActivate(function(pl)
		pl:PS2_AddStandardPoints(iAmount, "/donate")
	end)

	self.ps2_points = iAmount
	return self
end