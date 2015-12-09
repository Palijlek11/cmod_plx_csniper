#include <sourcemod>
#include <sdkhooks>
#include <cmod>

#define MEDKIT_MODEL "models/chicken/chicken.mdl"

public Plugin:myinfo = {
	name = "Cmod class: Kapitan",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new maKlase[MAXPLAYERS+1] = false

public OnPluginStart()
{
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_awp");
	PushArrayString(weapons, "weapon_usp-s");
	PushArrayString(weapons, "weapon_hegrenade");
	PushArrayString(weapons, "weapon_flashbang");
	Cmod_RegisterClass("Kapitan [Premium]", "Natychmiastowe zabicie z AWP", 5, 35, 25, 15, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID)
{
	maKlase[client] = true
}

public Cmod_OnClassDisabled(client, classID)
{
	maKlase[client] = false
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
		if(StrEqual(weapon, "weapon_awp") && (damagetype & DMG_BULLET))
		{
			damage = float(GetClientHealth(victim)) * 3.0;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}