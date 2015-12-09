#if defined XP_SYS
#define XP_NATIVE

public Xp_Native_GetClientExp(Handle:plugin, numParams){
	if(1 <= GetNativeCell(1) && GetNativeCell(1) <= MaxClients && IsClientConnected(GetNativeCell(1)) && IsClientInGame(GetNativeCell(1))){
		return g_iCmodExp[GetNativeCell(1)];
	}
	return -1;
}

public Xp_Native_SetClientExp(Handle:plugin, numParams){
	if(1 <= GetNativeCell(1) && GetNativeCell(1) <= MaxClients && IsClientConnected(GetNativeCell(1)) && IsClientInGame(GetNativeCell(1))){
		g_iCmodExp[GetNativeCell(1)] = GetNativeCell(2);
		return true;
	}
	return false;
}

public Xp_Native_GetClientBonusExp(Handle:plugin, numParams){
	if(1 <= GetNativeCell(1) && GetNativeCell(1) <= MaxClients && IsClientConnected(GetNativeCell(1)) && IsClientInGame(GetNativeCell(1))){
		return g_iCmodBonusExp[GetNativeCell(1)];
	}
	return -1;
}

public Xp_Native_SetClientBonusExp(Handle:plugin, numParams){
	if(1 <= GetNativeCell(1) && GetNativeCell(1) <= MaxClients && IsClientConnected(GetNativeCell(1)) && IsClientInGame(GetNativeCell(1))){
		g_iCmodBonusExp[GetNativeCell(1)] = GetNativeCell(2);
		return true;
	}
	return false;
}

public Xp_Native_GetExpForLvl(Handle:plugin, numParams){
	if(1 <= GetNativeCell(1) && GetNativeCell(1) <= MaxClients && IsClientConnected(GetNativeCell(1)) && IsClientInGame(GetNativeCell(1))){
		return XpSys_GetXpForLvl(GetNativeCell(1));
	}
	return false;
}

public Xp_Native_CheckClientLvl(Handle:plugin, numParams){
	if(1 <= GetNativeCell(1) && GetNativeCell(1) <= MaxClients && IsClientConnected(GetNativeCell(1)) && IsClientInGame(GetNativeCell(1))){
		XpSys_CheckLvl(GetNativeCell(1));
		return true;
	}
	return false;
}

#endif
