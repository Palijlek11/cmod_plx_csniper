#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Apteczka",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new bool:uzylItemu[MAXPLAYERS+1] = false;
new bool:maItem[MAXPLAYERS+1] = false;

public OnPluginStart()
{
	Cmod_RegisterItem("Apteczka", "Raz na runde mozesz przywrocic sobie cale HP", 1, 1, 250, INVALID_HANDLE);
	HookEvent("player_spawn", eventPlayerSpawn);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maItem[client] = true;
	uzylItemu[client] = false;
}

public Cmod_OnItemDisabled(client, itemID){
	maItem[client] = false;
}

public Cmod_OnClientUseItem(client, itemID){
	if(!uzylItemu[client])
	{
		new hp = GetClientHealth(client)
		new max_hp = 100 + Cmod_GetCON(client)
		if(hp == max_hp)
			return;

		SetEntData(client, FindDataMapOffs(client, "m_iHealth"), max_hp, 4, true);
		uzylItemu[client] = true;
	}
}

public Action:eventPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"))
	if(maItem[client])
		uzylItemu[client] = false;
}

public OnClientConnected(client)
{
	uzylItemu[client] = false;
	maItem[client] = false;
}