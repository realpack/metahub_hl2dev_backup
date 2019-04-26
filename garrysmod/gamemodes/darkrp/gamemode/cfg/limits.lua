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
	['textscreens'] = 3,
	['item_ammo_crates'] = 10,
	['prop_doors'] = 10,
	['env_headcrabcanisters'] = 10,
	['headcrabcanisters'] = 10,
	['item_item_crates'] = 10,
	['prop_npc_crates'] = 10,
	['prop_thumpers'] = 10,
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
	['permaprop'] = 3,
	['item_item_crate'] = 2,
	['prop_door'] = 2,
	['env_headcrabcanister'] = 2,
	['headcrabcanisters'] = 2,
	['item_ammo_crate'] = 2,
	['prop_npc_crates'] = 2,
	['prop_thumper'] = 2,
	['lamp'] = 2,
	['light'] = 2,
	['trigger'] = 2,
	['prop_npc_crate'] = 2,
	['headcrabcanister'] = 2

}

timer.Simple(1,function()
	for tool, rank in pairs(rp.cfg.ToolLimits) do
		rp.pp.AddBlockedTool(tool, rank)
	end
end)

rp.cfg.PropWhitelist = {
    'models/balloons/balloon_classicheart.mdl',
    'models/balloons/balloon_dog.mdl',
    'models/balloons/balloon_star.mdl',
    'models/hunter/blocks/cube025x025x025.mdl',
    'models/hunter/blocks/cube025x05x025.mdl',
    'models/hunter/blocks/cube025x075x025.mdl',
    'models/hunter/blocks/cube025x125x025.mdl',
    'models/hunter/blocks/cube025x150x025.mdl',
    'models/hunter/blocks/cube025x1x025.mdl',
    'models/hunter/blocks/cube025x2x025.mdl',
    'models/hunter/blocks/cube025x3x025.mdl',
    'models/hunter/blocks/cube025x4x025.mdl',
    'models/hunter/blocks/cube025x5x025.mdl',
    'models/hunter/blocks/cube025x6x025.mdl',
    'models/hunter/blocks/cube025x7x025.mdl',
    'models/hunter/blocks/cube025x8x025.mdl',
    'models/hunter/blocks/cube05x05x025.mdl',
    'models/hunter/blocks/cube05x05x05.mdl',
    'models/hunter/blocks/cube05x075x025.mdl',
    'models/hunter/blocks/cube05x105x05.mdl',
    'models/hunter/blocks/cube05x1x025.mdl',
    'models/hunter/blocks/cube05x1x05.mdl',
    'models/hunter/blocks/cube05x2x025.mdl',
    'models/hunter/blocks/cube05x2x05.mdl',
    'models/hunter/blocks/cube05x3x025.mdl',
    'models/hunter/blocks/cube05x3x05.mdl',
    'models/hunter/blocks/cube05x4x025.mdl',
    'models/hunter/blocks/cube05x4x05.mdl',
    'models/hunter/blocks/cube05x5x025.mdl',
    'models/hunter/blocks/cube05x5x05.mdl',
    'models/hunter/blocks/cube05x6x025.mdl',
    'models/hunter/blocks/cube05x6x05.mdl',
    'models/hunter/blocks/cube05x7x025.mdl',
    'models/hunter/blocks/cube05x7x05.mdl',
    'models/hunter/blocks/cube05x8x025.mdl',
    'models/hunter/blocks/cube05x8x05.mdl',
    'models/hunter/blocks/cube075x075x025.mdl',
    'models/hunter/blocks/cube075x075x075.mdl',
    'models/hunter/blocks/cube075x1x025.mdl',
    'models/hunter/blocks/cube075x2x025.mdl',
    'models/hunter/blocks/cube075x2x075.mdl',
    'models/hunter/blocks/cube075x3x025.mdl',
    'models/hunter/blocks/cube075x4x025.mdl',
    'models/hunter/blocks/cube075x6x025.mdl',
    'models/hunter/blocks/cube075x8x025.mdl',
    'models/hunter/blocks/cube1x150x1.mdl',
    'models/hunter/blocks/cube1x1x025.mdl',
    'models/hunter/blocks/cube1x1x1.mdl',
    'models/hunter/blocks/cube1x2x025.mdl',
    'models/hunter/blocks/cube1x3x025.mdl',
    'models/hunter/blocks/cube1x4x025.mdl',
    'models/hunter/blocks/cube1x5x025.mdl',
    'models/hunter/blocks/cube1x6x025.mdl',
    'models/hunter/blocks/cube1x7x025.mdl',
    'models/hunter/blocks/cube1x8x025.mdl',
    'models/hunter/blocks/cube2x2x025.mdl',
    'models/hunter/blocks/cube2x3x025.mdl',
    'models/hunter/blocks/cube2x4x025.mdl',
    'models/hunter/blocks/cube2x6x025.mdl',
    'models/hunter/blocks/cube3x3x025.mdl',
    'models/hunter/blocks/cube3x4x025.mdl',
    'models/hunter/blocks/cube3x6x025.mdl',
    'models/hunter/blocks/cube3x8x025.mdl',
    'models/hunter/blocks/cube4x4x025.mdl',
    'models/hunter/blocks/cube8x8x1.mdl',
    'models/hunter/geometric/hex025x1.mdl',
    'models/hunter/geometric/hex1x1.mdl',
    'models/hunter/geometric/pent1x1.mdl',
    'models/hunter/geometric/tri1x1eq.mdl',
    'models/hunter/misc/lift2x2.mdl',
    'models/hunter/misc/platehole1x1a.mdl',
    'models/hunter/misc/platehole4x4.mdl',
    'models/hunter/misc/shell2x2a.mdl',
    'models/hunter/misc/shell2x2b.mdl',
    'models/hunter/misc/shell2x2c.mdl',
    'models/hunter/misc/shell2x2d.mdl',
    'models/hunter/misc/stair1x1.mdl',
    'models/hunter/plates/plate1x1.mdl',
    'models/hunter/plates/plate1x2.mdl',
    'models/hunter/plates/plate1x3.mdl',
    'models/hunter/plates/plate1x4.mdl',
    'models/hunter/plates/plate1x5.mdl',
    'models/hunter/plates/plate1x6.mdl',
    'models/hunter/plates/plate1x7.mdl',
    'models/hunter/plates/plate1x8.mdl',
    'models/hunter/plates/plate2x2.mdl',
    'models/hunter/plates/plate2x3.mdl',
    'models/hunter/plates/plate2x4.mdl',
    'models/hunter/plates/plate2x5.mdl',
    'models/hunter/plates/plate3x3.mdl',
    'models/hunter/plates/plate3x4.mdl',
    'models/hunter/plates/plate3x5.mdl',
    'models/hunter/plates/plate3x6.mdl',
    'models/hunter/plates/plate4x4.mdl',
    'models/hunter/plates/plate5x5.mdl',
    'models/hunter/plates/platehole1x1.mdl',
    'models/hunter/plates/platehole1x2.mdl',
    'models/hunter/plates/platehole2x2.mdl',
    'models/hunter/plates/platehole3.mdl',
    'models/hunter/triangles/025x025.mdl',
    'models/hunter/triangles/025x025mirrored.mdl',
    'models/hunter/triangles/05x05.mdl',
    'models/hunter/triangles/05x05mirrored.mdl',
    'models/hunter/triangles/075x075.mdl',
    'models/hunter/triangles/075x075mirrored.mdl',
    'models/hunter/triangles/1x05x1.mdl',
    'models/hunter/triangles/1x1.mdl',
    'models/hunter/triangles/1x1mirrored.mdl',
    'models/hunter/triangles/1x1x1.mdl',
    'models/hunter/triangles/1x1x5.mdl',
    'models/hunter/triangles/2x2.mdl',
    'models/hunter/triangles/2x2mirrored.mdl',
    'models/hunter/triangles/3x3.mdl',
    'models/hunter/triangles/3x3mirrored.mdl',
    'models/hunter/triangles/4x4.mdl',
    'models/hunter/triangles/4x4mirrored.mdl',
    'models/hunter/triangles/5x5.mdl',
    'models/hunter/tubes/circle2x2.mdl',
    'models/hunter/tubes/circle2x2b.mdl',
    'models/hunter/tubes/circle2x2c.mdl',
    'models/hunter/tubes/circle2x2d.mdl',
    'models/hunter/tubes/circle4x4.mdl',
    'models/hunter/tubes/tube1x1x1.mdl',
    'models/hunter/tubes/tube1x1x1b.mdl',
    'models/hunter/tubes/tube1x1x1c.mdl',
    'models/hunter/tubes/tube1x1x2.mdl',
    'models/hunter/tubes/tube1x1x2b.mdl',
    'models/hunter/tubes/tube1x1x2c.mdl',
    'models/hunter/tubes/tube1x1x3.mdl',
    'models/hunter/tubes/tube1x1x3c.mdl',
    'models/hunter/tubes/tube1x1x4.mdl',
    'models/hunter/tubes/tube1x1x4c.mdl',
    'models/hunter/tubes/tube1x1x4d.mdl',
    'models/hunter/tubes/tube1x1x5.mdl',
    'models/hunter/tubes/tube1x1x5b.mdl',
    'models/hunter/tubes/tube1x1x5c.mdl',
    'models/hunter/tubes/tube1x1x5d.mdl',
    'models/hunter/tubes/tube1x1x6.mdl',
    'models/hunter/tubes/tube1x1x6b.mdl',
    'models/hunter/tubes/tube1x1x6c.mdl',
    'models/hunter/tubes/tube1x1x6d.mdl',
    'models/hunter/tubes/tube1x1x8.mdl',
    'models/hunter/tubes/tube1x1x8b.mdl',
    'models/hunter/tubes/tube1x1x8c.mdl',
    'models/hunter/tubes/tube1x1x8d.mdl',
    'models/hunter/tubes/tube2x2x+.mdl',
    'models/hunter/tubes/tube2x2x025.mdl',
    'models/hunter/tubes/tube2x2x025c.mdl',
    'models/hunter/tubes/tube2x2x05.mdl',
    'models/hunter/tubes/tube2x2x05b.mdl',
    'models/hunter/tubes/tube2x2x05c.mdl',
    'models/hunter/tubes/tube2x2x05d.mdl',
    'models/hunter/tubes/tube2x2x1.mdl',
    'models/hunter/tubes/tube2x2x1b.mdl',
    'models/hunter/tubes/tube2x2x1c.mdl',
    'models/hunter/tubes/tube2x2x1d.mdl',
    'models/hunter/tubes/tube2x2x2.mdl',
    'models/hunter/tubes/tube2x2x2b.mdl',
    'models/hunter/tubes/tube2x2x2c.mdl',
    'models/hunter/tubes/tube2x2x2d.mdl',
    'models/hunter/tubes/tube2x2x4.mdl',
    'models/hunter/tubes/tube2x2x4b.mdl',
    'models/hunter/tubes/tube2x2x4c.mdl',
    'models/hunter/tubes/tube2x2x4d.mdl',
    'models/hunter/tubes/tube2x2x8.mdl',
    'models/hunter/tubes/tube2x2x8b.mdl',
    'models/hunter/tubes/tube2x2x8c.mdl',
    'models/hunter/tubes/tube2x2x8d.mdl',
    'models/hunter/tubes/tube2x2xt.mdl',
    'models/hunter/tubes/tube2x2xta.mdl',
    'models/hunter/tubes/tube2x2xtb.mdl',
    'models/hunter/tubes/tube4x4x05.mdl',
    'models/hunter/tubes/tube4x4x05b.mdl',
    'models/hunter/tubes/tube4x4x05c.mdl',
    'models/hunter/tubes/tube4x4x1.mdl',
    'models/hunter/tubes/tube4x4x1b.mdl',
    'models/hunter/tubes/tube4x4x1c.mdl',
    'models/hunter/tubes/tube4x4x1d.mdl',
    'models/hunter/tubes/tube4x4x1to2x2.mdl',
    'models/hunter/tubes/tube4x4x2b.mdl',
    'models/hunter/tubes/tube4x4x2c.mdl',
    'models/hunter/tubes/tube4x4x2d.mdl',
    'models/hunter/tubes/tubebend1x1x90.mdl',
    'models/hunter/tubes/tubebend1x2x90b.mdl',
    'models/hunter/tubes/tubebend2x2x90.mdl',
    'models/hunter/tubes/tubebend2x2x90outer.mdl',
    'models/hunter/tubes/tubebend2x2x90square.mdl',
    'models/hunter/tubes/tubebendinsidesquare2.mdl',
    'models/hunter/tubes/tubebendoutsidesquare.mdl',
    'models/hunter/tubes/tubebendoutsidesquare2.mdl',
    'models/items/ammocrate_ar2.mdl',
    'models/items/ammocrate_grenade.mdl',
    'models/items/ammocrate_rockets.mdl',
    'models/items/boxmrounds.mdl',
    'models/mechanics/gears2/pinion_20t1.mdl',
    'models/mechanics/gears2/pinion_20t2.mdl',
    'models/mechanics/gears2/pinion_20t3.mdl',
    'models/mechanics/solid_steel/box_beam_4.mdl',
    'models/mechanics/solid_steel/i_beam_4.mdl',
    'models/phxtended/tri1x1x1solid.mdl',
    'models/phxtended/tri2x1x2solid.mdl',
    'models/phxtended/tri2x2x2solid.mdl',
    'models/props/cs_assault/barrelwarning.mdl',
    'models/props/cs_assault/camera.mdl',
    'models/props/cs_assault/dryer_box.mdl',
    'models/props/cs_assault/dryer_box2.mdl',
    'models/props/cs_assault/firehydrant.mdl',
    'models/props/cs_assault/handtruck.mdl',
    'models/props/cs_assault/meter.mdl',
    'models/props/cs_assault/pylon.mdl',
    'models/props/cs_assault/ticketmachine.mdl',
    'models/props/cs_assault/ventilationduct01.mdl',
    'models/props/cs_assault/wall_vent.mdl',
    'models/props/cs_militia/bar01.mdl',
    'models/props/cs_militia/barstool01.mdl',
    'models/props/cs_militia/boxes_frontroom.mdl',
    'models/props/cs_militia/boxes_garage_lower.mdl',
    'models/props/cs_militia/bunkbed2.mdl',
    'models/props/cs_militia/caseofbeer01.mdl',
    'models/props/cs_militia/couch.mdl',
    'models/props/cs_militia/dryer.mdl',
    'models/props/cs_militia/fertilizer.mdl',
    'models/props/cs_militia/food_stack.mdl',
    'models/props/cs_militia/footlocker01_closed.mdl',
    'models/props/cs_militia/footlocker01_open.mdl',
    'models/props/cs_militia/furnace01.mdl',
    'models/props/cs_militia/furniture_shelf01a.mdl',
    'models/props/cs_militia/gun_cabinet.mdl',
    'models/props/cs_militia/haybale_target.mdl',
    'models/props/cs_militia/haybale_target_02.mdl',
    'models/props/cs_militia/haybale_target_03.mdl',
    'models/props/cs_militia/mailbox01.mdl',
    'models/props/cs_militia/newspaperstack01.mdl',
    'models/props/cs_militia/refrigerator01.mdl',
    'models/props/cs_militia/sawhorse.mdl',
    'models/props/cs_militia/shelves.mdl',
    'models/props/cs_militia/shelves_wood.mdl',
    'models/props/cs_militia/table_kitchen.mdl',
    'models/props/cs_militia/table_shed.mdl',
    'models/props/cs_militia/television_console01.mdl',
    'models/props/cs_militia/toilet.mdl',
    'models/props/cs_militia/urine_trough.mdl',
    'models/props/cs_militia/wood_bench.mdl',
    'models/props/cs_militia/wood_table.mdl',
    'models/props/cs_office/computer.mdl',
    'models/props/cs_office/exit_ceiling.mdl',
    'models/props/cs_office/file_cabinet1.mdl',
    'models/props/cs_office/file_cabinet1_group.mdl',
    'models/props/cs_office/fire_extinguisher.mdl',
    'models/props/cs_office/light_security.mdl',
    'models/props/cs_office/microwave.mdl',
    'models/props/cs_office/plant01.mdl',
    'models/props/cs_office/radio.mdl',
    'models/props/cs_office/shelves_metal.mdl',
    'models/props/cs_office/shelves_metal1.mdl',
    'models/props/cs_office/shelves_metal2.mdl',
    'models/props/cs_office/shelves_metal3.mdl',
    'models/props/cs_office/snowman_body.mdl',
    'models/props/cs_office/snowman_nose.mdl',
    'models/props/cs_office/sofa.mdl',
    'models/props/cs_office/sofa_chair.mdl',
    'models/props/cs_office/trash_can_p.mdl',
    'models/props/cs_office/tv_plasma.mdl',
    'models/props/cs_office/vending_machine.mdl',
    'models/props/de_inferno/bed.mdl',
    'models/props/de_inferno/picture1.mdl',
    'models/props/de_inferno/picture2.mdl',
    'models/props/de_inferno/picture3.mdl',
    'models/props/de_nuke/clock.mdl',
    'models/props/de_nuke/crate_extrasmall.mdl',
    'models/props/de_nuke/crate_small.mdl',
    'models/props/de_nuke/industriallight01.mdl',
    'models/props/de_nuke/lifepreserver.mdl',
    'models/props/de_nuke/light_red1.mdl',
    'models/props/de_nuke/light_red2.mdl',
    'models/props/de_nuke/nucleartestcabinet.mdl',
    'models/props/de_prodigy/ammo_can_01.mdl',
    'models/props/de_prodigy/ammo_can_03.mdl',
    'models/props/de_tides/restaurant_table.mdl',
    'models/props/de_tides/tides_staffonly_sign.mdl',
    'models/props/de_tides/vending_turtle.mdl',
    'models/props_borealis/bluebarrel001.mdl',
    'models/props_borealis/borealis_door001a.mdl',
    'models/props_borealis/mooring_cleat01.mdl',
    'models/props_building_details/storefront_template001a_bars.mdl',
    'models/props_c17/bench01a.mdl',
    'models/props_c17/briefcase001a.mdl',
    'models/props_c17/cashregister01a.mdl',
    'models/props_c17/chair_kleiner03a.mdl',
    'models/props_c17/concrete_barrier001a.mdl',
    'models/props_c17/display_cooler01a.mdl',
    'models/props_c17/door01_left.mdl',
    'models/props_c17/door02_double.mdl',
    'models/props_c17/fence01a.mdl',
    'models/props_c17/fence01b.mdl',
    'models/props_c17/fence02a.mdl',
    'models/props_c17/fence02b.mdl',
    'models/props_c17/fence03a.mdl',
    'models/props_c17/furniturecouch001a.mdl',
    'models/props_c17/furniturecouch002a.mdl',
    'models/props_c17/furniturecupboard001a.mdl',
    'models/props_c17/furnituredrawer001a.mdl',
    'models/props_c17/furnituredrawer001a_chunk01.mdl',
    'models/props_c17/furnituredrawer001a_chunk02.mdl',
    'models/props_c17/furnituredrawer001a_chunk03.mdl',
    'models/props_c17/furnituredrawer001a_chunk05.mdl',
    'models/props_c17/furnituredrawer001a_chunk06.mdl',
    'models/props_c17/furnituredrawer002a.mdl',
    'models/props_c17/furnituredrawer003a.mdl',
    'models/props_c17/furnituredresser001a.mdl',
    'models/props_c17/furniturefridge001a.mdl',
    'models/props_c17/furnituremattress001a.mdl',
    'models/props_c17/furnitureradiator001a.mdl',
    'models/props_c17/furnitureshelf001a.mdl',
    'models/props_c17/furnitureshelf001b.mdl',
    'models/props_c17/furnitureshelf002a.mdl',
    'models/props_c17/furnituresink001a.mdl',
    'models/props_c17/furniturestove001a.mdl',
    'models/props_c17/furnituretable001a.mdl',
    'models/props_c17/furnituretable002a.mdl',
    'models/props_c17/furnituretable003a.mdl',
    'models/props_c17/furnituretoilet001a.mdl',
    'models/props_c17/gaspipes006a.mdl',
    'models/props_c17/gate_door01a.mdl',
    'models/props_c17/gravestone001a.mdl',
    'models/props_c17/gravestone002a.mdl',
    'models/props_c17/gravestone003a.mdl',
    'models/props_c17/gravestone004a.mdl',
    'models/props_c17/gravestone_coffinpiece001a.mdl',
    'models/props_c17/gravestone_coffinpiece002a.mdl',
    'models/props_c17/gravestone_cross001b.mdl',
    'models/props_c17/lamp001a.mdl',
    'models/props_c17/lampshade001a.mdl',
    'models/props_c17/lockers001a.mdl',
    'models/props_c17/metalladder001.mdl',
    'models/props_c17/playgroundtick-tack-toe_block01a.mdl',
    'models/props_c17/playground_teetertoter_seat.mdl',
    'models/props_c17/playground_teetertoter_stan.mdl',
    'models/props_c17/pottery02a.mdl',
    'models/props_c17/pottery03a.mdl',
    'models/props_c17/pottery04a.mdl',
    'models/props_c17/pottery05a.mdl',
    'models/props_c17/pottery06a.mdl',
    'models/props_c17/pottery07a.mdl',
    'models/props_c17/pottery08a.mdl',
    'models/props_c17/pottery09a.mdl',
    'models/props_c17/pottery_large01a.mdl',
    'models/props_c17/shelfunit01a.mdl',
    'models/props_c17/streetsign001c.mdl',
    'models/props_c17/streetsign002b.mdl',
    'models/props_c17/streetsign003b.mdl',
    'models/props_c17/streetsign004e.mdl',
    'models/props_c17/streetsign004f.mdl',
    'models/props_c17/streetsign005b.mdl',
    'models/props_c17/streetsign005c.mdl',
    'models/props_c17/streetsign005d.mdl',
    'models/props_c17/tv_monitor01.mdl',
    'models/props_combine/breenbust.mdl',
    'models/props_combine/breenclock.mdl',
    'models/props_combine/breenconsole.mdl',
    'models/props_combine/breendesk.mdl',
    'models/props_combine/breenglobe.mdl',
    'models/props_combine/breenpod.mdl',
    'models/props_combine/breenpod_inner.mdl',
    'models/props_combine/cell_01_pod.mdl',
    'models/props_combine/cell_01_pod_cheap.mdl',
    'models/props_combine/combine_barricade_med01a.mdl',
    'models/props_combine/combine_barricade_med01b.mdl',
    'models/props_combine/combine_barricade_med02a.mdl',
    'models/props_combine/combine_barricade_med02b.mdl',
    'models/props_combine/combine_barricade_med02c.mdl',
    'models/props_combine/combine_barricade_med03b.mdl',
    'models/props_combine/combine_barricade_med04b.mdl',
    'models/props_combine/combine_barricade_short01a.mdl',
    'models/props_combine/combine_barricade_short02a.mdl',
    'models/props_combine/combine_barricade_short03a.mdl',
    'models/props_combine/combine_barricade_tall01a.mdl',
    'models/props_combine/combine_barricade_tall01b.mdl',
    'models/props_combine/combine_barricade_tall03a.mdl',
    'models/props_combine/combine_barricade_tall03b.mdl',
    'models/props_combine/combine_barricade_tall04a.mdl',
    'models/props_combine/combine_barricade_tall04b.mdl',
    'models/props_combine/combine_booth_med01a.mdl',
    'models/props_combine/combine_booth_short01a.mdl',
    'models/props_combine/combine_emitter01.mdl',
    'models/props_combine/combine_fence01a.mdl',
    'models/props_combine/combine_fence01b.mdl',
    'models/props_combine/combine_interface001.mdl',
    'models/props_combine/combine_interface002.mdl',
    'models/props_combine/combine_interface003.mdl',
    'models/props_combine/combine_intwallunit.mdl',
    'models/props_combine/combine_window001.mdl',
    'models/props_debris/metal_panel01a.mdl',
    'models/props_debris/metal_panel02a.mdl',
    'models/props_debris/wall001a_base.mdl',
    'models/props_docks/dock01_pole01a_128.mdl',
    'models/props_docks/dock01_pole01a_256.mdl',
    'models/props_doors/door03_slotted_left.mdl',
    'models/props_industrial/bridge_deck.mdl',
    'models/props_interiors/furniture_chair03a.mdl',
    'models/props_interiors/furniture_couch01a.mdl',
    'models/props_interiors/furniture_couch02a.mdl',
    'models/props_interiors/furniture_desk01a.mdl',
    'models/props_interiors/furniture_lamp01a.mdl',
    'models/props_interiors/furniture_shelf01a.mdl',
    'models/props_interiors/furniture_vanity01a.mdl',
    'models/props_interiors/pot01a.mdl',
    'models/props_interiors/pot02a.mdl',
    'models/props_interiors/radiator01a.mdl',
    'models/props_interiors/refrigerator01a.mdl',
    'models/props_interiors/refrigeratordoor01a.mdl',
    'models/props_interiors/refrigeratordoor02a.mdl',
    'models/props_interiors/sinkkitchen01a.mdl',
    'models/props_interiors/vendingmachinesoda01a_door.mdl',
    'models/props_junk/cardboard_box001a.mdl',
    'models/props_junk/cardboard_box001a_gib01.mdl',
    'models/props_junk/cardboard_box001b.mdl',
    'models/props_junk/cardboard_box002a.mdl',
    'models/props_junk/cardboard_box002a_gib01.mdl',
    'models/props_junk/cardboard_box002b.mdl',
    'models/props_junk/cinderblock01a.mdl',
    'models/props_junk/garbage128_composite001b.mdl',
    'models/props_junk/garbage128_composite001c.mdl',
    'models/props_junk/harpoon002a.mdl',
    'models/props_junk/metalbucket01a.mdl',
    'models/props_junk/metalbucket02a.mdl',
    'models/props_junk/plasticbucket001a.mdl',
    'models/props_junk/plasticcrate01a.mdl',
    'models/props_junk/pushcart01a.mdl',
    'models/props_junk/ravenholmsign.mdl',
    'models/props_junk/shovel01a.mdl',
    'models/props_junk/trafficcone001a.mdl',
    'models/props_junk/trashbin01a.mdl',
    'models/props_junk/wood_crate001a.mdl',
    'models/props_junk/wood_crate001a_damaged.mdl',
    'models/props_junk/wood_crate002a.mdl',
    'models/props_lab/bewaredog.mdl',
    'models/props_lab/blastdoor001a.mdl',
    'models/props_lab/blastdoor001b.mdl',
    'models/props_lab/blastdoor001c.mdl',
    'models/props_lab/cactus.mdl',
    'models/props_lab/desklamp01.mdl',
    'models/props_lab/filecabinet02.mdl',
    'models/props_lab/frame002a.mdl',
    'models/props_lab/harddrive01.mdl',
    'models/props_lab/huladoll.mdl',
    'models/props_lab/kennel_physics.mdl',
    'models/props_lab/monitor01a.mdl',
    'models/props_lab/monitor01b.mdl',
    'models/props_lab/monitor02.mdl',
    'models/props_lab/reciever01a.mdl',
    'models/props_lab/workspace003.mdl',
    'models/props_phx/construct/concrete_barrier00.mdl',
    'models/props_phx/construct/concrete_barrier01.mdl',
    'models/props_phx/construct/glass/glass_angle180.mdl',
    'models/props_phx/construct/glass/glass_angle360.mdl',
    'models/props_phx/construct/glass/glass_angle90.mdl',
    'models/props_phx/construct/glass/glass_curve180x1.mdl',
    'models/props_phx/construct/glass/glass_curve180x2.mdl',
    'models/props_phx/construct/glass/glass_curve360x1.mdl',
    'models/props_phx/construct/glass/glass_curve360x2.mdl',
    'models/props_phx/construct/glass/glass_curve90x1.mdl',
    'models/props_phx/construct/glass/glass_curve90x2.mdl',
    'models/props_phx/construct/glass/glass_dome180.mdl',
    'models/props_phx/construct/glass/glass_dome360.mdl',
    'models/props_phx/construct/glass/glass_dome90.mdl',
    'models/props_phx/construct/glass/glass_plate1x1.mdl',
    'models/props_phx/construct/glass/glass_plate1x2.mdl',
    'models/props_phx/construct/glass/glass_plate2x2.mdl',
    'models/props_phx/construct/glass/glass_plate2x4.mdl',
    'models/props_phx/construct/glass/glass_plate4x4.mdl',
    'models/props_phx/construct/metal_angle180.mdl',
    'models/props_phx/construct/metal_angle360.mdl',
    'models/props_phx/construct/metal_angle90.mdl',
    'models/props_phx/construct/metal_dome180.mdl',
    'models/props_phx/construct/metal_dome360.mdl',
    'models/props_phx/construct/metal_dome90.mdl',
    'models/props_phx/construct/metal_plate1.mdl',
    'models/props_phx/construct/metal_plate1x2.mdl',
    'models/props_phx/construct/metal_plate1x2_tri.mdl',
    'models/props_phx/construct/metal_plate1_tri.mdl',
    'models/props_phx/construct/metal_plate2x2.mdl',
    'models/props_phx/construct/metal_plate2x2_tri.mdl',
    'models/props_phx/construct/metal_plate2x4.mdl',
    'models/props_phx/construct/metal_plate2x4_tri.mdl',
    'models/props_phx/construct/metal_plate4x4.mdl',
    'models/props_phx/construct/metal_plate4x4_tri.mdl',
    'models/props_phx/construct/metal_plate_curve.mdl',
    'models/props_phx/construct/metal_plate_curve180.mdl',
    'models/props_phx/construct/metal_plate_curve180x2.mdl',
    'models/props_phx/construct/metal_plate_curve2.mdl',
    'models/props_phx/construct/metal_plate_curve2x2.mdl',
    'models/props_phx/construct/metal_plate_curve360.mdl',
    'models/props_phx/construct/metal_plate_curve360x2.mdl',
    'models/props_phx/construct/metal_plate_pipe.mdl',
    'models/props_phx/construct/metal_tube.mdl',
    'models/props_phx/construct/metal_tubex2.mdl',
    'models/props_phx/construct/metal_wire1x1.mdl',
    'models/props_phx/construct/metal_wire1x1x1.mdl',
    'models/props_phx/construct/metal_wire1x1x2.mdl',
    'models/props_phx/construct/metal_wire1x1x2b.mdl',
    'models/props_phx/construct/metal_wire1x2.mdl',
    'models/props_phx/construct/metal_wire1x2b.mdl',
    'models/props_phx/construct/metal_wire1x2x2b.mdl',
    'models/props_phx/construct/metal_wire2x2.mdl',
    'models/props_phx/construct/metal_wire2x2b.mdl',
    'models/props_phx/construct/metal_wire2x2x2b.mdl',
    'models/props_phx/construct/metal_wire_angle180x1.mdl',
    'models/props_phx/construct/metal_wire_angle180x2.mdl',
    'models/props_phx/construct/metal_wire_angle360x1.mdl',
    'models/props_phx/construct/metal_wire_angle360x2.mdl',
    'models/props_phx/construct/metal_wire_angle90x1.mdl',
    'models/props_phx/construct/metal_wire_angle90x2.mdl',
    'models/props_phx/construct/plastic/plastic_angle_360.mdl',
    'models/props_phx/construct/windows/window1x1.mdl',
    'models/props_phx/construct/windows/window1x2.mdl',
    'models/props_phx/construct/windows/window2x2.mdl',
    'models/props_phx/construct/windows/window2x4.mdl',
    'models/props_phx/construct/windows/window4x4.mdl',
    'models/props_phx/construct/windows/window_angle180.mdl',
    'models/props_phx/construct/windows/window_angle360.mdl',
    'models/props_phx/construct/windows/window_angle90.mdl',
    'models/props_phx/construct/windows/window_curve180x1.mdl',
    'models/props_phx/construct/windows/window_curve180x2.mdl',
    'models/props_phx/construct/windows/window_curve360x1.mdl',
    'models/props_phx/construct/windows/window_curve90x1.mdl',
    'models/props_phx/construct/windows/window_curve90x2.mdl',
    'models/props_phx/construct/wood/wood_angle180.mdl',
    'models/props_phx/construct/wood/wood_angle360.mdl',
    'models/props_phx/construct/wood/wood_angle90.mdl',
    'models/props_phx/construct/wood/wood_boardx1.mdl',
    'models/props_phx/construct/wood/wood_boardx2.mdl',
    'models/props_phx/construct/wood/wood_curve180x1.mdl',
    'models/props_phx/construct/wood/wood_curve180x2.mdl',
    'models/props_phx/construct/wood/wood_curve360x1.mdl',
    'models/props_phx/construct/wood/wood_curve360x2.mdl',
    'models/props_phx/construct/wood/wood_curve90x1.mdl',
    'models/props_phx/construct/wood/wood_curve90x2.mdl',
    'models/props_phx/construct/wood/wood_dome180.mdl',
    'models/props_phx/construct/wood/wood_dome360.mdl',
    'models/props_phx/construct/wood/wood_dome90.mdl',
    'models/props_phx/construct/wood/wood_panel1x1.mdl',
    'models/props_phx/construct/wood/wood_panel1x2.mdl',
    'models/props_phx/construct/wood/wood_panel2x2.mdl',
    'models/props_phx/construct/wood/wood_panel2x4.mdl',
    'models/props_phx/construct/wood/wood_panel4x4.mdl',
    'models/props_phx/construct/wood/wood_wire1x1.mdl',
    'models/props_phx/construct/wood/wood_wire1x1x1.mdl',
    'models/props_phx/construct/wood/wood_wire1x1x2.mdl',
    'models/props_phx/construct/wood/wood_wire1x1x2b.mdl',
    'models/props_phx/construct/wood/wood_wire1x2.mdl',
    'models/props_phx/construct/wood/wood_wire1x2b.mdl',
    'models/props_phx/construct/wood/wood_wire1x2x2b.mdl',
    'models/props_phx/construct/wood/wood_wire2x2.mdl',
    'models/props_phx/construct/wood/wood_wire2x2b.mdl',
    'models/props_phx/construct/wood/wood_wire2x2x2b.mdl',
    'models/props_phx/games/chess/black_bishop.mdl',
    'models/props_phx/games/chess/black_dama.mdl',
    'models/props_phx/games/chess/black_king.mdl',
    'models/props_phx/games/chess/black_knight.mdl',
    'models/props_phx/games/chess/black_pawn.mdl',
    'models/props_phx/games/chess/black_queen.mdl',
    'models/props_phx/games/chess/black_rook.mdl',
    'models/props_phx/games/chess/white_bishop.mdl',
    'models/props_phx/games/chess/white_dama.mdl',
    'models/props_phx/games/chess/white_king.mdl',
    'models/props_phx/games/chess/white_knight.mdl',
    'models/props_phx/games/chess/white_pawn.mdl',
    'models/props_phx/games/chess/white_queen.mdl',
    'models/props_phx/games/chess/white_rook.mdl',
    'models/props_phx/rt_screen.mdl',
    'models/props_rooftop/satellitedish02.mdl',
    'models/props_trainstation/bench_indoor001a.mdl',
    'models/props_trainstation/payphone001a.mdl',
    'models/props_trainstation/tracksign02.mdl',
    'models/props_trainstation/tracksign07.mdl',
    'models/props_trainstation/tracksign08.mdl',
    'models/props_trainstation/tracksign09.mdl',
    'models/props_trainstation/tracksign10.mdl',
    'models/props_trainstation/traincar_seats001.mdl',
    'models/props_trainstation/trainstation_clock001.mdl',
    'models/props_trainstation/trainstation_post001.mdl',
    'models/props_wasteland/barricade001a.mdl',
    'models/props_wasteland/barricade002a.mdl',
    'models/props_wasteland/cafeteria_table001a.mdl',
    'models/props_wasteland/controlroom_desk001a.mdl',
    'models/props_wasteland/controlroom_desk001b.mdl',
    'models/props_wasteland/controlroom_filecabinet001a.mdl',
    'models/props_wasteland/controlroom_filecabinet002a.mdl',
    'models/props_wasteland/controlroom_storagecloset001a.mdl',
    'models/props_wasteland/exterior_fence001a.mdl',
    'models/props_wasteland/exterior_fence001b.mdl',
    'models/props_wasteland/exterior_fence002a.mdl',
    'models/props_wasteland/exterior_fence002b.mdl',
    'models/props_wasteland/exterior_fence002c.mdl',
    'models/props_wasteland/exterior_fence002d.mdl',
    'models/props_wasteland/exterior_fence003a.mdl',
    'models/props_wasteland/exterior_fence003b.mdl',
    'models/props_wasteland/interior_fence001a.mdl',
    'models/props_wasteland/interior_fence001b.mdl',
    'models/props_wasteland/interior_fence001c.mdl',
    'models/props_wasteland/interior_fence001d.mdl',
    'models/props_wasteland/interior_fence001e.mdl',
    'models/props_wasteland/interior_fence001g.mdl',
    'models/props_wasteland/interior_fence002a.mdl',
    'models/props_wasteland/interior_fence002b.mdl',
    'models/props_wasteland/interior_fence002c.mdl',
    'models/props_wasteland/interior_fence002d.mdl',
    'models/props_wasteland/interior_fence002e.mdl',
    'models/props_wasteland/interior_fence002f.mdl',
    'models/props_wasteland/interior_fence003a.mdl',
    'models/props_wasteland/interior_fence003b.mdl',
    'models/props_wasteland/interior_fence003d.mdl',
    'models/props_wasteland/interior_fence003e.mdl',
    'models/props_wasteland/kitchen_counter001a.mdl',
    'models/props_wasteland/kitchen_counter001b.mdl',
    'models/props_wasteland/kitchen_counter001c.mdl',
    'models/props_wasteland/kitchen_fridge001a.mdl',
    'models/props_wasteland/kitchen_shelf001a.mdl',
    'models/props_wasteland/kitchen_shelf002a.mdl',
    'models/props_wasteland/laundry_cart001.mdl',
    'models/props_wasteland/laundry_cart002.mdl',
    'models/props_wasteland/light_spotlight01_lamp.mdl',
    'models/props_wasteland/prison_celldoor001a.mdl',
    'models/props_wasteland/prison_celldoor001b.mdl',
    'models/props_wasteland/prison_cellwindow002a.mdl',
    'models/props_wasteland/prison_heater001a.mdl',
    'models/props_wasteland/prison_shelf002a.mdl',
    'models/props_wasteland/wood_fence02a.mdl'
}
