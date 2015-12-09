#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Amulet Krwiopicy",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Amulet Krwiopicy", "1/4 na pomyślne wyssanie 15 hp po strzale", 1, 1, 250, INVALID_HANDLE);
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
		if(GetRandomInt(1,4) == 1 && (damagetype & DMG_BULLET))
		{
			new hp = GetClientHealth(attacker) + 15;
			new maxHp = 100 + Cmod_GetCON(attacker);
			if(hp > maxHp)
				SetEntData(attacker, FindDataMapOffs(attacker, "m_iHealth"), maxHp, 4, true);
			else
				SetEntData(attacker, FindDataMapOffs(attacker, "m_iHealth"), hp, 4, true);
		}
	}
	return Plugin_Continue;
}