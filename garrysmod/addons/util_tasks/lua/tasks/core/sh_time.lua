local months = {
	[1] = 31,
	[2] = 28,
	[3] = 31,
	[4] = 30,
	[5] = 31,
	[6] = 30,
	[7] = 31,
	[8] = 31,
	[9] = 30,
	[10] = 31,
	[11] = 30,
	[12] = 31
}

function Tasks.DaysHaveElapsed(date, currentDate, days)
	date = string.Split(date, ":")
	local startHour, startDay, startMonth = tonumber(date[1]), tonumber(date[2]), tonumber(date[3])
	local currentDate = string.Split(currentDate, ":")
	local currentHour, currentDay, currentMonth = tonumber(currentDate[1]), tonumber(currentDate[2]), tonumber(currentDate[3])
	local daysPassed 
	if currentMonth == startMonth then
		daysPassed = currentDay - startDay
	else
		local daysInMonth = months[startMonth]
		daysPassed = (daysInMonth - startDay) + currentDay
	end
	return daysPassed == days and currentHour >= startHour or daysPassed > days
end