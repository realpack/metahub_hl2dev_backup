ezsqloo = ezsqloo or { }
require('mysqloo')
require('dprint')
require('xfn')
local mysqloo = mysqloo
local tostring, string, unpack, type
do
  local _obj_0 = _G
  tostring, string, unpack, type = _obj_0.tostring, _obj_0.string, _obj_0.unpack, _obj_0.type
end
local pairs, ipairs, table
do
  local _obj_0 = _G
  pairs, ipairs, table = _obj_0.pairs, _obj_0.ipairs, _obj_0.table
end
local color_white = Color(255, 255, 255)
local color_grey = Color(200, 200, 200)
local print
print = function(...)
  _G.MsgC(color_white, 'EzSQL ')
  local col = color_grey
  for i = 1, (select('#', ...)) do
    _G.MsgC(col, tostring(select(i, ...)))
  end
  return _G.MsgN()
end
local formatters, formattersQuoted
formatters = {
  string = function(v, db)
    return db:escape(v)
  end,
  table = function(v, db)
    if #v == 0 then
      local vals
      do
        local _accum_0 = { }
        local _len_0 = 1
        for _index_0 = 1, #v do
          local val = v[_index_0]
          local tv = type(val)
          local _value_0 = formattersQuoted[tv](val, db)
          _accum_0[_len_0] = _value_0
          _len_0 = _len_0 + 1
        end
        vals = _accum_0
      end
      return table.concat(vals, ',')
    else
      local vals
      do
        local _accum_0 = { }
        local _len_0 = 1
        for k, v in pairs(v) do
          local tv = type(v)
          local _value_0 = '`' .. k .. '`=' .. formattersQuoted[tv](v, db)
          _accum_0[_len_0] = _value_0
          _len_0 = _len_0 + 1
        end
        vals = _accum_0
      end
      return table.concat(vals, ',')
    end
  end,
  number = function(v, db)
    return tostring(v)
  end
}
formattersQuoted = {
  table = function(v, db)
    return '(' .. formatters.table(v, db) .. ')'
  end,
  string = function(v, db)
    return '\'' .. formatters.string(v, db) .. '\''
  end,
  number = formatters.number
}
local formatArguments
formatArguments = function(db, args)
  for k, v in pairs(args) do
    local tv = type(v)
    if tv == 'table' then
      args[k] = formattersQuoted['table'](v, db)
    else
      args[k] = formatters[tv](v, db)
    end
  end
end
local databases = { }
local Db
do
  local _base_0 = {
    connect_new = function(self, options)
      local host, user, pass, db, port, socket, flags
      host, user, pass, db, port, socket, flags = options.host, options.user, options.pass, options.db, options.port, options.socket, options.flags
      if not (host) then
        error('must provide .host (host:port)')
      end
      if not (user) then
        error('must provide .user (mysql username)')
      end
      if not (pass) then
        error('must provide .pass (password)')
      end
      if not (db) then
        error('must provide .db (database name)')
      end
      local _host, _port = host:match('(.-):(.-)$')
      if _host and _port then
        host = _host
        port = tonumber(_port)
      end
      if not (port) then
        error('must provide .port or host:port')
      end
      self.host = host
      self.username = user
      self.database = db
      self.port = port
      self.hash = string.format('%s:%s@%s-%X', host, port, user, util.CRC(user .. '-' .. pass:sub(2)), db)
      if databases[self.hash] then
        self.db = databases[self.hash]
        return print('recycled database connection hashid: ' .. self.hash)
      else
        self.db = mysqloo.connect(host, user, pass, db, port)
        databases[self.hash] = self.db
        self.db.onConnected = function()
          return print(self.hash .. ' connected successfully.')
        end
        self.db.onConnectionFailed = function(_, err)
          print(Color(255, 0, 0), self.hash .. ' failed to establish connection: ' .. err)
          return self:invalidate()
        end
        return self:connect()
      end
    end,
    connect_shared = function(self, db)
      self.hash = db.hash
      self.host = db.host
      self.username = db.username
      self.database = db.database
      self.port = db.port
      self.db = db.db
    end,
    connect = function(self)
      local t = SysTime()
      print(self.hash .. ' establishing connection...')
      self.db:connect()
      self.db:wait()
      local dt = SysTime() - t
      return print('\ttook ' .. dt .. ' seconds.')
    end,
    invalidate = function(self)
      databases[self.hash] = nil
      self.query = function()
        return error('failed to connect to database')
      end
      self._query = function()
        return error('failed to connect to database')
      end
    end,
    connect_resume = function(self, db)
      self.hash = db.hash
      self.host = db.host
      self.username = db.username
      self.database = db.database
      self.port = db.port
      self.db = db.db
    end,
    escape = function(self, str)
      return self.db:escape(str)
    end,
    _query = function(self, sqlstr, callback)
      local query = self.db:query(sqlstr)
      query.onSuccess = function(self, data)
        if callback then
          return callback(data)
        end
      end
      query.onError = function(_, err)
        if self.db:status() == mysqloo.DATABASE_NOT_CONNECTED then
          self:connect()
        end
        ErrorNoHalt('QUERY FAILED!')
        print('SQL: ' .. sqlstr)
        print('ERR: ' .. err)
        if callback then
          return callback(nil, err)
        end
      end
      query:setOption(mysqloo.OPTION_INTERPRET_DATA)
      query:start()
      return query
    end,
    query = function(self, sqlstr, ...)
      local args = {
        ...
      }
      local cback
      if type(args[#args]) == 'function' then
        cback = table.remove(args, #args)
      else
        cback = xfn.noop
      end
      formatArguments(self, args)
      local count = 0
      sqlstr = sqlstr:gsub('?', function(match)
        count = count + 1
        return args[count]
      end)
      return self:_query(sqlstr, cback)
    end,
    query_sync = function(self, sqlstr, ...)
      local args = {
        ...
      }
      formatArguments(self, args)
      local count = 0
      sqlstr = sqlstr:gsub('?', function(match)
        count = count + 1
        return args[count]
      end)
      local _data, _err
      local query = self:_query(sqlstr, function(data, err)
        _data = data
        _err = err
      end)
      query:wait()
      return _data, _err
    end
  }
  _base_0.__index = _base_0
  local _class_0 = setmetatable({
    __init = function(self, options, ...)
      local host, user, pass, db, port = options, ...
      if type(host) == 'string' and user then
        return self:connect_new({
          host = host,
          user = user,
          pass = pass,
          db = db,
          port = port
        })
      elseif type(options) == 'table' then
        if options.__class and options.__class == self.__class then
          return self:connect_shared(options)
        else
          return self:connect_new(options)
        end
      end
    end,
    __base = _base_0,
    __name = "Db"
  }, {
    __index = _base_0,
    __call = function(cls, ...)
      local _self_0 = setmetatable({}, _base_0)
      cls.__init(_self_0, ...)
      return _self_0
    end
  })
  _base_0.__class = _class_0
  Db = _class_0
end
ezsqloo.newdb = function(...)
  return Db(...)
end
ezsqloo.Db = Db
