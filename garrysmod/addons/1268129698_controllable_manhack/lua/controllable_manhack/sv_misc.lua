
function ControllableManhack.GetManhackForPlayer(ply)
    for manhackIndex, manhack in pairs(ents.FindByClass(ControllableManhack.manhackEntityClassName)) do
    	local playerController = manhack:GetPlayerController()

        if IsValid(playerController) and playerController == ply then
            return manhack
        end
    end
end

function ControllableManhack.SpawnManhack(playerController, position, angle)
    local manhack = ents.Create(ControllableManhack.manhackEntityClassName)
    manhack:SetPos(position)
    manhack:SetAngles(angle)
    manhack:SetPlayerController(playerController)
    manhack:Spawn()

    return manhack
end
