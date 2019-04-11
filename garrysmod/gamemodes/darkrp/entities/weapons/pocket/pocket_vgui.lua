local iconWidth = 200;
local iconSize = 74

local PANEL = {};

function PANEL:Init()
  self.Contents = rp.inv.Data;
  self.Created = SysTime();
  self.Closed = nil;
  self.Alpha = 0;
  self.Icons = {};

  self:SetSize(ScrW(), ScrH());

  self:MakePopup();
  self:SetKeyBoardInputEnabled(false);
end

function PANEL:InitLocal()
  self.Contents = rp.inv.Data

  self:Finalize()
end

function PANEL:InitInspect(pl, contents, body)
  self.Contents = contents
  self.Inspecting = pl:Name()
  self.InspectingPlayer = pl
  if body then
    self.Body = body
  end

  self:Finalize()
end

function PANEL:Finalize()

  if (self.Inspecting) then
    for k, v in pairs(self.Contents) do
      local ico = self:Add("PocketItem");
      ico:SetItem(v, k);

      table.insert(self.Icons, ico);
    end
  else
    for k, v in pairs(self.Contents) do
      local ico = self:Add("PocketItem");
      ico:SetItem(v);

      table.insert(self.Icons, ico);
    end
  end

  self:LayoutIcons()


  if (self.Inspecting) then
    local y = self.Icons[1] and self.Icons[1].y or ScrW() * 0.25
    self.InspLbl = ui.Create("DLabel", function(lbl)
      lbl:SetText(self.Inspecting)
      lbl:SetFont("font_base_24")
      lbl:SizeToContents()

      lbl:CenterHorizontal()
      lbl:SetPos(lbl.x, y/2.2)
    end, self)
    y = y - self.InspLbl:GetTall() - 3
    self.btnClose = ui.Create("DButton", function(btn)
      btn:SetText("Закрыть")
      btn:SizeToContents()
      btn:SetWide(self.InspLbl:GetWide())
      btn:CenterHorizontal()
      btn:SetPos(btn.x, y/1.8)
      btn.DoClick = rp.inv.DisableMenu
    end, self)
  end
end

function PANEL:LayoutIcons()
    if (#self.Icons == 0) then return; end

    local perRow = math.floor((ScrW() * 0.75) / (iconWidth + 10));
    local numRows = math.ceil(#self.Icons / perRow);

    -- local x = ScrW()* 0.5;
    -- local y = ScrH()* 0.5;

    local radius = 200
    if #self.Icons == 1 then
        radius = 0
    end

    for k, v in ipairs(self.Icons) do
        local a = math.rad( ( k / #self.Icons ) * -360 )
        -- local x, y = x + math.sin( a ) * radius, y + math.cos( a ) * radius

        x = ScrW()* 0.5 - v:GetWide()*.5
        y = ScrH()* 0.5 - k*(v:GetTall()+2)

        v:SetPos(x, y);
        -- v:SetSize(iconSize,iconSize)

        x = x + 0;
    end
end

function PANEL:Close()
  self.Closed = SysTime();
end

function PANEL:Think()
  self.Alpha = (math.Clamp(SysTime() - self.Created, 0, 0.1) - math.Clamp(SysTime() - (self.Closed or math.huge), 0, 0.1)) / 0.1;

  if (self.Closed and self.Alpha == 0) then
    self:Remove();
    return;
  end

  if (!self.Inspecting and !input.IsMouseDown(MOUSE_RIGHT) and !self.Closed) then
    rp.inv.DisableMenu();
  end
end

function PANEL:Paint(w, h)
    surface.SetDrawColor(0, 0, 0, self.Alpha * 70);
--   surface.DrawRect(0, 0, w, h);

--   draw.SimpleText(table.Count(self.Contents) .. /*'/' .. (LocalPlayer():GetUpgradeCount('pocket_space_2') * 2) + 8 ..*/ ' Items', 'font_base', ScrW()/2, 10, rp.col.White, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP)

--   surface.SetAlphaMultiplier(self.Alpha);

    -- alpha = 230
    -- alpha_lerp = Lerp(FrameTime()*2,alpha_lerp or 0,alpha or 0) or 0

    draw.Blur(self)
    draw.RoundedBox(0,0,0,w,h,Color(52, 73, 94, self.Alpha * 200))

    draw.SimpleText('У вас '..#self.Icons..' вещей из '..tostring(8)..' доступных', "font_base_18", w*.5, h*.5 +20, color_white, 1, 1)
end

function PANEL:PaintOver(w, h)
  surface.SetAlphaMultiplier(1);
end

vgui.Register("Pocket", PANEL, "EditablePanel");

local ITEM = {};

function ITEM:Init()
    self.Icon = self:Add("ModelImage");
    self.Icon:SetMouseInputEnabled(false);

    self.Title = "ITEM";
    self.SubTitle = '';

    self:SetSize(300, 24);
    self.Icon:SetPos(0, 0);
    self.Icon:SetSize(24, 24);
end

function ITEM:SetItem(itemData, itemKey)
    if itemKey then 
      self.ID = itemKey
    else
      self.ID = itemData.ID;
    end

    self.Title = itemData.Title;
    self.SubTitle = itemData.SubTitle;
    self.Model = itemData.Model;

    self.Icon:SetModel(self.Model or "models/error.mdl");
end

function ITEM:OnMousePressed(mb)
  if (!self:GetParent().Inspecting) then
    rp.inv.DisableMenu();
    -- rp.RunCommand('invdrop', tostring(self.ID))
      RunConsoleCommand('rp','invdrop',tonumber(self.ID))
  elseif (mb == MOUSE_LEFT) then
    net.Start("Pocket.TakeFromBody")
    net.WriteEntity(self:GetParent().InspectingPlayer)
    net.WriteUInt(self.ID, 32)
    net.WriteEntity(self:GetParent().Body)
    net.WriteEntity(LocalPlayer())
    net.SendToServer()

    self:Remove()
  end
end

function ITEM:Paint(w, h)
  -- draw.Blur(self)
  -- draw.OutlinedBox(0, 0, w, h, self:IsHovered() and rp.col.SUP or rp.col.Background, rp.col.Outline)

  -- surface.SetFont("font_base_24");
  -- surface.SetTextColor(255, 255, 255);

  local title = self.Title or "ITEM"

    local col = Color(0, 0, 0, 120)
    if self:IsHovered() then
        col = Color(255, 255, 255, 5)
    end

    if not (!self.SubTitle or self.SubTitle == "") then
        draw.SimpleText(self.SubTitle, "font_base_18", w-2, h*.5, color_white, 2, 1)
    end
    draw.RoundedBox(0, 0, 0, w, h, col)


    draw.SimpleText(title, "font_base_18", 26, h*.5, color_white, 0, 1)

    -- draw.SimpleText(self.Icons, "font_base_18", w*.5, h*.5, color_white, 1, 1)
    --     draw.SimpleText(title, "font_base_18", iconSize-10, 8, color_white, 0, 0)
    -- else
    --     draw.SimpleText(title, "font_base_18", iconSize-10, 8, color_white, 0, 0)
    --     draw.SimpleText(title, "font_base_18", iconSize-10, 28, color_white, 0, 0)
    -- end

  -- local tw, th = surface.GetTextSize(title);
  -- if (!self.SubTitle or self.SubTitle == "") then
  --  surface.SetTextPos(74, (h - th) * 0.5);

  --  surface.DrawText(title);
  -- else
  --  local stw, sth = surface.GetTextSize(self.SubTitle);

  --  surface.SetTextPos(74, (h * 0.25) - (th * 0.5));
  --  surface.DrawText(title);

  --  surface.SetTextPos(74, (h * 0.75) - (sth * 0.5));
  --  surface.DrawText(self.SubTitle);
  -- end
end

vgui.Register("PocketItem", ITEM, "Panel");
