net.Receive("OpenDeathPocket", function(len, ply)
  if (rp.inv.UI and rp.inv.UI:IsValid()) then return; end

  local ent = net.ReadEntity()
  local content = net.ReadTable()
  local ply = net.ReadEntity()

  rp.inv.UI = vgui.Create("Pocket")
  rp.inv.UI:InitInspect(ply, content, ent)
end)

net.Receive("ClearPlayerPocketDeath", function(len, ply)
  local ply = net.ReadEntity()
  rp.inv.Data = {}
end)

function draw.OverlayText(ent, text)
  local pos = (ent:GetPos()):ToScreen()
  local alpha = math.Round(255/(LocalPlayer():GetPos():DistToSqr(ent:GetPos())/10000))
  local x, y = math.floor(pos.x-20), math.floor(pos.y-10)

  draw.SimpleText(text, 'font_base_small', x+1, y+1, Color(0,0,0,alpha), 1, 1)
  draw.SimpleText(text, 'font_base_small', x, y, Color(220,220,220,alpha), 1, 1)
end

hook.Add("HUDPaint", "Rag.OverlayTexts", function()
  for k, v in pairs(ents.FindInSphere(LocalPlayer():GetPos(),300)) do
    if not IsValid(v) then return end
    if not LocalPlayer():Alive() then return end
      if v:GetClass() == "prop_ragdoll" then
        draw.OverlayText(v, "Е - обыскать труп")
      end
  end
end)
