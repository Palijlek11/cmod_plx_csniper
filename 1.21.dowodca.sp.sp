#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Class: Dowodca",
	author = "CSnajper",
	description = "Class dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

new bool:maKlase[MAXPLAYERS+1] = false;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_m4a1");
	PushArrayString(weapons, "weapon_fiveseven");
	PushArrayString(weapons, "weapon_smokegrenade");
	PushArrayString(weapons, "weapon_hegrenade");
	Cmod_RegisterClass("Dowodca", "1/4 szansy na 2x dmg przy headshocie. Gdy trafi z Smoke w przeciwnika, zabijasz go", 5, 10, 15, 11, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID){
	maKlase[client] = true;
}

public Cmod_OnClassDisabled(client, classID){
	maKlase[client] = false;
}

public OnClientPutInServer(client) {
	SDKHook(client, SDKHook_TraceAttack, TraceAttack);
}

public Action:TraceAttack(victim, &attacker, &inflictor, &Float:damage, &damagetype, &ammotype, hitbox, hitgroup) {
	if(maKlase[attacker])
	{
		if(hitgroup == 1 && GetRandomInt(1,4) == 1){
			damage *= 2.0;
			return Plugin_Changed;
		}
	}
	return Plugin_Continue;
}

public OnEntityCreated(iEntity, const String:classname[]) 
{
    new iGrenade = iEntity;
    if(StrEqual(classname, "smokegrenade_projectile")) 
    {    
        SDKHook(iGrenade, SDKHook_StartTouch, GrenadeTouch);
    }
}

public GrenadeTouch(iGrenade, iEntity) 
{
	new attacker = GetEntPropEnt(iGrenade, Prop_Data, "m_hOwnerEntity", 0);
	if(maKlase[attacker])
	{
		if(iEntity > 0)
		{
			if(GetClientTeam(attacker) != GetClientTeam(iEntity))
			{
				PrintToChatAll("Dotkniety :)))");
				new Float:damage = float(GetClientHealth(iEntity)) * 3.0
				SDKHooks_TakeDamage(iEntity, 0, attacker, damage, DMG_GENERIC);
			}
		}
	}
} 