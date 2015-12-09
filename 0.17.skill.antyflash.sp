#include <sourcemod>
#include <flashtools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Skill: Anty-Flash",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new bool:antyFlashKlasa[MAXPLAYERS+1] = false;
new bool:antyFlashItem[MAXPLAYERS+1] = false;

/*public OnPluginStart()
{
	HookEvent("player_blind", Event_PlayerBlind, EventHookMode_Pre);
}*/

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("AntyFlash", native_antyFlash);
	
	return APLRes_Success;
}

public OnClientConnected(client)
{
	antyFlashKlasa[client] = false;
	antyFlashItem[client] = false;
}

public Action:OnGetPercentageOfFlashForPlayer(client, entity, Float:pos[3], &Float:percent)
{
//	new owner = GetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity");
	//Dont team flash but flash the owner
	if(antyFlashKlasa[client] || antyFlashItem[client])
	{
		return Plugin_Handled;
	}
	
	return Plugin_Continue;
}

/*public Action:Event_PlayerBlind(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	if(antyFlashKlasa[client] || antyFlashItem[client])
		return Plugin_Handled;
		
	return Plugin_Continue;
}*/

public native_antyFlash(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1.0 || item == -1.0)
	{
		if(klasa == -1)
		{
			antyFlashKlasa[client] = false;
		}
		if(item == -1)
		{
			antyFlashItem[client] = false;
		}
		return;
	}
	
	if(klasa)
	{
		antyFlashKlasa[client] = true;
	}
	if(item)
	{
		antyFlashItem[client] = true;
	}
}