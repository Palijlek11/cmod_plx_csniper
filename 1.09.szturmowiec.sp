#include <sourcemod>
#include <sdkhooks>
#include <cmod>
#include <cmod_skills>

public Plugin:myinfo = {
	name = "Cmod class: Szturmowiec",
	author = "CSnajper",
	description = "Klasa dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "weapon_m4a1");
	PushArrayString(weapons, "weapon_m4a1_silencer");
	PushArrayString(weapons, "weapon_p250");
	PushArrayString(weapons, "weapon_hegrenade");
	PushArrayString(weapons, "weapon_smokegrenade");
	Cmod_RegisterClass("Szturmowiec", "Brak dodatkowych umiejetnosci", 0, 20, 10, 10, 0, weapons);

}

public Cmod_OnClassEnabled(client, classID)
{
	
}

public Cmod_OnClassDisabled(client, classID)
{
	
}
