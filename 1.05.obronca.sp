#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod class: Obronca",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_negev");
	PushArrayString(weapons, "weapon_elite");
	PushArrayString(weapons, "weapon_hegrenade");
	Cmod_RegisterClass("Obronca", "Wolny, ale potrafi duzo zniesc", 0, 35, 0, -15, 100, weapons);
}

public Cmod_OnClassEnabled(client, classID)
{
	
}

public Cmod_OnClassDisabled(client, classID)
{
	
}