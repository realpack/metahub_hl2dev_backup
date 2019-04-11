--[[-------------------------------------------------------------------------
	Поддержка вот этого говнокода:
	https://github.com/vrondakis/Leveling-System
---------------------------------------------------------------------------]]

local STORE_ITEM = FindMetaTable("IGSItem")

function STORE_ITEM:SetLevels(iAmount)
	self:SetCategory("Система уровней")
	self:SetDescription("Мгновенно добавляет вам " .. iAmount .. " уровней")
	self:SetOnActivate(function(pl)
		pl:addLevels(iAmount)
	end)

	return self
end

function STORE_ITEM:SetEXP(iAmount)
	self:SetCategory("Система уровней")
	self:SetDescription("Мгновенно добавляет вам " .. iAmount .. " единиц опыта")
	self:SetOnActivate(function(pl)
		pl:addXP(iAmount)
	end)

	return self
end