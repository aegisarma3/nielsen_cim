///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cRm_events_server.sqf:		///////////////////
///////////	This script makes the events.		///////////////////
///////////										///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CRM_DebugMode) then {diag_log "nielsen_cRm_events_Server.sqf is running.";};

//get variables

_chance = CRM_Module getVariable "nielsen_crm_chance";
_events = CRM_Module getVariable "nielsen_crm_events";
_range = 300;
_multiplier = CRM_Module getVariable "nielsen_crm_multiplier";

//Launch new event when ordered
while {true} do {

	//Reset newEvent (set false) before (re)starting loop
	_resetVariable = ["crm_newEvent",[false,"random",objNull]] call CBA_fnc_publicVariable;

	//wait for newEvent and set variables
	waitUntil {crm_newEvent select 0};
	_type = crm_newEvent select 1;
	_pos = crm_newEvent select 2;
		//Check if custom event multiplier is set, else use module multiplier
	if (count _this == 4) then {
		_multiplier = crm_newEvent select 3;
	} else {
		_multiplier = CRM_Module getVariable "nielsen_crm_multiplier";
	};

	//Choose random event
	if (_type == "random") then {
		_type = _events select (floor(random(count _events)));
	};

	//Gather civilians near soldier and put in _civilians list
	_civilians = [];
	_nearMen = _pos nearEntities ["Man",_range];
	for "_y" from 0 to (count _nearMen - 1) do {
		if (side (_nearMen select _y) == CIVILIAN && !((group (_nearMen select _y)) in CRM_AllGroups) && !((_nearMen select _y) in CIM_List_Keycuff) && isNil {(_nearMen select _y) getVariable "reezo_eod_triggerman"} && isNil {(_nearMen select _y) getVariable "reezo_eod_trigger"}) then {
			_civilians = _civilians + [(_nearMen select _y)];
		};
	};

	//Do the event
	switch (_type) do {

		//Riot event
		case "riot":
		{
			civilian setFriend [west,0];
			//make all civilians do the riot.fsm
			//civilian setFriend [west,0];
			{
				_x doFSM ["\nielsen_cim\fsm\nielsen_crm_riot.fsm",getPos _x,_x];
			} forEach _civilians;
			//Debug
			if (CRM_DebugMode) then {diag_log format ["CRM - Riot triggered. Civilians: %1",_civilians];};
		};

		//Intel event
		case "intel":
		{
			//make a random civilian give intel
			_newCiv = _civilians select (floor(random(count _civilians)));
			_newCiv doFSM ["\nielsen_cim\fsm\nielsen_crm_intel.fsm",getPos _newCiv,_newCiv];

			//Debug
			if (CRM_DebugMode) then {diag_log format ["CRM - Intel triggered. Civilian: %1",_newCiv];};
		};
	};

	sleep 0.5;
};
