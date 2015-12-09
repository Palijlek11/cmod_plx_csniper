/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          Drop.inc
 *  Type:          Module
 *  Description:   Drop player item
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
#define ITEM_DROP;

stock Module:g_moduleItem_Drop;

public Item_Drop_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Item: Drop");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Item_Drop");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Drop player item");
	moduledata[ModuleData_Dependencies][0] = g_moduleItemSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	RegConsoleCmd("sm_drop", Item_Drop_Cmd);
	RegConsoleCmd("sm_d", Item_Drop_Cmd);
	RegConsoleCmd("sm_wyrzuc", Item_Drop_Cmd);
	
	g_moduleItem_Drop = ModuleMgr_Register(moduledata);
	
}

public Action:Item_Drop_Cmd(client, args){
	if(g_iCmodPlayerItem[client]){
		PrintToChat(client, "\x01\x0B\x01 \x07%s \x06Wyrzuciłeś \x03%s", MOD_TAG, g_sCmodItemName[g_iCmodPlayerItem[client]]); 	
		Item_Set(client, 0);
	}else{
		PrintToChat(client, "\x01\x0B\x01 \x07%s \x06Nie posiadasz żadnego \x03itemu\x06, aby zdobyć item musisz kogoś zabić!", MOD_TAG); 
	}
	return Plugin_Handled;
}


#endif
