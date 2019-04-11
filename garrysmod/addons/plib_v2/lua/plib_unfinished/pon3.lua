require 'pbench'

local ASCII_OFFSET = 32
local ASCII_UPPER_BOUND = 126
local ASCII_COUNT = 94 -- 126 - 32

local math_pow = math.pow 

local string_sub = string.sub 
local string_char = string.char 
local string_byte = string.byte 





local encoders = {}
local decoders = {}

local math_log = math.log 
local math_log_94 = math.log(94)
local math_log_2 = math.log(2)
local math_pow = math.pow

local math_pow_94 = {}
for i = 0, 100 do math_pow_94[i] = math_pow(94, i) end

local math_pow_2 = {}
for i = 0, 100 do math_pow_2[i] = math_pow(2, i) end


local function _encode_number_helper(num)
	if num == 0 then return end
	local next = num / 94
	next = next - next % 1
	return 32 + num % 94, _encode_number_helper(next)
end

encoders['number'] = function(num, output)
	if num % 1 == 0 then
		local depth = -math_log(num) / math_log_2
		depth = -(depth - depth % 1)
		output[#output + 1] = string_char(73, 32 + depth, _encode_number_helper(num)) -- I(len)(num)
	else
		local pow = math.ceil(math_log(1 / (num % 1)) / math_log_2)
		print(pow)
		num = num * math_pow_2[pow]
		print(num)

		local depth = -math_log(num) / math_log_2
		depth = -(depth - depth % 1)
		output[#output + 1] = string_char(
				70, -- F(len)(pow)(num)
				32 + depth, 
				32 + pow, 
				_encode_number_helper(num)
			)
	end
end


local function _decode_number_helper(mult, a, ...)
	if a == nil then return 0 else return mult * (a - 32) + _decode_number_helper(mult * 94, ...) end
end
-- I(len)(num) : integer
decoders[73] = function(str, index)
	local size = string_byte(str, index, index) - 32
	index = index + 1
	local value = _decode_number_helper(1, string_byte(str, index, index + size))

	return index + size, value
end

-- F(len)(pow)(num) : floating point number
decoders[70] = function(str, index)
	local size, div = string_byte(str, index, index+1)
	size = size - 32
	index = index + 2
	local value = _decode_number_helper(1, string_byte(str, index, index + size))

	print('diviser power: ' .. div)
	return index + size, value / math_pow_2[div-32]
end

local ENC = {}
encoders['number'](12345.1, ENC)
print('encoded: ' .. ENC[1])
print('decoded: ', decoders[70](ENC[1], 2))



-- TODO: benchmark. is this faster to pass on stack?
local output = {}
local index = 1


local encode_integer
local decode_integer
do
	local function _encode_integer(num)
		if num == 0 then return end
		local next = num / 94
		next = next - next % 1
		return 32 + num % 94, _encode_number(next)
	end

	local math_log = math.log 
	local math_log_94 = math_log(94)
	function encode_integer(num)
		local depth = -math_log(num) / math_log_94
		depth = -(depth - depth % 1)
		return string_char(32 + depth, _encode_number(num))
	end

	local function _decode_integer(mult, a, ...)
		if a == nil then
			return 0
		else
			return mult * (a - 32) + _decode_number(mult * 94, ...)
		end
	end

	function decode_integer(data)
		local size = string_byte(data, 1, 1) - 32
		return _decode_integer(1, string_byte(data, 2, 1+size))
	end

end


local encode_double
local decode_double
do
	local function _encode_double(num)
		if num == 0 then return end
		local next = num / 94
		next = next - next % 1
		return 32 + num % 94, _encode_number(next)
	end

	local math_log = math.log 
	local math_log_94 = math_log(94)
	local math_pow = math.pow 
	function encode_double(num)
		local mul = -math_log(num % 1) / math_log_94
		num = num * math_pow(94, mul)

		local depth = -math_log(num) / math_log_94
		depth = -(depth - depth % 1)
		return string_char(32 + depth, 32 + mul, _encode_number(num))
	end

	local function _decode_double(mult, a, ...)
		if a == nil then
			return 0
		else
			return mult * (a - 32) + _decode_number(mult * 94, ...)
		end
	end

	function decode_double(data)
		local size, div = string_byte(data, 1, 2)
		size, div = size - 32, math_pow(94, div)
		return _decode_double(1, string_byte(data, 2, 1+size)) / div
	end
end


local BENCH_NUMBER = 10000000
print('benchmarking function 1')
pbench.push()
for i = 1, 1000000 do
	encode_number1(BENCH_NUMBER)
end
print('\ttook ' .. pbench.pop() .. ' to encode')

local encoded = encode_number1(BENCH_NUMBER) .. 'foobar'
pbench.push()
for i = 1, 1000000 do
	if decode_number1(encoded) ~= BENCH_NUMBER then
		error 'number was not the same'
	end
end
print('\ttook ' .. pbench.pop() .. ' to decode')

