#include <sourcemod>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

public Plugin:myinfo = {
	name = "Cmod class: Zabojca",
	author = "Sniper Elite",
	description = "",
	version = "0.1",
	url = "http://csfifka.pl/"
};

public OnPluginStart()
{
	RegAdminCmd("cod_gi", GiveItem, ADMFLAG_BAN, "- <target> <ilosc expa>");
}

public Action:GiveItem(id, args)
{
	if(args < 2)
	{
		ReplyToCommand(id, "[SM] Usage: cod_gi <name | #userid> <itemid>");
		return Plugin_Handled;
	}
	
	new String: name[48];
	new String: itemid[48];
	new itemidInt;
	
	GetCmdArg(1, name, sizeof(name));
	GetCmdArg(2, itemid, sizeof(itemid));
	itemidInt = StringToInt(itemid);
	
/*	if(itemidInt < 1 || itemidInt > Cmod_GetItemCount())
	{
		ReplyToCommand(id, "[SM] ItemId = %i is invalid", itemidInt);
		return Plugin_Handled;
	}*/
	
	decl String:sTargetName[MAX_TARGET_LENGTH];
	decl sTargetList[1];
	decl bool:bTN_IsML;
	
	new iTarget = -1;
	
	if(ProcessTargetString(name, id, sTargetList, 1, COMMAND_FILTER_ALIVE, sTargetName, sizeof(sTargetName), bTN_IsML) > 0)
		iTarget = sTargetList[0];
	
	if(iTarget != -1 && !IsFakeClient(iTarget))
		Cmod_SetClientItem(iTarget, itemidInt);
	ReplyToCommand(id, "[SM] Nick (%s) [target = %i] | ItemId = %i", name, iTarget, itemidInt);
	
	return Plugin_Handled;
}