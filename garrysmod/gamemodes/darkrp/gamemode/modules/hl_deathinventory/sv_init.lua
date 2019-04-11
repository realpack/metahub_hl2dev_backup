util.AddNetworkString("OpenDeathPocket")
util.AddNetworkString("ClearPlayerPocketDeath")

local function CreateRagdoll(pPlayer)
  local eRagdoll = ents.Create("prop_ragdoll");
  eRagdoll:SetPos(pPlayer:GetPos());
  eRagdoll:SetModel(pPlayer:GetModel());
  eRagdoll:SetAngles(pPlayer:GetAngles());
  eRagdoll:SetSkin(pPlayer:GetSkin());
  eRagdoll:SetMaterial(pPlayer:GetMaterial());
  eRagdoll:Spawn();
  eRagdoll.player = pPlayer
  eRagdoll:SetCollisionGroup(COLLISION_GROUP_WORLD);
  eRagdoll.deathinv = pPlayer:GetInv()
  rp.inv.Data[pPlayer:SteamID64()] = {}
  pPlayer:SaveInv()

  pPlayer:SetNWEntity("ShareDRag", eRagdoll)

  timer.Create("DeleteRag"..pPlayer:UniqueID(), 120, 0, function()
    if eRagdoll and IsValid(eRagdoll) then
        eRagdoll:Remove()
    end
    if pPlayer and IsValid(pPlayer) then
        pPlayer:SetNWEntity("ShareDRag", nil)
    end
  end)

  local phys = eRagdoll:GetPhysicsObject()
  if ( IsValid( phys ) ) then
    phys:SetMass(1)
  end

  local v = pPlayer:GetVelocity()/5
  local num = eRagdoll:GetPhysicsObjectCount() - 1

  for i=0, num do
    local bone = eRagdoll:GetPhysicsObjectNum(i)
    if IsValid(bone) then
    local bp, ba = pPlayer:GetBonePosition(eRagdoll:TranslatePhysBoneToBone(i))
    if bp and ba then
      bone:SetPos(bp)
      bone:SetAngles(ba)
    end
    -- not sure if this will work:
    bone:SetVelocity(v)
    end
  end
end

function PlayerUseRagdoll(ply, key)
  if key == IN_USE and IsValid(ply) then
    local tr = util.TraceLine({
    start  = ply:GetShootPos(),
    endpos = ply:GetShootPos() + ply:GetAimVector() * 84,
    filter = ply,
    mask   = MASK_SHOT
    })
    local ent = tr.Entity
    if tr.Hit and ent.player and IsValid(ent.player) then
      net.Start("OpenDeathPocket")
      net.WriteEntity(ent)
      net.WriteTable(ent.deathinv)
      net.WriteEntity(ply)
      net.Send(ply)
      return true
    end
  end
end
hook.Add("KeyRelease", "KeyReleasedHookRagdoll", PlayerUseRagdoll)

local function DoPlayerDeath( pPlayer)
  net.Start("ClearPlayerPocketDeath")
  net.WriteEntity(pPlayer)
  net.Send(pPlayer)
  CreateRagdoll(pPlayer)
  return false
end
hook.Add("DoPlayerDeath", "MakePalyerRag", DoPlayerDeath)
