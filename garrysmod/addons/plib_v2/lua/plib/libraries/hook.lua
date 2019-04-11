hook = setmetatable({}, {
	__call = function(self, name, id, func)
		return self.Add(name, id, func)
	end
})

local hook 			= hook
local table_remove 	= table.remove
local debug_info 	= debug.getinfo
local type 			= type
local ipairs 		= ipairs
local IsValid 		= IsValid

local hooks 		= {}
local mappings 		= {}

hook.GetTable = function()
	return table.Copy(mappings)
end

hook.Call = function(name, gm, ...) 
	local a, b, c, d, e
	if hooks[name] ~= nil then
		for k,v in ipairs(hooks[name]) do
			a, b, c, d, e = v(...)
			if a ~= nil then
				return a, b, c, d, e
			end
		end
	end
	if gm ~= nil then
		if gm[name] then
			return gm[name](gm, ...)
		end
	end
end

local hook_Call = hook.Call
hook.Run = function(name, ...)
	return hook_Call(name, GAMEMODE, ...)
end

hook.Remove = function(name, id)
	local collection = hooks[name]
	if collection ~= nil then
		local func = mappings[name][id]
		if func ~= nil then
			for k,v in ipairs(collection) do
				if func == v then
					table_remove(collection, k)
					break 
				end
			end
		end
		mappings[name][id] = nil
	end
end

local hook_Remove = hook.Remove
hook.Add = function(name, id, func) 
	if type(id) == 'function' then
		func = id
		id = debug_info(func).short_src
	end
	hook_Remove(name, id) -- properly simulate hook overwrite behavior

	if type(id) ~= 'string' then
		local orig = func
		func = function(...)
			if IsValid(id) then
				return orig(id, ...)
			else
				hook_Remove(name, id)
			end
		end
	end

	local collection = hooks[name]
	
	if collection == nil then
		collection = {}
		hooks[name] = collection
		mappings[name] = {}
	end

	local mapping = mappings[name]

	collection[#collection+1] = func
	mapping[id] = func
end