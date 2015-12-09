#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Buty Ninjy",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Buty Ninjy", "Jestes zwinny (+20 do kondycji) oraz nie slychac twoich krokow", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Cichobiegi(client, 0, 1);
	Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) + 20);
}

public Cmod_OnItemDisabled(client, itemID){
	Cichobiegi(client, 0, -1);
	Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) - 20);
}