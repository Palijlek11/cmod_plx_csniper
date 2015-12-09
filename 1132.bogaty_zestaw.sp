#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Bogaty Zestaw",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_hegrenade");
	PushArrayString(weapons, "weapon_flashbang");
	PushArrayString(weapons, "weapon_molotov");
	PushArrayString(weapons, "weapon_smokegrenade");
	Cmod_RegisterItem("Bogaty Zestaw", "Posiadasz pelen zestaw granatow", 1, 1, 250, weapons);
}
