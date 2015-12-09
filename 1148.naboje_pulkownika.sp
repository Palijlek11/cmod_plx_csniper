#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Naboje Pulkownika",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Naboje Pulkownika", "Zadajesz o 15 wiecej obrazen", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	BonusDMG(client, 0, 15);
}

public Cmod_OnItemDisabled(client, itemID){
	BonusDMG(client, 0, -1);
}