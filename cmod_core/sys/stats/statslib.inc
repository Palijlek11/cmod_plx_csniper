
stock Stats_GetINT(const client, const bool:pPoint = true, const bool:cPoint = true, const bool:bPoint = true){
	new _point;
	if(pPoint)
		_point += g_iCmodPlayerINT[client];
	if(cPoint)
		_point += g_iCmodClassINT[g_iCmodPlayerClass[client]];
	if(bPoint)
		_point += g_iCmodBonusINT[client];
	return _point;
}

stock Stats_GetCON(const client, const bool:pPoint = true, const bool:cPoint = true, const bool:bPoint = true){
	new _point;
	if(pPoint)
		_point += g_iCmodPlayerCON[client];
	if(cPoint)
		_point += g_iCmodClassCON[g_iCmodPlayerClass[client]];
	if(bPoint)
		_point += g_iCmodBonusCON[client];
	return _point;
}

stock Stats_GetSTR(const client, const bool:pPoint = true, const bool:cPoint = true, const bool:bPoint = true){
	new _point;
	if(pPoint)
		_point += g_iCmodPlayerSTR[client];
	if(cPoint)
		_point += g_iCmodClassSTR[g_iCmodPlayerClass[client]];
	if(bPoint)
		_point += g_iCmodBonusSTR[client];
	return _point;
}

stock Stats_GetDEX(const client, const bool:pPoint = true, const bool:cPoint = true, const bool:bPoint = true){
	new _point;
	if(pPoint)
		_point += g_iCmodPlayerDEX[client];
	if(cPoint)
		_point += g_iCmodClassDEX[g_iCmodPlayerClass[client]];
	if(bPoint)
		_point += g_iCmodBonusDEX[client];
	return _point;
}

stock Stats_GetARM(const client){
	return g_iCmodClassARM[g_iCmodPlayerClass[client]];
}
