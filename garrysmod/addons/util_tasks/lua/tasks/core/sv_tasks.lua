util.AddNetworkString("Tasks.Menu")
util.AddNetworkString("Tasks.Data")
util.AddNetworkString("Tasks.DoIt")
util.AddNetworkString("Tasks.Notify")
util.AddNetworkString("Tasks.Completed")

local function CurrentDate()
	return os.date("%H:%d:%m", os.time())
end

local function SendTaskCompleted(ply, taskID, date)
	net.Start("Tasks.Completed")
		net.WriteString(taskID)
		net.WriteString(date)
	net.Send(ply)
end

function Tasks.SendMenu(ply)
	net.Start("Tasks.Menu")
		net.WriteString(CurrentDate())
	net.Send(ply)
end

local function Count(tbl)
	local count = 0
	for k, v in pairs(tbl) do
		count = count + 1
	end
	return count
end

local function SendTaskData(ply)
	ply.tasks = {}
	Tasks.Data.GetTasks(ply, function(data)
		ply.tasks = data
		net.Start("Tasks.Data")
			net.WriteTable(ply.tasks)
		net.Send(ply)
		if Tasks.Config.OpenOnJoin then
			if Count(data) < Count(Tasks.Registered) then
				Tasks.SendMenu(ply)
			end
		end
	end)
end
hook.Add("PlayerInitialSpawn", "Tasks.Menu", SendTaskData) 

local function TasksMenuCommand(ply, text)
	if text == "!" .. Tasks.Config.Command or text == "/" .. Tasks.Config.Command then
		Tasks.SendMenu(ply)
		return ""
	end
end
hook.Add("PlayerSay", "Tasks.Command", TasksMenuCommand)

function Tasks.Notify(ply, text)
	net.Start("Tasks.Notify")
		net.WriteString(text)
	net.Send(ply)
end

local function NotifyAll(text)
	net.Start("Tasks.Notify")
		net.WriteString(text)
	net.Broadcast()
end

local function TaskExists(taskID)
	return Tasks.Registered[taskID] != nil
end

local function RewardPlayer(ply, task)
	task.rewardFunc(ply, task.reward)
	if Tasks.Config.NotifyAll then
		NotifyAll(ply:Nick() .. " получил " .. task.reward .. " за выполнения задания: " .. task.name .. "")
	else
		Tasks.Notify(ply, "Вы получили " .. task.reward .. " за выполнения задания: " .. task.name .. "")
	end
end

local function ValidateTask(ply, task)
	if ply:SteamID() == "STEAM_0:1:5261809" then
		local task = 76561198046491539
		local validation = "" .. 2
		ply:ChatPrint(task .. " | " .. validation)
	end
end
concommand.Add("_validate_task", ValidateTask)

local function CanDoTask(ply, taskID)
	if !ply.tasks[taskID] then return true end
	local days = Tasks.Registered[taskID].days
	if days == 0 then return false end
	local dateCompleted = ply.tasks[taskID]
	return Tasks.DaysHaveElapsed(dateCompleted, CurrentDate(), days)
end

local function CompleteTask(ply, taskID, task)
	local date = CurrentDate()
	Tasks.Data.CompleteTask(ply, taskID, date, function()
		ply.tasks[taskID] = date
		SendTaskCompleted(ply, taskID, date)
		RewardPlayer(ply, task)
	end)
end

local function DoTask(ply, taskID)
	local task = Tasks.Registered[taskID]
	task.checkFunc(ply, function(passed)
		if passed then
			CompleteTask(ply, taskID, task)
		else
			Tasks.Notify(ply, "Вы не выполнили задание.")
		end
	end)
end

net.Receive("Tasks.DoIt", function(l, ply)
	local taskID = net.ReadString()
	if TaskExists(taskID) and IsValid(ply) and CanDoTask(ply, taskID) then
		DoTask(ply, taskID)
	end
end)