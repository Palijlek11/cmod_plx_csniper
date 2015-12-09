#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod class: Demolitions",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new maKlase[MAXPLAYERS] = false;

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_aug");
	PushArrayString(weapons, "weapon_p250");
	PushArrayString(weapons, "weapon_smokegrenade");
	Cmod_RegisterClass("Demolitions", "Posiada dynamit (zadaje 80+inteligencja obrazen w promieniu 200j)\nUzycie 'bind klawisz cod_skill'", 15, 5, 10, 10, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID)
{
	maKlase[client] = true
	Dynamit(client, 2, 0);
}

public Cmod_OnClassDisabled(client, classID)
{
	maKlase[client] = false
	Dynamit(client, -1, 0);
}

public Cmod_OnClientUseSkill(client, classID)
{
	if(maKlase[client])
		PolozDynamit(client);
}
