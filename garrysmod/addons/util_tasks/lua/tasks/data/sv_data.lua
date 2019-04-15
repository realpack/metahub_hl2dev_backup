Tasks.Data = Tasks.Data or {}

local function UsingSQL()
	return Tasks.Config.DataProvider != "file"
end

if UsingSQL() then
	Tasks.IncludeSV("providers/" .. Tasks.Config.DataProvider .. ".lua")
end

local function CreateTables()
    Tasks.DataProvider.Query("CREATE TABLE IF NOT EXISTS tasks (steamid varchar(255), task varchar(255), date varchar(255))")
end

if UsingSQL() then
    print("Tasks | Attempting to connect to the database...")
	Tasks.DataProvider.Connect(function()
		CreateTables()
	end)
else
	file.CreateDir("tasks")
end

local function SortTaskData(data)
	local tasks = {}
	for k, v in pairs(data) do
		tasks[v.task] = v.date
	end
	return tasks
end

function Tasks.Data.GetTasks(ply, cback)
	if UsingSQL() then
		Tasks.DataProvider.Query("SELECT task, date FROM tasks WHERE steamid=?", ply:SteamID64(), function(data) 
			cback(SortTaskData(data)) 
		end)
	else
		local data = {}
		if file.Exists("tasks/" .. ply:SteamID64() .. ".txt", "DATA") then	
			local json = file.Read("tasks/" .. ply:SteamID64() .. ".txt")
			data = util.JSONToTable(json)
		end
		cback(data)
	end
end

function Tasks.Data.CompleteTask(ply, task, date, cback)
	if UsingSQL() then
		Tasks.DataProvider.Query("SELECT COUNT(*) FROM tasks WHERE steamid=? AND task=?", ply:SteamID64(), task, function(data)
			local count = data[1]["COUNT(*)"]
			if tonumber(count) < 1 then
				Tasks.DataProvider.Query("INSERT INTO tasks (steamid, task, date) VALUES (?, ?, ?)", ply:SteamID64(), task, date, cback)
			else
				Tasks.DataProvider.Query("UPDATE tasks SET date=? WHERE steamid=? AND task=?", date, ply:SteamID64(), task, cback)
			end
		end)
	else
		local doneTasks = ply.tasks
		doneTasks[task] = date
		file.Write("tasks/"..ply:SteamID64()..".txt", util.TableToJSON(doneTasks))
		cback()
	end
end