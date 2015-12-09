#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: RoadRunner",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("RoadRunner", "Dostajesz 20 kondycji oraz zmniejsza grawitacje", 1, 1, 250, INVALID_HANDLE);
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
	SetEntityGravity(client, 0.5);
	Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) + 20);
}

public Cmod_OnItemDisabled(client, itemID){
	maPerk[client] = false;
	SetEntityGravity(client, 0.5);
	Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) - 20);
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid") );
	
	if(maPerk[client])
	{
		SetEntityGravity(client, 0.5);
	}
}