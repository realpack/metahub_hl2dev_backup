local EML_Ingedients = {"eml_iodine", "eml_macid", "eml_sulfur", "eml_water"}
local EML_Products = {"eml_redp", "eml_ciodine", "eml_meth"}
local EML_Cookware = {"eml_pot", "eml_spot", "eml_jar"}

hook.Add("playerBoughtCustomEntity", "EML_StuffPurchased", function(player, entityTab, entity, num)
	if (EML_Ingredients_Physgun) then
		if table.HasValue(EML_Ingedients, entity:GetClass()) then
			entity:CPPISetOwner(player);
		end;
	end;

	if (EML_Products_Physgun) then
		if table.HasValue(EML_Products, entity:GetClass()) then
			entity:CPPISetOwner(player);
		end;
	end;
	
	if (EML_Cookware_Physgun) then
		if table.HasValue(EML_Cookware, entity:GetClass()) then
			entity:CPPISetOwner(player);
		end;
	end;
	
	if (EML_Gas_Physgun) then
		if (entity:GetClass() == "eml_gas") then
			entity:CPPISetOwner(player);
		end;
	end;
	
	if (EML_Stove_Physgun) then
		if (entity:GetClass() == "eml_stove") then
			entity:CPPISetOwner(player);
		end;
	end;
end);