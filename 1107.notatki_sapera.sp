#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Notatnik Sapera",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart()
{
	Cmod_RegisterItem("Notatnik Sapera", "Dostajesz 2 miny co runde", 2, 4, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value)
{
	maPerk[client] = true;
	Miny(client, 0, 2);
}

public Cmod_OnItemDisabled(client, itemID)
{
	maPerk[client] = false;
	Miny(client, 0, -1);
}

public Cmod_OnClientUseItem(client, ItemID)
	if(maPerk[client])
		KladzMine(client);