///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cRm_control_server.sqf:		///////////////////
///////////	This script triggers events.		///////////////////
///////////										///////////////////
///////////////////////////////////////////////////////////////////

_chance = CRM_Module getVariable "nielsen_crm_events_chance";
_range = CRM_Module getVariable "nielsen_crm_events_range";

	//Find all cities
	private ["_locationTypes","_nearest","_dist"];
	_locationTypes = ["NameCityCapital","NameCity","NameVillage","NameLocal"];
	CRM_AllCities = nearestLocations [CRM_Module,_locationTypes, 15000];
	_dist = CRM_Module distance (getPos _nearestCity);

//Debug
if (CRM_DebugMode) then {diag_log format ["nielsen_cRm_checkCity_Server.sqf is running. CRM_AllCities is: %1",CRM_AllCities];};

//Dont start the loop until we start the mission
waitUntil {time > 1;};

while {true} do {
	{
		//private ["_nearestCity","_closing","_dist1","_dist2","_closing","_rnd"];
		//Get the nearest city of player
		_checkUnit = _x;
		if (vehicle _x != _x) then {_checkUnit = vehicle _x;};
		_locationTypes = ["NameCityCapital","NameCity","NameVillage","NameLocal"];
		_nearestCity = (nearestLocations [_checkUnit,_locationTypes, _range]) select 0;
		
		//If near a a new city check if allready setup, else set it up
		if !(isNull _nearestCity) then {
			if (CRM_DebugMode) then {diag_log format ["CRM - Cheking for city. Nearest city is %1.",_nearestCity];};
			//Check if new city
			if (_nearestCity in CRM_AllCities) then {
				//Chance to spawn event
				hint "testing";
				_rnd = random 1;
				if (_rnd < _chance) then {
					_broadcastEvent = ["crm_newEvent",[true,"random",getPos _nearestCity]] call CBA_fnc_publicVariable;
					hint "creating event";
				};
				//Remove from city list, so not to check more than once
				CRM_AllCities = CRM_AllCities - [_nearestCity];
				
				//Debug
				if (CRM_DebugMode) then {
					diag_log format ["City %1 is spawning new event.",_nearestCity];	
					hint "Making event";
					call compile format ["intelMarker_%1 = createMarker [""intelMarker_%1"", getPos _nearestCity]; intelMarker_%1 setMarkerShape ""ICON""; intelMarker_%1 setMarkerText ""City""; intelMarker_%1 setMarkerSize [1,1]; intelMarker_%1 setMarkerColor ""ColorRed""; intelMarker_%1 setMarkerType ""DOT"";",CRM_Intel_Found];
					_pubVar = ["CRM_Intel_Found", CRM_Intel_Found + 1] call CBA_fnc_publicVariable;
				};
			};
		};
		sleep 2;
	} forEach CRM_SyncUnits;
};
	
	
