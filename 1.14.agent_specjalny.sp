#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Class: ",
	author = "CSnajper",
	description = "Class dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_ump45");
	PushArrayString(weapons, "weapon_tec9");
	PushArrayString(weapons, "weapon_flashbang");
	PushArrayString(weapons, "weapon_flashbang");
	PushArrayString(weapons, "weapon_incgrenade");
	Cmod_RegisterClass("Agent Specjalny [PR]", "posiada ubranie wroga", 0, 25, 25, 20, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID){
	ZmienUbranie(client, 1, 0);
}

public Cmod_OnClassDisabled(client, classID){
	ZmienUbranie(client, -1, 0);
}

