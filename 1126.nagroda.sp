#include <sourcemod>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Item: Nagroda",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;
new OffsetPlayerMoney = -1;

public OnPluginStart(){
	HookEvent("player_spawn", Event_PlayerSpawn);
	Cmod_RegisterItem("Nagroda", "Co runde dostajesz 16000$", 1, 1, 250, INVALID_HANDLE);
	OffsetPlayerMoney = FindSendPropOffs("CCSPlayer", "m_iAccount");
}

public Cmod_OnItemEnabled(client, ItemID, value){
	maPerk[client] = true;
}

public Cmod_OnItemDisabled(client, ItemID){
	maPerk[client] = false;
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid") );
	if(maPerk[client])
	{
		CreateTimer(0.1, DajHajs, client)
	}
}

public Action:DajHajs(Handle:timer, any:client)
{
	SetEntData(client, OffsetPlayerMoney, 16000)
}