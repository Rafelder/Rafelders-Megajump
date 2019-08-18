/////////////////////////////////////////
//////////RAFELDERS'S MEGAJUMP///////////
/////////////////////////////////////////
////Scripted by Rafelder/////////////////
////////Mapped by Rafelder and Desert////
/////////////////////////////////////////
/////////Copyright by Rafelder///////////
/////////////////////////////////////////

#include <a_samp>
#include <Megajump/bfx_oStream>
#include <LanguageNew>
#include <MegajumpO>

#pragma dynamic 99999

#define ModeName "MM"
#define RESTART_MINUTES 120

//#define TEXT_DRAW_IN_USE
/*****REG+LOG*****/
new logged[MAX_PLAYERS];
new adminlevel[MAX_PLAYERS];
new vip[MAX_PLAYERS];
new plevel[MAX_PLAYERS];
new Kills[MAX_PLAYERS];
new Deaths[MAX_PLAYERS];
new Skin[MAX_PLAYERS];
new DM[MAX_PLAYERS];
/*****IMPORTANT*****/
new Ramp[MAX_PLAYERS];
new muted[MAX_PLAYERS];
new hasspawned[MAX_PLAYERS];
new seconds;
new countdowntimer;
new newspawned[MAX_VEHICLES];
#define high 2//Spawnhigh
#define carcolor 6//Carcolor of spawned vehicles
#define Respawn_Delay 20//Respawn_Delay
#define Wartezeit 30*1000
#define DM_INFO_COORDS -65.162757, 1914.825683, 17.226562, 179.024429
#define SKIN_DM_INFO 190
new Float:gBackCoords[43][4] = {
{-2820.671631, -2831.666016, 1934.666992, 338.0},
{-179.5144040, 2308.7683100, 715.6417230, 90.00},
{1410.5349120, -154.2465820, 707.3397820, 179.7},
{-353.9770000, 2705.2290000, 533.2410000, 122.0},
{-367.1649780, -1640.131592, 884.9698490, 44.00},
{-2682.302734, 2427.4367680, 637.5301510, 180.0},
{67.462868000, -900.9755860, 447.2370000, 180.0},
{834.57971200, -2355.493408, 467.8578800, 360.0},
{1242.3818360, -1588.320313, 346.3426210, 270.0},
{-427.1530000, -1046.698000, 284.5090000, 327.0},
{-2482.833984, 247.02409400, 18.70662300, 270.0},
{3040.8483890, -1780.456055, -56.1729050, 180.0},
{2835.3383790, -1774.232544, 3207.975342, 90.00},
{1946.9381100, 1692.6065670, 657.7426760, 180.0},
{-2202.443848, -33.42960700, 276.2835390, 270.0},
{73.867798000, 2158.4274900, 296.0219120, 360.0},
{1129.0437010, -1785.406006, 285.4363100, 360.0},
{586.35000000, 2504.7100000, 149.0200000, 90.00},
{2716.5202640, 713.21594200, 226.2851260, 90.00},
{-1794.552612, 577.82849100, 233.4958190, 360.0},
{330.83660900, -928.6892700, 317.0557560, 345.0},
{-2473.942871, 3079.9890140, 649.5173340, 180.0},
{-2152.638672, 918.23248300, 93.46353100, 270.0},
{2190.6508790, 1049.9211430, 80.22824900, 0.000},
{1547.1521000, -1330.458252, 235.7529450, 259.0},
{-2148.347412, -550.2412110, 196.4017640, 0.000},
{1535.1542970, -1352.153931, 330.7169490, 0.000},
{-656.9807740, 2351.7580570, 189.5256500, 253.0},
{-2259.150000, 731.07800000, 479.6500000, 270.0},
{618.15100000, 2501.6280000, 206.1680000, 90.00},
{-1945.271606, 470.45550500, 211.9781190, 180.0},
{3265.1700000,-1081.8550000, 199.9340000, 98.00},
{724.00567600, -2215.074951, 233.3557430, 0.000},
{2471.9287100, -1663.113891, 5216.367187, 273.0},
{-552.6793820, 1805.0926510, 147.6343540, 22.00},
{-1016.483093, 2517.2768550, 286.4449460, 206.0},
{3123.2470700, -1196.759766, 183.7489930, 180.0},
{1922.6234130, 123.79566900, 265.6589350, 180.0},
{1379.6110840, -1711.107666, 10.65937500, 259.0},
{2069.3378910, -1303.622314, 587.8427120, 90.00},
{-2234.592041, -1732.330933, 484.9392700, 203.0},
{3143.6120610, -173.9495540, 267.5273740, 118.0},
{369.82100000, -1428.698000, 181.0950000, 180.0}
};
/*****ADMINSPEC*****/
#define ADMIN_SPEC_TYPE_NONE 0
#define ADMIN_SPEC_TYPE_PLAYER 1
#define ADMIN_SPEC_TYPE_VEHICLE 2
new gSpectateID[MAX_PLAYERS];
new gSpectateType[MAX_PLAYERS];
/*****COLORS*****/
#define COLOR_WHITE 0xFFFFFFFF
#define COLOR_YELLOW 0xFFFF00FF
#define COLOR_ORANGE 0xFF6600FF
#define COLOR_RED 0xC60000FF
//#define COLOR_BLUE 0x006699FF
#define COLOR_BLUE 0x006CD9FF
#define COLOR_GREEN 0x40FF40FF
#define COLOR_GREY 0xAFAFAFAA
#define COLOR_BLACK 0x000000FF
/*****TEXTDRAW*****/
#if defined TEXT_DRAW_IN_USE
new Text: box;
new Text: info;
new Text: info2;
#endif
/*****FORWARD*****/
forward NosTimer();
forward Cardel();
forward ResetVehicleSpawn(playerid);
forward Inforeset(playerid);
forward MoneyTimer();
forward Message();
forward CountDown();
forward GameTextTimer(playerid);
forward ExitGameMode();
/*****DCMD*****/
#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#define DisableBadword(%1) for(new i=0; i<strlen(text); i++) if(strfind(text[i], %1, true) == 0) for(new a=0; a<256; a++) if (a >= i && a < i+strlen(%1)) text[a]='*'
//=====MAIN=====================================================================
main()
{
	new ocount;

 	/*for(new i=0; i<10000; i++) {
  		if (IsValidDynamicObject(i)) {
    		ocount++;
    	}
	}*/
	printf("\n\n\n\n\n\n");
	printf("		  /-----------------------------------\\");
	printf("		  | Rafelder's Megajump V.4.1         |");
	printf("		  |-----------------------------------|");
	printf("		  | Created by Rafelder               |");
	printf("		  | in accession with Desert          |");
	printf("		  |-----------------------------------|");
	printf("		  | Objects loaded: %04d              |", ocount);
	printf("		  |-----------------------------------|");
	printf("		  | Includes: Megajump.inc            |");
	printf("		  \\-----------------------------------/\n\n\n\n\n\n");
}
//=====GAMEMODE=================================================================
public OnGameModeInit()
{
	StreamObject_OnGameModeInit();
	SetGameModeText("_|>Megajump<|_");
	SetWeather(6);
	SetWorldTime(12);
	UsePlayerPedAnims();
	EnableZoneNames(1);
	AllowInteriorWeapons(0);
	DisableInteriorEnterExits();
	/*****PLAYERCLASSES*****/
	AddPlayerClass( 29, -183.961074, 1894.715454, 115.223503, 178.397781, 0, 0, 0, 0, 0, 0);
	AddPlayerClass( 12, -183.961074, 1894.715454, 115.223503, 178.397781, 0, 0, 0, 0, 0, 0);
	AddPlayerClass( 21, -183.961074, 1894.715454, 115.223503, 178.397781, 0, 0, 0, 0, 0, 0);
	AddPlayerClass( 233, -183.961074, 1894.715454, 115.223503, 178.397781, 0, 0, 0, 0, 0, 0);
	/*****OBJECTS*****/
	AddObjects();
	/*****TEXTDRAW*****/
	#if defined TEXT_DRAW_IN_USE
	box = TextDrawCreate(0, 425, " ~b~Rafelder's ~g~Megajump    ~y~Tipe ~r~/car, /bike, /bmx or /quad ~y~to get a vehicle~n~~w~ Update: Script uses less traffic [ /setpass <oldpw> <newpw> ]");
	TextDrawUseBox(box, 1);
	TextDrawSetShadow(box, 0);
	TextDrawSetOutline(box, 1);
	info = TextDrawCreate(0, 125, "~y~Welcome to ~g~Rafelder's ~b~Megajump!~n~~n~~y~On this server you can drive many ramps.~n~To see the ramps tipe ~g~/jumps.~n~~y~After you teleported yourself to a ramp you can spawn different vehicles:");
	TextDrawUseBox(info, 1);
	TextDrawSetShadow(info, 0);
	TextDrawSetOutline(info, 1);
	TextDrawBoxColor(info, 0x000000CC);
	info2 = TextDrawCreate(0, 180, "~y~Tipe ~g~/car ~y~(Infernus), ~g~/bike ~y~(NRG-500), ~g~/quad~y~ (Quad) or ~g~/bmx ~y~(BMX).~n~~n~~r~Respect the rules:~n~Dont hit/dis other players!~n~Dont steal vehicles!~n~~n~~b~Have fun...");
	TextDrawUseBox(info2, 1);
	TextDrawSetShadow(info2, 0);
	TextDrawSetOutline(info2, 1);
	TextDrawBoxColor(info2, 0x000000CC);
	#endif
	/*****TIMER*****/
	SetTimer("NosTimer", 19000, 1);
	SetTimer("MoneyTimer", 1000, 1);
	SetTimer("Message", 1000*60*10, 1);
	SetTimer("ExitGameMode", 1000*60*RESTART_MINUTES, 0);
	return 1;
}

public OnGameModeExit()
{
	return 1;
}
//=====TIMER====================================================================
public ExitGameMode()
{
	new string[128];
	format(string, 128, "changemode %s", ModeName);
	SendRconCommand(string);
	StreamObject_OnGameModeExit();
	return 1;
}

public NosTimer()
{
	new Float:armour, ping;
	new string0[256], string1[256];
		
  	for(new a=0; a<MAX_PLAYERS; a++) {
		GetPlayerArmour(a, armour);
		if (armour > 0 && !IsPlayerAdmin(a)) {
			for(new b=0; b<MAX_PLAYERS; b++)
			if (IsPlayerAdminLevel(b, 1)) SendLanguageMessageEx(b, COLOR_ORANGE, "[HACKER WARNING]: %s has got armour!", PlayerName(a), "[HACKER WARNUNG]: %s hat R�stung!", PlayerName(a));
		}
	}
		
  	for(new i=0; i<MAX_PLAYERS; i++) {
		AddVehicleComponent(GetPlayerVehicleID(i), 1010);
  	}

	for(new i=0; i<MAX_PLAYERS; i++) {
		ping = GetPlayerPing(i);
		if(ping > 600 && ping < 65535) {
			if(!IsPlayerAdmin(i) && adminlevel[i] == 0) {
				SendLanguageMessageEx(i, 0x0099CCFF, "You was kicked with reason of too high ping: %s (allowed: 600)", TurnIntoString(ping), "Du bist wegen eines zu hohen Pings gekickt worden: %s (erlaubt: 600)", TurnIntoString(ping));
				format(string0, sizeof(string0), "%s was kicked with reason of too high ping: %d (allowed: 600)", PlayerName(i), ping);
				format(string1, sizeof(string1), "%s wurde wegen eines zu hohen Pings gekickt: %d (erlaubt: 600)", PlayerName(i), ping);
				SendLanguageMessageToAll(0x0099CCFF, string0, string1);
				Kick(i);
			}
		}
	}
	return 1;
}

public Message()
{
	SendLanguageMessageToAll(COLOR_BLUE,   "x-x-x-x-x-x-x-x-x-x-x-Megajump-Message-x-x-x-x-x-x-x-x-x-x", "x-x-x-x-x-x-x-x-x-x-x-Megajump-Message-x-x-x-x-x-x-x-x-x-x");
	SendLanguageMessageToAll(COLOR_YELLOW, "Don't know how to spawn a vehicle? /car /bike /quad or /bmx", "Du wei�t nicht wie man Autos spawnt? /car /bike /quad oder /bmx");
	SendLanguageMessageToAll(COLOR_YELLOW, "Don't know what to do? Tipe /jumps to see the available jumps", "Du wei�t nicht was du machen kannst? Tippe /jumps um die verf�gbaren Rampen zu sehen");
	SendLanguageMessageToAll(COLOR_RED, "Tipe /back to get back to the start of your ramp!", "Tippe /back um dich zum Anfang deiner Rampe zu teleportieren");
	SendLanguageMessageToAll(COLOR_YELLOW, "Want to know your stunt level? Tipe /level", "Du willst dein Stuntlevel wissen? Tippe /level");
	SendLanguageMessageToAll(COLOR_YELLOW, "Have fun playing on Rafelder's Megajump", "Viel Spa� auf Rafelder's Megajump");
    SendLanguageMessageToAll(COLOR_RED, "Visit our homepage: www.megajump.foren-city.de (German homepage)", "Besuche unsere Homepage: www.megajump.foren-city.de");
	SendLanguageMessageToAll(COLOR_BLUE,   "x-x-x-x-x-x-x-x-x-x-x-Megajump-Message-x-x-x-x-x-x-x-x-x-x", "x-x-x-x-x-x-x-x-x-x-x-Megajump-Message-x-x-x-x-x-x-x-x-x-x");
	return 1;
}

public MoneyTimer()
{
	for(new i=0; i<MAX_PLAYERS; i++) {
		#define money GetPlayerMoney(i)
	 	SetPlayerScore(i, money);
	 	if(DM[i] == 0)
	 	{
	 	    if (IsPlayerInInfoDMArea(i))
	 	    {
	 	        LanguageGameText(i, "~r~You are not allowed to be here!", "~r~Du darfst dich hier nicht aufhalten!", 3000, 3);
				SpawnPlayer(i);
			}
			if (money < 5000) SetPlayerWantedLevel(i, 0), plevel[i]=0;
			if (money >= 5000 && money < 20000) SetPlayerWantedLevel(i, 1), GivePlayerMoney(i, 10), plevel[i]=1;
			if (money >= 20000 && money < 50000) SetPlayerWantedLevel(i, 2), GivePlayerMoney(i, 20), plevel[i]=2;
			if (money >= 50000 && money < 100000) SetPlayerWantedLevel(i, 3), GivePlayerMoney(i, 30), plevel[i]=3;
			if (money >= 100000 && money < 500000) SetPlayerWantedLevel(i, 4), GivePlayerMoney(i, 40), plevel[i]=4;
			if (money >= 500000 && money < 1000000) SetPlayerWantedLevel(i, 5), GivePlayerMoney(i, 50), plevel[i]=5;
			if (money >= 1000000 && money < 10000000) SetPlayerWantedLevel(i, 6), GivePlayerMoney(i, 100), plevel[i]=6;
			if (money > 10000000) {
				if (vip[i] == 0) SendLanguageMessageToAllEx(COLOR_YELLOW, "*%s reached $10.000.000 and becomes V.I.P.*", PlayerName(i), "*%s hat $10.000.000 erreicht und wird V.I.P.*", PlayerName(i));
				vip[i]=1;
				SetPlayerWantedLevel(i, 0);
				plevel[i]=7;
			}
		}
		else
		{
			if(!IsPlayerInInfoDMArea(i))
			{
				SpawnPlayer(i);
			    SetTimerEx("GameTextTimer", 500, 0, "i", i);
			}
		}
		#undef money
	}
	return 1;
}

public GameTextTimer(playerid)
{
    LanguageGameText(playerid, "~r~You are not allowed to be here!", "~r~Du darfst dich hier nicht aufhalten!", 3000, 3);
}

public Cardel()
{
	for(new cars=0; cars<MAX_VEHICLES; cars++) DestroyVehicle(cars);
	for(new players=0; players<MAX_PLAYERS; players++)
	if (IsPlayerConnected(players)) TogglePlayerControllable(players, 1);
	return 1;
}

public ResetVehicleSpawn(playerid) return hasspawned[playerid]=0;

public CountDown()
{
	if (seconds <= 0)
	{
	    LanguageGameTextForAll("~g~GO!!!", "~g~Los!!!", 1000, 4);
	    PlaySoundForAll(1057);
	    KillTimer(countdowntimer);
	}
	else
	{
		LanguageGameTextForAllEx("~y~%s", TurnIntoString(seconds), "~y~%s", TurnIntoString(seconds), 2000, 4);
	    PlaySoundForAll(1056);
		seconds--;
	}
}

#if defined TEXT_DRAW_IN_USE
public Inforeset(playerid)
{
	TogglePlayerControllable(playerid, 1);
	TextDrawHideForPlayer(playerid, info);
	TextDrawHideForPlayer(playerid, info2);
	return 1;
}
#endif
//=====(DIS)CONNECT=============================================================
public OnPlayerConnect(playerid)
{
    /*****MESSAGE*****/
    if (dini_Exists(PlayerName(playerid)))
	{
    	SetPlayerLanguage(playerid, dini_Int(PlayerName(playerid), "language"));
	}
	else SetPlayerLanguage(playerid, LANGUAGE_ENGLISH);
	LanguageGameText(playerid, "~b~Welcome to faboulous~n~~y~Rafelder's Megajump ~g~V.4.1", "~b~Willkommen auf~n~~y~Rafelder's Megajump ~g~V.4.1", 5000, 3);
	SendLanguageMessageToAllEx(0x009900FF, "***%s joined the Server.***", PlayerName(playerid), "***%s hat den Server betreten.***", PlayerName(playerid));
	SendLanguageMessage(playerid, COLOR_BLUE, "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x", "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x");
	SendLanguageMessageEx(playerid, 0xFFFF00FF, "Welcome %s on Rafelder's Megajump!", PlayerName(playerid), "Willkommen %s auf Rafelder's Megajump!", PlayerName(playerid));
	SendLanguageMessage(playerid, 0xFFFF00FF, "Tipe /help to get help!", "Tippe /help um Hilfe zu bekommen!");
	SendLanguageMessage(playerid, COLOR_BLUE, "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x", "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x");
	if (dini_Exists(PlayerName(playerid))) SendLanguageMessageEx(playerid, COLOR_YELLOW, "Welcome back %s, your account already exist. Please log in with /login <password>.", PlayerName(playerid), "Willkommen zur�ck %s, dein Account besteht schon. Bitte logge dich mit /login <password> ein.", PlayerName(playerid));
    else SendLanguageMessageEx(playerid, COLOR_YELLOW, "Welcome %s, tipe /register to register yourself with the server.",PlayerName(playerid), "Willkommen %s, tippe /register um dich zu registrieren.",PlayerName(playerid));
	SendLanguageMessage(playerid, COLOR_BLUE, "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x", "x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x-x");
	muted[playerid]=0;
	hasspawned[playerid]=0;
	Ramp[playerid]=0;
	logged[playerid]=0;
	adminlevel[playerid]=0;
	vip[playerid]=0;
	plevel[playerid]=0;
	Kills[playerid]=0;
	Deaths[playerid]=0;
	Skin[playerid]=0;
	DM[playerid]=0;
	/*****SONTSIGES*****/
	#if defined TEXT_DRAW_IN_USE
	SetPlayerCheckpoint(playerid, -188.880508, 1887.126098, 115.546958, 3);
	TextDrawShowForPlayer(playerid, box);
	#endif
	/*****BANS*****/
	if (!strcmp(PlayerName(playerid), "Mark_Rock", true)) return Ban(playerid);//Really bad hacker!!
	/*****LANGUAGE*****/
	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	if (dini_Exists(PlayerName(playerid))) {
		SendLanguageMessageEx(playerid, COLOR_YELLOW, "Your language was changes automaticly to %s", Languages[Language[playerid]], "Deine Sprache wurde automatisch zu %s gewechselt", Languages[Language[playerid]]);
	}
	else SendLanguageMessage(playerid, COLOR_YELLOW, "Change your language: \"/setlanguage [English/German]\"", "W�hle deine Sprache: \"/setlanguage [English/German]\"");
	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	return 1;
}

public OnPlayerDisconnect(playerid, reason)
{
	StreamObject_OnPlayerDisconnect(playerid);
	/*****MESSAGE*****/
    switch (reason)    {
        case 0: SendLanguageMessageToAllEx(0x0099CCFF, "%s has left the server! (Timeout)", PlayerName(playerid), "%s hat den Server verlassen! (Timeout)", PlayerName(playerid));
        case 1: SendLanguageMessageToAllEx(0x0099CCFF, "%s has left the server! (Leaving)", PlayerName(playerid), "%s hat den Server verlassen! (Leaving)", PlayerName(playerid));
        case 2: SendLanguageMessageToAllEx(0x0099CCFF, "%s has left the server! (Kicked/Banned)", PlayerName(playerid), "%s hat den Server verlassen! (Kicked/Banned)", PlayerName(playerid));
    }
	#if defined TEXT_DRAW_IN_USE
	TextDrawHideForPlayer(playerid, box);
	#endif
    /*****SAVE*****/
    if (logged[playerid] == 1) {
		dini_IntSet(PlayerName(playerid), "money", GetPlayerMoney(playerid));
		dini_IntSet(PlayerName(playerid), "admin", adminlevel[playerid]);
		dini_IntSet(PlayerName(playerid), "vip", vip[playerid]);
		dini_IntSet(PlayerName(playerid), "kills", Kills[playerid]);
		dini_IntSet(PlayerName(playerid), "deaths", Deaths[playerid]);
		logged[playerid] = 0;
	}
	return 1;
}
//=====PLAYERCLASSES============================================================
public OnPlayerRequestClass(playerid, classid)
{
		SetPlayerPosEx(playerid, -259.982910, 1832.734130, 83.771926, 126.865623);
		SetPlayerCameraPos(playerid, -262.654174, 1830.988574, 83.675837);
		SetPlayerCameraLookAt(playerid, -259.982910, 1832.734130, 83.771926);
		PlayerPlaySound(playerid, 1097, 0.0, 0.0, 0.0);
    	LanguageGameText(playerid, "~b~Rafelder's ~g~Megajump~n~~y~V.4.1", "~b~Rafelder's ~g~Megajump~n~~y~V.4.1", 5000, 3);
		return 1;
}
//=====PLAYERS==================================================================
public OnPlayerRequestSpawn(playerid) return 1;

public OnPlayerSpawn(playerid)
{
	new skin = GetPlayerSkin(playerid);
	if((skin == 29) || (skin == 12) || (skin == 21) || (skin == 233))
	{
		Skin[playerid]=GetPlayerSkin(playerid);
	}
	if(DM[playerid] == 0)
	{
		GameTextForPlayer(playerid, " ", 1, 3);
    	SetPlayerHealth(playerid, 9999);
	}
	PlayerPlaySound(playerid, 1186, 0.0, 0.0, 0.0);
	return 1;
}

public OnPlayerDeath(playerid, killerid, reason)
{
	LanguageGameText(playerid, "~y~Have a nice ~r~death", "~y~N' schoenen ~r~tod",  3000, 0);
	#if defined TEXT_DRAW_IN_USE
	SetPlayerCheckpoint(playerid, -188.880508, 1887.126098, 115.546958, 3.0);
	#endif
	if (DM[playerid] > 0)
	{
		if (killerid != INVALID_PLAYER_ID)
		{
			if (IsPlayerInInfoDMArea(playerid) && IsPlayerInInfoDMArea(killerid) && (DM[playerid] > 0) && (DM[killerid] > 0))
			{
			    Deaths[playerid]++;
			    Kills[killerid]++;
			}
			if (IsPlayerInInfoDMArea(playerid))
			{
			    SetSpawnInfo(playerid, GetPlayerTeam(playerid), SKIN_DM_INFO, DM_INFO_COORDS, 25, 30, 30, 200, 5, 1);
			}
		}
		else
		{
		    if (IsPlayerInInfoDMArea(playerid))
		    {
			    Deaths[playerid]++;
			    SetSpawnInfo(playerid, GetPlayerTeam(playerid), SKIN_DM_INFO, DM_INFO_COORDS, 25, 30, 30, 200, 5, 1);
			}
		}
	}
	else
	{
		DM[playerid]=0;
		if (Ramp[playerid] == 0) SetSpawnInfo(playerid, 0, GetPlayerSkin(playerid), -183.961074, 1894.715454, 115.223503, 178.397781, 0, 0, 0, 0, 0, 0);
		if (Ramp[playerid] != 0) SetSpawnInfo(playerid, 0, GetPlayerSkin(playerid), gBackCoords[Ramp[playerid]-1][0], gBackCoords[Ramp[playerid]-1][1], gBackCoords[Ramp[playerid]-1][2], gBackCoords[Ramp[playerid]-1][3], 0, 0, 0, 0, 0, 0);
	}
	return 1;
}
//=====VEHICLES=================================================================
public OnVehicleSpawn(vehicleid)
{
    SetVehicleNumberPlate(vehicleid, "Megajump");
    if (newspawned[vehicleid] == 2) {
		newspawned[vehicleid]--;
		return 1;
	}
	if (newspawned[vehicleid] == 1) {
	    SetVehiclePos(vehicleid, 10000, 10000, 10000);
		//DestroyVehicle(vehicleid);
		//newspawned[vehicleid]=2;
		return 1;
	}
	/*if (newspawned[vehicleid] == 0) {
		newspawned[vehicleid]--;
		return 1;
	}
	if (newspawned[vehicleid] == -1) {
		DestroyVehicle(vehicleid);
		newspawned[vehicleid]=2;
		return 1;
	}*/
	return 1;
}

public OnVehicleDeath(vehicleid, killerid) return 1;
public OnPlayerEnterVehicle(playerid, vehicleid, ispassenger) return 1;
public OnPlayerExitVehicle(playerid, vehicleid) return 1;

public OnPlayerStateChange(playerid, newstate, oldstate)
{
	/*****NITRO+GODMODE*****/
	AddVehicleComponent(GetPlayerVehicleID(playerid), 1010);
  	SetVehicleHealth(GetPlayerVehicleID(playerid), 9999999.9);
	return 1;
}
//=====CMDS+TEXT================================================================
public OnPlayerText(playerid, text[])
{
	/*****MUTED*****/
    if(muted[playerid] == 1)
	{
		SendLanguageMessage(playerid, COLOR_RED, "Chat is currently disabled for you because you're muted.", "Der Chat ist f�r dich zur Zeit deaktiviert, weil du gemuted bist.");
		return 0;
	}
	
	DisableBadword("Fuck");
	DisableBadword("Bitch");
	DisableBadword("Asshole");
	DisableBadword("Ass");
	//DisableBadWord(" ");
	return 1;
}

public OnPlayerCommandText(playerid, cmdtext[])
{
    new cmd[256], idx;
	cmd = strtok(cmdtext, idx);
	/*****MUTED*****/
	if (muted[playerid] == 1)
	{
		SendLanguageMessage(playerid, COLOR_RED, "Commands is currently disabled for you because you're muted.", "Die Commands sind f�r dich zur Zeit deaktiviert, weil du gemuted bist.");
		return 1;
	}
	
	dcmd(setlanguage, 11, cmdtext);
	
	/*****INFOCOMMANDS*****/
	if (!strcmp("/help", cmdtext, true))
	{
		SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Welcome to Rafelder's Megajump!", "Willkommen auf Rafelder's Megajump");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "This is a Funserver not a Deathmatchserver!", "Dies ist ein Funserver, nicht ein Deathmatchserver!");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "On this server you can drive many ramps, check it out with /jumps", "Auf diesem Server kannst du viele Rampen fahren: /jumps");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /commands to see the commands.", "Tippe /commands um die Befehle zu sehen.");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}
 	
	if (!strcmp("/commands", cmdtext, true))
	{
		SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		SendLanguageMessage(playerid, COLOR_YELLOW, "Change one of the three categories:", "W�hle eine der drei Kategorien:");
		SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /pcommands to see the 'player' commands", "Tippe /pcommands um die 'Player' Befehle zu sehen");
		SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /vcommands to see the 'vehicle' commands", "Tippe /vcommands um die 'Vehicle' Befehle zu sehen");
		SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /dmcommands to see the 'DM' commands", "Tippe /dmcommands um die 'DM' Befehle zu sehen");
		SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /rcommands to see the rest of commands", "Tippe /rcommands um die 'Restlichen' Befehle zu sehen");
		SendLanguageMessage(playerid, COLOR_YELLOW, "Important commands:", "Wichtige Befehle:");
		SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /jumps to see the available ramps", "Tippe /jumps um die verf�gbaren Rampen zu sehen");
		SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /back to teleport yourself to the start of your ramp", "Tippe /back um dich zum Start deiner Rampe zu teleportieren");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}
 	
 	if (!strcmp("/vcommands", cmdtext, true))
 	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /car, /quad, /bike or /bmx to get a vehicle!", "Tippe /car, /quad, /bike oder /bmx um ein Fahrzeug zu bekommen!");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /carcolor to see the available carcolors!", "Tippe /carcolor um die verf�gbaren Fahrzeugfarben zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /color <color> to change your carcolor!", "Tippe /color <Farbe> um deine Fahrzeugfarbe zu wechseln");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /back to teleport yourself to the start of your ramp!", "Tippe /back um dich zum Start deiner Rampe zu teleportieren");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}
 	
 	if (!strcmp("/pcommands", cmdtext, true))
  	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /back to teleport yourself to the start of your ramp!", "Tippe /back um dich zum Start deiner Rampe zu teleportieren");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /level to see your stuntlevel", "Tippe /level um dein Stuntlevel zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /stats to see your Ramp Stats", "Tippe /stats um deine Rampen Statistik zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /para(chute) to get a parachute", "Tippe /para(chute) um einen Fallschirm zu bekommen");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}

 	if (!strcmp("/dmcommands", cmdtext, true))
  	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /dm [DM type] to join a dm!", "Tippe /dm [DM Typ] um einem Deathmatch beizutreten!");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /dmstats to see your stats!", "Tippe /dmstats um deine Statistik zu sehen!");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /exitdm to leave the deathmatch1", "Tippe /exitdm um das Deathmatch zu verlassen!");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}
 	
	if (!strcmp("/rcommands", cmdtext, true))
 	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /jumps to see the available ramps", "Tippe /jumps um die verf�gbaren Rampen zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /admins to see the online admins", "Tippe /admins um die verf�gbaren Admins zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /vips to see the online V.I.P.s", "Tippe /vips um die verf�gbaren V.I.P.s zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /update to see the update", "Tippe /update um das neuste Update zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Profil commands:", "Profil Befehle:");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /setpass <old password> <new password> to change your password!", "Tippe /setpass <altes passwort> <neues passwort> um dein Passwort zu �ndern!");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /changeaccountname <new name> to change your account name (Loginname)", "Tippe /changeaccountname <neuer name> um deinen Accountnamen zu �ndern (Loginname)");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}

 	if (!strcmp("/update", cmdtext, true))
	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "New Maps: DM Infocentre Map", "Neue Rampen/DM: DM Infocenter Map");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "New Commands: /dm [DM type], /dmstats, /dmexit", "Neue Commands: /dm [DM Typ], /dmstats, /dmexit");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "New Cars: ---", "Neue Fahrzeuge: ---");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "New Systems: -Deathmatch system", "Neue Systeme: Deathmatch System");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Rafelder's Megajump", "Rafelder's Megajump");
		new day, month, year, string0[50], string1[50];
		getdate(year, month, day);
		format(string0, sizeof(string0), "Date: %d.%d.%d", day, month, year);
		format(string1, sizeof(string1), "Datum: %d.%d.%d", day, month, year);
	 	SendLanguageMessage(playerid, COLOR_RED, string0, string1);
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}
 	
 	if (!strcmp("/stats", cmdtext, true))
 	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessageEx(playerid, COLOR_YELLOW, "Ramp Stats:  (Your (last) Ramp: %s)", TurnIntoString(Ramp[playerid]), "Rampen Statistik:  (Deine (letzte) Rampe: %s)", TurnIntoString(Ramp[playerid]));
	 	SendClientMessage(playerid, COLOR_YELLOW, "1 = Chilian, 2 = Desertramp, 3 = Vinewood, 4 = X-treme, 5 = Channel, 6 = Golden Gate, 7 = Loop,");
	 	SendClientMessage(playerid, COLOR_YELLOW, "8 = SA Ride, 9 = Loop2, 10 = Forestjump, 11 = SF Ride, 12 = Underwater, 13 = Wallride,");
	 	SendClientMessage(playerid, COLOR_YELLOW, "14 = X-Down, 15 = Forestride, 16 = Smallway, 17 = Removed, 18 = Halfpipe, 19 = LittleLV,");
	 	SendClientMessage(playerid, COLOR_YELLOW, "20 = Removed, 21 = Removed, 22 = SF Ride2, 23 = X-Loop, 24 = LittleLV2, 25 = LittleLS,");
	 	SendClientMessage(playerid, COLOR_YELLOW, "26 = SF Live, 27 = SA Ride3, 28 = LittleLV3, 29 = X-Down3, 30 = Removed, 31 = X-SF,");
	 	SendClientMessage(playerid, COLOR_YELLOW, " 32 = SA Ride2, 33 = LittleSA, 34 = Paraplatform, 35 = Dam1, 36 = Dam2, 37 = 2Loops,");
	 	SendClientMessage(playerid, COLOR_YELLOW, "38 = LittleSA2, 39 = X-Channel, 40 = X-Down2, 41 =Ski, 42 = LS Ride, 43 = LS Beach...");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}
 	
 	if (!strcmp("/level", cmdtext, true))
 	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessageEx(playerid, COLOR_YELLOW, "Level Stats:  (Your Level: %s)", TurnIntoString(GetPlayerWantedLevel(playerid)), "Level Statistik:  (Dein Level: %s)", TurnIntoString(plevel[playerid]));
	 	SendClientMessage(playerid, COLOR_YELLOW, "[Level 0: (0$/sec)   $0 - $4.999]");
	 	SendClientMessage(playerid, COLOR_YELLOW, "[Level 1: (10$/sec)  $5.000 - $19.999]");
	 	SendClientMessage(playerid, COLOR_YELLOW, "[Level 2: (20$/sec)  $20.000 - $49.999]");
	 	SendClientMessage(playerid, COLOR_YELLOW, "[Level 3: (30$/sec)  $50.000 - $99.999]");
	 	SendClientMessage(playerid, COLOR_YELLOW, "[Level 4: (40$/sec)  $100.000 - $499.999]");
	 	SendClientMessage(playerid, COLOR_YELLOW, "[Level 5: (50$/sec)  $500.000 - $999.999]");
	 	SendClientMessage(playerid, COLOR_YELLOW, "[Level 6: (100$/sec) $1.000.000 - $9.999.999]    [Level 7: (V.I.P) $10.000.000++]");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}

 	if (!strcmp("/carcolor", cmdtext, true))
 	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Vehicle colors:", "Fahrzeug Farben:");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /color <color>", "Tippe /color <farbe>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Colors: random, yellow, pink, red, green, blue, darkblue, brown, white, black", "Farben: random, yellow, pink, red, green, blue, darkblue, brown, white, black");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}
 	

 	if(!strcmp(cmdtext, "/info", true))
	{
		#if defined TEXT_DRAW_IN_USE
		if(IsPlayerInCheckpoint(playerid)) {
			TogglePlayerControllable(playerid, 0);
			ClearGameTextForPlayer(playerid);
			TextDrawShowForPlayer(playerid, info);
			TextDrawShowForPlayer(playerid, info2);
			SetTimerEx("Inforeset", 15000, 0, "%d%f", playerid, 500);
			return 1;
		}
		#else
		SendLanguageMessage(playerid, COLOR_RED, "This function isn't available at the moment!", "Diese Funktion ist zur Zeit nicht verf�gbar!");
		return 1;
		#endif
	}
	
	if(!strcmp(cmd, "/dm", true))
	{
		new dm[75];
		dm = strtok(cmdtext, idx);
	    if (!strlen(dm))
		{
			SendLanguageMessage(playerid, COLOR_YELLOW, "[USAGE]: '/dm [DM type]", "[BENUTZE]: '/dm [DM Typ]");
			SendLanguageMessage(playerid, COLOR_YELLOW, "Available DM types: 'Infocentre'", "Verf�gbare DM Typen: 'Infocenter'");
			return 1;
		}
		if(!strcmp(dm, "infocentre", true) || !strcmp(dm, "infocenter", true)) DM[playerid]=1, SetSpawnInfo(playerid, random(10000), SKIN_DM_INFO, DM_INFO_COORDS, 25, 30, 30, 200, 5, 1), SpawnPlayer(playerid), SetPlayerHealth(playerid, 100);
	    else
	    {
	        SendLanguageMessage(playerid, COLOR_YELLOW, "[USAGE]: '/dm [DM type]", "[BENUTZE]: '/dm [DM Typ]");
			SendLanguageMessage(playerid, COLOR_YELLOW, "Available DM types: 'Infocentre'", "Verf�gbare DM Typen: 'Infocenter'");
		}
		return 1;
	}
	
	if(!strcmp(cmd, "/dmstats", true))
	{
	    SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessageEx(playerid, COLOR_YELLOW, "DM stats of %s", PlayerName(playerid), "DM Statistik von %s", PlayerName(playerid));
	 	SendLanguageMessageEx(playerid, COLOR_YELLOW, "Kills: %s", TurnIntoString(Kills[playerid]), "Kills: %s", TurnIntoString(Kills[playerid]));
	 	SendLanguageMessageEx(playerid, COLOR_YELLOW, "Deaths: %s", TurnIntoString(Deaths[playerid]), "Deaths: %s", TurnIntoString(Deaths[playerid]));
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
	}
	
	if(!strcmp(cmd, "/exitdm", true))
	{
	    if(DM[playerid] == 0)
	    {
	        SendLanguageMessage(playerid, COLOR_RED, "You aren't in a dm!", "Du bist in keinem Deathmatch!");
	        return 1;
		}
		SetSpawnInfo(playerid, 0, Skin[playerid], -183.961074, 1894.715454, 115.223503, 178.397781, 0, 0, 0, 0, 0, 0);
		SpawnPlayer(playerid);
		DM[playerid]=0;
		SetPlayerHealth(playerid, 10000);
		return 1;
	}
	/*****REGISTER+LOGIN*****/
	if(!strcmp(cmd, "/login", true))
	{
		if (logged[playerid] == 1)
		{
			SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: You're already logged in!", "[ERROR]: Du bist schon eingeloggt!");
			return 1;
		}
		if (!dini_Exists(PlayerName(playerid)))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: Your account doesn't exist!", "[ERROR]: Dein Account existiert nicht!");
			return 1;
		}
		new dir[256];
		dir = strtok(cmdtext, idx);
		if (!strlen(dir))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: '/login password'", "[BENUTZE]: '/login password'");
			return 1;
		}
		if (strcmp(dir, dini_Get(PlayerName(playerid), "password"), true))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: Wrong password!", "[ERROR]: Falsches Passwort!");
			return 1;
		}
		logged[playerid] = 1;
		SendLanguageMessage(playerid, COLOR_YELLOW, "Sucessfully logged in!", "Erfolgreich eingeloggt!");
		adminlevel[playerid]=dini_Int(PlayerName(playerid), "admin");
		vip[playerid]=dini_Int(PlayerName(playerid), "vip");
		if (adminlevel[playerid] > 0)
		{
			SendLanguageMessageEx(playerid, COLOR_WHITE, "You are logged in as a Level %s admin!", TurnIntoString(adminlevel[playerid]), "Du wurdest als Level %s Admin eingeloggt!", TurnIntoString(adminlevel[playerid]));
			SetPlayerColor(playerid, 0xFF0000FF);
			new string0[256], string1[256];
			format(string0, sizeof(string0), "%s has logged in as a Level %d admin!",PlayerName(playerid), adminlevel[playerid]);
			format(string1, sizeof(string1), "%s hat sich als Level %d Admin eingeloggt!",PlayerName(playerid), adminlevel[playerid]);
			SendLanguageMessageToAll(COLOR_WHITE, string0, string1);
		}
		if(vip[playerid] == 1)
		{
			SendLanguageMessageToAllEx(COLOR_YELLOW, "***%s has logged in as a V.I.P.***", PlayerName(playerid), "***%s hat sich als V.I.P. eingeloggt***", PlayerName(playerid));
		}
		GivePlayerMoney(playerid, dini_Int(PlayerName(playerid), "money"));
		Kills[playerid] = dini_Int(PlayerName(playerid), "kills");
		Deaths[playerid] = dini_Int(PlayerName(playerid), "deaths");
		return 1;
	}

	if (!strcmp(cmd, "/register", true))
	{
		if (logged[playerid] == 1)
		{
			SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: You're already logged in!", "[ERROR]: Du bist schon eingeloggt!");
			return 1;
		}
		if (dini_Exists(PlayerName(playerid)))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: Your account already exists!", "[ERROR]: Dein Account existiert bereits!");
			return 1;
		}
		new dir[256];
		dir = strtok(cmdtext, idx);
		if (!strlen(dir))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: '/register password'", "[BENUTZE]: '/register password'");
			return 1;
		}
		new fname[MAX_STRING];
		format(fname,sizeof(fname),"%s", PlayerName(playerid));
		dini_Create(fname);
		dini_Set(PlayerName(playerid), "password", dir);
		dini_IntSet(PlayerName(playerid), "admin", 0);
		dini_IntSet(PlayerName(playerid), "vip", 0);
		SendLanguageMessage(playerid, COLOR_YELLOW, "Sucessfully registed! Please log in with /login <password>!", "Erfolgreich registriert! Bitte loggt dich mit /login <password> ein");
		return 1;
	}
	
	if (!strcmp(cmd, "/changeaccountname", true))
	{
		if (logged[playerid] == 0)
		{
			SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: You have to be logged in the change you account name", "[ERROR]: Du musst eingeloggt sein um deinen Accountnamen zu �ndern!");
			return 1;
		}
		new newname[256];
		newname = strtok(cmdtext, idx);
		if (!strlen(newname))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: '/changeaccountname <new account name>'", "[BENUTZE]: '/changeaccountname <neuer Accountname>'");
			return 1;
		}
		if (strlen(newname) > MAX_PLAYER_NAME)
		{
			SendLanguageMessageEx(playerid, COLOR_RED, "[ERROR]: You can't take a name with more than %s characters!", TurnIntoString(MAX_PLAYER_NAME), "[ERROR]: Du kannst keinen Namen mit mehr als %s Buchstaben w�hlen!", TurnIntoString(MAX_PLAYER_NAME));
			return 1;
		}
		if (dini_Exists(newname))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: This account already exists!", "[ERROR]: Dieser Account besteht bereits!");
			return 1;
		}
		fcopy(PlayerName(playerid), newname);
		dini_Remove(PlayerName(playerid));
		SetPlayerName(playerid, newname);
		SendLanguageMessageEx(playerid, COLOR_YELLOW, "Account sucessful changed to %s!", newname, "Dein Accountname w�rde zu %s gewechselt!", newname);
		return 1;
	}
	
	
	
	if (!strcmp(cmd, "/setpass", true))
	{
		if (logged[playerid] == 0)
		{
			SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: You have to be logged in the change the password", "[ERROR]: Du musst eingeloggt sein um dein Passwort zu �ndern!");
			return 1;
		}
		new passwort[256];
		passwort = strtok(cmdtext, idx);
		if (!strlen(passwort))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: '/setpass <old password> <new password>'", "[BENUTZE]: '/setpass <altes passwort> <neues passwort>'");
			return 1;
		}
		if (strcmp(passwort, dini_Get(PlayerName(playerid), "password"), true))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: Wrong old password!", "[ERROR]: Falsches altes Passwort!");
			return 1;
		}
		new passwortneu[256];
		passwortneu = strtok(cmdtext, idx);
		if (!strlen(passwortneu))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: '/setpass <old password> <new password>'", "[BENUTZE]: '/setpass <altes passwort> <neues passwort>'");
			return 1;
		}
		dini_Set(PlayerName(playerid), "password", passwortneu);
		SendLanguageMessageEx(playerid, COLOR_RED, "Your password has been changed to \"%s\".", passwortneu, "Dein Passwort wurde in \"%s\" ge�ndert.", passwortneu);
		return 1;
	}
	
 	/*****IMPORTANTCOMMANDS*****/
	if (!strcmp("/kill", cmdtext, true)) return SetPlayerHealth(playerid, 0);
	if (!strcmp(cmdtext, "/parachute", true) || !strcmp(cmdtext, "/para", true)) return GivePlayerWeapon(playerid, 46, 1);
	
	if (!strcmp(cmd, "/admins", true))
	{
	    new string[128];
	    SendLanguageMessage(playerid, COLOR_BLUE, "Online Admins:", "Verf�gbare Admins:");
	    for(new a=0; a<MAX_PLAYERS; a++) {
		    if(IsPlayerConnected(a) && IsPlayerAdminLevel(a, 1)) {
				format(string, 256,"(%i) %s (Level %d)", a, PlayerName(a), adminlevel[a]);
				SendClientMessage(playerid, COLOR_YELLOW, string);
	 		}
 		}
    	return 1;
	}
	
	if (!strcmp(cmd, "/vips", true))
	{
	    new string[128];
	    SendLanguageMessage(playerid, COLOR_BLUE, "Online V.I.P.'s:", "Verf�gbare V.I.P.'s:");
	    for(new a=0; a<MAX_PLAYERS; a++) {
		    if(IsPlayerConnected(a) && vip[a] == 1) {
				format(string, 256,"(%i) %s (V.I.P.)", a, PlayerName(a));
				SendClientMessage(playerid, COLOR_YELLOW, string);
	 		}
 		}
    	return 1;
	}
	
	dcmd(me, 2, cmdtext);
	/*****RAMPSINFO*****/
	if (!strcmp("/jumps", cmdtext, true))
	{
		SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "=>Please choose a jump group:", "Bitte w�hle eine Unterkategorie:");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "=>Tipe /ramps to see the 'normal' jumps", "Tippe /ramps um die 'normalen' Rampen zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "=>Tipe /little to see the 'little' jumps", "Tippe /little um die 'Little' Rampen zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "=>Tipe /funny to see the 'funny' jumps", "Tippe /funny um die 'Funny' Rampen zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "=>Tipe /stunt to see the 'stunt' jumps", "Tippe /stunt um die 'Stunt' Rampen zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "=>Tipe /x to see the 'X' jumps", "Tippe /x um die 'X' Rampen zu sehen");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /update to see the newest update!", "Tippe /upate um das neuste Upate zu sehen!");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}

 	if (!strcmp("/ramps", cmdtext, true))
	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Here you can see the 'normal' jumps:", "Hier kannst du die 'normalen' Rampen sehen:");
	 	SendClientMessage(playerid, COLOR_YELLOW, "/channel, /chilian, /dam1, /dam2, /desertramp, /forestjump, /forestride, /lsbeach,");
	 	SendClientMessage(playerid, COLOR_YELLOW, "/lsride, /goldengate, /saride, /saride2, /saride3, /sfride, /sfride2, /sflive,");
	 	SendClientMessage(playerid, COLOR_YELLOW, "/smallway, /vinewood...");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /little, /funny, /stunt or /x to see the other jumps!", "Tippe /little, /funny, /stunt oder /x um die anderen Rampen zu sehen!");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}

 	if (!strcmp("/little", cmdtext, true))
	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Here you can see the 'little' jumps:", "Hier kannst du die 'Little' Rampen sehen:");
	 	SendClientMessage(playerid, COLOR_YELLOW, "/littleLV, /littleLV2, /littleLV3, /littleLS, /littleSA, /littleSA2...");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /ramps, /funny, /stunt or /x to see the other jumps!", "Tippe /ramps, /funny, /stunt oder /x um die anderen Rampen zu sehen!");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}

 	if (!strcmp("/funny", cmdtext, true))
	{
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Here you can see the 'funny' jumps:", "Hier kannst du die 'Funny' Rampen sehen:");
	 	SendClientMessage(playerid, COLOR_YELLOW, "/2loops, /loop, /loop2, /underwater, /wallride...");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /ramps, /little, /stunt or /x to see the other jumps!", "Tippe /ramps, /little, /stunt oder /x um die anderen Rampen zu sehen!");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}

	if (!strcmp("/stunt", cmdtext, true))
	{
		SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Here you can see the 'stunt' jumps:", "Hier kannst du die 'Stunt' Rampen sehen:");
	 	SendClientMessage(playerid, COLOR_YELLOW, "/halfpipe, /para-platform, /ski...");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /ramps, /little, /funny or /x to see the other jumps!", "Tippe /ramps, /little, /funny oder /x um die anderen Rampen zu sehen!");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}

    if (!strcmp("/x", cmdtext, true))
	{
	    SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Here you can see the 'X' jumps:", "Hier kannst du die 'X' Rampen sehen:");
	 	SendClientMessage(playerid, COLOR_YELLOW, "/x-channel, /x-down, /x-down2, /x-down3, /x-loop, /x-sf...");
	 	SendLanguageMessage(playerid, COLOR_YELLOW, "Tipe /ramps, /little, /funny or /stunt to see the other jumps!", "Tippe /ramps, /little, /funny oder /stunt um die anderen Rampen zu sehen!");
	 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
	 	return 1;
 	}
 	
 	/*****ADMINSCMDS*****/
 	if(!strcmp(cmdtext, "/ahelp", true))
 	{
	 	if (IsPlayerAdminLevel(playerid, 1))
	 	{
		 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		 	SendLanguageMessage(playerid, COLOR_YELLOW, "Admin commands:", "Admin Befehle:");
		 	SendClientMessage(playerid, COLOR_YELLOW, "Level 1: /goto /english /! /freeze /unfreeze");
		 	SendClientMessage(playerid, COLOR_YELLOW, "Level 2: /bring /akill /bus /cardel /clearchat /a /count /killcount [endless vehicle spawning]");
			SendClientMessage(playerid, COLOR_YELLOW, "Level 3: /kick /getcar /specplayer /specvehicle /specplayervehicle /specoff /mute /unmute");
			SendClientMessage(playerid, COLOR_YELLOW, "Level 4: /ban /crash /weather /time /givemoney");
		 	SendClientMessage(playerid, COLOR_YELLOW, "Level 5: /gmx /heli /setlevel /setvip /gravity");
		 	SendClientMessage(playerid, COLOR_RED, ">>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
		 	return 1;
	 	}
 	}
 	
 	//Level 1
	dcmd(goto, 4, cmdtext);
	dcmd(freeze, 6, cmdtext);
	dcmd(unfreeze, 8, cmdtext);
	
	if(!strcmp(cmdtext, "/english", true))
	{
	 	if (IsPlayerAdminLevel(playerid, 1))
	 	{
		 	LanguageGameTextForAll("~r~Please speak english or german!", "~r~Bitte schreibe deutsch oder english", 5000, 3);
		 	return 1;
	 	}
	 	SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 1!", "Du musst Admin Level 1 sein!");
		return 1;
 	}
 	
 	if(!strcmp(cmdtext, "/!", true))
 	{
	 	if (IsPlayerAdminLevel(playerid, 1))
	 	{
		 	LanguageGameTextForAll("~r~Don't hit!", "~r~Nicht schlagen!", 5000, 3);
	 		return 1;
	 	}
	 	SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 1!", "Du musst Admin Level 1 sein!");
		return 1;
 	}
 	//Level 2
	dcmd(bring, 5, cmdtext);
	dcmd(a, 1, cmdtext);
	dcmd(count, 5, cmdtext);
	
	if (!strcmp("/killcount", cmdtext, true))
	{
		if (IsPlayerAdminLevel(playerid, 2)) {
			if (seconds <= 0) {SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: No countdown available!", "[ERROR]: Es ist kein Countdown verf�gbar!"); return 1;}
			KillTimer(countdowntimer);
			LanguageGameTextForAll("~g~Countdown stopped!", "~g~Countdown gestoppt!", 2000, 3);
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 2!", "Du musst Admin Level 2 sein!");
		return 1;
	}
	
 	if (!strcmp(cmd, "/akill", true))
 	{
		if (IsPlayerAdminLevel(playerid, 2)) {
			new dir[256];
			dir = strtok(cmdtext, idx);
			if (!strlen(dir))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /akill [playerid]", "[BENUTZE]: /akill [playerid]");
				return 1;
			}
			if (!IsPlayerConnected(strval(dir)))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: Not connected playerid!", "[ERROR]: Dieses playerid ist nicht verf�gbar!");
			 	return 1;
			}
			SetPlayerHealth(strval(dir), 0.0);
			new string0[60], string1[60];
			format(string0, sizeof(string0), "%s killed %s.", PlayerName(playerid), PlayerName(strval(dir)));
			format(string1, sizeof(string1), "%s t�tete %s.", PlayerName(playerid), PlayerName(strval(dir)));
			SendLanguageMessageToAll(COLOR_ORANGE, string0, string1);
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 2!", "Du musst Admin Level 2 sein!");
		return 1;
	}
	
 	if (!strcmp("/bus", cmdtext, true))
 	{
	 	if (IsPlayerAdminLevel(playerid, 2))
	 	{
			new Float:x,Float:y,Float:z, Float:d;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, d);
			new car;
		 	car = CreateVehicle(437, x+2, y-2, z+2, d, carcolor, carcolor, Respawn_Delay);
			newspawned[car]=2;
		 	SetVehicleToRespawn(car);
		  	return 1;
	 	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 2!", "Du musst Admin Level 2 sein!");
		return 1;
 	}
 	
 	if (!strcmp("/cardel", cmdtext, true))
 	{
		if (IsPlayerAdminLevel(playerid, 2))
		{
		 	for(new i=0; i<MAX_PLAYERS; i++) {
				if (IsPlayerConnected(i)) {
				 	if (Ramp[i] == 0) SetPlayerPosEx(i, -183.961074, 1894.715454, 115.223503, 178.397781);
				   	if (Ramp[i] != 0) SetPlayerPosEx(i, gBackCoords[Ramp[i]-1][0], gBackCoords[Ramp[i]-1][1], gBackCoords[Ramp[i]-1][2], gBackCoords[Ramp[i]-1][3]);
				   	#if defined TEXT_DRAW_IN_USE
				 	SetPlayerCheckpoint(i, -188.880508, 1887.126098, 115.546958, 3);
				 	#endif
					TogglePlayerControllable(i, 0);
				 	GameTextForAll("~y~Car deleting!", 3000, 3);
					SetTimer("Cardel", 2000, 0);
		 		}
		 	}
	 	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 2!", "Du musst Admin Level 2 sein!");
		return 1;
	}
	
 	if (!strcmp("/clearchat", cmdtext, true))
 	{
		if (IsPlayerAdminLevel(playerid, 2))
		{
			for (new j = 1; j <= 40; j++) SendClientMessageToAll(0, "\n");
			SendLanguageMessageToAll(COLOR_BLUE, "Chat has been cleared by an admin!", "Der Chat wurde von einem Admin geleert!");
			for (new j = 1; j <=  9; j++) SendClientMessageToAll(0, "\n");
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 2!", "Du musst Admin Level 2 sein!");
		return 1;
	}
	
 	//Level 3
 	dcmd(getcar, 6, cmdtext);
	dcmd(mute,4, cmdtext);
	dcmd(unmute,6, cmdtext);
 	
 	if (!strcmp(cmd, "/kick", true))
	 {
		if (IsPlayerAdminLevel(playerid, 3))
		{
			new kickid[256];
			kickid = strtok(cmdtext, idx);
			if(!strlen(kickid))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /kick [playerid] [reason]", "[BENUTZE] /kick [playerid] [Grund]");
				return 1;
			}
			if (!IsPlayerConnected(strval(kickid)))
			{
				SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
				return 1;
			}
			new string0[256], string1[256];
			format(string0, sizeof(string0), "%s has been kicked by %s (%s)", PlayerName(strval(kickid)), PlayerName(playerid), cmdtext[7+strlen(kickid)]);
			format(string1, sizeof(string1), "%s wurde von %s gekickt (%s)", PlayerName(strval(kickid)), PlayerName(playerid), cmdtext[7+strlen(kickid)]);
			SendLanguageMessageToAll(COLOR_BLUE, string0, string1);
			Kick(strval(kickid));
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 3!", "Du musst Admin Level 3 sein!");
		return 1;
	}
	
 	if(!strcmp(cmd, "/specplayer", true))
 	{
 		if(IsPlayerAdminLevel(playerid, 3))
	 	{
		 	new specplayerid, tmp[256];
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /specplayer [playerid]", "[BENUTZE] /specplayer [playerid]");
				return 1;
			}
			specplayerid = strval(tmp);
			if(!IsPlayerConnected(specplayerid))
			{
				SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
				return 1;
			}
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectatePlayer(playerid, specplayerid);
			SetPlayerInterior(playerid,GetPlayerInterior(specplayerid));
			gSpectateID[playerid] = specplayerid;
			gSpectateType[playerid] = ADMIN_SPEC_TYPE_PLAYER;
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 3!", "Du musst Admin Level 3 sein!");
		return 1;
	}

 	if(!strcmp(cmd, "/specvehicle", true))
	{
	 	if(IsPlayerAdminLevel(playerid, 3))
 		{
		 	new specvehicleid;
		  	new tmp[256];
			tmp = strtok(cmdtext, idx);
			if(!strlen(tmp))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /specvehicle [vehicleid]", "[BENUTZE] /specvehicle [vehicleid]");
				return 1;
			}
			specvehicleid = strval(tmp);
			if(specvehicleid < MAX_VEHICLES)
			{
				TogglePlayerSpectating(playerid, 1);
				PlayerSpectateVehicle(playerid, specvehicleid);
				gSpectateID[playerid] = specvehicleid;
				gSpectateType[playerid] = ADMIN_SPEC_TYPE_VEHICLE;
			}
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 3!", "Du musst Admin Level 3 sein!");
		return 1;
	}
	
	if(!strcmp(cmd, "/specplayervehicle", true))
	{
	 	if(IsPlayerAdminLevel(playerid, 3))
 		{
		  	new specid[256];
			specid = strtok(cmdtext, idx);
			if(!strlen(specid))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /specplayervehicle [playerid]", "[BENUTZE] /specplayervehicle [playerid]");
				return 1;
			}
			new specplayer = strval(specid);
			if(!IsPlayerConnected(specplayer))
			{
			 	SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
		 		return 1;
		 	}
			if(!IsPlayerInAnyVehicle(specplayer))
			{
				SendLanguageMessage(playerid, COLOR_RED, "The player doesn't sit in a vehicle!", "Diese playerid sitzt nicht in einem Fahrzeug!");
				return 1;
			}
			TogglePlayerSpectating(playerid, 1);
			PlayerSpectateVehicle(playerid, GetPlayerVehicleID(specplayer));
			gSpectateID[playerid] = GetPlayerVehicleID(specplayer);
			gSpectateType[playerid] = ADMIN_SPEC_TYPE_VEHICLE;
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 3!", "Du musst Admin Level 3 sein!");
		return 1;
	}

 	if(!strcmp(cmd, "/specoff", true))
	{
	 	if(IsPlayerAdminLevel(playerid, 3))
		{
			TogglePlayerSpectating(playerid, 0);
			gSpectateID[playerid] = INVALID_PLAYER_ID;
			gSpectateType[playerid] = ADMIN_SPEC_TYPE_NONE;
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 3!", "Du musst Admin Level 3 sein!");
		return 1;
	}
	
 	//Level 4
 	if (!strcmp(cmd, "/ban", true))
 	{
		if (IsPlayerAdminLevel(playerid, 4))
		{
			new kickid[256];
			kickid = strtok(cmdtext, idx);
			if(!strlen(kickid))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /ban [playerid] [reason]", "[BENUTZE]: /ban [playerid] [Grund]");
				return 1;
			}
			if (!IsPlayerConnected(strval(kickid)))
			{
			 	SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
		 		return 1;
		 	}
			new string0[256], string1[256];
			format(string0, sizeof(string0), "%s has been banned by %s (%s)", PlayerName(strval(kickid)), PlayerName(playerid), cmdtext[6+strlen(kickid)]);
			format(string1, sizeof(string1), "%s wurde von %s gebannt (%s)", PlayerName(strval(kickid)), PlayerName(playerid), cmdtext[6+strlen(kickid)]);
			SendLanguageMessageToAll(COLOR_BLUE, string0, string1);
			Ban(strval(kickid));
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 4!", "Du musst Admin Level 4 sein!");
		return 1;
	}
	
	if (!strcmp(cmd, "/time", true))
	{
		if (IsPlayerAdminLevel(playerid, 4))
		{
			new timeida[256];
			timeida = strtok(cmdtext, idx);
			if(!strlen(timeida))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /time [0-23]", "[BENUTZE]: /time [0-23]");
				return 1;
			}
			if(strval(timeida) < 24 && strval(timeida) > -1) return SetWorldTime(strval(timeida));
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /time [0-23]", "[BENUTZE]: /time [0-23]");
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 4!", "Du musst Admin Level 4 sein!");
		return 1;
	}
	
	if (!strcmp(cmd, "/weather", true))
	{
		if (IsPlayerAdminLevel(playerid, 4))
		{
			new weatherida[256];
			weatherida = strtok(cmdtext, idx);
			if (!strlen(weatherida))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /weather [0-45]", "[BENUTZE]: /weather [0-45]");
				return 1;
			}
			if (strval(weatherida) < 46 && strval(weatherida) > -1) return SetWeather(strval(weatherida));
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /weather [0-45]", "[BENUTZE]: /weather [0-45]");
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 4!", "Du musst Admin Level 4 sein!");
		return 1;
	}

	if (!strcmp(cmd, "/crash", true))
	{
		if (IsPlayerAdminLevel(playerid, 4))
		{
			new crashida[256];
			crashida = strtok(cmdtext, idx);
			if (!strlen(crashida))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /crash [playerid]", "[BENUTZE]: /crash [playerid]");
				return 1;
			}
			if (!IsPlayerConnected(strval(crashida)))
			{
			 	SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
				return 1;
		 	}
			new ob;
			ob = CreatePlayerObject(strval(crashida), 9999999999999, 0,0,0,0,0,0);
			DestroyPlayerObject(strval(crashida), ob);
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 4!", "Du musst Admin Level 4 sein!");
		return 1;
	}
	
	if (!strcmp(cmd, "/givemoney", true))
	{
		if (IsPlayerAdminLevel(playerid, 4))
		{
			new moneyid[256], money[256];
			moneyid = strtok(cmdtext, idx);
			money = strtok(cmdtext, idx);
			if (!strlen(moneyid) || !strlen(money))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /givemoney [playerid] [amount]", "[BENUTZE]: /givemoney [playerid] [Menge]");
				return 1;
			}
			if (!IsPlayerConnected(strval(moneyid)))
			{
 				SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
		 		return 1;
		 	}
			GivePlayerMoney(strval(moneyid), strval(money));
			new string0[256], string1[256];
			format(string0, 256, "You gave %s $%d.", PlayerName(strval(moneyid)), strval(money));
			format(string1, 256, "Du hast %s $%d gegeben.", PlayerName(strval(moneyid)), strval(money));
			SendLanguageMessage(playerid, COLOR_WHITE, string0, string1);
			format(string0, 256, "%s gave $%d to you.", PlayerName(playerid), strval(money));
			format(string1, 256, "%s hat dir $%d gegeben.", PlayerName(playerid), strval(money));
			SendLanguageMessage(strval(moneyid), COLOR_WHITE, string0, string1);
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 4!", "Du musst Admin Level 4 sein!");
		return 1;
	}
 	//Level 5
 	if (!strcmp(cmd, "/setlevel", true))
 	{
		if (IsPlayerAdminLevel(playerid, 5))
		{
			new levelid[256], glevel[256];
			levelid = strtok(cmdtext, idx);
			glevel = strtok(cmdtext, idx);
			if (!strlen(levelid) || !strlen(glevel))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /setlevel [playerid] [0-5]", "[BENUTZE]: /setlevel [playerid] [0-5]");
				return 1;
			}
			new glevel2 = strval(glevel);
			new levelid2 = strval(levelid);
			if (!IsPlayerConnected(levelid2))
			{
				SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
				return 1;
			}
			if (glevel2 > 5 || glevel2 < 0)
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /setlevel [playerid] [0-5]", "[BENUTZE]: /setlevel [playerid] [0-5]");
				return 1;
			}
			adminlevel[levelid2]=glevel2;
			new string0[256], string1[256];
			format(string0, sizeof(string0), "%s sets your admin level to %d.", PlayerName(playerid), glevel2);
			format(string1, sizeof(string1), "%s hat dein Adminlevel auf %d gesetzt.", PlayerName(playerid), glevel2);
			SendLanguageMessage(levelid2, COLOR_WHITE, string0, string1);
			format(string0, sizeof(string0), "You have set %s's admin level to %d.", PlayerName(levelid2), glevel2);
			format(string1, sizeof(string1), "Du hast %s's Admin Level auf %d gesetzt.", PlayerName(levelid2), glevel2);
			SendLanguageMessage(playerid, COLOR_WHITE, string0, string1);
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 5!", "Du musst Admin Level 5 sein!");
		return 1;
	}
	
	if (!strcmp(cmd, "/setvip", true))
	{
		if (IsPlayerAdminLevel(playerid, 5))
		{
			new vipid[256], vipmode[256];
			vipid = strtok(cmdtext, idx);
			vipmode = strtok(cmdtext, idx);
			if (!strlen(vipid))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /setvip [playerid] [vip]", "[BENUTZE]: /setvip [playerid] [vip]");
				return 1;
			}
			if (GetPlayerMoney(strval(vipid)) >= 10000000)
			{
				SendLanguageMessage(playerid, COLOR_RED, "[ERROR]: You can't use this command at this player", "[ERROR]: Du kannst diesen Befehl bei diesem Spieler nicht anwenden");
				return 1;
			}
			if (strval(vipmode) == 0)
			{
				SendLanguageMessageEx(playerid, COLOR_WHITE, "You took %s's V.I.P rights.", PlayerName(strval(vipid)), "Du hast %s V.I.P Rechte genommen.", PlayerName(strval(vipid)));
				SendLanguageMessageEx(strval(vipid), COLOR_WHITE, "%s took your V.I.P rights.", PlayerName(playerid), "%s hat dir V.I.P Rechte genommen.", PlayerName(playerid));
				vip[strval(vipid)]=0;
			}
			else if (strval(vipmode) == 1)
			{
				SendLanguageMessageEx(playerid, COLOR_WHITE, "You gave %s V.I.P rights.", PlayerName(strval(vipid)), "Du hast %s V.I.P Rechte gegeben.", PlayerName(strval(vipid)));
				SendLanguageMessageEx(strval(vipid), COLOR_WHITE, "%s gave you V.I.P rights.", PlayerName(playerid), "%s hat dir V.I.P Rechte gegeben.", PlayerName(playerid));
				vip[strval(vipid)]=1;
			} else SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /setvip [playerid] [0/1]", "[BENUTZE]: /setvip [playerid] [0/1]");
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 5!", "Du musst Admin Level 5 sein!");
		return 1;
	}
	
	if (!strcmp(cmd, "/gravity", true))
	{
		if (IsPlayerAdminLevel(playerid, 5))
		{
			new gravity[256];
			gravity = strtok(cmdtext, idx);
			if(!strlen(gravity))
			{
				SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /gravity [low/normal/high]", "[BENUTZE]: /gravity [low/normal/high]");
				return 1;
			}
			if (strcmp(gravity, "low", true) == 0) return SendRconCommand("gravity 0.002");
			if (strcmp(gravity, "normal", true) == 0) return SendRconCommand("gravity 0.008");
			if (strcmp(gravity, "high", true) == 0) return SendRconCommand("gravity 0.02");
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /gravity [low/normal/high]", "[BENUTZE]: /gravity [low/normal/high]");
			return 1;
		} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 5!", "Du musst Admin Level 5 sein!");
		return 1;
	}
	
	if (!strcmp("/heli", cmdtext, true))
	{
	 	if (IsPlayerAdminLevel(playerid, 5)) {
			new Float:x,Float:y,Float:z, Float:d;
			GetPlayerPos(playerid, x, y, z);
			GetPlayerFacingAngle(playerid, d);
			new car;
		 	car = CreateVehicle(487, x+2, y-2, z+2, d, carcolor, carcolor, Respawn_Delay*10);
			newspawned[car]=2;
		 	SetVehicleToRespawn(car);
		  	return 1;
	 	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 5!", "Du musst Admin Level 5 sein!");
		return 1;
 	}
	
 	if (!strcmp("/gmx", cmdtext, true))
	{
		if(IsPlayerAdminLevel(playerid, 5))
		{
			SendLanguageMessageToAll(COLOR_YELLOW, "An admin restarted the gamemode!", "Ein Admin hat den Gamemode neu gestartet!");
			new string[128];
			format(string, 128, "changemode %s", ModeName);
			SendRconCommand(string);
			return 1;
		}
		SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 5!", "Du musst Admin Level 5 sein!");
		return 1;
	}
 	/*****COLORS+VEHICLES*****/
 	if (strcmp(cmd, "/color", true) == 0) {
	 	if (!IsPlayerInAnyVehicle(playerid))
	 	{
		 	SendLanguageMessage(playerid, COLOR_RED, "You have to be in a car to change to color!", "Du musst im Fahrzeug sitzen um die Farbe �ndern zu k�nnen!");
		 	return 1;
	 	}
		if (GetPlayerState(playerid) != PLAYER_STATE_DRIVER)
		{
			SendLanguageMessage(playerid, COLOR_RED, "You have to be the driver to change the color!", "Du musst der Fahrer sein um die Farbe �ndern zu k�nnen!");
			return 1;
		}
		new color[256];
		color = strtok(cmdtext, idx);
		if (!strlen(color)) { SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /color <color> (Colors: /carcolor)!", "[BENUTZE]: /color <Farbe> (Farben: /carcolor)!"); return 1;}
		if (strcmp(color, "yellow", true) == 0) return ChangeVehicleColor(GetPlayerVehicleID(playerid), 6, 6);
	    if (strcmp(color, "red", true) == 0) return ChangeVehicleColor(GetPlayerVehicleID(playerid), 3, 3);
	    if (strcmp(color, "blue", true) == 0) return ChangeVehicleColor(GetPlayerVehicleID(playerid), 106, 106);
	    if (strcmp(color, "darkblue", true) == 0) return ChangeVehicleColor(GetPlayerVehicleID(playerid), 53, 53);
	    if (strcmp(color, "green", true) == 0) return ChangeVehicleColor(GetPlayerVehicleID(playerid), 86, 86);
	    if (strcmp(color, "brown", true) == 0) return ChangeVehicleColor(GetPlayerVehicleID(playerid), 61, 61);
	    if (strcmp(color, "white", true) == 0) return ChangeVehicleColor(GetPlayerVehicleID(playerid), 1, 1);
	    if (strcmp(color, "black", true) == 0) return ChangeVehicleColor(GetPlayerVehicleID(playerid), 0, 0);
	    if (strcmp(color, "pink", true) == 0) return ChangeVehicleColor(GetPlayerVehicleID(playerid), 126, 85);
	    if (strcmp(color, "random", true) == 0) return ChangeVehicleColor(GetPlayerVehicleID(playerid), random(126), random(126));
		SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /color <color> (Colors: /carcolor)!", "[BENUTZE]: /color <Farbe> (Farben: /carcolor)!");
		return 1;
	}
	
	if (!strcmp("/car", cmdtext, true))
	{
	 	new Float:x,Float:y,Float:z, Float:d;
		new car;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, d);
	 	if (IsPlayerAdminLevel(playerid, 2)) {
		 	car = CreateVehicle(411, x+2, y-2, z+2, d, carcolor, carcolor, Respawn_Delay);
			newspawned[car]=2;
		 	SetVehicleToRespawn(car);
		 	return 1;
	 	} else {
	 	    if (IsPlayerInInfoDMArea(playerid))
	 	    {
				 SendLanguageMessage(playerid, COLOR_RED, "You can't spawn vehicles in DM areas!", "Du kannste keine Fahrzeuge in DM Areas spawnen!");
				 return 1;
		 	}
		 	if (Ramp[playerid] == 0)
		 	{
				 SendLanguageMessage(playerid, COLOR_RED, "You have to be on a ramp to spawn a car!", "Du musst auf einer Rampe sein um ein Fahrzeug spawnen zu k�nnen!");
				 return 1;
		 	}
		 	if (hasspawned[playerid] == 1)
		 	{
				 SendLanguageMessage(playerid, COLOR_RED, "You have to wait 30 seconds to spawn a new vehicle!", "Du musst 30 Sekunden warten bis du wieder ein Fahrzeug spawnen kannst!");
				 return 1;
	 		}
			SetTimerEx("ResetVehicleSpawn", Wartezeit, 0, "%d", playerid);
		 	car = CreateVehicle(411, x+2, y-2, z+2, d, carcolor, carcolor, Respawn_Delay);
			newspawned[car]=2;
		 	SetVehicleToRespawn(car);
		 	hasspawned[playerid]=1;
		 	return 1;
	 	}
	}

 	if (!strcmp("/quad", cmdtext, true))
	{
	 	new Float:x,Float:y,Float:z, Float:d;
		new car;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, d);
	 	if (IsPlayerAdminLevel(playerid, 2)) {
		 	car = CreateVehicle(471, x+2, y-2, z+2, d, carcolor, carcolor, Respawn_Delay);
			newspawned[car]=2;
		 	SetVehicleToRespawn(car);
		 	return 1;
	 	} else {
	 	    if (IsPlayerInInfoDMArea(playerid))
	 	    {
				 SendLanguageMessage(playerid, COLOR_RED, "You can't spawn vehicles in DM areas!", "Du kannste keine Fahrzeuge in DM Areas spawnen!");
				 return 1;
		 	}
		 	if (Ramp[playerid] == 0)
		 	{
				 SendLanguageMessage(playerid, COLOR_RED, "You have to be on a ramp to spawn a car!", "Du musst auf einer Rampe sein um ein Fahrzeug spawnen zu k�nnen!");
				 return 1;
		 	}
		 	if (hasspawned[playerid] == 1)
		 	{
				 SendLanguageMessage(playerid, COLOR_RED, "You have to wait 30 seconds to spawn a new vehicle!", "Du musst 30 Sekunden warten bis du wieder ein Fahrzeug spawnen kannst!");
				 return 1;
	 		}
			SetTimerEx("ResetVehicleSpawn", Wartezeit, 0, "%d", playerid);
		 	car = CreateVehicle(411, x+2, y-2, z+2, d, carcolor, carcolor, Respawn_Delay);
			newspawned[car]=2;
		 	SetVehicleToRespawn(car);
		 	hasspawned[playerid]=1;
		 	return 1;
	 	}
	}

 	if (!strcmp("/bike", cmdtext, true))
	{
	 	new Float:x,Float:y,Float:z, Float:d;
		new car;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, d);
	 	if (IsPlayerAdminLevel(playerid, 2)) {
		 	car = CreateVehicle(522, x+2, y-2, z+2, d, carcolor, carcolor, Respawn_Delay);
			newspawned[car]=2;
		 	SetVehicleToRespawn(car);
		 	return 1;
	 	} else {
	 	    if (IsPlayerInInfoDMArea(playerid))
	 	    {
				 SendLanguageMessage(playerid, COLOR_RED, "You can't spawn vehicles in DM areas!", "Du kannste keine Fahrzeuge in DM Areas spawnen!");
				 return 1;
		 	}
		 	if (Ramp[playerid] == 0)
		 	{
				 SendLanguageMessage(playerid, COLOR_RED, "You have to be on a ramp to spawn a car!", "Du musst auf einer Rampe sein um ein Fahrzeug spawnen zu k�nnen!");
				 return 1;
		 	}
		 	if (hasspawned[playerid] == 1)
		 	{
				 SendLanguageMessage(playerid, COLOR_RED, "You have to wait 30 seconds to spawn a new vehicle!", "Du musst 30 Sekunden warten bis du wieder ein Fahrzeug spawnen kannst!");
				 return 1;
	 		}
			SetTimerEx("ResetVehicleSpawn", Wartezeit, 0, "%d", playerid);
		 	car = CreateVehicle(411, x+2, y-2, z+2, d, carcolor, carcolor, Respawn_Delay);
			newspawned[car]=2;
		 	SetVehicleToRespawn(car);
		 	hasspawned[playerid]=1;
		 	return 1;
	 	}
	}

 	if (!strcmp("/bmx", cmdtext, true))
	{
	 	new Float:x,Float:y,Float:z, Float:d;
		new car;
		GetPlayerPos(playerid, x, y, z);
		GetPlayerFacingAngle(playerid, d);
	 	if (IsPlayerAdminLevel(playerid, 2)) {
		 	car = CreateVehicle(481, x+2, y-2, z+2, d, carcolor, carcolor, Respawn_Delay);
			newspawned[car]=2;
		 	SetVehicleToRespawn(car);
		 	return 1;
	 	} else {
	 	    if (IsPlayerInInfoDMArea(playerid))
	 	    {
				 SendLanguageMessage(playerid, COLOR_RED, "You can't spawn vehicles in DM areas!", "Du kannste keine Fahrzeuge in DM Areas spawnen!");
				 return 1;
		 	}
		 	if (Ramp[playerid] == 0)
		 	{
				 SendLanguageMessage(playerid, COLOR_RED, "You have to be on a ramp to spawn a car!", "Du musst auf einer Rampe sein um ein Fahrzeug spawnen zu k�nnen!");
				 return 1;
		 	}
		 	if (hasspawned[playerid] == 1)
		 	{
				 SendLanguageMessage(playerid, COLOR_RED, "You have to wait 30 seconds to spawn a new vehicle!", "Du musst 30 Sekunden warten bis du wieder ein Fahrzeug spawnen kannst!");
				 return 1;
	 		}
			SetTimerEx("ResetVehicleSpawn", Wartezeit, 0, "%d", playerid);
		 	car = CreateVehicle(411, x+2, y-2, z+2, d, carcolor, carcolor, Respawn_Delay);
			newspawned[car]=2;
		 	SetVehicleToRespawn(car);
		 	hasspawned[playerid]=1;
		 	return 1;
	 	}
	}
	/*****TELEPORTCOMMANDS*****/
	if (strcmp("/lsbeach", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=43, SetPlayerPosEx(playerid, 369.821,-1428.698,179.095+high,180.0);
		return 1;
	}
    if (strcmp("/lsride", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=42, SetPlayerPosEx(playerid, 3143.612061, -173.949554, 267.527374+high,118.0);
		return 1;
	}
	if (strcmp("/ski", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=41, SetPlayerPosEx(playerid, -2253.509521, -1724.890137, 484.947144+high,228.0);
		return 1;
	}
	if (strcmp("/x-down2", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=40, SetPlayerPosEx(playerid, 2069.337891, -1303.622314, 586.842712+high,90.0);
		return 1;
	}
	if (strcmp("/x-channel", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=39, SetPlayerPosEx(playerid, 1384.927734, -1715.230957, 9.470692+high,264.0);
		return 1;
	}
	if (strcmp("/littlesa2", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=38, SetPlayerPosEx(playerid, 1922.866211, 138.889816, 265.612518+high,180.0);
		return 1;
	}
	if (strcmp("/2loops", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		SendClientMessage(playerid, COLOR_RED, "--Closed--"); /*Ramp[playerid]=37, SetPlayerPosEx(playerid, 3123.247070, -1191.759766, 182.748993+high,180.0);*/
		return 1;
	}
	if (strcmp("/dam2", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=36, SetPlayerPosEx(playerid, -1016.483093, 2519.276855, 286.444946+high,206.0);
		return 1;
	}
 	if (strcmp("/dam1", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=35, SetPlayerPosEx(playerid, -552.679382, 1807.092651, 147.634354+high,22.0);
		return 1;
	}
    if (strcmp("/para-platform", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=34, SetPlayerPosEx(playerid, 2471.928710, -1663.113891, 5215.367187+high,273.0), GivePlayerWeapon(playerid, 46, 1);
		return 1;
	}
 	if (strcmp("/littlesa", cmdtext, true) == 0)
 	{
	 	if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
	 	Ramp[playerid]=33, SetPlayerPosEx(playerid, 727.005676, -2215.074951, 233.355743+high,360.0);
	 	return 1;
 	}
	if (strcmp("/saride2", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=32, SetPlayerPosEx(playerid, 3265.1700000,-1081.8550000, 197.9340000+high, 98.00);
		return 1;
	}
	if (strcmp("/x-sf", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=31, SetPlayerPosEx(playerid, -1943.271606, 470.455505, 211.978119+high,180.0);
		return 1;
	}
	/*if (strcmp("/desertspeed", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=30, SetPlayerPosEx(playerid, 618.151, 2501.628, 206.168+high, 90.0);
		return 1;
	}*/
	if (strcmp("/x-down3", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=29, SetPlayerPosEx(playerid, -2259.150, 731.078, 479.650+high, 270.0);
		return 1;
	}
	if (strcmp("/littlelv3", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=28, SetPlayerPosEx(playerid, -668.759216, 2355.251953, 189.665283+high,253.0);
		return 1;
	}
	if (strcmp("/saride3", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=27, SetPlayerPosEx(playerid, 1540.361328, -1352.387207, 332.556702+high,0.0);
		return 1;
	}
    if (strcmp("/sflive", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=26 ,SetPlayerPosEx(playerid, -2148.347412, -545.241211, 196.401764+high,0.0);
		return 1;
	}
	if (strcmp("/littlels", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=25, SetPlayerPosEx(playerid, 1545.169555, -1328.539306, 236.092575+high,259.0);
		return 1;
	}
	if (strcmp("/littlelv2", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=24, SetPlayerPosEx(playerid, 2184.736816, 1040.577271, 81.367874+high,360.0);
		return 1;
	}
	if (strcmp("/x-loop", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=23, SetPlayerPosEx(playerid, -2155.638672, 918.232483, 93.463531+high,270.0);
		return 1;
	}
	if (strcmp("/sfride2", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=22, SetPlayerPosEx(playerid, -2473.942871, 3082.989014, 649.517334+high,180.0);
		return 1;
	}
	/*if (strcmp("/lowjumps", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=21, SetPlayerPosEx(playerid, 332.836609, -930.689270, 317.055756+high,345.0);
		return 1;
	}*/
	/*if (strcmp("/sfstreets", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=20, SetPlayerPosEx(playerid, -1791.552612, 577.828491, 237.495819+high,360.0);
		return 1;
	}*/
	if (strcmp("/littlelv", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=19, SetPlayerPosEx(playerid, 2716.520264, 716.215942, 226.285126+high,90.0);
		return 1;
	}
	if (strcmp("/halfpipe", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=18, SetPlayerPosEx(playerid, 586.350, 2504.710, 149.020+high, 90.0);
		return 1;
	}
    /*if (strcmp("/saride2", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=17, SetPlayerPosEx(playerid, 1135.043701, -1785.406006, 285.436310+high,360.0);
		return 1;
	}*/
	if (strcmp("/smallway", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=16, SetPlayerPosEx(playerid, 78.867798, 2158.427490, 296.021912+high,360.0);
		return 1;
	}
	if (strcmp("/forestride", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=15, SetPlayerPosEx(playerid, -2202.443848, -33.429607, 276.283539+high,270.0);
		return 1;
	}
	if (strcmp("/x-down", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=14, SetPlayerPosEx(playerid, 1946.938110, 1692.606567, 655.742676+high,180.0);
		return 1;
	}
	if (strcmp("/wallride", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=13, SetPlayerPosEx(playerid, 2835.338379, -1771.232544, 3210.975342+high,90.0);
		return 1;
	}
	if (strcmp("/underwater", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=12, SetPlayerPosEx(playerid, 3040.848389, -1780.456055, -55.172905+high,180.0);
		return 1;
	}
	if (strcmp("/sfride", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=11, SetPlayerPosEx(playerid, -2482.833984, 247.024094, 16.706623+high,270.0);
		return 1;
	}
	if (strcmp("/forestjump", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=10, SetPlayerPosEx(playerid, -427.153, -1046.698, 284.509+high, 327.0);
		return 1;
	}
	if (strcmp("/loop2", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		SendClientMessage(playerid, COLOR_RED, "--Closed--"); /*Ramp[playerid]=9, SetPlayerPosEx(playerid, 1241.652832, -1599.161865, 344.336456+high,360);*/
		return 1;
	}
	if (strcmp("/saride", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=8, SetPlayerPosEx(playerid, 837.579712, -2355.493408, 465.857880+high,360);
		return 1;
	}
	if (strcmp("/loop", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=7, SetPlayerPosEx(playerid, 70.462868, -900.975586, 449.237000+high,180);
		return 1;
	}
    if (strcmp("/goldengate", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=6, SetPlayerPosEx(playerid, -2682.302734, 2430.436768, 635.530151+high,180);
		return 1;
	}
	if (strcmp("/channel", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=5, SetPlayerPosEx(playerid, -367.164978, -1643.131592, 882.969849+high,44);
		return 1;
	}
	if (strcmp("/x-treme", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=4, SetPlayerPosEx(playerid, -353.977, 2705.229, 533.241+high+xtremehigh, 122.0);
		return 1;
	}
	if (strcmp("/vinewood", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=3, SetPlayerPosEx(playerid, 1410.401001, -153.236298, 705.473938+high,180);
		return 1;
	}
	if (strcmp("/desertramp", cmdtext, true) == 0)
	{
		if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=2, SetPlayerPosEx(playerid, -161.203430, 2310.889648, 716.849915+high+2,90);
		return 1;
	}
 	if (strcmp("/chilian", cmdtext, true) == 0)
 	{
	 	if (DM[playerid] > 0) { SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1; }
		Ramp[playerid]=1, SetPlayerPosEx(playerid, -2836.291016, -2833.197021, 1934.666992+high,338), LanguageGameText(playerid, "Tipe /up to spawn higher", "Tippe /up um hoeher zu spawnen", 3000, 3);
		return 1;
	}

	if (!strcmp("/up", cmdtext, true))
	{
		if (DM[playerid] > 0) {SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1;}
		if (Ramp[playerid] == 1) return SetCoordsPos(playerid, -2862.049560, -2965.827392, 2376.882080+high, 26.0);
		SendLanguageMessage(playerid, 0xFF6600FF, "You have to be on /chilian to use this command!", "Du musst auf /chilian sein um den Command nutzen zu k�nnen!");
		return 1;
	}

	if (!strcmp("/back", cmdtext, true))
	{
		if (DM[playerid] > 0) {SendLanguageMessage(playerid, COLOR_RED, "You have to leave the DM first ('/exitdm')!", "Du musst erst dein DM verlassen ('/exitdm')!"); return 1;}
		if (GetPlayerState(playerid) == PLAYER_STATE_DRIVER || GetPlayerState(playerid) == PLAYER_STATE_ONFOOT) return SetCoordsPos(playerid, gBackCoords[Ramp[playerid]-1][0], gBackCoords[Ramp[playerid]-1][1], gBackCoords[Ramp[playerid]-1][2], gBackCoords[Ramp[playerid]-1][3]);
		SendLanguageMessage(playerid, COLOR_RED, "You have to be the driver!", "Du musst der Fahrer sein!");
		return 1;
	}

	else SendLanguageMessageEx(playerid, COLOR_RED, "The command (%s) doesn't exist!", cmdtext, "Der Befehl (%s) existiert nicht!", cmdtext);
	return 1;
}

/*************************************DCMD*************************************/
//Admins
dcmd_a(playerid, cmdtext[])
{
	if (IsPlayerAdminLevel(playerid, 2)) {
		if(!strlen(cmdtext))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /a [text]", "[BENUTZE]: /a [Text]");
			return 1;
		}
		new string[256];
		format(string, 256, "~g~%s:~n~~y~%s", PlayerName(playerid), cmdtext);
		GameTextForAll(string, 7000, 3);
	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 2!", "Du musst Admin Level 2 sein!");
	return 1;
}
//===
dcmd_count(playerid,cmdtext[])
{
	if (IsPlayerAdminLevel(playerid, 2)) {
		seconds = strval(cmdtext);
		if (!strlen(cmdtext) || seconds < 1 || seconds > 50)
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /count [seconds (1-50)]", "[BENUTZE]: /count [Sekunden (1-50)]");
			return 1;
		}
		KillTimer(countdowntimer);
		countdowntimer = SetTimer("CountDown", 1000, 1);
		return 1;
	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 2!", "Du musst Admin Level 2 sein!");
	return 1;
}
//===
dcmd_freeze(playerid, params[])
{
	new endid = strval(params);
	if (IsPlayerAdminLevel(playerid, 1))
	{
		if(!strlen(params))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /freeze [playerid]", "[BENUTZE]: /freeze [playerid]");
			return 1;
		}
		if(!IsPlayerConnected(endid))
		{
			SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
			return 1;
		}
		TogglePlayerControllable(endid, 0);
		new string0[256], string1[256];
		format(string0, sizeof(string0),"%s has been frozen by %s!", PlayerName(endid), PlayerName(playerid));
		format(string1, sizeof(string1),"%s wurde von %s gefreezed!", PlayerName(endid), PlayerName(playerid));
		SendLanguageMessageToAll(COLOR_YELLOW, string0, string1);
		return 1;
	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 1!", "Du musst Admin Level 1 sein!");
	return 1;
}
//===
dcmd_unfreeze(playerid, params[])
{
	new endid = strval(params);
	if (IsPlayerAdminLevel(playerid, 1)){
		if(!strlen(params))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /unfreeze [playerid]", "[BENUTZE]: /unfreeze [playerid]");
		 	return 1;
	 	}
		if(!IsPlayerConnected(endid))
		{
			SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
			return 1;
		}
		TogglePlayerControllable(endid, 1);
		new string0[256], string1[256];
		format(string0, sizeof(string0),"%s has been unfrozen by %s!", PlayerName(endid), PlayerName(playerid));
		format(string1, sizeof(string1),"%s wurde von %s entfreezed!", PlayerName(endid), PlayerName(playerid));
		SendLanguageMessageToAll(COLOR_YELLOW, string0, string1);
		return 1;
	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 1!", "Du musst Admin Level 1 sein!");
	return 1;
}
//===
dcmd_getcar(playerid, params[])
{
	new string[256];
	new endid = strval(params);
	if (IsPlayerAdminLevel(playerid, 3))
	{
		if(!strlen(params))
		{
			SendLanguageMessage(playerid,COLOR_RED, "[USAGE]: /getcar [playerid]", "[BENUTZE]: /getcar [playerid]");
			return 1;
		}
		if(!IsPlayerConnected(endid))
		{
			SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
			return 1;
		}
		if(!IsPlayerInAnyVehicle(endid))
		{
			SendLanguageMessage(playerid, COLOR_RED, "The player doesn't sit in a vehicle!", "Der Spieler sitzt nicht in einem Fahrzeug!");
			return 1;
		}
		format(string, sizeof(string),"VehicleID (%s): %d", PlayerName(endid), GetPlayerVehicleID(endid));
		SendClientMessage(playerid, COLOR_YELLOW, string);
		return 1;
	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 3!", "Du musst Admin Level 3 sein!");
	return 1;
}
//===
dcmd_mute(playerid, params[])
{
	new endid = strval(params);
	if (IsPlayerAdminLevel(playerid, 3))
	{
		if(!strlen(params))
		{
			SendLanguageMessage(playerid,COLOR_RED, "[USAGE]: /mute [playerid]", "[BENUTZE]: /mute [playerid]");
			return 1;
		}
		if(!IsPlayerConnected(endid))
		{
			SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
			return 1;
		}
		muted[endid] =1;
		new string0[256], string1[256];
		format(string0, sizeof(string0),"%s has been muted by %s!", PlayerName(endid), PlayerName(playerid));
		format(string1, sizeof(string1),"%s wurde von %s gemuted!", PlayerName(endid), PlayerName(playerid));
		SendLanguageMessageToAll(COLOR_YELLOW, string0, string1);
		return 1;
	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 3!", "Du musst Admin Level 3 sein!");
	return 1;
}
//===
dcmd_unmute(playerid, params[])
{
	new endid = strval(params);
	if (IsPlayerAdminLevel(playerid, 3))
	{
		if(!strlen(params))
		{
			SendLanguageMessage(playerid,COLOR_RED, "[USAGE]: /unmute [playerid]", "[BENUTZE]: /unmute [playerid]");
			return 1;
		}
		if(!IsPlayerConnected(endid))
		{
			SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
			return 1;
		}
		muted[endid]=0;
		new string0[256], string1[256];
		format(string0, sizeof(string0),"%s has been unmuted by %s!", PlayerName(endid), PlayerName(playerid));
		format(string1, sizeof(string1),"%s wurde von %s entmuted!", PlayerName(endid), PlayerName(playerid));
		SendLanguageMessageToAll(COLOR_YELLOW, string0, string1);
		return 1;
	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 3!", "Du musst Admin Level 3 sein!");
	return 1;
}
//===
dcmd_bring(playerid, params[])
{
	if (IsPlayerAdminLevel(playerid, 2))
	{
		if (!strlen(params))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /bring [playerid]", "[BENUTZE]: /bring [playerid]");
			return 1;
		}
		if (!IsPlayerConnected(strval(params)))
		{
			SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
			return 1;
		}
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(playerid, X, Y, Z);
		GetXYInFrontOfPlayer(playerid, X, Y, 1.5);
		SetPlayerInterior(strval(params), GetPlayerInterior(strval(params)));
		SetPlayerPos(strval(params), X, Y, Z);
		Ramp[strval(params)]=Ramp[playerid];
		new string0[256], string1[256];
		format(string0, sizeof(string0), "You have brought %s (ID: %d) to you.", PlayerName(strval(params)), strval(params));
		format(string1, sizeof(string1), "Du hast %s (ID: %d) zu dir gebracht.", PlayerName(strval(params)), strval(params));
		SendLanguageMessage(playerid, COLOR_GREEN, string0, string1);
		return 1;
	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 2!", "Du musst Admin Level 2 sein!");
	return 1;
}
//=============================================================================
dcmd_goto(playerid, params[])
{
	if (IsPlayerAdminLevel(playerid, 1))
	{
		if (!strlen(params))
		{
			SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /goto [playerid]", "[BENUTZE]: /goto [playerid]");
			return 1;
		}
		if (!IsPlayerConnected(strval(params)))
		{
			SendLanguageMessage(playerid, COLOR_RED, "Not connected playerid!", "Diese playerid ist nicht verf�gbar!");
			return 1;
		}
		new Float:X, Float:Y, Float:Z;
		GetPlayerPos(strval(params), X, Y, Z);
		GetXYInFrontOfPlayer(strval(params), X, Y, 1.5);
		SetPlayerInterior(playerid, GetPlayerInterior(strval(params)));
		SetPlayerPos(playerid, X, Y, Z);
		Ramp[playerid]=Ramp[strval(params)];
		new string0[256], string1[256];
		format(string0, sizeof(string0), "You teleported yourself to %s (ID: %d).", PlayerName(strval(params)), strval(params));
		format(string1, sizeof(string1), "Du hast dich zu %s (ID: %d) teleportiert.", PlayerName(strval(params)), strval(params));
		SendLanguageMessage(playerid, COLOR_GREEN, string0, string1);
		return 1;
	} else SendLanguageMessage(playerid, COLOR_RED, "You have to be admin level 1!", "Du musst Admin Level 1 sein!");
	return 1;
}

//Players
dcmd_me(playerid, cmdtext[])
{
	if (!strlen(cmdtext))
	{
		SendLanguageMessage(playerid, COLOR_RED, "[USAGE]: /me [action]", "[BENUTZE]: /me [Action]");
		return 1;
	}
	new string[256];
	format(string, sizeof(string), "%s %s", PlayerName(playerid), cmdtext);
	SendClientMessageToAll(COLOR_BLUE, string);
	return 1;
}
//=====CHECKPOINTS==============================================================
public OnPlayerEnterCheckpoint(playerid) { LanguageGameText(playerid, "~y~Tipe ~g~/info ~y~to see the information about the server", "~y~Tippe ~g~/info ~y~ um die Information ueber den Server zu sehen", 5000, 3); return 1;}
public OnPlayerLeaveCheckpoint(playerid) return 1;
public OnPlayerEnterRaceCheckpoint(playerid) return 1;
public OnPlayerLeaveRaceCheckpoint(playerid) return 1;
//=====RCON=====================================================================
public OnRconCommand(cmd[])	return 1;
//=====OBJECTS==================================================================
public OnObjectMoved(objectid) return 1;
public OnPlayerObjectMoved(playerid, objectid) return 1;
//=====PICKUPS==================================================================
public OnPlayerPickUpPickup(playerid, pickupid) return 1;
//=====MENUS====================================================================
public OnPlayerSelectedMenuRow(playerid, row) return 1;
public OnPlayerExitedMenu(playerid) return 1;
//=====INTERIOR=================================================================
public OnPlayerInteriorChange(playerid, newinteriorid, oldinteriorid)
{
	new x=0;
	while(x!=MAX_PLAYERS) {
		if(IsPlayerConnected(x) && GetPlayerState(x) == PLAYER_STATE_SPECTATING && gSpectateID[x] == playerid && gSpectateType[x] == ADMIN_SPEC_TYPE_PLAYER) {SetPlayerInterior(x, newinteriorid);}
		x++;
	}
	return 1;
}
//=====KEYS=====================================================================
public OnPlayerKeyStateChange(playerid, newkeys, oldkeys) return 1;
//=====STOCK====================================================================
stock IsPlayerAdminLevel(playerid, level)
{
	if (IsPlayerAdmin(playerid) || adminlevel[playerid] >= level) return 1;
	return 0;
}
