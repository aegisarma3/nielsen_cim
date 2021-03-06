///////////////////////////////////////////////////////////////////
///////////	(CIM) Civilian Interaction Module	///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cim_checksmoke.sqf:			///////////////////
///////////	Only runs on clients.				///////////////////
///////////	called by 'FIRED' eventhandler		///////////////////
///////////////////////////////////////////////////////////////////
///////////	This script collects info from		///////////////////
///////////	eventhandler, and detects if smoke  ///////////////////
///////////	was thrown. If so it places a		///////////////////
///////////	invisible helipad on the smokeshell.///////////////////
///////////////////////////////////////////////////////////////////

private ["_ammotype","_muzzle","_unit","_smokeShell","_smokeList"];

// the "Fired" event passes an array of: [unit, weapon, muzzle, mode, ammo];
_ammotype = _this select 4;
_muzzle = _this select 2;
_unit = _this select 0;
_smokeList = CIM_Module getVariable "nielsen_cim_SmokeType";

//Check if the CIM_Key is pressed
if (cim_key_pressed) then {
	//detecting smoke and placing Hpad
	if (_ammotype in _smokeList) then {
			_smokeShell = position player nearestObject _ammotype;
			_unit groupchat "Marking LZ with smoke!";

			sleep 5; //Need sleep to make sure the smoke lands before placing Hpad
			nul = createVehicle ["Land_HelipadEmpty_F", getPos _smokeShell, [], 0, "NONE"]; 

		//Debug msg
		if (CIM_DebugMode) then {diag_log diag_log "CIM Smoketype detected. Placing helipad for LZ";};
	};
};

/* ///////////////////
////  DEBUG to .rpt  ///////
diag_log format ["%1",_unit];
diag_log format ["%1",_muzzle];
diag_log format ["%1",_ammotype];
diag_log format ["%1",_smokeShell];
diag_log "Smoke Script Stopped";
*/
