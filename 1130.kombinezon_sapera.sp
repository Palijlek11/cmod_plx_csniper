#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Kombinezon Sapera",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Kombinezon Sapera", "Nie otrzymujesz obrazen od granatow wybuchowych", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	AntyHE(client, 0, 1);
}

public Cmod_OnItemDisabled(client, itemID){
	AntyHE(client, 0, -1);
}
