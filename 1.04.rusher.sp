#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod class: Lekki Snajper",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new m_hActiveWeapon, m_iClip1;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_xm1014");
	PushArrayString(weapons, "weapon_tec9");
	PushArrayString(weapons, "weapon_hegrenade");
	PushArrayString(weapons, "weapon_flashbang");
	Cmod_RegisterClass("Rusher", "Nieskonczona amunicja w XM1014", 0, 30, 0, 35, 0, weapons);
	m_hActiveWeapon      = FindSendPropOffsEx("CBasePlayer",       "m_hActiveWeapon");
	m_iClip1             = FindSendPropOffsEx("CBaseCombatWeapon", "m_iClip1");
	HookEvent("weapon_fire", Event_WeaponFire);
}

public Cmod_OnClassEnabled(client, classID)
{

}

public Cmod_OnClassDisabled(client, classID)
{
	
}

//nieskonczone ammo
public Event_WeaponFire(Handle:event, const String:name[], bool:dontBroadcast)
{
	new clientiID = GetEventInt(event, "userid");
	new client = GetClientOfUserId( clientiID );
	new String:weapon[31];
	GetClientWeapon(client, weapon, 30);
	if(StrEqual(weapon, "weapon_xm1014") && IsPlayerAlive(client))
	{
		CreateTimer(0.1, Timer_PostEquip, clientiID, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public Action:Timer_PostEquip(Handle:timer, any:data)
{
	new client = data;

	// Always validate client from delayed callbacks (timers etc...)
	if ((client = GetClientOfUserId(client)))
	{
		// Get the active player weapon and set its ammo appropriately
		new weapon = GetEntDataEnt2(client, m_hActiveWeapon);
		//SetWeaponClip(weapon, weapontype:replen);
		SetEntData(weapon, m_iClip1, 7);
	}
}

FindSendPropOffsEx(const String:serverClass[64], const String:propName[64])
{
	new offset = FindSendPropOffs(serverClass, propName);

	// Disable plugin if a networkable send property offset was not found
	if (offset <= 0)
	{
		SetFailState("Unable to find offset \"%s::%s\"!", serverClass, propName);
	}

	return offset;
}