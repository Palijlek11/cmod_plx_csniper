/*
 * ============================================================================
 *
 *  SourceMod Project Base
 *
 *  File:          sql.inc
 *  Type:          Module
 *  Description:   Basic save system
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

#define SQL_SYS

stock Module:g_moduleSQLSys;

new Handle:task_zapisz_exp[MAXPLAYERS+1] = INVALID_HANDLE;
new String:g_sSqlCreate[] = "CREATE TABLE IF NOT EXISTS `codmod` (`id` INT(11) NOT NULL AUTO_INCREMENT, `steamid` VARCHAR(48) NOT NULL,  `class` VARCHAR(48) NOT NULL,  `lvl` INT(11) DEFAULT 1,  `exp` INT(14), `sInt` INT(9), `sCon` INT(9), `sStr` INT(9), `sDex` INT(9), PRIMARY KEY (`id`), UNIQUE KEY `class_sid` (`class`,`steamid`)) ENGINE=MyISAM  DEFAULT CHARSET=utf8 COLLATE=utf8_polish_ci;";
	
new Handle:g_expDb; //przechowuje dane do bazy z pliku database.cfg
new String:g_sSQLTable[100]; //przechowuje nazwe tabeli w bazie danych (regulowane cvarem g_cvarSQLTable)
new Handle:g_cvarSQLTable; // uchwyt przechwouje cvar "codmod_sql_table"

new loadLevel[MAXPLAYERS+1] = 0;

public SQLSys_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = true;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod:core] Save data system");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "SQLSys");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Basic save system");
	moduledata[ModuleData_Dependencies][0] = INVALID_MODULE;
	
	g_moduleSQLSys = ModuleMgr_Register(moduledata);
	
	EventMgr_RegisterEvent(g_moduleSQLSys, "Event_OnEventsRegister", "SQLSys_OnEventsRegister");
	g_cvarSQLTable = CreateConVar("codmod_sql_table","codmod","The name of the table that will be used. (Max: 100)");
	
	//sniper zmiana zapisu
//	GetConVarString(g_cvarSQLTable,g_sSQLTable,sizeof(g_sSQLTable));
	DB_Connect(true);
	
}

public DB_Connect(bool:firstload)
{
	if(firstload){ // NEEDS TO CONNECT IF NEVER CONNECTED
		GetConVarString(g_cvarSQLTable,g_sSQLTable,sizeof(g_sSQLTable));
		decl String:sError[256];
		g_expDb = SQL_Connect("codmod", false, sError, sizeof(sError));
		if(g_expDb == INVALID_HANDLE)
		{
			SetFailState("[Cod Mod] Unable to connect to the database (%s)",sError);
		}
		SQL_LockDatabase(g_expDb);
		new String:sQuery[1200];
		//towrzenie bazy o ile nie istnieje
		Format(sQuery,sizeof(sQuery),g_sSqlCreate,g_sSQLTable);
		SQL_FastQuery(g_expDb,sQuery);
		
		SQL_UnlockDatabase(g_expDb);
	}
}

public QueryCreateTable( Handle:owner, Handle:hndl, const String:error[], any:data)
{ 
	if ( hndl == INVALID_HANDLE )
	{
		LogError( " MySQL_Init: %s", error ); 
		
		return;
	} 
	
	return;
}

public SQLSys_OnEventsRegister(){
	#if defined EVENT_MANAGER	
		EventMgr_RegisterEvent(g_moduleSQLSys, "Event_OnClientPutInServer", "SQLSys_OnClientPutInServer");
		EventMgr_RegisterEvent(g_moduleSQLSys, "Event_OnClientDisconnect", "SQLSys_OnClientDisconnect");
//		EventMgr_RegisterEvent(g_moduleSQLSys, "Event_OnMapEnd", "SQLSys_OnMapEnd");
	#endif
}

/*public SQLSys_OnMapEnd(){
	for(new client = 1; client <= MaxClients; client++){
		if(task_zapisz_exp[client] != INVALID_HANDLE)
			KillTimer(task_zapisz_exp[client]);
		task_zapisz_exp[client] = INVALID_HANDLE;
	}
}*/

public SQLSys_OnClientPutInServer(client){
	g_iCmodPlayerClass[client] = 0;
	for(new i=0; i < MAX_CLASS_NUMBER; i++)
		g_player_class_lvl[client][i] = 1;
	loadLevel[client] = 0;
	LoadPlayerClassesLevel(client);
	SQLSys_Load(client, 0);
}

public SQLSys_OnClientDisconnect(client){
	SQLSys_Save(client);
	loadLevel[client] = 0;
}

public SQLSys_Save(id)
{
	if(IsFakeClient(id))
		return -2;
	new String:_tmp[1025];
	decl String:_authid[64];
	if(!GetClientAuthId(id, AuthId_Steam2, _authid, 63))
		return -1;
	
	Format(_tmp, sizeof(_tmp), "INSERT INTO `%s` (`steamid`, `class`, `lvl`, `exp`, `sInt`, `sCon`, `sStr`, `sDex`) VALUES ('%s', '%s', %d, %d, %d, %d, %d, %d) ON DUPLICATE KEY UPDATE `lvl`=VALUES(`lvl`), `exp`=VALUES(`exp`), `sInt`=VALUES(`sInt`), `sCon`=VALUES(`sCon`), `sStr`=VALUES(`sStr`), `sDex`=VALUES(`sDex`);", g_sSQLTable, _authid, g_sCmodClassName[g_iCmodPlayerClass[id]], g_iCmodLvl[id], g_iCmodExp[id], g_iCmodPlayerINT[id], g_iCmodPlayerCON[id], g_iCmodPlayerSTR[id], g_iCmodPlayerDEX[id]);
	
	SQL_TQuery( g_expDb, SQLSys_Save_Handle, _tmp, id);
	return 0;
}

public SQLSys_Save_Handle( Handle:owner, Handle:hndl, const String:error[], any:data)
{ 
	if ( hndl == INVALID_HANDLE )
	{
		LogError( "SQLSys_Save_Handle: %s", error ); 
		
		return;
	}
} 

public SQLSys_Load(id, classN)
{
	new String:_tmp[513];
	decl String:_authid[64];
	if(!GetClientAuthId(id, AuthId_Steam2, _authid, 63))
		return -1;
		
	Format(_tmp, sizeof(_tmp), "SELECT `lvl`, `exp`, `sInt`, `sCon`, `sStr`, `sDex` FROM `%s` WHERE steamID = '%s' AND class = '%s';", g_sSQLTable, _authid, g_sCmodClassName[classN]);
	
	SQL_TQuery( g_expDb, SQLSys_Load_Handle, _tmp, id);
	
	return 1;
}

public SQLSys_Load_Handle( Handle:owner, Handle:hndl, const String:error[], any:data)
{ 
	if ( hndl != INVALID_HANDLE )
	{
		if(SQL_GetRowCount(hndl))
		{
			while ( SQL_FetchRow(hndl) ) 
			{
				g_iCmodLvl[data] = SQL_FetchInt(hndl, 0);
				g_iCmodExp[data] = SQL_FetchInt(hndl, 1);
				g_iCmodPlayerINT[data] = SQL_FetchInt(hndl, 2);
				g_iCmodPlayerCON[data] = SQL_FetchInt(hndl, 3);
				g_iCmodPlayerSTR[data] = SQL_FetchInt(hndl, 4);
				g_iCmodPlayerDEX[data] = SQL_FetchInt(hndl, 5);
				g_iCmodPlayerPoint[data] = (g_iCmodLvl[data]-1)*2-g_iCmodPlayerINT[data]-g_iCmodPlayerCON[data]-g_iCmodPlayerSTR[data]-g_iCmodPlayerDEX[data];
			}
		}
		else
		{
			g_iCmodLvl[data] = 1;
			g_iCmodExp[data] = 0;
			g_iCmodPlayerPoint[data] = 0;
			g_iCmodPlayerINT[data] = 0;
			g_iCmodPlayerCON[data] = 0;
			g_iCmodPlayerSTR[data] = 0;
			g_iCmodPlayerDEX[data] = 0;
		}
			
		task_zapisz_exp[data] = CreateTimer(30.0, TaskZapiszExp, data, TIMER_FLAG_NO_MAPCHANGE);
	} 
	else
	{
		LogError( "%s", error ); 
		
		return;
	}
}

public Action:TaskZapiszExp(Handle:timer, any:data)
{
	if(IsClientInGame(data))
	{
		SQLSys_Save(data);
		task_zapisz_exp[data] = CreateTimer(30.0, TaskZapiszExp, data, TIMER_FLAG_NO_MAPCHANGE);
	}
}

public SQLSys_LoadLvl(id, classN)
{
	new String:_tmp[513];
	decl String:_authid[64];
	if(!GetClientAuthId(id, AuthId_Steam2, _authid, 63))
		return -1;
	Format(_tmp, sizeof(_tmp), "SELECT `lvl` FROM `%s` WHERE `steamID` = '%s' AND `class` = '%s';", g_sSQLTable, _authid, g_sCmodClassName[classN]);
	new Handle:_query = SQL_Query(g_expDb, _tmp);
	
	if(_query == INVALID_HANDLE){
		SQL_GetError(g_expDb, g_sCmodSQLError, sizeof(g_sCmodSQLError));
		PrintToServer("Failed to query readLvlClassFromDB (error: %s)", g_sCmodSQLError);
		return -2;
	}
	
	if(SQL_GetRowCount(_query)){
		SQL_FetchRow(_query);
		new _r = SQL_FetchInt(_query, 0);
		CloseHandle(_query);
		return _r;
	}else{
		CloseHandle(_query);
		return 1;
	}
}

//sniper
public LoadPlayerClassesLevel(client) {
	if(loadLevel[client] == 0)
	{
		new String:_tmp[513];
		decl String:_authid[64];
		if(!GetClientAuthId(client, AuthId_Steam2, _authid, 63))
			return -1;
			
		Format(_tmp, sizeof(_tmp), "SELECT `lvl`, `class` FROM `%s` WHERE steamID = '%s';", g_sSQLTable, _authid);
		
		SQL_TQuery( g_expDb, LoadPlayerClassesLevel_Handle, _tmp, client);
		loadLevel[client] = 1;
		
		return 1;
	}
	
	return 0;
}

public LoadPlayerClassesLevel_Handle( Handle:owner, Handle:hndl, const String:error[], any:data)
{ 
	if ( hndl != INVALID_HANDLE )
	{
		if(SQL_GetRowCount(hndl))
		{
			new String:nazwa_klasy[MAX_NAME_LONG+1];
			new level = 1;
			while ( SQL_MoreRows(hndl) ) 
			{
				while(SQL_FetchRow(hndl))
				{
					level = SQL_FetchInt(hndl, 0);
					SQL_FetchString(hndl, 1, nazwa_klasy, MAX_NAME_LONG);
					
					for(new i=0; i<MAX_CLASS_NUMBER; i++)
					{
						if(StrEqual(g_sCmodClassName[i], nazwa_klasy))
						{
							g_player_class_lvl[data][i] = level;
						}
					}
				}
			}
		}
		loadLevel[data] = 2;
	} 
	else
	{
		LogError( "%s", error ); 
		loadLevel[data] = 0;
		return;
	}
}