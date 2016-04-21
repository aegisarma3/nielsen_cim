///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cRm_events_SpawnFNCs.sqf:	///////////////////
///////////	This script makes functions			///////////////////
///////////	to spawn civilians for events.		///////////////////
///////////////////////////////////////////////////////////////////


//AMBUSH FUNCTION

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
	_leader = _unit;
	
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
//Return value (no semicolon)	
[_grp,_pos,_leader]

