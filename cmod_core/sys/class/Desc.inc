/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          Desc.inc
 *  Type:          Module
 *  Description:   Class describe menu
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
#if defined CLASS_SYS
#define CLASS_DESC;

stock Module:g_moduleClass_Desc;

public Class_Desc_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Class describe menu");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Class_Desc");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Menu with class describtion");
	moduledata[ModuleData_Dependencies][0] = g_moduleClassSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	g_moduleClass_Desc = ModuleMgr_Register(moduledata);
	
	RegConsoleCmd("sm_classinfo", Class_Desc_Cmd);
	RegConsoleCmd("sm_klasy", Class_Desc_Cmd);

}

public Action:Class_Desc_Cmd(client, args){
	Class_Desc_ShowClassListMenu(client);
	return Plugin_Handled;
}

Class_Desc_ShowClassListMenu(client){
	if(!g_iCmodClassCount){
		PrintToChat(client, "\x01\x0B\x01 \x07%s \x06Nie znaleziono żadnej klasy!", MOD_TAG);
	}
	new Handle:_hMenu = CreateMenu(Class_Desc_HandlerShowClassListMenu) ;

	SetMenuTitle(_hMenu, "Wybierz klase:");
	
	for(new i = 1; i <= g_iCmodClassCount; i++){
		AddMenuItem(_hMenu, g_sCmodClassName[i], g_sCmodClassName[i]);
	}

	DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
}

public Class_Desc_HandlerShowClassListMenu(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select){
		Class_Desc_ShowClassDesc(param1, param2 + 1);
	}else if(action == MenuAction_End){
		CloseHandle(menu);
	}
}

Class_Desc_ShowClassDesc(client, classID){
	new String:_sDesc[129];
	new String:_sName[MAX_NAME_LONG+1];
	new Handle:_hMenu = CreateMenu(Class_Desc_HandlerShowClassDesc);
	new String:_stats[128];
	new bool:ciche_m4 = false;
//	new String:exploded[2][21];
	
	Format(_sName, sizeof(_sName), "Klasa:\n%s", g_sCmodClassName[classID]);
	AddMenuItem(_hMenu, "name", _sName);
	
	Format(_sDesc, sizeof(_sDesc), "Opis:\n%s", g_sCmodClassDesc[classID]);
	AddMenuItem(_hMenu, "desc", _sDesc);
	
	#if defined STATS_SYS
		Format(_stats, sizeof(_stats), "Statystyki:\nINT: %d | ZDR: %d | WYT: %d | KON: %d | ARM: %d", g_iCmodClassINT[classID], g_iCmodClassCON[classID], g_iCmodClassSTR[classID], g_iCmodClassDEX[classID], g_iCmodClassARM[classID]);
		AddMenuItem(_hMenu, "stats", _stats);
	#endif
	
	#if defined CLASS_WEAPONS
		decl String:_tmpBuffer[64];
		_sDesc = "Bronie:\n";
		for(new i; i < GetArraySize(g_hCmodClassWeapons[classID]); i++){
			GetArrayString(g_hCmodClassWeapons[classID], i, _tmpBuffer, sizeof(_tmpBuffer));
			//sniper
			//ExplodeString(_tmpBuffer, "_", String:exploded, 2, 20, true);
			ReplaceString(_tmpBuffer, 43, "weapon_", "");
			ReplaceString(_tmpBuffer, 43, "_", " ");
			if(StrEqual(_tmpBuffer, "m4a1 silencer"))
				ciche_m4 = true;
			if(StrEqual(_tmpBuffer, "m4a1") && ciche_m4)
				continue;
			StrCat(_sDesc, sizeof(_sDesc), _tmpBuffer);
			StrCat(_sDesc, sizeof(_sDesc), "\n");
		}
		AddMenuItem(_hMenu, "weapons", _sDesc);
	#endif
	
	DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
}


public Class_Desc_HandlerShowClassDesc(Handle:menu, MenuAction:action, param1, param2)
{
	if(action == MenuAction_End){
		CloseHandle(menu);
	}
	
	Class_Desc_ShowClassListMenu(param1);
}

#endif
