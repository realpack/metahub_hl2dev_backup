require("tmysql4")

Tasks.DataProvider = Tasks.DataProvider or {}

local quote = '"'

function Tasks.DataProvider.Query(query, ...)
    if !Tasks.DataProvider.DB then
        print("Tasks | You are not connected to any database.")
        return
    end

    local args = {...}
    local count = 0
    query = query:gsub("?", function()
        count = count + 1
        return (args[count] ~= nil) and (quote .. Tasks.DataProvider.DB:Escape(args[count]) .. quote) or "NULL"
    end)

    local cback = args[count + 1]

    Tasks.DataProvider.DB:Query(query, function(results)
        if cback then
            cback(results[1].data)
        end
    end)
end

function Tasks.DataProvider.Connect()
    if Tasks.DataProvider.DB then
        return
    end

    local database, err = tmysql.initialize(Tasks.Config.SQL.ip, Tasks.Config.SQL.username, Tasks.Config.SQL.password, Tasks.Config.SQL.database, Tasks.Config.SQL.port)

	if (database == false) or err then
        print("Tasks | Connection to database failed!" )
        print("Tasks | Error: " .. err )
		return
	end
	Tasks.DataProvider.DB = database
end