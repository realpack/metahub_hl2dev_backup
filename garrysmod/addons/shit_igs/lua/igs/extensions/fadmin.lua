-- Кто-то использует FAdmin, как отдельный аддон к другим гейммодам? О_о

local STORE_ITEM = FindMetaTable("IGSItem")

function STORE_ITEM:SetFAdminGroup(sGroup, iWeight)
	self:SetDescription("Автоматическое повышение вас до " .. sGroup)
	self:SetOnActivate(function(pl)
		FAdmin.Access.PlayerSetGroup(pl, sGroup)
		pl.IGSFAdminWeight = iWeight
	end)
	self:SetValidator(function(pl)
		if pl.IGSFAdminWeight then
			return iWeight < pl.IGSFAdminWeight, true
		end
		return pl:IsUserGroup(sGroup), true
	end)

	return self
end