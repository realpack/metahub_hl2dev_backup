function rp.inv.Add(ID, Title, SubTitle, Model)
	table.insert(rp.inv.Data, {
		ID = ID,
		Title = Title,
		SubTitle = SubTitle,
		Model = Model
	  });
end

function rp.inv.Remove(ID)
	if (!ID) then return; end

	if (type(ID) == "number") then
		for k, v in pairs(rp.inv.Data) do
			if (v.ID == ID) then
				table.remove(rp.inv.Data, k);
				return;
			end
		end
	end
end

function rp.inv.EnableMenu(pl, contents)
	if (rp.inv.UI and rp.inv.UI:IsValid()) then return; end

	rp.inv.UI = vgui.Create("Pocket");

	if (contents) then
		rp.inv.UI:InitInspect(pl, contents)
	else
		rp.inv.UI:InitLocal()
	end
end

function rp.inv.DisableMenu()
  if (!rp.inv.UI or !rp.inv.UI:IsValid()) then return; end
	rp.inv.UI:Close();
end

net.Receive("Pocket.Load", function()
	local contents = net.ReadTable();
    rp.inv.Data = {}
	for k, v in pairs(contents) do
		if v.contents then
			rp.inv.Add(k, rp.shipments[v.contents].name,  "В ящике " .. v.count .. " шт.", v.Model);
		else
			rp.inv.Add(k, v.Title or rp.inv.Wl[v.Class], "", v.Model);
		end
	end
end);

net.Receive("Pocket.AddItem", function()
	rp.inv.Add(net.ReadUInt(32), net.ReadString(), net.ReadString(), net.ReadString())
	-- rp.inv.DisableMenu()
end);

net.Receive("Pocket.RemoveItem", function()
	rp.inv.Remove(net.ReadUInt(32))
	-- rp.inv.DisableMenu()
end)

net.Receive("Pocket.Inspect", function()
	local pl = net.ReadEntity()
	local contents = net.ReadTable()

	for k, v in pairs(contents) do
		v.ID = k
		if (v.contents) then
			v.Title = rp.shipments[v.contents].name
			v.SubTitle = "В ящике " .. v.count .. " шт."
		else
			v.Title = rp.inv.Wl[v.Class]
			v.SubTitle = ''
		end
	end

	rp.inv.EnableMenu(pl, contents)
end)
