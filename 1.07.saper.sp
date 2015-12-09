#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod class: Lekki Snajper",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new maKlase[MAXPLAYERS+1] = false

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_bizon");
	PushArrayString(weapons, "weapon_p250");
	Cmod_RegisterClass("Saper", "Posiada 5 min. Kazda mina zadaje 60+inteligencja obrazen\nPostawienie miny 'bind klawisz cod_skill'", 15, 15, 10, 15, 0, weapons);
}

public Cmod_OnClassEnabled(client, classID)
{
	maKlase[client] = true;
	Miny(client, 3, 0);
}

public Cmod_OnClassDisabled(client, classID)
{
	maKlase[client] = false;
	Miny(client, -1, 0);
}

public Cmod_OnClientUseSkill(client, classID)
{
	if(maKlase[client])
		KladzMine(client);
}
