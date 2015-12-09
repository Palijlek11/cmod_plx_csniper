/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          Active.inc
 *  Type:          Module
 *  Description:   Active player item
 *
 *  Copyright (C) 2015 PLX
 *
 *  This program is free software: you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation, either version 3 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * ============================================================================
 */
#if defined ITEM_SYS;
#define ITEM_ACTIVE;

stock Module:g_moduleItem_Active;

public Item_Active_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Item: Active");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Item_Active");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Active player item");
	moduledata[ModuleData_Dependencies][0] = g_moduleItemSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	RegConsoleCmd("cod_perk", Item_Active_Cmd);
	RegConsoleCmd("cod_item", Item_Active_Cmd);
	
	g_moduleItem_Active = ModuleMgr_Register(moduledata);
	
}

public Action:Item_Active_Cmd(client, args){
	new Function:_func;
	_func = GetFunctionByName(g_hCmodItemPlugin[g_iCmodPlayerItem[client]], "Cmod_OnClientUseItem");
	if(_func !=  INVALID_FUNCTION){
		Call_StartFunction(g_hCmodItemPlugin[g_iCmodPlayerItem[client]], _func);
		Call_PushCell(client);
		Call_PushCell(g_iCmodPlayerItem[client]);
		Call_Finish();
	}
	return Plugin_Handled;
}

public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{
	if((buttons & IN_USE) && button[client] != buttons)
	{
		new Function:_func;
		_func = GetFunctionByName(g_hCmodItemPlugin[g_iCmodPlayerItem[client]], "Cmod_OnClientUseItem");
		if(_func !=  INVALID_FUNCTION){
			Call_StartFunction(g_hCmodItemPlugin[g_iCmodPlayerItem[client]], _func);
			Call_PushCell(client);
			Call_PushCell(g_iCmodPlayerItem[client]);
			Call_Finish();
		}
	}
		
	button[client] = buttons;
}


#endif
