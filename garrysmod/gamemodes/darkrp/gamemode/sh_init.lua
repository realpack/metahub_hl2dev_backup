rp = rp or {
	cfg = {},
	inv = {
		Data = {},
		Wl = {}
	}
}

PLAYER	= FindMetaTable 'Player'
ENTITY	= FindMetaTable 'Entity'
VECTOR	= FindMetaTable 'Vector'

if (SERVER) then
	require 'mysql'
else
	require 'cvar'
end
require 'nw'
require 'pon'
require 'pcolor'
require 'xfn'

rp.include_sv = (SERVER) and include or function() end
rp.include_cl = (SERVER) and AddCSLuaFile or include
rp.include_sh = function(f) rp.include_sv(f) rp.include_cl(f) end

rp.include_load = function(f)
	if string.find(f, 'sv_') then
		rp.include_sv(f)
	elseif string.find(f, 'cl_') then
		rp.include_cl(f)
	else
		rp.include_sh(f)
	end
end

function rp.include_dir(directory) -- Depruciated
    local fol = GM.FolderName .. '/gamemode/' .. directory .. '/'

	-- Find all of the files within the directory.
	for k, v in ipairs(file.Find(fol .. '*', 'LUA')) do
		local fileName = directory..'/'..v
		rp.include_load(fileName)
	end

	local _, folders = file.Find(fol .. '*', 'LUA')
	if folders then
		for _, f in ipairs(folders) do
			rp.include_dir(directory .. '/' .. f)
		end
    end
end

GM.Name 	= 'DarkRP'
GM.Author 	= ''
GM.Website 	= ''

rp.include_sv 'db.lua'

rp.include_sh 'cfg/cfg.lua'
rp.include_sh 'cfg/colors.lua'

rp.include_dir 'util'

rp.include_dir 'core'
rp.include_dir 'core/sandbox'
rp.include_dir 'core/chat'
rp.include_dir 'core/player'
rp.include_dir 'core/makethings'
rp.include_dir 'core/doors'

rp.include_dir 'modules'

rp.include_sh 'cfg/jobs.lua'
rp.include_sh 'cfg/entities.lua'
rp.include_sh 'cfg/terms.lua'
rp.include_sv 'cfg/limits.lua'


print('reloaded')
