#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Pakt Lucyfera",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Pakt Lucyfera", "Zadajesz 40% obrazen wiecej ale tracisz 30 punktow zdrowia", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
	Cmod_SetBonusCON(client, Cmod_GetBonusCON(client) - 30);
}

public Cmod_OnItemDisabled(client, itemID){
	maPerk[client] = false;
	Cmod_SetBonusCON(client, Cmod_GetBonusCON(client) + 30);
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
			damage *= 1.4;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}