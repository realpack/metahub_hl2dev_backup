local REQ = {}
REQ.__index = REQ

function REQ:FormStructure(fS,fF)
	return {
		url        = self.u,
		parameters = self.p,
		method     = self.m,
		headers    = self.h,
		type       = self.t,
		body       = self.b,
		failed     = self.e or fF,
		success    = self.s or fS,
	}
end

function REQ:Exec(fS,fF)
	-- prt(self:FormStructure(fS,fF))
	HTTP(self:FormStructure(fS,fF))
end

function REQ:SetCallback(cb, bItsErrorCb)
	self[bItsErrorCb and "e" or "s"] = cb
	return self
end

function REQ:SetContentType(sType)
	self.t = sType
	return self
end

function REQ:SetHeaders(t)
	self.h = t
	return self
end

function REQ:SetParam(k,v)
	self.p[k] = tostring(v)
	return self
end

function REQ:SetParams(t)
	for k,v in pairs(t) do
		self:SetParam(k,v)
	end

	return self
end

function REQ:SetBody(s)
	self.b = s
	return self
end

function http.request(target,method)
	return setmetatable({
		u = target, -- url
		m = method or "POST",
		p = {}, -- params
	},REQ)
end
