///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Extraction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cem_chopperCall.sqf:		///////////////////
///////////										///////////////////
///////////	Activated by radio 'india'.			///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script creates a trigger to	///////////////////
///////////	give extration chopper 'All clear'.	///////////////////
///////////	It also creates an extraction marker///////////////////
///////////	and plays sound and radio when act.	///////////////////
///////////////////////////////////////////////////////////////////


private ["_soldier"];
_soldier = _this select 0;

CEM_NewChopperList = [];

CEM_Trigger2 = createTrigger ["EmptyDetector", getPos _soldier];
CEM_Trigger2 setTriggerActivation ["JULIET", "PRESENT", false];
CEM_Trigger2 setTriggerStatements ["this", "null = [""CEM_allClear"", true] call CBA_fnc_publicVariable; deleteVehicle CEM_Trigger2; {if (_x in CEM_Chopper) then {CEM_ChopperList = CEM_ChopperList + [_x];}} forEach CIM_List_Arrested; CEM_newChopperList = CEM_Chopperlist; null = [""CEM_ChopperList"", CEM_newChopperList] call CBA_fnc_publicVariable; null = [""CIM_List_Arrested"", CIM_List_Arrested - CEM_ChopperList] call CBA_fnc_publicVariable; {[_x] joinSilent CEM_Chopper} forEach CEM_ChopperList; deleteMarker ""CEM_ExtractMarker""; null = [""CEM_ExtractPos"", [0,0,0]] call CBA_fnc_publicVariable; ", ""];
CEM_Trigger2 setTriggerText "Give all clear";

CEM_ExtractMarker = createMarker ["CEM_ExtractMarker", getPos _soldier];
"CEM_ExtractMarker" setMarkerShape "ICON";
"CEM_ExtractMarker" setMarkerType "hd_pickup";
"CEM_ExtractMarker" setMarkerColor "ColorBlue";
"CEM_ExtractMarker" setMarkerText "POW Exfil LZ";

if !(CEM_Module getVariable "nielsen_CEM_disableAUDIO") then {

	//Play radiochatter audio
	[_soldier, "nielsen_CIM_radiochatter"] call CBA_fnc_globalSay3d;

	//Display radio
	(leader _soldier) sidechat format["Carebear-1 this is %1.",name leader _soldier];
	sleep 2;
	CEM_Chopper sidechat format["%1 this is Carebear-1 Go ahead, over.",name leader _soldier];
	sleep 3;
	(leader _soldier) sidechat format ["We've detained som civilians. Requesting POW extraction at coordinates %1, over.",mapGridPosition (leader _soldier)];
	sleep 4;
	CEM_Chopper sidechat format["Copy that %1. We are en route, out.",name leader _soldier];
};

hint "POW transport is inbound. Mark the desired LZ with smoke when the chopper arrives.";
