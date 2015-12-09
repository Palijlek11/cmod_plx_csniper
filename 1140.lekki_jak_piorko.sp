#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Lekki jak Piorko",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Lekki jak Piorko", "Twoja grawitacja jest zredukowana do polowy", 1, 2, 250, INVALID_HANDLE);
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
	SetEntityGravity(client, 0.5);
}

public Cmod_OnItemDisabled(client, itemID){
	maPerk[client] = false;
	SetEntityGravity(client, 1.0);
}

public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid") );

	if ( maPerk[client] )
	{
		SetEntityGravity(client, 0.5);
	}

	return Plugin_Continue
}

