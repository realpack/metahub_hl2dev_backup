IGS.IL = IGS.IL or {}

local callbacks,last,MAX = {},0,7
function IGS.IL.GetLog(fCb, iPage, s64_owner)
	net.Start("IGS.InvLog")
		net.WriteBool(s64_owner)
		if s64_owner then
			net.WriteString(s64_owner)
		end

		net.WriteBool(iPage)
		if iPage then
			net.WriteUInt(iPage,8)
		end

		last = (last + 1) % MAX + 1
		callbacks[last] = fCb

		net.WriteUInt(last,3)
	net.SendToServer()
end

net.Receive("IGS.InvLog", function()
	local cb_id = net.ReadUInt(3)
	local cb = callbacks[cb_id]
	-- prt({callbacks = callbacks,cb_id = cb_id})
	assert(cb,"No callback with id " .. cb_id)

	local data = {[0] = net.ReadUInt(22)}
	for i = 1,net.ReadUInt(6) do
		data[i] = {
			owner     = net.ReadString(),
			inflictor = net.ReadString(),
			gift_uid  = net.ReadString(),
			gift_id   = net.ReadUInt(20),
			action    = net.ReadUInt(3),
			action_id = net.ReadUInt(22),
			date      = net.ReadUInt(32),
		}
	end

	cb(data)
	callbacks[cb_id] = nil
end)
