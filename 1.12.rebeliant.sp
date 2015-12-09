#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Class: Rebeliant",
	author = "CSnajper",
	description = "Class dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maKlase[MAXPLAYERS+1] = false;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_mac10");
	PushArrayString(weapons, "weapon_tec9");
	PushArrayString(weapons, "weapon_molotov");
	Cmod_RegisterClass("Rebeliant", "Dzieki lekkiemu wyposazeniu ma zwiekszona grawitacje.", 5, 15, 5, 10, 0, weapons);
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public Cmod_OnClassEnabled(client, classID){
	maKlase[client] = true;
	SetEntityGravity(client, 0.5);
}

public Cmod_OnClassDisabled(client, classID){
	maKlase[client] = false;
	SetEntityGravity(client, 1.0);
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId( GetEventInt(event, "userid") );
	if(maKlase[client])
		SetEntityGravity(client, 0.5);
}
