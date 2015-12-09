#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Pakiet Doswiadczenia",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Pakiet Doswiadczenia", "Co runde daje ci losowa ilosc expa (max 150)", 1, 1, 250, INVALID_HANDLE);
	
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
}
public Cmod_OnItemDisabled(client, itemID){
	maPerk[client] = false;
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid") );
	
	if(maPerk[client])
	{
		new exp = Cmod_GetClientExp(client) + GetRandomInt(10, 150);
		Cmod_SetClientExp(client, exp);
	}
}