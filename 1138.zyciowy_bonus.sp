#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Zyciowy Bonus",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Zyciowy Bonus", "Dostajesz +25pkt zdrowia", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Cmod_SetBonusCON(client, Cmod_GetBonusCON(client) + 25);
}

public Cmod_OnItemDisabled(client, itemID){
	Cmod_SetBonusCON(client, Cmod_GetBonusCON(client) - 25);
}
