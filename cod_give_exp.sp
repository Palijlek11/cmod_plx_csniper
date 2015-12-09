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
	RegAdminCmd("cod_ge", GiveExp, ADMFLAG_BAN, "- <target> <ilosc expa>");
	RegAdminCmd("cod_gl", GiveLvl, ADMFLAG_BAN, "- <target> <ilosc expa>");
}

public Action:GiveExp(id, args)
{
	if(args < 2)
	{
		ReplyToCommand(id, "[SM] Usage: cod_ge <name | #userid> <exp>");
		return Plugin_Handled;
	}
	
	new String: name[48];
	new String: expstr[48];
	new exp;
	
	GetCmdArg(1, name, sizeof(name));
	GetCmdArg(2, expstr, sizeof(expstr));
	exp = StringToInt(expstr);
	
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
	{
		Cmod_SetClientExp(iTarget, Cmod_GetClientExp(iTarget)+exp);
		Cmod_CheckClientLvl(iTarget);
	}
	ReplyToCommand(id, "[SM] Nick (%s) [target = %i] | EXP = %i", name, iTarget, exp);
	
	return Plugin_Handled;
}
public Action:GiveLvl(id, args)
{
	if(args < 2)
	{
		ReplyToCommand(id, "[SM] Usage: cod_gl <name | #userid> <LVL>");
		return Plugin_Handled;
	}
	
	new String: name[48];
	new String: lvlstr[48];
	new lvl;
	
	GetCmdArg(1, name, sizeof(name));
	GetCmdArg(2, lvlstr, sizeof(lvlstr));
	lvl = StringToInt(lvlstr);
	
/*	if(itemidInt < 1 || itemidInt > Cmod_GetItemCount())
	{
		ReplyToCommand(id, "[SM] ItemId = %i is invalid", itemidInt);
		return Plugin_Handled;
	}*/
	
	decl String:sTargetName[MAX_TARGET_LENGTH];
	decl sTargetList[1];
	decl bool:bTN_IsML;
	
	new exp = Cmod_GetExpForLvl(lvl)
	
	new iTarget = -1;
	
	if(ProcessTargetString(name, id, sTargetList, 1, COMMAND_FILTER_ALIVE, sTargetName, sizeof(sTargetName), bTN_IsML) > 0)
		iTarget = sTargetList[0];
	
	if(iTarget != -1 && !IsFakeClient(iTarget))
	{
		Cmod_SetClientExp(iTarget, exp);
		Cmod_CheckClientLvl(iTarget);
	}
	ReplyToCommand(id, "[SM] Nick (%s) [target = %i] | LVL = %i", name, iTarget, exp);
	
	return Plugin_Handled;
}