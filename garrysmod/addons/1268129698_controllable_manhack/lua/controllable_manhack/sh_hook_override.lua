hook.Add("PostGamemodeLoaded", "ControllableManhack.HookOverride", function()
    ControllableManhack.overriddenHooks = {}
    ControllableManhack.hookBackups = {}

    ControllableManhack.RealHookAdd = ControllableManhack.RealHookAdd or hook.Add
    ControllableManhack.RealHookRemove = ControllableManhack.RealHookRemove or hook.Remove
    
    --hook.Add reroute
    function hook.Add(...)
        local eventName, identifier, Func = ...
        
        if ControllableManhack.overriddenHooks[eventName] then
            ControllableManhack.hookBackups[eventName][identifier] = Func
        else
            return ControllableManhack.RealHookAdd(...)
        end
    end
    
    --hook.Remove reroute
    function hook.Remove(...)
        local eventName, identifier = ...
        
        if ControllableManhack.overriddenHooks[eventName] then
            ControllableManhack.hookBackups[eventName][identifier] = nil
        else
            return ControllableManhack.RealHookRemove(...)
        end
    end
    
    if ControllableManhack.ConVarFixConflicts() then
        --Add a function to a hook and surpress all other functions in that hook
        function ControllableManhack.AddOverrideHook(eventName, identifier, Func)
            ControllableManhack.overriddenHooks[eventName] = Func
            ControllableManhack.hookBackups[eventName] = {}
            
            for eventName2, funcs in pairs(hook.GetTable()) do
                if eventName2 == eventName then
                    for identifier2, Func2 in pairs(funcs) do
                        ControllableManhack.hookBackups[eventName][identifier2] = Func2
                        
                        ControllableManhack.RealHookRemove(eventName, identifier2)
                    end
                end
            end
            
            ControllableManhack.RealHookAdd(eventName, identifier, Func)
        end
        
        --Remove a hook override
        function ControllableManhack.RemoveOverrideHook(eventName, identifier)
            ControllableManhack.overriddenHooks[eventName] = nil
            
            for eventName2, funcs in pairs(ControllableManhack.hookBackups) do
                if eventName2 == eventName then
                    for identifier2, Func2 in pairs(funcs) do
                        ControllableManhack.RealHookAdd(eventName, identifier2, Func2)
                    end
                end
            end
            
            ControllableManhack.hookBackups[eventName] = nil
            
            ControllableManhack.RealHookRemove(eventName, identifier)
        end
    else
        --These just use hook.Add and hook.Remove since command controllable_manhack_fixconflicts is off
        
        function ControllableManhack.AddOverrideHook(eventName, identifier, Func)
            ControllableManhack.RealHookAdd(eventName, identifier, Func)
        end
        
        function ControllableManhack.RemoveOverrideHook(eventName, identifier)
            ControllableManhack.RealHookRemove(eventName, identifier)
        end
    end
end)
