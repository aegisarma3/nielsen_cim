///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_arrest_server.sqf:		///////////////////
///////////	Executed by nielsen_cim_init.sqf	///////////////////		
///////////	Called by nielsen_cim_arrest_client	///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script collects info from		///////////////////
///////////	clients, and joins the civilian		///////////////////
///////////	to the requesting players group		///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CIM_DebugMode) then {diag_log "nielsen_cim_arrest_Server.sqf is running.";};

private ["_cim_serverFnc","_group"];
_cim_serverFnc = {
	
	//What should the civilian do?
	private ["_thisMan"];
	_thisMan = _this select 0;
	
	//Get the original group and store it in variable on unit
	_group = group _thisman;
	_thisman setVariable ["cim_civ_OG",_group];
	
	//Join unit to caller group and put in global CIM array
	_thisman setCaptive true;
	[_thisman] joinSilent (group CIM_Arrest_Caller);
	_newList_Arrested = CIM_List_Arrested + [_thisman];
	_CBApubVar = ["CIM_List_Arrested", _newList_Arrested] call CBA_fnc_publicVariable;
		
	//Debug msg
	if (CIM_DebugMode) then {diag_log format ["Civilian %1 arrested. List: %2",_thisman,CIM_List_Arrested];};
	
};

while {true} do {
	waitUntil {CIM_Arrest};
	
	[CIM_NewArrest] call _cim_serverFnc;
	//Debug
	if (CIM_DebugMode) then {diag_log format ["Server calling Arrest function on civilian %1",CIM_NewArrest];};
	
	CIM_NewArrest = ObjNull;
	//CIM_Arrest = false;
	_CBApubVar = ["CIM_Arrest", false] call CBA_fnc_publicVariable;
	sleep 0.5;
	
};
