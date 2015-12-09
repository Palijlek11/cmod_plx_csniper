#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Skill: Natychmiastowe Zabicie Granatem",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new granatKlasa[MAXPLAYERS+1] = 0;
new granatItem[MAXPLAYERS+1] = 0;


//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Granat", native_granat);
	
	return APLRes_Success;
}

public OnClientConnected(client)
{
	granatKlasa[client] = 0;
	granatItem[client] = 0;
}

public OnEntityCreated(iEnt, const String:szClassname[])
{
	if(StrEqual(szClassname, "hegrenade_projectile"))
	{
		SDKHook(iEnt, SDKHook_SpawnPost, OnGrenadeSpawn);
	}
}

public OnGrenadeSpawn(iGrenade)
{
	new client = GetEntPropEnt(iGrenade, Prop_Data, "m_hOwnerEntity");
	if(IsClientInGame(client))
	{
		if(granatKlasa[client] > 0)
		{
			if(GetRandomInt(1,granatKlasa[client]) == 1)
				CreateTimer(0.1, ChangeGrenadeDamage, iGrenade, TIMER_FLAG_NO_MAPCHANGE);
		}
		else if(granatItem[client] > 0)
		{
			if(GetRandomInt(1,granatItem[client]) == 1)
				CreateTimer(0.1, ChangeGrenadeDamage, iGrenade, TIMER_FLAG_NO_MAPCHANGE);
		}
	}
}

public Action:ChangeGrenadeDamage(Handle:hTimer, any:iEnt)
{	
	SetEntPropFloat(iEnt, Prop_Send, "m_flDamage", 10000.0);
}

public native_granat(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1 || item == -1)
	{
		if(klasa == -1)
		{
			granatKlasa[client] = 0;
		}
		if(item == -1)
		{
			granatItem[client] = 0;
		}
		return;
	}
	
	if(klasa)
	{
		granatKlasa[client] = klasa;
	}
	if(item)
	{
		granatItem[client] = item;
	}
}
