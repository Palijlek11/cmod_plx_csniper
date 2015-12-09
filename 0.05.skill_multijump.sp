#include <sourcemod>
#include <sdktools>

public Plugin:myinfo = {
	name = "Cmod Skill: Multi-Jump",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new ileSkokowKlasa[MAXPLAYERS+1] = 0;
new ileSkokowItem[MAXPLAYERS+1] = 0;
new maxSkokow[MAXPLAYERS+1] = 0;
new	g_fLastButtons[MAXPLAYERS+1];
new	g_fLastFlags[MAXPLAYERS+1];
new	Float:g_flBoost	= 250.0;

new jump_left[MAXPLAYERS+1] = 0;

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("Skoki", native_Skoki);
	
	return APLRes_Success;
}

public native_Skoki(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new ileKlasa = GetNativeCell(2);
	new ileItem = GetNativeCell(3);
	
	if(ileKlasa == -1 || ileItem == -1)
	{
		if(ileKlasa == -1)
		{
			ileSkokowKlasa[client] = 0;
		}

		if(ileItem == -1)
		{
			ileSkokowItem[client] = 0;
		}
		maxSkokow[client] = ileSkokowKlasa[client] + ileSkokowItem[client];
		return;
	}
	
	if(ileKlasa > 0)
		ileSkokowKlasa[client] = ileKlasa;
	if(ileItem > 0)
		ileSkokowItem[client] = ileItem;
	maxSkokow[client] = ileSkokowKlasa[client] + ileSkokowItem[client];
	jump_left[client] = maxSkokow[client]
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon)
{
	new fCurFlags = GetEntityFlags(client)
	
	if(maxSkokow[client])
	{
		if((buttons & IN_JUMP) && !(fCurFlags & FL_ONGROUND) && !(g_fLastButtons[client] & IN_JUMP) && jump_left[client] > 0)
		{
			jump_left[client]--
			decl Float:vVel[3]
			GetEntPropVector(client, Prop_Data, "m_vecVelocity", vVel)
			vVel[2] = g_flBoost
			TeleportEntity(client, NULL_VECTOR, NULL_VECTOR, vVel)
		}
		else if(fCurFlags & FL_ONGROUND)
		{
			jump_left[client] = maxSkokow[client]
		}
		
		g_fLastFlags[client] = fCurFlags
		g_fLastButtons[client]	= buttons
	}
	
	return Plugin_Continue;
}