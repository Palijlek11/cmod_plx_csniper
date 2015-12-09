#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod class: Lekki Snajper",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new bool:maKlase[MAXPLAYERS+1] = false;

public OnPluginStart()
{
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_deagle");
	PushArrayString(weapons, "weapon_hegrenade");
	Cmod_RegisterClass("Komandos", "Natychmiastowe zabicie z noza (prawy przycisk myszy)", 5, 30, 25, 20, 0, weapons);
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
		if((GetClientButtons(attacker) & IN_ATTACK2) && StrEqual(weapon, "weapon_knife") && (damagetype & DMG_SLASH))
		{
			damage = float(GetClientHealth(victim)) * 3.0;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}