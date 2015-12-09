#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Zwinne Palce",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Zwinne Palce", "Natychmiastowe przeładowanie broni", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	UnlimitedClip(client, 0, 1);
}

public Cmod_OnItemDisabled(client, itemID){
	UnlimitedClip(client, 0, -1);
}
