#include <sourcemod>
#include <sdkhooks>
#include <cmod>

new VisibilityKlasa[MAXPLAYERS+1] = 0;
new VisibilityItem[MAXPLAYERS+1] = 0;

public OnPluginStart()
{
	HookEvent("player_spawn", Event_PlayerSpawn);
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Visibility", native_Visibility);
	CreateNative("SetVisibility", native_SetVisibility);
	
	return APLRes_Success;
}

public OnClientConnected(client)
{
	VisibilityKlasa[client] = 0;
	VisibilityItem[client] = 0;
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid") );
	
	if(VisibilityKlasa[client] || VisibilityItem[client])
		SetVisability(client);
}

public native_Visibility(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa < 0)
		VisibilityKlasa[client] = 0;
	if(item < 0)
		VisibilityItem[client] = 0;
	
	if(klasa > 0)
		VisibilityKlasa[client] = klasa;
	if(item > 0)
		VisibilityItem[client] = item;

	SetVisability(client);
	
	return;
}

public SetVisability(client)
{
	if(!VisibilityKlasa[client] && !VisibilityItem[client])
	{
		SetEntityRenderMode(client , RENDER_NORMAL);
		SetEntityRenderColor(client, 255, 255, 255, 255);
		return;
	}
	new visibility = 0;
	if(VisibilityKlasa[client] >= VisibilityItem[client])
		visibility = RoundToNearest(255 * VisibilityKlasa[client] * 0.01);
	else if(VisibilityItem[client] > VisibilityKlasa[client])
		visibility = RoundToNearest(255 * VisibilityItem[client] * 0.01);
		
	SetEntityRenderMode(client , RENDER_TRANSCOLOR);
	SetEntityRenderColor(client, 255, 255, 255, visibility);
	
	return;
}

public native_SetVisibility(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);

	SetVisability(client);
	
	return;
}