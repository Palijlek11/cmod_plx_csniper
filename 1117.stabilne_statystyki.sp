#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Stabilne Statystyki",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Stabilne Statystyki", "Dostajesz +10pkt do każdej statystyki", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value)
{
	Cmod_SetBonusCON(client, Cmod_GetBonusCON(client) + 10);
	Cmod_SetBonusINT(client, Cmod_GetBonusINT(client) + 10);
	Cmod_SetBonusSTR(client, Cmod_GetBonusSTR(client) + 10);
	Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) + 10);
}

public Cmod_OnItemDisabled(client, itemID)
{
	Cmod_SetBonusCON(client, Cmod_GetBonusCON(client) - 10);
	Cmod_SetBonusINT(client, Cmod_GetBonusINT(client) - 10);
	Cmod_SetBonusSTR(client, Cmod_GetBonusSTR(client) - 10);
	Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) - 10);
}