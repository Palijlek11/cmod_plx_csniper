#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Skill: Miny",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

//#define MINE_MODEL "models/cod_csfifka/mine/w_slam.mdl"

new const String:mine_model[] = "models/lasermine/lasermine.mdl"

//dzwiek eksplozji
new const String:FULL_SOUND_PATH[] = "sound/cod_csnajper/skills/mine_explode.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*cod_csnajper/skills/mine_explode.mp3";

new ExplosionModel;
new iloscMinKlasa[MAXPLAYERS+1] = 0;
new iloscMinItem[MAXPLAYERS+1] = 0;
new pozostaloMin[MAXPLAYERS+1];

new bool:OdpornoscKlasa[MAXPLAYERS+1] = false;
new bool:OdpornoscItem[MAXPLAYERS+1] = false;

public OnPluginStart()
{
	HookEvent("player_spawn", PlayerSpawn);

	RegConsoleCmd("+mina", KladzMine);
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Miny", native_Miny);
	CreateNative("KladzMine", native_KladzMine);
	CreateNative("OdpornoscNaMiny", native_OdpornoscNaMiny);

	return APLRes_Success;
}

public OnMapStart()
{
	AddFileToDownloadsTable( "models/lasermine/lasermine.dx80.vtx" );
	AddFileToDownloadsTable( "models/lasermine/lasermine.dx90.vtx" );
	AddFileToDownloadsTable( "models/lasermine/lasermine.mdl" );
	AddFileToDownloadsTable( "models/lasermine/lasermine.phy" );
	AddFileToDownloadsTable( "models/lasermine/lasermine.vvd" );

	AddFileToDownloadsTable( "materials/models/lasermine/lasermine.vmt" );
	AddFileToDownloadsTable( "materials/models/lasermine/lasermine.vtf" );

	PrecacheModel(mine_model,true);

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
	iloscMinKlasa[client] = 0;
	iloscMinItem[client] = 0;
	pozostaloMin[client] = 0;
}

public Action:PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid"));

	pozostaloMin[client] = (iloscMinKlasa[client] + iloscMinItem[client]);

}

public native_KladzMine(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	KladzMine(client, 0);

}

public Action:KladzMine(client, args)
{
	if(!pozostaloMin[client])
	{
		PrintToChat(client, "Nie masz juz MIN!");
		return;
	}
	if(!IsPlayerAlive(client))
		return;

 	decl Float:Location[3];
	decl Float:Angles[3];
	decl Float:PlayerOrigin[3];

	GetClientAbsOrigin(client, PlayerOrigin);
	GetClientEyeAngles(client, Angles);

	Location[0] = (PlayerOrigin[0] + (10 * Cosine(DegToRad(Angles[1]))));
	Location[1] = (PlayerOrigin[1] + (10 * Sine(DegToRad(Angles[1]))));
	Location[2] = PlayerOrigin[2];

	// create tripmine model
	new ent = CreateEntityByName("prop_physics_override");
	if (ent != -1)
	{
		SetEntityModel(ent, mine_model);
		DispatchSpawn(ent)
		TeleportEntity(ent, Location, NULL_VECTOR, NULL_VECTOR);
		DispatchKeyValue(ent, "TouchType", "4");
		SetEntProp(ent, Prop_Send, "m_usSolidFlags", 12); //FSOLID_NOT_SOLID|FSOLID_TRIGGER
		SetEntProp(ent, Prop_Data, "m_nSolidType", 6); // SOLID_VPHYSICS
		SetEntProp(ent, Prop_Send, "m_CollisionGroup", 1); //COLLISION_GROUP_DEBRIS
		SetEntityMoveType(ent, MOVETYPE_NONE);
		SetEntProp(ent, Prop_Data, "m_MoveCollide", 0);
		SetEntPropEnt(ent, Prop_Send, "m_hOwnerEntity", client);

		SetEntityRenderMode(ent, RENDER_TRANSCOLOR);
		SetEntityRenderColor(ent, 255, 255, 255, 100);

		SDKHook(ent, SDKHook_StartTouch, OnStartTouch); // Hook touch event

		pozostaloMin[client]--;
		PrintToChat(client, "Pozostala ilosc min: %i", pozostaloMin[client]);
	}
}

public OnStartTouch(ent, client)
{
	if (client < 1 || client > MaxClients || !IsClientInGame(client) || !IsValidEntity(client))
		return;

	decl String:classname[32];
	GetEdictClassname(client, classname, sizeof(classname));

	if(StrEqual(classname, "player"))
	{
		new attacker = GetEntPropEnt(ent, Prop_Data, "m_hOwnerEntity", 0);
		if(GetClientTeam(client) != GetClientTeam(attacker))
		{
			if(!OdpornoscKlasa[client] && !OdpornoscItem[client])
			{
				new Float:damage = 80.0 + float(Cmod_GetClientINT(attacker)  + Cmod_GetClassINT(attacker) + Cmod_GetBonusINT(attacker))
				SDKHooks_TakeDamage(client, 0, attacker, damage, DMG_GENERIC, -1)
			}
			decl Float:locationVictim[3];
			GetClientAbsOrigin(client, locationVictim);
			TE_SetupExplosion(locationVictim,ExplosionModel,15.0,10,10,150,150);
			TE_SendToAll();
			EmitSoundToAll(RELATIVE_SOUND_PATH, ent);
			if (IsValidEdict(ent))
				RemoveEdict(ent);
		}
	}
}

public native_Miny(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new ileKlasa = GetNativeCell(2);
	new ileItem = GetNativeCell(3);

	if(ileKlasa == -1 || ileItem == -1)
	{
		if(ileKlasa == -1)
		{
			pozostaloMin[client] = 0;
			iloscMinKlasa[client] = 0;
		}
		if(ileItem == -1)
		{
			if(pozostaloMin[client] >= iloscMinItem[client])
				pozostaloMin[client] -= iloscMinItem[client];
			else pozostaloMin[client] = 0;
			iloscMinItem[client] = 0;
		}
		return;
	}

	if(ileKlasa)
		iloscMinKlasa[client] = ileKlasa;
	if(ileItem)
		iloscMinItem[client] = ileItem;
	pozostaloMin[client] += ileKlasa + ileItem;

}

public native_OdpornoscNaMiny(Handle:plugin, numParams)
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
