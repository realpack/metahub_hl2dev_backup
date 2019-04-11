IGS = IGS or {
	C = {}, -- config
	Version = 180706
}

IGS.DIR = "igs/"

local iSV = SERVER and include or function() end
local iCL = SERVER and AddCSLuaFile or include
local iSH = function(f) return iCL(f) or iSV(f) end

function IGS.sh(sFile) return iSH(IGS.DIR .. sFile) end -- print("sh " .. sFile)
function IGS.sv(sFile) return iSV(IGS.DIR .. sFile) end -- print("sv " .. sFile)
function IGS.cl(sFile) return iCL(IGS.DIR .. sFile) end -- print("cl " .. sFile)



local function poop(...)
	local path = select(1,...)
	if path:EndsWith("README.MD") then return end
	print("[IGS] Попытка инклюда странного файла: " .. path)
end

local func_map = {
	["sh"] = IGS.sh,
	["sv"] = IGS.sv,
	["cl"] = IGS.cl,
}

local function IncludeFuncFromFilename(sFile)
	if !string.EndsWith(sFile,".lua") then return poop end

	local sh_sv_cl = sFile:sub(-#"_gg.lua" + 1,-#".lua" - 1)
	return func_map[sh_sv_cl] or poop
end

function IGS.dir(sPath, fLoader, bRecursive)
	local files,dirs = file.Find(IGS.DIR .. sPath .. "/*","LUA")

	for _,fileName in ipairs(files) do
		local incl = fLoader or IncludeFuncFromFilename(fileName)
		incl(sPath .. "/" .. fileName)
	end

	if bRecursive then
		for _,dirName in ipairs(dirs) do
			IGS.dir(sPath .. "/" .. dirName, fLoader, bRecursive)
		end
	end
end


IGS.sh("launcher.lua")
