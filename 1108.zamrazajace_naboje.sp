#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Zamrazajace Naboje",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	Cmod_RegisterItem("Zamrazajace Naboje", "Masz 1/15 na zamrozenie wroga na 1.5 sek.", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	Przygwozdzenie(client, 0, 15);
}

public Cmod_OnItemDisabled(client, itemID){
	Przygwozdzenie(client, 0, -1);
}
