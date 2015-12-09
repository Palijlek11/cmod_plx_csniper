#if defined ITEM_SYS
#define ITEM_NATIVE;

public Item_Native_GetClientItem(Handle:plugin, numParams){
	if(1 <= GetNativeCell(1) && GetNativeCell(1) <= MaxClients && IsClientConnected(GetNativeCell(1)) && IsClientInGame(GetNativeCell(1))){
		return g_iCmodPlayerItem[GetNativeCell(1)];
	}
	return -1;
}

public Item_Native_GetItemNameByID(Handle:plugin, numParams){
	if(GetNativeCell(1) <= g_iCmodItemCount && GetNativeCell(1) >= 0){
		SetNativeString(2, g_sCmodItemName[GetNativeCell(1)], GetNativeCell(3));	
		return 1;	
	}
	
	return 0;
}

public Item_Native_GetItemIDByName(Handle:plugin, numParams){
	decl String:_tmp[MAX_NAME_LONG+1];
	GetNativeString(1, _tmp, sizeof(_tmp));
	for(new i; i <= g_iCmodItemCount; i++){
		if(StrEqual(_tmp, g_sCmodItemName[i])){
			return i;
		}
	}
	return -1;
}

public Item_Native_GetItemDesc(Handle:plugin, numParams){
	if(GetNativeCell(1) <= g_iCmodItemCount && GetNativeCell(1) >= 0){
		SetNativeString(2, g_sCmodItemDesc[GetNativeCell(1)], GetNativeCell(3));	
		return 1;	
	}
	
	return 0;
}

public Item_Native_GetMinItemValue(Handle:plugin, numParams){
	return g_iCmodItemMinValue[GetNativeCell(1)];
}

public Item_Native_GetMaxItemValue(Handle:plugin, numParams){
	return g_iCmodItemMaxValue[GetNativeCell(1)];
}

public Item_Native_GetClientItemValue(Handle:plugin, numParams){
	return g_iCmodPlayerItemValue[GetNativeCell(1)];
}

public Item_Native_SetMinItemValue(Handle:plugin, numParams){
	g_iCmodItemMinValue[GetNativeCell(1)] = GetNativeCell(2);
}

public Item_Native_SetMaxItemValue(Handle:plugin, numParams){
	g_iCmodItemMaxValue[GetNativeCell(1)] = GetNativeCell(2);
}

public Item_Native_SetClientItemValue(Handle:plugin, numParams){
	g_iCmodPlayerItemValue[GetNativeCell(1)] = GetNativeCell(2);
}

public Item_Native_GetItemCount(Handle:plugin, numParams){
	return g_iCmodItemCount;
}

public Item_Native_SetClientItem(Handle:plugin, numParams){
	Item_Set(GetNativeCell(1), GetNativeCell(2));
}
#endif
