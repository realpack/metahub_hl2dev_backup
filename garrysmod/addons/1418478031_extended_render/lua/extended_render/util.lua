ExtendedRender.Util = {}

function ExtendedRender.Util:MultiplyPosition( coord, size, offset )
	return ( coord - size / 2 ) * offset + size / 2
end

function ExtendedRender.Util:LoadMaterials( obj )
	for i, material in pairs( obj.materials ) do
		local mat = Material( material.textureID )
		obj.materials[i].material = mat
	end
end