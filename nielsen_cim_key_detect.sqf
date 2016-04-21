

//Add eventhandlers to check if the CIM key is pressed
waitUntil {time > 1};
nul = findDisplay 46 displayAddEventHandler ["KeyDown", "if (_this select 1==CIM_Key) then {cim_key_pressed = true;};"];
nul = findDisplay 46 displayAddEventHandler ["KeyUp", "if (_this select 1==CIM_Key) then {cim_key_pressed = false;};"];

//Debug msg
if (CIM_DebugMode) then {diag_log format ["key_detect-sqf running. CIM_Key is %1",CIM_Key];};
