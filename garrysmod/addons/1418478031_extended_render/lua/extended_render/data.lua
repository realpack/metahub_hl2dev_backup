ExtendedRender.Data = {}
ExtendedRender.Data.Storage = {
	["Packages"] = {}
}

function ExtendedRender.Data:RegisterCategory( category )
	self.Storage[category] = {}
end

function ExtendedRender.Data:Include( category, data )
	if self.Storage[category] then
		table.Merge( self.Storage[category], data )
	end
end