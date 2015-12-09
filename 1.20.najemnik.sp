#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Class: Najemnik",
	author = "CSnajper",
	description = "Class dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maKlase[MAXPLAYERS+1] = false;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_glock");
	PushArrayString(weapons, "weapon_usp-s");
	Cmod_RegisterClass("Najemnik", "Może kupić i podnieść każdą broń. Ma 1/10 na 3x zadanego dmg", 3, 10, 10, 10, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID){
	maKlase[client] = true;
}

public Cmod_OnClassDisabled(client, classID){
	maKlase[client] = false;
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
	if(maKlase[attacker])
	{
		if(GetRandomInt(1,10) == 1 && (damagetype & DMG_BULLET))
		{
			damage *= 3.0;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}
