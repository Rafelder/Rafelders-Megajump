//////////////////////////////////////
/////Language system by Rafelder//////
//////////////////////////////////////
///V.2.0//////Copyright by Rafelder///
//////////////////////////////////////
////Last Update: 13.April 2010////////
//////////////////////////////////////

#if defined _Language_included
  #endinput
#endif

#define _Language_included
#pragma library Language

#include <dini>

#define LANGUAGE_ENGLISH 0 // Write your custom languages
#define LANGUAGE_GERMAN 1 // Write your custom languages
new Languages[2][] = {"English", "German"}; // Write your custom languages {"Language 0", Language 1"};
new Language[MAX_PLAYERS] = 0; // Language 0

/*
native dcmd(setlanguage, 11, cmdtext);
native SetPlayerLanguage(playerid, language)
native SendLanguageMessage(playerid, color, const message0[], const message1[])
native SendLanguageMessageEx(playerid, color, const message0[], const define0[], const message1[], const define1[])
native SendLanguageMessageToAll(color, const message0[], const message1[])
native SendLanguageMessageToAllEx(color, const message0[], const define0[], const message1[], const define1[])

native LanguageGameText(playerid, const message0[], const message1[], time, style)
native LanguageGameTextEx(playerid, const message0[], const define0[], const message1[], const define1[], time, style)
native LanguageGameTextForAll(const message0[], const message1[], time, style)
native LanguageGameTextForAllEx(const message0[], const define0[], const message1[], const define1[], time, style)

native ResetStats(playerid);
native TurnIntoString(number);
*/

#if !defined COLOR_YELLOW
	#define COLOR_YELLOW 0xFFFF00FF
#endif

#if !defined dcmd
	#define dcmd(%1,%2,%3) if ((strcmp((%3)[1], #%1, true, (%2)) == 0) && ((((%3)[(%2) + 1] == 0) && (dcmd_%1(playerid, "")))||(((%3)[(%2) + 1] == 32) && (dcmd_%1(playerid, (%3)[(%2) + 2]))))) return 1
#endif

#define STR_SIZE 256

new lstr[STR_SIZE];


stock SetPlayerLanguage(playerid, language) return Language[playerid] = language;
stock SendLanguageMessage(playerid, color, const message0[], const message1[]) SendClientMessage(playerid, color, (Language[playerid] == 0) ? (message0) : (message1));

stock SendLanguageMessageEx(playerid, color, const message0[], const define0[], const message1[], const define1[])
{
	format(lstr, STR_SIZE, (Language[playerid] == 0) ? (message0) : (message1), (Language[playerid] == 0) ? (define0) : (define1));
	SendClientMessage(playerid, color, lstr);
}

stock SendLanguageMessageToAll(color, const message0[], const message1[]) for(new i=0; i<MAX_PLAYERS; i++) SendClientMessage(i, color, (Language[i] == 0) ? (message0) : (message1));

stock SendLanguageMessageToAllEx(color, const message0[], const define0[], const message1[], const define1[])
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		format(lstr, STR_SIZE, (Language[i] == 0) ? (message0) : (message1), (Language[i] == 0) ? (define0) : (define1));
		SendClientMessage(i, color, lstr);
	}
}

dcmd_setlanguage(playerid, cmdtext[])
{

	if (!strlen(cmdtext))
	{
		format(lstr, STR_SIZE, (Language[playerid] == 0) ? ("Use \"/setlanguage [%s/%s]\" to change your language!") : ("Benutze \"/setlanguage [%s/%s]\" um deine Sprache zu ändern!"), Languages[0], Languages[1]);
		SendClientMessage(playerid, COLOR_YELLOW, lstr);
		return 1;
	}
	if (!strcmp(cmdtext, Languages[0], true)) SetPlayerLanguage(playerid, 0);
	else if (!strcmp(cmdtext, Languages[1], true)) SetPlayerLanguage(playerid, 1);
	else
	{
		format(lstr, STR_SIZE, (Language[playerid] == 0) ? ("Use \"/setlanguage [%s/%s]\" to change your language!") : ("Benutze \"/setlanguage [%s/%s]\" um deine Sprache zu ändern!"), Languages[0], Languages[1]);
		SendClientMessage(playerid, COLOR_YELLOW, lstr);
		return 1;
	}
	GetPlayerName(playerid, lstr, STR_SIZE);
	SendLanguageMessageEx(playerid, COLOR_YELLOW, "You change your language to \"%s\"", Languages[0], "Du hast deine Sprache zu \"%s\" gewechselt", Languages[1]);
	return 1;
}

stock ResetStats(playerid) Language[playerid]=0;

stock TurnIntoString(number)
{
	valstr(lstr, number);
	return lstr;
}

stock LanguageGameText(playerid, const message0[], const message1[], time, style) GameTextForPlayer(playerid, (Language[playerid] == 0) ? (message0) : (message1), time, style);

stock LanguageGameTextEx(playerid, const message0[], const define0[], const message1[], const define1[], time, style)
{
	new string[256];
	if (Language[playerid] == 0) format(string, sizeof(string), message0, define0);
	if (Language[playerid] == 1) format(string, sizeof(string), message1, define1);
	GameTextForPlayer(playerid, string, time, style);
}

stock LanguageGameTextForAll(const message0[], const message1[], time, style) for(new i=0; i<MAX_PLAYERS; i++) GameTextForPlayer(i, (Language[i] == 0) ? (message0) : (message1), time, style);

stock LanguageGameTextForAllEx(const message0[], const define0[], const message1[], const define1[], time, style)
{
	for(new i=0; i<MAX_PLAYERS; i++)
	{
		format(lstr, STR_SIZE, (Language[i] == 0) ? (message0) : (message1), (Language[i] == 0) ? (define0) : (define1));
		GameTextForPlayer(i, lstr, time, style);
	}
}