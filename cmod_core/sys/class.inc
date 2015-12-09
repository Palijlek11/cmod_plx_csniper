/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          class.inc
 *  Type:          Module
 *  Description:   Basic class system
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

#define CLASS_SYS

stock Module:g_moduleClassSys;


public ClassSys_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = true;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod:core] Class system");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "ClassSys");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Basic class system");
	moduledata[ModuleData_Dependencies][0] = INVALID_MODULE;
	
	g_moduleClassSys = ModuleMgr_Register(moduledata);
	
	EventMgr_RegisterEvent(g_moduleClassSys, "Event_OnEventsRegister", "ClassSys_OnEventsRegister");
	
	g_sCmodClassName[0] = "None";
	g_sCmodClassDesc[0] = "None";
	
	g_hCmodClassWeapons[0] = CreateArray(32);
}

public ClassSys_OnEventsRegister(){

	#if defined EVENT_MANAGER
		EventMgr_RegisterEvent(g_moduleClassSys, "Event_OnClientDisconnect", "ClassSys_OnClientDisconnect");
		EventMgr_RegisterEvent(g_moduleClassSys, "Event_OnClientPutInServer", "ClassSys_OnClientPutInServer");
		#if defined PROJECT_GAME_CSGO
			EventMgr_RegisterEvent(g_moduleClassSys, "Event_PlayerSpawn", "ClassSys_EventPlayerSpawn");
			EventMgr_RegisterEvent(g_moduleClassSys, "Event_OnMapEnd", "ClassSys_OnMapEnd");
		#endif	
	#endif
}

public ClassSys_OnMapEnd(){
	for(new client = 1; client <= MaxClients; client++){
		new Function:_fnTarget;
		_fnTarget = GetFunctionByName(g_hCmodClassPlugin[g_iCmodPlayerClass[client]], "Cmod_OnClassDisabled");
		if(_fnTarget !=  INVALID_FUNCTION){	
			Call_StartFunction(g_hCmodClassPlugin[g_iCmodPlayerClass[client]], _fnTarget);
			Call_PushCell(client);
			Call_PushCell(g_iCmodPlayerClass[client]);
			Call_Finish();
		}
	}
}
	
public ClassSys_OnClientDisconnect(client){
	new Function:_fnTarget;
	_fnTarget = GetFunctionByName(g_hCmodClassPlugin[g_iCmodPlayerClass[client]], "Cmod_OnClassDisabled");
	if(_fnTarget !=  INVALID_FUNCTION){	
		Call_StartFunction(g_hCmodClassPlugin[g_iCmodPlayerClass[client]], _fnTarget);
		Call_PushCell(client);
		Call_PushCell(g_iCmodPlayerClass[client]);
		Call_Finish();
	}
	//sniper
	SDKUnhook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}
//sniper	
public ClassSys_OnClientPutInServer(client){
	SDKHook(client, SDKHook_OnTakeDamage, OnTakeDamage);
}

public Action:OnTakeDamage(victim, &attacker, &inflictor, &Float:damage, &damagetype)
{
	if(!IsClientValid(victim) || !IsClientValid(attacker))
		return Plugin_Continue;
	if(!IsPlayerAlive(victim))
		return Plugin_Continue;
	new Float:redukcjaKlasy = FloatMul(damage, Cmod_GetResistance(victim));
	damage -= redukcjaKlasy;
	new Float:dodatkowe_dmg = bonusDmgKlasa[attacker] + bonusDmgItem[attacker];
	new Float:dodatkowa_redukcja = bonusReductionKlasa[victim] + bonusReductionItem[victim];
	damage += dodatkowe_dmg;
	damage -= dodatkowa_redukcja;
	if(damage < 0)
		damage = 1.0;
	return Plugin_Changed;
}
	
public ClassSys_EventPlayerSpawn(client){
	if(g_iCmodPlayerNextClass[client])
	{
		ClassSys_ChangeClass(client);
		Item_Set(client, 0);
	}
}

public ClassSys_Register(Handle:plugin, numParams)
{
	if(numParams != 8){
		ThrowNativeError(SP_ERROR_NATIVE, "Bad registerClass NumParams(%d)", numParams);
		return -1;
	}	
	if(++g_iCmodClassCount > MAX_CLASS_NUMBER){
		ThrowNativeError(SP_ERROR_NATIVE, "Too many class");
		return -2;	
	}
	
	g_hCmodClassPlugin[g_iCmodClassCount] = plugin;
	
	GetNativeString(1, g_sCmodClassName[g_iCmodClassCount], MAX_NAME_LONG);
	GetNativeString(2, g_sCmodClassDesc[g_iCmodClassCount], MAX_DESC_LONG);	
	
	g_iCmodClassINT[g_iCmodClassCount] = GetNativeCell(3);
	g_iCmodClassCON[g_iCmodClassCount] = GetNativeCell(4);
	g_iCmodClassSTR[g_iCmodClassCount] = GetNativeCell(5);
	g_iCmodClassDEX[g_iCmodClassCount] = GetNativeCell(6);
	g_iCmodClassARM[g_iCmodClassCount] = GetNativeCell(7);
	
	g_hCmodClassWeapons[g_iCmodClassCount] = GetNativeCell(8);
	
	return g_iCmodClassCount;
}

stock ClassSys_ChangeClass(client){
	new Function:_fnTarget;
	new _iResult;
	
	_fnTarget = GetFunctionByName(g_hCmodClassPlugin[g_iCmodPlayerClass[client]], "Cmod_OnClassDisabled");
	if(_fnTarget !=  INVALID_FUNCTION){	
		Call_StartFunction(g_hCmodClassPlugin[g_iCmodPlayerClass[client]], _fnTarget);
		Call_PushCell(client);
		Call_PushCell(g_iCmodPlayerClass[client]);
		Call_Finish();
	}
	
	#if defined SQL_SYS
		SQLSys_Save(client);
	#endif
	
	_fnTarget = GetFunctionByName(g_hCmodClassPlugin[g_iCmodPlayerNextClass[client]], "Cmod_OnClassEnabled");
	if(_fnTarget !=  INVALID_FUNCTION){	
		Call_StartFunction(g_hCmodClassPlugin[g_iCmodPlayerNextClass[client]], _fnTarget);
		Call_PushCell(client);
		Call_PushCell(g_iCmodPlayerNextClass[client]);
		Call_Finish(_iResult);
	}
	
	if(_iResult == -1){
		g_iCmodPlayerClass[client] = 0;
		g_iCmodPlayerNextClass[client] = 0;
		#if defined EVENT_MANAGER
			OnClassChangeFail(client);
		#endif
		return 0;
	}
	
	g_iCmodPlayerClass[client] = g_iCmodPlayerNextClass[client];
	g_iCmodPlayerNextClass[client] = 0;
	
	#if defined SQL_SYS
		SQLSys_Load(client, g_iCmodPlayerClass[client]);
	#endif
	
	#if defined EVENT_MANAGER
		OnClassChangeSuccess(client);
	#endif
	return 1;	
}

stock bool:IsClientValid(client)
{
	if(client > 0 && client <= MaxClients)
		return true;
	return false;
}