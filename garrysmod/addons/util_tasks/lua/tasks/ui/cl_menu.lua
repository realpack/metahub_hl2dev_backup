function Tasks.OpenMenu()
	local frame = vgui.Create("tasks.frame")
	frame:SetSize(520, 500)
	frame:Center()
	frame:MakePopup()
	frame:SetTitle("Награждение за выполнение заданий MetaHub")

	local scroll = vgui.Create("DScrollPanel", frame)
	scroll:SetSize(frame:GetWide(), frame:GetTall() - 30)
	scroll:SetPos(0, 29)

	for taskID, task in pairs(Tasks.Registered) do
		local panel = vgui.Create("DPanel", scroll)
		panel:SetSize(scroll:GetWide(), 70)
		panel:Dock(TOP)
		panel:DockMargin(0, 0, 0, -1)
		panel.Paint = function(self, w, h)
			surface.SetDrawColor(44, 62, 80)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect(0, 0, w, h)
		end

		local name = vgui.Create("DLabel", panel)
		name:SetFont("tasks.28")
		name:SetText(task.name .. " - " ..  task.reward .. (task.days > 0 and " - " .. task.days .. " дня" or ""))
		name:SizeToContents()
		name:SetPos(20, 10)

		local desc = vgui.Create("DLabel", panel)
		desc:SetFont("tasks.20")
		desc:SetText(task.description)
		desc:SizeToContents()
		desc:SetPos(name.x, panel:GetTall() - desc:GetTall() - 10)

		local doIt = vgui.Create("DButton", panel)
		doIt:SetSize(120, panel:GetTall() - 10)
		doIt:SetPos(panel:GetWide() - doIt:GetWide() - 5, 5)
		doIt:SetText("Окей")
		if !Tasks.CanDoTask(taskID) then
			doIt:SetEnabled(false)
			doIt:SetText("Готово")
		end
		doIt.DoClick = function()
			task.doFunc()
			doIt:SetText("Ожидание...")
			timer.Simple(4, function()
				doIt:SetText("Готово?")
				doIt.DoClick = function()
					net.Start("Tasks.DoIt")
						net.WriteString(taskID)
					net.SendToServer()
					doIt:SetEnabled(false)
				end		
			end)
		end
		doIt.Paint = function(self, w, h)
			local color = !self:IsEnabled() and Color(64, 105, 153) or self.Hovered and Color(63, 98, 140) or Color(65, 94, 130)
			surface.SetDrawColor(color)
			surface.DrawRect(0, 0, w, h)

			surface.SetDrawColor(color_white)
			surface.DrawOutlinedRect(0, 0, w, h)

			self:SetTextColor(Color(230, 230, 230, 235))
			self:SetFont("tasks.24")
		end
	end
end