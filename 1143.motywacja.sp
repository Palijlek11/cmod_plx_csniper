#include <sourcemod>
#include <sdkhooks>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod Item: Motywacja",
	author = "CSnajper",
	description = "Item dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

new maItem[MAXPLAYERS+1] = false;

public OnPluginStart(){
	Cmod_RegisterItem("Motywacja", "Leczysz 10 HP za zabojstwo", 1, 1, 250, INVALID_HANDLE);
	
	HookEvent("player_death", eventPlayerDeath);
}

public Cmod_OnItemEnabled(client, itemID, value){
	maItem[client] = true
}

public Cmod_OnItemDisabled(client, itemID){
	maItem[client] = false;
}

public Action:eventPlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new attacker = GetClientOfUserId(GetEventInt(event, "attacker"))
	
	if ( maItem[attacker] && attacker && IsPlayerAlive(attacker))
	{
		new hp = GetClientHealth(attacker) + 10;
		new maxHp = 100 + Cmod_GetCON(attacker)
		if(hp > maxHp)
			SetEntData(attacker, FindDataMapOffs(attacker, "m_iHealth"), maxHp, 4, true);
		else
			SetEntData(attacker, FindDataMapOffs(attacker, "m_iHealth"), hp, 4, true);
	}

}