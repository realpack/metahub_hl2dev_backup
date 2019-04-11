bib = bib or {} -- Не знаю, почему я решил дать ему именно такое название

function bib.set(key,value)
	sql.Query([[
		REPLACE INTO `bib`(`key`,`value`)
		VALUES (]] .. sql.SQLStr(key) .. "," .. sql.SQLStr(value) .. [[)
	]])
end

function bib.get(key,fallback)
	return sql.QueryValue([[
		SELECT `value`
		FROM `bib`
		WHERE `key` = ]] .. sql.SQLStr(key)
	) or fallback
end

function bib.delete(key)
	sql.Query([[
		DELETE FROM `bib`
		WHERE `key` = ]] .. sql.SQLStr(key)
	)
end

function bib.getAll()
	local t = sql.Query([[
		SELECT `key`,`value`
		FROM `bib`
	]]) or {}

	local kv = {}
	for _,v in ipairs(t) do
		kv[v.key] = v.value
	end

	return kv
end

function bib.reset()
	sql.Query([[
		DELETE FROM `bib`
	]])
end

sql.Query([[
	CREATE TABLE IF NOT EXISTS `bib` (
		`key`   TEXT NOT NULL UNIQUE,
		`value` TEXT,
		PRIMARY KEY(key)
	);
]])





--[[-------------------------------------------------------------------------
	Extra
---------------------------------------------------------------------------]]
function bib.getBool(k)
	return bib.get(k,"f") == "t"
end

function bib.setBool(k,b)
	bib.set(k,b and "t" or "f")
end

function bib.getNum(k,iFallback)
	return tonumber(bib.get(k,iFallback))
end

function bib.setNum(k,i)
	bib.set(k,i)
end

-- local function g() return bib.getBool("foo") end
-- local function s(b) bib.setBool("foo",b) end
-- s(nil)   print("false",g())
-- s(true)  print("true",g())
-- s(false) print("false",g())
-- s(1)     print("true",g())
