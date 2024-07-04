#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod class: Cichy",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new bool:maKlase[MAXPLAYERS+1] = false;
new bool:mocAktywna[MAXPLAYERS+1] = false;
new oldButtons[MAXPLAYERS+1] = 0;
new Handle:SkillTimer[MAXPLAYERS+1] = INVALID_HANDLE;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_m4a1_silencer");
	PushArrayString(weapons, "weapon_m4a1");
	PushArrayString(weapons, "weapon_usp_silencer");
	PushArrayString(weapons, "weapon_glock");
	Cmod_RegisterClass("Cichy [Premium]", "Bardzo slabo widoczny gdy kuca", 6, 31, 26, 31, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID)
{
/*	if(!GetAdminFlag(GetUserAdmin(client), Admin_Custom2)){
		PrintToChat(client, "\x01\x0B\x01 \x07%s \x06Klasa dostępna tylko dla posiadaczy Vip'a!", MOD_TAG);
		return CMOD_DISABLE;
	}*/
	maKlase[client] = true;
	
	return CMOD_CONTINUE;
}

public Cmod_OnClassDisabled(client, classID)
{
	maKlase[client] = false;
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{
	if(maKlase[client])
	{
		new button = GetClientButtons(client);
		new String:weapon2[32];
		GetClientWeapon(client, weapon2, 31);
		
		if((button & IN_DUCK) && !(oldButtons[client] & IN_DUCK) && StrEqual(weapon2, "weapon_knife"))
		{
			new weapon_index = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
			SetEntityRenderMode(weapon_index , RENDER_NONE);
			SetEntityRenderMode(client , RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 255, 255, 255, 15);
			UnhandleTimer(client);
			SkillTimer[client] = CreateTimer(10.0, StopInvisibility, client, 0);
			PrintToChat(client, "\x01\x0B\x01 \x04 Niewidzialnosc wlaczona!");
			mocAktywna[client] = true;
		}
		else if(mocAktywna[client] && (!(button & IN_DUCK) || !StrEqual(weapon2, "weapon_knife")))
		{
			StopInv(client);
			UnhandleTimer(client);
		}
		
		oldButtons[client] = button;
	}
	return Plugin_Continue;
}

public Action:StopInvisibility(Handle:timer, any:client)
{
	StopInv(client);
}

public StopInv(client)
{
	if(mocAktywna[client])
	{
		new weapon_index = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
		SetEntityRenderMode(weapon_index , RENDER_NORMAL);
		SetEntityRenderColor(weapon_index, 255, 255, 255, 255);
		SetEntityRenderMode(client , RENDER_NORMAL);
		SetEntityRenderColor(client, 255, 255, 255, 255);
		SkillTimer[client] = INVALID_HANDLE;
		PrintToChat(client, "\x01\x0B\x01 \x02 Niewidzialnosc wylaczona!");
		mocAktywna[client] = false;
	}
	
}

public UnhandleTimer(client)
{
	if(SkillTimer[client] != INVALID_HANDLE)
	{
		KillTimer(SkillTimer[client]);
		SkillTimer[client] = INVALID_HANDLE;
	}
}
