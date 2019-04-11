util.AddNetworkString 'rp.FlashString'
util.AddNetworkString 'rp.FlashTerm'

function rp.FlashNotify(recipients, title, msg, ...)
	if isstring(msg) then
		net.Start('rp.FlashString')
			net.WriteString(title)
			rp.WriteMsg(msg, ...)
		net.Send(recipients)
	else
		net.Start('rp.FlashTerm')
			net.WriteString(title)
			rp.WriteTerm(msg, ...)
		net.Send(recipients)
	end
end

function rp.FlashNotifyAll(title, msg, ...)
	if isstring(msg) then
		net.Start('rp.FlashString')
			net.WriteString(title)
			rp.WriteMsg(msg, ...)
		net.Broadcast()
	else
		net.Start('rp.FlashTerm')
			net.WriteString(title)
			rp.WriteTerm(msg, ...)
		net.Broadcast()
	end
end

function PLAYER:FlashNotify(title, msg, ...)
	rp.FlashNotify(self, title, msg, ...)
end
