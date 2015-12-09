/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          xp.inc
 *  Type:          Module
 *  Description:   Basic Xp and level system
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

#define XP_SYS

stock Module:g_moduleXpSys;

new bool:ExpGodzAktywne = false;
new Handle:ExpGodzTimer = INVALID_HANDLE;

enum {exp_zabojstwo = 1, exp_hosty, exp_paka_podlozona, exp_paka_rozbrojona, exp_asysta, exp_wygrana_runda, exp_zabojstwo_bota, exp_paka_asysta_TT, exp_paka_asysta_CT, exp_hosty_asysta};
new String:exp_info[] = {"losowanie", "zabojstwo", "podlozenie bomby", "rozbrojenie bomby", "uratowanie zakladnika", "asyste w zabojstwie", "wygrana runde", "zabojstwo bota", "podlozenie bomby przez twoj team", "rozbrojenie bomby przez twoj team", "uratowanie zakladnika przez twoj team"};

public XpSys_OnPluginStart()
{

	new moduledata[ModuleData];

	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = true;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod:core] Xp system");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "XpSys");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Basic Xp and Lvl system");
	moduledata[ModuleData_Dependencies][0] = INVALID_MODULE;

	g_moduleXpSys = ModuleMgr_Register(moduledata);

	EventMgr_RegisterEvent(g_moduleXpSys, "Event_OnEventsRegister", "XpSys_OnEventsRegister");

	//ConfigMgr_Register(g_moduleXpSys, "XpSys_OnConfigReload", "configs/cmod/xpsys_config.txt");

	g_hCmodExpKill = CreateConVar("cmod_expkill", "10", "Kill exp");
	g_hCmodExpAsist = CreateConVar("cmod_expasist", "3", "Kill for asist");
	g_hCmodExpWin = CreateConVar("cmod_expwin", "20", "Win exp");
	g_hCmodExpBomb = CreateConVar("cmod_expbomb", "30", "Bomb exp");
	g_hCmodExpHost = CreateConVar("cmod_exphost", "30", "Host exp");
	g_hCmodBotExpKill = CreateConVar("cmod_botexpkill", "10", "Kill bot exp");
	g_hCmodVipBonusExp = CreateConVar("cmod_vipbonusexp", "10", "Ile wiecej w % expa ma dosttawac vip");
	g_hCmodMaxLvl = CreateConVar("cmod_maxlvl", "200", "Max lvl");
	g_hCmodLvlRatio = CreateConVar("cmod_lvlratio", "35", "exp for 1st lvl");
	g_hCmodMinPlayers = CreateConVar("cmod_min_players", "3", "Minimalna liczba graczy aby przyznawany byl exp");
	
	g_hCmodExpOdGodz = CreateConVar("cmod_exp_od_godz", "22", "Od ktorej zwiekszyc expa");
	g_hCmodExpDoGodz = CreateConVar("cmod_exp_do_godz", "10", "Do ktorej zwiekszyc expa");
	g_hCmodExpBonusGodz = CreateConVar("cmod_exp_bonus_godz", "0.5", "(liczba rzeczywista) o ile wiecej expa przyznawac");
	
	if(ExpGodzTimer != INVALID_HANDLE)
		ExpGodzTimer = CreateTimer(60.0, SprawdzGodz, _, TIMER_REPEAT);

	AutoExecConfig(true, "cmod");
}

public Action:SprawdzGodz(Handle:timer, any:client)
{
	new String:godzina_str[8];
	FormatTime(godzina_str, sizeof(godzina_str), "%H", GetTime());
	new godzina = StringToInt(godzina_str);
	
	new odgodziny = GetConVarInt(g_hCmodExpOdGodz),
	dogodziny = GetConVarInt(g_hCmodExpDoGodz);
	
	if(odgodziny > dogodziny)
	{
		if(godzina >= odgodziny || godzina < dogodziny)
		ExpGodzAktywne = true;
	}
	else
	{
		if(godzina >= odgodziny && godzina < dogodziny)
		ExpGodzAktywne = false;
	} 
}

public XpSys_OnEventsRegister()
{
	#if defined EVENT_MANAGER

		#if defined PROJECT_GAME_CSGO
			EventMgr_RegisterEvent(g_moduleXpSys, "Event_OnClientPutInServer", "XpSys_OnClientPutInServer");
			EventMgr_RegisterEvent(g_moduleXpSys, "Event_PlayerDeath", "XpSys_PlayerDeath");
			EventMgr_RegisterEvent(g_moduleXpSys, "Event_RoundEnd", "XpSys_RoundEnd");
			EventMgr_RegisterEvent(g_moduleXpSys, "Event_PlantBomb", "XpSys_PlantBomb");
			EventMgr_RegisterEvent(g_moduleXpSys, "Event_DefuseBomb", "XpSys_DefuseBomb");
			EventMgr_RegisterEvent(g_moduleXpSys, "Event_RescueHost", "XpSys_RescueHost");
		#endif

	#endif
}
public XpSys_OnClientPutInServer(client)
{
	g_iCmodLvl[client] = 1;
	g_iCmodExp[client] = 0;
}

#if defined PROJECT_GAME_CSGO
public XpSys_PlayerDeath(victim, attacker, String:weapon[], headshoot){
	if(/*!IsFakeClient(attacker) && */(attacker != victim)){
		new _iExp = GetConVarInt(g_hCmodExpKill) + g_iCmodBonusExp[attacker];
		if(!IsFakeClient(victim)){
			if(g_iCmodLvl[victim] > g_iCmodLvl[attacker])
				_iExp += (g_iCmodLvl[victim] - g_iCmodLvl[attacker])*(GetConVarInt(g_hCmodExpKill)/10);

		}else{
			_iExp = GetConVarInt(g_hCmodBotExpKill);
		}
		XpSys_GiveExp(attacker, _iExp, _:exp_zabojstwo);
	}
}
public XpSys_RoundEnd(winner)
{
	new i, team;
	new _iExp = GetConVarInt(g_hCmodExpWin);
	for(i = 1; i <= MAXPLAYERS-1; i++)
	{
		if(!IsClientInGame(i))
			continue;
		if(!IsFakeClient(i))
		{
			team = GetClientTeam(i);
			if(team == winner)
			{
				XpSys_GiveExp(i, _iExp, exp_wygrana_runda);
			}
		}
	}
}
public XpSys_PlantBomb(client)
{
	new i, team, team_planted;
	team_planted = GetClientTeam(client);
	new _iExp_planted = GetConVarInt(g_hCmodExpBomb);
	new _iExp = GetConVarInt(g_hCmodExpKill);
	XpSys_GiveExp(client, _iExp_planted, exp_paka_podlozona);
	for(i = 1; i <= MAXPLAYERS-1; i++)
	{
		if(!IsClientInGame(i))
			continue;
		if(!IsFakeClient(i) && i != client)
		{
			team = GetClientTeam(i);
			if(team == team_planted)
			{
				XpSys_GiveExp(i, _iExp, exp_paka_asysta_TT);
			}
		}
	}
}
public XpSys_DefuseBomb(client)
{
	new i, team, team_defused;
	team_defused = GetClientTeam(client);
	new _iExp_defused = GetConVarInt(g_hCmodExpBomb);
	new _iExp = GetConVarInt(g_hCmodExpKill);
	XpSys_GiveExp(client, _iExp_defused, exp_paka_rozbrojona);
	for(i = 1; i <= MAXPLAYERS-1; i++)
	{
		if(!IsClientInGame(i))
			continue;
		if(!IsFakeClient(i) && i != client)
		{
			team = GetClientTeam(i);
			if(team == team_defused)
			{
				XpSys_GiveExp(i, _iExp, exp_paka_asysta_CT);
			}
		}
	}
}
public XpSys_RescueHost(client)
{
	new _iExp = GetConVarInt(g_hCmodExpHost);
	if(!IsFakeClient(client))
	{
		XpSys_GiveExp(client, _iExp, exp_hosty);
	}
}
#endif

XpSys_GiveExp(client, value, info){
	if(!(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client)))
		return 0;
  if(g_iCmodPlayerClass[client])
    return 0;

	new ilosc_graczy = GetClientCount(true), min_graczy = GetConVarInt(g_hCmodMinPlayers);
	if(ilosc_graczy < min_graczy)
	{
		PrintToChat(client, "\x01\x0B\x01 \x07%s Min ilosc graczy aby przyznawany byl exp to %i", MOD_TAG, min_graczy);
		return 0;
	}
	if(GetAdminFlag(GetUserAdmin(client), Admin_Reservation))
	{
		new Float:_iExp_bonus = GetConVarFloat(g_hCmodVipBonusExp);
		value += RoundFloat(value * _iExp_bonus);
	}
	if(ExpGodzAktywne)
	{
		new Float:_iExp_bonus = GetConVarFloat(g_hCmodExpBonusGodz);
		value += RoundFloat(value * _iExp_bonus);
	}
	g_iCmodExp[client] += value;
	
	PrintToChat(client, "\x01\x0B\x01 \x07%s \x06Otrzymujesz \x03+%dxp \x06za %s!", MOD_TAG, value, exp_info[info]);
	
	XpSys_CheckLvl(client);

	return 1;
}

XpSys_CheckLvl(client){
	new bool:_bLvlUp = false;
	new bool:_bLvlDown = false;

	if(!IsClientConnected(client))
		return;

	while(g_iCmodExp[client] >= XpSys_GetXpForLvl(g_iCmodLvl[client]) && g_iCmodLvl[client] < GetConVarInt(g_hCmodMaxLvl)){
		g_iCmodLvl[client]++;

		#if defined STATS_SYS
			//g_iStatsSysPoints[client] = (g_iXpSysLvl[client]-1)*2-g_iStatsSysINT[client]-g_iStatsSysCON[client]-g_iStatsSysSTR[client]-g_iStatsSysDEX[client];
		#endif

		_bLvlUp = true;
	}
	while(g_iCmodExp[client] < XpSys_GetXpForLvl(g_iCmodLvl[client]-1)){
		g_iCmodLvl[client]--;
		_bLvlDown = true;
	}

	if(g_iCmodLvl[client] > GetConVarInt(g_hCmodMaxLvl)){
		g_iCmodLvl[client] = GetConVarInt(g_hCmodMaxLvl);

		#if defined STATS_RESET
			Stats_Reset_Start(client);
		#endif

	}

	if(_bLvlDown){
		#if defined STATS_RESET
			Stats_Reset_Start(client);
		#endif
		PrintToChat(client, "\x01\x0B\x01 \x07%s \x06Spadłeś na \x03%d \x06poziom!", MOD_TAG, g_iCmodLvl[client]);
	}else if(_bLvlUp){

		#if defined STATS_MENU
			g_iCmodPlayerPoint[client] = (g_iCmodLvl[client]-1)*2-g_iCmodPlayerINT[client]-g_iCmodPlayerCON[client]-g_iCmodPlayerSTR[client]-g_iCmodPlayerDEX[client];
//			Stats_Menu_Show(client);
		#endif

		PrintToChat(client, "\x01\x0B\x01 \x07%s \x06Awansowałeś na \x03%d \x06poziom!", MOD_TAG, g_iCmodLvl[client]);
		EmitSoundToClient(client, "*cod_csnajper/skills/csnajper_up.mp3");
		g_player_class_lvl[client][g_iCmodPlayerClass[client]] = g_iCmodLvl[client];
	}
}

stock XpSys_GetXpForLvl(lvl){
	return lvl*lvl*GetConVarInt(g_hCmodLvlRatio);
}
