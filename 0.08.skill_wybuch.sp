#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Skill: Wybuch po Smierci",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

#define BEAMSPRITE_CSGO "materials/sprites/laserbeam.vmt"
#define HALOSPRITE_CSGO "materials/sprites/halo.vmt"

//dzwiek eksplozji
new const String:FULL_SOUND_PATH[] = "sound/cod_csnajper/skills/dynamit_explode.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*cod_csnajper/skills/dynamit_explode.mp3";

new g_beam;
new g_halo;

new wybuchKlasa[MAXPLAYERS+1] = 0;
new wybuchItem[MAXPLAYERS+1] = 0;

public OnPluginStart()
{
	HookEvent("player_death", Event_PlayerDeath);
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Wybuch", native_Wybuch);
	
	return APLRes_Success;
}

public OnMapStart()
{
	//dzwieki
	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
	
	//sprity
	g_beam = PrecacheModel(BEAMSPRITE_CSGO);
	g_halo = PrecacheModel(HALOSPRITE_CSGO);
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public OnClientConnected(client)
{
	wybuchKlasa[client] = 0;
	wybuchItem[client] = 0;
}

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new victim = GetClientOfUserId(GetEventInt(event, "userid") );
	new attacker = GetClientOfUserId(  GetEventInt(event, "attacker") );
	
	if(attacker != victim)
	{
		if(wybuchKlasa[victim] && GetRandomInt(1,wybuchKlasa[victim]) == 1)
		{
			Kamikadze(victim);
		}
		if(wybuchItem[victim] && GetRandomInt(1,wybuchItem[victim]) == 1)
		{
			Kamikadze(victim);
		}
	}
	
	return Plugin_Continue
}

public Action:Kamikadze(client)
{
	decl Float:locationOwner[3], Float:locationPlayer[3];
	GetClientAbsOrigin(client, locationOwner);
	//rozchodzace sie kolo
	TE_SetupBeamRingPoint(locationOwner, 1.0, 300.0, g_beam, g_halo, 0, 15, 0.5, 20.0, 10.0, {255,0,0,33}, 120, 0);
	TE_SendToAll();
	//dzwiek
	EmitSoundToAll(RELATIVE_SOUND_PATH, client);
	
	//czy ktos jest w zasiegu
	for(new i = 1; i <= MaxClients; i++)
	{
		if(!IsClientConnected(i) || GetClientTeam(client) == GetClientTeam(i))
			continue;
		if(!IsPlayerAlive(i))
			continue;
		
		GetClientAbsOrigin(i, locationPlayer);
			
		if(GetVectorDistance(locationOwner, locationPlayer) <= 200.0)
		{
			//obrazenia
			new Float:damage = 100.0 + float(Cmod_GetClientINT(client)  + Cmod_GetClassINT(client) + Cmod_GetBonusINT(client))
			SDKHooks_TakeDamage(i, 0, client, damage, DMG_GENERIC, -1)
		}
	}
}

public native_Wybuch(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1 || item == -1)
	{
		if(klasa == -1)
		{
			wybuchKlasa[client] = 0;
		}
		if(item == -1)
		{
			wybuchItem[client] = 0;
		}
		return;
	}
	
	if(klasa)
		wybuchKlasa[client] = klasa;
	if(item)
		wybuchItem[client] = item;
}

