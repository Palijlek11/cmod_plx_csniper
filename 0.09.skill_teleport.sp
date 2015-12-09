#include <sourcemod>
#include <sdkhooks>
#include <sdktools>

public Plugin:myinfo = {
	name = "Cmod Skill: Teleport",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new Float:poprzednieUzycie[MAXPLAYERS+1] = 0.0;
new teleportKlasa[MAXPLAYERS+1] = 0;
new teleportItem[MAXPLAYERS+1] = 0;

//dzwiek eksplozji
new const String:FULL_SOUND_PATH[] = "sound/cod_csnajper/skills/teleport.mp3";
new const String:RELATIVE_SOUND_PATH[] = "*cod_csnajper/skills/teleport.mp3";

public OnPluginStart(){
	HookEvent("player_spawn", Event_PlayerSpawn);
}

public Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid") );
	poprzednieUzycie[client] = 0.0;
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Teleport", native_Teleport);
	
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

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_PreThink, PreThink);
}

public OnClientDisconnect(client)
{
	SDKUnhook(client, SDKHook_PreThink, PreThink);
}

public Action:PreThink(client)
{
	if(teleportKlasa[client] || teleportItem[client])
	{
		new String:weapon[31]
		GetClientWeapon(client, weapon, sizeof(weapon));
		if((GetClientButtons(client) & IN_ATTACK2) && StrEqual(weapon, "weapon_knife"))
		{
			if(poprzednieUzycie[client] < GetGameTime())
			{
				decl Float:Location[3];
				decl Float:Angles[3];
				decl Float:PlayerOrigin[3];
				new Float:EyePos[3];
				
				GetClientAbsOrigin(client, PlayerOrigin);
				GetClientEyeAngles(client, Angles);
				GetClientEyePosition(client, EyePos)
				
				new distance = 300
				Location[0] = (PlayerOrigin[0] + (distance * Cosine(DegToRad(Angles[1]))));
				Location[1] = (PlayerOrigin[1] + (distance * Sine(DegToRad(Angles[1]))));
				Location[2] = (PlayerOrigin[2] + 20);
				
				decl Float:vecMin[3], Float:vecMax[3]
	
				GetClientMins(client, vecMin);
				GetClientMaxs(client, vecMax);
	
				TR_TraceHullFilter(PlayerOrigin, Location, vecMin, vecMax, MASK_ALL, TraceFilter);
				
				if(!TR_DidHit()){
					TeleportEntity(client, Location, NULL_VECTOR, NULL_VECTOR)
					EmitSoundToAll(RELATIVE_SOUND_PATH, client);
				}
				poprzednieUzycie[client] = GetGameTime() + 3.0;
			}
		}
	}
}
/*tele(client){
	new Float:OwnerAng[3];
	GetClientEyeAngles(client, OwnerAng);
	
	new Float:OwnerPos[3];
	GetClientEyePosition(client, OwnerPos)
	
	TR_TraceRayFilter(OwnerPos, OwnerAng, MASK_PLAYERSOLID, RayType_Infinite, DontHitOwnerOrNade, client);
	
	new Float:InitialPos[3];
	TR_GetEndPosition(InitialPos);
	
	TeleportEntity(client, InitialPos, NULL_VECTOR, NULL_VECTOR);
}*/

public bool:DontHitOwnerOrNade(entity, contentsMask, any:data)
{
	return (entity != data);
}

public bool:FilterOutPlayer(entity, contentsMask, any:data)
{
	if (entity == data)
	{
		return false;
	}
	return true;
}

//is player stuck?
stock bool:CheckIfPlayerIsStuck(iClient)
{
	decl Float:vecMin[3], Float:vecMax[3], Float:vecOrigin[3];
	
	GetClientMins(iClient, vecMin);
	GetClientMaxs(iClient, vecMax);
	GetClientAbsOrigin(iClient, vecOrigin);
	
	TR_TraceHullFilter(vecOrigin, vecOrigin, vecMin, vecMax, MASK_SOLID, TraceEntityFilterSolid);
	return TR_DidHit();	// head in wall ?
}

public bool:TraceEntityFilterSolid(entity, contentsMask)
{
	return false;
}

public bool:TraceFilter(entity, mask, any:data) {
	if(entity>0 && entity <=MAXPLAYERS)
		return false;
	new String:buf[10];
	if(GetEdictClassname(entity, buf, sizeof(buf))){
		if(!StrContains(buf, "weapon_") || !StrContains(buf, "item_")){
			return false;
		}
	}
	return true;
}

public native_Teleport(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1 || item == -1)
	{
		if(klasa == -1)
		{
			teleportKlasa[client] = 0;
		}
		if(item == -1)
		{
			teleportItem[client] = 0;
		}
		return;
	}
	
	if(klasa)
		teleportKlasa[client] = 1;
	if(item)
		teleportItem[client] = 1;
}