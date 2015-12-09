#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Kamuflaz Specjalisty",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maPerk[MAXPLAYERS+1] = false;
new Handle:timer_ustaw_hp[MAXPLAYERS+1] = INVALID_HANDLE;
new mocAktywna[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Kamuflaz Specjalisty", "Jestes calkowicie niewidoczny na nozu, masz 10HP", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
	timer_ustaw_hp[client] = CreateTimer(1.0, UstawHP, client, TIMER_REPEAT);
}

public Cmod_OnItemDisabled(client, itemID){
	maPerk[client] = false;
	if(timer_ustaw_hp[client] != INVALID_HANDLE)
	{
		KillTimer(timer_ustaw_hp[client]);
		timer_ustaw_hp[client] = INVALID_HANDLE;
	}
	SetVisibility(client);
}

public Action:UstawHP(Handle:timer, any:client)
{
	SetEntData(client, FindDataMapOffs(client, "m_iHealth"), 10, 4, true);
}

public OnClientPutInServer(client)
{
	SDKHook(client, SDKHook_WeaponSwitchPost, WeaponSwitchPost);
}

public OnClientDisconnect(client)
{
	SDKUnhook(client, SDKHook_WeaponSwitchPost, WeaponSwitchPost);
}

public WeaponSwitchPost(client, weapon)
{
	new String:weapon2[31] 
	GetClientWeapon(client,weapon2,30)
	if(maPerk[client])
	{
		if(StrEqual(weapon2, "weapon_knife") && !mocAktywna[client])
		{
			SetEntityRenderMode(client , RENDER_TRANSCOLOR);
			SetEntityRenderColor(client, 255, 255, 255, 5);
			mocAktywna[client] = true;
		}
		else if(mocAktywna[client])
		{
			SetVisibility(client);
			mocAktywna[client] = false;
		}
	}
}