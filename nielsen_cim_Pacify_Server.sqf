///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_pacify_server.sqf:		///////////////////
///////////	Executed by nielsen_cim_init.sqf	///////////////////		
///////////	called by nielsen_cim_pacify_client ///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script collects info from		///////////////////
///////////	clients, and forces the civilian	///////////////////
///////////	into a keycuffed looping animation.	///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CIM_DebugMode) then {diag_log "nielsen_cim_pacify_Server.sqf is running.";};

private ["_cim_serverFnc","_broadcastedAnim","_broadcastedInfo"];
_cim_serverFnc = {
	
	//What should the civilian do?
	private ["_thisMan","_newAnim","_animations","_list_Keycuff"];
	_thisMan = _this select 0;
	doStop _thisman;
	_thisman setCaptive true;
	_animations = ["ActsPsitMstpSnonWunaDnon_sceneNikitinDisloyalty_Cooper","ActsPsitMstpSnonWunaDnon_sceneNikitinDisloyalty_Sykes","ActsPsitMstpSnonWunaDnon_sceneNikitinDisloyalty_Rodriguez","ActsPsitMstpSnonWunaDnon_sceneNikitinDisloyalty_Ohara"];
	_newAnim = _animations select (round (random ((count _animations) - 1)));
	//_thisman switchMove _newAnim; 
	
	//Broadcast animation
	_broadcastedInfo = ["cim_animation", [true,_thisman,_newAnim]] call CBA_fnc_publicVariable;

	
	//pubvar
	_List_Keycuff = CIM_List_Keycuff + [_thisman];
	_broadcasted = ["CIM_List_Keycuff", _List_Keycuff] call CBA_fnc_publicVariable;

	_thisman disableAI "ANIM";
	_thisman disableAI "MOVE";
};

while {true} do {
	waitUntil {CIM_Pacify};
	
	[CIM_NewPacify] call _cim_serverFnc;
	
	//Debug
	if (CIM_DebugMode) then {diag_log format ["Server calling Pacify function on civilian %1",CIM_NewPacify];};
	
	_broadcasted = ["CIM_Pacify", false] call CBA_fnc_publicVariable;
	sleep 0.5;
	
};
