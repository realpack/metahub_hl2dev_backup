-- please at least do not remove this comment
    -- by chelog

include "cats/shared.lua"

if SERVER then
    AddCSLuaFile "cats/client.lua"
    AddCSLuaFile "cats/shared.lua"
    include "cats/mysqlite.lua"
    include "cats/server.lua"
else
    include "cats/client.lua"
end

print("[CATS] Files loaded.")
