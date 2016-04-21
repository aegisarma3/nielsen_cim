///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cRm_control_server.sqf:		///////////////////
///////////	This script triggers events.		///////////////////
///////////										///////////////////
///////////////////////////////////////////////////////////////////
private ["_chance","_range","_allMarkers"];
_chance = CRM_Module getVariable "nielsen_crm_events_chance";
_range = CRM_Module getVariable "nielsen_crm_events_range";

//how many locations?
private ["_locations"];
if (isNil {CRM_Module getVariable "nielsen_crm_Locations"}) then {
	diag_log "CRM - Number of locations is not set for CRM";
	hint "Locations for CRM not set.";
	if (true) exitWith {};
} else {
	_locations = CRM_Module getVariable "nielsen_crm_Locations";
};

//Gather markers in list
_allMarkers = [];
for "_y" from 1 to _locations do {
	call compile format ["_allMarkers = _allMarkers + [""CRM_Marker_%1""];",_y];
};

//Debug
if (CRM_DebugMode) then {diag_log format ["nielsen_cRm_checkLocations_Server.sqf is running. CRM_AllCities is: %1",CRM_AllCities];};

//Dont start the loop until we start the mission
waitUntil {time > 1;};

while {true} do {
	{
		private ["_distance","_rnd","_checkUnit","_pos"];
		//Get the nearest city of player
		_checkUnit = _x;
		if (vehicle _x != _x) then {_checkUnit = vehicle _x;};
		
		//debug		
		//if (CRM_DebugMode) then {diag_log format ["CRM - Cheking for location. All locations are %1.",_allMarkers];};
		
		{
			_pos = getMarkerPos _x;
			_distance = _pos distance _checkUnit;
			if (_distance < _range) then {
				_rnd = random 1;
				if (_rnd < _chance) then {
					_broadcastEvent = ["crm_newEvent",[true,"random",_pos]] call CBA_fnc_publicVariable;
				};
				//Remove from city list, so not to check more than once
				_allMarkers = _allMarkers - [_x];
				sleep 2.5;
			};
		} forEach _allMarkers;
		sleep 1;
	} forEach CRM_SyncUnits;
};
	
	
