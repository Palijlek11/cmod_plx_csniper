#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Tajmnieca Medyka",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Tajmnieca Medyka", "Co 5 sekund dostajesz 15HP", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Sanitarne(client, 0, 15);
}

public Cmod_OnItemDisabled(client, itemID){
	Sanitarne(client, 0, -1);
}
