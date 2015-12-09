/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          Desc.inc
 *  Type:          Module
 *  Description:   Describe item
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
#define ITEM_DESC;

stock Module:g_moduleItem_Desc;

public Item_Desc_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Item: Describe");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Item_Desc");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Show player item desc");
	moduledata[ModuleData_Dependencies][0] = g_moduleItemSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	RegConsoleCmd("sm_item", Item_Desc_Cmd);
	RegConsoleCmd("sm_i", Item_Desc_Cmd);
	RegConsoleCmd("sm_perk", Item_Desc_Cmd);
	RegConsoleCmd("sm_p", Item_Desc_Cmd);
	RegConsoleCmd("sm_perki", Item_Desc_Cmd_List);
	RegConsoleCmd("sm_itemy", Item_Desc_Cmd_List);
	
	g_moduleItem_Desc = ModuleMgr_Register(moduledata);
	
}

public Action:Item_Desc_Cmd(client, args){
	//sniper
	if(g_iCmodPlayerItem[client]){
		if(GetConVarInt(g_hCmodItemDur))
			PrintToChat(client, "\x01\x0B\x01 \x03Item: \x04%s \x03Wyt: \x05%i", g_sCmodItemName[g_iCmodPlayerItem[client]], g_iCmodPlayerItemDur[client]);
		else
			PrintToChat(client, "\x01\x0B\x01 \x03Item: \x04%s", g_sCmodItemName[g_iCmodPlayerItem[client]]);
		new String:opis[MAX_DESC_LONG+1], String:value[11];
		IntToString(g_iCmodPlayerItemValue[client], value, 10);
		strcopy(opis, MAX_DESC_LONG, g_sCmodItemDesc[g_iCmodPlayerItem[client]]);
		ReplaceString(opis, MAX_DESC_LONG, "LW", value);
		PrintToChat(client, "\x01\x0B\x01 \x03Opis: \x06%s", opis);
	}else{
		PrintToChat(client, "\x01\x0B\x01 \x07%s \x01Nie posiadasz żadnego \x04itemu!", MOD_TAG); 
		PrintToChat(client, "\x01\x0B\x01 \x01Aby zdobyć item musisz kogoś zabić!", MOD_TAG); 
	}
	return Plugin_Handled; 
}

public Action:Item_Desc_Cmd_List(client, args){
	Item_Desc_ShowItemListMenu(client);
	return Plugin_Handled;
}

Item_Desc_ShowItemListMenu(client){
	if(!g_iCmodItemCount){
		PrintToChat(client, "\x01\x0B\x01 \x07%s \x06Nie znaleziono żadnego perku!", MOD_TAG);
	}
	new Handle:_hMenu = CreateMenu(Item_Desc_HandlerShowItemListMenu) ;

	SetMenuTitle(_hMenu, "Wybierz klase:");
	
	for(new i = 1; i <= g_iCmodItemCount; i++){
		AddMenuItem(_hMenu, g_sCmodItemName[i], g_sCmodItemName[i]);
	}

	DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
}

public Item_Desc_HandlerShowItemListMenu(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select){
		Item_Desc_ShowItemDesc(param1, param2 + 1);
	}else if(action == MenuAction_End){
		CloseHandle(menu);
	}
}

Item_Desc_ShowItemDesc(client, ItemID){
	new String:_sDesc[129];
	new String:_sMinMax[26];
	new String:_sName[MAX_NAME_LONG+1];
	new String:_sWyt[26];
//	new String:_sKoszt[26];
	new Handle:_hMenu = CreateMenu(Item_Desc_HandlerShowItemDesc);
//	new String:exploded[2][21];
	
	Format(_sName, sizeof(_sName), "Item:\n%s", g_sCmodItemName[ItemID]);
	AddMenuItem(_hMenu, "name", _sName);
	
	if(GetConVarInt(g_hCmodItemDur))
	{
		Format(_sWyt, sizeof(_sWyt), "Wytrzymalosc:\n%i", g_iCmodItemDurability[ItemID]);
		AddMenuItem(_hMenu, "name", _sWyt);
	}
	
//	Format(_sKoszt, sizeof(_sKoszt), "Koszt w sklepie:\n%i", g_hCmodItemCostInShop[ItemID]);
//	AddMenuItem(_hMenu, "name", _sKoszt);
	
	Format(_sDesc, sizeof(_sDesc), "Opis:\n%s", g_sCmodItemDesc[ItemID]);
	Format(_sMinMax, sizeof(_sMinMax), "%i-%i", g_iCmodItemMinValue[ItemID], g_iCmodItemMaxValue[ItemID]);
	ReplaceString(_sDesc, sizeof(_sDesc), "LW", _sMinMax, true);
	AddMenuItem(_hMenu, "desc", _sDesc);
	
	DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
}


public Item_Desc_HandlerShowItemDesc(Handle:menu, MenuAction:action, param1, param2)
{
	if(action == MenuAction_End){
		CloseHandle(menu);
	}
	
	Item_Desc_ShowItemListMenu(param1);
}

#endif
