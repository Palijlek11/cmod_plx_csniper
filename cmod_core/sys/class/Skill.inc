/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          Skill.inc
 *  Type:          Module
 *  Description:   Send active skill too class
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
#define CLASS_SKILL;

stock Module:g_moduleClass_Skill;
new button[MAXPLAYERS+1] = 0;

public Class_Skill_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Class skill forward");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Class_Skill");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Send active skill too class");
	moduledata[ModuleData_Dependencies][0] = g_moduleClassSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	g_moduleClass_Skill = ModuleMgr_Register(moduledata);

	RegConsoleCmd("cod_skill", Class_Skill_Cmd);
}

public Action:Class_Skill_Cmd(client, args){
	Class_Skill_SendUse(client, g_iCmodPlayerClass[client]);
	return Plugin_Handled;
}

stock Class_Skill_SendUse(client, classID){
	new Function:_fnTarget;
	_fnTarget = GetFunctionByName(g_hCmodClassPlugin[classID], "Cmod_OnClientUseSkill");
	if(_fnTarget !=  INVALID_FUNCTION){	
		Call_StartFunction(g_hCmodClassPlugin[classID], _fnTarget);
		Call_PushCell(client);
		Call_PushCell(classID);
		Call_Finish();
	}
}

/*public Action:OnPlayerRunCmd(client, &buttons, &impulse, Float:vel[3], Float:angles[3], &weapon, &subtype, &cmdnum, &tickcount, &seed, mouse[2])
{
	if((buttons & IN_USE) && button[client] != buttons)
	{
		Class_Skill_SendUse(client, g_iCmodPlayerClass[client]);
	}
		
	button[client] = buttons;
}*/

#endif
