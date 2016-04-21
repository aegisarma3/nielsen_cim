///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_getAway_server.sqf:		///////////////////
///////////	Executed by nielsen_cim_init.sqf	///////////////////		
///////////	called by nielsen_cim_getAway_client///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script collects info from		///////////////////
///////////	clients, and sends the civilians	///////////////////
///////////	running away from the player		///////////////////
///////////////////////////////////////////////////////////////////


//Debug
if (CIM_DebugMode) then {diag_log "nielsen_cim_getAway_Server.sqf is running!";};

private ["_cim_serverFnc"];
_cim_serverFnc = {
	private ["_thisMan","_spawnPos"];
	_thisMan = _this select 0;
	
	if ( !(_thisman in CIM_List_Keycuff) AND (group _thisMan != group CIM_getAway_Caller) AND isNil {_thisMan getVariable "reezo_ied_triggerman"} && isNil {_thisMan getVariable "reezo_ied_trigger"}) then {

			//stop animation if any
		if ((animationState _thisMan) != "") then { _thisMan enableAI "ANIM"; _thisMan enableAI "MOVE"; _broadcastedInfo = ["cim_animation", [true,_thisman,""]] call CBA_fnc_publicVariable;};
		
		//Get position to move to from SHK_pos.sqf, and send civilian there
		_spawnpos = [getpos CIM_getAway_Caller,random 360,[100,200],false,1] call SHK_pos;
		_thisMan setBehaviour "SAFE";
		_thisMan setUnitPos "Up";
		_thisMan doMove _spawnPos;
		
		//Debug
		if (CIM_DebugMode) then {diag_log format ["Server telling civilian - %1 - to move away from %2.",_thisman,CIM_getAway_Caller];};
	};
};

while {true} do {
	waitUntil {CIM_GetOutCiv};
	{
		[_x] call _cim_serverFnc;
	} forEach CIM_AwayCivilians;
	//CIM_AwayCivilians = [];

	_CBApubVar = ["CIM_GetOutCiv", false] call CBA_fnc_publicVariable;
	sleep 0.5;

	//Debug
	if (CIM_DebugMode) then {diag_log "Server calling function on CIM_AwayCivilians.";};
};
