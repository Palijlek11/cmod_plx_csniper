#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: SSG08 Snajper",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_ssg08");
	Cmod_RegisterItem("SSG08 Snajper", "Dostajesz SSG08 na początku rundy, 1/2 na zabicie z niego", 1, 1, 250, weapons);
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
		if(GetRandomInt(1,2) == 1 && StrEqual(weapon, "weapon_ssg08") && (damagetype & DMG_BULLET))
		{
			damage = float(GetClientHealth(victim)) * 3.0;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}