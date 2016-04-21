///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_stopCar_server.sqf:		///////////////////
///////////	Executed by nielsen_cim_init.sqf	///////////////////		
///////////	called by nielsen_cim_stopCar_client///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script collects info from		///////////////////
///////////	clients, and forces the civilian	///////////////////
///////////	car to stop, and all inside to eject///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CIM_DebugMode) then {diag_log "nielsen_cim_arrest_Server.sqf is running.";};

private ["_cim_serverFnc"];
_cim_serverFnc = {
	
	//What should the civilian do?
	private ["_thisMan"];
	_thisMan = _this select 0;
	
	doGetOut _thisMan;
	//dostop _thisman;
	[_thisMan] allowGetin false;
};

while {true} do {
	waitUntil {CIM_stopCar};
	
	{
	[_x] call _cim_serverFnc;
	} forEach CIM_carCrew;
	//Debug
	if (CIM_DebugMode) then {diag_log format ["Server calling stop car function. List of crew: %1",CIM_carCrew];};
	
	CIM_carCrew = [];
	
	_broadcasted = ["CIM_stopCar", false] call CBA_fnc_publicVariable;
	sleep 0.5;
	
};

