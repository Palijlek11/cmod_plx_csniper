#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Pancerz Neomexowy",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Pancerz Neomexowy", "Masz 1/4-7 szans na odbicie pocisku", 4, 7, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Ultra(client, 0, value);
}

public Cmod_OnItemDisabled(client, itemID){
	Ultra(client, 0, -1);
}
