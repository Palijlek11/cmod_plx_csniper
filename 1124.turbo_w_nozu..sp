#include <sourcemod>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod Item: Turbo w Nozu",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new maPerk[MAXPLAYERS+1] = false
new mocAktywna[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Turbo w Nozu", "Na nozu posiadasz niesamowita szybkosc (+60 kondycji)", 1, 1, 250, INVALID_HANDLE);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maPerk[client] = true;
}

public Cmod_OnItemDisabled(client, itemID){
	maPerk[client] = false;
	if(mocAktywna[client])
		Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) - 60);
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
			Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) + 60)
			mocAktywna[client] = true
		}
		else if(mocAktywna[client])
		{
			Cmod_SetBonusDEX(client, Cmod_GetBonusDEX(client) - 60)
			mocAktywna[client] = false
		}
	}
}
