/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          itemlib.inc
 *  Type:          Libary
 *  Description:   
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
 
//native RemoveMoreWeapons(client, const String:weapon[]);

#if defined _itemlib
 #endinput
#endif
#define _itemlib

stock Item_Set(client, ItemID){
	new Function:_func;
	new _iValue;
	_func = GetFunctionByName(g_hCmodItemPlugin[g_iCmodPlayerItem[client]], "Cmod_OnItemDisabled");
	if(_func !=  INVALID_FUNCTION){
		Call_StartFunction(g_hCmodItemPlugin[g_iCmodPlayerItem[client]], _func);
		Call_PushCell(client);
		Call_PushCell(g_iCmodPlayerItem[client]);
		Call_Finish();
	}
	
	_iValue = GetRandomInt(g_iCmodItemMinValue[ItemID], g_iCmodItemMaxValue[ItemID]);
	
	_func = GetFunctionByName(g_hCmodItemPlugin[ItemID], "Cmod_OnItemEnabled");
	if(_func !=  INVALID_FUNCTION){
		Call_StartFunction(g_hCmodItemPlugin[ItemID], _func);
		Call_PushCell(client);
		Call_PushCell(ItemID);
		Call_PushCell(_iValue);
		Call_Finish();
	}
	
	if(ItemID)
		g_iCmodPlayerItemDur[client] = g_iCmodItemDurability[ItemID];
	else
		g_iCmodPlayerItemDur[client] = 0;
	
	if(ItemID)
	{
		if(g_hCmodItemWeapons[ItemID] != INVALID_HANDLE)
		{
			new size = GetArraySize(g_hCmodItemWeapons[ItemID]);
			decl String:_buffer[32];
			if(size)
			{
				for(new i; i < size; i++)
				{
					GetArrayString(g_hCmodItemWeapons[ItemID], i, _buffer, sizeof(_buffer));
					GiveMoreWeapons(client, _buffer);
				}
			}
		}
	}
	else if(g_hCmodItemWeapons[g_iCmodPlayerItem[client]] != INVALID_HANDLE)
	{
		new _tmpCount = GetArraySize(g_hCmodItemWeapons[g_iCmodPlayerItem[client]]);
		decl String:_weapon[32];
		if(_tmpCount)
		{
			new i;
			for(i = 0; i < _tmpCount; i++)
			{
				GetArrayString(g_hCmodItemWeapons[g_iCmodPlayerItem[client]], i, _weapon, sizeof(_weapon));
				RemoveMoreWeapons(client, _weapon);
			}
		}
	}
	
	g_iCmodPlayerItem[client] = ItemID;
	g_iCmodPlayerItemValue[client] = _iValue;
}

