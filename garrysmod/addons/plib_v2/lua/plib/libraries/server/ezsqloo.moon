export ezsqloo
ezsqloo or= {}

require 'mysqloo'
require 'dprint'
require 'xfn'

mysqloo = mysqloo
import tostring, string, unpack, type from _G
import pairs, ipairs, table from _G


color_white = Color 255, 255, 255
color_grey = Color 200, 200, 200
print = (...) ->
	_G.MsgC(color_white, 'EzSQL ')
	col = color_grey
	for i = 1, (select '#', ...)
		_G.MsgC col, tostring(select(i, ...))
	_G.MsgN()

--
-- UTILITIES
--
local formatters, formattersQuoted

formatters = 
	string: (v, db) ->
		db\escape(v)
	table: (v, db) ->
		if #v == 0
			vals = for val in *v
				tv = type(val)
				formattersQuoted[tv](val, db)
			table.concat(vals, ',')
		else
			vals = for k, v in pairs v
				tv = type(v)
				'`'..k..'`='..formattersQuoted[tv](v, db)
			table.concat(vals, ',')
	number: (v, db) ->
		tostring(v)

formattersQuoted = 
	table: (v, db) ->
		'(' .. formatters.table(v, db) .. ')'
	string: (v, db) ->
		'\'' .. formatters.string(v, db) .. '\''
	number: formatters.number

formatArguments = (db, args) ->
	for k,v in pairs(args)
		tv = type(v)
		if tv == 'table'
			args[k] = formattersQuoted['table'](v, db)
		else
			args[k] = formatters[tv](v, db)

databases = {}

class Db
	new: ( options, ... ) =>
		host, user, pass, db, port = options, ...

		if type(host) == 'string' and user
			@connect_new {
				host: host,
				user: user,
				pass: pass,
				db: db,
				port: port
			}
		elseif type(options) == 'table'
			if options.__class and options.__class == self.__class
				@connect_shared options
			else
				@connect_new options

	connect_new: (options) =>
		{
			:host,
			:user,
			:pass,
			:db,
			:port,
			:socket,
			:flags
		} = options

		error 'must provide .host (host:port)' unless host
		error 'must provide .user (mysql username)' unless user
		error 'must provide .pass (password)' unless pass
		error 'must provide .db (database name)' unless db
		_host, _port = host\match('(.-):(.-)$')
		if _host and _port
			host = _host
			port = tonumber(_port)
		error 'must provide .port or host:port' unless port

		@host = host
		@username = user
		@database = db
		@port = port

		@hash = string.format('%s:%s@%s-%X', host, port, user, util.CRC(user..'-'..pass\sub(2)), db)

		if databases[@hash]
			@db = databases[@hash]
			print 'recycled database connection hashid: ' .. @hash
		else
			@db = mysqloo.connect host, user, pass, db, port
			databases[@hash] = @db

			-- events on connection
			@db.onConnected = () ->
				print @hash .. ' connected successfully.'
			@db.onConnectionFailed = (_, err) ->
				print Color(255,0,0), @hash .. ' failed to establish connection: ' .. err
				@invalidate!

			@connect!

	connect_shared: (db) =>
		@hash = db.hash
		@host = db.host
		@username = db.username
		@database = db.database
		@port = db.port
		@db = db.db

	connect: () =>
		t = SysTime!
		print @hash .. ' establishing connection...'
		@db\connect!
		@db\wait!
		dt = SysTime! - t
		print '\ttook ' .. dt .. ' seconds.'

	invalidate: () =>
		databases[@hash] = nil
		@query = () ->
			error 'failed to connect to database'
		@_query = () ->
			error 'failed to connect to database'

	connect_resume: (db) =>
		@hash = db.hash
		@host = db.host
		@username = db.username
		@database = db.database
		@port = db.port
		@db = db.db

	escape: (str) =>
		return @db\escape(str)

	_query: (sqlstr, callback) =>
		query = @db\query(sqlstr)
		query.onSuccess = (data) =>
			callback(data) if callback
		query.onError = (_, err) ->
			if @db\status! == mysqloo.DATABASE_NOT_CONNECTED
				@connect!

			ErrorNoHalt('QUERY FAILED!')
			print('SQL: '..sqlstr)
			print('ERR: '..err)
			
			callback(nil, err) if callback

		query\setOption( mysqloo.OPTION_INTERPRET_DATA )
		query\start!
		return query

	query: (sqlstr, ...) =>
		args = {...}
		local cback
		if type(args[#args]) == 'function'
			cback = table.remove(args, #args)
		else
			cback = xfn.noop

		-- transform query arguments as desired
		formatArguments(self, args)

		count = 0
		sqlstr = sqlstr\gsub '?', (match) ->
			count += 1
			return args[count]

		return @_query(sqlstr, cback)

	query_sync: (sqlstr, ...) =>
		args = {...}
		formatArguments(self, args)

		count = 0
		sqlstr = sqlstr\gsub '?', (match) ->
			count += 1
			return args[count]

		local _data, _err
		query = @_query sqlstr, (data, err) ->
			_data = data
			_err = err

		query\wait!

		return _data, _err

ezsqloo.newdb = (...) ->
	Db(...)
	
ezsqloo.Db = Db