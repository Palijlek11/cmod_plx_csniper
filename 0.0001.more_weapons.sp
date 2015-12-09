#include <sourcemod>
#include <cstrike>
#include <sdkhooks>
#include <sdktools>
#include <cmod>

#define MAX_WEAPONS_PLAYER 15

#define BRON_DLUGA 1
#define BRON_KROTKA 2
#define NOZ 3
#define GRANATY 4
#define C4 5

new Handle:info_timer = INVALID_HANDLE;

new String:bronieKrotkie[][] = { 
	"weapon_glock", 
	"weapon_p250", 
	"weapon_fiveseven", 
	"weapon_hkp2000", 
	"weapon_deagle", 
	"weapon_elite", 
	"weapon_tec9",
	"weapon_usp_silencer"
}

new String: bronieDlugie[][] =  {
	"weapon_ssg08", 
	"weapon_mp9", 
	"weapon_mp7", 
	"weapon_awp", 
	"weapon_mag7", 
	"weapon_ump45", 
	"weapon_sawedoff", 
	"weapon_p90", 
	"weapon_nova", 
	"weapon_famas",  
	"weapon_xm1014", 
	"weapon_bizon",
	"weapon_galilar", 
	"weapon_m4a1", 
	"weapon_m4a1_silencer", 
	"weapon_ak47", 
	"weapon_aug", 
	"weapon_sg556",
	"weapon_scar20",
	"weapon_m249", 
	"weapon_g3sg1",
	"weapon_negev"
}

new String: noz[] = "weapon_knife";

new String: c4[] = "weapon_c4";

new String: granaty[][] = {
	"weapon_hegrenade",
	"weapon_incgrenade",
	"weapon_smokegrenade",
	"weapon_molotov",
	"weapon_flashbang"
}

new aktualna_bron_dluga[MAXPLAYERS+1] = -1
new aktualna_bron_krotka[MAXPLAYERS+1] = -1
new aktualna_liczba_broni_dlugich[MAXPLAYERS+1] = 0;
new aktualna_liczba_broni_krotkich[MAXPLAYERS+1] = 0;

new String:player_weapons[MAXPLAYERS+1][MAX_WEAPONS_PLAYER][2][31];
new player_ammo[MAXPLAYERS+1][MAX_WEAPONS_PLAYER][2][2];

public Plugin:myinfo =
{
    name = "More Weapons",
    author = "CSnajper",
    description = "More weapons on one slot",
    version = "v1.0",
    url = "http://CSnajper.eu/"
};

public OnPluginStart()
{
	HookEvent("player_spawn", Event_PlayerSpawn, EventHookMode_Pre);
	
	//zmiana broni dlugiej
	RegConsoleCmd("zmien_bron", ChangeWeapon);
	AddCommandListener(Dropss, "drop");
}

public OnMapStart()
{
	if(info_timer != INVALID_HANDLE)
		CloseHandle(info_timer)
	info_timer = CreateTimer(30.0, Info);
}

public Action:Info(Handle:timer)
{
	PrintToChatAll("\x01\x0B\x01\x02 Cod Mod \x01stworzony przez \x04CSnajper'a \x01-\x06 CSnajper.eu");
	info_timer = INVALID_HANDLE;
}

//natywy
public APLRes:AskPluginLoad2(Handle:myself, bool:late, String:error[], err_max)
{
	//natywy
	CreateNative("GiveMoreWeapons", native_GiveMoreWeapons);
	CreateNative("RemoveMoreWeapons", native_RemoveMoreWeapons);
	
	return APLRes_Success;
}

public Action:Dropss(client, const String:command[], argc)
{
	new slot = ZwrocSlot(client);
	if(slot == BRON_DLUGA)
	{
		PrintToChat(client, "Nie mozesz wyrzucic swojej broni glownej");
		return Plugin_Handled;
	}
	return Plugin_Continue;
}

public Action:ChangeWeapon(client, args)
{
	ChangeWeapon2(client, 1);
	
	return Plugin_Continue;
}

public Action:ChangeWeapon2(client, num)
{
/*	if(aktualna_liczba_broni_dlugich[client] == 1 && (GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY) == -1) || aktualna_liczba_broni_dlugich[client] > 1)
	{
		if(num == 1)
			ZapiszAmmo(client);
		
		new weaponIndex = -1
		weaponIndex = GetPlayerWeaponSlot(client, 0);
		if(weaponIndex != -1)
		{
			RemovePlayerItem(client, weaponIndex);
			RemoveEdict(weaponIndex);
		}*/
		new weaponIndex = -1
		new slot = ZwrocSlot(client)
		switch(slot)
		{
			case BRON_DLUGA:
			{
				if(aktualna_liczba_broni_dlugich[client] == 1 && (GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY) == -1) || aktualna_liczba_broni_dlugich[client] > 1)
				{
					if(num == 1)
						ZapiszAmmo(client);
					weaponIndex = -1
					weaponIndex = GetPlayerWeaponSlot(client, 0);
					if(weaponIndex != -1)
					{
						RemovePlayerItem(client, weaponIndex);
						RemoveEdict(weaponIndex);
					}
					if(++aktualna_bron_dluga[client] >= aktualna_liczba_broni_dlugich[client])
						aktualna_bron_dluga[client] = 0;
					
					GivePlayerItem(client, player_weapons[client][aktualna_bron_dluga[client]][0]);
					DajAmmo(client, 0);
				}
			}
			case BRON_KROTKA:
			{
				if(aktualna_liczba_broni_krotkich[client] == 1 && (GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY) == -1) || aktualna_liczba_broni_krotkich[client] > 1)
				{
					if(num == 1)
						ZapiszAmmo(client);
					weaponIndex = -1
					weaponIndex = GetPlayerWeaponSlot(client, 1);
					if(weaponIndex != -1)
					{
						RemovePlayerItem(client, weaponIndex);
						RemoveEdict(weaponIndex);
					}
					if(++aktualna_bron_krotka[client] >= aktualna_liczba_broni_krotkich[client])
						aktualna_bron_krotka[client] = 0;
					GivePlayerItem(client, player_weapons[client][aktualna_bron_krotka[client]][1]);
					DajAmmo(client, 1);
				}
			}
			default:
			{
				if(aktualna_liczba_broni_dlugich[client] == 1 && (GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY) == -1) || aktualna_liczba_broni_dlugich[client] > 1)
				{
					if(num == 1)
						ZapiszAmmo(client);
					weaponIndex = -1
					weaponIndex = GetPlayerWeaponSlot(client, 0);
					if(weaponIndex != -1)
					{
						RemovePlayerItem(client, weaponIndex);
						RemoveEdict(weaponIndex);
					}
					if(++aktualna_bron_dluga[client] >= aktualna_liczba_broni_dlugich[client])
						aktualna_bron_dluga[client] = 0;
					
					GivePlayerItem(client, player_weapons[client][aktualna_bron_dluga[client]][0]);
					DajAmmo(client, 0);
				}
			}
/*			case NOZ:
			{
				GivePlayerItem(client, player_weapons[client][aktualna_bron_dluga[client]][0]);
				DajAmmo(client, 0);
			}
			case GRANATY:
			{
				GivePlayerItem(client, player_weapons[client][aktualna_bron_dluga[client]][0]);
				DajAmmo(client, 0);
			}
			case C4:
			{
				GivePlayerItem(client, player_weapons[client][aktualna_bron_dluga[client]][0]);
				DajAmmo(client, 0);
			}*/
		}
//	}
	if(num == 0)
	{
		weaponIndex = -1
		weaponIndex = GetPlayerWeaponSlot(client, 0);
		if(weaponIndex != -1)
		{
			RemovePlayerItem(client, weaponIndex);
			RemoveEdict(weaponIndex);
		}
	}
	
	return Plugin_Continue;
}

public Action:ZapiszAmmo(client)
{
	new String:weapon[31];
	GetClientWeapon(client, weapon, 30);
	new bool:znalazl = false;
	new i;
	for(i = 0; i < sizeof(bronieKrotkie); i++)
	{
		if(StrEqual(weapon, bronieKrotkie[i]))
		{
			znalazl = true;
			player_ammo[client][aktualna_bron_krotka[client]][1][0] = GetPrimaryAmmo(client)
			player_ammo[client][aktualna_bron_krotka[client]][1][1] = GetReserveAmmo(client)
		}
	}
	if(znalazl)
		return;
	for(i = 0; i < sizeof(bronieDlugie); i++)
	{
		if(StrEqual(weapon, bronieDlugie[i]))
		{
			znalazl = true;
			player_ammo[client][aktualna_bron_dluga[client]][0][0] = GetPrimaryAmmo(client)
			player_ammo[client][aktualna_bron_dluga[client]][0][1] = GetReserveAmmo(client)
		}
	}
	if(znalazl)
		return;
}

public Action:DajAmmo(client, slot)
{
	switch(slot)
	{
		case 0:
		{
			if(player_ammo[client][aktualna_bron_dluga[client]][0][0] != -1)
			{
				SetPrimaryAmmo(client, player_ammo[client][aktualna_bron_dluga[client]][0][0]);
			}
			if(player_ammo[client][aktualna_bron_dluga[client]][0][1] != -1)
			{
				SetReserveAmmo(client, player_ammo[client][aktualna_bron_dluga[client]][0][1]);
			}
		}
		case 1:
		{
			if(player_ammo[client][aktualna_bron_krotka[client]][1][0] != -1)
			{
				SetPrimaryAmmo(client, player_ammo[client][aktualna_bron_krotka[client]][1][0]);
				
			}
			if(player_ammo[client][aktualna_bron_krotka[client]][1][1] != -1)
			{
				SetReserveAmmo(client, player_ammo[client][aktualna_bron_krotka[client]][1][1]);
			}
		}
	}
	return;
}
public Action:Event_PlayerSpawn(Handle:event, const String:name[], bool:dontBroadcast)
{
	new client = GetClientOfUserId(GetEventInt(event, "userid") );
	
	aktualna_bron_dluga[client] = 0;
	aktualna_bron_krotka[client] = 0;
	aktualna_liczba_broni_dlugich[client] = 0;
	aktualna_liczba_broni_krotkich[client] = 0;
	new i;
	for(i = 0; i < MAX_WEAPONS_PLAYER - 1; i++)
	{
		strcopy(player_weapons[client][i][0], 30, "")
		strcopy(player_weapons[client][i][1], 30, "")
		player_ammo[client][i][0][0] = -1
		player_ammo[client][i][0][1] = -1
		player_ammo[client][i][1][0] = -1
		player_ammo[client][i][1][1] = -1
	}
	return Plugin_Continue;
}

public native_GiveMoreWeapons(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new String:bron[31]
	GetNativeString(2, bron, 30);
	new i, bool:ma_bron = false, bool:znalazl = false;
	for(i = 0; i < aktualna_liczba_broni_dlugich[client]; i++)
	{
		if(StrEqual(player_weapons[client][i][0], bron) || StrEqual(bron, "weapon_m4a1") && StrEqual(player_weapons[client][i][0], "weapon_m4a1_silencer"))
		{
			ma_bron = true;
			break;
		}
	}
	if(!ma_bron)
	{
		for(i = 0; i < sizeof(bronieKrotkie); i++)
		{
			if(StrEqual(bron, bronieKrotkie[i]))
			{
				if(aktualna_liczba_broni_krotkich[client] <= MAX_WEAPONS_PLAYER)
				{
					strcopy(player_weapons[client][aktualna_liczba_broni_krotkich[client]][1], 30, bron);
					aktualna_liczba_broni_krotkich[client]++;
				}
				new weaponIndex = GetPlayerWeaponSlot(client, CS_SLOT_SECONDARY);
				if(weaponIndex == -1)
				{
					new Handle:data;
					CreateDataTimer(0.1, DajBron_krotka, data);
					WritePackCell(data, client);
					WritePackString(data, player_weapons[client][aktualna_bron_krotka[client]][1]);
				}
				
				znalazl = true;
				break;
			}
		}
		if(!znalazl)
		{
			for(i = 0; i < sizeof(bronieDlugie); i++)
			{
				if(StrEqual(bron, bronieDlugie[i]))
				{
					if(aktualna_liczba_broni_dlugich[client] >= MAX_WEAPONS_PLAYER)
					{
						LogError("Proba nadania zbyt wielu broni dlugich");
						return;
					}
					
					strcopy(player_weapons[client][aktualna_liczba_broni_dlugich[client]][0], 30, bron);
					aktualna_liczba_broni_dlugich[client]++;
						
					new weaponIndex = GetPlayerWeaponSlot(client, CS_SLOT_PRIMARY);
					if(weaponIndex == -1)
					{
						new Handle:data;
						CreateDataTimer(0.1, DajBron, data);
						WritePackCell(data, client);
						WritePackString(data, player_weapons[client][aktualna_bron_dluga[client]][0]);
					}
					break;
				}
			}
			for(i = 0; i < sizeof(granaty); i++)
			{
				if(StrEqual(bron, granaty[i]))
				{
					GivePlayerItem(client, bron)
					break;
				}
			}
		}
	}
	return;
}

public Action:DajBron_krotka(Handle:timer, Handle:data)
{
	new client;
	new String:bron[32];
	
	ResetPack(data);
	client = ReadPackCell(data);
	ReadPackString(data, bron, 31);
	new weaponIndex = GetPlayerWeaponSlot(client, 1);
	if(weaponIndex == -1)
		GivePlayerItem(client, bron)
		
	return;
}

public Action:DajBron(Handle:timer, Handle:data)
{
	new client;
	new String:bron[32];
	
	ResetPack(data);
	client = ReadPackCell(data);
	ReadPackString(data, bron, 31);
	new weaponIndex = GetPlayerWeaponSlot(client, 0);
	if(weaponIndex == -1)
	{
		GivePlayerItem(client, bron);
	}
		
	return;
}
	

public native_RemoveMoreWeapons(Handle:plugin, numParams)
{
	new client = GetNativeCell(1);
	new String:bron[31]
	GetNativeString(2, bron, 30);
	
	new String:bron_w_reku[31]
//	new weapon = GetPlayerWeaponSlot(client, 0);
	GetClientWeapon(client, bron_w_reku, 30);
	
	new Handle:bronie_klasy = Cmod_GetClassWeapons(Cmod_GetClientClass(client));
	new _tmpCount = GetArraySize(bronie_klasy);
	new String:buffer[32];
	
	new bool:czy_znalazl = false;
	new bool:czy_znalazl2 = false;
	
	for(new i; i < _tmpCount; i++){
		GetArrayString(bronie_klasy, i, buffer, sizeof(buffer));
		if(StrEqual(bron, buffer))
		{
			czy_znalazl = true
			break;
		}
	}
	if(!czy_znalazl)
	{
		for(new i = 0; i < sizeof(bronieDlugie); i++)
		{
			if(StrEqual(bron, bronieDlugie[i]))
			{
				aktualna_liczba_broni_dlugich[client]--;
				if(aktualna_liczba_broni_dlugich[client] < 0)
					LogError("'native_RemoveMoreWeapons' Próba odwołania do ujemnego elementu tablicy w broniach dlugich!");
/*				strcopy(player_weapons[client][aktualna_liczba_broni_dlugich[client]][0], 30, "");
				player_ammo[client][aktualna_liczba_broni_dlugich[client]][0][0] = -1;
				player_ammo[client][aktualna_liczba_broni_dlugich[client]][0][1] = -1;
				player_ammo[client][aktualna_liczba_broni_dlugich[client]][1][0] = -1;
				player_ammo[client][aktualna_liczba_broni_dlugich[client]][1][1] = -1;*/
				new aktualnie = aktualna_liczba_broni_dlugich[client] - 1;
				if(aktualna_bron_dluga[client] > aktualnie)
				{
					aktualna_bron_dluga[client] = 0;
					ChangeWeapon2(client, 0);
					ChangeWeapon2(client, 1);
				}
				czy_znalazl2 = true;
			}
		}
		if(!czy_znalazl2)
		{
			for(new i = 0; i < sizeof(bronieKrotkie); i++)
			{
				if(StrEqual(bron, bronieKrotkie[i]))
				{
					aktualna_liczba_broni_krotkich[client]--;
					if(aktualna_liczba_broni_krotkich[client] < 0)
					LogError("'native_RemoveMoreWeapons' Próba odwołania do ujemnego elementu tablicy w broniach krotkich!");
/*					strcopy(player_weapons[client][aktualna_liczba_broni_krotkich[client]][1], 30, "");
					player_ammo[client][aktualna_liczba_broni_krotkich[client]][0][0] = -1;
					player_ammo[client][aktualna_liczba_broni_krotkich[client]][0][1] = -1;
					player_ammo[client][aktualna_liczba_broni_krotkich[client]][1][0] = -1;
					player_ammo[client][aktualna_liczba_broni_krotkich[client]][1][1] = -1;*/
					new aktualnie = aktualna_liczba_broni_krotkich[client] - 1;
					if(aktualna_bron_krotka[client] > aktualnie)
					{
						aktualna_bron_krotka[client] = 0;
						ChangeWeapon2(client, 0);
						ChangeWeapon2(client, 1);
					}
				}
			}
		}
	}
	
	return;
}

public _IsValidClient(client, bool:nobotss)
{
    new bool:nobots = nobotss;
    if (client <= 0 || client > MaxClients || !IsClientConnected(client) || (nobots && IsFakeClient(client))) 
    {  
        return false;  
    }
    return IsClientInGame(client);  
}

stock GetPrimaryAmmo(client)
{
	new iWeapon = GetEntDataEnt2(client, FindSendPropInfo("CCSPlayer", "m_hActiveWeapon"));
	
	return GetEntData(iWeapon, FindSendPropInfo("CBaseCombatWeapon", "m_iClip1"));
}

stock SetPrimaryAmmo(client,ammo)
{
	new iWeapon = GetEntDataEnt2(client, FindSendPropInfo("CCSPlayer", "m_hActiveWeapon"));
	
	return SetEntData(iWeapon, FindSendPropInfo("CBaseCombatWeapon", "m_iClip1"), ammo);
}

stock GetReserveAmmo(client)
{
    new weapon = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
    if(weapon < 1) return -1;
    
    return GetEntProp(weapon, Prop_Send, "m_iPrimaryReserveAmmoCount");
}

stock SetReserveAmmo(client, ammo)
{
    new weapon = GetEntPropEnt(client, Prop_Data, "m_hActiveWeapon");
    if(weapon < 1) return;
    
    new ammotype = GetEntProp(weapon, Prop_Send, "m_iPrimaryAmmoType");
    if(ammotype == -1) return;
    
    SetEntProp(client, Prop_Send, "m_iAmmo", ammo, _, ammotype);
}

public ZwrocSlot(client)
{
	new String: currentWeapon[31]
	GetClientWeapon(client, currentWeapon, sizeof(currentWeapon))
	
	if(StrEqual(currentWeapon, noz))
	{
		return NOZ;
	}
	if(StrEqual(currentWeapon, c4))
	{
		return C4;
	}
	new i;
	for(i = 0; i < sizeof(bronieKrotkie); i++)
	{
		if(StrEqual(currentWeapon, bronieKrotkie[i]))
		{
			return BRON_KROTKA;
		}
	}
	for(i = 0; i < sizeof(bronieDlugie); i++)
	{
		if(StrEqual(currentWeapon, bronieDlugie[i]))
		{
			return BRON_DLUGA;
		}
	}
	for(i = 0; i < sizeof(granaty); i++)
	{
		if(StrEqual(currentWeapon, granaty[i]))
		{
			return GRANATY;
		}
	}
	return 0
}