#define WYMIEN;

stock Module:g_moduleReplaceItem;

new wybrany_gracz[MAXPLAYERS+1] = 0;
new IDGraczy[MAXPLAYERS+1][MAXPLAYERS+1];
new bool:wymienia[MAXPLAYERS+1] = false;

public Wymien_OnPluginStart(){
	new moduledata[ModuleData];

	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Wymien");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Wymien");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Wymiana perkow!");
	moduledata[ModuleData_Dependencies][0] = INVALID_MODULE;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;

	g_moduleReplaceItem = ModuleMgr_Register(moduledata);

	RegConsoleCmd("sm_wymien", MenuReplaceItem);
	RegConsoleCmd("sm_zamien", MenuReplaceItem);
}
/////////////////////////////////////////////////////////////////////////
///////////////////////       XXX      //////////////////////////////////
/////////////////////////////////////////////////////////////////////////
public Action:MenuReplaceItem(client, args){
	if(!g_iCmodPlayerItem[client])
	{
		PrintToChat(client, "Nie posiadasz itemu do wymiany!");
	}
	else if(wymienia[client])
	{
		PrintToChat(client, "Wymiana trwa, poczekaj az sie skonczy!");
	}
	else
		CreateTimer( 0.1, WymienMenu, client, TIMER_FLAG_NO_MAPCHANGE);
}

public Action:WymienMenu(Handle:timer, any:client){
	new Handle:_hMenu = CreateMenu(WymienMenuHandler);
	SetMenuTitle(_hMenu, "Wybierz gracza z ktorym chcesz wymienic sie itemem");
	new element_menu = 0;
	for(new i = 1; i < MAXPLAYERS; i++)
	{
		if(IsClientInGame(i) && !IsFakeClient(i) /*&& i != client*/)
		{
			new String:name[48];
			GetClientName(i, name, 47);
			new String: info[128];
			Format(info, 127, "%s [%s]", name, g_sCmodItemName[g_iCmodPlayerItem[i]]);
			IDGraczy[client][element_menu] = i;
			AddMenuItem(_hMenu, name, name);
			element_menu++;
		}
	}
	
	DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
}

public WymienMenuHandler(Handle:menu, MenuAction:action, param1, param2){
	if (action == MenuAction_Select){
		
		ZapytajOWymiane(param1, IDGraczy[param1][param2]);
		wymienia[param1] = true;
	}else if (action == MenuAction_End){
		CloseHandle(menu);
	}
}

public ZapytajOWymiane(client, cel)
{
	new Handle:_hMenu = CreateMenu(WymianaMenuHandler);
	decl String:_sName[128];
	new String:name[48];
	GetClientName(client, name, 47);
	Format(_sName, 127, "Gracz %s propouje ci wymiane perku za %s", name, g_sCmodItemName[g_iCmodPlayerItem[client]]);
	SetMenuTitle(_hMenu, _sName);
	wybrany_gracz[cel] = client;
	AddMenuItem(_hMenu, "0", "Wymien sie");
	AddMenuItem(_hMenu, "1", "Odrzuc wymiane");
	
	DisplayMenu(_hMenu, cel, 10);
}

public WymianaMenuHandler(Handle:menu, MenuAction:action, param1, item){
	wymienia[wybrany_gracz[param1]] = false;
	if (action == MenuAction_Select){
		switch(item)
		{
			case 0:
			{
				ReplaceItem(param1, wybrany_gracz[param1]);
			}
			case 1:
			{
				PrintToChat(wybrany_gracz[wybrany_gracz[param1]], "Gracz odrzucil twoja propozycje wymiany");
			}
		}
	}else if (action == MenuAction_End){
		CloseHandle(menu);
	}
}



public ReplaceItem(client, target)
{
  new temp_item_id = g_iCmodPlayerItem[target];
  new temp_item_durability = g_iCmodPlayerItemDur[target];

  g_iCmodPlayerItem[target] = g_iCmodPlayerItem[client];
  g_iCmodPlayerItemDur[target] = g_iCmodPlayerItemDur[client];

  g_iCmodPlayerItem[client] = temp_item_id;
  g_iCmodPlayerItemDur[client] = temp_item_durability;
}
