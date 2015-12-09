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
	Cmod_RegisterItem("Zwinnosc Komandosa", "Dostajesz +25pkt inteligencji", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Cmod_SetBonusINT(client, Cmod_GetBonusINT(client) + 25);
}

public Cmod_OnItemDisabled(client, itemID){
	Cmod_SetBonusINT(client, Cmod_GetBonusINT(client) - 25);
}
