require("mysqloo")

Tasks.DataProvider = Tasks.DataProvider or {}

function Tasks.DataProvider.Connect(cback)
    if Tasks.DataProvider.DB then
        return
    end

    local db = mysqloo.connect(Tasks.Config.SQL.ip, Tasks.Config.SQL.username, Tasks.Config.SQL.password, Tasks.Config.SQL.database, Tasks.Config.SQL.port)

    function db:onConnected()
        print("Tasks | Connected to the database!")
        cback()
    end

    function db:onConnectionFailed( err )
        print("Tasks | Connection failed: " .. err)
    end

    db:connect()

	Tasks.DataProvider.DB = db
end

local function RunQuery(query, cback)
    function query:onSuccess(data)
        if cback and isfunction(cback) then
	        cback(data)
        end
    end

    function query:onError(err)
        print("Tasks | Query error: " .. err)
    end

    query:start()
end

local function CreateQuery(query, ...)
    local args = {...}
    local cback = args[#args]

    local preparedQuery = Tasks.DataProvider.DB:prepare(query)
    for i=1, #args - 1 do
        preparedQuery:setString(i, args[i])
    end

    return preparedQuery, cback
end

function Tasks.DataProvider.Query(query, ...)
    if !Tasks.DataProvider.DB then
        print("Tasks | You are not connected to any database.")
        return
    end

    RunQuery(CreateQuery(query, ...))
end