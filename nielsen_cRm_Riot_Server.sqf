///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cRm_riot_server.sqf:		///////////////////
///////////	This script creates random riots	///////////////////
///////////	when pacifying civilians.			///////////////////
///////////////////////////////////////////////////////////////////

private ["_chance","_Civilians","_nearMen","_newCiv","_cause"];

//Set variables
_chance = CRM_Module getVariable "nielsen_crm_chance_riot";
_range = 200;

//Function to add make riot
private ["_riotFNC"];
_riotFNC = {

	private ["_thisMan","_item"];
	_thisMan = _x;

	_thisMan doFSM ["\@Nielsen_CIM\addons\nielsen_cim\fsm\nielsen_crm_riot.fsm",getPos _thisman,_thisman];
	//Set variable on unit to check in other (local) scripts
	//_thisMan setVariable ["crm_evidence",_item];
};

//Control structure
while {true} do {
	
	waitUntil {(CRM_Riot_Cause select 0)};
	if (CRM_DebugMode) then {diag_log "CRM - Riot triggered";};
	_Cause = CRM_Riot_Cause select 1;
	
	//force riot if enabled or get set chance value
	private ["_newchance"];
	if ((count CRM_Riot_Cause) == 3) then {_Newchance = 1} else {_newChance = _chance};
	
	_rnd = random 1;
	//Check against chance
	if (_rnd < _chance) then {
		//Gather nearby civs and put in _civilians list
		_Civilians = [];
		_nearMen = (getPos _Cause) nearEntities ["Man",_range];
		for "_y" from 0 to (count _nearMen - 1) do {
			if (side (_nearMen select _y) == CIVILIAN && !((group (_nearMen select _y)) in CRM_AllGroups) && !((_nearMen select _y) in CIM_List_Keycuff) && isNil {(_nearMen select _y) getVariable "reezo_ied_triggerman"} && isNil {(_nearMen select _y) getVariable "reezo_ied_trigger"}) then {
				_Civilians = _Civilians + [(_nearMen select _y)];			
			};
		};

		//Call function on civs to start riot
		{
			[_x] call _riotFNC;
		} forEach _civilians;
	
		//Debug
		if (CRM_DebugMode) then {diag_log format ["CRM - Riot triggered. Civilians: %1",_Civilians];};
	};
	_CBApubVar = ["CRM_Riot_Cause", [false,(CRM_Riot_Cause select 1)]] call CBA_fnc_publicVariable;
	sleep 1;	

};