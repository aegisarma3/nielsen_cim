///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cRm_events_SpawnFNCs.sqf:	///////////////////
///////////	This script makes functions			///////////////////
///////////	to spawn civilians for events.		///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CRM_DebugMode) then {diag_log "nielsen_cRm_events_SpawnFNCs.sqf is running.";};

//RIOT FUNCTION
CRM_SpawnFnc_riot = {
	//get variables
	private ["_pos","_multiplier","_spawnCount","_NewPos","_house","_civilians","_civType","_spawnPos","_unit"];
	_pos = _this select 0;
	_multiplier = _this select 1;
	_spawnCount = round ((10 + random 10) * _multiplier);
	_civilians = CRM_Module getVariable "nielsen_crm_civilians";
	_grp = createGroup civilian;
	_grp setBehaviour "CARELESS";
	//_grp setCombatMode "BLUE";

			//Debug
			if (CRM_DebugMode) then {diag_log format ["CRM - Riot triggered. Spawning %1 civilians, of types %2",_spawnCount,_civilians];};

	//Spawn civilians
	for "_y" from 1 to _spawnCount do {
		//Find new hidden spawn position
		_spawnPos = [0,0,0];
		while { format ["%1", _spawnPos] == "[0,0,0]" } do {
			_NewPos = [_pos,random 360,[10,100],false,1] call SHK_pos;
			_house = _newPos nearestObject "HOUSE";
			_SpawnPos = _house buildingPos 0;
		};

		_CivType = _civilians select (floor(random(count _civilians)));
		if (CRM_DebugMode) then {diag_log format ["grp: %1,type %2, pos %3",_grp,_CivType,_SpawnPos];};
		_unit = _grp createUnit [_CivType, _SpawnPos, [], 0, "NONE"];
		sleep 0.1;
		_unit allowDamage false;
		removeAllWeapons _unit;

			//Eventhandler that fires pubVar for client to cancel animation
		_unit addEventHandler ["Killed", { broadcastedInfo = ["cim_animation", [true,(_this select 0),""]] call CBA_fnc_publicVariable;}];

		_unit doFSM ["\nielsen_cim\fsm\nielsen_crm_gathering.fsm",getPos _unit,_unit];
	};
};

//INTEL FUNCTION
CRM_SpawnFnc_Intel = {
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
	removeAllWeapons _unit;
	_unit doFSM ["\nielsen_cim\fsm\nielsen_crm_intel.fsm",getPos _unit,_unit];

};

//AMBUSH FUNCTION
CRM_SpawnFnc_Ambush = {
	//get variables
	private ["_enemyType","_enemySide","_pos","_multiplier","_spawnCount","_NewPos","_house","_civilians","_civType","_grp","_spawnPos","_unit"];
	_pos = _this select 0;
	_multiplier = _this select 1;
	_spawnCount = round ((2 + random 6) * _multiplier);
	_civilians = CRM_Module getVariable "nielsen_crm_civilians";
	if (true) then {_enemyType = "TK_INS_Warlord_EP1";} else {_enemyType = "US_Delta_Force_TL_EP1";};
	_grp = createGroup CRM_EnemySide;
	_grp setBehaviour "STEALTH";
	_grp setCombatMode "GREEN";

	//Spawn OPFOR LEADER (to make sure the civs are hostile)
	//Find spawn pos in building
	_spawnPos = [0,0,0];
	while { format ["%1", _spawnPos] == "[0,0,0]" } do {
		_NewPos = [_pos,random 360,[10,100],false,1] call SHK_pos;
		_house = _newPos nearestObject "HOUSE";
		_SpawnPos = _house buildingPos 0;
	};
	_unit = _grp createUnit [_enemyType, _spawnPos, [], 0, "NONE"];

	//Spawn civilians
	for "_y" from 1 to _spawnCount do {
		//Find new hidden spawn position
		_spawnPos = [0,0,0];
		while { format ["%1", _spawnPos] == "[0,0,0]" } do {
			_NewPos = [_pos,random 360,[10,100],false,1] call SHK_pos;
			_house = _newPos nearestObject "HOUSE";
			_SpawnPos = _house buildingPos 0;
		};
		_No = 0;
		while { format ["%1", _house buildingPos _No] != "[0,0,0]" } do {_No = _No + 1};
		_SpawnPos = _house buildingPos (floor random  _No);

		_CivType = _civilians select (floor(random(count _civilians)));
		_unit = _grp createUnit [_CivType, _SpawnPos, [], 0, "NONE"];

		_unit setUnitPos "DOWN";
		_unit addWeapon "AK_74";
		_unit addMagazine "30Rnd_545x39_AK"; _unit addMagazine "30Rnd_545x39_AK"; _unit addMagazine "30Rnd_545x39_AK"; _unit addMagazine "30Rnd_545x39_AK";
		_unit setskill ["Endurance",0.4];
		_unit setskill ["aimingAccuracy",0.1];
		_unit setskill ["aimingSpeed",0.2];
		_unit setskill ["aimingShake",0.1];
		_unit setskill ["spotDistance",0.2];
		_unit setskill ["courage",0.4];

		if (CRM_DebugMode) then {diag_log format ["CRM - Ambush triggered. Spawning %1 hostile civilians.",_spawnCount];};
	};
	//Execute(!) FSM to control ambush  (ERROR FIX THE FSM!!!)
	//nul = [_grp,_pos] ExecFSM "\nielsen_cim\fsm\nielsen_crm_ambush.fsm";
};

//Massacre FUNCTION
CRM_SpawnFnc_massacre = {
	//get variables
	private ["_pos","_multiplier","_spawnCount","_NewPos","_house","_civilians","_civType","_spawnPos","_unit"];
	_pos = _this select 0;
	_multiplier = _this select 1;
	_spawnCount = round ((15 + random 10) * _multiplier);
	_civilians = CRM_Module getVariable "nielsen_crm_civilians";
	_grp = createGroup civilian;

			//Debug
	if (CRM_DebugMode) then {diag_log format ["CRM - Masssacre triggered. Spawning %1 civilians, of types %2",_spawnCount,_civilians];};

	//Spawn civilians
	for "_y" from 1 to _spawnCount do {
		//Find new spawn position
		_spawnpos = [_pos,random 360,[5,20],false,1] call SHK_pos;

		_CivType = _civilians select (floor(random(count _civilians)));

		_unit = _grp createUnit [_CivType, _spawnPos, [], 0, "NONE"];

		removeAllWeapons _unit;
		_unit setDamage 1;

		//Spawn flies (global?)
		//nul = [getPos _unit] call bis_FNC_Flies;
		nul = [-2, {nul = [getPos _unit] call bis_FNC_Flies;}] call CBA_fnc_globalExecute;
	};
};
