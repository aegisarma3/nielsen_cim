///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////	
///////////	nielsen_cim_pacify_server.sqf:		///////////////////
///////////	Executed by nielsen_cim_init.sqf	///////////////////		
///////////	called by nielsen_cim_getDown_client///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script collects info from		///////////////////
///////////	clients, and disarms civilians		///////////////////
///////////										///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CIM_DebugMode) then {diag_log "nielsen_cim_pacify_Server.sqf is running.";};

private ["_cim_serverFnc"];
_cim_serverFnc = {
	private ["_thisMan","_weaponholder","_invList","_type"];
	_thisMan = _this select 0;
		
	_weaponholder = "WeaponHolder" createVehicle getPos _thisMan; 
	_weaponholder setPos getPos _thisMan;
	
	//Get inventory list
	_invList = [_thisMan] call bis_fnc_invString;

	//If anything in inventory putt everything on the ground
	if (count _invList > 0) then {
		//put weapons/mags/items in invisible ammocrate
		for "_y" from 0 to ((count _invList) - 1) do {	
		
			_type = [(_invList select _y)] call bis_fnc_invSlotType;
			if ((_type select 3 != 0) OR (_type select 4 != 0) OR (_type select 3 != 0)) then {
				_weaponholder addMagazineCargoGlobal [(_invList select _y),1];
			} else {
				_weaponholder addWeaponCargoGlobal [(_invList select _y),1];
			};
		};
		//remove all weapons/mags/items from civ
		removeAllWeapons _thisMan;
		removeAllItems _thisMan;
	};
	
	//Add civilian to global array of disarmed civilians
	_CBApubVar = ["CIM_List_Disarmed", CIM_List_Disarmed + [_thisMan]] call CBA_fnc_publicVariable;
	_CBApubVar = ["CIM_List_Searched", CIM_List_Searched - [_thisMan]] call CBA_fnc_publicVariable;
};

while {true} do {
	waitUntil {CIM_Disarm select 0};
	_newCiv = CIM_Disarm select 1;
	
	[_newCiv] call _cim_serverFnc;
		
	//Debug
	if (CIM_DebugMode) then {diag_log format ["Server disarming civilian %1",CIM_Disarm select 1];};

	_CBApubVar = ["CIM_Disarm", [false,CIM_Disarm select 1]] call CBA_fnc_publicVariable;
};
