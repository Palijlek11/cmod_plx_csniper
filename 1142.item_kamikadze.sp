#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Kamikadze",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Kamikadze", "1/LW szans na wybuch po smierci (zadaje 100+int obrazen)", 1, 4, 200, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Wybuch(client, 0, value);
}

public Cmod_OnItemDisabled(client, itemID){
	Wybuch(client, 0, -1);
}