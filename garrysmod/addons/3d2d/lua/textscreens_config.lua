textscreenFonts = {}

local function addFont(font, t)
	if CLIENT then
		for i = 1, 100 do
			t.size = i*2
			surface.CreateFont(font .. i, t)
		end
	end

	table.insert(textscreenFonts, font)
end

--[[
---------------------------------------------------------------------------
Custom fonts - requires server restart to take affect -- "Screens_" will be removed from the font name in spawnmenu
---------------------------------------------------------------------------
--]]

-- Default textscreens font
addFont("Exo 2", {
	font = "Exo 2",
	weight = 400,
	extended = true,
	antialias = false,
	outline = true
})

addFont("Exo 2 Bold", {
	font = "Exo 2 Bold",
	weight = 400,
	extended = true,
	antialias = false,
	outline = false
})

-- Trebuchet
addFont("Exo 2 Light", {
	font = "Exo 2 Light",
	weight = 400,
	extended = true,
	antialias = false,
	outline = true
})

addFont("Exo 2 Medium", {
	font = "Exo 2 Medium",
	weight = 400,
	extended = true,
	antialias = false,
	outline = false
})

-- Arial
addFont("Exo 2 Semi Bold", {
	font = "Exo 2 Semi Bold",
	weight = 600,
	extended = true,
	antialias = false,
	outline = true
})

addFont("Play", {
	font = "Play",
	extended = true,
	weight = 600,
	antialias = false,
	outline = false
})

-- Roboto Bk
addFont("Play Bold", {
	font = "Play Bold",
	weight = 400,
	extended = true,
	antialias = false,
	outline = true
})

if CLIENT then

	local function addFonts(path)
		local files, folders = file.Find("resource/fonts/" .. path .. "*", "MOD")

		for k, v in ipairs(files) do
			if string.GetExtensionFromFilename(v) == "ttf" then
				local font = string.StripExtension(v)
				if table.HasValue(textscreenFonts, "Screens_" .. font) then continue end
print("-- "  .. font .. "\n" .. [[
addFont("Screens_ ]] .. font .. [[", {
	font = font,
	weight = 400,
	antialias = false,
	extended = true,
	outline = true
})
				]])
			end
		end

		for k, v in ipairs(folders) do
			addFonts(path .. v .. "/")
		end
	end

	concommand.Add("get_fonts", function(ply)
		addFonts("")
	end)

end
