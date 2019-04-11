if SERVER then return end

IGS.C.Banners = IGS.C.Banners or {
	MAP  = {}, -- url  > obj
	LIST = {}  -- iter > obj
}


local MT = {}
MT.__index = MT




function MT:SetTall(iTallPx)
	self.tall = iTallPx
	return self
end

function MT:SetFilter(fFilter)
	self.filter = fFilter
	return self
end

function MT:SetAction(fAction)
	self.action = fAction
	return self
end




function MT:GetTall()
	return self.tall or 50
end

function MT:GetURL()
	return self.url
end

function MT:Filter()
	if self.filter then
		return self.filter(LocalPlayer())
	end

	return true
end

function MT:Activate()
	if self.action then
		self.action(LocalPlayer())
	end
end





function IGS.AddBanner(url)
	local OBJ = IGS.C.Banners.MAP[url] or setmetatable({},MT)
	OBJ.url = url

	if !IGS.C.Banners.MAP[url] then -- антидубликат
		OBJ.id = table.insert(IGS.C.Banners.LIST,OBJ)
	end

	IGS.C.Banners.MAP[url] = OBJ

	return OBJ
end