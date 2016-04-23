///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cim_addactions.sqf:			///////////////////
///////////	Executed by nielsen_cim_init.sqf.	///////////////////
///////////	This script adds the initial actions///////////////////
///////////	to the players.						///////////////////
///////////////////////////////////////////////////////////////////
if (CIM_DebugMode) then {diag_log format ["addactions - cim_list_keycuff: %1, newCuff is %2",CIM_List_KeyCuff,CIM_NewunCuff];};

private ["_soldier"];
_soldier = _this select 0;

cim_action_getDown1 = [['<t color="#FF0000">'+"Verbal Command: Get down!"+'</t>', "\nielsen_cim\nielsen_cim_getDown_Client.sqf", [_soldier,false,cursorTarget], 10, false, true, CIM_Module getVariable "nielsen_cim_key_getDown","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (cursorTarget isKindof ""MAN"") AND (cursorTarget distance player > 2)"]] call CBA_fnc_addPlayerAction;
cim_action_getDownAll = [['<t color="#FF0000">'+"Verbal Command: Get down!"+'</t>', "\nielsen_cim\nielsen_cim_getDown_Client.sqf", [_soldier,true], 10, false, true, CIM_Module getVariable "nielsen_cim_key_getDown","cim_key_pressed AND !((cursorTarget isKindof ""MAN"") AND (side cursorTarget == CIVILIAN))"]] call CBA_fnc_addPlayerAction;

cim_action_getAway1 = [['<t color="#FF0000">'+"Verbal Command: Clear area!"+'</t>', "\nielsen_cim\nielsen_cim_getAway_Client.sqf", [_soldier,false,cursorTarget], 9, false, true, CIM_Module getVariable "nielsen_cim_key_getAway","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (cursorTarget isKindof ""MAN"") AND (cursorTarget distance player > 2)"]] call CBA_fnc_addPlayerAction;
cim_action_getAwayAll = [['<t color="#FF0000">'+"Verbal Command: Clear area!"+'</t>', "\nielsen_cim\nielsen_cim_getAway_Client.sqf", [_soldier,true], 9, false, true, CIM_Module getVariable "nielsen_cim_key_getAway","cim_key_pressed AND !((cursorTarget isKindof ""MAN"") AND (side cursorTarget == CIVILIAN))"]] call CBA_fnc_addPlayerAction;

cim_action_getInside1 = [['<t color="#FF0000">'+"Verbal Command: Get inside!"+'</t>', "\nielsen_cim\nielsen_cim_getInside_Client.sqf", [_soldier,false,cursorTarget], 8, false, true, CIM_Module getVariable "nielsen_cim_key_getInside","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (cursorTarget isKindof ""MAN"") AND (cursorTarget distance player > 2)"]] call CBA_fnc_addPlayerAction;
cim_action_getInsideAll = [['<t color="#FF0000">'+"Verbal Command: Get inside!"+'</t>', "\nielsen_cim\nielsen_cim_getInside_Client.sqf", [_soldier,true], 8, false, true, CIM_Module getVariable "nielsen_cim_key_getInside","cim_key_pressed AND !((cursorTarget isKindof ""MAN"") AND (side cursorTarget == CIVILIAN))"]] call CBA_fnc_addPlayerAction;

cim_action_StopCar = [['<t color="#FF0000">'+"Verbal Command: Get out of the car!"+'</t>', "\nielsen_cim\nielsen_cim_stopCar_Client.sqf", [_soldier], 7, false, true, CIM_Module getVariable "nielsen_cim_key_stopCar","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (cursorTarget isKindof ""CAR"") AND (cursorTarget distance player <= 75);"]] call CBA_fnc_addPlayerAction;

cim_action_Search = [['<t color="#FF0000">'+"Search individual!"+'</t>', "\nielsen_cim\nielsen_cim_search_Client.sqf", [_soldier], 10, false, true, CIM_Module getVariable "nielsen_cim_key_Search","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (alive cursorTarget) AND (cursorTarget distance player <= 2) AND (cursorTarget isKindof ""MAN"") AND !(cursorTarget in CIM_List_Searched)"]] call CBA_fnc_addPlayerAction;
cim_action_Disarm = [['<t color="#FF0000">'+"Remove Belongings!"+'</t>', "\nielsen_cim\nielsen_cim_disarm_Client.sqf", [_soldier], 10, false, true, CIM_Module getVariable "nielsen_cim_key_Search","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (alive cursorTarget) AND (cursorTarget distance player <= 2) AND (cursorTarget isKindof ""MAN"") AND (cursorTarget in CIM_List_Searched)"]] call CBA_fnc_addPlayerAction;

	//Add action depending on if ACE is set enabled
/*if (CIM_Module getVariable "nielsen_cim_enableACE") then {
	cim_action_Pacify = [['<t color="#FF0000">'+"Key-cuff individual!"+'</t>', "\nielsen_cim\nielsen_cim_Pacify_Client.sqf", [_soldier], 9, false, true, CIM_Module getVariable "nielsen_cim_key_Pacify","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (alive cursorTarget) AND (cursorTarget distance player <= 2) AND (cursorTarget isKindof ""MAN"") AND !(cursorTarget in CIM_List_Keycuff) AND (_target hasWeapon ""ACE_KeyCuffs"")"]] call CBA_fnc_addPlayerAction;
} else {
	cim_action_Pacify = [['<t color="#FF0000">'+"Key-cuff individual!"+'</t>', "\nielsen_cim\nielsen_cim_Pacify_Client.sqf", [_soldier], 9, false, true, CIM_Module getVariable "nielsen_cim_key_Pacify","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (alive cursorTarget) AND (cursorTarget distance player <= 2) AND (cursorTarget isKindof ""MAN"") AND !(cursorTarget in CIM_List_Keycuff)"]] call CBA_fnc_addPlayerAction;
};*/
cim_action_Pacify = [['<t color="#FF0000">'+"Key-cuff individual!"+'</t>', "\nielsen_cim\nielsen_cim_Pacify_Client.sqf", [_soldier], 9, false, true, CIM_Module getVariable "nielsen_cim_key_Pacify","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (alive cursorTarget) AND (cursorTarget distance player <= 2) AND (cursorTarget isKindof ""MAN"") AND !(cursorTarget in CIM_List_Keycuff) AND (""ACE_CableTie"" in items _target)"]] call CBA_fnc_addPlayerAction;

cim_action_Arrest = [['<t color="#FF0000">'+"Detain individual!"+'</t>', "\nielsen_cim\nielsen_cim_arrest_Client.sqf", [_soldier], 8, false, true, CIM_Module getVariable "nielsen_cim_key_Arrest","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (alive cursorTarget) AND (cursorTarget distance player <= 2) AND (group cursorTarget != group _target) AND (cursorTarget isKindof ""MAN"")"]] call CBA_fnc_addPlayerAction;

cim_action_release = [['<t color="#FF0000">'+"Release individual!"+'</t>', "\nielsen_cim\nielsen_cim_release_Client.sqf", [_soldier], 8, false, true, CIM_Module getVariable "nielsen_cim_key_release","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (alive cursorTarget) AND (cursorTarget distance player <= 2) AND (group cursorTarget == group _target) AND (cursorTarget isKindof ""MAN"")"]] call CBA_fnc_addPlayerAction;

cim_action_uncuff = [['<t color="#FF0000">'+"Uncuff individual!"+'</t>', "\nielsen_cim\nielsen_cim_uncuff_Client.sqf", [_soldier], 9, false, true, CIM_Module getVariable "nielsen_cim_key_release","cim_key_pressed AND (side cursorTarget == CIVILIAN) AND (alive cursorTarget) AND (cursorTarget distance player <= 2) AND (cursorTarget in CIM_List_KeyCuff) AND (cursorTarget isKindof ""MAN"")"]] call CBA_fnc_addPlayerAction;
