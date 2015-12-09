#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod skill: Ultra Armor",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new ultraKlasa[MAXPLAYERS+1] = 0;
new ultraItem[MAXPLAYERS+1] = 0;

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Ultra", native_ultra);
	
	return APLRes_Success;
}

public OnClientConnected(client)
{
	ultraKlasa[client] = 0;
	ultraItem[client] = 0;
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
	if(ultraKlasa[attacker])
	{
		if(GetRandomInt(1, ultraKlasa[attacker]) == 1)
		{
			damage = 0.0;
			return Plugin_Changed;
		}
	}
	if(ultraItem[attacker])
	{
		if(GetRandomInt(1, ultraItem[attacker]) == 1)
		{
			damage = 0.0;
			return Plugin_Changed;
		}
	}
	
	return Plugin_Continue;
}

public native_ultra(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1 || item == -1)
	{
		if(klasa == -1)
		{
			ultraKlasa[client] = 0;
		}
		if(item == -1)
		{
			ultraItem[client] = 0;
		}
		return;
	}
	
	if(klasa)
	{
		ultraKlasa[client] = klasa;
	}
	if(item)
	{
		ultraItem[client] = item;
	}
}
