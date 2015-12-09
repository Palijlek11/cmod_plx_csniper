#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Platynowe Naboje Penetrujace",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;
new szansa[MAXPLAYERS+1] = 0;

public OnPluginStart(){
	Cmod_RegisterItem("Platynowe Naboje Penetrujace", "Masz 1/2-7 szans na potrojenie obrazen", 2, 7, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
	szansa[client] = value;
}

public Cmod_OnItemDisabled(client, itemID){
	maPerk[client] = false;
	szansa[client] = 0;
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
	if(maPerk[attacker])
	{
		if(damagetype & DMG_BULLET)
		{
			if(GetRandomInt(1, szansa[attacker]) == 1)
			{
				damage *= 3;
				return Plugin_Changed;
			}
		}
	}
	return Plugin_Continue;
}