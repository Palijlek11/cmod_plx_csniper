#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Jumper",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Jumper", "Mozesz wykonac dwa skoki w powietrzu", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Skoki(client, 0, 2);
}

public Cmod_OnItemDisabled(client, itemID){
	Skoki(client, 0, -1);
}
