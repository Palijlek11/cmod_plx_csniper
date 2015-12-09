#include <sourcemod>
#include <sdkhooks>

public Plugin:myinfo = {
	name = "Cmod Skill: Odnowienie Magazynku",
	author = "CSnajper",
	description = "Skill dla Cmod by PLX",
	version = "0.1",
	url = "http://CSnajper.eu/"
};

#define IsValidClient(%1)  ( 1 <= %1 <= MaxClients && IsClientInGame(%1) )

new refillKlasa[MAXPLAYERS+1] = false;
new refillItem[MAXPLAYERS+1] = false;
new bool:UnlimitedClipKlasa[MAXPLAYERS+1] = false;
new bool:UnlimitedClipItem[MAXPLAYERS+1] = false;

enum weapontype
{
	init,
	drop,
	pickup,
	replen
};

enum ammotype // trie array values
{
	defaultclip, // original clip size
	clipsize,    // desired clip size
	ammosize,    // reserved ammo
	array_size   // size of trie array
};

new	Handle:WeaponsTrie, // Trie array to save weapon names, its clips and reserved ammo
	EngineVersion:CurrentVersion, // Array to store original ammo convar values
	bool:saveclips, // Global booleans to use instead of global handles
	bool:reserveammo,
	bool:replenish = true, bool:restock = true,
	m_iAmmo, m_hMyWeapons, m_hActiveWeapon, // Datamap offsets to setup ammunition for player
	m_iClip1, m_iClip2, // Offsets to setup ammunition for weapons only
	m_iPrimaryAmmoType, m_iSecondaryAmmoType,
	prefixlength, MAX_WEAPONS; // Max. bound for ammo convars and m_hMyWeapons array datamap
	
	
public OnPluginStart(){
	m_iAmmo              = FindSendPropOffsEx("CBasePlayer",       "m_iAmmo");
	m_hMyWeapons         = FindSendPropOffsEx("CBasePlayer",       "m_hMyWeapons");
	m_hActiveWeapon      = FindSendPropOffsEx("CBasePlayer",       "m_hActiveWeapon");
	m_iClip1             = FindSendPropOffsEx("CBaseCombatWeapon", "m_iClip1");
	m_iClip2             = FindSendPropOffsEx("CBaseCombatWeapon", "m_iClip2");
	m_iPrimaryAmmoType   = FindSendPropOffsEx("CBaseCombatWeapon", "m_iPrimaryAmmoType");
	m_iSecondaryAmmoType = FindSendPropOffsEx("CBaseCombatWeapon", "m_iSecondaryAmmoType");
	
	prefixlength  = 7;
	MAX_WEAPONS   = 48;
	
	HookEvent("player_death", Event_PlayerDeath);
	HookEvent("weapon_fire", Event_WeaponFire);
	
	// Create most important thing - a trie structure
	WeaponsTrie = CreateTrie();
	AutoExecConfig();
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("OdnowienieMagazynka", native_OdnowienieMagazynka);
	CreateNative("UnlimitedClip", native_UnlimitedClip);
	
	return APLRes_Success;
}

public OnClientConnected(client)
{
	refillKlasa[client] = false;
	refillItem[client] = false;
	UnlimitedClipKlasa[client] = false;
	UnlimitedClipItem[client] = false;
}

public native_OdnowienieMagazynka(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new klasa = GetNativeCell(2);
	new item = GetNativeCell(3);
	
	if(klasa == -1 || item == -1)
	{
		if(klasa == -1)
		{
			refillKlasa[client] = false;
		}
		if(item == -1)
		{
			refillItem[client] = false;
		}
		return;
	}
	
	if(klasa)
		refillKlasa[client] = true;
	if(item)
		refillItem[client] = true;
}

public native_UnlimitedClip(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new Klasa = GetNativeCell(2);
	new Item = GetNativeCell(3);
	
	if(Klasa == -1 || Item == -1)
	{
		if(Klasa == -1)
		{
			UnlimitedClipKlasa[client] = false;
		}
		if(Item == -1)
		{
			UnlimitedClipItem[client] = false;
		}
		return;
	}
	
	if(Klasa)
		UnlimitedClipKlasa[client] = true;
	if(Item)
		UnlimitedClipItem[client] = true;
}

public OnMapStart()
{
	// Get the config and set weapons trie values eventually
	decl String:filepath[PLATFORM_MAX_PATH], Handle:file, clipnammo[array_size];
	BuildPath(Path_SM, filepath, sizeof(filepath), "configs/ammo_manager.txt");

	// Check whether or not plugin config is exists
	if ((file = OpenFile(filepath, "r")) != INVALID_HANDLE)
	{
		ClearTrie(WeaponsTrie);

		decl String:fileline[PLATFORM_MAX_PATH];
		decl String:datas[4][PLATFORM_MAX_PATH];

		// Read every line in config
		while (ReadFileLine(file, fileline, sizeof(fileline)))
		{
			// Break ; symbols from config (a javalia's method)
			if (ExplodeString(fileline, ";", datas, sizeof(datas), sizeof(datas[])) == 4)
			{
				// Properly setup default clip size and other ammo values
				clipnammo[defaultclip] = StringToInt(datas[1]);
				clipnammo[clipsize]    = StringToInt(datas[2]);
				clipnammo[ammosize]    = StringToInt(datas[3]);
				SetTrieArray(WeaponsTrie, datas[0], clipnammo, array_size);
			}
		}
	}
	else
	{
		// No config, wtf? Restore ammo settings and properly disable plugin
		SetFailState("Unable to load plugin configuration file \"%s\"!", filepath);
	}
}

public Action:Event_PlayerDeath(Handle:event, const String:name[], bool:dontBroadcast)
{
	new attackerID = GetEventInt(event, "attacker");
	new victim = GetClientOfUserId(GetEventInt(event, "userid") );
	new attacker = GetClientOfUserId( attackerID );
	
	if(IsValidClient(attacker) && attacker != victim)
	{
		if((refillKlasa[attacker] || refillItem[attacker]) && IsPlayerAlive(attacker))
		{
			CreateTimer(0.1, Timer_PostEquip, attackerID|(_:replen << 16), TIMER_FLAG_NO_MAPCHANGE);
		}
	}
	
	return Plugin_Continue
}

public Action:Timer_PostEquip(Handle:timer, any:data)
{
	new client = data & 0x0000FFFF;
	new type   = data >> 16;

	// Always validate client from delayed callbacks (timers etc...)
	if ((client = GetClientOfUserId(client)))
	{
		// Get the type of post equip ammunition
		switch (type)
		{
			case replen: // Replen weapon ammo after a kill
			{
				// Get the active player weapon and set its ammo appropriately
				new weapon = GetEntDataEnt2(client, m_hActiveWeapon);
				if (replenish) 
				{
					SetWeaponClip(weapon, weapontype:replen);
				}
				if (restock)
				{
					SetWeaponReservedAmmo(client, weapon, weapontype:replen);
				}
			}
			default: SetSpawnAmmunition(client, false); // Either OnPlayerSpawn or CS_OnBuyCommand has been fired
		}
	}
}

FindSendPropOffsEx(const String:serverClass[64], const String:propName[64])
{
	new offset = FindSendPropOffs(serverClass, propName);

	// Disable plugin if a networkable send property offset was not found
	if (offset <= 0)
	{
		SetFailState("Unable to find offset \"%s::%s\"!", serverClass, propName);
	}

	return offset;
}

SetWeaponClip(weapon, type)
{
	// Make sure weapon edict is valid
	if (weapon > MaxClients)
	{
		// Retrieve weapon classname
		decl String:classname[64], clipnammo[array_size];
		if (GetEdictClassname(weapon, classname, sizeof(classname)) && CurrentVersion == Engine_CSGO)
		{
			// Get the weapon definition index (like in hat fortress)
			switch (GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex"))
			{
				case 60: classname = "weapon_m4a1_silencer";
				case 61: classname = "weapon_usp_silencer";
				case 63: classname = "weapon_cz75a";
			}
		}

		// Ignore first 7/10 characters in weapon string to avoid comparing with the prefix
		if (GetTrieArray(WeaponsTrie, classname[prefixlength], clipnammo, array_size))
		{
			if (clipnammo[clipsize])
			{
				switch (type)
				{
					case init:   SetEntData(weapon, m_iClip2, clipnammo[clipsize]); // When weapon just spawned, set m_iClip2 value to clip size from trie array
					case drop:   SetEntData(weapon, m_iClip2, GetEntData(weapon, m_iClip1)); // After dropping a weapon, set m_iClip2 value same as current (m_iClip1) size
					case pickup: SetEntData(weapon, m_iClip1, GetEntData(weapon, m_iClip2)); // And when weapon is picked, retrieve m_iClip2 value and set current clip size
					case replen: SetEntData(weapon, m_iClip1, clipnammo[clipsize]); // When player kills another, get the clip value from trie and set it for weapon immediately
				}
			}
		}
	}
}

SetWeaponReservedAmmo(client, weapon, type)
{
	if (weapon > MaxClients)
	{
		decl String:classname[64], clipnammo[array_size];

		// Replace whole weapon string for CS:GO after checking definition index
		if (GetEdictClassname(weapon, classname, sizeof(classname)) && CurrentVersion == Engine_CSGO)
		{
			switch (GetEntProp(weapon, Prop_Send, "m_iItemDefinitionIndex"))
			{
				case 60: classname = "weapon_m4a1_silencer";
				case 61: classname = "weapon_usp_silencer";
				case 63: classname = "weapon_cz75a";
			}
		}

		if (GetTrieArray(WeaponsTrie, classname[prefixlength], clipnammo, array_size))
		{
			// Get the weapon ID to properly find it in m_iAmmo array
			new WeaponID = GetEntData(weapon, m_iPrimaryAmmoType) * 4;

			// If ammo value is not set (= 0) dont do anything
			if (clipnammo[ammosize])
			{
				// Retrieve ammunition type when weapon is created, dropped or picked
				switch (type)
				{
					case init:   SetEntData(weapon, m_iSecondaryAmmoType, clipnammo[ammosize]); // Initialize reserved ammunition in unused m_iSecondaryAmmoType datamap offset
					case drop:   if (IsClientInGame(client)) SetEntData(weapon, m_iSecondaryAmmoType, GetEntData(client, m_iAmmo + WeaponID));
					case pickup: if (IsClientInGame(client)) SetEntData(client, m_iAmmo + WeaponID, GetEntData(weapon, m_iSecondaryAmmoType)); // Retrieve it
					case replen: if (IsClientInGame(client)) SetEntData(client, m_iAmmo + WeaponID, clipnammo[ammosize]); // Get desired max ammo value from trie and just set reserved ammo for this weapon
				}
			}
		}
	}
}

SetSpawnAmmunition(client, bool:prehook)
{
	// Loop through max game weapons to properly get all player weapons
	for (new i; i < MAX_WEAPONS; i += 4) // increase every offset by 4 units
	{
		new weapon  = -1;
		if ((weapon = GetEntDataEnt2(client, m_hMyWeapons + i)) != -1)
		{
			// On pre-spawn hook set m_iSecondaryAmmoType as default value
			if (saveclips)   SetWeaponClip(weapon, prehook ? init : pickup); // Otherwise set current ammo from this value
			if (reserveammo) SetWeaponReservedAmmo(client, weapon, prehook ? init : pickup);
		}
	}
}

//nieskonczone ammo
public Event_WeaponFire(Handle:event, const String:name[], bool:dontBroadcast)
{
	new clientiID = GetEventInt(event, "userid");
	new client = GetClientOfUserId( clientiID );
	if((UnlimitedClipKlasa[client] || UnlimitedClipItem[client]) && IsPlayerAlive(client))
	{
		CreateTimer(0.1, Timer_PostEquip, clientiID|(_:replen << 16), TIMER_FLAG_NO_MAPCHANGE);
	}
}