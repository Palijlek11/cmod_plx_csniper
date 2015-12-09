/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:			stats.inc
 *  Type:			Module
 *  Description:	Basic statystic system
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
#include "stats\statslib.inc"

#define STATS_SYS;

stock Module:g_moduleStatsSys;

public StatsSys_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = true;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod:core] Stats system");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "StatsSys");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Basic statystic system");
	moduledata[ModuleData_Dependencies][0] = INVALID_MODULE;
	
	g_moduleStatsSys = ModuleMgr_Register(moduledata);
	
	EventMgr_RegisterEvent(g_moduleStatsSys, "Event_OnEventsRegister", "StatsSys_OnEventsRegister");
}

public StatsSys_OnEventsRegister(){
	#if defined EVENT_MANAGER	
		EventMgr_RegisterEvent(g_moduleStatsSys, "Event_OnClassChangeSuccess", "StatsSys_OnClassChangeSuccess");
		EventMgr_RegisterEvent(g_moduleStatsSys, "Event_PlayerSpawn", "StatsSys_OnClassChangeSuccess");
		EventMgr_RegisterEvent(g_moduleStatsSys, "Event_OnClientPutInServer", "StatsSys_OnClientPutInServer");
	#endif
}

//sniper
public StatsSys_OnClientPutInServer(client){
	g_iCmodBonusINT[client] = 0;
	g_iCmodBonusCON[client] = 0;
	g_iCmodBonusSTR[client] = 0;
	g_iCmodBonusDEX[client] = 0;
}


public StatsSys_OnClassChangeSuccess(client){
	CreateTimer(0.1, StatsSys_Timer, client, TIMER_FLAG_NO_MAPCHANGE);	
	//StatsSys_ActiveStats(client);
}

public Action:StatsSys_Timer(Handle:timer, any:client){	
	StatsSys_ActiveStats(client);
}

stock StatsSys_ActiveStats(client){
	SetEntData(client, FindDataMapOffs(client, "m_iMaxHealth"), PLAYER_BASE_HP + Stats_GetCON(client), 4, true);
	SetEntData(client, FindDataMapOffs(client, "m_iHealth"), PLAYER_BASE_HP + Stats_GetCON(client), 4, true);
	
	g_iCmodSpeed[client] = FloatAdd(1.0, FloatMul(float(Stats_GetDEX(client)), 0.005));
	SetEntPropFloat(client, Prop_Send, "m_flLaggedMovementValue", g_iCmodSpeed[client]);
	
	SetEntData(client, FindDataMapOffs(client, "m_ArmorValue"), Stats_GetARM(client), 4, true);
	 
	//if(Stats_GetSTR(client)>=0)
	//	SetEntProp(client, Prop_Data, "m_ArmorValue", Stats_GetSTR(client), 4);
}
