local ITEM = FindMetaTable("IGSItem")

function ITEM:SetEvolveRank(rank)
	self:SetCategory("Группы")
	self:SetDescription("После покупки вы получите доступ ко всем невероятным возможностям " .. rank)

	self:SetOnActivate(function(pl)
		evolve.PlayerInfo[pl:UniqueID()]["Rank"] = rank
	end)
	self:SetValidator(function(pl)
		return evolve.PlayerInfo[pl:UniqueID()]["Rank"] == rank, true
	end)

	self.ev_rank = rank
	return self
end

