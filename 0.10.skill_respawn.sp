#include <sourcemod>
#include <cstrike>
#include <sdktools>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Skill: Odrodzenie",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

//dzwiek eksplozji
new const String:FULL_SOUND_PATH[] = "sound/cod_csnajper/skills/odrodzenie.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*cod_csnajper/skills/odrodzenie.mp3";

new respawnKlasa[MAXPLAYERS+1] = 0;
new respawnItem[MAXPLAYERS+1] = 0;

public OnPluginStart()
{
	HookEvent("player_death", Event_PlayerDeath);
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Respawn", native_respawn);
	
	return APLRes_Success;
}

public OnMapStart()
{
	//dzwieki
	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public OnClientConnected(client)
{
	respawnKlasa[client] = 0;
	respawnItem[client] = 0;
}

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid") );
	
	if(victim)
	{
		if(respawnKlasa[victim])
		{
			if(GetRandomInt(1, respawnKlasa[victim]) == 1)
			{
				CreateTimer(0.1, RespGracza, victim);
				return Plugin_Continue;
			}
		}
		if(respawnItem[victim])
		{
			if(GetRandomInt(1, respawnItem[victim]) == 1)
			{
				CreateTimer(0.1, RespGracza, victim);
				return Plugin_Continue;
			}
		}
	}
	return Plugin_Continue;
}

public Action:RespGracza(Handle:timer, any:victim)
{
	CS_RespawnPlayer(victim);
	
	return Plugin_Continue;
}

public native_respawn(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1 || item == -1)
	{
		if(klasa == -1)
		{
			respawnKlasa[client] = 0;
		}
		if(item == -1)
		{
			respawnItem[client] = 0;
		}
		return;
	}
	
	if(klasa)
		respawnKlasa[client] = klasa;
	if(item)
		respawnItem[client] = item;
}

