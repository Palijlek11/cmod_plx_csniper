#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Wytrzymałosc Obroncy",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Wytrzymałosc Obroncy", "Dostajesz +25pkt wytrzymalosci", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Cmod_SetBonusSTR(client, Cmod_GetBonusSTR(client) + 25);
}

public Cmod_OnItemDisabled(client, itemID){
	Cmod_SetBonusSTR(client, Cmod_GetBonusSTR(client) - 25);
}
