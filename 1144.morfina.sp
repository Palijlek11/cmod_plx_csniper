#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Morfina",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

public OnPluginStart()
{
	Cmod_RegisterItem("Morfina", "1/LW szansy na odrodzenie sie po zgonie", 2, 8, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value)
{
	Respawn(client, 0, value);
}

public Cmod_OnItemDisabled(client, itemID)
{
	Respawn(client, 0, -1);
}