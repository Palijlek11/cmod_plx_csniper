#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: ",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Naboje Amadeusza", "Zadajesz 20(+int) obrażen więcej", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
}

public Cmod_OnItemDisabled(client, itemID){
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
	if(maPerk[attacker])
	{
		if(damagetype & DMG_BULLET)
		{
			new Float:dam = 20.0 + float(Cmod_GetClientINT(attacker));
			damage += dam;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}