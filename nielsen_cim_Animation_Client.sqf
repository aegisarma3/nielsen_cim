///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_arrest_client.sqf:		///////////////////
///////////	Executed by action menu on civilian.///////////////////		
///////////	This script collects info about the ///////////////////
///////////	targeted civilian and passes it		///////////////////
///////////	to the server						///////////////////
///////////////////////////////////////////////////////////////////

private ["_cim_AnimFnc"];
_cim_AnimFnc = {
	private ["_thisMan","_newAnim"];
	_thisMan = _this select 1;
	_newAnim = _this select 2;
	
	_thisman switchMove _newAnim;
};

while {true} do {
	waitUntil {cim_animation select 0};
	
	cim_animation call _cim_AnimFnc;
	cim_animation = [false,(cim_animation select 1),(cim_animation select 2)];
	
	sleep 0.2;
	
	//Debug
	if (CIM_DebugMode) then {diag_log "Client showing animation";};
};