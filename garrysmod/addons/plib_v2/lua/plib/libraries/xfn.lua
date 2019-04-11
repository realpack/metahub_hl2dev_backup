--[[
LICENSE:
_p_modules\lua\includes\modules\xfn.luasrc

Copyright 08/24/2014 thelastpenguin
]]

xfn = {
	version = (function(a, b, c) return a * 10000 + b * 100 + c end)(1,0,0)
}

local xfn = xfn;
local pairs , ipairs , unpack = pairs , ipairs , unpack ;

-- composes functions
function xfn.compose(a, b, ...)
	if not b then return a end
	b = xfn.compose(b, ...)
	return function(...)
		return b(a(...))
	end
end

-- returns the arguments
function xfn.returnArgs(fn)
	return function(...)
		fn(...)
		return ...
	end
end

-- identity
function xfn.identity(...)
	return ...
end

-- call all the functions with the same arguments
function xfn.parallel(...)
	-- its almost beautiful.
	xfn.compose(xfn.mapStack(xfn.returnArgs, ...))
end

function xfn.filter(tab, func)
	local c = 1
	for i = 1, #tab do
		if func(tab[i]) then
			tab[c] = tab[i]
			c = c + 1
		end
	end
	for i = c, #tab do
		tab[i] = nil
	end
	return tab
end

function xfn.map( tbl, func )
	for k,v in pairs( tbl )do
		tbl[k] = func( v, k );
	end
	return tbl;
end

local function mapStack(fn, ...)
	local function helper(count, a, ...)
		if count == 0 then return end
		return fn(a), helper(count - 1, ...)
	end
	return helper(select('#', ...), ...)
end
xfn.mapStack = mapStack


-- does nothing
function xfn.nothing() end
xfn.noop = xfn.nothing;

-- takes no inputs
function xfn.fn_deafen( func )
	return function() func() end
end
xfn.deafen = xfn.fn_deafen

-- gives no outputs
function xfn.neuter( func )
	return function(...)
		func(...)
	end
end

function xfn.curry(fn, arguments)
	if arguments == 1 then return fn end
	return function(a)
		return xfn.curry(
			function(...)
				return fn(a, ...)
			end,
			arguments - 1)
	end
end

function xfn.applyArgsToCurriedFunction(fn, ...)
	local count = select('#', ...)
	local function h_apply(count, fn, a, ...)
		if count == 0 then return fn end
		return h_apply(count - 1, fn(a), ...)
	end

	return h_apply(select('#', ...), fn, ...)
end

function xfn.bind(fn, ...)
	local curried = xfn.applyArgsToCurriedFunction(
		xfn.curry(fn, select('#', ...) + 1),
		...)
	return function(...)
		curried(...)
	end
end
xfn.partial = xfn.bind

function xfn.storeArgs(...)
	return xfn.applyArgsToCurriedFunction(
		xfn.curry(xfn.identity, select('#', ...) + 1),
		...)
end

function xfn.mergeStacks(...)
	local stack = xfn.storeArgs(...)
	return function(...)
		return stack(...)
	end
end

