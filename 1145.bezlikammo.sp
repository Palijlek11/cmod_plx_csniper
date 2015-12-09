#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Bezlik Ammo",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Bezlik Ammo", "Amunicja w twojej broni nigdy siê nie skoñczy", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, ItemID, value){
	UnlimitedClip(client, 0, 1);
}

public Cmod_OnItemDisabled(client, ItemID){
	UnlimitedClip(client, 0, -1);
}
