#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Class: Gestapo",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_ak47");
	PushArrayString(weapons, "weapon_glock");
	PushArrayString(weapons, "weapon_hegrenade");
	PushArrayString(weapons, "weapon_flashbang");
	Cmod_RegisterClass("Gestapo", "Brak dodatkowych umiejetnosci", 0, 10, 15, 10, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID){
	
}

public Cmod_OnClassDisabled(client, classID){
	
}