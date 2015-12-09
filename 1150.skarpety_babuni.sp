#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Skarpety Babuni",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Skarpety Babuni", "Nie slychac twoich krokow", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Cichobiegi(client, 0, 1);
}

public Cmod_OnItemDisabled(client, itemID){
	Cichobiegi(client, 0, -1);
}