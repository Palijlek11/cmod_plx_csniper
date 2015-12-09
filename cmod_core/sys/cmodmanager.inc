/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          cmodmanager.inc
 *  Type:          Manager
 *  Description:   None
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

stock	g_iCmodExp[MAXPLAYERS+1],
		g_iCmodLvl[MAXPLAYERS+1],
		g_iCmodBonusExp[MAXPLAYERS+1],
		Handle:g_hCmodExpKill,
		Handle:g_hCmodExpAsist,
		Handle:g_hCmodExpWin,
		Handle:g_hCmodExpBomb,
		Handle:g_hCmodExpHost,
		Handle:g_hCmodBotExpKill,
		Handle:g_hCmodVipBonusExp,
		Handle:g_hCmodMaxLvl,
		Handle:g_hCmodLvlRatio,
		//sniper
		Handle:g_hCmodMinPlayers,
		Handle:g_hCmodForum,
		Handle:g_hCmodForumColor,
		Handle:g_hCmodItemDur,
		Handle:g_hCmodDurPerhit,
		Handle:g_hCmodDurStyle,
		Handle:g_hCmodExpOdGodz,
		Handle:g_hCmodExpDoGodz,
		Handle:g_hCmodExpBonusGodz,
		itemDur,
		Float:bonusDmgKlasa[MAXPLAYERS+1],
		Float:bonusDmgItem[MAXPLAYERS+1],
		Float:bonusReductionKlasa[MAXPLAYERS+1],
		Float:bonusReductionItem[MAXPLAYERS+1],
		bool:GrabWeapons[MAXPLAYERS+1];

stock	Handle:g_hCmodClassPlugin[MAX_CLASS_NUMBER+1],
		String:g_sCmodClassName[MAX_CLASS_NUMBER+1][MAX_NAME_LONG+1],
		String:g_sCmodClassDesc[MAX_CLASS_NUMBER+1][MAX_DESC_LONG+1],
		g_iCmodClassCount,
		g_iCmodPlayerClass[MAXPLAYERS+1],
		g_iCmodPlayerNextClass[MAXPLAYERS+1],
		g_player_class_lvl[MAXPLAYERS+1][MAX_CLASS_NUMBER];

stock	Handle:g_hCmodItemPlugin[MAX_ITEM_NUMBER+1],
		String:g_sCmodItemName[MAX_ITEM_NUMBER+1][MAX_NAME_LONG+1],
		String:g_sCmodItemDesc[MAX_ITEM_NUMBER+1][MAX_DESC_LONG+1],
		g_iCmodItemMaxValue[MAX_ITEM_NUMBER+1],
		g_iCmodItemMinValue[MAX_ITEM_NUMBER+1],
		g_iCmodItemDurability[MAX_ITEM_NUMBER+1],
		g_iCmodItemCount,
		g_iCmodPlayerItem[MAXPLAYERS+1],
		g_iCmodPlayerItemDur[MAXPLAYERS+1],
		g_iCmodPlayerItemValue[MAXPLAYERS+1];

stock	Handle:g_hCmodAllowsWeapons,
		Handle:g_hCmodPlayerAllowsWeapons[MAXPLAYERS+1],
		Handle:g_hCmodPlayerBonusWeapons[MAXPLAYERS+1];

stock	Handle:g_hCmodClassWeapons[MAX_CLASS_NUMBER+1];

stock	Handle:g_hCmodItemWeapons[MAX_ITEM_NUMBER+1];

stock	g_iCmodPlayerPoint[MAXPLAYERS+1],
		g_iCmodPlayerINT[MAXPLAYERS+1],
		g_iCmodPlayerCON[MAXPLAYERS+1],
		g_iCmodPlayerSTR[MAXPLAYERS+1],
		g_iCmodPlayerDEX[MAXPLAYERS+1];

stock	g_iCmodClassINT[MAX_CLASS_NUMBER+1],
		g_iCmodClassCON[MAX_CLASS_NUMBER+1],
		g_iCmodClassSTR[MAX_CLASS_NUMBER+1],
		g_iCmodClassDEX[MAX_CLASS_NUMBER+1],
		g_iCmodClassARM[MAX_CLASS_NUMBER+1];

stock	g_iCmodBonusINT[MAXPLAYERS+1],
		g_iCmodBonusCON[MAXPLAYERS+1],
		g_iCmodBonusSTR[MAXPLAYERS+1],
		g_iCmodBonusDEX[MAXPLAYERS+1];

stock	Handle:g_hCmodSQL;
stock	String:g_sCmodSQLError[DB_ERROR_BUFFER_SIZE+1];

stock	Float:g_iCmodSpeed[MAXPLAYERS+1];
