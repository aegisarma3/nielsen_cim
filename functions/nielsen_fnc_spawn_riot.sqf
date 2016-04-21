///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cRm_events_SpawnFNCs.sqf:	///////////////////
///////////	This script makes functions			///////////////////
///////////	to spawn civilians for events.		///////////////////
///////////////////////////////////////////////////////////////////

//RIOT FUNCTION

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
		
		_CivType = _civilians select (floor(random(count _civilians)));
		if (CRM_DebugMode) then {diag_log format ["grp: %1,type %2, pos %3",_grp,_CivType,_SpawnPos];};
		_unit = _grp createUnit [_CivType, _Pos, [], 100, "NONE"];
		_unit allowDamage false;
		removeAllWeapons _unit;
			
			//Eventhandler that fires pubVar for client to cancel animation
		//_unit addEventHandler ["firedNear", { cim_animation = [true,(_this select 0),""];(_this select 0) doFSM ["\@Nielsen_CIM\addons\nielsen_cim\fsm\nielsen_crm_gathering.fsm",getPos (_this select 0),(_this select 0)];}];
		_unit addEventHandler ["hit", { broadcastedInfo = ["cim_animation", [true,(_this select 0),""]] call CBA_fnc_publicVariable;}];
		
		_unit doFSM ["\@Nielsen_CIM\addons\nielsen_cim\fsm\nielsen_crm_gathering.fsm",getPos _unit,_unit];
	};

