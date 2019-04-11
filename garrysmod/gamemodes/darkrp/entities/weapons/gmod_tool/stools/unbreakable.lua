TOOL.Category	= 'Constraints'
TOOL.Name		= '#tool.unbreakable.name'

if (CLIENT) then
	language.Add('tool.unbreakable.name', 'Unbreakable')
	language.Add('tool.unbreakable.desc', 'Make a prop unbreakable')
	language.Add('tool.unbreakable.0', 'Left click to make a prop unbreakable. Right click to restore its previous settings')
else
	hook.Add('InitPostEntity', 'unbreakable.InitPostEntity', function()
		local ent = ents.Create('filter_activator_name')
		ent:SetKeyValue('TargetName', 'FilterDamage')
		ent:SetKeyValue('negated', '1')
		ent:Spawn()
	end)
end

local function ToogleUnbreakable(Player, Entity, Data)
	if Data.Unbreakable then
		Entity:Fire('SetDamageFilter', 'FilterDamage', 0)
	else
		Entity:Fire('SetDamageFilter', '', 0)
	end
	
	if (SERVER) then
		duplicator.StoreEntityModifier(Entity, 'unbreakable', Data)
	end
end
duplicator.RegisterEntityModifier('unbreakable', ToogleUnbreakable)

local data = {}
function TOOL:LeftClick(tr)
	if IsValid(tr.Entity) then
		if (SERVER) then
			data.Unbreakable = true
			ToogleUnbreakable(self:GetOwner(), tr.Entity, data)
		end
		return true
	end
	return false
end

function TOOL:RightClick(tr)
	if IsValid(tr.Entity) then
		if (SERVER) then
			data.Unbreakable = false
			ToogleUnbreakable(self:GetOwner(), tr.Entity, data)
		end
		return true
	end
	return false
end

function TOOL.BuildCPanel(Panel)
	Panel:AddControl('Header', { 
		Text = '#tool.unbreakable.name', 
		Description = '#tool.unbreakable.0'
	})
end