///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_getDown_server.sqf:		///////////////////
///////////	Executed by nielsen_cim_init.sqf	///////////////////		
///////////	called by nielsen_cim_getDown_client///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script collects info from		///////////////////
///////////	clients, and forces the civilians	///////////////////
///////////	to stop and go prone.				///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CIM_DebugMode) then {diag_log "nielsen_cim_getDown_Server.sqf is running.";};

private ["_cim_serverFnc"];
_cim_serverFnc = {
	private ["_thisMan"];
	_thisMan = _this select 0;
	if (!(_thisman in CIM_List_Keycuff) && isNil {_thisMan getVariable "reezo_ied_triggerman"} && isNil {_thisMan getVariable "reezo_ied_trigger"}) then {
		
		//stop animation if any
		if ((animationState _thisMan) != "") then { _thisMan enableAI "ANIM"; _thisMan enableAI "MOVE"; _broadcastedInfo = ["cim_animation", [true,_thisman,""]] call CBA_fnc_publicVariable;};
		
		//Stop the civs on the spot!
		diag_log "stopping unit now";
		_thisMan setBehaviour "SAFE";
		doStop _thisMan;
		_thisMan setUnitPos "Down";
	};
};

while {true} do {
	waitUntil {CIM_WarnCiv};
	{
		[_x] call _cim_serverFnc;
	} forEach CIM_NewCivilians;
	
	_CBApubVar = ["CIM_WarnCiv", false] call CBA_fnc_publicVariable;

	//Debug
	if (CIM_DebugMode) then {diag_log format ["Server calling getDown function on civilians %1",CIM_NewCivilians];};

	CIM_NewCivilians = [];
};
