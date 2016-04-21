///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_getInside_server.sqf:	///////////////////
///////////	Executed by nielsen_cim_init.sqf	///////////////////		
///////////	called by nielsen_cim_getInside_client/////////////////
///////////////////////////////////////////////////////////////////
///////////	This script collects info from		///////////////////
///////////	clients, and sends the civilians	///////////////////
///////////	running into nearby buildings.		///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CIM_DebugMode) then {diag_log "nielsen_cim_getInside_Server.sqf is running!";};

private ["_cim_serverFnc"];
_cim_serverFnc = {
	private ["_thisMan","_house","_pos","_newPos"];
	_thisMan = _this select 0;
	
	if (!(_thisman in CIM_List_Keycuff) AND (group _thisMan != group CIM_getInside_Caller) AND isNil {_thisMan getVariable "reezo_ied_triggerman"} && isNil {_thisMan getVariable "reezo_ied_trigger"}) then {
		
		//stop animation if any
		if ((animationState _thisMan) != "") then { _thisMan enableAI "ANIM"; _thisMan enableAI "MOVE"; _broadcastedInfo = ["cim_animation", [true,_thisman,""]] call CBA_fnc_publicVariable;};
		/* //NOW HANDLED BY FSM
		//Get nearest building and number of housepositions, then send CIV to random position in house
		_house = nearestBuilding _thisMan;
		_pos = 0;
		while { format ["%1", _house buildingPos _pos] != "[0,0,0]" } do {_pos = _pos + 1};
		_pos = _pos - 1; 
		_newPos = round random _pos; 
		*/
		
		//[_thisMan] joinSilent grpNull;

			_thisMan doFSM ["\nielsen_cim\fsm\nielsen_cim_getInside.fsm",getPos _thisman,_thisman];
			waitUntil {unitReady _thisMan;};
			doStop _thisMan;
			//_thisMan disableAI "FSM";
			
			//Debug
			if (CIM_DebugMode) then {diag_log format ["%2 telling civilian - %1 - to move inside.",_thisman,CIM_getInside_Caller];};			
	};
};

while {true} do {
	waitUntil {CIM_getInside};
	{
		[_x] spawn _cim_serverFnc;
	} forEach CIM_InsideCivilians;
	CIM_InsideCivilians = [];
	
	_CBApubVar = ["CIM_getInside", false] call CBA_fnc_publicVariable;
	sleep 0.5;

	//Debug
	if (CIM_DebugMode) then {diag_log "Server calling function on CIM_InsideCivilians.";};
};
