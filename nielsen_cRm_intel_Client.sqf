///////////////////////////////////////////////////////////////////
///////////	(CRM) Civilian Reaction Module		///////////////////
///////////				By: Nielsen				///////////////////
///////////////////////////////////////////////////////////////////
///////////	nielsen_cRm_intel_client.sqf:		///////////////////
///////////	This script handles the intel 		///////////////////
///////////	Executed by init. Info from FSM.	///////////////////
///////////////////////////////////////////////////////////////////

//Debug
if (CRM_DebugMode) then {diag_log "nielsen_cRm_intel_client.sqf is running.";};

private ["_getInfoFNC","_soldier","_enemies","_nearMen","_enemy","_offPos","_intelType","_nearIEDs","_ied","_viableIntel","_rnd"];

CRM_newInfo= false;

	//Function to get intel from civilian
_getInfoFNC = {
	//Set intel type (10% chance of bad intel)
	_rnd = random 1;
	if (_rnd < 0.1) then {_intelType = "bad";} else {_intelType = "good";};

	//Set player unit
	_soldier = _this select 0;

	//If intel is good, get list of viable intel and reveal random - else give standard bad intel.
	switch (_intelType) do {
		case "good": {
			_viableIntel = [];
			//check for enemies in the area
			_enemies = [];
			_nearMen = (getPos _soldier) nearEntities ["Man",500];
			for "_y" from 0 to (count _nearMen - 1) do {
				if (side (_nearMen select _y) == CRM_EnemySide) then {
					_enemies = _enemies + [(_nearMen select _y)];
				};
			};
			if (count _enemies > 0) then { _viableIntel = _viableIntel + ["Enemy"];};

			//Check for IEDs in the area
			_nearIEDs = nearestObjects [(getPos _soldier),["ACE_IEDLandBig_Range","ACE_IEDUrbanBig_Range","ACE_IEDLandSmall_Range","ACE_IEDUrbanSmall_Range"],500];
			if (count _nearIEDs > 0) then { _viableIntel = _viableIntel + ["IED"];};

				//Give intel if the area is safe or not
			if (count _viableIntel == 0) then {
				titleText ["The civilian tells you that the area is safe.", "PLAIN"];
			} else {
				//Get random intel
				_currentIntel = _viableIntel select (floor(random(count _viableIntel)));
				switch (_currentIntel) do {
					case "Enemy": {
						_enemy = _enemies select (floor(random(count _enemies)));

						//Get random location around the enemy and place a maker
						_offPos = [getpos _enemy,random 360,[20,100],false,1] call SHK_pos;
						call compile format ["intelMarker_%1 = createMarker [""intelMarker_%1"", _offPos]; intelMarker_%1 setMarkerShape ""ICON""; intelMarker_%1 setMarkerText ""Aprox. enemy location""; intelMarker_%1 setMarkerSize [1,1]; intelMarker_%1 setMarkerColor ""ColorRed""; intelMarker_%1 setMarkerType ""DOT"";",CRM_Intel_Found];
						_pubVar = ["CRM_Intel_Found", CRM_Intel_Found + 1] call CBA_fnc_publicVariable;

						//Give hint to the player that he got intel
						titleText ["The civilian tells you that enemies are nearby, and shows you where on your map.", "PLAIN"];
					};
					case "IED": {
						_ied = _nearIEDs select (floor(random(count _nearIEDs)));

						//Get random location around the enemy and place a maker
						_offPos = [getpos _ied,random 360,[5,30],false,1] call SHK_pos;
						call compile format ["intelMarker_%1 = createMarker [""intelMarker_%1"", _offPos]; intelMarker_%1 setMarkerShape ""ICON""; intelMarker_%1 setMarkerText ""Aprox. IED location""; intelMarker_%1 setMarkerSize [1,1]; intelMarker_%1 setMarkerColor ""ColorRed""; intelMarker_%1 setMarkerType ""DOT"";",CRM_Intel_Found];
						_pubVar = ["CRM_Intel_Found", CRM_Intel_Found + 1] call CBA_fnc_publicVariable;

						//Give hint to the player that he got intel
						titleText ["The civilian tells you that enemies have planted an IED nearby, and shows you where on your map.", "PLAIN"];
					};
				};
			};
		};
		//If intel is bad give standard bad-intel.
		case "bad": {
			titleText ["The civilian tells you that the area is safe.", "PLAIN"];
		};
	};
};

//Loop fired by intel.fsm.
//Check if soldier is local and call intel function
while {true} do {
	//Reset variable before loop
	waitUntil {CRM_newInfo select 0};

	//Check is soldier is local and call intel function
	_soldier = CRM_newInfo select 1;
	if (local _soldier) then {
		[_soldier] call _getInfoFNC;
		_pubVar = ["CRM_newInfo", [false,objNull]] call CBA_fnc_publicVariable;
	};
};
