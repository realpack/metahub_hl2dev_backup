local taskData = {}
local serverDate

net.Receive("Tasks.Data", function()
	taskData = net.ReadTable()
	hook.Call("Tasks.DataLoaded", GAMEMODE, taskData)
end)

net.Receive("Tasks.Completed", function()
	taskData[net.ReadString()] = net.ReadString()
end)

net.Receive("Tasks.Menu", function()
	serverDate = net.ReadString()
	Tasks.OpenMenu()
end)

function Tasks.Notify(msg)
	chat.AddText(Color(59, 234, 247), "Meta.Rewards | ", Color(255, 255, 255), msg)
end

net.Receive("Tasks.Notify", function()
	Tasks.Notify(net.ReadString())
end)

function Tasks.CanDoTask(task)
	if !taskData[task] then return true end
	local days = Tasks.Registered[task].days
	if days == 0 then return false end
	return Tasks.DaysHaveElapsed(taskData[task], serverDate, days)
end