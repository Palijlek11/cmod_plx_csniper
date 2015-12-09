#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Ciemne Okulary",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Ciemne Okulary", "Jestea odporny na flash'e", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	AntyFlash(client, 0, 1);
}

public Cmod_OnItemDisabled(client, itemID){
	AntyFlash(client, 0, -1);
}
