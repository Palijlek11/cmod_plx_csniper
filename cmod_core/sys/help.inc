#define HELP;

stock Module:g_moduleHelp;

public Help_OnPluginStart(){
	new moduledata[ModuleData];
	
	moduledata[ModuleData_Disabled] = false;
	moduledata[ModuleData_Hidden] = false;
	strcopy(moduledata[ModuleData_FullName], MM_DATA_FULLNAME, "[Cmod] Help files");
	strcopy(moduledata[ModuleData_ShortName], MM_DATA_SHORTNAME, "Help");
	strcopy(moduledata[ModuleData_Description], MM_DATA_DESCRIPTION, "Menu and commands of help");
	moduledata[ModuleData_Dependencies][0] = INVALID_MODULE;
	moduledata[ModuleData_Dependencies][1] = INVALID_MODULE;
	
	g_moduleHelp = ModuleMgr_Register(moduledata);
	
	RegConsoleCmd("sm_menu", MenuCodMod);
	RegConsoleCmd("sm_pomoc", MenuCodMod);
	RegConsoleCmd("sm_komendy", Komendy);
	RegConsoleCmd("sm_bindy", Bindy);
}
/////////////////////////////////////////////////////////////////////////
///////////////////////       komendy      //////////////////////////////
/////////////////////////////////////////////////////////////////////////
public Action:Komendy(client, args){
	new String:_desc[128];
	new Handle:_hMenu = CreateMenu(Komendy_Handler);
	Format(_desc, 127, "!menu, /menu, menu\nWyswietla glowne menu Cod Mod");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "!klasa, /klasa, !k, /k, klasa\nMenu z wyborem klas");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "!klasy, /klasy, klasy\nOpisy klas");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "!bindy, /bindy, bindy\nSpis przydatnych bindow");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "!sklep, /sklep, !s, /s, sklep\nSklep CodMod");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "!item, !perk, /item, /perk, item, perk, !i, !p, /i, /p\nOpis twojego przedmiotu");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "!itemy, !perki, /itemy, /perki\nOpisy wszystkich przedmiotow");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "!drop, /drop, !d, /d\nWyrzuca aktualny przedmiot");
	AddMenuItem(_hMenu, "0", _desc);
	
	DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
}

public Komendy_Handler(Handle:menu, MenuAction:action, client, item)
{
	if (action == MenuAction_Select){
		switch(item)
		{
			case 0:
				MenuCodMod(client, 0);
			case 1:
				CreateTimer(0.1, Class_Menu_Show, client, TIMER_FLAG_NO_MAPCHANGE);
			case 2:
				Class_Desc_ShowClassListMenu(client);
			case 3:
				Bindy(client, 0);
			case 4:
				MenuSklepu(client, 0);
			case 5:
				Item_Desc_Cmd(client, 0);
			case 6:
				Item_Desc_Cmd_List(client, 0);
			case 7:
				Item_Drop_Cmd(client, 0);
		}
	}else if(action == MenuAction_End){
		CloseHandle(menu);
	}
}
/////////////////////////////////////////////////////////////////////////
///////////////////////       bindy      ////////////////////////////////
/////////////////////////////////////////////////////////////////////////
public Action:Bindy(client, args){
	new String:_desc[128];
	new Handle:_hMenu = CreateMenu(Bindy_Handler);
	Format(_desc, 127, "cod_skill\nMoc specjalna klasy (kliknij po wiecej)");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "cod_item\nMoc specjalna itemu (kliknij po wiecej)");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "zmien_bron\nZmiana broni dlugiej (kliknij po wiecej)");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "+rakieta\nRakieta (kliknij po wiecej)");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "+mina\nMina (kliknij po wiecej)");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "+dynamit\nDynamit (kliknij po wiecej)");
	AddMenuItem(_hMenu, "0", _desc);
	
	DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
}


public Bindy_Handler(Handle:menu, MenuAction:action, client, item)
{
	if (action == MenuAction_Select){
		new String:_desc[128];
		new Handle:_hMenu = CreateMenu(Bindy_Handler2);
		switch(item)
		{
			case 0:
			{
				Format(_desc, 127, "Bind na moc specjalna klasy\nWpisz w konsole:\nbind klawisz cod_skill\nZamiast 'klawisz' podaj klawisz do zbindowania");
				AddMenuItem(_hMenu, "0", _desc);
			}
			case 1:
			{
				Format(_desc, 127, "Bind na moc specjalna itemu\nWpisz w konsole:\nbind klawisz cod_item\nZamiast 'klawisz' podaj klawisz do zbindowania");
				AddMenuItem(_hMenu, "0", _desc);
			}
			case 2:
			{
				Format(_desc, 127, "Bind na zmiane broni glownej\nWpisz w konsole:\nbind klawisz zmien_bron\nZamiast 'klawisz' podaj klawisz do zbindowania");
				AddMenuItem(_hMenu, "0", _desc);
			}
			case 3:
			{
				Format(_desc, 127, "Bind na rakiety\nWpisz w konsole:\nbind klawisz +rakieta\nZamiast 'klawisz' podaj klawisz do zbindowania");
				AddMenuItem(_hMenu, "0", _desc);
			}
			case 4:
			{
				Format(_desc, 127, "Bind na miny\nWpisz w konsole:\nbind klawisz +mina\nZamiast 'klawisz' podaj klawisz do zbindowania");
				AddMenuItem(_hMenu, "0", _desc);
			}
			case 5:
			{
				Format(_desc, 127, "Bind na dynamit\nWpisz w konsole:\nbind klawisz +dynamit\nZamiast 'klawisz' podaj klawisz do zbindowania");
				AddMenuItem(_hMenu, "0", _desc);
			}
		}
		Format(_desc, 127, "PAMIETAJ!\nNigdy nie binduj klawiszy funkcyjnych jak:\nTAB, M, klaiwsze 1-5, spacja itd.\nUsunie to ich poprzednia wlasnosc");
		AddMenuItem(_hMenu, "0", _desc);
		DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
	}else if(action == MenuAction_End){
		CloseHandle(menu);
	}
}

public Bindy_Handler2(Handle:menu, MenuAction:action, client, item)
{
	CloseHandle(menu);
}

/////////////////////////////////////////////////////////////////////////
///////////////////////       menu       ////////////////////////////////
/////////////////////////////////////////////////////////////////////////

public Action:MenuCodMod(client, args){
	new String:_desc[128];
	new Handle:_hMenu = CreateMenu(MenuCodMod_Handler);
	Format(_desc, 127, "Wybierz Klase");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "Opisy Klas");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "Przydatne Komendy");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "Przydatne bindy");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "Sklep");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "Spis Perków");
	AddMenuItem(_hMenu, "0", _desc);
	Format(_desc, 127, "Opis twojego przedmiotu");
	AddMenuItem(_hMenu, "0", _desc);
	
	DisplayMenu(_hMenu, client, MENU_TIME_FOREVER);
}

public MenuCodMod_Handler(Handle:menu, MenuAction:action, client, item)
{
	if (action == MenuAction_Select){
		switch(item)
		{
			case 0:
				CreateTimer(0.1, Class_Menu_Show, client, TIMER_FLAG_NO_MAPCHANGE);
			case 1:
				Class_Desc_ShowClassListMenu(client);
			case 2:
				Komendy(client, 0);
			case 3:
				Bindy(client, 0);
			case 4:
				MenuSklepu(client, 0);
			case 5:
				Item_Desc_ShowItemListMenu(client);
			case 6:
				Item_Desc_Cmd(client, 0);
		}
	}else if(action == MenuAction_End){
		CloseHandle(menu);
	}
}