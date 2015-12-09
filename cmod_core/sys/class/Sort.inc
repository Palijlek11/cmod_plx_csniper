/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          Sort.inc
 *  Type:          Module
 *  Description:   Basic sort class system
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
#define CLASS_SORT;

stock Module:g_moduleClass_Sort;

public Class_Sort_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod:core] class sort system");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Class_Sort");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Basic sort class system");
	moduledata[ModuleData_Dependencies][0] = g_moduleClassSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	g_moduleClass_Sort = ModuleMgr_Register(moduledata);
	
	EventMgr_RegisterEvent(g_moduleClass_Sort, "Event_OnEventsRegister", "Class_Sort_OnEventsRegister");
}

public Class_Sort_OnEventsRegister(){

	#if defined EVENT_MANAGER	
			EventMgr_RegisterEvent(g_moduleClass_Sort, "Event_OnAllPluginsLoaded", "Class_Sort_Start");
	#endif
}

public Class_Sort_Start(){
	decl String:_sBuffer[1024];
	new _iNum = 1;
	BuildPath(Path_SM, _sBuffer, sizeof(_sBuffer), "cmod_class.txt");
	new Handle:_hFile;
	if(!FileExists(_sBuffer)){
		_hFile = OpenFile(_sBuffer, "w");
		CloseHandle(_hFile);
	}
	_hFile = OpenFile(_sBuffer, "r");
	
	if(_hFile == INVALID_HANDLE){
		return;
	}
	
	while(!IsEndOfFile(_hFile) && ReadFileLine(_hFile, _sBuffer, sizeof(_sBuffer))){
		TrimString(_sBuffer);
		if(_sBuffer[0] == '/'){	//Check comment
			continue;
		}
		
		if(_sBuffer[0] == '#'){	//Check fraction
			continue;
		}
		
		for(new i = 1; i <= g_iCmodClassCount; i++){
			if(StrEqual(g_sCmodClassName[i], _sBuffer)){
				if(_iNum != i){
					Class_Sort_Replace(i, _iNum);
				}
				_iNum++;
			}
		}
		
		if(_iNum > g_iCmodClassCount)
			break;
	}
	
	CloseHandle(_hFile);
}

stock Class_Sort_Replace(FClassID, SClassID){
	decl	String:_tmpClassName[MAX_NAME_LONG+1],
			String:_tmpClassDesc[MAX_DESC_LONG+1],
			Handle:_tmpHandle;
	
	#if defined STATS_SYS
	decl	_tmpClassStats;
	#endif
	
	_tmpClassName = g_sCmodClassName[FClassID];
	g_sCmodClassName[FClassID] = g_sCmodClassName[SClassID];
	g_sCmodClassName[SClassID] = _tmpClassName;
	
	_tmpClassDesc = g_sCmodClassDesc[FClassID];
	g_sCmodClassDesc[FClassID] = g_sCmodClassDesc[SClassID];
	g_sCmodClassDesc[SClassID] = _tmpClassDesc;	
	
	_tmpHandle = g_hCmodClassPlugin[FClassID];
	g_hCmodClassPlugin[FClassID] = g_hCmodClassPlugin[SClassID];
	g_hCmodClassPlugin[SClassID] = _tmpHandle;
	
	_tmpClassStats = g_iCmodClassINT[FClassID];
	g_iCmodClassINT[FClassID] = g_iCmodClassINT[SClassID];
	g_iCmodClassINT[SClassID] = _tmpClassStats;
		
	_tmpClassStats = g_iCmodClassCON[FClassID];
	g_iCmodClassCON[FClassID] = g_iCmodClassCON[SClassID];
	g_iCmodClassCON[SClassID] = _tmpClassStats;	
		
	_tmpClassStats = g_iCmodClassSTR[FClassID];
	g_iCmodClassSTR[FClassID] = g_iCmodClassSTR[SClassID];
	g_iCmodClassSTR[SClassID] = _tmpClassStats;
		
	_tmpClassStats = g_iCmodClassDEX[FClassID];
	g_iCmodClassDEX[FClassID] = g_iCmodClassDEX[SClassID];
	g_iCmodClassDEX[SClassID] = _tmpClassStats;
	
	_tmpHandle = g_hCmodClassWeapons[FClassID];
	g_hCmodClassWeapons[FClassID] = g_hCmodClassWeapons[SClassID];
	g_hCmodClassWeapons[SClassID] = _tmpHandle;

	Class_Sort_SendNewClassID(FClassID, SClassID);
	Class_Sort_SendNewClassID(SClassID, FClassID);
}

stock Class_Sort_SendNewClassID(oldclassID, newclassID){
	new Function:_fnTarget;
	_fnTarget = GetFunctionByName(g_hCmodClassPlugin[oldclassID], "Cmod_OnGetNewClassID");
	if(_fnTarget !=  INVALID_FUNCTION){	
		Call_StartFunction(g_hCmodClassPlugin[oldclassID], _fnTarget);
		Call_PushCell(oldclassID);
		Call_PushCell(newclassID);
		Call_Finish();
	}
}
#endif
