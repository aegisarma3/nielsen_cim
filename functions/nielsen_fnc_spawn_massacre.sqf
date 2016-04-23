///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cRm_events_SpawnFNCs.sqf:	///////////////////
///////////	This script makes functions			///////////////////
///////////	to spawn civilians for events.		///////////////////
///////////////////////////////////////////////////////////////////

//Massacre FUNCTION

	//get variables
	private ["_pos","_multiplier","_spawnCount","_NewPos","_house","_civilians","_civType","_spawnPos","_unit","_dog"];
	_pos = _this select 0;
	_multiplier = _this select 1;
	_spawnCount = round ((15 + random 10) * _multiplier);
	_civilians = CRM_Module getVariable "nielsen_crm_civilians";
	_grp = createGroup civilian;
	_grp2 = createGroup civilian;

			//Debug
	if (CRM_DebugMode) then {diag_log format ["CRM - Masssacre triggered. Spawning %1 civilians, of types %2",_spawnCount,_civilians];};

	//create dog
	//"fin" createVehicle [_pos, _grp];
	 _dog = _grp2 createUnit ["Fin_random_F", _pos, [], 5, "NONE"];

	//Spawn civilians
	for "_y" from 1 to _spawnCount do {
		//Find new spawn position
		//_spawnpos = [_pos,random 360,[5,20],false,1] call SHK_pos;

		_CivType = _civilians select (floor(random(count _civilians)));

		_unit = _grp createUnit [_CivType, _pos, [], 20, "NONE"];

		removeAllitems _unit;
		_unit setDamage 1;
		//Create local effects (flies) on all machines with globalexecute
		call compile format ["nul = [-2, {nul = [%1] call bis_FNC_Flies;}] call CBA_fnc_globalExecute; ",(getPos _unit)];
	};

	_CivTypeWomen = ["C_scientist_F","C_journalist_F"]; //POR WOMAN CLASSNAME QUANDO EXISTIR NO A3
	_spawnCount = 1 + (round random 3);
	//Spawn women
	for "_y" from 1 to _spawnCount do {

		_CivType = _CivTypeWomen select (floor(random(count _CivTypeWomen)));

		_unit = _grp2 createUnit [_CivType, _Pos, [], 20, "NONE"];
		//_unit allowDamage false;
		//removeAllWeapons _unit;

			//Eventhandler that fires pubVar for client to cancel animation
		_unit addEventHandler ["hit", { broadcastedInfo = ["cim_animation", [true,(_this select 0),""]] call CBA_fnc_publicVariable;}];


		_unit doFSM ["\nielsen_cim\fsm\nielsen_crm_women.fsm",getPos _unit,_unit];
	};
