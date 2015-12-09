#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <smlib>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Skill: Rakiety",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

//#define ROCKET_MODEL "models/cod_angelskill/rakieta/rakieta.mdl"

new const String:rocket_model[] = "models/weapons/w_missile_closed.mdl"

//dzwiek eksplozji
new const String:FULL_SOUND_PATH[] = "sound/cod_csnajper/skills/rocket_explode.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*cod_csnajper/skills/rocket_explode.mp3";

new const Float:g_fSpin[3] = {0.0, 0.0, 0.0};
new const Float:g_fMinS[3] = {-24.0, -24.0, -24.0};
new const Float:g_fMaxS[3] = {24.0, 24.0, 24.0};

new ExplosionModel;
new iloscRakietKlasa[MAXPLAYERS+1] = 0;
new iloscRakietItem[MAXPLAYERS+1] = 0;
new pozostaloRakiet[MAXPLAYERS+1] = 0;
new Float:poprzednieUzycie[MAXPLAYERS+1];

new bool:OdpornoscKlasa[MAXPLAYERS+1] = false;
new bool:OdpornoscItem[MAXPLAYERS+1] = false;

public OnPluginStart()
{
	HookEvent("player_spawn", PlayerSpawn);

	RegConsoleCmd("+rakieta", StworzRakiete);
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Rakiety", native_Rakiety);
	CreateNative("StworzRakiete", native_StworzRakiete);
	CreateNative("OdpornoscNaRakiety", native_OdpornoscNaRakiety);

	return APLRes_Success;
}

public OnMapStart()
{
	AddFileToDownloadsTable("materials/models/weapons/w_missile/missile_side.vmt");

	AddFileToDownloadsTable("models/weapons/W_missile_closed.dx80.vtx");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.dx90.vtx");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.mdl");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.phy");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.sw.vtx");
	AddFileToDownloadsTable("models/weapons/W_missile_closed.vvd");

	PrecacheModel(rocket_model,true)

	ExplosionModel=PrecacheModel("materials/sprites/zerogxplode.vmt",false);

	AddFileToDownloadsTable( FULL_SOUND_PATH );
	FakePrecacheSound( RELATIVE_SOUND_PATH );
}

stock FakePrecacheSound( const String:szPath[] )
{
	AddToStringTable( FindStringTable( "soundprecache" ), szPath );
}

public OnClientConnected(client)
{
	iloscRakietKlasa[client] = 0;
	iloscRakietItem[client] = 0;
	pozostaloRakiet[client] = 0;
}

public PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	pozostaloRakiet[client] = (iloscRakietKlasa[client] + iloscRakietItem[client]);

}

public native_StworzRakiete(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	StworzRakiete(client, 0);

}

public Action:StworzRakiete(client, args)
{
	if(!pozostaloRakiet[client])
	{
		PrintToChat(client, "Nie masz juz rakiet!");
		return;
	}
	if(!IsPlayerAlive(client))
		return;
	if(poprzednieUzycie[client] > GetGameTime())
	{
		PrintToChat(client, "Rakiety mozna uzywac co 3 sek.");
		return;
	}

	static Float:fPos[3], Float:fAng[3], Float:fVel[3], Float:fPVel[3];
	GetClientEyePosition(client, fPos);
	// simple noblock fix. prevent throw if it will spawn inside another client
	if (IsClientIndex(GetTraceHullEntityIndex(fPos, client)))
		return;

	new Float: g_fVelocity = 900.0// + 250.0// * 3.0;

	// create & spawn entity. set model & owner. set to kill itself OnUser1
	// calc & set spawn position, angle, velocity & spin
	// add to lethal knife array, teleport, add trial, ...
	new entity = CreateEntityByName("hegrenade_projectile");
	if ((entity != -1) && DispatchSpawn(entity))
	{
		SetEntityModel(entity, rocket_model);
		SetEntPropEnt(entity, Prop_Send, "m_hOwnerEntity", client);
		SetEntityMoveType( entity, MOVETYPE_FLY );
		GetClientEyeAngles(client, fAng);
		GetAngleVectors(fAng, fVel, NULL_VECTOR, NULL_VECTOR);
		ScaleVector(fVel, g_fVelocity);
		GetEntPropVector(client, Prop_Data, "m_vecVelocity", fPVel);
		AddVectors(fVel, fPVel, fVel);
		SetEntPropVector(entity, Prop_Data, "m_vecAngVelocity", g_fSpin);
		SetEntPropFloat(entity, Prop_Send, "m_flElasticity", 0.0);
		TeleportEntity(entity, fPos, fAng, fVel);
		SDKHook(entity, SDKHook_StartTouch, OnStartTouch); // Hook touch event

		poprzednieUzycie[client] = GetGameTime() + 3.0
		pozostaloRakiet[client]--;
		PrintToChat(client, "Pozostala ilosc rakiet: %i", pozostaloRakiet[client]);
	}
}

GetTraceHullEntityIndex(Float:pos[3], xindex) {

	TR_TraceHullFilter(pos, pos, g_fMinS, g_fMaxS, MASK_SHOT, THFilter, xindex);
	return TR_GetEntityIndex();
}

public OnStartTouch(ent, client)
{
	new attacker = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity", 0);
	decl Float:locationPlayer[3];
	new Float:locationEnt[3];
	GetEntPropVector(ent, Prop_Send, "m_vecOrigin", locationEnt);

	//czy ktos jest w zasiegu
	for(new i = 1; i <= MaxClients; i++)
	{
		if(!IsClientConnected(i) || GetClientTeam(attacker) == GetClientTeam(i) || OdpornoscKlasa[i] || OdpornoscItem[i])
			continue;
		if(!IsPlayerAlive(i))
			continue;

		GetClientAbsOrigin(i, locationPlayer);

		if(GetVectorDistance(locationEnt, locationPlayer) <= 180.0)
		{
			//obrazenia
			new Float:damage = 65.0 + float(Cmod_GetClientINT(attacker)  + Cmod_GetClassINT(attacker) + Cmod_GetBonusINT(attacker))
			SDKHooks_TakeDamage(i, 0, attacker, damage, DMG_GENERIC, -1);
		}
	}

	TE_SetupExplosion(locationEnt,ExplosionModel,15.0,10,10,150,150);
	TE_SendToAll();
	EmitSoundToAll(RELATIVE_SOUND_PATH, ent);

	if (IsValidEdict(ent))
		RemoveEdict(ent);
}

public bool:THFilter(entity, contentsMask, any:data)
{
	return IsClientIndex(entity) && (entity != data);
}

bool:IsClientIndex(index) {

	return (index > 0) && (index <= MaxClients);
}

public native_Rakiety(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new ileKlasa = GetNativeCell(2);
	new ileItem = GetNativeCell(3);

	if(ileKlasa == -1 || ileItem == -1)
	{
		if(ileKlasa == -1)
		{
			pozostaloRakiet[client] = 0;
			iloscRakietKlasa[client] = 0;
		}
		if(ileItem == -1)
		{
			if(pozostaloRakiet[client] >= iloscRakietItem[client])
				pozostaloRakiet[client] -= iloscRakietItem[client];
			else pozostaloRakiet[client] = 0;
			iloscRakietItem[client] = 0;
		}
		return;
	}

	if(ileKlasa)
		iloscRakietKlasa[client] = ileKlasa;
	if(ileItem)
		iloscRakietItem[client] = ileItem;
	pozostaloRakiet[client] += ileKlasa + ileItem;

}

public native_OdpornoscNaRakiety(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new Klasa = GetNativeCell(2);
	new Item = GetNativeCell(3);

	if(Klasa == -1)
	{
		OdpornoscKlasa[client] = false;
	}
	if(Item == -1)
	{
		OdpornoscItem[client] = false;
	}

	if(Klasa == 1)
		OdpornoscKlasa[client] = true;
	if(Item == 1)
		OdpornoscItem[client] = true;

}
