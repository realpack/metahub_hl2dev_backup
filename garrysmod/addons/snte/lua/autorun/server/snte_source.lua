--[[
If you read all of this file is that you will extract it in your ftp..
I ask you to just read the code and then add to your SNTE workshop collection,
I will not provide any support if I learn that your server runs on an outdated version..
if you do not agree with my request do not contact me (seriously)
]]

local rdmNetNum = 30 -- having more usable exploitable addons means it's 100% darkrp gamemode lol

// global list of exploits that circulates
local legit_nets = {
    "pplay_deleterow",
    "pplay_addrow",
    "pplay_sendtable",
    "WriteQuery",
    "VJSay",
    "SendMoney",
    "BailOut",
    "customprinter_get",
    "textstickers_entdata",
    "NC_GetNameChange",
    "ATS_WARP_REMOVE_CLIENT",
    "ATS_WARP_FROM_CLIENT",
    "ATS_WARP_VIEWOWNER",
    "CFRemoveGame",
    "CFJoinGame",
    "CFEndGame",
    "CreateCase",
    "rprotect_terminal_settings",
    "StackGhost",
    "RevivePlayer",
    "ARMORY_RetrieveWeapon",
    "TransferReport",
    "SimplicityAC_aysent",
    "pac_to_contraption",
    "SyncPrinterButtons76561198056171650",
    "sendtable",
    "steamid2",
    "Kun_SellDrug",
    "net_PSUnBoxServer",
    "pplay_deleterow",
    "pplay_addrow",
    "CraftSomething",
    "banleaver",
    "75_plus_win",
    "ATMDepositMoney",
    "Taxi_Add",
    "Kun_SellOil",
    "SellMinerals",
    "TakeBetMoney",
    "PoliceJoin",
    "CpForm_Answers",
    "DepositMoney",
    "MDE_RemoveStuff_C2S",
    "NET_SS_DoBuyTakeoff",
    "NET_EcSetTax",
    "RP_Accept_Fine",
    "RP_Fine_Player",
    "RXCAR_Shop_Store_C2S",
    "RXCAR_SellINVCar_C2S",
    "drugseffect_remove",
    "drugs_money",
    "CRAFTINGMOD_SHOP",
    "drugs_ignite",
    "drugseffect_hpremove",
    "DarkRP_Kun_ForceSpawn",
    "drugs_text",
    "NLRKick",
    "RecKickAFKer",
    "GMBG:PickupItem",
    "DL_Answering",
    "plyWarning",
    "NLR.ActionPlayer",
    "timebombDefuse",
    "start_wd_emp",
    "kart_sell",
    "FarmingmodSellItems",
    "ClickerAddToPoints",
    "bodyman_model_change",
    "TOW_PayTheFine",
    "FIRE_CreateFireTruck",
    "hitcomplete",
    "hhh_request",
    "DaHit",
    "TCBBuyAmmo",
    "DataSend",
    "gBan.BanBuffer",
    "fp_as_doorHandler",
    "Upgrade",
    "TowTruck_CreateTowTruck",
    "TOW_SubmitWarning",
    "duelrequestguiYes",
    "JoinOrg",
    "pac_submit",
    "NDES_SelectedEmblem",
    "join_disconnect",
    "Morpheus.StaffTracker",
    "casinokit_chipexchange",
    "BuyKey",
    "BuyCrate",
    "FactionInviteConsole",
    "FacCreate",
    "1942_Fuhrer_SubmitCandidacy",
    "pogcp_report_submitReport",
    "textscreens_download",
    "hsend",
    "BuilderXToggleKill",
    "Chatbox_PlayerChat",
    "reports.submit",
    "services_accept",
    "Warn_CreateWarn",
    "NewReport",
    "soez",
    "GiveHealthNPC",
    "DarkRP_SS_Gamble",
    "buyinghealth",
    "DarkRP_preferredjobmodel",
    "DarkRP_spawnPocket",
    "whk_setart",
    "WithdrewBMoney",
    "DuelMessageReturn",
    "ban_rdm",
    "BuyCar",
    "ats_send_toServer",
    "dLogsGetCommand",
    "disguise",
    "gportal_rpname_change",
    "AbilityUse",
    "ClickerAddToPoints",
    "race_accept",
    "give_me_weapon",
    "FinishContract",
    "NLR_SPAWN",
    "Kun_ZiptieStruggle",
    "JB_Votekick",
    "Letthisdudeout",
    "ckit_roul_bet",
    "pac.net.TouchFlexes.ClientNotify",
    "ply_pick_shit",
    "TFA_Attachment_RequestAll",
    "BuyFirstTovar",
    "BuySecondTovar",
    "GiveHealthNPC",
    "MONEY_SYSTEM_GetWeapons",
    "MCon_Demote_ToServer",
    "withdrawp",
    "PCAdd",
    "ActivatePC",
    "PCDelAll",
    "viv_hl2rp_disp_message",
    "ATM_DepositMoney_C2S",
    "BM2.Command.SellBitcoins",
    "BM2.Command.Eject",
    "tickbooksendfine",
    "egg",
    "RHC_jail_player",
    "PlayerUseItem",
    "Chess Top10",
    "ItemStoreUse",
    "EZS_PlayerTag",
    "simfphys_gasspill",
    "sphys_dupe",
    "sw_gokart",
    "wordenns",
    "SyncPrinterButtons16690",
    "AttemptSellCar",
    "DarkRP_spawnPocket",
    "uPLYWarning",
    "atlaschat.rqclrcfg",
    "dlib.getinfo.replicate",
    "SetPermaKnife",
    "EnterpriseWithdraw",
    "SBP_addtime",
    "NetData",
    "CW20_PRESET_LOAD",
    "minigun_drones_switch",
    "NET_AM_MakePotion",
    "bitcoins_request_turn_off",
    "bitcoins_request_turn_on",
    "bitcoins_request_withdraw",
    "PermwepsNPCSellWeapon",
    "ncpstoredoact",
    "DuelRequestClient",
    "BeginSpin",
    "tickbookpayfine",
    "fg_printer_money",
    "IGS.GetPaymentURL",
    "pp_info_send",
    "AirDrops_StartPlacement",
    "SlotsRemoved",
    "FARMINGMOD_DROPITEM",
    "cab_sendmessage",
    "cab_cd_testdrive",
    "blueatm",
    "SCP-294Sv",
    "dronesrewrite_controldr",
    "desktopPrinter_Withdraw",
    "RemoveTag",
    "IDInv_RequestBank",
    "UseMedkit",
    "WipeMask",
    "SwapFilter",
    "RemoveMask",
    "DeployMask",
    "ZED_SpawnCar",
    "levelup_useperk",
    "passmayorexam",
    "Selldatride",
    "ORG_VaultDonate",
    "ORG_NewOrg",
    "ScannerMenu",
    "misswd_accept",
    "D3A_Message",
    "LawsToServer",
    "Shop_buy",
    "D3A_CreateOrg",
    "Gb_gasstation_BuyGas",
    "Gb_gasstation_BuyJerrycan",
    "MineServer",
    "AcceptBailOffer",
    "LawyerOfferBail",
    "buy_bundle",
    "AskPickupItemInv",
    "donatorshop_itemtobuy",
    "netOrgVoteInvite_Server",
    "Chess ClientWager",
    "AcceptRequest",
    "deposit",
    "CubeRiot CaptureZone Update",
    "NPCShop_BuyItem",
    "SpawnProtection",
    "hoverboardpurchase",
    "soundArrestCommit",
    "LotteryMenu",
    "updateLaws",
    "TMC_NET_FirePlayer",
    "thiefnpc",
    "TMC_NET_MakePlayerWanted",
    "SyncRemoveAction",
    "HV_AmmoBuy",
    "NET_CR_TakeStoredMoney",
    "nox_addpremadepunishment",
    "GrabMoney",
    "LAWYER.GetBailOut",
    "LAWYER.BailFelonOut",
    "br_send_pm",
    "GET_Admin_MSGS",
    "OPEN_ADMIN_CHAT",
    "LB_AddBan",
    "redirectMsg",
    "RDMReason_Explain",
    "JB_SelectWarden",
    "JB_GiveCubics",
    "SendSteamID",
    "wyozimc_playply",
    "SpecDM_SendLoadout",
    "sv_saveweapons",
    "DL_StartReport",
    "DL_ReportPlayer",
    "DL_AskLogsList",
    "DailyLoginClaim",
    "GiveWeapon",
    "GovStation_SpawnVehicle",
    "inviteToOrganization",
    "createFaction",
    "sellitem",
    "giveArrestReason",
    "unarrestPerson",
    "JoinFirstSS",
    "bringNfreeze",
    "start_wd_hack",
    "DestroyTable",
    "nCTieUpStart",
    "IveBeenRDMed",
    "FIGHTCLUB_StartFight",
    "FIGHTCLUB_KickPlayer",
    "ReSpawn",
    "CP_Test_Results",
    "AcceptBailOffer",
    "IS_SubmitSID_C2S",
    "IS_GetReward_C2S",
    "ChangeOrgName",
    "DisbandOrganization",
    "CreateOrganization",
    "newTerritory",
    "InviteMember",
    "sendDuelInfo",
    "DoDealerDeliver",
    "PurchaseWeed",
    "guncraft_removeWorkbench",
    "wordenns",
    "userAcceptPrestige",
    "DuelMessageReturn",
    "Client_To_Server_OpenEditor",
    "GiveSCP294Cup",
    "GiveArmor100",
    "SprintSpeedset",
    "ArmorButton",
    "HealButton",
    "SRequest",
    "ClickerForceSave",
    "rpi_trade_end",
    "NET_BailPlayer",
    "vj_testentity_runtextsd",
    "requestmoneyforvk",
    "gPrinters.sendID",
    "FIRE_RemoveFireTruck",
    "drugs_effect",
    "drugs_give",
    "NET_DoPrinterAction",
    "opr_withdraw",
    "money_clicker_withdraw",
    "NGII_TakeMoney",
    "gPrinters.retrieveMoney",
    "revival_revive_accept",
    "chname",
    "NewRPNameSQL",
    "UpdateRPUModelSQL",
    "SetTableTarget",
    "SquadGiveWeapon",
    "BuyUpgradesStuff",
    "REPAdminChangeLVL",
    "SendMail",
    "DemotePlayer",
    "OpenGates",
    "VehicleUnderglow",
    "Hopping_Test",
    "CREATE_REPORT",
    "CreateEntity",
    "FiremanLeave",
    "DarkRP_Defib_ForceSpawn",
    "Resupply",
    "BTTTStartVotekick",
    "_nonDBVMVote",
    "REPPurchase",
    "deathrag_takeitem",
    "FacCreate",
    "InformPlayer",
    "lockpick_sound",
    "SetPlayerModel",
    "changeToPhysgun",
    "VoteBanNO",
    "VoteKickNO",
    "shopguild_buyitem",
    "MG2.Request.GangRankings",
    "RequestMAPSize",
    "gMining.sellMineral",
    "ItemStoreDrop",
    "optarrest",
    "DarkRP_TipJarUpdate",
    "TalkIconChat",
    "UpdateAdvBoneSettings",
    "ViralsScoreboardAdmin",
    "PowerRoundsForcePR"
}

// battle against a risk of backdoor
local bad_nets = {
    "Sbox_gm_attackofnullday_key",
    "c",
    "enablevac",
    "ULXQUERY2",
    "Im_SOCool",
    "MoonMan",
    "LickMeOut",
    "SessionBackdoor",
    "OdiumBackDoor",
    "ULX_QUERY2",
    "nocheat",
    "Sbox_itemstore",
    "Sbox_darkrp",
    "Sbox_Message",
    "_blacksmurf",
    "nostrip",
    "Remove_Exploiters",
    "Sandbox_ArmDupe",
    "rconadmin",
    "jesuslebg",
    "zilnix",
    "Þà?D)◘",
    "disablebackdoor",
    "blacksmurfBackdoor",
    "jeveuttonrconleul",
    "memeDoor",
    "DarkRP_AdminWeapons",
    "Fix_Keypads",
    "noclipcloakaesp_chat_text",
    "_CAC_ReadMemory",
    "Ulib_Message",
    "Ulogs_Infos",
    "ITEM",
    "fix",
    "nocheat",
    "Sandbox_GayParty",
    "DarkRP_UTF8",
    "OldNetReadData",
    "Backdoor",
    "cucked",
    "NoNerks",
    "kek",
    "ZimbaBackdoor",
    "something",
    "random",
    "strip0",
    "fellosnake",
    "idk",
    "killserver",
    "fuckserver",
    "cvaraccess",
    "rcon",
    "rconadmin",
    "web",
    "dontforget",
    "aze46aez67z67z64dcv4bt",
    "nolag",
    "changename",
    "music",
    "_Defqon",
    "xenoexistscl",
    "R8",
    "DefqonBackdoor",
    "fourhead",
    "echangeinfo",
    "PlayerItemPickUp",
    "kill",
    "Þ� ?D)◘",
    "thefrenchenculer",
    "elfamosabackdoormdr",
    "stoppk",
    "noprop",
    "reaper",
    "Abcdefgh",
    "JSQuery.Data(Post(false))",
    "pjHabrp9EY",
    "_Raze",
    "NoOdium_ReadPing",
    "m9k_explosionradius",
    "gag",
    "_cac_",
    "_Battleye_Meme_",
    "ULogs_B",
    "arivia",
    "_Warns",
    "striphelper",
    "m9k_explosive",
    "GaySploitBackdoor",
    "_GaySploit",
    "slua",
    "Bilboard.adverts:Spawn(false)",
    "BOOST_FPS",
    "FPP_AntiStrip",
    "ULX_QUERY_TEST2",
    "FADMIN_ANTICRASH",
    "ULX_ANTI_BACKDOOR",
    "UKT_MOMOS",
    "rcivluz",
    "SENDTEST",
    "_clientcvars",
    "_main",
    "GMOD_NETDBG",
    "thereaper",
    "audisquad_lua",
    "anticrash",
    "ZernaxBackdoor",
    "bdsm",
    "waoz",
    "stream",
    "adm_network",
    "antiexploit",
    "ReadPing",
    "berettabest",
    "BerettaBest",
    "negativedlebest"
}


local legit_num = #legit_nets
local bad_num = #bad_nets

local function ban(_, ply)
    ply:Ban(0, false)
    ply:Kick("(SNTE) Net exploit detected !")
end

timer.Simple(1, function()
    for i = legit_num, 1, -1 do
        if util.NetworkStringToID(legit_nets[i]) ~= 0 then
            print("(SNTE) " .. table.remove(legit_nets, i) .. " has been detected but probably not exploitable")
            legit_num = legit_num - 1
        end
    end
    for i = bad_num, 1, -1 do
        if util.NetworkStringToID(bad_nets[i]) ~= 0 then
            print("(SNTE) " .. table.remove(bad_nets, i) .. " has been detected ! Check your addons and make sure to remove the backdoor")
            net.Receive(bad_nets[i], ban)
            bad_num = bad_num - 1
        end
    end
    local global_nets = legit_nets
    table.Add(global_nets, bad_nets)
    for i = 1, rdmNetNum do
        local rand = table.remove(global_nets, math.random(1, bad_num + legit_num - (i-1)))
        if (not rand) then
            break
        end
        util.AddNetworkString(rand)
        net.Receive(rand, ban)
            print("(SNTE) Booby-trapped " .. rand)
    end
end)

if file.Exists("ulx/modules/sh/rcon.lua","LUA") then
    timer.Simple(1,function()
        function ulx.luaRun( calling_ply, command )
            ulx.fancyLogAdmin( calling_ply, true, "#A tried to run lua (SNTE blocked) : #s", command )
        end
        local luarun = ulx.command( "Rcon", "ulx luarun", ulx.luaRun, nil, false, false, true )
        luarun:addParam{ type=ULib.cmds.StringArg, hint="command", ULib.cmds.takeRestOfLine }
        luarun:defaultAccess( ULib.ACCESS_SUPERADMIN )
        luarun:help( "Executes lua in server console. (Use '=' for output)" )
    end)
end



--[[
this is a temporary patch until facepunch moves his buttocks,
the exploit is to crash instantly your server because of the duplicator .. there are example videos about this (the launch effect).
]]--

-- thx maks..thank you for continuing to contribute to gmod
CreateConVar("snte_dupefix", "1", FCVAR_ARCHIVE, "0 to activate dupe tool")
if GetConVar("snte_dupefix"):GetBool() then
    timer.Simple(1, function()
        net.Receive("ArmDupe", function(_, ply)
                ply:ChatPrint("Use snte_dupefix 0 in console to activate dupes (admin only)")
        end)
    end)
end
--------------------------------------------------------------------------------------------------------------------

--[[/*
Welcome to Say No To Exploits! - Edition 2018/2019


original creator of the code: meepdarknessmeep
https://github.com/meepen/say-no-to-exploits/

This script basically serves to be a little more safe from crazy cheats that connects to random heaps of servers to test various exploits,

The basic list written by meepdarknessmeep prevents the basic operation of the "Loki" add-on menu from the mod odium.pro menu... but French players recently brought us the base of this piece of shit to add various feat and complement in terms of backdoor .

around the 3/4 menu based on loki we had to detect (the most famous being that of the NTF team to then be declined on derma different but nevertheless substantially identical (Death Note, Jesus Menu),

Many groups see the day and come back relentlessly to the same shit while most will only work if the founder is stupid enough to throw a lua_run in the chat or install stolen addon.

What drives me to put this workshop online is literally the fatigue of seeing people get scammed and use poorly coded menus without forgetting the compassion of seeing servers "destroyed" every week.

I indicate in the source code the most useful exploits and for the founder of 8 to 15 years of very old exploit probably still valid (?)

in short, here is a piece of security but please keep in mind that the best security is your person ... do not listen to anyone and do not let the load of your server to a stranger called "Coder" or who pretend "Coding" ..

the best protections in theory are indicated below

- CAC ANTICHEAT (ultimate reference of the anti-cheat world)
- REMOVING RCON.LUA IN ULX MODULES
- DO NOTHING IN THE CONSOLE OR CHATBOX UNDER THE ADVICE OF A PLAYER

- INSTALL A BASIC SHIELD (theblacklist> https://g-box.fr/la-blacklist/)
- CHECK THE ADDONS PROVIDED BY "FRIENDS" OR "CODERS"

here it is .. I hope your server is now a little more secure and I wish you courage ;)



//////////////////////////////////////////////////////////////////////////////////////////////
FRENCH CREDITS


Bienvenue à Say No To Exploits! - Édition 2018/2019

créateur original du code: meepdarknessmeep

Ce script sert essentiellement à être un peu plus à l'abri de tricheurs fou qui se connecte à des tas de serveurs au hasard pour tester divers exploits,

La liste de base écrite par meepdarknessmeep empêche le fonctionnement de base du menu complémentaire "Loki" du menu mod odium.pro..mais des joueurs français récemment nous ressorte la base de ce morceau de merde pour ajouter divers feat et complètent en terme de backdoor.

autour du menu 3/4 reposant sur loki nous devions détecter (le plus célèbre étant celui de l'équipe NTF pour ensuite être décliné sur derma différent mais néanmoins sensiblement identique (Death Note, Jesus Menu),

De nombreux groupes voient la journée et reviennent sans relâche à la même merde alors que la plupart ne fonctionneront que si le fondateur est assez stupide pour lancer un lua_run dans le chat ou installer addon volé.

Ce qui me pousse à mettre en ligne cet atelier, c'est littéralement la fatigue de voir des gens se faire arnaquer et d'utiliser des menus mal codés sans oublier la compassion de voir des serveurs «détruits» chaque semaine.

J'indique dans le code source les exploits les plus utiles et pour le fondateur de 8 à 15 ans de très vieil exploit probablement encore valide (?)

bref voila un bout de sécurité mais je vous en prie gardez a l'esprit que la meilleur sécurité reste votre personne..n'écoutez pas n'importe qui et ne laisser pas la charge de votre serveur a un inconnu soit disant "Codeur" ou qui prétent "Codage"..

la meilleur protetion en tutoriel est indiquer ci-dessous

- CAC ANTICHEAT (référence ultime du monde de l'anti triche)
- SUPPRESSION DU RCON.LUA DANS LES MODULES ULX
- NE RIEN FAIRE DANS LA CONSOLE OU CHATBOX SOUS LES CONSEILS D'UN JOUEUR

- INSTALLEZ UN BOUCLIER DE BASE (theblacklist > https://g-box.fr/la-blacklist/ )
- VERIFIEZ LES ADDONS FOURNIT PAR DES "AMIS" OU "CODEUR"

voila voila..j'espere que votre serveur est désormais un peu plus a l'abri et je vous souhaite du courage ;)
*/--]]--
