CITYWORKER = CITYWORKER or {}

/*
    Action Display
    HUD that displays the progress of the player's current action.
*/

local MAT_WRENCH = Material( "cityworker/wrench.png" )

net.Receive( "CITYWORKER.StartAction", function()
    local desc = net.ReadString()
    local time = net.ReadUInt( 8 )

    local startTime = CurTime()
    local targetTime = CurTime() + time
    local deltaTime = targetTime - startTime

    hook.Add( "HUDPaint", "CITYWORKER.Action.HUDPaint", function()
        local x, y, w, h = ScrW() / 2 - ScrW() / 6, ScrH() / 4, ScrW() / 3, 60 * ( ScrH() / 1080 )
    
        surface.SetDrawColor( 0, 0, 0, 200 )
        surface.DrawRect( x, y, w, h )
    
        surface.SetDrawColor( 20, 150, 200 )
        surface.DrawRect( x + 5, y + 5, ( w - 10 ) * ( ( CurTime() - startTime ) / ( deltaTime ) ), h - 10 )
    
        draw.SimpleText( desc, "Trebuchet24", x + ( w / 2 ), y + ( h / 2 ) - 10, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
        draw.SimpleText( CITYWORKER.Config.Language["CANCEL"], "Trebuchet18", x + ( w / 2 ), y + ( h / 2 ) + 12, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_CENTER )
    end )

    timer.Create( "CITYWORKER.Action.Timer", time, 1, function()
        hook.Remove( "HUDPaint", "CITYWORKER.Action.HUDPaint" )
    end )
end )

net.Receive( "CITYWORKER.StopAction", function()
    hook.Remove( "HUDPaint", "CITYWORKER.Action.HUDPaint" )

    if timer.Exists( "CITYWORKER.Action.Timer" ) then
        timer.Remove( "CITYWORKER.Action.Timer" )
    end
end )

/*
    Task Notification
    HUD that displays the position of their next task.
*/

net.Receive( "CITYWORKER.NotifyTask", function()
    local pos = net.ReadVector()

    hook.Add( "HUDPaint", "CITYWORKER.Task.HUDPaint", function()
        local screenPos = pos:ToScreen()

        surface.SetDrawColor( 255, 255, 255 )
        surface.SetMaterial( MAT_WRENCH )
        surface.DrawTexturedRect( screenPos.x - 16, screenPos.y - 16, 32, 32 )

        draw.SimpleTextOutlined( math.ceil( ( LocalPlayer():GetPos():Distance( pos ) / 16 ) / 3.28084 ).."m", "Trebuchet24", screenPos.x, screenPos.y + 16, Color( 255, 255, 255 ), TEXT_ALIGN_CENTER, TEXT_ALIGN_TOP, 1, Color( 0, 0, 0 ) )
    end )
end )

net.Receive( "CITYWORKER.RemoveTask", function()
    hook.Remove( "HUDPaint", "CITYWORKER.Task.HUDPaint" )
end )