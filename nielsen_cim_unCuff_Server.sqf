///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_CIM_unCuff_server.sqf:		///////////////////
///////////	Executed by nielsen_cim_init.sqf	///////////////////		
///////////	called by nielsen_CIM_unCuff_client///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script collects info from		///////////////////
///////////	clients, and frees the civilian		///////////////////
///////////	from keycuffs (re)enabling AI.		///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CIM_DebugMode) then {diag_log "nielsen_CIM_unCuff_Server.sqf is running.";};

private ["_cim_serverFnc"];
_cim_serverFnc = {
	
	//What should the civilian do?
	private ["_thisMan","_List_Keycuff"];
	_thisMan = _this select 0;

	_thisman enableAI "ANIM";
	_thisman enableAI "MOVE";
	//_thisman switchmove "";
	
	
	_broadcastedInfo = ["cim_animation", [true,_thisman,""]] call CBA_fnc_publicVariable;

	
	_List_Keycuff = CIM_List_Keycuff - [_thisman];
	_CBApubVar = ["CIM_List_Keycuff", _List_Keycuff] call CBA_fnc_publicVariable;
	
	//Debug msg
	if (CIM_DebugMode) then {diag_log format ["Civilian %1 unCuffed.",_thisman];};
	
};

while {true} do {
	waitUntil {CIM_unCuff};
	
	[CIM_NewunCuff] call _cim_serverFnc;
	//Debug
	if (CIM_DebugMode) then {diag_log format ["Server calling release function on civilian %1",CIM_NewunCuff];};
	
	CIM_NewunCuff = ObjNull;

	_CBApubVar = ["CIM_unCuff", false] call CBA_fnc_publicVariable;
	sleep 0.5;
	
};
