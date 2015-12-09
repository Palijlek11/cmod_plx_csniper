#include <sdkhooks>
#include <cstrike>
#include <sdktools>

public Plugin:myinfo = {
	name = "Cmod Skill: Ubranie Wroga",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new ubranieWrogaKlasa[MAXPLAYERS+1] = 0;
new ubranieWrogaItem[MAXPLAYERS+1] = 0;

#define MAX_SKINS_CT 7
#define MAX_SKINS_TT 4

new String:SkinyCT[MAX_SKINS_CT][] = {"models/player/ctm_fbi.mdl", "models/player/ctm_gign.mdl", "models/player/ctm_gsg9.mdl", "models/player/ctm_idf.mdl", "models/player/ctm_sas.mdl", "models/player/ctm_st6.mdl", "models/player/ctm_swat.mdl"};
new String:SkinyTT[MAX_SKINS_TT][] = {"models/player/tm_leet_variantd.mdl", "models/player/tm_leet_varianta.mdl", "models/player/tm_leet_varianta.mdl", "models/player/tm_phoenix_variantb.mdl"};

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("ZmienUbranie", native_ubranieWroga);
	
	HookEvent("player_spawn", OnPlayerSpawn, EventHookMode_Post);
	
	return APLRes_Success;
}

public OnMapStart()
{
	new i;
	for(i = 0; i < MAX_SKINS_CT; i++)
	{
		PrecacheModel(SkinyCT[i],true);
	}
	for(i = 0; i < MAX_SKINS_TT; i++)
	{
		PrecacheModel(SkinyTT[i],true);
	}
}

public OnClientConnected(client)
{
	ubranieWrogaKlasa[client] = 0;
	ubranieWrogaItem[client] = 0;
}

public OnPlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	// Get real player index from event key
	new client = GetClientOfUserId(GetEventInt(event, "userid"));
	// Does plugin is enabled?
	if(ubranieWrogaKlasa[client] || ubranieWrogaItem[client])
	{
		ZmienUbranie(client);
	}
}

public Action:ZmienUbranie(client)
{
	if (IsPlayerAlive(client))
	{
		new team  = GetClientTeam(client);
		// Get same random number for using same arms and skin
		new random = 0;
		// Set skin depends on client's team
		switch (team)
		{
			case CS_TEAM_T: // Terrorists
			{
				random = GetRandomInt(0, MAX_SKINS_CT);
				SetEntityModel(client, SkinyCT[random]);
			}
			case CS_TEAM_CT: // Counter-Terrorists
			{
				random = GetRandomInt(0, MAX_SKINS_TT);
				SetEntityModel(client, SkinyTT[random]);
			}
		}
	}
}

public native_ubranieWroga(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new ileKlasa = GetNativeCell(2);
	new ileItem = GetNativeCell(3);
	
	if(ileKlasa == -1 || ileItem == -1)
	{
		if(ileKlasa == -1)
		{
			ubranieWrogaKlasa[client] = 0;
		}
		if(ileItem == -1)
		{
			ubranieWrogaItem[client] = 0;
		}
		return;
	}
	
	if(ileKlasa)
		ubranieWrogaKlasa[client] = ileKlasa;	
	if(ileItem)
		ubranieWrogaItem[client] = ileItem;
	if(ubranieWrogaKlasa[client] || ubranieWrogaItem[client])
	{
		ZmienUbranie(client);
	}
}