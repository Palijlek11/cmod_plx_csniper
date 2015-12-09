#define SHOP;

stock Module:g_moduleShop;

new OffsetPlayerMoney = -1;

public Shop_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Shop");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Shop");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Shop for players");
	moduledata[ModuleData_Dependencies][0] = INVALID_MODULE;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	g_moduleShop = ModuleMgr_Register(moduledata);
	
	OffsetPlayerMoney = FindSendPropOffs("CCSPlayer", "m_iAccount");
	
	RegConsoleCmd("sm_shop", MenuSklepu);
	RegConsoleCmd("sm_sklep", MenuSklepu);
	RegConsoleCmd("sm_s", MenuSklepu);
}
/////////////////////////////////////////////////////////////////////////
///////////////////////       komendy      //////////////////////////////
/////////////////////////////////////////////////////////////////////////
public Action:MenuSklepu(client, args){
	if(GameRules_GetProp("m_bWarmupPeriod") == 1)
	{
		PrintToChat(client, "\x01\x0B\x01\x02 Nie mozesz korzystac ze sklepu w czasie rozgrzewki!");
		return;
	}
	new Handle:menu = CreateMenu(MenuSklepu_Handle);
	SetMenuTitle(menu, "Sklep CodMod");
	
	AddMenuItem(menu, "0", "Losowe Doswiadczenie [KOSZT 12000$]");
	AddMenuItem(menu, "0", "Losowy Perk [KOSZT 5000$]");
//	AddMenuItem(menu, "0", "Kup Perk");
	AddMenuItem(menu, "0", "Napraw Perk (+60 wytrzymalosci)[KOSZT 10000$]");
	AddMenuItem(menu, "0", "Adrenalna (+50 HP) [KOSZT 3000$]");
	AddMenuItem(menu, "0", "Apteczka (+100 HP) [KOSZT 5000$]");
	
	SetMenuExitButton(menu, true);
	DisplayMenu(menu, client, 25);
	
	return;
}

public MenuSklepu_Handle(Handle:menu, MenuAction:action, client, item)
{
	if( action == MenuAction_Select )
	{
		switch(item)
		{
			case 0:
			{
				if(BuyForMoney(client, 12000))
				{
					new XP = GetRandomInt(10,35);
					
					if(!XpSys_GiveExp(client, XP, 0))
						SetEntData(client, OffsetPlayerMoney, GetEntData(client, OffsetPlayerMoney) + 12000);
				}
			}
			case 1:
			{
				if(!g_iCmodPlayerItem[client])
				{
					if(BuyForMoney(client, 5000))
					{
						new itemid = GetRandomInt(1, g_iCmodItemCount);
						Item_Set(client, itemid);
						PrintToChat(client, "\x01\x0B\x07[Sklep]\x06 Wylosowales\x07 %s", g_sCmodItemName[g_iCmodPlayerItem[client]]);
					}
				}
				else
					PrintToChat(client, "\x01\x0B\x07[Sklep]\x06 Posiadasz juz przedmiot");
			}
//			case 2:
//				Buy_Perk(client);
			case 2:
			{
				if(g_iCmodPlayerItem[client])
				{
					if(BuyForMoney(client, 10000))
					{
						if(g_iCmodPlayerItemDur[client] + 60 > g_iCmodItemDurability[g_iCmodPlayerItem[client]])
							g_iCmodPlayerItemDur[client] = g_iCmodItemDurability[g_iCmodPlayerItem[client]];
						else g_iCmodPlayerItemDur[client] += 60;
						PrintToChat(client, "\x01\x0B\x07[Sklep]\x06 Naprawiles\x07 %s", g_sCmodItemName[g_iCmodPlayerItem[client]]);
					}
				}
				else
					PrintToChat(client, "\x01\x0B\x07[Sklep]\x06 Nie posiadasz zadnego przedmiotu do naprawienia");
			}
			case 3:
			{
				if(IsPlayerAlive(client))
				{
					if(BuyForMoney(client, 3000))
					{
						new hp = GetClientHealth(client) + 50;
						new maxHp = 100 + g_iCmodPlayerCON[client]  + g_iCmodClassCON[g_iCmodPlayerClass[client]] + g_iCmodBonusCON[client];
						if(hp > maxHp)
							SetEntData(client, FindDataMapOffs(client, "m_iHealth"), maxHp, 4, true);
						else
							SetEntData(client, FindDataMapOffs(client, "m_iHealth"), hp, 4, true);
							
						PrintToChat(client, "\x01\x0B\x07[Sklep]\x06 Kupiles\x07 Adrenaline");
					}
				}
			}
			case 4:
			{
				if(IsPlayerAlive(client))
				{
					if(BuyForMoney(client, 5000))
					{
						new hp = GetClientHealth(client) + 100;
						new maxHp = 100 + g_iCmodPlayerCON[client]  + g_iCmodClassCON[g_iCmodPlayerClass[client]] + g_iCmodBonusCON[client];
						if(hp > maxHp)
							SetEntData(client, FindDataMapOffs(client, "m_iHealth"), maxHp, 4, true);
						else
							SetEntData(client, FindDataMapOffs(client, "m_iHealth"), hp, 4, true);
							
						PrintToChat(client, "\x01\x0B\x07[Sklep]\x06 Kupiles\x07 Apteczke");
					}
				}
			}
		}
	} 
	else if (action == MenuAction_End)	
	{
		CloseHandle(menu);
	}
}

public bool:BuyForMoney(client, amount)
{
	new PlayerMoney;
	if (OffsetPlayerMoney != -1)
	{
		PlayerMoney = GetEntData(client, OffsetPlayerMoney);
	}
	else
	{
		PrintToChat(client, "\x01\x0B\x01 \x07[Sklep]\x06 Bledny offset. Zglos bug administracji");
		return false;
	}
	
	if (PlayerMoney >= amount)
	{
		new roznica = PlayerMoney - amount;
		SetEntData(client, OffsetPlayerMoney, roznica);
		return true;
	}
	else
	{
		PrintToChat(client, "\x01\x0B\x01 \x07[Sklep]\x06 Nie masz dosc $$ aby to kupic");
		return false;
	}
}

/*public Buy_Perk(client)
{
	if(!g_iCmodItemCount){
		PrintToChat(client, "\x01\x0B\x01 \x07%s \x06Nie znaleziono żadnego perku!", MOD_TAG);
	}
	new Handle:_hMenu = CreateMenu(Shop_HandlerBuyPerk) ;

	SetMenuTitle(_hMenu, "Kup Perk:");
	
	for(new i = 1; i <= g_iCmodItemCount; i++){
		if(g_hCmodItemCostInShop[i] > 0)
		{
			new String:opis[51];
			new String:number[5];
			IntToString(i, number, 4);
			Format(opis, 50, "%s [%i$]", g_sCmodItemName[i], g_hCmodItemCostInShop[i]);
			AddMenuItem(_hMenu, number, opis);
		}
	}
	
	DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
}

public Shop_HandlerBuyPerk(Handle:menu, MenuAction:action, param1, param2)
{
	if (action == MenuAction_Select){
		new String:buffer[32];
		new String:dispBuf[32];
		GetMenuItem(menu, param2, buffer, 31, _, dispBuf, 31);
		new number = StringToInt(buffer);
		PrintToChat(param1, "Number: %i, cos tam %s", number, buffer);
		Item_Desc_ShowItemDesc(param1, param2);
	}else if(action == MenuAction_End){
		CloseHandle(menu);
	}
}*/