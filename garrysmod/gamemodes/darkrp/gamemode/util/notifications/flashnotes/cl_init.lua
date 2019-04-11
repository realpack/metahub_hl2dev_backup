local flashnotes = {}

-- local PANEL = {}
-- function PANEL:Init()
-- 	self.Title = ui.Create('DLabel', function(s, p)
-- 		s:SetColor(rp.col.SUP)
-- 		s:SetFont('HudFont')
-- 	end, self)
-- end

-- function PANEL:SetInfo(title, text)
-- 	local w, h = 275, 26

-- 	text = string.Wrap('HudFontSmall', text, w - 10)

-- 	for k, v in ipairs(text) do
-- 		if (v ~= '') then
-- 			ui.Create('DLabel', function(s, p)
-- 				s:SetText(v)
-- 				s:SetPos(5, 26 + ((k - 1) * s:GetTall()))
-- 				s:SetColor(rp.col.Close)
-- 				s:SetFont('HudFontSmall')
-- 				s:SizeToContents()
-- 				h = h + s:GetTall() + 2
-- 			end, self)
-- 		end
-- 	end

-- 	self:SetSize(w, h)
-- 	self:SetAlpha(0)
-- 	self:FadeIn(0.2)
-- 	self:SetPos(ScrW() * .5 - self:GetWide() * .5, ScrH() - ScrH() * .85)

-- 	self.Title:SetText(title)

-- 	hook('Think', self, function()
-- 		if (self.animation) then
-- 			self.animation:Run()
-- 		end
-- 	end)

-- 	timer.Simple(2.5, function()
-- 		if IsValid(self) then
-- 			self:FadeOut(0.2, function()
-- 				flashnotes[self.ID] = nil
-- 				self:Remove()
-- 			end)
-- 		end
-- 	end)
-- end

-- function PANEL:PerformLayout()
-- 	self.Title:SizeToContents()
-- 	self.Title:SetPos((self:GetWide() * .5) - (self.Title:GetWide() * .5), 1)
-- end

-- local color_background = rp.col.Background
-- local color_outline = rp.col.Outline
-- function PANEL:Paint(w, h)
-- 	draw.OutlinedBox(0,0,w,h,color_background,color_outline)
-- 	draw.Outline(0,0,w,26,color_outline)
-- end

-- function PANEL:FadeIn(speed, cback)
-- 	self.animation = Derma_Anim('Fade Panel', self, function(panel, animation, delta, data)
-- 		panel:SetAlpha(delta * 255)
-- 		if (animation.Finished) then
-- 			self.animation = nil
-- 			if cback then cback() end
-- 		end
-- 	end)

-- 	if (self.animation) then
-- 		self.animation:Start(speed)
-- 	end
-- end

-- function PANEL:FadeOut(speed, cback)
-- 	self.animation = Derma_Anim('Fade Panel', self, function(panel, animation, delta, data)
-- 		panel:SetAlpha(255 - (delta * 255))
-- 		if (animation.Finished) then
-- 			self.animation = nil
-- 			if cback then cback() end
-- 		end
-- 	end)

-- 	if (self.animation) then
-- 		self.animation:Start(speed)
-- 	end
-- end
-- vgui.Register('rp_flashnotification', PANEL, 'Panel')


local function FlashNotify(title, text)
	local note = ui.Create('rp_flashnotification')
	note:SetInfo(title, text)
	note.ID = #flashnotes + 1
	for k, v in ipairs(flashnotes) do
		local x, y = v:GetPos()
		v:SetPos(x, y + note:GetTall() + 4, 0.2)
	end
	flashnotes[note.ID] = note
end

net('rp.FlashString', function()
	FlashNotify(net.ReadString(), rp.ReadMsg())
end)

net('rp.FlashTerm', function()
	FlashNotify(net.ReadString(), rp.ReadTerm())
end)
