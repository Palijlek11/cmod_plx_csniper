#include <sourcemod>
#include <sdktools>
#include <sdkhooks>
#include <cstrike>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Item: NanoKamizelka",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;
new bool:uzylPerku[MAXPLAYERS+1] = false;
new bool:Niesmiertelny[MAXPLAYERS+1] = false;
new Handle:timer_perk[MAXPLAYERS+1] = INVALID_HANDLE;

public OnPluginStart()
{
	Cmod_RegisterItem("NanoKamizelka", "Uzyj aby stac sie niesmiertelnym na 5 sekund", 1, 1, 250, INVALID_HANDLE);
	HookEvent("player_spawn", eventPlayerSpawn);
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
	uzylPerku[client] = false;
}

public Cmod_OnItemDisabled(client, ItemID){
	maPerk[client] = false;
}


public Cmod_OnClientUseItem(client, itemID){
	if(maPerk[client] && !uzylPerku[client])
	{
		Niesmiertelny[client] = true;
		uzylPerku[client] = true;
		timer_perk[client] = CreateTimer(5.0, StopNiesmiertelnosc, client);
		PrintToChatAll("\x01\x0B\x04Jestes niesmiertelny na 5 sekund");
	}
}

public Action:StopNiesmiertelnosc(Handle:timer, any:client)
{
	Niesmiertelny[client] = false;
	
	timer_perk[client] = INVALID_HANDLE;
	
	PrintToChatAll("\x01\x0B\x02Niesmiertelnosc wylaczona");
}

public eventPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"))
	
	if ( maPerk[client])
	{
		uzylPerku[client] = false;
	}
	Niesmiertelny[client] = false;

}

public OnClientPutInServer(client)
{
	Niesmiertelny[client] = false;
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public OnClientDisconnect(client)
{
	Niesmiertelny[client] = false;
	SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if(!IsValidClient(victim) || !IsValidClient(attacker))
		return Plugin_Continue;
	if(!IsValidAlive(victim))
		return Plugin_Continue;
	if(maPerk[victim] && Niesmiertelny[victim])
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