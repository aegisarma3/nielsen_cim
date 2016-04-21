///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cRm_control_server.sqf:		///////////////////
///////////	This script handles the control of	///////////////////
///////////	reactions.							///////////////////
///////////////////////////////////////////////////////////////////

private ["_time","_chance","_Civilians","_nearMen","_allItems","_newCiv"];

//Set variables
_time = CRM_Module getVariable "nielsen_crm_evidence_time";
_chance = CRM_Module getVariable "nielsen_crm_evidence_chance";
_range = 300;
_allItems = ["Land_Laptop_unfolded_F","Land_Document_01_F","Land_File1_F","Land_FilePhotos_F","Land_File2_F","Land_File_research_F","Land_Notepad_F","Land_Money_F","Land_Laptop_device_F","Land_Map_unfolded_F"];

//Function to add evidence to civilian
private ["_evidenceFNC"];
_evidenceFNC = {
	private ["_thisMan","_item"];
	_thisMan = _this select 0;

	//select random item and add it to civilian
	_item = _allItems select (floor(random(count _allItems)));
	[_thisMan,_item] call BIS_fnc_invAdd;

	//Set variable on unit to check in other (local) scripts
	_thisMan setVariable ["crm_evidence",_item];
};

//Control structure
while {true} do {

	//Wait
	sleep _time;

	//Do a check on all synced units
	{
		_rnd = random 1;
		//Check against chance
		if (_rnd < _chance) then {
				//Gather nearby civs and put in _civilians list
				_Civilians = [];
				_nearMen = (getPos _x) nearEntities ["Man",_range];
				for "_y" from 0 to (count _nearMen - 1) do {
					if (side (_nearMen select _y) == CIVILIAN && !((_nearMen select _y) in CIM_List_Searched)) then {
						_Civilians = _Civilians + [(_nearMen select _y)];
					};
				};
				//Get random civilian
				_newCiv = _Civilians select (floor(random(count _Civilians)));

				//Call function to add evidence
				nul = [_newCiv] call _evidenceFNC;

				//Debug
				if (CRM_DebugMode) then {diag_log format ["Server starting new civilian event near player %2. On civs: %1",_Civilians,_x];};
		};
	} forEach CRM_SyncUnits;
};
