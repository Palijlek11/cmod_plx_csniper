/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:			ui.inc
 *  Type:			Module
 *  Description:	Display information
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

#define UI_SYS

stock Module:g_moduleUISys;

public UISys_OnPluginStart(){
	new moduledata[ModuleData];

	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = true;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] UI system");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "UISys");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Display information");
	moduledata[ModuleData_Dependencies][0] = INVALID_MODULE;

	g_moduleUISys = ModuleMgr_Register(moduledata);

	CreateTimer(1.0, UISys_Show, _, TIMER_REPEAT);

	g_hCmodForum = CreateConVar("cmod_forum", "TwojeForum.pl", "Nazwa forum");
	g_hCmodForumColor = CreateConVar("cmod_forum_color", "#006600", "Kolor forum");
	g_hCmodItemDur = CreateConVar("cmod_item_dur", "1", "Wytrzymalosc przedmiotow");
}

public Action:UISys_Show(Handle:timer){

	for(new client = 1; client <= MaxClients; client++){
		if(IsClientConnected(client) && IsClientInGame(client) && !IsFakeClient(client)){
			if(IsPlayerAlive(client))
			{
				new	String:_tmp[128],
				String:_buffer[256];
				#if defined CLASS_SYS
					new String:forumName[31];
					GetConVarString(g_hCmodForum, forumName, 30);
					new String:forumColor[12];
					GetConVarString(g_hCmodForumColor, forumColor, 11);
					if(GetAdminFlag(GetUserAdmin(client), Admin_Custom6))
						Format(_tmp, sizeof(_tmp), "<font color='%s'>%s</font> <font color='#CC3399'>[PREMIUM]</font>\n",forumColor, forumName);
					else
						Format(_tmp, sizeof(_tmp), "<font color='%s'>%s</font>\n",forumColor, forumName);
					StrCat(_buffer, sizeof(_buffer), _tmp);
				#endif

				if(g_iCmodPlayerClass[client])
				{
					#if defined CLASS_SYS
						Format(_tmp, sizeof(_tmp), "%s ", g_sCmodClassName[g_iCmodPlayerClass[client]]);
						StrCat(_buffer, sizeof(_buffer), _tmp);
					#endif
					#if defined XP_SYS
						new Float:procenty;
						if(!g_iCmodLvl[client])
							procenty = 0.0;
						else
						{
							new i = g_iCmodExp[client] - XpSys_GetXpForLvl(g_iCmodLvl[client]-1);
							new j = XpSys_GetXpForLvl(g_iCmodLvl[client]+1) - XpSys_GetXpForLvl(g_iCmodLvl[client]);
							procenty = float(i)/float(j) * 100.0;
						}
						Format(_tmp, sizeof(_tmp), "[LVL: %d (%0.1f%%)]\n", g_iCmodLvl[client], procenty);
						StrCat(_buffer, sizeof(_buffer), _tmp);
					#endif

					#if defined ITEM_SYS

						if(GetConVarInt(g_hCmodItemDur))
						{
							new String:color[16];
							if(g_iCmodPlayerItem[client])
							{
								if(250 >= g_iCmodPlayerItemDur[client] >= 200)
									strcopy(color, 15, "#006600");
								else if(199 >= g_iCmodPlayerItemDur[client] >= 150)
									strcopy(color, 15, "#339900");
								else if(149 >= g_iCmodPlayerItemDur[client] >= 100)
									strcopy(color, 15, "#FFFF00");
								else if(99 >= g_iCmodPlayerItemDur[client] >= 50)
									strcopy(color, 15, "#FF9900");
								else if(49 >= g_iCmodPlayerItemDur[client] >= 1)
									strcopy(color, 15, "#FF0000");
							}
							else strcopy(color, 15, "#FFFFFF");
							Format(_tmp, sizeof(_tmp), "%s [<font color='%s'>%i</font>]\n", g_sCmodItemName[g_iCmodPlayerItem[client]], color, g_iCmodPlayerItemDur[client]);
						}
						else
							Format(_tmp, sizeof(_tmp), "Perk: %s\n", g_sCmodItemName[g_iCmodPlayerItem[client]]);
						StrCat(_buffer, sizeof(_buffer), _tmp);
					#endif
					PrintHintText(client, "%s", _buffer);
				}
				else
				{
					Format(_tmp, sizeof(_tmp), "Wpisz !klasa\naby zaczac gre!");
					StrCat(_buffer, sizeof(_buffer), _tmp);
					PrintHintText(client, "%s", _buffer);
				}
			}
			else
			{
				new iSpecMode = GetEntProp(client, Prop_Send, "m_iObserverMode");
				if(iSpecMode == 4 || iSpecMode == 5)
				{
					new target = GetEntPropEnt(client, Prop_Send, "m_hObserverTarget");

					if(1 <= target <= MaxClients)
					{
							new	String:_tmp[128],
							String:_buffer[256];
						#if defined CLASS_SYS
							new String:forumName[31];
							GetConVarString(g_hCmodForum, forumName, 30);
							new String:forumColor[12];
							GetConVarString(g_hCmodForumColor, forumColor, 11);

							
							if(GetAdminFlag(GetUserAdmin(target), Admin_Custom6))
								Format(_tmp, sizeof(_tmp), "<font color='%s'>%s</font>  <font color='#CC3399'>[PREMIUM]\n%s ",forumColor, forumName, g_sCmodClassName[g_iCmodPlayerClass[target]]);
							else
								Format(_tmp, sizeof(_tmp), "<font color='%s'>%s</font>\n%s ",forumColor, forumName, g_sCmodClassName[g_iCmodPlayerClass[target]]);
							StrCat(_buffer, sizeof(_buffer), _tmp);
						#endif

						#if defined XP_SYS
							new Float:procenty;
							if(!g_iCmodLvl[target])
								procenty = 0.0;
							else
							{
								new i = g_iCmodExp[target] - XpSys_GetXpForLvl(g_iCmodLvl[target]-1);
								new j = XpSys_GetXpForLvl(g_iCmodLvl[target]+1) - XpSys_GetXpForLvl(g_iCmodLvl[target]);
								procenty = float(i)/float(j) * 100.0;
							}
							Format(_tmp, sizeof(_tmp), "[LVL: %d (%0.1f%%)]\n", g_iCmodLvl[target], procenty);
							StrCat(_buffer, sizeof(_buffer), _tmp);
						#endif

						#if defined ITEM_SYS

							if(GetConVarInt(g_hCmodItemDur))
							{
								new String:color[16];
								if(g_iCmodPlayerItem[target])
								{
									if(250 >= g_iCmodPlayerItemDur[target] >= 200)
										strcopy(color, 15, "#006600");
									else if(199 >= g_iCmodPlayerItemDur[target] >= 150)
										strcopy(color, 15, "#339900");
									else if(149 >= g_iCmodPlayerItemDur[target] >= 100)
										strcopy(color, 15, "#FFFF00");
									else if(99 >= g_iCmodPlayerItemDur[target] >= 50)
										strcopy(color, 15, "#FF9900");
									else if(49 >= g_iCmodPlayerItemDur[target] >= 1)
										strcopy(color, 15, "#FF0000");
								}
								else strcopy(color, 15, "#FFFFFF");
								Format(_tmp, sizeof(_tmp), "%s [<font color='%s'>%i</font>]\n", g_sCmodItemName[g_iCmodPlayerItem[target]], color, g_iCmodPlayerItemDur[target]);
							}
							else
								Format(_tmp, sizeof(_tmp), "Perk: %s\n", g_sCmodItemName[g_iCmodPlayerItem[target]]);
							StrCat(_buffer, sizeof(_buffer), _tmp);
						#endif
						PrintHintText(client, "%s", _buffer);
					}
				}
			}
		}
	}
	return Plugin_Continue;
}
