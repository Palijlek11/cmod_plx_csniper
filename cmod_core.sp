#pragma semicolon 1

#include <sourcemod>

//Base (don't touch)
#include "cmod_core\project"
#include "cmod_core\base\wrappers"
#include "cmod_core\base\versioninfo"
//#include "cmod_core/base/accessmanager"
//#include "cmod_core/base/translationsmanager"
#include "cmod_core\base\logmanager"
#include "cmod_core\base\configmanager"
#include "cmod_core\base\eventmanager"
#include "cmod_core\base\modulemanager"

//Cmod manager:
#include "cmod_core\sys\cmodmanager"

//Cmod module:
#include "cmod_core\sys\sql"

#include "cmod_core\sys\stats"
	#include "cmod_core\sys\stats\Menu"
	#include "cmod_core\sys\stats\Reset"

#include "cmod_core\sys\xp"

#include "cmod_core\sys\class"
	#include "cmod_core\sys\class\Weapons"
	#include "cmod_core\sys\class\Sort"
	#include "cmod_core\sys\class\Menu"
	#include "cmod_core\sys\class\Desc"
	#include "cmod_core\sys\class\Skill"

#include "cmod_core\sys\item"
	#include "cmod_core\sys\item\PlayerKill"
	#include "cmod_core\sys\item\Durability"
	#include "cmod_core\sys\item\Desc"
	#include "cmod_core\sys\item\Drop"
	#include "cmod_core\sys\item\Active"

#include "cmod_core\sys\ui"

//Native:
#include "cmod_core\sys\stats\Native"
#include "cmod_core\sys\xp\Native"
#include "cmod_core\sys\class\Native"
#include "cmod_core\sys\item\Native"

#include "cmod_core\sys\shop"
#include "cmod_core\sys\help"
#include "cmod_core\sys\wymien"

public Plugin:myinfo = {
	name = PROJECT_FULLNAME,
	author = PROJECT_AUTHOR,
	description = PROJECT_DESCRIPTION,
	version = PROJECT_VERSION,
	url = PROJECT_URL
};

public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	#if defined STATS_SYS
		#if defined STATS_NATIVE
			CreateNative("Cmod_GetClientPoint", Stats_Native_GetPlayerPoint);
			CreateNative("Cmod_SetClientPoint", Stats_Native_SetPlayerPoint);
			CreateNative("Cmod_GetClientINT", Stats_Native_GetPlayerINT);
			CreateNative("Cmod_SetClientINT", Stats_Native_SetPlayerINT);
			CreateNative("Cmod_GetClientCON", Stats_Native_GetPlayerCON);
			CreateNative("Cmod_SetClientCON", Stats_Native_SetPlayerCON);
			CreateNative("Cmod_GetClientSTR", Stats_Native_GetPlayerSTR);
			CreateNative("Cmod_SetClientSTR", Stats_Native_SetPlayerSTR);
			CreateNative("Cmod_GetClientDEX", Stats_Native_GetPlayerDEX);
			CreateNative("Cmod_SetClientDEX", Stats_Native_SetPlayerDEX);
			CreateNative("Cmod_GetBonusINT", Stats_Native_GetBonusINT);
			CreateNative("Cmod_SetBonusINT", Stats_Native_SetBonusINT);
			CreateNative("Cmod_GetBonusCON", Stats_Native_GetBonusCON);
			CreateNative("Cmod_SetBonusCON", Stats_Native_SetBonusCON);
			CreateNative("Cmod_GetBonusSTR", Stats_Native_GetBonusSTR);
			CreateNative("Cmod_SetBonusSTR", Stats_Native_SetBonusSTR);
			CreateNative("Cmod_GetBonusDEX", Stats_Native_GetBonusDEX);
			CreateNative("Cmod_SetBonusDEX", Stats_Native_SetBonusDEX);
			CreateNative("Cmod_ResetPlayerStats", Stats_Native_ResetPlayerStats);
			CreateNative("Cmod_ShowStatsMenu", Stats_Native_ShowStatsMenu);
//			CreateNative("Cmod_GetResistance", Stats_Native_GetResistance);
			CreateNative("Cmod_SetSpeed", Stats_Native_SetSpeed);
		#endif
	#endif

	#if defined XP_SYS
		#if defined XP_NATIVE
			CreateNative("Cmod_GetClientExp", Xp_Native_GetClientExp);
			CreateNative("Cmod_SetClientExp", Xp_Native_SetClientExp);
			CreateNative("Cmod_GetClientBonusExp", Xp_Native_GetClientBonusExp);
			CreateNative("Cmod_SetClientBonusExp", Xp_Native_SetClientBonusExp);
			CreateNative("Cmod_GetExpForLvl", Xp_Native_GetExpForLvl);
			CreateNative("Cmod_CheckClientLvl", Xp_Native_CheckClientLvl);
		#endif
	#endif

	#if defined CLASS_SYS
		CreateNative("Cmod_RegisterClass", ClassSys_Register);
		#if defined CLASS_NATIVE
			CreateNative("Cmod_GetClientClass", Class_Native_GetClientClass);
			CreateNative("Cmod_GetClassNameByID", Class_Native_GetClassNameByID);
			CreateNative("Cmod_GetClassIDByName", Class_Native_GetClassIDByName);
			CreateNative("Cmod_GetClassDesc", Class_Native_GetClassDesc);
			CreateNative("Cmod_SortClass", Class_Native_SortClass);

			CreateNative("Cmod_GetClassINT", Class_Native_GetClassINT);
			CreateNative("Cmod_GetClassCON", Class_Native_GetClassCON);
			CreateNative("Cmod_GetClassSTR", Class_Native_GetClassSTR);
			CreateNative("Cmod_GetClassDEX", Class_Native_GetClassDEX);
			CreateNative("Cmod_GetClassARM", Class_Native_GetClassARM);
			CreateNative("Cmod_SetClassINT", Class_Native_SetClassINT);
			CreateNative("Cmod_SetClassCON", Class_Native_SetClassCON);
			CreateNative("Cmod_SetClassSTR", Class_Native_SetClassSTR);
			CreateNative("Cmod_SetClassDEX", Class_Native_SetClassDEX);
			CreateNative("Cmod_SetClassARM", Class_Native_SetClassARM);

			CreateNative("Cmod_GetClassWeapons", Class_Native_GetClassWeapons);
			CreateNative("Cmod_GetClientWeapons", Class_Native_GetClientWeapons);
			CreateNative("Cmod_GetAllowWeapons", Class_Native_GetAllowWeapons);
			CreateNative("Cmod_GetClientBonusWeapons", Class_Native_GetBonusWeapons);

			CreateNative("BonusDMG", Class_Native_SetBonusDMG);
			CreateNative("BonusReduction", Class_Native_SetBonusReduction);
			CreateNative("GrabWeapons", Class_Native_GrabWeapons);
		#endif
	#endif

	#if defined ITEM_SYS
		CreateNative("Cmod_RegisterItem", ItemSys_Register);
		#if defined ITEM_NATIVE
			CreateNative("Cmod_GetClientItem", Item_Native_GetClientItem);
			CreateNative("Cmod_GetItemNameByID", Item_Native_GetItemNameByID);
			CreateNative("Cmod_GetItemIDByName", Item_Native_GetItemIDByName);
			CreateNative("Cmod_GetItemDesc", Item_Native_GetItemDesc);
			CreateNative("Cmod_GetMinItemValue", Item_Native_GetMinItemValue);
			CreateNative("Cmod_GetMaxItemValue", Item_Native_GetMaxItemValue);
			CreateNative("Cmod_GetClientItemValue", Item_Native_GetClientItemValue);
			CreateNative("Cmod_SetMinItemValue", Item_Native_SetMinItemValue);
			CreateNative("Cmod_SetMaxItemValue", Item_Native_SetMaxItemValue);
			CreateNative("Cmod_SetClientItemValue", Item_Native_SetClientItemValue);
			CreateNative("Cmod_GetItemCount", Item_Native_GetItemCount);
			CreateNative("Cmod_SetClientItem", Item_Native_SetClientItem);
		#endif
	#endif

	// Let plugin load successfully.
	return APLRes_Success;
}

public OnPluginStart()
{
	ModuleMgr_OnPluginStart();

	#if defined EVENT_MANAGER
		EventMgr_OnPluginStart();
	#endif

	#if defined CONFIG_MANAGER
		ConfigMgr_OnPluginStart();
	#endif

	#if defined TRANSLATIONS_MANAGER
		TransMgr_OnPluginStart();
	#else
		Project_LoadExtraTranslations(false);
	#endif

	#if defined LOG_MANAGER
		LogMgr_OnPluginStart();
	#endif

	#if defined ACCESS_MANAGER
		AccessMgr_OnPluginStart();
	#endif

	#if defined VERSION_INFO
		VersionInfo_OnPluginStart();
	#endif

	ForwardOnPluginStart();

	#if defined SQL_SYS
		SQLSys_OnPluginStart();
	#endif

	#if defined STATS_SYS
		StatsSys_OnPluginStart();

		#if defined STATS_MENU
			Stats_Menu_OnPluginStart();
		#endif

		#if defined STATS_RESET
			Stats_Reset_OnPluginStart();
		#endif

	#endif

	#if defined XP_SYS
		XpSys_OnPluginStart();
	#endif

	#if defined CLASS_SYS

		ClassSys_OnPluginStart();

		#if defined CLASS_WEAPONS
			Class_Weapons_OnPluginStart();
		#endif

		#if defined CLASS_SORT
			Class_Sort_OnPluginStart();
		#endif

		#if defined CLASS_MENU
			Class_Menu_OnPluginStart();
		#endif

		#if defined CLASS_DESC
			Class_Desc_OnPluginStart();
		#endif

		#if defined CLASS_SKILL
			Class_Skill_OnPluginStart();
		#endif

	#endif

	#if defined ITEM_SYS

		ItemSys_OnPluginStart();

		#if defined ITEM_PLAYERKILL
			Item_PlayerKill_OnPluginStart();
		#endif

		#if defined ITEM_DURABILITY
			Item_Durability_OnPluginStart();
		#endif

		#if defined ITEM_DESC
			Item_Desc_OnPluginStart();
		#endif

		#if defined ITEM_DROP
			Item_Drop_OnPluginStart();
		#endif

		#if defined ITEM_ACTIVE
			Item_Active_OnPluginStart();
		#endif

	#endif



	#if defined UI_SYS
		UISys_OnPluginStart();
	#endif

	//sklep
	Shop_OnPluginStart();
	//pliki pomocy
	Help_OnPluginStart();
	//wymiana perku
	Wymien_OnPluginStart();

	// All modules should be registered by this point!


	#if defined EVENT_MANAGER
		EventMgr_Forward(g_EvOnEventsRegister, g_CommonEventData1, 0, 0, g_CommonDataType1);
		EventMgr_Forward(g_EvOnEventsReady, g_CommonEventData1, 0, 0, g_CommonDataType1);
		EventMgr_Forward(g_EvOnAllModulesLoaded, g_CommonEventData1, 0, 0, g_CommonDataType1);
	#endif
}

public OnPluginEnd()
{

	#if defined EVENT_MANAGER
		EventMgr_Forward(g_EvOnPluginEnd, g_CommonEventData1, 0, 0, g_CommonDataType1);
	#endif

	#if defined VERSION_INFO
		VersionInfo_OnPluginEnd();
	#endif

	#if defined ACCESS_MANAGER
		AccessMgr_OnPluginEnd();
	#endif

	#if defined LOG_MANAGER
		LogMgr_OnPluginEnd();
	#endif

	#if defined TRANSLATIONS_MANAGER
		TransMgr_OnPluginEnd();
	#endif

	#if defined CONFIG_MANAGER
		ConfigMgr_OnPluginEnd();
	#endif

	#if defined EVENT_MANAGER
		EventMgr_OnPluginEnd();
	#endif

	ModuleMgr_OnPluginEnd();
}
