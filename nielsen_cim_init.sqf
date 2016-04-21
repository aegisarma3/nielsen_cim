///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_init.sqf:				///////////////////
///////////	This script initializes the module	///////////////////
///////////	Gets and sets variables etc.		///////////////////
///////////////////////////////////////////////////////////////////

waitUntil {(isDedicated) || !(isNull player)};

//get setvariables from module or set default
	
	if (isNil {_this getVariable "nielsen_cim_authority"}) then
	{
		_this setVariable ["nielsen_cim_authority", 0.9];
	};
	
	if (isNil {_this getVariable "nielsen_cim_enableACE"}) then
	{
		_this setVariable ["nielsen_cim_enableACE", false];
	};
	
	if (isNil {_this getVariable "nielsen_cim_disableAUDIO"}) then
	{
		_this setVariable ["nielsen_cim_disableAUDIO", false];
	};

	if (isNil {_this getVariable "nielsen_cim_DebugMode"}) then
	{
		_this setVariable ["nielsen_cim_DebugMode", true];
	};
	
	if (isNil {_this getVariable "nielsen_cim_key"}) then
	{
		_this setVariable ["nielsen_cim_key", 42]; //42 = shift key
	};


	//get keystrokes for commands or set default (accepts entries from CfgDefaultKeysMapping)
	// See list at http://community.bistudio.com/wiki/ArmA_2:_CfgDefaultKeysMapping
	if (isNil {_this getVariable "nielsen_cim_key_GetDown"}) then
	{
		_this setVariable ["nielsen_cim_key_GetDown", ""];
	};
	
	if (isNil {_this getVariable "nielsen_cim_key_getAway"}) then
	{
		_this setVariable ["nielsen_cim_key_getAway", ""];
	};
	
	if (isNil {_this getVariable "nielsen_cim_key_getInside"}) then
	{
		_this setVariable ["nielsen_cim_key_getInside", ""];
	};

	if (isNil {_this getVariable "nielsen_cim_key_stopCar"}) then
	{
		_this setVariable ["nielsen_cim_key_stopCar", ""];
	};
	
	if (isNil {_this getVariable "nielsen_cim_key_Arrest"}) then
	{
		_this setVariable ["nielsen_cim_key_Arrest", ""];
	};
	
	if (isNil {_this getVariable "nielsen_cim_key_Pacify"}) then
	{
		_this setVariable ["nielsen_cim_key_Pacify", ""];
	};
	if (isNil {_this getVariable "nielsen_cim_key_search"}) then
	{
		_this setVariable ["nielsen_cim_key_search", ""];
	};
	if (isNil {_this getVariable "nielsen_cim_key_release"}) then
	{
		_this setVariable ["nielsen_cim_key_release", ""];
	};


//Variable lists	
CIM_List_Keycuff = [];
CIM_List_Arrested = [];
CIM_List_Searched = [];
CIM_List_Disarmed = [];

//Set fixed variables
if (isNil "CIM_Key") then {CIM_Key = _this getVariable "nielsen_cim_key";};
cim_key_pressed = false;
CIM_Module = _this;
CIM_Arrest = false;
CIM_Pacify = false;
CIM_stopCar = false;
CIM_carCrew = [];
CIM_Disarm = [false];
CIM_NewCivilians = [];
CIM_AwayCivilians = [];
CIM_WarnCiv = false;
CIM_GetOutCiv = false;
CIM_getInside = false;
CIM_InsideCivilians = [];
CIM_release = false;
CIM_unCuff = false;
cim_animation = [false];


//create hold group for released civilians
if (isServer) then {
	CIM_holdGrp = createGroup civilian;
	[CIM_holdGrp, 0] setWaypointType "DISMISS";
};

//Start server scripts to handle actions
if (isServer) then {
	nul = [] execVM "\nielsen_cim\nielsen_cim_Arrest_Server.sqf";
	nul = [] execVM "\nielsen_cim\nielsen_cim_stopCar_Server.sqf";
	nul = [] execVM "\nielsen_cim\nielsen_cim_Pacify_Server.sqf";
	nul = [] execVM "\nielsen_cim\nielsen_cim_getDown_Server.sqf";
	nul = [] execVM "\nielsen_cim\nielsen_cim_getAway_Server.sqf";
	nul = [] execVM "\nielsen_cim\nielsen_cim_getInside_Server.sqf";
	nul = [] execVM "\nielsen_cim\nielsen_cim_release_Server.sqf";
	nul = [] execVM "\nielsen_cim\nielsen_cim_unCuff_Server.sqf";
	nul = [] execVM "\nielsen_cim\nielsen_cim_disarm_Server.sqf";
};

//CLIENT-SIDE: run addaction script and add eventhandler to check for CIM-Key
if (!(isDedicated) OR ((isDedicated) and !(isServer))) then {
	nul = [player] execVM "\nielsen_cim\nielsen_cim_addActions.sqf";
	
	//run script to add displayeventhandler for detecting cim_key
	if (isNil "CIM_Detecting") then {
		nul = [] execVM "\nielsen_cim\nielsen_cim_key_detect.sqf";
		CIM_Detecting = true;
	};

};

//Show debug settings?
CIM_DebugMode = CIM_Module getVariable "nielsen_cim_DebugMode";


//Compile script by Shuko to find positions
SHK_pos = compile (preprocessFileLineNumbers "\nielsen_cim\SHK_pos.sqf");

//Run script on all clients to show pacify animation when needed
if (!(isDedicated) OR ((isDedicated) and !(isServer))) then {
	nul = [] execVM "\nielsen_cim\nielsen_cim_animation_client.sqf";
};
