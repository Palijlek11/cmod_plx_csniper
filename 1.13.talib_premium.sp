#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Class: Talib",
	author = "CSnajper",
	description = "Class dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maKlase[MAXPLAYERS+1] = false;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_sg556");
	PushArrayString(weapons, "weapon_p2000");
	PushArrayString(weapons, "weapon_hegrenade");
	PushArrayString(weapons, "weapon_incgrenade");
	Cmod_RegisterClass("Talib [Premium]", "Posiada naboje podpalające 1/15\nPodpalenie trwa 5 sek.", 0, 20, 30, 25, 0, weapons);
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
		if(GetRandomInt(1,15) == 1 && (damagetype & DMG_BULLET))
		{
			IgniteEntity(victim, 5.0);
		}
	}
	return Plugin_Continue;
}
