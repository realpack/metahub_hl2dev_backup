Tasks.Registered = Tasks.Registered or {}

local function RegisterTask(id, name, description, reward, rewardFunc, days, doFunc, checkFunc)
	Tasks.Registered[id] = {doFunc = doFunc, 
							checkFunc = checkFunc, 
							description = description,
							days = days,
							name = name,
							reward = reward,
							rewardFunc = rewardFunc or Tasks.RewardPlayer}
end

local function NameContainsURL(ply, cback)
    -- local name = gmod.GetGamemode().Name == "DarkRP" and ply:SteamName() or ply:Name() // cheers falco
    local name = ply:OldName()
    cback(string.find(string.lower(name), string.lower(Tasks.Config.Website)))
end

RegisterTask("steam_group", 
			  Tasks.GetPhrase("steam_group_title"), 
			  Tasks.GetPhrase("steam_group_desc"), 
			  "Кроны 3000",
			  Tasks.DefaultRewardFunc(3000), 
			  0, 
			  Tasks.SteamGroup.Join, 
			  Tasks.SteamGroup.IsInGroup)
			  
RegisterTask("steam_name", 
			  Tasks.GetPhrase("steam_name_title"), 
			  Tasks.GetPhrase("steam_name_desc"), 
			  "Кроны 3000",
			  Tasks.DefaultRewardFunc(3000), 
			  0, 
			  function() end, 
			  NameContainsURL)

RegisterTask("discord_join", 
			  Tasks.GetPhrase("discord_join_title"), 
			  Tasks.GetPhrase("discord_join_desc"), 
			  "Кроны 4000",
			  Tasks.DefaultRewardFunc(4000), 
			  0, 
			  Tasks.Discord.Join, 
			  Tasks.Discord.Joined)

// To disable one just put // in front of it like so:
//RegisterTask("forum_join", "Forums", "Sign up on our forums", 5000, 0, Tasks.Forums.Join, Tasks.Forums.UserExists)

/*
Adding your own tasks:

RegisterTask(id, name, description, reward, days, do function, check function)

id - this is the id used in the database, once you have set this and players have done the task you shouldn't change the id

name - name displayed on the ui

description - description displayed on the ui

reward - amount of credits, points, money you give the user as a reward

reward function - Tasks.DefaultRewardFunc(amount) for default or you can use: Tasks.RPCash(amount), Tasks.PS1(amount), Tasks.PS2(amount), Tasks.PS2_Premium(amount), Tasks.ULXGroup(group)

days - how many days until they can do it again, 0 for never

do function - client function called when they press the "Do It" button
check function - server function called to check if they should get the reward
*/