#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

new const String:medkit_model[] = "models/items/healthkit.mdl"

#define BEAMSPRITE_CSGO "materials/sprites/laserbeam.vmt"
#define HALOSPRITE_CSGO "materials/sprites/halo.vmt"


//static const String:g_HealthKit_Model[7][] = { "models/props/cs_italy/chianti02.mdl" , "models/chicken/chicken.mdl" , "models/props_urban/life_ring001.mdl" , "models/items/medkit_small.mdl" , "models/items/medkit_large.mdl" , "models/items/HealthKit.mdl" , "models/items/cs_gift.mdl" }
public Plugin:myinfo = {
	name = "Cmod skill: Apteczka",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new g_beam;
new g_halo;
new Float:poprzednieUzycie[MAXPLAYERS+1] = 0.0;
new pozostaloApteczek[MAXPLAYERS+1] = 0;
new iloscApteczekKlasa[MAXPLAYERS+1] = 0;
new iloscApteczekItem[MAXPLAYERS+1] = 0;

public OnPluginStart()
{
	HookEvent("player_spawn", PlayerSpawn);

	RegConsoleCmd("+apteczka", StworzApteczke);
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Apteczki", native_Apteczki);
	CreateNative("StworzApteczke", native_StworzApteczke);

	return APLRes_Success;
}

public OnMapStart()
{
	g_beam = PrecacheModel(BEAMSPRITE_CSGO);
	g_halo = PrecacheModel(HALOSPRITE_CSGO);

	AddFileToDownloadsTable("models/items/healthkit.dx80.vtx")
	AddFileToDownloadsTable("models/items/healthkit.dx90.vtx")
	AddFileToDownloadsTable("models/items/healthkit.mdl")
	AddFileToDownloadsTable("models/items/healthkit.phy")
	AddFileToDownloadsTable("models/items/healthkit.sw.vtx")
	AddFileToDownloadsTable("models/items/healthkit.vvd")

	PrecacheModel(medkit_model,true)


//	if ( !IsModelPrecached(medkit_model) ) PrecacheModel(medkit_model);
//	AddFileToDownloadsTable( medkit_model );
}

public OnClientConnected(client)
{
	iloscApteczekKlasa[client] = 0;
	iloscApteczekItem[client] = 0;
	pozostaloApteczek[client] = 0;
}

public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	pozostaloApteczek[client] = (iloscApteczekKlasa[client] + iloscApteczekItem[client]);

}

public native_StworzApteczke(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	StworzApteczke(client, 0);
}

public Action:StworzApteczke(client, args)
{
	if(!IsPlayerAlive(client))
		return;
	if(!pozostaloApteczek[client])
	{
		PrintToChat(client, "Nie masz juz APTECZEK!");
		return;
	}

	if(poprzednieUzycie[client] > GetGameTime())
	{
		PrintToChat(client, "Apteczki mozna uzyc raz na 4 sek.");
		return;
	}

	decl Float:Location[3];
	decl Float:Angles[3];
	decl Float:PlayerOrigin[3];

	GetClientAbsOrigin(client, PlayerOrigin);
	GetClientEyeAngles(client, Angles);

	Location[0] = (PlayerOrigin[0] + (10 * Cosine(DegToRad(Angles[1]))));
	Location[1] = (PlayerOrigin[1] + (10 * Sine(DegToRad(Angles[1]))));
	Location[2] = PlayerOrigin[2]

	decl ent;
	ent = CreateEntityByName("prop_dynamic_override");

	if(ent != -1)
	{
		DispatchKeyValue(ent, "model", medkit_model);

		DispatchSpawn(ent);

		TeleportEntity(ent, Location, NULL_VECTOR, NULL_VECTOR);

		new Handle:data;
		CreateDataTimer(1.0, Lecz, data, TIMER_REPEAT);
		WritePackCell(data, client);
		WritePackCell(data, ent);

		poprzednieUzycie[client] = GetGameTime() + 4.0

		pozostaloApteczek[client]--;
		PrintToChat(client, "Pozostala liczba apteczek: %i", pozostaloApteczek[client]);
	}
}

public Action:Lecz(Handle:timer, Handle:data)
{
	static numPrinted = 0;

	new client;
	new ent;

	ResetPack(data);
	client = ReadPackCell(data);
	ent = ReadPackCell(data);

	if (numPrinted >= 4) {
		numPrinted = 0;
		if (IsValidEdict(ent))
		{
			SetEntityRenderMode(ent, RENDER_TRANSCOLOR);
			SetEntityRenderColor(ent, 255, 255, 255, 100);
			RemoveEdict(ent);
		}
		return Plugin_Stop;
	}

	new Float: locationEnt[3], Float:locationPlayer[3], Float:locationOwner[3];
	GetEntPropVector(ent, Prop_Send, "m_vecOrigin", locationEnt);
	GetClientAbsOrigin(client, locationOwner);
//	GetEntAbsOrigin(ent, locationEnt2);


	//rozchodzace sie kolo
	TE_SetupBeamRingPoint(locationEnt, 1.0, 300.0, g_beam, g_halo, 0, 15, 0.5, 20.0, 10.0, {100,255,100,33}, 120, 0);
	TE_SendToAll();

	for(new i = 1; i <= MaxClients; i++)
	{
		if(!IsClientConnected(i) || GetClientTeam(client) != GetClientTeam(i))
			continue;
		if(!IsPlayerAlive(i))
			continue;

		GetClientAbsOrigin(i, locationPlayer);

		if(GetVectorDistance(locationEnt, locationPlayer) <= 300.0)
		{
			//dodatkowe hp
			new hp = GetClientHealth(i) + 15 + (Cmod_GetClientINT(client)  + Cmod_GetClassINT(client) + Cmod_GetBonusINT(client))/2
			new maxHp = 100 + Cmod_GetClientCON(i)  + Cmod_GetClassCON(i) + Cmod_GetBonusCON(i)
			if(hp > maxHp)
				SetEntData(i, FindDataMapOffs(i, "m_iHealth"), maxHp, 4, true);
			else
				SetEntData(i, FindDataMapOffs(i, "m_iHealth"), hp, 4, true);
		}
	}

	numPrinted++;

	return Plugin_Continue;
}

public native_Apteczki(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new ileKlasa = GetNativeCell(2);
	new ileItem = GetNativeCell(3);

	if(ileKlasa == -1 || ileItem == -1)
	{
		if(ileKlasa == -1)
		{
			pozostaloApteczek[client] = 0;
			iloscApteczekKlasa[client] = 0;
		}
		if(ileItem == -1)
		{
			if(pozostaloApteczek[client] >= iloscApteczekItem[client])
				pozostaloApteczek[client] -= iloscApteczekItem[client];
			else pozostaloApteczek[client] = 0;
			iloscApteczekItem[client] = 0;
		}
		return;
	}

	if(ileKlasa)
		iloscApteczekKlasa[client] = ileKlasa;
	if(ileItem)
		iloscApteczekItem[client] = ileItem;
	pozostaloApteczek[client] += ileKlasa + ileItem;

}
