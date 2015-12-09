#include <sourcemod>
#include <sdktools>
#include <cmod>

new bool:cichobiegiKlasa[MAXPLAYERS+1] = false;
new bool:cichobiegiItem[MAXPLAYERS+1] = false;

new Handle:TFootstepsEnabledConVar;

public OnPluginStart()
{
	TFootstepsEnabledConVar = FindConVar("sv_footsteps");
	AddNormalSoundHook(Event_SoundPlayed);
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Cichobiegi", native_cichobiegi);
	return APLRes_Success;
}

public OnClientPutInServer(client)
{
	cichobiegiKlasa[client] = false;
	cichobiegiItem[client] = false;
	if(!IsFakeClient(client))
		SendConVarValue(client, TFootstepsEnabledConVar, "0");
}
/*public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	SendConVarValue(client, TFootstepsEnabledConVar, "0");
}*/

public Action:Event_SoundPlayed(clients[64],&numClients,String:sample[PLATFORM_MAX_PATH],&entity,&channel,&Float:volume,&level,&pitch,&flags) 
{
	if (entity && entity <= MaxClients && (StrContains(sample, "physics") != -1 || StrContains(sample, "footsteps") != -1))
	{
		if (IsClientInGame(entity) && (cichobiegiKlasa[entity] || cichobiegiItem[entity]))
		{
			//PrintToChat(entity, "Daje cichobiegi");
			return Plugin_Handled;
		}
		else
		{
			//PrintToChat(entity, "Emituje dzwiek");
			EmitSoundToAll(sample, entity);
			return Plugin_Handled;
		}
	}

	return Plugin_Continue
}

public native_cichobiegi(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1 || item == -1)
	{
		if(klasa == -1)
		{
			cichobiegiKlasa[client] = false;
		}
		if(item == -1)
		{
			cichobiegiItem[client] = false;
		}
		return;
	}
	
	if(klasa)
	{
		cichobiegiKlasa[client] = true;
	}
	if(item)
	{
		cichobiegiItem[client] = true;
	}
}