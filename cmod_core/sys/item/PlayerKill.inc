/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          PlayerKill.inc
 *  Type:          Module
 *  Description:   Give new item for kill
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
#if defined ITEM_SYS

#define ITEM_PLAYERKILL;

stock Module:g_moduleItem_PlayerKill;

public Item_PlayerKill_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Item: PlayerKill");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Item_PlayerKill");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Give new item for kill");
	moduledata[ModuleData_Dependencies][0] = g_moduleItemSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	g_moduleItem_PlayerKill = ModuleMgr_Register(moduledata);
	
	EventMgr_RegisterEvent(g_moduleItem_PlayerKill, "Event_OnEventsRegister", "Item_PlayerKill_OnEventsRegister");
}

public Item_PlayerKill_OnEventsRegister(){

	#if defined EVENT_MANAGER
		#if defined PROJECT_GAME_CSGO
			EventMgr_RegisterEvent(g_moduleItem_PlayerKill, "Event_PlayerDeath", "Item_PlayerKill_EventPlayerDeath");
		#endif
	#endif
}

#if defined PROJECT_GAME_CSGO
public Item_PlayerKill_EventPlayerDeath(victim, attacker, String:weapon[], headshoot){
		
		if(!g_iCmodPlayerItem[attacker] && (g_iCmodItemCount > 0) && (victim != attacker)){
			new _random = GetRandomInt(1, g_iCmodItemCount);
			Item_Set(attacker, _random);
			PrintToChat(attacker, "\x01\x0B\x01 \x07%s \x06Znalazłeś: \x03%s", MOD_TAG, g_sCmodItemName[_random]);
		}
	
}
#endif

#endif
