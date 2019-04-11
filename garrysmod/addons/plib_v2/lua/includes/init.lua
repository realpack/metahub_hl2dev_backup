-- Init
if (SERVER) then
	AddCSLuaFile()
	AddCSLuaFile 'plib/init.lua'
end
include 'plib/init.lua'

plib.IncludeSH '_init.lua'

-- Extensions
for k, v in pairs(plib.LoadDir('extensions')) do
	plib.IncludeSH(v)
end
for k, v in pairs(plib.LoadDir('extensions/server')) do
	plib.IncludeSV(v)
end
for k, v in pairs(plib.LoadDir('extensions/client')) do
	plib.IncludeCL(v)
end