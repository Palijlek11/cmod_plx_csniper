/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          Weapons.inc
 *  Type:          Module
 *  Description:   Allow/Deny Class weapons for player
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
native GiveMoreWeapons(client, const String:weapon[]);
native RemoveMoreWeapons(client, const String:weapon[]);

#if defined CLASS_SYS
#define CLASS_WEAPONS

stock Module:g_moduleClass_Weapons;

public Class_Weapons_OnPluginStart(){
	new moduledata[ModuleData];

	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Class Weapons");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Class_Weapons");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Allow/Deny Class weapons for player");
	moduledata[ModuleData_Dependencies][0] = g_moduleClassSys;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;

	g_moduleClass_Weapons = ModuleMgr_Register(moduledata);

	EventMgr_RegisterEvent(g_moduleClass_Weapons, "Event_OnEventsRegister", "Class_Weapons_OnEventsRegister");

	g_hCmodAllowsWeapons = CreateArray(32);

	for(new i; i <= MAXPLAYERS; i++){
		g_hCmodPlayerAllowsWeapons[i] = CreateArray(32);
		g_hCmodPlayerBonusWeapons[i] = CreateArray(32);
	}

	#if defined PROJECT_GAME_CSGO
		PushArrayString(g_hCmodAllowsWeapons, "weapon_hkp2000");
		PushArrayString(g_hCmodAllowsWeapons, "weapon_c4");
		PushArrayString(g_hCmodAllowsWeapons, "item_defuser");
		PushArrayString(g_hCmodAllowsWeapons, "weapon_knife");

//		PushArrayString(g_hCmodClassWeapons[0], "weapon_glock");
//		PushArrayString(g_hCmodClassWeapons[0], "weapon_hkp2000");
	#endif

}

public Class_Weapons_OnEventsRegister(){
	#if defined EVENT_MANAGER
		EventMgr_RegisterEvent(g_moduleClass_Weapons, "Event_OnClassChangeSuccess", "Class_Weapons_OnClassChangeSuccess");
		#if defined PROJECT_GAME_CSGO
			EventMgr_RegisterEvent(g_moduleClass_Weapons, "Event_OnClientPutInServer", "Class_Weapons_EventOnClientPutInServer");
			EventMgr_RegisterEvent(g_moduleClass_Weapons, "Event_OnClientDisconnect", "Class_Weapons_EventOnClientDisconnect");

//			EventMgr_RegisterEvent(g_moduleClass_Weapons, "Event_ItemEquip", "Class_Weapons_EventItemEquip");
			EventMgr_RegisterEvent(g_moduleClass_Weapons, "Event_PlayerSpawn", "Class_Weapons_EventPlayerSpawn");
//			EventMgr_RegisterEvent(g_moduleClass_Weapons, "Event_ItemPickUp", "Class_Weapons_EventItemPickUp");
//			EventMgr_RegisterEvent(g_moduleClass_Weapons, "Event_PlayerDeath", "Weapon_PlayerDeath_EventPlayerDeath");
		#endif

	#endif
}

public Class_Weapons_OnClassChangeSuccess(client){
	Class_Weapons_RemoveAllWeapons(client);
	CreateTimer(0.1, Class_Weapons_Timer, client, TIMER_FLAG_NO_MAPCHANGE);
}

#if defined PROJECT_GAME_CSGO
/*public Action:Class_Weapons_EventItemPickUp(client, String:weapon[]){
	PrintToChat(client, "Sprawdzam bron %s", weapon);
	if(Class_Weapons_CheckPlayerWeapon(client, weapon)){
		PrintToChat(client, "Bron %s jest niedozwolona", weapon);
		return Plugin_Handled;
	}
	return Plugin_Continue;

}*/

public Action:Class_Weapons_EventOnClientPutInServer(client){
	SDKHook(client, SDKHook_WeaponCanUse, OnWeaponCanUse);
}

public Action:Class_Weapons_EventOnClientDisconnect(client){
	SDKUnhook(client, SDKHook_WeaponCanUse, OnWeaponCanUse);
}

public Action:OnWeaponCanUse(client, weapon){
	decl String:_buffer[64];
	GetEdictClassname(weapon, _buffer, sizeof(_buffer));
	if(Class_Weapons_CheckPlayerWeapon(client, _buffer) && !GrabWeapons[client]){
//		AcceptEntityInput(weapon, "Kill");
//		CS_DropWeapon(client, weapon, false, false);
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Class_Weapons_EventPlayerSpawn(client){
	CreateTimer(0.1, Class_Weapons_Timer, client, TIMER_FLAG_NO_MAPCHANGE);
	//Class_Weapons_GiveWeapons(client);
}

public Action:Class_Weapons_Timer(Handle:timer, any:client){
	Class_Weapons_GiveWeapons(client);
}
#endif



stock Class_Weapons_CheckPlayerWeapon(client, String:_buffer[]){
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client)){

		decl	String:_weapon[32],
				_tmpCount,
				_tmpClass;

		_tmpClass = g_iCmodPlayerClass[client];
		_tmpCount = GetArraySize(g_hCmodClassWeapons[_tmpClass]);
		for(new i; i < _tmpCount; i++){
			GetArrayString(g_hCmodClassWeapons[_tmpClass], i, _weapon, sizeof(_weapon));
			if(StrEqual(_weapon, _buffer))
				return 0;
		}

		_tmpCount = GetArraySize(g_hCmodPlayerBonusWeapons[client]);
		for(new i; i < _tmpCount; i++){
			GetArrayString(g_hCmodPlayerBonusWeapons[client], i, _weapon, sizeof(_weapon));
			if(StrEqual(_weapon, _buffer))
				return 0;
		}

		_tmpCount = GetArraySize(g_hCmodPlayerAllowsWeapons[client]);
		for(new i; i < _tmpCount; i++){
			GetArrayString(g_hCmodPlayerAllowsWeapons[client], i, _weapon, sizeof(_weapon));
			if(StrEqual(_weapon, _buffer))
				return 0;
		}

		//sniper
		if(g_iCmodPlayerItem[client] && g_hCmodItemWeapons[g_iCmodPlayerItem[client]] != INVALID_HANDLE)
		{
			new size = GetArraySize(g_hCmodItemWeapons[g_iCmodPlayerItem[client]]);
			if(size)
			{
				for(new i; i < size; i++)
				{
					GetArrayString(g_hCmodItemWeapons[g_iCmodPlayerItem[client]], i, _weapon, sizeof(_weapon));
					if(StrEqual(_weapon, _buffer))
					{
						return 0;
					}
				}
			}
		}

		_tmpCount = GetArraySize(g_hCmodAllowsWeapons);
		for(new i; i < _tmpCount; i++){
			GetArrayString(g_hCmodAllowsWeapons, i, _weapon, sizeof(_weapon));
			if(StrEqual(_weapon, _buffer))
				return 0;
		}

		return 1;
	}
	return 0;
}

stock Class_Weapons_RemoveAllWeapons(client){
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && !IsFakeClient(client) && IsPlayerAlive(client)){
		for(new slot = 0; slot < 4; slot ++)
		{
			if(slot == 2)
				continue;
			new weapon_index = -1;
			while((weapon_index = GetPlayerWeaponSlot(client, slot)) != -1)
			{
				if(IsValidEntity(weapon_index))
				{
					RemovePlayerItem(client, weapon_index);
					AcceptEntityInput(weapon_index, "kill");
				}
			}
		}
	}
}

stock Class_Weapons_GiveWeapons(client){
	if(client >= 1 && client <= MaxClients && IsClientConnected(client) && IsClientInGame(client) && IsPlayerAlive(client)){
		decl String:_buffer[32];

		new weaponIndex;
		for(new slot = 0; slot < 2; slot++)
		{
			while ((weaponIndex = GetPlayerWeaponSlot(client, slot)) != -1)
			{
				RemovePlayerItem(client, weaponIndex);
				AcceptEntityInput(weaponIndex, "kill");
			}
		}

		for(new i; i < GetArraySize(g_hCmodClassWeapons[g_iCmodPlayerClass[client]]); i++){
			GetArrayString(g_hCmodClassWeapons[g_iCmodPlayerClass[client]], i, _buffer, sizeof(_buffer));
			GiveMoreWeapons(client, _buffer);
		}

		for(new i; i < GetArraySize(g_hCmodPlayerBonusWeapons[client]); i++){
			GetArrayString(g_hCmodPlayerBonusWeapons[client], i, _buffer, sizeof(_buffer));
			GivePlayerItem(client, _buffer);
		}

		if(g_iCmodPlayerItem[client] && g_hCmodItemWeapons[g_iCmodPlayerItem[client]] != INVALID_HANDLE)
		{
			new size = GetArraySize(g_hCmodItemWeapons[g_iCmodPlayerItem[client]]);

			if(size)
			{
				for(new i; i < size; i++)
				{
					GetArrayString(g_hCmodItemWeapons[g_iCmodPlayerItem[client]], i, _buffer, sizeof(_buffer));
					GiveMoreWeapons(client, _buffer);
				}
			}
		}

		new team = GetClientTeam(client);
		if(!(GetEntProp(client, Prop_Send, "m_bHasDefuser")) && team == CS_TEAM_CT)
		{
			GivePlayerItem(client, "item_defuser");
		}
	}
}

#endif
