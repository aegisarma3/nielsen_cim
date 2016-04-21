///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cRm_control_server.sqf:		///////////////////
///////////	This script triggers events.		///////////////////
///////////										///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CRM_DebugMode) then {diag_log "nielsen_cRm_control_Server.sqf is running.";};

private ["_time","_chance","_events"];

_time = 5;//CRM_Module getVariable "nielsen_crm_time";
_chance = 1;//CRM_Module getVariable "nielsen_crm_chance";
_events = ["riot","riot"];

//Dont start the loop until we start the mission
waitUntil {time > 1;};

//check chance for event on each synced unit and broadcast the random event on unit(s)
while {true} do {
	sleep _time;
	{
		_rnd = random 1;
		if (_rnd < _chance) then {

			_broadcastEvent = ["crm_newEvent",[true,"random",_x]] call CBA_fnc_publicVariable;

			//Debug
			if (CRM_DebugMode) then {diag_log format ["Server starting new civilian event. On civs: %1",_Civilians];};
		};
	} forEach CRM_SyncUnits;
};

