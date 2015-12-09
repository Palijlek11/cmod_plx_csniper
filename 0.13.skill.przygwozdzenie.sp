#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Skill: Przygwozdzenie",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new przygwozdzenieKlasa[MAXPLAYERS+1] = 0;
new przygwozdzenieItem[MAXPLAYERS+1] = 0;
new bool:przygwozdzony[MAXPLAYERS+1] = false;
new Handle:timer_przygwozdzenie[MAXPLAYERS+1] = INVALID_HANDLE;

//dzwiek eksplozji
new const String:FULL_SOUND_PATH[] = "sound/cod_csnajper/skills/przygwozdzenie.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*cod_csnajper/skills/przygwozdzenie.mp3";

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Przygwozdzenie", native_przygwozdzenie);
	
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
	przygwozdzenieKlasa[client] = 0;
	przygwozdzenieItem[client] = 0;
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
	if(!przygwozdzony[victim])
	{
		if(przygwozdzenieKlasa[attacker])
		{
			if(GetRandomInt(1, przygwozdzenieKlasa[attacker]) == 1)
			{
				EmitSoundToAll(RELATIVE_SOUND_PATH, victim);
				przygwozdzony[victim] = true;
				SetEntityMoveType( victim, MOVETYPE_NONE );
				timer_przygwozdzenie[victim] = CreateTimer(1.0, PrzygwozdzenieStop, victim);
				return Plugin_Continue;
			}
		}
		if(przygwozdzenieItem[attacker])
		{
			if(GetRandomInt(1, przygwozdzenieItem[attacker]) == 1)
			{
				EmitSoundToAll(RELATIVE_SOUND_PATH, victim);
				przygwozdzony[victim] = true;
				SetEntityMoveType( victim, MOVETYPE_NONE );
				timer_przygwozdzenie[victim] = CreateTimer(1.0, PrzygwozdzenieStop, victim);
				return Plugin_Continue;
			}
		}
	}
	
	return Plugin_Continue;
}

public Action:PrzygwozdzenieStop(Handle:timer, any:victim)
{
	przygwozdzony[victim] = false;
	SetEntityMoveType( victim, MOVETYPE_ISOMETRIC );
}

public native_przygwozdzenie(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1 || item == -1)
	{
		if(klasa == -1)
		{
			przygwozdzenieKlasa[client] = 0;
		}
		if(item == -1)
		{
			przygwozdzenieItem[client] = 0;
		}
		return;
	}
	
	if(klasa)
	{
		przygwozdzenieKlasa[client] = klasa;
	}
	if(item)
	{
		przygwozdzenieItem[client] = item;
	}
}
