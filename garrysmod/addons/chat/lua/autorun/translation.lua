
-----------------------------------------------------
if SERVER then
	for _, name in pairs(file.Find("translations/*", "LUA")) do
		AddCSLuaFile("translations/" .. name)
	end
	return
end

translation = translation or {}
translation.known_gui_strings = translation.known_gui_strings or {}
translation.current_lang = translation.current_lang or {}

local cvar = GetConVar("gmod_language")

local code_to_lang = {
	ko = "korean",
	en = "english",
	ja = "japanese",
	pt = "portuguese"
}

function translation.LanguageString(val)
	local key = val:Trim():lower()
		
	translation.known_gui_strings[key] = val

	return translation.current_lang[key] or val
end

translation.L = translation.LanguageString

local L = translation.LanguageString

translation.editor_frame = NULL

function translation.ShowEditor()
	
	if translation.editor_frame:IsValid() then translation.editor_frame:Remove() end
	
	local lang = translation.GetLanguage()

	local frame = vgui.Create("DFrame")
	translation.editor_frame = frame
	
	frame:SetSize(512, 512)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle(L"translation editor")
	
	local menu_bar = vgui.Create( "DMenuBar", frame )
	menu_bar:DockMargin( -3,-6,-3,0 ) --corrects MenuBar pos

	local m1 = menu_bar:AddMenu( L"File" )
	m1:AddOption(L"New", function()
		Derma_StringRequest(
			L"New language",
			L"Type the name of the new language",
			"",
			function(txt)
				translation.SetLanguage(txt)
				translation.SaveCurrentTranslation()
				translation.ShowEditor()
			end,
			function(txt) return false end
		)
	end):SetIcon( "icon16/page_white_go.png" )
	
	local menu, pnl = m1:AddSubMenu(L"Open", function() end)
	menu.GetDeleteSelf = function() return false end
	pnl:SetIcon( "icon16/folder_go.png" )
	
	for _, name in pairs(file.Find("translations/*", "DATA")) do
		name = name:match("(.-)%.txt")
		menu:AddOption(name, function()
			translation.SetLanguage(name)
			translation.ShowEditor()
		end):SetImage("icon16/page_edit.png")
	end

	for _, name in pairs(file.Find("translations/*", "LUA")) do
		name = name:match("(.-)%.lua")
		menu:AddOption(name, function()
			translation.SetLanguage(name)
			translation.ShowEditor()
		end):SetImage("icon16/page.png")
	end
	
	local list = vgui.Create("DListView", frame)
	list:Dock(FILL)
	
	list:AddColumn("english")
	list:AddColumn(lang)
	
	local strings = {}
	
	for k,v in pairs(translation.known_gui_strings) do
		strings[k] = v:Trim():lower()
	end
	table.Merge(strings, translation.current_lang)
	
	for english, other in pairs(strings) do
	
		local line = list:AddLine(english, other)
		line.OnRightClick = function()
			local menu = DermaMenu()
			menu:SetPos(gui.MousePos())
			menu:AddOption(L"edit", function()
				local window = Derma_StringRequest(
					L"translate",
					english,
					other,

					function(new)
						translation.current_lang[english] = new
						line:SetValue(2, new)
						translation.SaveCurrentTranslation()
					end
				)
				for _, pnl in pairs(window:GetChildren()) do
					if pnl.ClassName == "DPanel" then
						for key, pnl in pairs(pnl:GetChildren()) do
							if pnl.ClassName == "DTextEntry" then
								pnl:SetAllowNonAsciiCharacters(true)
							end
						end
					end
				end
			end):SetImage("icon16/table_edit.png")
			menu:AddOption(L"revert", function()
				local new
				
				if file.Exists("translations/" .. lang .. ".lua", "LUA") then
					new = CompileFile("translations/"..lang..".lua")()[english]
				elseif file.Exists("translations/" .. lang .. ".txt", "DATA") then
					new = CompileString(file.Read("translations/" .. lang .. ".txt", "DATA"), "translation")()[english]
				end
				
				translation.current_lang[english] = new
				line:SetValue(2, new or english)
				translation.SaveCurrentTranslation()
			end):SetImage("icon16/table_delete.png")
			
			menu:MakePopup()
		end
	end
	
	list:SizeToContents()
end

function translation.SaveCurrentTranslation()
	local str = {}
	
	table.insert(str, "return {")
	
	for key, val in pairs(translation.current_lang) do
		table.insert(str, string.format("[%q] = %q,", key, val))
	end
	
	table.insert(str, "}")
	
	file.CreateDir("translations", "DATA")
	file.Write("translations/" .. translation.GetLanguage() .. ".txt", table.concat(str, "\n"), "DATA")
end

function translation.GetOutputForTranslation()
	local str = ""
	 
	for key, val in pairs(translation.known_gui_strings) do
		str = str .. ("%s = %s\n"):format(key:gsub("(.)","_%1_"), val)
	end
	
	return str
end

function translation.SetLanguage(lang)

	lang = lang or code_to_lang[cvar:GetString()] or "english"
	translation.lang_override = lang
	
	translation.current_lang = {}
	
	if lang ~= "english" then
		if file.Exists("translations/" .. lang .. ".txt", "DATA") then
			table.Merge(translation.current_lang, CompileString(file.Read("translations/" .. lang .. ".txt", "DATA"), "translation")())
		elseif file.Exists("translations/" .. lang .. ".lua", "LUA") then
			table.Merge(translation.current_lang, CompileFile("translations/"..lang..".lua")())
		end
	end
	
	for k,v in pairs(translation.current_lang) do
		translation.current_lang[k:lower():Trim()] = v
	end
end

function translation.GetLanguage()
	return translation.lang_override or code_to_lang[cvar:GetString()] or "english"
end

translation.SetLanguage()