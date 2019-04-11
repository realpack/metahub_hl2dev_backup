
ControllableManhack.conVarPrefix = "controllable_manhack_"

function ControllableManhack.CreateConvar(...)
    local convarTable = ...
    
    CreateConVar(ControllableManhack.conVarPrefix .. convarTable.convarName, convarTable.value, convarTable.flags, convarTable.helpText)
    
    ControllableManhack["ConVar" .. convarTable.functionName] = function()
        local conVar = GetConVar(ControllableManhack.conVarPrefix .. convarTable.convarName)
        
        return  conVar["Get" .. convarTable.type](conVar)
    end
end

ControllableManhack.CreateConvar{
    convarName = "ammoinfinite",
    functionName = "AmmoInfinite",
    type = "Bool",
    value = 0,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable infinite ammo"
}

ControllableManhack.CreateConvar{
    convarName = "ammoamount",
    functionName = "AmmoAmount",
    type = "Int",
    value = 3,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Amount of ammo you start with"
}

ControllableManhack.CreateConvar{
    convarName = "ammoretrieve",
    functionName = "AmmoRetrieve",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable getting ammo back when retrieving a manhack"
}

ControllableManhack.CreateConvar{
    convarName = "selfdestructdeath",
    functionName = "SelfDestructDeath",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable self destructing when owner dies"
}

ControllableManhack.CreateConvar{
    convarName = "selfdestructexplosion",
    functionName = "SelfDestructExplosion",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable explosion when a manhack selfdestructs"
}

ControllableManhack.CreateConvar{
    convarName = "selfdestructinstant",
    functionName = "SelfDestructInstant",
    type = "Bool",
    value = 0,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable instant self destructing"
}

ControllableManhack.CreateConvar{
    convarName = "haterebel",
    functionName = "HateRebel",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable rebels hating controllable manhacks by default"
}

ControllableManhack.CreateConvar{
    convarName = "hatecombine",
    functionName = "HateCombine",
    type = "Bool",
    value = 0,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable combines hating controllable manhacks by default"
}

ControllableManhack.CreateConvar{
    convarName = "hudoverlay",
    functionName = "HUDOverlay",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable red overlay when controlling a manhack"
}

ControllableManhack.CreateConvar{
    convarName = "hudtargets",
    functionName = "HUDTargets",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable HUD targets when controlling a manhack"
}

ControllableManhack.CreateConvar{
    convarName = "hudtexts",
    functionName = "HUDTexts",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable HUD texts when controlling a manhack"
}

ControllableManhack.CreateConvar{
    convarName = "thirdpersonallowed",
    functionName = "ThirdPersonAllowed",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Allow third person when controlling a manhack"
}

ControllableManhack.CreateConvar{
    convarName = "thirdpersonhud",
    functionName = "ThirdPersonHUD",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Show HUD texts in third person"
}

ControllableManhack.CreateConvar{
    convarName = "retrieveallowed",
    functionName = "RetrieveAllowed",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Allow players to retrieve their manhack with the use key"
}

ControllableManhack.CreateConvar{
    convarName = "collideuse",
    functionName = "CollideUse",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable manhacks to use buttons, doors, etc by hitting them"
}

ControllableManhack.CreateConvar{
    convarName = "bladesound",
    functionName = "BladeSound",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable annoying blade loop sound"
}

ControllableManhack.CreateConvar{
    convarName = "multiglowcolor",
    functionName = "MultiGlowColor",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable different glow colors for the different manhack states"
}

ControllableManhack.CreateConvar{
    convarName = "health",
    functionName = "Health",
    type = "Int",
    value = 25,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Amount of health that controllable manhacks spawn with"
}

ControllableManhack.CreateConvar{
    convarName = "collideusewhitelist",
    functionName = "CollideUseWhitelist",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Enable whitelist (defined in a Lua file) of entities that can be used by hitting them with the manhack"
}

ControllableManhack.CreateConvar{
    convarName = "fixconflicts",
    functionName = "FixConflicts",
    type = "Bool",
    value = 1,
    flags = FCVAR_ARCHIVE + FCVAR_REPLICATED,
    helpText = "Fix various conflicts with addons. Turn this off if you are getting errors or having problems (requires restart)"
}
