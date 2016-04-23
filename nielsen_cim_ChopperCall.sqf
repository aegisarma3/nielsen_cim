///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cim_chopperCall.sqf:		///////////////////
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

CIM_NewChopperList = [];

CIM_Trigger2 = createTrigger ["EmptyDetector", getPos _soldier];
CIM_Trigger2 setTriggerActivation ["JULIET", "PRESENT", false];
CIM_Trigger2 setTriggerStatements ["this", "null = [""CIM_allClear"", true] call CBA_fnc_publicVariable; deleteVehicle CIM_Trigger2; {if (_x in CIM_Chopper) then {CIM_ChopperList = CIM_ChopperList + [_x];}} forEach CIM_List_Arrested; CIM_newChopperList = CIM_Chopperlist; null = [""CIM_ChopperList"", CIM_newChopperList] call CBA_fnc_publicVariable; null = [""CIM_List_Arrested"", CIM_List_Arrested - CIM_ChopperList] call CBA_fnc_publicVariable; {[_x] joinSilent CIM_Chopper} forEach CIM_ChopperList; deleteMarker ""CIM_ExtractMarker""; null = [""CIM_ExtractPos"", [0,0,0]] call CBA_fnc_publicVariable; ", ""];
CIM_Trigger2 setTriggerText "Give all clear";

CIM_ExtractMarker = createMarker ["CIM_ExtractMarker", getPos _soldier];
"CIM_ExtractMarker" setMarkerShape "ICON";
"CIM_ExtractMarker" setMarkerType "hd_pickup";
"CIM_ExtractMarker" setMarkerColor "ColorBlue";
"CIM_ExtractMarker" setMarkerText "POW Exfil LZ";

if !(CIM_Module getVariable "nielsen_cim_disableAUDIO") then {

	//Play radiochatter audio
	[_soldier, "nielsen_cim_radiochatter"] call CBA_fnc_globalSay3d;

	//Display radio
	(leader _soldier) sidechat format["Carebear-1 this is %1.",name leader _soldier];
	sleep 2;
	CIM_Chopper sidechat format["%1 this is Carebear-1 Go ahead, over.",name leader _soldier];
	sleep 3;
	(leader _soldier) sidechat format ["We've detained som civilians. Requesting POW extraction at coordinates %1, over.",mapGridPosition (leader _soldier)];
	sleep 4;
	CIM_Chopper sidechat format["Copy that %1. We are en route, out.",name leader _soldier];
};

hint "POW transport is inbound. Mark the desired LZ with smoke when the chopper arrives.";
