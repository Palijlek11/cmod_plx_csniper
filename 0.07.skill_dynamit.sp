#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Skill: Dynamit",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

//dzwiek eksplozji
new const String:FULL_SOUND_PATH[] = "sound/cod_csnajper/skills/dynamit_explode.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*cod_csnajper/skills/dynamit_explode.mp3";
//dzwiek lvl up
new const String:FULL_SOUND_LVLUP[] = "sound/cod_csnajper/skills/csnajper_up.mp3";
new const String:RELATIVE_SOUND_LVLUP[] = "*cod_csnajper/skills/csnajper_up.mp3";

new ExplosionModel;
new iloscDynamitowKlasa[MAXPLAYERS+1] = 0;
new iloscDynamitowItem[MAXPLAYERS+1] = 0;
new pozostaloDynamitow[MAXPLAYERS+1] = 0;
new Float:poprzednieUzycie[MAXPLAYERS+1];

public OnPluginStart()
{
	HookEvent("player_spawn", PlayerSpawn);
	RegConsoleCmd( "+dynamit", PolozDynamit );
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Dynamit", native_Dynamit);
	CreateNative("PolozDynamit", native_PolozDynamit);
	
	return APLRes_Success;
}

public OnMapStart()
{
	ExplosionModel=PrecacheModel("materials/sprites/zerogxplode.vmt",false);
	
	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
	//dzwiek lvl up
	AddFileToDownloadsTable( FULL_SOUND_LVLUP );
	FakePrecacheSound( RELATIVE_SOUND_LVLUP );
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}



public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	
	pozostaloDynamitow[client] = (iloscDynamitowKlasa[client] + iloscDynamitowItem[client]);
	
}

public native_PolozDynamit(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	PolozDynamit(client, 0);
}

public Action:PolozDynamit(client, args)
{
	if(!pozostaloDynamitow[client])
	{
		PrintToChat(client, "Nie masz juz DYNAMITU!");
		return;
	}
	if(!IsPlayerAlive(client))
		return;
	if(poprzednieUzycie[client] > GetGameTime())
	{
		PrintToChat(client, "Dynamitu mozna uzywac co 3 sek.");
		return;
	}
	
	decl Float:locationOwner[3], Float:locationPlayer[3];
	GetClientAbsOrigin(client, locationOwner);
	TE_SetupExplosion(locationOwner,ExplosionModel,15.0,10,10,200,200);
	TE_SendToAll();
	//dzwiek
	EmitSoundToAll(RELATIVE_SOUND_PATH, client);
	
	//czy ktos jest w zasiegu
	for(new i = 1; i <= MaxClients; i++)
	{
		if(!IsClientInGame(i) || GetClientTeam(client) == GetClientTeam(i))
			continue;
		if(!IsPlayerAlive(i))
			continue;
		
		GetClientAbsOrigin(i, locationPlayer);
			
		if(GetVectorDistance(locationOwner, locationPlayer) <= 200.0)
		{
			//obrazenia
			new Float:damage = 80.0 + float(Cmod_GetClientINT(client)  + Cmod_GetClassINT(client) + Cmod_GetBonusINT(client));
			SDKHooks_TakeDamage(i, 0, client, damage, DMG_GENERIC, -1);
		}
	}
	poprzednieUzycie[client] = GetGameTime() + 3.0
	pozostaloDynamitow[client]--;
	PrintToChat(client, "Pozostala ilosc dynamitu: %i", pozostaloDynamitow[client]);
}

public native_Dynamit(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new ileKlasa = GetNativeCell(2);
	new ileItem = GetNativeCell(3);
	
	if(ileKlasa == -1 || ileItem == -1)
	{
		if(ileKlasa == -1)
		{
			pozostaloDynamitow[client] = 0;
			iloscDynamitowKlasa[client] = 0;
		}
		if(ileItem == -1)
		{
			if(pozostaloDynamitow[client] >= iloscDynamitowItem[client])
				pozostaloDynamitow[client] -= iloscDynamitowItem[client];
			else pozostaloDynamitow[client] = 0;
			iloscDynamitowItem[client] = 0;
		}
		return;
	}
	
	if(ileKlasa)
		iloscDynamitowKlasa[client] = ileKlasa;
	if(ileItem)
		iloscDynamitowItem[client] = ileItem;
	pozostaloDynamitow[client] += ileKlasa + ileItem;

}