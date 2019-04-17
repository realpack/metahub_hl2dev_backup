rp.cfg.Limits = {
	['dynamite']	= 0,
	['hoverballs']	= 0,
	['turrets']		= 0,
	['spawners']	= 0,
	['emitters']	= 0,
	['effects']		= 0,
	['buttons']		= 4,
	['ragdolls']	= 0,
	['npcs']		= 0,
	['lamps']		= 2,
	['balloons']	= 4,
	['lights']		= 4,
	['props']		= 1000,
	['vehicles']	= 0,
	['sents']		= 25,
	['keypads']		= 10,
  ['prop_doors']   = 10,
	['textscreens'] = 3
}

function rp.GetLimit(name)
	return rp.cfg.Limits[name] or 0
end

function rp.SetLimit(name, limit)
	rp.cfg.Limits[name] = limit
end

-- 0 - Все
-- 1 - --
-- 2 - Админы
-- 3 - Суперадмины
-- 4 - Никто

rp.cfg.ToolLimits = {
	['rb655_easy_bodygroup'] = 2,
	['npctool_controller'] = 4,
	['npctool_follower'] = 4,
	['npctool_health'] = 4,
	['npctool_newroute'] = 4,
	['npctool_newspawner'] = 4,
	['npctool_notarget'] = 4,
	['npctool_relationships'] = 4,
	['npctool_proficiency'] = 4,
	['npctool_spawner'] = 4,
	['npctool_viewcam'] = 4,
	['permaprops'] = 2,
	['item_ammo_crates'] = 2,
	['prop_doors'] = 2,
	['env_headcrabcanisters'] = 2,
	['headcrabcanisters'] = 2,
	['item_item_crates'] = 2,
	['prop_npc_crates'] = 2,
	['prop_thumpers'] = 2,
	['permaprops'] = 2,
	['lamps'] = 2,
	['lights'] = 2,

}

timer.Simple(1,function()
	for tool, rank in pairs(rp.cfg.ToolLimits) do
		rp.pp.AddBlockedTool(tool, rank)
	end
end)
