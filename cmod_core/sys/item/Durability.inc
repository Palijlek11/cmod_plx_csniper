/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          Durability.inc
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

#define ITEM_DURABILITY;

stock Module:g_moduleItem_Durability;

public Item_Durability_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Item: Durability");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Item_Durability");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Item Durability");
	moduledata[ModuleData_Dependencies][0] = g_moduleItemSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	g_moduleItem_Durability = ModuleMgr_Register(moduledata);
	
	EventMgr_RegisterEvent(g_moduleItem_Durability, "Event_OnEventsRegister", "Item_Durability_OnEventsRegister");
	
	g_hCmodDurPerhit = CreateConVar("cmod_dur_per_hit", "5", "O ile ma spadac wytrzymalosc przedmiotu");
	g_hCmodDurStyle = CreateConVar("cmod_dur_style", "1", "0-wytrzymalosc spada co kazde uszkodzenie gracza. 1-tylko przy smierci gracza");
	
	AutoExecConfig(true, "cmod");
}

public Item_Durability_OnEventsRegister(){
	#if defined EVENT_MANAGER
		#if defined PROJECT_GAME_CSGO
			EventMgr_RegisterEvent(g_moduleItem_Durability, "Event_PlayerHurt", "Item_Durability_EventPlayerHurt");
			EventMgr_RegisterEvent(g_moduleItem_Durability, "Event_PlayerDeath", "Item_ItemDurability_EventPlayerDeath");
		#endif
	#endif
}

#if defined PROJECT_GAME_CSGO
public Item_Durability_EventPlayerHurt(victim, attacker, healht, armor, String:weapon[], dmg_health, dmg_armor, hitgroup){
		
		if(GetConVarInt(g_hCmodDurStyle) == 0)
		{
			if(g_iCmodPlayerItem[victim] && g_iCmodPlayerItemDur[victim] && GetConVarInt(g_hCmodItemDur)){
				if(attacker && attacker != victim)
				{
					g_iCmodPlayerItemDur[victim] -= GetConVarInt(g_hCmodDurPerhit);
					if(g_iCmodPlayerItemDur[victim] <= 0)
					{
						PrintToChat(victim, "\x01\x0B\x01 \x02Przedmiot:\x04%s \x02zostal calkowicie zniszczony", g_sCmodItemName[g_iCmodPlayerItem[victim]]);
						Item_Set(victim, 0);
					}
				}
			}
		}
		
	
}

public Item_ItemDurability_EventPlayerDeath(victim, attacker, String:weapon[], headshoot){
		
		if(GetConVarInt(g_hCmodDurStyle) == 1)
		{
			if(g_iCmodPlayerItem[victim] && g_iCmodPlayerItemDur[victim] && GetConVarInt(g_hCmodItemDur)){
				if(attacker && attacker != victim)
				{
					g_iCmodPlayerItemDur[victim] -= GetConVarInt(g_hCmodDurPerhit);
					if(g_iCmodPlayerItemDur[victim] <= 0)
					{
						PrintToChat(victim, "\x01\x0B\x01 \x02Przedmiot:\x04%s \x02zostal calkowicie zniszczony", g_sCmodItemName[g_iCmodPlayerItem[victim]]);
						Item_Set(victim, 0);
					}
				}
			}
		}
	
}
#endif

#endif
