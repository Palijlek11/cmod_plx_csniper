#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Class: Zlodziej",
	author = "CSnajper",
	description = "Class dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maKlase[MAXPLAYERS+1] = false;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_galil");
	PushArrayString(weapons, "weapon_p250");
	PushArrayString(weapons, "weapon_hegrenade");
	PushArrayString(weapons, "weapon_flashbang");
	Cmod_RegisterClass("Zlodziej", "1/3 na wyssanie krwi z wroga (1 strzal = 5hp, 1 pkt. inteligencji = 1hp wiecej)", 5, 15, 15, 10, 0, weapons);
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
		if(GetRandomInt(1,3) == 1 && (damagetype & DMG_BULLET))
		{
			new heal = 5 + Cmod_GetINT(attacker);
			new hp = GetClientHealth(attacker) + heal;
			new maxHp = 100 + Cmod_GetCON(attacker);
			if(hp > maxHp)
				SetEntData(attacker, FindDataMapOffs(attacker, "m_iHealth"), maxHp, 4, true);
			else
				SetEntData(attacker, FindDataMapOffs(attacker, "m_iHealth"), hp, 4, true);
		}
	}
	return Plugin_Continue;
}