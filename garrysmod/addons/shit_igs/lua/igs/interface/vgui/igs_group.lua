local PANEL = {}

local PL_VARIANTS = PL.Add("variants",{"вариант", "варианта", "вариантов"})
function PANEL:SetGroup(ITEM_GROUP)
	self.group = ITEM_GROUP

	if ITEM_GROUP:ICON() then
		self:SetIcon(ITEM_GROUP:ICON())
	end

	if ITEM_GROUP.highlight then
		self:SetTitleColor(ITEM_GROUP.highlight)
	end

	self:SetName(ITEM_GROUP:Name())
	self:SetSign(PL_VARIANTS(#ITEM_GROUP:Items()))

	local min,max = math.huge,0 -- минимальная и максимальная цены итемов
	for _,v in ipairs(ITEM_GROUP:Items()) do
		local price = v.item:PriceInCurrency()

		if price < min then
			min = price
		end

		if price > max then
			max = price
		end
	end

	if min == max then
		self:SetBottomText("Все по " .. IGS.SignPrice(min))
	else
		self:SetBottomText("От " .. min .. " до " .. IGS.SignPrice(max))
	end

	return self
end

function PANEL:DoClick()
	if !IsValid(self.list_bg) then
		self.list_bg = IGS.WIN.Group(self.group:UID())
	end
end


vgui.Register("igs_group",PANEL,"igs_item")
-- IGS.UI()