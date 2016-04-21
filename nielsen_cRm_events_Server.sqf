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
private ["_chance","_events","_multiplier","_pos","_type","_spawnEvent"];
_chance = CRM_Module getVariable "nielsen_crm_chance";
_events = CRM_Module getVariable "nielsen_crm_events";
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
	
	//DEBUG - hint format ["Spawning %1, on pos %2",_type,_pos];
	
	//Do the event
	switch (_type) do {
		
		//Riot event
		case "gathering":
		{
			//Get nearest road
			private ["_roads","_nearRoad","_reciever"];
			_roads = _pos nearRoads 50;
			_newRoad = _roads select (floor(random(count _roads)));
			_pos = getPos _newRoad;
			
			//Setup tirepile on road as center of event (unique name to pass to client because of smoke)
			call compile format ["crm_tirepile_%1 = createVehicle [""misc_tyreheap"", %2, [], 5, ""NONE""];",CRM_TirePile_Count,_pos];
			call compile format ["crm_tirepile_%1 setVariable [""crm_tirePile"",true];",CRM_TirePile_Count];
			call compile format ["crm_tirepile_%1 inflame true;",CRM_TirePile_Count];
			call compile format ["crm_tirepile_%1 setpos [(getpos crm_tirepile_%1) select 0, (getpos crm_tirepile_%1) select 1, -0.2];",CRM_TirePile_Count];
			call compile format ["waitUntil {!(isNil (""crm_tirepile_%1""));};",CRM_TirePile_Count];

			//Create local effects (sound/smoke) with globalexecute
			call compile format ["
				[-2, {
					CRM_Smoke_%1 = [crm_tirepile_%1,4,time,false,false] spawn BIS_Effects_Burn;
					CRM_TriggerPos_%1 = [%2 select 0, (%2 select 1) + 10, 1.8];
					CRM_TriggerArray_%1 = [CRM_TriggerPos_%1, ""AREA:"", [30, 30, 0, false], ""ACT:"", [""CIV"", ""PRESENT"", true], ""STATE:"", [""true"","""",""""]] call CBA_fnc_createTrigger;
					CRM_Sound_Trigger_%1 = CRM_TriggerArray_%1 select 0;
					CRM_Sound_Trigger_%1 setSoundEffect [""NoSound"", """", """", ""nielsen_cim_crowd""];
				}, []] call CBA_fnc_globalExecute;
			",CRM_TirePile_Count,_pos];
			

			_pubVar = ["CRM_TirePile_Count", (CRM_TirePile_Count + 1)] call CBA_fnc_publicVariable;	
			_pubVar = ["CRM_Trigger_Count", (CRM_Trigger_Count + 1)] call CBA_fnc_publicVariable;	
			
			//Spawn civilians (the function runs the FSM on each unit)
			_spawnEvent = [_pos,_multiplier] call CRM_SpawnFnc_gathering;

			//Debug
			if (CRM_DebugMode) then {diag_log format ["CRM - Riot triggered. Civilians: %1",_Civilians];};
		};
		
		//Intel event
		case "intel":
		{
			//spawn a civilian to give intel	
			_spawnEvent = [_pos] call CRM_SpawnFnc_Intel;
			
			//Debug
			if (CRM_DebugMode) then {diag_log format ["CRM - Intel triggered. Civilian: %1",_newCiv];};
		};
		
		//Ambush event
		case "ambush":
		{
			//Gather nearby civs and put in list
			private ["_nearMen","_Civilians","_spawnEvent"];
			_Civilians = [];
			_nearMen = _pos nearEntities ["Man",200];
			for "_y" from 0 to (count _nearMen - 1) do {
				if (side (_nearMen select _y) == CIVILIAN && isNil {(_nearMen select _y) getVariable "reezo_ied_triggerman"} && isNil {(_nearMen select _y) getVariable "reezo_ied_trigger"}) then {
					_Civilians = _Civilians + [(_nearMen select _y)];					
				};
			};
			//Make all civilians flee inside
			if ((count _Civilians) > 0) then {
				{_x doFSM ["\nielsen_cim\fsm\nielsen_cim_getInside.fsm",getPos _x,_x];} forEach _Civilians;
			};

			//Spawn enemies (The spawn function executes the FSM!!)
			_spawnEvent = [_pos,_multiplier] call CRM_SpawnFnc_Ambush;
			
			//waitUntil {scriptDone {_spawnEvent}};
			//Execute(!) FSM to control ambush
			nul = [(_spawnEvent select 0),(_spawnEvent select 1),(_spawnEvent select 2)] ExecFSM "\nielsen_cim\fsm\nielsen_crm_ambush.fsm";

			//Debug
			if (CRM_DebugMode) then {diag_log format ["CRM - Ambush triggered. Civilian: %1",_civilians];};
		};
		
		//Massacre event
		case "massacre":
		{
			//Gather nearby civs and put in list
			private ["_nearMen","_civilians"];
			_Civilians = [];
			_nearMen = _pos nearEntities ["Man",200];
			for "_y" from 0 to (count _nearMen - 1) do {
				if (side (_nearMen select _y) == CIVILIAN && isNil {(_nearMen select _y) getVariable "reezo_ied_triggerman"} && isNil {(_nearMen select _y) getVariable "reezo_ied_trigger"}) then {
					_Civilians = _Civilians + [(_nearMen select _y)];					
				};
			};

			//Kill the civilians and create flies on all machines
			if ((count _Civilians) > 0) then {
				{_x setDamage 1; nul = [getPos _x] call bis_FNC_Flies;} forEach _Civilians;
			};
			//spawn dead civilians	
			_spawnEvent = [_pos,_multiplier] call CRM_SpawnFnc_Massacre;
			
			//Create local effects (sound for crying women) on clients with globalexecute
			call compile format ["
				[-2, {
					CRM_Massacre_TriggerPos_%1 = [%2 select 0, (%2 select 1), 0.5];
					CRM_Massacre_TriggerArray_%1 = [CRM_Massacre_TriggerPos_%1, ""AREA:"", [30, 30, 0, false], ""ACT:"", [""CIV"", ""PRESENT"", true], ""STATE:"", [""true"","""",""""]] call CBA_fnc_createTrigger;
					CRM_Massacre_Sound_Trigger_%1 = CRM_Massacre_TriggerArray_%1 select 0;
					CRM_Massacre_Sound_Trigger_%1 setSoundEffect [""NoSound"", """", """", ""nielsen_cim_crying""];
				}, []] call CBA_fnc_globalExecute;
			",CRM_Trigger_Count,_pos];
			
			_pubVar = ["CRM_Trigger_Count", CRM_Trigger_Count + 1] call CBA_fnc_publicVariable;	
			
			//Debug
			if (CRM_DebugMode) then {diag_log format ["CRM - Massacre triggered. Preexisting Civilian: %1",_newCiv];};
		};
	};
	sleep 0.5;	
};


				