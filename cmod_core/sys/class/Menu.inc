/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          Menu.inc
 *  Type:          Module
 *  Description:   Choose Class menu
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
#define CLASS_MENU;

stock Module:g_moduleClass_Menu;

public Class_Menu_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Class menu");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Class_Menu");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Menu with class for choose");
	moduledata[ModuleData_Dependencies][0] = g_moduleClassSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	g_moduleClass_Menu = ModuleMgr_Register(moduledata);
	
	EventMgr_RegisterEvent(g_moduleClass_Menu, "Event_OnEventsRegister", "Class_Menu_OnEventsRegister");

	RegConsoleCmd("sm_class", Class_Menu_Cmd);
	RegConsoleCmd("sm_klasa", Class_Menu_Cmd);
	RegConsoleCmd("sm_k", Class_Menu_Cmd);

}

public Class_Menu_OnEventsRegister(){

	#if defined EVENT_MANAGER
		EventMgr_RegisterEvent(g_moduleClass_Menu, "Event_OnClassChangeFail", "Class_Menu_EventOnClassChangeFail");
		#if defined PROJECT_GAME_CSGO
			EventMgr_RegisterEvent(g_moduleClass_Menu, "Event_PlayerSpawn", "Class_Menu_EventPlayerSpawn");
		#endif
	#endif
}

public Class_Menu_EventOnClassChangeFail(client){
	CreateTimer(0.1, Class_Menu_Show, client, TIMER_FLAG_NO_MAPCHANGE);
}

public Class_Menu_EventPlayerSpawn(client){	
	if(!g_iCmodPlayerClass[client])
		if(g_iCmodClassCount)
			CreateTimer(0.1, Class_Menu_Show, client, TIMER_FLAG_NO_MAPCHANGE);
}

public Action:Class_Menu_Cmd(client, args){
	CreateTimer(0.1, Class_Menu_Show, client, TIMER_FLAG_NO_MAPCHANGE);
	return Plugin_Handled;
}

public Action:Class_Menu_Show(Handle:timer, any:client){
	if(!g_iCmodClassCount){
		PrintToChat(client, "\x01\x0B\x01 \x07%s \x06Nie znaleziono żadnej klasy!", MOD_TAG);
	}
	
	if(IsFakeClient(client))
	{
		g_iCmodPlayerNextClass[client] = GetRandomInt(1, g_iCmodClassCount);
		
		if(!g_iCmodPlayerClass[client]){
			ClassSys_ChangeClass(client);
		}
		return;
	}
	
	if(loadLevel[client] != 2)
	{
		LoadPlayerClassesLevel(client);
		CreateTimer(3.0, Class_Menu_Show, client, TIMER_FLAG_NO_MAPCHANGE);
		return;
	}
	
	new Handle:_hMenu = CreateMenu(Class_Menu_HandlerShow);
	decl String:_sName[64];
	SetMenuTitle(_hMenu, "Wybierz klase:");
	
	for(new i = 1; i <= g_iCmodClassCount; i++){
		
		#if defined SQL_SYS
			Format(_sName, sizeof(_sName), "%s (LVL: %d)", g_sCmodClassName[i], g_player_class_lvl[client][i]);
		#else
			Format(_sName, sizeof(_sName), "%s", g_sCmodClassName[i]);
		#endif
		
		AddMenuItem(_hMenu, g_sCmodClassName[i], _sName);
	}
	
	DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
}

public Class_Menu_HandlerShow(Handle:menu, MenuAction:action, param1, param2){
	if (action == MenuAction_Select){
		g_iCmodPlayerNextClass[param1] = param2 + 1;
		
		if(!g_iCmodPlayerClass[param1]){
			ClassSys_ChangeClass(param1);
			return;	
		}
		PrintToChat(param1, "\x01\x0B\x01 \x07%s \x01Wybrales klase:\x04 %s", MOD_TAG, g_sCmodClassName[g_iCmodPlayerNextClass[param1]]);
		PrintToChat(param1, "\x01\x0B\x01 \x07%s \x06Klasa zostanie zmieniona przy następnym spawn'ie.", MOD_TAG);
	}else if (action == MenuAction_End){
		CloseHandle(menu);
	}
}

#endif
