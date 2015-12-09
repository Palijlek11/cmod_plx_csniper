#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Class: KGB",
	author = "CSnajper",
	description = "Class dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maKlase[MAXPLAYERS+1] = false;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_ak47");
	PushArrayString(weapons, "weapon_p250");
	PushArrayString(weapons, "weapon_molotov");
	PushArrayString(weapons, "weapon_hegrenade");
	Cmod_RegisterClass("KGB", "+8dmg z AK47,Leczy sie o 1/5 zadawanych obrazen", 2, 15, 15, 10, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID){
	maKlase[client] = true;
	Vampire(client, 20, 0);
}

public Cmod_OnClassDisabled(client, classID){
	maKlase[client] = false;
	Vampire(client, -1, 0);
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
		new String:weapon[32];
		GetClientWeapon(attacker, weapon, 31);
		if(StrEqual(weapon, "weapon_ak47") && (damagetype & DMG_BULLET))
		{
			damage += 8.0;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}