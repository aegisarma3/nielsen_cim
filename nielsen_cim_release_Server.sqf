///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_release_server.sqf:		///////////////////
///////////	Executed by nielsen_cim_init.sqf	///////////////////		
///////////	called by nielsen_cim_release_client///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script collects info from		///////////////////
///////////	clients, and frees the civilian		///////////////////
///////////	from keycuffs (re)enabling AI.		///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CIM_DebugMode) then {diag_log "nielsen_CIM_Release_Server.sqf is running.";};

private ["_cim_serverFnc","_group","_List_Arrested"];
_cim_serverFnc = {
	
	//get the unit and original group
	private ["_thisMan"];
	_thisMan = _this select 0;
	_group = _thisman getVariable "cim_civ_og";
	
	//Return to original group or hold group
	if !(_group == grpNull) then {
		[_thisman] joinSilent _group;
	} else {	
		[_thisman] joinSilent CIM_holdGrp;
	};
		
	//doStop _thisman;
	_thisman setCaptive true;//Make sure he becomes civilian again
	_List_Arrested = CIM_List_Arrested - [_thisman];
	_broadcasted = ["CIM_List_Arrested", _List_Arrested] call CBA_fnc_publicVariable;

		// No! You need to unCuff them first.
	//_thisman enableAI "MOVE";
	//_thisman switchmove "";
	
	//Debug msg
	if (CIM_DebugMode) then {diag_log format ["Civilian %1 released.",_thisman];};
	
};

while {true} do {
	waitUntil {CIM_Release};
	
	[CIM_NewRelease] call _cim_serverFnc;
	//Debug
	if (CIM_DebugMode) then {diag_log format ["Server calling release function on civilian %1",CIM_NewRelease];};
	
	CIM_NewRelease = ObjNull;
	
	_broadcasted = ["CIM_Release", false] call CBA_fnc_publicVariable;
	sleep 0.5;
	
};
