


local notify_colors = {
    [0] = Color(221, 174, 100),
    [1] = Color(183, 81, 52),
    [2] = Color(123, 168, 196),
    [3] = Color(123, 168, 196),
    [4] = Color(123, 168, 196),
}

local date_format = "%H:%M"

-- NOTIFY_TYPES = {
--     ['yellow'] = Color(221, 174, 100),
--     ['red']    = Color(183, 81, 52),
--     ['blue']   = Color(123, 168, 196),
--     ['green']  = Color(140, 160, 93),
--     ['purple'] = Color(176, 100, 149),
--     ['cyan']   = Color(136, 219, 216),
-- }

net('rp.NotifyString', function()
    local msg = rp.ReadMsg()
    chat.AddText(notify_colors[net.ReadUInt(2)],'['..os.date(date_format , os.time())..'] ',color_white,msg)
end)

net('rp.NotifyTerm', function()
    local term = rp.ReadTerm()
    chat.AddText(notify_colors[net.ReadUInt(2)],'['..os.date(date_format , os.time())..'] ',color_white,term)
end)

function rp.Notify(notify_type, msg, ...)
	local replace = {...}
	local count = 0

	msg = msg:gsub('#', function()
		count = count + 1
		local v = replace[count]
		local t = type(v)
		if (t == 'Player') then
			if (not IsValid(v)) then return 'Unknown' end
			return v:Name()
		elseif (t == 'Entity') then
			if (not IsValid(v)) then return 'Invalid Entity' end
			return (v.PrintName and v.PrintName or v:GetClass())
		end
		return v
	end)

    chat.AddText(notify_colors[notify_type],'['..os.date(date_format , os.time())..'] ',color_white,msg)
end
