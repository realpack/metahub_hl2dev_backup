boost_printers = {}

boost_printers.BatteryAdd = 100
boost_printers.CoolingCellAdd = 100

boost_printers.list = {}

boost_printers.list["blue"] = {
	name          = "Принтер крон",
	color         = Color(0, 123, 255),
	gradient      = Color(0, 80, 200),
	battery       = 5,  -- How much battery does it take from the printer when it prints something
	cooling       = 10, -- How much cooling gel does it take from the printer when it prints something
	heat          = 20, -- How much heat does the printer get if the cooling cell is empty
	money         = 25, -- How much money does it prints. This number is multiplied by the printer speed (stars).
	rate          = { min = 30, max = 60 }, -- That will give random number between 30 and 60 for the print rate. Time is in seconds.
	upgrade_price = 30, -- This is the upgrade price of the printer for 1 star
}

boost_printers.list["red"] = {
	name          = "Принтер крон",
	color         = Color(255, 0, 0),
	gradient      = Color(200, 0, 0),
	battery       = 5,  -- How much battery does it take from the printer when it prints something
	cooling       = 10, -- How much cooling gel does it take from the printer when it prints something
	heat          = 20, -- How much heat does the printer get if the cooling cell is empty
	money         = 35, -- How much money does it prints. This number is multiplied by the printer speed (stars).
	rate          = { min = 30, max = 60 }, -- That will give random number between 30 and 60 for the print rate. Time is in seconds.
	upgrade_price = 50, -- This is the upgrade price of the printer for 1 star
}

boost_printers.list["green"] = {
	name          = "Принтер крон",
	color         = Color(0, 200, 0),
	gradient      = Color(0, 150, 0),
	battery       = 5,  -- How much battery does it take from the printer when it prints something
	cooling       = 10, -- How much cooling gel does it take from the printer when it prints something
	heat          = 20, -- How much heat does the printer get if the cooling cell is empty
	money         = 50, -- How much money does it prints. This number is multiplied by the printer speed (stars).
	rate          = { min = 30, max = 60 }, -- That will give random number between 30 and 60 for the print rate. Time is in seconds.
	upgrade_price = 100, -- This is the upgrade price of the printer for 1 star
}

boost_printers.list["yellow"] = {
	name          = "Принтер крон",
	color         = Color(255, 255, 0),
	gradient      = Color(252, 194, 0, 255),
	battery       = 5,  -- How much battery does it take from the printer when it prints something
	cooling       = 10, -- How much cooling gel does it take from the printer when it prints something
	heat          = 20, -- How much heat does the printer get if the cooling cell is empty
	money         = 65, -- How much money does it prints. This number is multiplied by the printer speed (stars).
	rate          = { min = 30, max = 60 }, -- That will give random number between 30 and 60 for the print rate. Time is in seconds.
	upgrade_price = 150, -- This is the upgrade price of the printer for 1 star
}

boost_printers.list["purple"] = {
	name          = "Принтер крон",
	color         = Color(139, 0, 204),
	gradient      = Color(0, 80, 200),
	battery       = 5,  -- How much battery does it take from the printer when it prints something
	cooling       = 10, -- How much cooling gel does it take from the printer when it prints something
	heat          = 20, -- How much heat does the printer get if the cooling cell is empty
	money         = 75, -- How much money does it prints. This number is multiplied by the printer speed (stars).
	rate          = { min = 30, max = 60 }, -- That will give random number between 30 and 60 for the print rate. Time is in seconds.
	upgrade_price = 250, -- This is the upgrade price of the printer for 1 star
}
