#include <sourcemod>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Item: ",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maItem[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Podpalajace Naboje", "1/15 szans na podpalenie wroga na 5 sek.", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maItem[client] = true;
}

public Cmod_OnItemDisabled(client, itemID){
	maItem[client] = false;
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public OnClientDisconnect(client)
{
	SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if(!IsValidClient(victim) || !IsValidClient(attacker))
		return Plugin_Continue;
	if(!IsValidAlive(victim))
		return Plugin_Continue;
	if(maItem[attacker])
	{
		if(GetRandomInt(1,15) == 1 && (damagetype & DMG_BULLET))
		{
			IgniteEntity(victim, 5.0);
		}
	}
	return Plugin_Continue;
}