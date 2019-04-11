local string_comma = string.Comma

function rp.FormatMoney(n)
	return '$' .. string_comma(n)
end

function rp.formatNumber(n)
	return string_comma(n)
end