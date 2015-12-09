#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Kamuflaz Predatora",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;
new bool:uzylPerku[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Kamuflaz Predatora", "Uzyj [E] aby stac sie niewidzialnym na 5 sekund", 1, 1, 250, INVALID_HANDLE);
	
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
	uzylPerku[client] = false;
}

public Cmod_OnItemDisabled(client, itemID){
	maPerk[client] = false;
	uzylPerku[client] = false;
	SetVisibility(client);
}

public Cmod_OnClientUseItem(client, itemID){
	if(!uzylPerku[client])
		PredatorStart(client);
}

public PredatorStart(client)
{
	SetEntityRenderMode(client , RENDER_TRANSCOLOR);
	SetEntityRenderColor(client, 255, 255, 255, 0);
	
	CreateTimer(5.0, PredatorStop, client);
	
	PrintToChat(client, "\x01\x0B\x04Kamuflaz wlaczony!");
}

public Action:PredatorStop(Handle:Timer, any:client)
{
	PrintToChat(client, "\x01\x0B\x02Kamuflaz wylaczony!");
	SetVisibility(client);
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid") );
	
	if(maPerk[client])
	{
		uzylperku[client] = false;
		SetVisibility(client);
	}
	
}