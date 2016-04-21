///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cRm_events_SpawnFNCs.sqf:	///////////////////
///////////	This script makes functions			///////////////////
///////////	to spawn civilians for events.		///////////////////
///////////////////////////////////////////////////////////////////

//INTEL FUNCTION

	private ["_grp","_pos","_NewPos","_spawnPos","_house","_civilians","_civType","_unit"];
	_pos = _this select 0;
	_civilians = CRM_Module getVariable "nielsen_crm_civilians";
	_grp = createGroup civilian;
	_grp setBehaviour "CARELESS";
	
	//Find spawn pos in building
	_spawnPos = [0,0,0];
	while { format ["%1", _spawnPos] == "[0,0,0]" } do {
		_NewPos = [_pos,random 360,[10,100],false,1] call SHK_pos;
		_house = _newPos nearestObject "HOUSE";
		_SpawnPos = _house buildingPos 0;
	};

	_CivType = _civilians select (floor(random(count _civilians)));
	_unit = _grp createUnit [_CivType, _SpawnPos, [], 0, "NONE"]; 
	removeAllitems _unit;
	_unit doFSM ["\nielsen_cim\fsm\nielsen_crm_intel.fsm",getPos _unit,_unit];



