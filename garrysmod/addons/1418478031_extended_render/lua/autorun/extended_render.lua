ExtendedRender = {} 

function ExtendedRender:IncludeFile( file )
	if SERVER then
		AddCSLuaFile(file)
		include(file)
	end
	if CLIENT then
		include(file)
	end
end

function ExtendedRender:IncludeDirectory( dir )
	local files, directories = file.Find( dir .. "/*.lua", "LUA")
	for _, file in pairs(files) do
		ExtendedRender:IncludeFile( dir .. "/" .. file);
	end
end

function ExtendedRender:Initialization()
	ExtendedRender:IncludeFile( "extended_render/data.lua" )
	ExtendedRender:IncludeFile( "extended_render/util.lua" ) 
	ExtendedRender:IncludeDirectory( "extended_render/packages" ) 
	
	ExtendedRender:IncludeFile( "extended_render/config.lua" )
	ExtendedRender:IncludeFile( "extended_render/part_class.lua" )
	ExtendedRender:IncludeFile( "extended_render/parts.lua" ) 
	
	ExtendedRender:IncludeDirectory( "extended_render/modules" )
end

ExtendedRender:Initialization()