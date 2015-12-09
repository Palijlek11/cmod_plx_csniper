#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Skill: Sanitarne",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new sanitarneKlasa[MAXPLAYERS+1] = 0;
new sanitarneItem[MAXPLAYERS+1] = 0;
new Handle:timer_klasa[MAXPLAYERS+1] = INVALID_HANDLE;
new Handle:timer_item[MAXPLAYERS+1] = INVALID_HANDLE;


//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Sanitarne", native_sanitarne);
	
	return APLRes_Success;
}

public OnClientConnected(client)
{
	sanitarneKlasa[client] = 0;
	sanitarneItem[client] = 0;
}

public native_sanitarne(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1 || item == -1)
	{
		if(klasa == -1)
		{
			if(timer_klasa[client] != INVALID_HANDLE)
			{
				CloseHandle(timer_klasa[client])
				timer_klasa[client] = INVALID_HANDLE;
			}
		}
		if(item == -1)
		{
			if(timer_item[client] != INVALID_HANDLE)
			{
				CloseHandle(timer_item[client])
				timer_item[client] = INVALID_HANDLE;
			}
		}
		return;
	}
	
	if(klasa)
	{
		timer_klasa[client] = CreateTimer(5.0, lecz, client, TIMER_REPEAT);
		sanitarneKlasa[client] = klasa;
	}
	if(item)
	{
		timer_item[client] = CreateTimer(5.0, lecz, client, TIMER_REPEAT);
		sanitarneItem[client] = item;
	}
}

public Action:lecz(Handle:timer, any:client)
{
	new id = client;
	
	if(IsPlayerAlive(id))
	{
		if(sanitarneKlasa[id] || sanitarneItem[id])
		{
			//dodatkowe hp
			new hp = GetClientHealth(id) + sanitarneKlasa[id] + sanitarneItem[id];
			new maxHp = 100 + Cmod_GetClientCON(id)  + Cmod_GetClassCON(id) + Cmod_GetBonusCON(id)
			if(hp > maxHp)
				SetEntData(id, FindDataMapOffs(id, "m_iHealth"), maxHp, 4, true);
			else
				SetEntData(id, FindDataMapOffs(id, "m_iHealth"), hp, 4, true);
		}
		else
		{
			if(timer_klasa[client] != INVALID_HANDLE)
{
				CloseHandle(timer_klasa[client])
				timer_klasa[client] = INVALID_HANDLE;
			}
			if(timer_item[client] != INVALID_HANDLE)
			{
				CloseHandle(timer_item[client])
				timer_item[client] = INVALID_HANDLE;
			}
		}
	}
	return Plugin_Continue;
	
}
