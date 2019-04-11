require 'tmysql4'

mysql = setmetatable({}, {
	__call = function(self, ...)
		return self.Connect(...)
	end
})
mysql.GetTable = setmetatable({}, {
	__call = function(self)
		return self
	end
})

local db_mt = {
	__tostring = function(self)
		return self.Database .. '@' .. self.Hostname .. ':' ..  self.Port
	end
}
db_mt.__concat 	= db_mt.__tostring
db_mt.__index 	= db_mt


local tostring 		= tostring
local SysTime 		= SysTime
local pairs 		= pairs

local color_purple 	= Color(185,0,255)
local color_white 	= Color(250,250,250)

local query_queue	= {}

function mysql.Connect(hostname, username, password, database, port, optional_socketpath, optional_clientflags)
	local db_obj = setmetatable({
		Hostname = hostname,
		Username = username,
		Password = password,
		Database = database,
		Port 	 = port,
	}, db_mt)

	if mysql.GetTable[tostring(db_obj)] then
		return mysql.GetTable[tostring(db_obj)]
	end

	db_obj.Handle, db_obj.Error = tmysql.initialize(hostname, username, password, database, port, optional_socketpath, optional_clientflags)

	mysql.GetTable[tostring(db_obj)] = db_obj

	if db_obj.Error then
		db_obj:Log(db_obj.Error)
	else
		db_obj:Log('Connected to database ' .. db_obj .. ' successfully.')
	end

	--self:SetOption(MYSQL_SET_CLIENT_IP, GetConVarString('ip'))
	--self:Connect()

	return db_obj
end


function db_mt:Connect()
	return self.Handle:Connect()
end

function db_mt:Disconnect()
	return self.Handle:Disconnect()
end

function db_mt:Poll()
	self.Handle:Poll()
end

function db_mt:Escape(value)
	return self.Handle:Escape(tostring(value))
end

function db_mt:Log(message)
	MsgC(color_purple, '[MySQL] ', color_white, tostring(message) .. '\n')
end


local retry_errors = {
	['Lost connection to MySQL server during query'] = true,
	[' MySQL server has gone away'] = true,
}

function db_mt:Query(query, ...)
	local args = {...}
	local count = 0
	query = query:gsub('?', function()
		count = count + 1
		return '"' .. self:Escape(tostring(args[count])) .. '"'
	end)

	--print(query)
	--PrintTable(args)

	self.Handle:Query(query, function(results)
		if (results[1].error ~= nil) then
			self:Log(results[1].error)
			if retry_errors[results[1].error] then
				if query_queue[query] then
					query_queue[query].Trys = query_queue[query].Trys + 1
				else
					query_queue[query] = {
						Db 		= self, 
						Query 	= query,
						Trys 	= 0,
						Cback 	= args[count + 1]
					}
				end
			end
		elseif (type(args[count + 1]) == 'function') then
			args[count + 1](results[1].data, results[1].lastid, results[1].affected, results[1].time)
		end
	end)
end

function db_mt:QuerySync(query, ...)
	local data, lastid, affected, time
	local start = SysTime() + 0.3
	if (... == nil) then
		self:Query(query, function(_data, _lastid, _affected, _time)
			data, lastid, affected, time = _data, _lastid, _affected, _time
		end)
	else
		self:Query(query, ..., function(_data, _lastid, _affected, _time)
			data, lastid, affected, time = _data, _lastid, _affected, _time
		end)
	end
	
	while (not data) and (start >= SysTime()) do
		self:Poll()
	end
	return data, lastid, affected, time
end


function db_mt:SetCharacterSet(charset)
	self.Handle:SetCharacterSet(charset)
end

function db_mt:SetOption(opt, value)
	self.Handle:SetOption(opt, value)
end


function db_mt:GetServerInfo()
	return self.Handle:GetServerInfo()
end

function db_mt:GetHostInfo()
	return self.Handle:GetHostInfo()
end

function db_mt:GetServerVersion()
	return self.Handle:GetServerVersion()
end

timer.Create('mysql.QueryQueue', 0.5, 0, function()
	for k, v in pairs(query_queue) do
		if (v.Trys < 5) then
			v.Db:Query(v.Query, v.Cback)
			v.Trys = v.Trys + 1
		else
			query_queue[k] = nil
		end
	end
end)