#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Teleport",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Teleport", "Mozesz teleportowac sie za pomoca noza (PPM) co 3 sek.", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Teleport(client, 0, 1);
}

public Cmod_OnItemDisabled(client, itemID){
	Teleport(client, 0, -1);
}