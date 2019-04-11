IGS_HELP_TEXT = "Хелп!" -- для IGS.OpenUITab(IGS_HELP_TEXT) например

local url -- кешируем

local function OpenHelpFrame(htmlpan)
	htmlpan:OpenURL(url)
end


hook.Add("IGS.CatchActivities","faq_and_help",function(activity,sidebar)
	local bg = sidebar:AddPage("FAQ")
	bg.OnOpenOver = function(self)
		-- Антирефреш страницы при переключении вкладки
		if !bg.html.opened then
			bg.html.opened = true

			if url then
				OpenHelpFrame(bg.html)
				return
			end

			IGS.GetHelpURL(function(sign)
				url = sign

				OpenHelpFrame(bg.html)
			end)
		end
	end

	for _,v in ipairs( IGS.C.Help ) do
		IGS.AddTextBlock(bg.side, v.TITLE, v.TEXT)
	end

	bg.html = ui.Create("iHTML",bg)
	bg.html:Dock(FILL)

	activity:AddTab(IGS_HELP_TEXT,bg,"materials/vgui/icons/fa32/hand-o-up.png")
end)

-- IGS.UI()