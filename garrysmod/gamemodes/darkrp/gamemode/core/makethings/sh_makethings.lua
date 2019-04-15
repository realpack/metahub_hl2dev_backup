local blockTypes = {"Physgun1", "Spawning1", "Toolgun1"}

local checkModel = function(model) return model ~= nil and (CLIENT or util.IsValidModel(model)) end
local requiredTeamItems = {"color", "description", "weapons", "command", "max"}
local validShipment = {model = checkModel, "entity", "price", "amount", "seperate", "allowed"}
local validVehicle = {"name", model = checkModel, "price"}
local validEntity = {"ent", model = checkModel, "price", "max", "name"}
local function checkValid(tbl, requiredItems)
	for k,v in pairs(requiredItems) do
		local isFunction = type(v) == "function"

		if (isFunction and not v(tbl[k])) or (not isFunction and tbl[v] == nil) then
			return isFunction and k or v
		end
	end
end

rp.pocket = {}

rp.teams = {}
function rp.addTeam(Name, CustomTeam)
	CustomTeam.name = Name

	-- local corrupt = checkValid(CustomTeam, requiredTeamItems)
	-- if corrupt then ErrorNoHalt("Corrupt team \"" ..(CustomTeam.name or "") .. "\": element " .. corrupt .. " is incorrect.\n") end

	table.insert(rp.teams, CustomTeam)
	team.SetUp(#rp.teams, Name, CustomTeam.color)
	local t = #rp.teams
	CustomTeam.team = t

	timer.Simple(0, function() GAMEMODE:AddTeamCommands(CustomTeam, CustomTeam.max) end)

	for k, v in pairs(CustomTeam.spawns or {}) do
		rp.cfg.TeamSpawns[k] = rp.cfg.TeamSpawns[k] or {}
		rp.cfg.TeamSpawns[k][t] = v
	end

	// Precache model here. Not right before the job change is done
	if type(CustomTeam.model) == "table" then
		for k,v in pairs(CustomTeam.model) do util.PrecacheModel(v) end
	elseif CustomTeam.model then
		util.PrecacheModel(CustomTeam.model)
	end
	return t
end

rp.teamDoors = {}
function rp.AddDoorGroup(name, ...)
    -- print(123, istable(...))
	rp.teamDoors[name] = rp.teamDoors[name] or {}
	for k, v in ipairs(istable(...) and ... or {...}) do
		rp.teamDoors[name][v] = true
	end
end

rp.shipments = {}
function rp.AddShipment(name, model, entity, price, Amount_of_guns_in_one_shipment, Sold_seperately, price_seperately, noshipment, classes, shipmodel, CustomCheck, bodygroup)
	local tableSyntaxUsed = type(model) == "table"

	local AllowedClasses = classes or {}
	if not classes then
		for k,v in ipairs(team.GetAllTeams()) do
			table.insert(AllowedClasses, k)
		end
	end

	local price = tonumber(price)
	local shipmentmodel = shipmodel or "models/Items/item_item_crate.mdl"

	local customShipment = tableSyntaxUsed and model or
		{model = model, entity = entity, price = price, amount = Amount_of_guns_in_one_shipment,
		seperate = Sold_seperately, pricesep = price_seperately, noship = noshipment, allowed = AllowedClasses,
		shipmodel = shipmentmodel, customCheck = CustomCheck, weight = 5, bodygroup = bodygroup}

	customShipment.seperate = customShipment.separate or customShipment.seperate
	customShipment.name = name
	customShipment.allowed = customShipment.allowed or {}

	for k, v in ipairs(customShipment.allowed) do
		customShipment.allowed[v] = true
	end

	local corrupt = checkValid(customShipment, validShipment)
	if corrupt then ErrorNoHalt("Corrupt shipment \"" .. (name or "") .. "\": element " .. corrupt .. " is corrupt.\n") end

	if SERVER then
		rp.nodamage[entity] = true
	end

	rp.inv.Wl[entity] = name

	table.insert(rp.shipments, customShipment)
	table.insert(rp.pocket, customShipment)
	util.PrecacheModel(customShipment.model)
end

/*---------------------------------------------------------------------------
Decides whether a custom job or shipmet or whatever can be used in a certain map
---------------------------------------------------------------------------*/
function GM:CustomObjFitsMap(obj)
	if not obj or not obj.maps then return true end

	local map = string.lower(game.GetMap())
	for k,v in pairs(obj.maps) do
		if string.lower(v) == map then return true end
	end
	return false
end

rp.entities = {}
rp.nodamage = rp.nodamage or {}
function rp.AddEntity(name, entity, model, price, max, command, classes, pocket)
	local tableSyntaxUsed = type(entity) == "table"

	local tblEnt = tableSyntaxUsed and entity or
		{ent = entity, model = model, price = price, max = max,
		cmd = command, allowed = classes, pocket = pocket}
	tblEnt.name = name
	tblEnt.allowed = tblEnt.allowed or {}

	if type(tblEnt.allowed) == "number" then
		tblEnt.allowed = {tblEnt.allowed}
	end

	if #tblEnt.allowed == 0 then
		for k,v in ipairs(team.GetAllTeams()) do
			table.insert(tblEnt.allowed, k)
		end
	end

	-- local corrupt = checkValid(tblEnt, validEntity)
	-- if corrupt then ErrorNoHalt("Corrupt Entity \"" .. (name or "") .. "\": element " .. corrupt .. " is corrupt.\n") end

	if SERVER then
		rp.nodamage[entity] = true
	end

	for k, v in ipairs(tblEnt.allowed) do
		tblEnt.allowed[v] = true
	end

	table.insert(rp.entities, tblEnt)
	timer.Simple(0, function()
		if tblEnt.cmd and tblEnt.cmd ~= '' then
			GAMEMODE:AddEntityCommands(tblEnt)
		end
	end)

	if (tblEnt.pocket ~= false) then
		rp.inv.Wl[tblEnt.ent] = name
	end

	table.insert(rp.pocket, tblEnt)
end

rp.CopItems = {}
function rp.AddCopItem(name, price, model, weapon, callback)
	if istable(price) then
		rp.CopItems[name] = {
			Name = name,
			Price = price.Price,
			Model = price.Model,
			Weapon = price.Weapon,
			Callback = price.Callback
		}
	else
		rp.CopItems[name] = {
			Name = name,
			Price = price,
			Model = model,
			Weapon = weapon,
			Callback = callback
		}
	end
end

-- rp.Drugs = {}
-- function rp.AddDrug(name, ent, model, cost, class)
-- 	local tab = {Name = name, Class = ent, Model = model, BuyPrice = math.ceil(cost * .50)}
-- 	rp.Drugs[#rp.Drugs + 1] = tab
-- 	rp.Drugs[ent] = tab
-- 	rp.AddShipment(name, model, ent, math.ceil(cost * 10), 10, false, math.ceil(cost * 1.3), false, {class})
-- end

function rp.AddWeapon(name, model, entity, price, Amount_of_guns_in_one_shipment, Sold_seperately, price_seperately, noshipment, classes)
	rp.AddShipment(name, model, entity, price, Amount_of_guns_in_one_shipment, Sold_seperately, price_seperately, noshipment, classes)
	rp.AddCopItem(name, price_seperately, model, entity)
end

rp.clothes = {}
function rp.AddClothe(name, model, entity, price, Amount_of_guns_in_one_shipment, Sold_seperately, price_seperately, noshipment, classes, bodygroup)

    local ENT = {}
	ENT.Base = "spawned_clothe"
	ENT.PrintName = name
    ENT.Model = model

	ENT.Category = "MetaHub Clothes"
	ENT.Spawnable = false
	-- ENT.AdminSpawnable = true

    ENT.bodygroup = bodygroup

	scripted_ents.Register( ENT, entity )

    -- table.insert(rp.clothes, entity)
    rp.clothes[entity] = true

	rp.AddShipment(name, model, entity, price, Amount_of_guns_in_one_shipment, Sold_seperately, price_seperately, noshipment, classes, nil, nil, bodygroup)
end

rp.agendas = {}
function rp.AddAgenda(title, manager, listeners)
	for k, v in ipairs(listeners) do
		rp.agendas[v] = {title = title, manager = manager}
	end
	rp.agendas[manager] = {title = title, manager = manager}

	nw.Register('Agenda;' .. manager, {
		Read 	= net.ReadString,
		Write 	= net.WriteString,
		GlobalVar = true
	})
end

rp.groupChats = {}
function rp.addGroupChat(...)
	local classes = {...}
	table.foreach(classes, function(k, class)
		rp.groupChats[class] = {}
		table.foreach(classes, function(k, class2)
			rp.groupChats[class][class2] = true
		end)
	end)
end


rp.ammoTypes = {}
function rp.AddAmmoType(ammoType, name, model, price, amountGiven, customCheck)
	table.insert(rp.ammoTypes, {
		ammoType = ammoType,
		name = name,
		model = model,
		price = price,
		amountGiven = amountGiven,
		customCheck = customCheck
	})
end

