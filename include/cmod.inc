#if defined _cmod_included
 #endinput
#endif
#define _cmod_included

#if !defined _sdkhooks_included
#include <sdkhooks>
#endif

#define CMOD_DISABLE -1
#define CMOD_CONTINUE 0
#define MOD_TAG "[Cod Mod]"

#define IsValidClient(%1)  ( 1 <= %1 <= MaxClients)
#define IsValidAlive(%1) ( 1 <= %1 <= MaxClients && IsClientInGame(%1) && IsPlayerAlive(%1) )

/**
 * ----------------------------------------
 *                   Stats
 * ----------------------------------------
 */

native Cmod_GetClientPoint(const client);

native Cmod_SetClientPoint(const client, const value);

native Cmod_GetClientINT(const client);

native Cmod_SetClientINT(const client, const value);

native Cmod_GetClientCON(const client);

native Cmod_SetClientCON(const client, const value);

native Cmod_GetClientSTR(const client);

native Cmod_SetClientSTR(const client, const value);

native Cmod_GetClientDEX(const client);

native Cmod_SetClientDEX(const client, const value);

native Cmod_GetBonusINT(const client);

native Cmod_SetBonusINT(const client, const value);

native Cmod_GetBonusCON(const client);

native Cmod_SetBonusCON(const client, const value);

native Cmod_GetBonusSTR(const client);

native Cmod_SetBonusSTR(const client, const value);

native Cmod_GetBonusDEX(const client);

native Cmod_SetBonusDEX(const client, const value);

native Cmod_GetClassINT(const ClassID);

native Cmod_GetClassCON(const ClassID);

native Cmod_GetClassSTR(const ClassID);

native Cmod_GetClassDEX(const ClassID);

native Cmod_SetClassINT(const ClassID, const value);

native Cmod_SetClassCON(const ClassID, const value);

native Cmod_SetClassSTR(const ClassID, const value);

native Cmod_SetClassDEX(const ClassID, const value);
/*
native Cmod_GetINT(client, pPoint, cPoint, bPoint);
native Cmod_GetCON(client, pPoint, cPoint, bPoint);
native Cmod_GetSTR(client, pPoint, cPoint, bPoint);
native Cmod_GetDEX(client, pPoint, cPoint, bPoint);
*/
native Cmod_ResetPlayerStats(const client);

native Cmod_ShowStatsMenu(const client);

native Float:Cmod_GetResistance(const client);

/**
 * ----------------------------------------
 *                  lvl/exp
 * ----------------------------------------
 */
  
native Cmod_GetClientExp(const client);

native Cmod_SetClientExp(const client, const value);

native Cmod_GetClientBonusExp(const client);

native Cmod_SetClientBonusExp(const client, const value);

native Cmod_GetExpForLvl(const lvl);

native Cmod_CheckClientLvl(const client);  
  
/** 
 * ----------------------------------------
 *                  Class
 * ----------------------------------------
 */
 
native Cmod_RegisterClass(const String:name[], const String:desc[], const pINT = 0, const pCON = 0, const pSTR = 0, const pDEX = 0, const pARM = 0, const Handle:weapons = INVALID_HANDLE);

native Cmod_GetClientClass(const client);

native Cmod_GetClassNameByID(const ClassID, const String:buffer[], const MaxLeng);

native Cmod_GetClassIDByName(const String:ClassName);

native Cmod_GetClassDesc(const ClassID, const String:buffer[], const MaxLeng);

native Cmod_SortClass();

native Handle:Cmod_GetClassWeapons(const ClassID);

native Handle:Cmod_GetClientWeapons(const ClassID);

native Handle:Cmod_GetAllowWeapons(const ClassID);

native BonusDMG(client, ileKlasa, ileItem)
native BonusReduction(client, ileKlasa, ileItem)

//wiecej broni
native GiveMoreWeapons(client, const String:weapon[])

forward Cmod_OnClassEnabled(client, classID);

forward Cmod_OnClassDisabled(client, classID);

forward Cmod_OnClientUseSkill(client, classID);

forward Cmod_OnGetNewClassID(oldClassID, newClassID);
 
/** 
 * ----------------------------------------
 *                  Item
 * ----------------------------------------
 */

native Cmod_RegisterItem(const String:name[], const String:desc[], const minValue = 0, const maxValue = 0, const dur = 250, const Handle:weapons = INVALID_HANDLE, const cost = 0);

native Cmod_GetClientItem(const client);

native Cmod_GetItemNameByID(const ItemID, const String:buffer[], const MaxLeng);

native Cmod_GetItemIDByName(const String:ItemName[]);

native Cmod_GetItemDesc(const ItemID, const String:buffer[], const MaxLeng);

native Cmod_GetMinItemValue(const ItemID);

native Cmod_GetMaxItemValue(const ItemID)

native Cmod_GetClientItemValue(const client);

native Cmod_SetMinItemValue(const ItemID, const value);

native Cmod_SetMaxItemValue(const ItemID, const value);

native Cmod_SetClientItemValue(const client, const value);

native Cmod_GetItemCount();

native Cmod_SetClientItem(const client, const value);

forward Cmod_OnItemEnabled(client, ItemID, value);

forward Cmod_OnItemDisabled(client, ItemID);

forward Cmod_OnClientUseItem(client, ItemID);

/**
 * ----------------------------------------
 *                   Stock
 * ----------------------------------------
 */

stock Cmod_GetINT(const client){
	new _point;
	_point += Cmod_GetClientINT(client);
	_point += Cmod_GetClassINT(client);
	_point += Cmod_GetBonusINT(client);
	return _point;
}

stock Cmod_GetCON(const client){
	new _point;
	_point += Cmod_GetClientCON(client);
	_point += Cmod_GetClassCON(client);
	_point += Cmod_GetBonusCON(client);
	return _point;
}

stock Cmod_GetSTR(const client){
	new _point;
	_point += Cmod_GetClientSTR(client);
	_point += Cmod_GetClassSTR(client);
	_point += Cmod_GetBonusSTR(client);
	return _point;
}

stock Cmod_GetDEX(const client){
	new _point;
	_point += Cmod_GetClientDEX(client);
	_point += Cmod_GetClassDEX(client);
	_point += Cmod_GetBonusDEX(client);
	return _point;
}

stock Cmod_InflictDMG(victim, inflictor, attacker, Float:damage, damageType=DMG_GENERIC, weapon=-1, const Float:damageForce[3]=NULL_VECTOR, const Float:damagePosition[3]=NULL_VECTOR){
	new Float:_tmp = FloatSub(damage, FloatMul(damage, Cmod_GetResistance(victim)));
	if(FloatCompare(_tmp, 0.0) == 1)
		damage = _tmp;
	else
		damage = 1.0;
	SDKHooks_TakeDamage(victim, inflictor, attacker, damage, damageType, weapon, damageForce, damagePosition); 
}
