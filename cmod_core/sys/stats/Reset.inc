/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          Reset.inc
 *  Type:          Module
 *  Description:   Stats reset
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
#if defined STATS_SYS
#define STATS_RESET;

stock Module:g_moduleStats_Reset;

public Stats_Reset_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Stats reset");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Stats_Reset");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Stats reset");
	moduledata[ModuleData_Dependencies][0] = g_moduleStatsSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	g_moduleStats_Reset = ModuleMgr_Register(moduledata);
	
	RegConsoleCmd("sm_reset", Stats_Reset_Cmd);
}

public Action:Stats_Reset_Cmd(id, args)
{
	Stats_Reset_Start(id);
	PrintToChat(id, "\x01\x0B\x01 \x07%s \x06Twoje statystyki zostały zrestartowane.", MOD_TAG); 
	return Plugin_Handled;	
}

public Stats_Reset_Start(id)
{
	g_iCmodPlayerPoint[id] = (g_iCmodLvl[id]-1)*2;
	g_iCmodPlayerINT[id] = 0;
	g_iCmodPlayerCON[id] = 0;
	g_iCmodPlayerSTR[id] = 0;
	g_iCmodPlayerDEX[id] = 0;
	
	#if defined STATS_MENU
		if(g_iCmodPlayerPoint[id])
			Stats_Menu_Show(id);
	#endif
}
#endif
