#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Biblia",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Biblia", "Za każde zabicie dodatkowe 100 expa", 1, 1, 250, INVALID_HANDLE);
	HookEvent("player_death", Event_PlayerDeath, EventHookMode_Post);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
}

public Cmod_OnItemDisabled(client, itemID){
	maPerk[client] = false;
}

public Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(  GetEventInt(event, "attacker") );
	if(maPerk[attacker])
	{
		new exp = Cmod_GetClientExp(attacker) + 100;
		Cmod_SetClientExp(attacker, exp);
	}
}