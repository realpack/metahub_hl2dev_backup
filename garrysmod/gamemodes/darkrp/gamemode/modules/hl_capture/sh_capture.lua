capture = {}
capture.Zones = rp.cfg.CaptureZones

capture.TeamCP = rp.cfg.CpatureTeamCP
capture.TeamRabel = rp.cfg.CpatureTeamRabel
capture.TimeReward = rp.cfg.CpatureTimeReward
capture.TimeToReward = rp.cfg.CpatureTimeToReward

function capture.FindPlayersInZone(id)
  local tPlayers3 = {}
  local iPlayers3 = 0
  local tEntities3 = ents.FindInSphere( capture.Zones[id].pos, capture.Zones[id].radius )
  local plteam

  if team1 == "ГО" then
    for k, v in pairs(tEntities3) do
      if v:IsPlayer() and v:Alive() and table.HasValue(capture.TeamCP, v:Team()) then
          iPlayers3 = k
          tPlayers3[iPlayers3] = tEntities3[k]
      end
    end
  elseif team1 == "Повстанцы" then
    for k, v in pairs(tEntities3) do
      if v:IsPlayer() and v:Alive() and table.HasValue(capture.TeamRabel, v:Team()) then
          iPlayers3 = k

          tPlayers3[iPlayers3] = tEntities3[k]
      end
  end
  end

  return tPlayers3, table.Count(tPlayers3)
end

function capture.FindPlayersInZoneT(id, team1)
  local tPlayers = {}
  local iPlayers = 0
  local tEntities = ents.FindInSphere( capture.Zones[id].pos, capture.Zones[id].radius )
  local plteam

  if team1 == "ГО" then
    for k, v in pairs(tEntities) do
      if v:IsPlayer() and v:Alive() and table.HasValue(capture.TeamCP, v:Team()) then
          iPlayers = k
          tPlayers[iPlayers] = tEntities[k]
      end
    end
  elseif team1 == "Повстанцы" then
    for k, v in pairs(tEntities) do
      if v:IsPlayer() and v:Alive() and table.HasValue(capture.TeamRabel, v:Team()) then
          iPlayers = k

          tPlayers[iPlayers] = tEntities[k]
      end
  end
  end

  return tPlayers, table.Count(tPlayers)
end

function capture.FindPlayersInZoneT2(id, team2)
  local tPlayers2 = {}
  local iPlayers2 = 0
  local tEntities2 = ents.FindInSphere( capture.Zones[id].pos, capture.Zones[id].radius )
  local plteam

  if team1 == "ГО" then
    for k, v in pairs(tEntities2) do
      if v:IsPlayer() and v:Alive() and table.HasValue(capture.TeamCP, v:Team()) then
          iPlayers2 = k
          tPlayers2[iPlayers2] = tEntities2[k]
      end
    end
  elseif team1 == "Повстанцы" then
    for k, v in pairs(tEntities2) do
      if v:IsPlayer() and v:Alive() and table.HasValue(capture.TeamRabel, v:Team()) then
          iPlayers2 = k

          tPlayers2[iPlayers2] = tEntities2[k]
      end
  end
  end

  return tPlayers2, table.Count(tPlayers2)
end

function capture.FindPlayersInZoneTCount(id, team1)
  local tPlayers = {}
  local iPlayers = 0
  local tEntities = ents.FindInSphere( capture.Zones[id].pos, capture.Zones[id].radius )
  local plteam

  if team1 == "ГО" then
    for k, v in pairs(tEntities) do
      if v:IsPlayer() and v:Alive() and table.HasValue(capture.TeamCP, v:Team()) then
          iPlayers = k
          tPlayers[iPlayers] = tEntities[k]
      end
    end
  elseif team1 == "Повстанцы" then
    for k, v in pairs(tEntities) do
      if v:IsPlayer() and v:Alive() and table.HasValue(capture.TeamRabel, v:Team()) then
          iPlayers = k

          tPlayers[iPlayers] = tEntities[k]
      end
  end
  end

  return table.Count(tPlayers)
end

function capture.FindPlayersInZoneT2Count(id, team2)
  local tPlayers2 = {}
  local iPlayers2 = 0
  local tEntities2 = ents.FindInSphere( capture.Zones[id].pos, capture.Zones[id].radius )
  local plteam

  if team1 == "ГО" then
    for k, v in pairs(tEntities2) do
      if v:IsPlayer() and v:Alive() and table.HasValue(capture.TeamCP, v:Team()) then
          iPlayers2 = k
          tPlayers2[iPlayers2] = tEntities2[k]
      end
    end
  elseif team1 == "Повстанцы" then
    for k, v in pairs(tEntities2) do
      if v:IsPlayer() and v:Alive() and table.HasValue(capture.TeamRabel, v:Team()) then
          iPlayers2 = k

          tPlayers2[iPlayers2] = tEntities2[k]
      end
  end
  end

  return table.Count(tPlayers2)
end
