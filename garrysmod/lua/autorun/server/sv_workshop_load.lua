hook.Add( "Initialize", "WorkshopLoad_Initialize", function()
	for k, v in pairs( engine.GetAddons() ) do
		local _file = v.wsid and v.wsid or string.gsub( tostring( v.file ), "%D", "" )
		resource.AddWorkshop( _file )
	end
end )

maplist = {}

resource.AddWorkshop( "1715080094" )
resource.AddWorkshop( "1715088389" )
resource.AddWorkshop( "1624787752" )
resource.AddWorkshop( "1418478031" )
resource.AddWorkshop( "837571030" )

-- maplist["rp_lusankya_metahub_v1"] = "1613799094"
maplist["rp_city24_v2"] = "1542655022"
maplist["rp_c18_updated"] = "1318848337"
maplist["rp_cyberz_c18_v1"] = "1702639487"
maplist["rp_city2_v4_finalb"] = "648741981"
-- maplist["event_cdx_dathcanyon"] = "969977945"
-- maplist["rp_venator_providence_battle"] = "804649089"
-- maplist["rp_deathstar"] = "1598263759"
-- maplist["rp_umbara"] = "1556357225"
-- maplist["gm_underground_v"] = "1568719631"
--add more maps here

resource.AddWorkshop( "1624787752" )

local map = game.GetMap() -- Get's the current map name
local workshopid = maplist[map] 
-- Finds the workshop ID for the current map name from the table above

if( workshopid != nil )then
	--If the map is in the table above, add it through workshop
	print( "[WORKSHOP] Setting up maps. " ..map.. " workshop ID: " ..workshopid )
	resource.AddWorkshop( workshopid )
else
	--If not, ) then hope the server has FastDL or the client has the map
	print( "[WORKSHOP] Not available for current map. Using FastDL instead hopefully..." )
end
