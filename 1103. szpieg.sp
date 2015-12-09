#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Szpieg",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Szpieg", "Posiadasz ubranie wroga", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	ZmienUbranie(client, 0, 1);
}

public Cmod_OnItemDisabled(client, itemID){
	ZmienUbranie(client, 0, -1);
}

