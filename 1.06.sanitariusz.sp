#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod class: Sanitariusz",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new maKlase[MAXPLAYERS+1] = false

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_p90");
	PushArrayString(weapons, "weapon_usp-s");
	Cmod_RegisterClass("Medyk", "Posiada 2 apteczki\nJedna apteczka leczy maksymalnie 60+int*2 zdrowia\nUzycie 'bind klawisz cod_skill'", 5, 15, 5, 5, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID)
{
	maKlase[client] = true;
	Apteczki(client, 2, 0);
}

public Cmod_OnClassDisabled(client, classID)
{
	maKlase[client] = false;
	Apteczki(client, -1, 0);
}

public Cmod_OnClientUseSkill(client, classID)
{
	if(maKlase[client])
		StworzApteczke(client);
}