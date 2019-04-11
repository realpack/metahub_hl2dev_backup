include('shared.lua')

function ENT:Draw()
	self:DrawModel()
end

-- function Hack(t, netw)
--     local hackbg = vgui.Create( "DLabel" )
--     hackbg:SetSize( ScrW(), ScrH() )
--     hackbg:SetText("")
--     hackbg:MakePopup()
--     function hackbg:Paint(w, h)
--         draw.RoundedBox(0, 0, 0, w, h, Color(27, 20, 100))
--         draw.OutlinedBox( 0, 0, w, h, 5, Color(5, 5, 5, 150))
--         -- draw.colorIcon("gmtech/skull.png", w/2-256, h/2-256, 512, 512, Color(5,5,5,100))
--         drawRotatedBox( "gmtech/skull.png", w/2, h/2, 512, 512, (CurTime() * 36) % 360, Color(5,5,5,100) )
--         local color = Color(255,255,255)
--         if remainingTime then
--         	color = Color(255,0,0)
--         end

--         local remainingTime = string.FormattedTime( timer.TimeLeft("hackingkill"), "%02i:%02i:%02i" )
--         draw.SimpleText(remainingTime or 0, "gmt.title.big", w/2, h-55, Color(5,5,5, 100), TEXT_ALIGN_CENTER)
--     end
--     function hackbg:Think()
--     	if !LocalPlayer():Alive() then
--         	hackbg:Remove()
--         	timer.Remove("changeloop")
--         	timer.Remove("generatenewkey1")
--         	timer.Remove("hackingkill")
--     	end

--         if (#hackbg:GetChildren() == 0) then
-- 	    	surface.PlaySound("gmtech_ui/hack.wav")
--         	hackbg:Remove()
--         	timer.Remove("changeloop")
--         	timer.Remove("generatenewkey1")
--         	timer.Remove("hackingkill")
--         	net.Start("gmt."..netw) net.SendToServer(LocalPlayer())
--             RunConsoleCommand("stopsound")
--         end
--     end

--     local clrs = {}
--     clrs[1] = Color(234, 32, 39)
--     clrs[2] = Color(6, 82, 221)
--     clrs[3] = gmt.color.green
--     clrs[4] = gmt.color.orange
--     clrs[5] = gmt.color.yellow
--     clrs[6] = Color(131, 52, 113)
--     clrs[7] = Color(10, 189, 227)

--    	for i=1, 3 do
--    		local key = vgui.Create( "DButton", hackbg )
-- 	    key:SetSize( 32, 32 )
-- 	    key:SetPos( math.random(5, ScrW()-5), math.random(5, ScrH()-5) )
-- 	    key:SetText(math.random(1,7))
-- 	    function key:Paint(w, h)
-- 	        drawRotatedBox( "gmtech/lock.png", 16, 16, 32, 32, (CurTime() * 96) % 360, clrs[util.StringToType(self:GetText(), "Int")] )
-- 	    end
-- 	    function key:DoClick()
-- 	    	surface.PlaySound("gmtech_ui/digitalaccept.wav")
-- 	    	key:AlphaTo(0, 0.2, 0)
-- 	        timer.Simple(0.2, function()
-- 	        	key:Remove()
-- 	        end)
-- 	    end
--    	end

--     timer.Create("generatenewkey1", 5, 0, function()
--     	surface.PlaySound("garrysmod/balloon_pop_cute.wav")
--    		local key = vgui.Create( "DButton", hackbg )
-- 	    key:SetSize( 32, 32 )
-- 	    key:SetPos( math.random(5, ScrW()-5), math.random(5, ScrH()-5) )
-- 	    key:SetText(math.random(1,7))
-- 	    function key:Paint(w, h)
-- 	        drawRotatedBox( "gmtech/lock.png", 16, 16, 32, 32, (CurTime() * 96) % 360, clrs[util.StringToType(self:GetText(), "Int")] )
-- 	    end
-- 	    function key:DoClick()
-- 	    	surface.PlaySound("gmtech_ui/digitalaccept.wav")
-- 	    	key:AlphaTo(0, 0.2, 0)
-- 	        timer.Simple(0.2, function()
-- 	        	key:Remove()
-- 	        end)
-- 	    end
--     end)

--     timer.Create("changeloop", 0.9, 0, function()
--     	for k, v in pairs(hackbg:GetChildren()) do
--     		if IsValid(v) then
--     			v:MoveTo(math.random(10, ScrW()-40), math.random(10, ScrH()-40), 0.2, 0)
--     		end
--     	end
--     end)

-- 	surface.PlaySound("gmtech_sounds/hacking.mp3")
-- 	timer.Create("hackingkill", 18, 1, function()
-- 	  	hackbg:Remove()
-- 	    timer.Remove("changeloop")
-- 	    timer.Remove("generatenewkey1")
-- 	    net.Start("gmt.fail") net.SendToServer(LocalPlayer())
--         RunConsoleCommand("stopsound")
-- 	end)
-- end