-- used like <tag=[pi * rand()]>

local lib =
{
	PI = math.pi,
	pi = math.pi,
	rand = math.random,
	random = math.random,
	randx = function(a,b)
		a = a or -1
		b = b or 1
		return math.Rand(a, b)
	end,

	abs = math.abs,
	sgn = function (x)
		if x < 0 then return -1 end
		if x > 0 then return  1 end
		return 0
	end,
	
	pwm = function(offset, w)
		w = w or 0.5
		return offset%1 > w and 1 or 0
	end,
	
	square = function(x)
		x = math.sin(x)
		
		if x < 0 then return -1 end
		if x > 0 then return  1 end
		
		return 0
	end,

	acos = math.acos,
	asin = math.asin,
	atan = math.atan,
	atan2 = math.atan2,
	ceil = math.ceil,
	cos = math.cos,
	cosh = math.cosh,
	deg = math.deg,
	exp = math.exp,
	floor = math.floor,
	frexp = math.frexp,
	ldexp = math.ldexp,
	log = math.log,
	log10 = math.log10,
	max = math.max,
	min = math.min,
	rad = math.rad,
	sin = math.sin,
	sinc = function (x)
		if x == 0 then return 1 end
		return math.sin(x) / x
	end,
	sinh = math.sinh,
	sqrt = math.sqrt,
	tanh = math.tanh,
	tan = math.tan,

	clamp = math.Clamp,
	pow = math.pow
}

local blacklist = {"repeat", "until", "function", "end"}

local expressions = {}

local function loadstring(str, env)
	local var = CompileString(str, env or "loadstring", false)
	if type(var) == "string" then
		return nil, var, 2
	end
	return setfenv(var, getfenv(1))
end

local function compile_expression(str, extra_lib)
	local source = str

	for _, word in pairs(blacklist) do
		if str:find("[%p%s]" .. word) or str:find(word .. "[%p%s]") then
			return false, string.format("illegal characters used %q", word)
		end
	end

	local functions = {}

	for k,v in pairs(lib) do functions[k] = v end

	if extra_lib then
		for k,v in pairs(extra_lib) do functions[k] = v end
	end

	local t0 = os.clock()
	functions.t    = function () return os.clock() - t0 end
	functions.time = function () return os.clock() - t0 end
	functions.select = select

	str = "local input = select(1, ...) return " .. str

	local func, err = loadstring(str)

	if func then
		setfenv(func, functions)
		expressions[func] = source
		return true, func
	else
		return false, err
	end
end

expression = {Compile = compile_expression}