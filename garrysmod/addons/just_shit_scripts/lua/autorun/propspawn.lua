
local hooks = {
    "Effect",
    "NPC",
    "Ragdoll",
    "SENT",
    "Vehicle"
}


for _, v in pairs (hooks) do


    hook.Add("PlayerSpawn"..v, "Disallow_user_"..v, function(client)
        if (client:IsUserGroup("jedi") or (client:IsUserGroup("commander") or (client:IsUserGroup("vip") or (client:IsUserGroup("premium") or (client:IsUserGroup("sponsor") or (client:IsUserGroup("founder") or (client:IsUserGroup("moderator") or client:IsUserGroup("serverstaff")))))))) then
            return true
        end
        
        return false
    end)
    
end