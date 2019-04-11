util.AddNetworkString 'rp.NotifyString'
util.AddNetworkString 'rp.NotifyTerm'
util.AddNetworkString 'rp.ChatMessage'

NOTIFY_GENERIC			= 0
NOTIFY_ERROR 			= 1
NOTIFY_RED 				= NOTIFY_ERROR
NOTIFY_GREEN			= 3
NOTIFY_HINT 			= 4

function rp.Notify(recipients, notify_type, msg, ...)
	if (not istable(recipients)) and (not IsValid(recipients)) then return end

	if isstring(msg) then
		net.Start('rp.NotifyString')
			rp.WriteMsg(msg, ...)
			net.WriteUInt(notify_type, 2)
		net.Send(recipients)
	else
		net.Start('rp.NotifyTerm')
			rp.WriteTerm(msg, ...)
			net.WriteUInt(notify_type, 2)
		net.Send(recipients)
	end
end

function rp.NotifyAll(notify_type, msg, ...)
	if isstring(msg) then
		net.Start('rp.NotifyString')
			rp.WriteMsg(msg, ...)
			net.WriteUInt(notify_type, 2)
		net.Broadcast()
	else
		net.Start('rp.NotifyTerm')
			rp.WriteTerm(msg, ...)
			net.WriteUInt(notify_type, 2)
		net.Broadcast()
	end
end

function PLAYER:Notify( notify_type, msg, ...)
	rp.Notify(self, notify_type, msg, ...)
end
