#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Item: kask Zwiadowcy",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart()
{
	Cmod_RegisterItem("Kask Zwiadowcy", "Nie otrzymujesz obrazen w glowe", 1, 1, 250, INVALID_HANDLE);

	for(new i = 1; i <= MaxClients; i++)
	{
		if(IsClientValid(i))
		{
			SDKHook(i, SDKHook_OnTakeDamage, OnTakeDamage);
		}
	}
}

public Cmod_OnItemEnabled(client, ItemID, value){
	maPerk[client] = true;
}

public Cmod_OnItemDisabled(client, ItemID){
	maPerk[client] = false;
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
	if(maPerk[victim] && (damagetype & CS_DMG_HEADSHOT))
	{
		damage = 0.0;
		return Plugin_Changed;
	}
	return Plugin_Continue;
}

stock bool:IsClientValid(client)
{
	if(client > 0 && client <= MaxClients && IsClientInGame(client))
		return true;
	return false;
}