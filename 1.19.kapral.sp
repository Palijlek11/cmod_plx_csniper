#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

#define MEDKIT_MODEL "models/chicken/chicken.mdl"

public Plugin:myinfo = {
	name = "Cmod class: Kapral",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new maKlase[MAXPLAYERS+1] = false

public OnPluginStart()
{
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_fiveseven");
	PushArrayString(weapons, "weapon_hegrenade");
	PushArrayString(weapons, "weapon_incgrenade");
	Cmod_RegisterClass("Kapral [Premium]", "1/8 na natychmiastowe zabicie z Five-Seven\n1/5 na natychmiastowe zabicie z HE", 5, 10, 40, 25, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID)
{
	maKlase[client] = true;
	Granat(client, 5, 0);
}

public Cmod_OnClassDisabled(client, classID)
{
	maKlase[client] = false;
	Granat(client, -1, 0);
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
		if(GetRandomInt(1,8) == 1 && StrEqual(weapon, "weapon_fiveseven") && (damagetype & DMG_BULLET))
		{
			damage = float(GetClientHealth(victim)) * 3.0;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}