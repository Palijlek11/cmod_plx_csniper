#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Zwinnosc Komandosa",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Zwinnosc Komandosa", "Dostajesz +25pkt szybkosci", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) + 25);
}

public Cmod_OnItemDisabled(client, itemID){
	Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) - 25);
}
