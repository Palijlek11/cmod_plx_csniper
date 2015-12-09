#include <sourcemod>
#include <sdkhooks>
#include <cmod>

new bool:antyHEKlasa[MAXPLAYERS+1] = false;
new bool:antyHEItem[MAXPLAYERS+1] = false;

/*public OnPluginStart()
{
	HookEvent("player_hurt", Event_PlayerHurt, EventHookMode_Pre);
}*/

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("AntyHE", native_antyHE);
	
	return APLRes_Success;
}

public OnClientConnected(client)
{
	antyHEKlasa[client] = false;
	antyHEItem[client] = false;
}

/*public Action:Event_PlayerHurt(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	new String:weapon[31];
	GetEventString(event, "weapon", weapon, 30);
	
	PrintToChat(client, "Bron: %s", weapon);
	
	if((antyHEKlasa[client] || antyHEItem[client]) && StrEqual(weapon, "hegrenade"))
	{
		PrintToChat(client, "Blokuje obrazenia");
		SetEventInt(event, "dmg_health", 0);
		SetEventInt(event, "dmg_armor", 0);
		
		return Plugin_Changed;
	}
	
	return Plugin_Continue;
}*/

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
	if(antyHEKlasa[victim] || antyHEItem[victim])
	{
		if(damagetype == DMG_BLAST)
		{
			return Plugin_Handled;
		}
	}
	return Plugin_Continue;
}

public native_antyHE(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1.0 || item == -1.0)
	{
		if(klasa == -1)
		{
			antyHEKlasa[client] = false;
		}
		if(item == -1)
		{
			antyHEItem[client] = false;
		}
		return;
	}
	
	if(klasa)
	{
		antyHEKlasa[client] = true;
	}
	if(item)
	{
		antyHEItem[client] = true;
	}
}