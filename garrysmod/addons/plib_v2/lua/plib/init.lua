plib = {
	BadModules = {}
}
_R 	 = debug.getregistry()

-- To do, add IncludeDir, IncudeDirSV, IncudeDirSH, IncudeDirCL
plib.IncludeSV 	= (SERVER) and include or function() end
plib.IncludeCL 	= (SERVER) and AddCSLuaFile or include
plib.IncludeSH 	= function(f) plib.IncludeSV(f) plib.IncludeCL(f) end

function plib.LoadDir(dir)
	local ret = {}
	local files, folders = file.Find('plib/' .. dir .. '/*', 'LUA')
	for _, f in ipairs(files) do
		if (f:sub(f:len() - 2, f:len()) == 'lua') then
			ret[f:sub(1, f:len() - 4)] = 'plib/' .. dir .. '/' .. f
		end
	end
	for _, f in ipairs(folders) do
		if (f ~= 'client') and (f ~= 'server') then
			ret[f] = 'plib/' .. dir  .. '/' .. f .. '/' .. f ..'.lua'
		end
	end
	return ret
end

local modules = {
	preload = {
		Shared = plib.LoadDir('preload'),
		Server = (SERVER) and plib.LoadDir('preload/server') or {},
		Client = plib.LoadDir('preload/client'),
	},
	Shared = plib.LoadDir('libraries'),
	Server = (SERVER) and plib.LoadDir('libraries/server') or {},
	Client = plib.LoadDir('libraries/client'),
	Loaded = {}
}

for k, v in pairs(modules.preload.Shared) do
	plib.IncludeSH(v)
end

if (SERVER) then
	for k, v in pairs(modules.preload.Server) do
		plib.IncludeSV(v)
	end
	for k, v in pairs(modules.Shared) do
		AddCSLuaFile(v)
	end
	for k, v in pairs(modules.Client) do
		AddCSLuaFile(v)
	end
end

for k, v in pairs(modules.preload.Client) do
	plib.IncludeCL(v)
end

local _require = require
function require(name)
	local lib = modules.Shared[name] or modules.Server[name] or modules.Client[name]
	if (lib ~= nil) and (not modules.Loaded[name]) and (not plib.BadModules[name]) then
		modules.Loaded[name] = true
		return include(lib)
	elseif (not modules.Loaded[name]) and (not plib.BadModules[name]) then
		return _require(name)
	end
end