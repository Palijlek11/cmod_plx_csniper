#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Class: ",
	author = "CSnajper",
	description = "Class dla Cmod by PLX",
	version = "0.1",
	url = "http://www.CSnajper.eu/"
};

public OnPluginStart(){
	new Handle:weapons = CreateArray(32);
	PushArrayString(weapons, "");
	Cmod_RegisterClass("", "", INT, CON, STR, DEX, ARM, weapons);
}

public Cmod_OnClassEnabled(client, classID){

}

public Cmod_OnClassDisabled(client, classID){

}

public Cmod_OnClientUseSkill(client, classID){

}
