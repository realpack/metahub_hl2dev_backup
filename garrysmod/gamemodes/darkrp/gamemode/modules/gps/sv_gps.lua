--

util.AddNetworkString('CreateMark')

function CreateMark( pl, pos, title, text, icon, time )
	net.Start('CreateMark')
		net.WriteVector(pos)
		net.WriteString(title)
		net.WriteString(text)
		net.WriteString(icon)
		net.WriteUInt(time, 32)
	net.Send( pl )
end
