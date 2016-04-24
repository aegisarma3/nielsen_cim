////////////////////////////////////////////////////////////////////
//DeRap: Produced from mikero's Dos Tools Dll version 4.97
//Thu Apr 21 12:18:30 2016 : Source 'file' date Thu Apr 21 12:18:30 2016
//http://dev-heaven.net/projects/list_files/mikero-pbodll
////////////////////////////////////////////////////////////////////

#define _ARMA_

//Class nielsen_cim : config.bin{
class CfgPatches
{
	class nielsen_cim
	{
		units[] = {};
		weapons[] = {};
		requiredVersion = 0.1;
		requiredAddons[] = {"A3_Modules_F","Extended_Eventhandlers"};
		version = "02";
		author[] = {"Nielsen"};
	};
};
class CfgAddons
{
	class PreloadAddons
	{
		class nielsen_cim
		{
			list[] = {"nielsen_cim"};
		};
	};
};
class CfgSFX
{
	class nielsen_cim_crowd
	{
		sounds[] = {"dummy","cim_crowd1"};
		name = "cim_Crowd";
		dummy[] = {"",0,0,0,0,0,0,0};
		cim_crowd1[] = {"\nielsen_cim\sounds\cim_crowd.ogg",0.00316228,1,50,1,0,0,0};
		empty[] = {"",0,0,0,0,0,0,0};
	};
	class nielsen_cim_crying
	{
		sounds[] = {"dummy","cim_crying1"};
		name = "cim_Crying";
		dummy[] = {"",0,0,0,0,0,0,0};
		cim_crying1[] = {"\nielsen_cim\sounds\cim_crying.ogg",0.00316228,1,50,1,0,0,0};
		empty[] = {"",0,0,0,0,0,0,0};
	};
};
class cfgSounds
{
	class NoSound
	{
		name = "NoSound";
		sound[] = {"",0,1};
		titles[] = {};
	};
	class nielsen_cim_getDown
	{
		name = "nielsen_cim_getDown";
		sound[] = {"\nielsen_cim\sounds\cim_getDown.ogg",0.31622776,1.0};
		titles[] = {};
	};
	class nielsen_cim_getAway
	{
		name = "nielsen_cim_getAway";
		sound[] = {"\nielsen_cim\sounds\cim_getAway.ogg",0.31622776,1.0};
		titles[] = {};
	};
	class nielsen_cim_stopCar
	{
		name = "nielsen_cim_stopCar";
		sound[] = {"\nielsen_cim\sounds\cim_stopCar.ogg",0.31622776,1.0};
		titles[] = {};
	};
	class nielsen_cim_getInside
	{
		name = "nielsen_cim_getInside";
		sound[] = {"\nielsen_cim\sounds\cim_getInside.ogg",0.31622776,1.0};
		titles[] = {};
	};
	class nielsen_cim_radiochatter
	{
		name = "nielsen_cim_radiochatter";
		sound[] = {"\nielsen_cim\sounds\radiochatter.ogg",0.31622776,1.0};
		titles[] = {};
	};
};

//MODULES
class CfgVehicles
{
	class Logic;
	class nielsen_cim: Logic
	{
		displayName = "(CIM) Civilian Interaction Module";
		icon = "\nielsen_cim\icon_CIM.paa";
		picture = "\nielsen_cim\icon_cim.paa";
		vehicleClass = "Modules";
		class EventHandlers
		{
			init = "private [""_ok""]; _ok = (_this select 0) execVM ""\nielsen_cim\nielsen_cim_init.sqf"" ";
		};
	};
	class nielsen_crm: Logic
	{
		displayName = "(CIM) Civilian Reaction Module";
		icon = "\nielsen_cim\icon_CRM.paa";
		picture = "\nielsen_cim\icon_crm.paa";
		vehicleClass = "Modules";
		class EventHandlers
		{
			init = "private [""_ok""]; _ok = (_this select 0) execVM ""\nielsen_cim\nielsen_cRm_init.sqf"" ";
		};
	};
	class nielsen_cem: Logic
	{
		displayName = "(CIM) Civilian Extraction Module";
		icon = "\nielsen_cim\icon_CEM.paa";
		picture = "\nielsen_cim\icon_cEm.paa";
		vehicleClass = "Modules";
		class EventHandlers
		{
			init = "private [""_ok""]; _ok = (_this select 0) execVM ""\nielsen_cim\nielsen_cEm_init.sqf"" ";
		};
	};
};
//};
