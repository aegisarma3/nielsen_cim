///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_chopperSpawn.sqf:		///////////////////
///////////	It runs on server AND clients		///////////////////		
///////////	is executed by nielsen_cim_init.sqf.///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script spawns a blackhawh with	///////////////////
///////////	crew, and sets up waypoint for POW  ///////////////////
///////////	extraction. It creates a radio 'india'/////////////////
///////////	trigger to execvm choppercall.sqf	///////////////////
///////////	It ends with server loop, cleaning	///////////////////
///////////	up extracted civilians.				///////////////////
///////////////////////////////////////////////////////////////////


private ["_spawnPos","_unit","_helipad"];

// set spawn postition to "CIM marker", or set to module location
	
	//set chopper spawn point (If no marker is selected use location of module)
if (isNil {CIM_Module getVariable "nielsen_cim_marker"}) then
{
	_spawnPos = getPos CIM_Module;
} else {
	_spawnPos = getMarkerPos (CIM_Module getVariable "nielsen_cim_marker");
};

	//Create trigger to call for POW extraction on players only
//CIM_NewExtractPos = [];
if (!(isDedicated) OR ((isDedicated) and !(isServer))) then {
	CIM_Trigger1 = createTrigger ["EmptyDetector",getPos CIM_Module]; 
	CIM_Trigger1 setTriggerArea [0,0,0,true];
	CIM_Trigger1 setTriggerActivation["INDIA","PRESENT",true];
	CIM_Trigger1 setTriggerStatements["this", "null = [""CIM_ExtractPos"", getPos player] call CBA_fnc_publicVariable; null = [""CIM_GoCode"", true] call CBA_fnc_publicVariable; nul = [player] execVM ""\nielsen_cim\nielsen_cim_ChopperCall.sqf"";", ""];
	CIM_Trigger1 setTriggerText "Request POW extraction";
};

if (isServer) then {

	//Spawn chopper on invisible helipad
	_helipad = createVehicle ["HeliHEmpty", _spawnPos, [], 0, "NONE"];
	CIM_Chopper = createVehicle ["UH60M_EP1", _spawnPos, [], 0, "NONE"];
	
	//Spawn crew in chopper
	CIM_HeliGrp = createGroup west;
	_unit = CIM_HeliGrp createVehicle ["US_Soldier_Pilot_EP1", _spawnPos, [], 0, "NONE"]; 
	_unit moveInDriver CIM_Chopper;	
	_unit = CIM_HeliGrp createVehicle ["US_Soldier_Pilot_EP1", _spawnPos, [], 0, "NONE"]; 
	_unit moveInCargo [CIM_Chopper,12];	
	_unit = CIM_HeliGrp createVehicle ["US_Soldier_Crew_EP1", _spawnPos, [], 0, "NONE"]; 
	_unit MoveInTurret [CIM_Chopper,[0]];	
	_unit = CIM_HeliGrp createVehicle ["US_Soldier_Crew_EP1", _spawnPos, [], 0, "NONE"]; 
	_unit MoveInTurret [CIM_Chopper,[1]];	
	_unit = CIM_HeliGrp createVehicle ["US_Soldier_Crew_EP1", _spawnPos, [], 0, "NONE"]; 
	_unit MoveInCargo [CIM_Chopper,0];
	_unit = CIM_HeliGrp createVehicle ["US_Soldier_Crew_EP1", _spawnPos, [], 0, "NONE"]; 
	_unit MoveInCargo [CIM_Chopper,3];
	_unit = CIM_HeliGrp createVehicle ["US_Soldier_Crew_EP1", _spawnPos, [], 0, "NONE"]; 
	_unit MoveInCargo [CIM_Chopper,9];
	_unit = CIM_HeliGrp createVehicle ["US_Soldier_Crew_EP1", _spawnPos, [], 0, "NONE"]; 
	_unit MoveInCargo [CIM_Chopper,10];

	CIM_Chopper setbehaviour "careless";
	CIM_Chopper allowDamage false;
	
	//Give chopper waypoints
	CIM_HeliGrp addWaypoint [_spawnPos, 1];
	[CIM_HeliGrp, 1] setWaypointType "MOVE";
	[CIM_HeliGrp, 1] setWaypointBehaviour "CARELESS";
	[CIM_HeliGrp, 1] setWaypointCombatMode "GREEN";
	[CIM_HeliGrp, 1] setWaypointStatements ["(CIM_GoCode);", "CIM_ClearCivs = true; [CIM_HeliGrp, 2] setWaypointPosition [CIM_ExtractPos, 0]; [CIM_HeliGrp, 3] setWaypointPosition [CIM_ExtractPos, 0];"];
	
	CIM_HeliGrp addWaypoint [_spawnPos, 2];
	[CIM_HeliGrp, 2] setWaypointType "LOAD";
	[CIM_HeliGrp, 2] setWaypointStatements ["true", "CIM_Chopper land ""GET IN"";"];

	CIM_HeliGrp addWaypoint [_spawnPos, 3];
	[CIM_HeliGrp, 3] setWaypointType "MOVE";
	[CIM_HeliGrp, 3] setWaypointStatements ["CIM_AllClear;", "CIM_AllClear = false; CIM_GoCode = false;"];
	
	CIM_HeliGrp addWaypoint [_spawnPos, 4];
	[CIM_HeliGrp, 4] setWaypointType "MOVE";
	[CIM_HeliGrp, 4] setWaypointStatements ["true", "CIM_Chopper land ""LAND""; null = [""CIM_List_Extracted"", CIM_List_Extracted + CIM_ChopperList] call CBA_fnc_publicVariable;"];

	CIM_HeliGrp addWaypoint [_spawnPos, 5];
	[CIM_HeliGrp, 5] setWaypointType "CYCLE";
	[CIM_HeliGrp, 5] setWaypointStatements ["true", ""];

};

//Start loop on server to delete allredy extracted civs when recalled
if (isServer) then {
	private ["_CBApubVar"];
	while {true} do {
		waitUntil {CIM_ClearCivs};
		
		//Debug
		if (CIM_DebugMode) then {diag_log format ["CIM_Chopper is en route. Deleting civilians: %1, CIM_Arrested_List is %2",CIM_ChopperList,CIM_List_Arrested];};
		
		{
			doGetOut _x; 
			waitUntil {vehicle _x == _x}; 
			deleteVehicle _x;
		} forEach CIM_ChopperList; 
		//PubVar empty chopperlist
		_CBApubVar = ["CIM_ChopperList", []] call CBA_fnc_publicVariable;
		CIM_ClearCivs = false;
		
		sleep 2;
	
	};
};