///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Extraction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cem_chopperSpawn.sqf:		///////////////////
///////////	It runs on server AND clients		///////////////////		
///////////	is executed by nielsen_cem_init.sqf.///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script spawns a blackhawh with	///////////////////
///////////	crew, and sets up waypoint for POW  ///////////////////
///////////	extraction. 						/////////////////
///////////										///////////////////
///////////	It ends with server loop, cleaning	///////////////////
///////////	up extracted civilians.				///////////////////
///////////////////////////////////////////////////////////////////

//Make sure NO CLIENTS run the script
if !(isServer) exitWith {};

//Debug
if (CEM_DebugMode) then {diag_log format ["CEM - Spawning chopper - side %1.",CEM_Side];};

/////////////////////////////////////////////
//////-------Get Spawn point-------////////////	
//If no marker is selected use location of module//
private ["_spawnPos"];
if (isNil {CEM_Module getVariable "nielsen_CEM_marker"}) then
{
	_spawnPos = getPos CEM_Module;
} else {
	_spawnPos = getMarkerPos (CEM_Module getVariable "nielsen_CEM_marker");
};

/////////////////////////////////////////////
//////-------Get Variables-------////////////
//Setup variables to spawn the correct stuff//
private ["_chopperType","_crewType","_crewPos","_gunners","_heliPad","_unit"];
if (isNil {CEM_Module getVariable "nielsen_CEM_ChopperType"}) then {
	switch (CEM_Side) do {
		//WEST
		case west: {

			_chopperType = "UH60M_EP1";
			_crewType = ["US_Soldier_Pilot_EP1","US_Soldier_Crew_EP1"];
			_crewPos = [12,0,3,9,10];
			_gunners = true;

		};
		//EAST
		case east: {

			_chopperType = "Mi17_TK_EP1";
			_crewType = ["RU_Soldier_Pilot","RU_Soldier_Crew"];
			_crewPos = [0,13,1,2,5];
			_gunners = true;
	
		};
		//RESISTANCE
		case resistance: {

			_chopperType = "Ka60_PMC";
			_crewType = ["UN_CDF_Soldier_Pilot_EP1","UN_CDF_Soldier_Crew_EP1"];
			_crewPos = [0,1,3,5];
			_gunners = false;

		};
	};
} else {
	_chopperType = CEM_Module getVariable "nielsen_CEM_ChopperType";
	_crewType = CEM_Module getVariable "nielsen_CEM_CrewType";
	_crewPos = CEM_Module getVariable "nielsen_CEM_CrewPos";
	_gunners = CEM_Module getVariable "nielsen_CEM_turrets";
};

/////////////////////////////////////////////
//////-------Spawn chopper-------////////////
//Spawn chopper on invisible helipad
_helipad = createVehicle ["HeliHEmpty", _spawnPos, [], 0, "NONE"];
CEM_Chopper = createVehicle [_chopperType, _spawnPos, [], 0, "NONE"];
//Spawn crew in chopper
CEM_HeliGrp = createGroup CEM_Side;
	//Pilot
_unit = CEM_HeliGrp createUnit [(_crewType select 0), _spawnPos, [], 0, "NONE"]; 
_unit moveInDriver CEM_Chopper;	
	//Co-pilot
_unit = CEM_HeliGrp createUnit [(_crewType select 0), _spawnPos, [], 0, "NONE"]; 
_unit moveInCargo [CEM_Chopper,(_crewPos select 0)];
	//Crew
for "_y" from 1 to (count _crewPos - 1) do {	
	_unit = CEM_HeliGrp createUnit [(_crewType select 1), _spawnPos, [], 0, "NONE"]; 
	_unit moveInCargo [CEM_Chopper,(_crewPos select _y)];	
};
	//Gunners?
if (_gunners) then {
	_unit = CEM_HeliGrp createUnit [(_crewType select 1), _spawnPos, [], 0, "NONE"]; 
	_unit MoveInTurret [CEM_Chopper,[0]];	
	_unit = CEM_HeliGrp createUnit [(_crewType select 1), _spawnPos, [], 0, "NONE"]; 
	_unit MoveInTurret [CEM_Chopper,[1]];	
};

/////////////////////////////////////////////
//////-------Setup Waypoints-------//////////
//Setup the choppers waypoints/behavior//////
CEM_Chopper setbehaviour "careless";
CEM_Chopper allowDamage false;

	//Give chopper waypoints
CEM_HeliGrp addWaypoint [_spawnPos, 1];
[CEM_HeliGrp, 1] setWaypointType "MOVE";
[CEM_HeliGrp, 1] setWaypointBehaviour "CARELESS";
[CEM_HeliGrp, 1] setWaypointCombatMode "GREEN";
[CEM_HeliGrp, 1] setWaypointStatements ["(CEM_GoCode);", "CEM_ClearCivs = true; [CEM_HeliGrp, 2] setWaypointPosition [CEM_ExtractPos, 0]; [CEM_HeliGrp, 3] setWaypointPosition [CEM_ExtractPos, 0];"];

CEM_HeliGrp addWaypoint [_spawnPos, 2];
[CEM_HeliGrp, 2] setWaypointType "LOAD";
[CEM_HeliGrp, 2] setWaypointStatements ["true", "CEM_Chopper land ""GET IN"";"];

CEM_HeliGrp addWaypoint [_spawnPos, 3];
[CEM_HeliGrp, 3] setWaypointType "MOVE";
[CEM_HeliGrp, 3] setWaypointStatements ["CEM_AllClear;", "CEM_AllClear = false; CEM_GoCode = false;"];

CEM_HeliGrp addWaypoint [_spawnPos, 4];
[CEM_HeliGrp, 4] setWaypointType "MOVE";
[CEM_HeliGrp, 4] setWaypointStatements ["true", "CEM_Chopper land ""LAND""; null = [""CEM_List_Extracted"", CEM_List_Extracted + CEM_ChopperList] call CBA_fnc_publicVariable;"];

CEM_HeliGrp addWaypoint [_spawnPos, 5];
[CEM_HeliGrp, 5] setWaypointType "CYCLE";
[CEM_HeliGrp, 5] setWaypointStatements ["true", ""];


/////////////////////////////////////////////
/////////-------Start Loop-------////////////
//Start loop on server to delete allredy extracted civs when recalled
private ["_CBApubVar"];
while {true} do {
	waitUntil {CEM_ClearCivs};
	
	//Debug
	if (CEM_DebugMode) then {diag_log format ["CEM_Chopper is en route. Deleting civilians: %1, CIM_Arrested_List is %2",CEM_ChopperList,CIM_List_Arrested];};
	
	{
		doGetOut _x; 
		waitUntil {vehicle _x == _x}; 
		deleteVehicle _x;
	} forEach CEM_ChopperList; 
	//PubVar empty chopperlist
	_CBApubVar = ["CEM_ChopperList", []] call CBA_fnc_publicVariable;
	CEM_ClearCivs = false;
	
	sleep 2;
};
