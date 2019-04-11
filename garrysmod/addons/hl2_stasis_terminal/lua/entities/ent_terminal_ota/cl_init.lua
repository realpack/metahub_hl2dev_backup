include("shared.lua")

surface.CreateFont("terms", { font = "Roboto", extended = true, size = 21, weight = 700 })
surface.CreateFont("btn", { font = "Roboto", extended = true, size = 19, weight = 500 })
surface.CreateFont("btn2", { font = "Play", extended = true, size = 19, weight = 400 })

function ENT:Draw()

	self:DrawModel()

	local ang = self:GetAngles()
	ang:RotateAroundAxis(ang:Forward(), 90)
	ang:RotateAroundAxis(ang:Right(), -90)

	local pos = self:GetPos()

	if (LocalPlayer():GetPos():Distance(self:GetPos()) < 300 or LocalPlayer():GetEyeTrace().Entity == self) then
		cam.Start3D2D(pos + ang:Up() * 1 + ang:Right() * -60, Angle(1, LocalPlayer():EyeAngles().y - 90, 90), 0.1)
		draw.SimpleTextOutlined('Перевод в SUP Отдел', 'DermaLarge', 0, 0, color_white, TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, color_black)
		cam.End3D2D()
	end
end

local blurmat = Material("pp/blurscreen")

local function blurframe(panel, amount)
	local x, y = panel:LocalToScreen(0, 0)
	local scrW, scrH = ScrW(), ScrH()
	surface.SetDrawColor(255, 255, 255)
	surface.SetMaterial(blurmat)

	for i = 1, 3 do
		blurmat:SetFloat("$blur", (i / 3) * (amount or 6))
		blurmat:Recompute()
		render.UpdateScreenEffectTexture()
		surface.DrawTexturedRect(x * -1, y * -1, scrW, scrH)
	end
end

local frame

net.Receive("stasis.open_terminal", function()
	if IsValid(frame) then frame:Remove() end

	frame = vgui.Create("DFrame")
	frame:SetSize(455, 165)
	frame:SetTitle("")
	frame:Center()
	frame:SetAlpha(0)
	frame:AlphaTo(255, .5, 0)
	frame:MakePopup()
	frame:ShowCloseButton(false)
	frame:SetDraggable(false)

	frame.Paint = function(self, w, h)
		-- Derma_DrawBackgroundBlur(self, CurTime())

		draw.RoundedBox(0, 0, 0, w, 60, Color(244, 182, 83, 255))
		draw.RoundedBox(0, 0, 105, w, h-105, Color(50, 50, 50))
		draw.SimpleText("ВНИМАНИЕ", "terms", w/2, 5, Color(0, 0, 0), 1, 0)
		draw.SimpleText("После смерти вы вернетесь в свою прошую профессию.", "btn", w/2, 25, Color(0, 0, 0), 1, 0)

		draw.SimpleText("Стоимость "..formatMoney(STASIS_PRICE)..";", "btn2", 5, 105, Color(255, 255, 255), 0, 0)
		draw.SimpleText("Машина сделает вас бойцом сверхчеловеческого отдела;", "btn2", 5, 125, Color(255, 255, 255), 0, 0)
		draw.SimpleText("Длительность операции занимает примерно 30 секунд;", "btn2", 5, 145, Color(255, 255, 255), 0, 0)
	end

	local p_b = vgui.Create("DButton", frame)
	p_b:SetSize(225, 35)
	p_b:SetPos(0, 65)
	p_b:SetFont("btn")
	p_b:SetText("Переработка")
	p_b.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(50, 50, 50) or Color(35, 35, 35))

		if self:IsHovered() then
			self:SetTextColor(color_white)
		else
			self:SetTextColor(Color(175,175,175))
		end
	end
	p_b.DoClick = function()
		net.Start("stasis.give_something")
		net.SendToServer()
		frame:Remove()
	end

	local c_b = vgui.Create("DButton", frame)
	c_b:SetSize(225, 35)
	c_b:SetPos(225+5, 65)
	c_b:SetFont("btn")
	c_b:SetText("Отмена")
	c_b.Paint = function(self, w, h)
		draw.RoundedBox(0, 0, 0, w, h, self:IsHovered() and Color(50, 50, 50) or Color(35, 35, 35))

		if self:IsHovered() then
			self:SetTextColor(color_white)
		else
			self:SetTextColor(Color(175,175,175))
		end
	end
	c_b.DoClick = function()
		frame:Remove()
	end
end)

hook.Add("HUDPaint", "spermabegimota", function()
	for i, v in pairs(ents.FindByClass("ent_termstasis")) do
		local position = v:GetPos() + Vector(0, 0, 73)
		local ply = LocalPlayer()
		position = position:ToScreen()
		local text = "Машина"
		local text2 = math.floor(Vector(LocalPlayer():GetPos()):Distance(Vector(v:GetPos()))) / 100 .. "м"
		surface.SetFont("Default")
		local width, height = surface.GetTextSize(text)
		local width2, height2 = surface.GetTextSize(text2)

		if ply:GetNWBool("cpota") == true then
			surface.SetMaterial(Material("icon16/briefcase.png"))
			surface.SetDrawColor(255, 255, 255)
			surface.DrawTexturedRect(position.x - 8, position.y - 50, 16, 16)
			draw.DrawText(text, "Default", position.x, position.y - 30, Color(48, 104, 178, 255), TEXT_ALIGN_CENTER)
			draw.DrawText(text2, "Default", position.x, position.y - 10, Color(255, 255, 255, 255), TEXT_ALIGN_CENTER)
		end
	end
end)
