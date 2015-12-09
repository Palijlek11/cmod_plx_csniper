#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Tajemnica Granatow Wybuchowych",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Tajemnica Granatow Wybuchowych", "Masz 1/1-4 szans na natychmiastowe zabicie z granata wybuchajacego", 1, 4, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Granat(client, 0, value);
}

public Cmod_OnItemDisabled(client, itemID){
	Granat(client, 0, -1);
}
