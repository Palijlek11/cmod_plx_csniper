/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:			item.inc
 *  Type:			Module
 *  Description:	Basic item system
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
#include "/item/itemlib"

#define ITEM_SYS

stock Module:g_moduleItemSys;

public ItemSys_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = true;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Item system");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "ItemSys");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Basic item system");
	moduledata[ModuleData_Dependencies][0] = INVALID_MODULE;
	
	g_moduleItemSys = ModuleMgr_Register(moduledata);
	
	EventMgr_RegisterEvent(g_moduleItemSys, "Event_OnEventsRegister", "ItemSys_OnEventsRegister");
	 
	g_sCmodItemName[0] = "Brak Perku";
	g_sCmodItemDesc[0] = "Brak Opisu";
	g_hCmodItemWeapons[0] = CreateArray(32);
}

public ItemSys_OnEventsRegister(){
	#if defined EVENT_MANAGER	
	
		EventMgr_RegisterEvent(g_moduleItemSys, "Event_OnClientDisconnect", "ItemSys_OnClientDisconnect");
		EventMgr_RegisterEvent(g_moduleItemSys, "Event_OnMapEnd", "ItemSys_OnMapEnd");
		
	#endif
}

public ItemSys_OnClientDisconnect(client){
	Item_Set(client, 0);
}

public ItemSys_OnMapEnd(){
	for(new client = 1; client <= MaxClients; client++){
		if(IsClientInGame(client))
			Item_Set(client, 0);
	}
}

public ItemSys_Register(Handle:plugin, numParams){
	if(++g_iCmodItemCount > MAX_ITEM_NUMBER){
		ThrowNativeError(SP_ERROR_NATIVE, "Too many item for register next (g_iItemSysCount: %d MAX_ITEM_NUMBER: %d)", g_iCmodItemCount, MAX_ITEM_NUMBER);
		return -1;
	}
			
	g_hCmodItemPlugin[g_iCmodItemCount] = plugin;
	GetNativeString(1, g_sCmodItemName[g_iCmodItemCount], MAX_NAME_LONG);
	GetNativeString(2, g_sCmodItemDesc[g_iCmodItemCount], MAX_DESC_LONG);
	g_iCmodItemMinValue[g_iCmodItemCount] = GetNativeCell(3);
	g_iCmodItemMaxValue[g_iCmodItemCount] = GetNativeCell(4);
	
	g_iCmodItemDurability[g_iCmodItemCount] = GetNativeCell(5);
	g_hCmodItemWeapons[g_iCmodItemCount] = GetNativeCell(6);
	
	return g_iCmodItemCount;
}




