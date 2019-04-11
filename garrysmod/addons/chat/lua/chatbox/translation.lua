local Tag="chatbox"
module(Tag,package.seeall)

if SERVER then AddCSLuaFile() return end

local L = translation and translation.L or function(s) return s end

troptions = troptions or {}

local languages = {
	Afrikaans = "af",
	--Albanian = "sq",
	Arabic = "ar",
	--Azerbaijani = "az",
	--Basque = "eu",
	--Bengali = "bn",
	--Belarusian = "be",
	--Bulgarian = "bg",
	--Catalan = "ca",
	["Chinese Simplified"] = "zh-CN",
	--["Chinese Traditional"] = "zh-TW",
	--Croatian = "hr",
	--Czech = "cs",
	--Danish = "da",
	--Dutch = "nl",
	English = "en",
	--Esperanto = "eo",
	Estonian = "et",
	Filipino = "tl",
	--Finnish = "fi",
	French = "fr",
	--Galician = "gl",
	--Georgian = "ka",
	German = "de",
	--Greek = "el",
	--Gujarati = "gu",
	--["Haitian Creole"] = "ht",
	--Hebrew = "iw",
	Hindi = "hi",
	Hungarian = "hu",
	--Icelandic = "is",
	Indonesian = "id",
	--Irish = "ga",
	Italian = "it",
	Japanese = "ja",
	--Kannada = "kn",
	Korean = "ko",
	--Latin = "la",
	Latvian = "lv",
	Lithuanian = "lt",
	--Macedonian = "mk",
	--Malay = "ms",
	--Maltese = "mt",
	--Norwegian = "no",
	--Persian = "fa",
	--Polish = "pl",
	Portuguese = "pt",
	Romanian = "ro",
	Russian = "ru",
	Serbian = "sr",
	Slovak = "sk",
	Slovenian = "sl",
	--Spanish = "es",
	--Swahili = "sw",
	--Swedish = "sv",
	--Tamil = "ta",
	--Telugu = "te",
	Thai = "th",
	--Turkish = "tr",
	Ukrainian = "uk",
	--Urdu = "ur",
	Vietnamese = "vi",
	--Welsh = "cy",
	--Yiddish = "yi",
}

local languages_sorted = {}
for k,v in pairs(languages) do
	table.insert(languages_sorted, {name = k, code = v}	)
end

table.sort(languages_sorted, function(a, b) return a.name > b.name end)

function OpenTranslateOptions()

	if trpanel then trpanel:Remove() end
	local frame = vgui.Create("DFrame")
	trpanel = frame

	frame:SetSize(256, 256)
	frame:Center()
	frame:SetTitle(L"translation")
	
	do
		local check = vgui.Create("DCheckBoxLabel", frame)
		check:SetText(L"reverse translate incoming")
		check.OnChange = function(_, b)
			troptions.reverse_incoming = b
		end
		
		check:SetValue(troptions.reverse_incoming)
		check:Dock(BOTTOM)
	end

	do
		local check = vgui.Create("DCheckBoxLabel", frame)
		check:SetText(L"show original")
		check.OnChange = function(_, b)
			troptions.show_original = b
		end
		
		check:SetValue(troptions.show_original)
		check:Dock(BOTTOM)
	end

	do
		local check = vgui.Create("DCheckBoxLabel", frame)
		check:SetText(L"enable")
		check.OnChange = function(_, b)
			troptions.enable = b
		end
		
		check:SetValue(troptions.enable)
		check:Dock(BOTTOM)
	end
	

	local function add_list(name, where, cb, select, extra)
		local list = vgui.Create("DListView", frame)
		list:AddColumn(name)
		list:SetMultiSelect(false)
		list:Dock(where)
		list:SetWide(frame:GetWide()/2 - 10)
		
		if extra then
			for _, data in pairs(extra) do
				local line = list:AddLine(data.name)
				line.trdata = data
				
				if select == data.code then
					list:SelectItem(line)
				end
			end
		end
		
		for _, data in pairs(languages_sorted) do
			local line = list:AddLine(data.name)
			line.trdata = data
			
			if select == data.code then
				list:SelectItem(line)
			end
		end
		
		list.OnClickLine = function(self, line)
			list:ClearSelection()
			list:SelectItem(line)
			cb(line.trdata)
		end
	end

	add_list(L"from", LEFT, function(data)  troptions.from = data.code end, troptions.from, {{name = L"Automatic", code = "auto"}})
	add_list(L"to", RIGHT, function(data) troptions.to = data.code end, troptions.to)

	frame:MakePopup()
end