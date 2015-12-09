#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Class: ",
	author = "CSnajper",
	description = "Class dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maKlase[MAXPLAYERS+1] = false;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_mp9");
	PushArrayString(weapons, "weapon_fiveseven");
	PushArrayString(weapons, "weapon_hegrenade");
	PushArrayString(weapons, "weapon_flashbang");
	PushArrayString(weapons, "weapon_flashbang");
	Cmod_RegisterClass("Preppers", "1/7 szansy na zatrzesienie ekranem wroga przy ataku", 5, 15, 10, 5, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID)
{
	maKlase[client] = true;
	BonusDMG(client, 5, 0);
}

public Cmod_OnClassDisabled(client, classID)
{
	maKlase[client] = false;
	BonusDMG(client, -1, 0);
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
	if(maKlase[attacker])
	{
		if(GetRandomInt(1,7) == 1)
			shake(victim, 3, 40, 70);
		
		return Plugin_Changed;	
	}
	return Plugin_Continue;
}

stock shake(client, time, distance, value)
{
	new Handle:message = StartMessageOne("Shake", client, USERMSG_RELIABLE|USERMSG_BLOCKHOOKS);

	if(GetFeatureStatus(FeatureType_Native, "GetUserMessageType") == FeatureStatus_Available && GetUserMessageType() == UM_Protobuf) 
	{
		PbSetInt(message, "command", 0);
		PbSetFloat(message, "local_amplitude", float(value));
		PbSetFloat(message, "frequency", float(distance));
		PbSetFloat(message, "duration", float(time));
	}
	else
	{
		BfWriteByte(message, 0);
		BfWriteFloat(message, float(value));
		BfWriteFloat(message, float(distance));
		BfWriteFloat(message, float(time));
	}
	
	EndMessage();
	
	return;
}