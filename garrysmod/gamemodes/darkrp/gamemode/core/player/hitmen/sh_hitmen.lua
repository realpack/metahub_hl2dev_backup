function PLAYER:HasHit()
	return (self:GetNetVar('HitPrice') ~= nil)
end

function PLAYER:GetHitPrice()
	return self:GetNetVar('HitPrice')
end

nw.Register 'HitPrice'
	:Write(net.WriteUInt, 32)
	:Read(net.ReadUInt, 32)