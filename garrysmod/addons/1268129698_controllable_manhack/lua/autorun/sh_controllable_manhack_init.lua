AddCSLuaFile()

ControllableManhack = ControllableManhack or {}

ControllableManhack.INSTANCE = {}
ControllableManhack.INSTANCE.SHARED = 1
ControllableManhack.INSTANCE.SERVER = 2
ControllableManhack.INSTANCE.CLIENT = 3

--Easier way to include files
function ControllableManhack.Include(path, instance)
	if SERVER then
		if instance == ControllableManhack.INSTANCE.SHARED or instance == ControllableManhack.INSTANCE.CLIENT then
			AddCSLuaFile(path)
		end

		if instance == ControllableManhack.INSTANCE.SHARED or instance == ControllableManhack.INSTANCE.SERVER then
			include(path)
		end
	end

	if CLIENT and (instance == ControllableManhack.INSTANCE.SHARED or instance == ControllableManhack.INSTANCE.CLIENT) then
		include(path)
	end
end

ControllableManhack.Include("controllable_manhack/sh_convars.lua", ControllableManhack.INSTANCE.SHARED)

ControllableManhack.Include("controllable_manhack/sh_misc.lua", ControllableManhack.INSTANCE.SHARED)
ControllableManhack.Include("controllable_manhack/sv_misc.lua", ControllableManhack.INSTANCE.SERVER)

ControllableManhack.Include("controllable_manhack/sh_hook_override.lua", ControllableManhack.INSTANCE.SHARED)

ControllableManhack.Include("controllable_manhack/sh_ammo_types.lua", ControllableManhack.INSTANCE.SHARED)
ControllableManhack.Include("controllable_manhack/cl_ammo_types.lua", ControllableManhack.INSTANCE.CLIENT)

ControllableManhack.Include("controllable_manhack/cl_kill_icons.lua", ControllableManhack.INSTANCE.CLIENT)
