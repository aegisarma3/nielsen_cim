///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cRm_init.sqf:				///////////////////
///////////	This script initializes the reaction///////////////////
///////////	module. Gets and sets variables etc.///////////////////
///////////////////////////////////////////////////////////////////

waitUntil {(isDedicated) || !(isNull player)};

//get setvariables from module or set default

	if (isNil {_this getVariable "nielsen_crm_events_chance"}) then
	{
		_this setVariable ["nielsen_crm_events_chance", 0.3];
	};
	if (isNil {_this getVariable "nielsen_crm_events_range"}) then
	{
		_this setVariable ["nielsen_crm_events_range", 500];
	};
	if (isNil {_this getVariable "nielsen_crm_events"}) then
	{
		_this setVariable ["nielsen_crm_events", ["gathering","intel","ambush","massacre"]];
	};
	if (isNil {_this getVariable "nielsen_crm_multiplier"}) then
	{
		_this setVariable ["nielsen_crm_multiplier", 1];
	};

	if (isNil {_this getVariable "nielsen_crm_evidence"}) then
	{
		_this setVariable ["nielsen_crm_evidence", true];
	};
	if (isNil {_this getVariable "nielsen_crm_evidence_chance"}) then
	{
		_this setVariable ["nielsen_crm_evidence_chance", 0.3];
	};
	if (isNil {_this getVariable "nielsen_crm_evidence_time"}) then
	{
		_this setVariable ["nielsen_crm_evidence_time", 120];
	};
	if (isNil {_this getVariable "nielsen_crm_civilians"}) then
	{
		_this setVariable ["nielsen_crm_civilians", ["C_man_1","C_man_polo_2_F","C_man_polo_5_F","C_man_polo_6_F","C_man_1_3_F","C_man_p_fugitive_F","C_man_polo_4_F"]];
	};





//Init variables
CRM_Module = _this;
CRM_SyncUnits = synchronizedObjects _this;
CRM_Side = side (CRM_SyncUnits select 0);
	//Find enemy side
if (CRM_side == east) then {CRM_EnemySide = west} else {CRM_EnemySide = east};

	//Set players
if (isServer) then {
	CRM_Players = playableUnits;
} else {
	CRM_Players = [player];
};
CRM_NewCivilians = [];
CRM_newEvent = [false];
CRM_DebugMode = true;
CRM_Trigger_count = 0;
CRM_TirePile_count = 0;
cim_animation = [false];



//variables for intel
CRM_Intel_Found = 0;
CRM_newIntel = [false,objNull];

//make array with name of all groups synced with module
CRM_AllGroups = [];
{CRM_AllGroups = CRM_AllGroups + [group _x];} forEach CRM_SyncUnits;

//Launch serverside control sripts
if (isServer) then {
	nul = [] execVM "\nielsen_cim\nielsen_crm_events_Server.sqf";

	nul = [] execVM "\nielsen_cim\nielsen_crm_CheckLocation_Server.sqf";

	if (CRM_Module getVariable "nielsen_crm_evidence") then {
		nul = [] execVM "\nielsen_cim\nielsen_crm_evidence_Server.sqf";
	};
};

//Launch clientside intel script
if (!(isDedicated) OR ((isDedicated) and !(isServer))) then {
	nul = [] execVM "\nielsen_cim\nielsen_crm_intel_Client.sqf";
};

[West] call CBA_fnc_createCenter;
[civilian] call CBA_fnc_createCenter;
[east] call CBA_fnc_createCenter;

//Initialize BIS function for making smoke
BIS_Effects_Burn = compile preprocessFile "\ca\Data\ParticleEffects\SCRIPTS\destruction\burn.sqf";

//Compile spawn functions
CRM_SpawnFnc_Gathering = compile preprocessFile "\nielsen_cim\functions\nielsen_fnc_spawn_gathering.sqf";
CRM_SpawnFnc_Intel = compile preprocessFile "\nielsen_cim\functions\nielsen_fnc_spawn_intel.sqf";
CRM_SpawnFnc_ambush = compile preprocessFile "\nielsen_cim\functions\nielsen_fnc_spawn_ambush.sqf";
CRM_SpawnFnc_Massacre = compile preprocessFile "\nielsen_cim\functions\nielsen_fnc_spawn_massacre.sqf";
