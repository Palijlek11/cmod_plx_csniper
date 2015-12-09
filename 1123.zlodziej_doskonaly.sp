#include <sourcemod>
#include <cstrike>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Zlodziej Doskonaly",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;
new szansa[MAXPLAYERS+1] = 0;

public OnPluginStart(){
	Cmod_RegisterItem("Zlodziej Doskonaly", "Masz 1/LW szans na wyrzucenie broni przeciwnika", 15, 35, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
	szansa[client] = value;
}

public Cmod_OnItemDisabled(client, itemID){
	maPerk[client] = false;
	szansa[client] = 0;
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
//		if(GetRandomInt(1,szansa) == 1)
//		{
			new weapon2 = GetEntPropEnt(victim, Prop_Data, "m_hActiveWeapon");
			//new String:weapon2[32];
			//GetClientWeapon(victim, weapon2, 31);
			CS_DropWeapon(victim, weapon2, false, false);
			//SDKHooks_DropWeapon(victim, weapon2, NULL_VECTOR);
//		}
	}
	return Plugin_Continue;
}