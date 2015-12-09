#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Prochy Al-kaida",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_hegrenade");
	Cmod_RegisterItem("Prochy Al'Kaida", "Natychmiastowe zabicie granatem", 1, 1, 250, weapons);
}

public Cmod_OnItemEnabled(client, ItemID, value){
	Granat(client, 0, 1);
}

public Cmod_OnItemDisabled(client, ItemID){
	Granat(client, 0, -1);
}