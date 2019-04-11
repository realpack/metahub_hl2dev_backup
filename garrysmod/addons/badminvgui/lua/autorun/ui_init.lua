if (CLIENT) then
	ui = ui or {}
end

plib.IncludeCL 'ui/colors.lua'
plib.IncludeCL 'ui/util.lua'
plib.IncludeCL 'ui/theme.lua'

local files, _ = file.Find('ui/controls/*.lua', 'LUA')
for k, v in ipairs(files) do
	plib.IncludeCL('ui/controls/' .. v)
end
