util.AddNetworkString( "captureSync" )
util.AddNetworkString("capture.StartAttack")
util.AddNetworkString("capture.WinnerEffect")

local function SpawnPoints()
  for k, v in pairs(capture.Zones) do
      local ent = ents.Create('control_point')
      ent:Spawn()
      ent:SetPos(v.pos)
      ent:SetAngles(Angle(v.ang))
      ent:SetId(k)

      if isfunction(ent.SetFraction) then
        ent:SetFraction('')
      end

      capture.Zones[k].Owner = {}
  end
end

hook.Add( "PostCleanupMap", "SpawnPoints_PostCleanupMap", SpawnPoints)
hook.Add( "InitPostEntity", "SpawnPoints_InitPostEntity", SpawnPoints)


function captureSync()
  net.Start( "captureSync" )
  net.WriteTable( capture.Zones )
  net.Broadcast()
end

function capture.SetZoneOwner(zoneid, team)
  capture.Zones[zoneid].Owner = nil
  capture.Zones[zoneid].Owner = team

  for k, v in pairs(ents.GetAll()) do
    if v:GetClass() == "control_point" and v:GetId() == zoneid then
      v:SetFraction(team)
    end
  end

  captureSync()
end

function capture.StartCapture(ply, zoneid)
  if not zoneid then return end
  if not ply then return end

  if table.HasValue(capture.TeamCP, ply:Team()) then
    team1 = "ГО"
  elseif table.HasValue(capture.TeamRabel, ply:Team()) then
    team1 = "Повстанцы"
  end

  if capture.Zones[zoneid].Owner == 'nil' then
    capture.CaptureWinner(team1, zoneid)
    return
  end

  local team2 = capture.Zones[zoneid].Owner

  if team1 == team2 then return end

  if team1 == capture.Zones[zoneid].Owner then
    ply:Notify(NOTIFY_ERROR, "Это уже твоя точка!")
    return false
  end

  if timer.Exists("StartCapturePercentage"..zoneid) then
    ply:Notify(NOTIFY_ERROR, "За эту точку уже ведётся борьба!")
    return false
  end

  capture.Zones[zoneid].perct1 = 0
  capture.Zones[zoneid].perct2 = 0
  capture.Zones[zoneid].team1count = 0
  capture.Zones[zoneid].team2count = 0
  captureSync()

  timer.Create("StartCapturePercentage"..zoneid, .1, 0, function()
    if capture.Zones[zoneid].perct1 == nil then return false end
    if capture.Zones[zoneid].perct2 == nil then return false end


    if capture.Zones[zoneid].perct1 >= 100 then
      capture.CaptureWinner(team1, zoneid)
      captureSync()
    elseif capture.Zones[zoneid].perct2 >= 100 then
      capture.CaptureWinner(team2, zoneid)
      captureSync()
    end
    capture.Zones[zoneid].team1count = capture.FindPlayersInZoneTCount(zoneid, team1) or 0
    capture.Zones[zoneid].team2count = capture.FindPlayersInZoneT2Count(zoneid, team2) or 0
    captureSync()
    
    if capture.Zones[zoneid].team1count > capture.Zones[zoneid].team2count then
          print(capture.Zones[zoneid].team1count)
      if not capture.Zones[zoneid].perct1 then return end
      capture.Zones[zoneid].perct1 = capture.Zones[zoneid].perct1 + 1
      for k, v in pairs(ents.GetAll()) do
        if v:GetClass() == "control_point" and v:GetId() == zoneid then
          print(v)
          v:SetNetVar('Control_Capture', capture.Zones[zoneid].perct1)
        end
      end
      captureSync()
    elseif capture.Zones[zoneid].team2count > capture.Zones[zoneid].team1count then
      if not capture.Zones[zoneid].perct2 then return end
      capture.Zones[zoneid].perct2 = capture.Zones[zoneid].perct2 + 1
      for k, v in pairs(ents.GetAll()) do
        if v:GetClass() == "control_point" and v:GetId() == zoneid then
          v:SetNetVar('Control_Capture', capture.Zones[zoneid].perct2)
        end
      end
      captureSync()
    end
  end)
end


function capture.EndCapture(zoneid)
  capture.Zones[zoneid].perct1 = nil
  capture.Zones[zoneid].perct2 = nil
  for k, v in pairs(ents.GetAll()) do
    if v:GetClass() == "control_point" and v:GetId() == zoneid then
      v:SetNetVar('Control_Capture', 0)
    end
  end
  for k, v in pairs(ents.GetAll()) do
    if v:GetClass() == "control_point" and v:GetId() == zoneid then
      v:SetNetVar('Control_Capture', 0)
    end
  end

  captureSync()

  if timer.Exists("StartCapturePercentage"..zoneid) then
    timer.Destroy("StartCapturePercentage"..zoneid)
  end
end

function capture.CaptureWinner(winner, zoneid)
  capture.EndCapture(zoneid)
  capture.SetZoneOwner(zoneid, winner)

  for k, v in pairs(player.GetAll()) do
     if winner == "ГО" or "Повстанцы" and table.HasValue(capture.TeamCP, v:Team()) or table.HasValue(capture.TeamRabel, v:Team()) then
      net.Start("capture.WinnerEffect")
      net.WriteEntity(v)
      net.Broadcast()
      v:PlayScene( "scenes/npc/male01/yeah01.vcd")
     end
  end
end

timer.Create("WinnerRewards", capture.TimeToReward, 0, function()
  local team1
  for k, v in pairs(player.GetAll()) do
  if table.HasValue(capture.TeamCP, v:Team()) then
    team1 = "ГО"
  elseif table.HasValue(capture.TeamRabel, v:Team()) then
    team1 = "Повстанцы"
  end
    if table.HasValue(capture.TeamCP, v:Team()) or table.HasValue(capture.TeamRabel, v:Team()) then
      for _, c in pairs(capture.Zones) do
        if c.Owner == team1 then
          v:AddMoney(capture.TimeReward)
          DarkRP.notify(v, 1, 4, "Вы получили "..rp.FormatMoney(capture.TimeReward).. " за удержание ".. c.name)
        end
      end
    end
  end
end)
