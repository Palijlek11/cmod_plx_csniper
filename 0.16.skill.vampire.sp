#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Skill: Wysysanie Zycia",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new Float:vampireKlasa[MAXPLAYERS+1] = 0.0;
new Float:vampireItem[MAXPLAYERS+1] = 0.0;

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Vampire", native_vampire);
	
	return APLRes_Success;
}

public OnClientConnected(client)
{
	vampireKlasa[client] = 0.0;
	vampireItem[client] = 0.0;
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
	new Float:heal = 0.0
	if(IsValidClient(attacker))
	{
		if(vampireKlasa[attacker])
		{
			heal += damage * vampireKlasa[attacker];
		}
		if(vampireItem[attacker])
		{
			heal += damage * vampireItem[attacker];
		}
		if(heal)
		{
			new hp = GetClientHealth(attacker) + RoundToNearest(heal);
			new maxHp = 100 + Cmod_GetClientCON(attacker)  + Cmod_GetClassCON(attacker) + Cmod_GetBonusCON(attacker)
			if(hp > maxHp)
				SetEntData(attacker, FindDataMapOffs(attacker, "m_iHealth"), maxHp, 4, true);
			else
				SetEntData(attacker, FindDataMapOffs(attacker, "m_iHealth"), hp, 4, true);
		}
	}
	
	return Plugin_Continue;
}

public native_vampire(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1.0 || item == -1.0)
	{
		if(klasa == -1)
		{
			vampireKlasa[client] = 0.0;
		}
		if(item == -1)
		{
			vampireItem[client] = 0.0;
		}
		return;
	}
	
	if(klasa)
	{
		vampireKlasa[client] = float(klasa) * 0.01;
	}
	if(item)
	{
		vampireItem[client] = float(item) * 0.01;
	}
}
