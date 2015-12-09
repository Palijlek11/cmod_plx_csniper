#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: BloodThrister",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("BloodThrister", "Leczysz sie 10% zadanych obrazen", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Vampire(client, 0, 10);
}

public Cmod_OnItemDisabled(client, itemID){
	Vampire(client, 0, -1);
}
