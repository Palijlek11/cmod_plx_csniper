#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod class: Zwiadowca",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_ssg08");
	PushArrayString(weapons, "weapon_fiveseven");
	PushArrayString(weapons, "weapon_molotov");
	PushArrayString(weapons, "weapon_incgrenade");
	Cmod_RegisterClass("Zwiadowca", "Regeneruje 10 HP co 5 sekund", 10, 30, 20, 15, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID)
{
	Sanitarne(client, 10, 0);
}

public Cmod_OnClassDisabled(client, classID)
{
	Sanitarne(client, -1, 0);
}
