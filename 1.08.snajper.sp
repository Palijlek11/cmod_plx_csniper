#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod class: Lekki Snajper",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new maKlase[MAXPLAYERS+1] = false;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_awp");
	PushArrayString(weapons, "weapon_deagle");
	PushArrayString(weapons, "weapon_smokegrenade");
	PushArrayString(weapons, "weapon_flashbang");
	Cmod_RegisterClass("Snajper", "Obrazenia z AWP zwiekszone o 20% + inteligencja", 10, 30, 10, 0, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID)
{
	maKlase[client] = true;
}

public Cmod_OnClassDisabled(client, classID)
{
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
		new String:weapon[32];
		GetClientWeapon(attacker, weapon, 31);
		new Float:extra_damage = 1.2 + (float(Cmod_GetINT(attacker)) / 100.0);
		if(StrEqual(weapon, "weapon_awp") && (damagetype & DMG_BULLET))
		{
			damage *= extra_damage;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}
