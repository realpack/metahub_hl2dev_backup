rp.col = {
	SUP 		= Color(51,128,255),

	-- Misc
	Black 		= Color(0,0,0),
	White 		= Color(255,255,255),
	Red 		= Color(204,51,51),
	Orange 		= Color(254,161,3),
	Purple 		= Color(180,50,200),
	Green 		= Color(50,200,50),
	Grey 		= Color(150,150,150),
	Yellow 		= Color(255,255,51),
	Blue 		= Color(66,139,202),
	Pink 		= Color(245,120,120),

	-- Chat
	OOC 		= Color(204,51,51),

	-- UI
	Background 		= Color(0,0,0,230),
	Outline 		= Color(190,190,190,200),
	Highlight 		= Color(255,255,255,125),
	Button 			= Color(120,120,120),
	ButtonHovered	= Color(51,128,255),
}

-- Chat Colors
rp.chatcolors = {}
for k, v in pairs(rp.col) do
	local count = #rp.chatcolors + 1
	rp.chatcolors[k] = count
	rp.chatcolors[count] = v
end
