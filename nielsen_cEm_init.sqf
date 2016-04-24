///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Extraction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cEm_init.sqf:				///////////////////
///////////	This script initializes the module	///////////////////
///////////	Gets and sets variables etc.		///////////////////
///////////////////////////////////////////////////////////////////

waitUntil {(isDedicated) || !(isNull player)};

//get setvariables from module or set default

	if (isNil {_this getVariable "nielsen_CEM_disableAUDIO"}) then
	{
		_this setVariable ["nielsen_CEM_disableAUDIO", false];
	};

	if (isNil {_this getVariable "nielsen_CEM_disableSmoke"}) then
	{
		_this setVariable ["nielsen_CEM_disableSmoke", false];
	};

	if (isNil {_this getVariable "nielsen_CEM_SmokeType"}) then
	{
		_this setVariable ["nielsen_CEM_SmokeType", ["SmokeShellOrange"]];
	};
	if (isNil {_this getVariable "nielsen_CEM_DebugMode"}) then
	{
		_this setVariable ["nielsen_CEM_DebugMode", true];
	};
	if (isNil {_this getVariable "nielsen_CIM_key"}) then
	{
		_this setVariable ["nielsen_CIM_key", 42]; //42 = shift key
	};


//Mission maker Variable lists
CEM_List_Extracted = [];

//Set CIM_Key if not allready set by CIM_init.
if (isNil "CIM_Key") then {CIM_Key = _this getVariable "nielsen_CIM_key";};

//Set module and player variables
CIM_key_pressed = false;
CEM_Module = _this;
CEM_SyncUnits = synchronizedObjects _this;
CEM_Side = side (CEM_SyncUnits select 0);

//Setup basics vars
CEM_GoCode = false;
CEM_allClear = false;
CEM_ExtractPos = [0,0,0];

//START THE CHOPPER SCRIPT
nul = [] execVM "\nielsen_cim\nielsen_cEm_ChopperSpawn.sqf";

//add eventhandler to check for smoke if player and allowed
if !(CEM_Module getVariable "nielsen_CEM_disableSmoke") then {

	//Compile the checksmoke script
	nielsen_CEM_checkSmokeFnc = compile (preprocessFileLineNumbers "\nielsen_cim\nielsen_CEM_CheckSmoke.sqf");

	//Add eventhandler to detect if smoke is thrown
	if (!(isDedicated) OR ((isDedicated) and !(isServer))) then {
		player addEventHandler ["Fired", "_this spawn nielsen_CEM_checkSmokeFnc;"];
	};
};

	//run script to detec CIM_Key only if CIM_Module is not placed
if ((!(isDedicated) OR ((isDedicated) and !(isServer))) AND (isNil "CIM_Detecting")) then {
	nul = [] execVM "\nielsen_cim\nielsen_CIM_key_detect.sqf";
	CIM_Detecting = true;
};

	//ONLY CLIENT
	//Create trigger to call for extraction on players only
if (!(isDedicated) OR ((isDedicated) and !(isServer))) then {
	CEM_Trigger1 = createTrigger ["EmptyDetector",getPos CEM_Module];
	CEM_Trigger1 setTriggerArea [0,0,0,true];
	CEM_Trigger1 setTriggerActivation["JULIET","PRESENT",true];
	CEM_Trigger1 setTriggerStatements["this", "null = [""CEM_ExtractPos"", getPos player] call CBA_fnc_publicVariable; null = [""CEM_GoCode"", true] call CBA_fnc_publicVariable; nul = [player] execVM ""\nielsen_cim\nielsen_CEM_ChopperCall.sqf"";", ""];
	CEM_Trigger1 setTriggerText "Request POW extraction";
};

_condition = {
    [_player, _target, []] call ace_common_fnc_canInteractWith
};
_statement = {
		null = ["CEM_ExtractPos", getPos player] call CBA_fnc_publicVariable;
		null = ["CEM_GoCode", true] call CBA_fnc_publicVariable;
		nul = [player] execVM "\nielsen_cim\nielsen_CEM_ChopperCall.sqf";
};

_action = ["Call_extract1"," Request extraction","\nielsen_cim\radio_extract.paa",_statement,_condition] call ace_interact_menu_fnc_createAction;
[(typeOf player), 1, ["ACE_SelfActions","ACE_Equipment"], _action] call ace_interact_menu_fnc_addActionToClass;




//Show debug settings?
CEM_DebugMode = CEM_Module getVariable "nielsen_CEM_DebugMode";
//onMapSingleClick "player setpos _pos";
