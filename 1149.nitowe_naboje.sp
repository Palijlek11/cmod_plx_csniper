#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Nanitowe Naboje",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Nanitowe Naboje", "Zadajesz dodatkowo 5 dmg, + 1 int = 1dmg", 1, 1, 250, INVALID_HANDLE);
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
		new String:weapon[32];
		GetClientWeapon(attacker, weapon, 31);
		new Float:extra_damage = 5.0 + float(Cmod_GetINT(attacker));
		if(damagetype & DMG_BULLET)
		{
			damage += extra_damage;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}
