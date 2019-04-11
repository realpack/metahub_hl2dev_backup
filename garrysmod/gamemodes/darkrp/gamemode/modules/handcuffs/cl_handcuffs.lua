local DragBone = "ValveBiped.Bip01_Spine1"
local DefaultRope = Material("cable/rope")

hook.Add( "PostDrawOpaqueRenderables", "Handcuffs_PostDrawOpaqueRenderables", function()
    local allCuffs = ents.FindByClass( "handcuffed" )
    for i=1,#allCuffs do
        local cuff = allCuffs[i]

        local player = cuff.Owner
        local kidnapper = player:GetNWEntity('GetPlayerHandcuffed')

        if not player then return end
        if kidnapper and IsValid(kidnapper) then

            local kidPos = ( (kidnapper:IsPlayer() or kidnapper:GetClass() == 'handcuffs_point') and (kidnapper:GetClass() == 'handcuffs_point' and kidnapper:GetPos() or kidnapper:GetPos() + Vector(0,0,40)) )

            local pos = cuff.Owner:GetPos()
            local bone = cuff.Owner:LookupBone( DragBone )
            if bone then
                pos = cuff.Owner:GetBonePosition( bone )
                if (pos.x==0 and pos.y==0 and pos.z==0) then pos = cuff.Owner:GetPos() end
            end

            render.SetMaterial( DefaultRope )
            render.DrawBeam( kidPos, pos, 1, 0, 5, Color(255,255,255,255) )
        end
        -- render.DrawBeam( pos, kidPos, -2, 0, 5, Color(255,255,255,255) )
    end
end)

local duration = 0
netstream.Hook('ProgressCuffed_Start',function(data)
    duration = data.timer
    timer.Create('ProgressCuffed_'..LocalPlayer():SteamID64(), data.timer, 1, function()
        netstream.Start('ProgressCuffed_Succes',nil)
    end)
end)

netstream.Hook('ProgressCuffed_Fail',function(data)
    timer.Destroy('ProgressCuffed_'..LocalPlayer():SteamID64())
end)

-- local duration = 0
-- net.Receive('ProgressCuffed_Start', function()
--     duration = data.timer
--     timer.Create('ProgressCuffed_'..LocalPlayer():SteamID64(), net.ReadUInt(32), 1, function()
--         -- netstream.Start('ProgressCuffed_Succes',nil)
--         net.Start('ProgressCuffed_Succes')
--         net.SendToServer()
--     end)
-- end)

-- -- net.Start()
-- net.Receive('ProgressCuffed_Fail', function()
--     timer.Destroy('ProgressCuffed_'..LocalPlayer():SteamID64())
-- end)


local progress_wide = 300
hook.Add( "HUDPaint", "Handcuffs_HUDPaint", function()
    local time_left = timer.TimeLeft('ProgressCuffed_'..LocalPlayer():SteamID64())

    if not time_left then return end

    draw.RoundedBox(0, ScrW()/2-progress_wide/2, ScrH()/2, progress_wide, 20, Color(0,0,0,90))
    draw.RoundedBox(0, ScrW()/2-progress_wide/2, ScrH()/2, ( time_left/(duration*1) ) * progress_wide, 20, Color(61,146,254,255))
end)
