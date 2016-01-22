-- Released under GPL v3
--------------------------------------------------------------
include("IGE_API_All");
print("IGE_UnitsPanel");
IGE = nil;


local civilianUnits = {};
local civilianUnitManager = nil;
local civilianGroupInstance = nil;

local standardUnits = {};
local standardUnitManager = nil;
local standardGroupInstance = nil;

local supremacyPurityClasses  = {}

local purityHarmonyClasses    = {}

local harmonySupremacyClasses = {}


local harmonyUnits = {};
local harmonyUnitManager = nil;
local harmonyGroupInstance = nil;

local supremacyUnits = {};
local supremacyUnitManager = nil;
local supremacyGroupInstance = nil;

local purityUnits = {};
local purityUnitManager = nil;
local purityGroupInstance = nil;

local alienUnits = {};
local alienUnitManager = nil;
local alienGroupInstance = nil;

local orbitalUnits = {};
local orbitalUnitManager = nil;
local orbitalGroupInstance = nil

local unknownUnits = {};
local unknownUnitManager = nil;
local unknownGroupInstance = nil;

local groupInstances = {};
local unitItemManagers = {};
local eraItemManager = CreateInstanceManager("GroupInstance", "Stack", Controls.EraList );

local data = {};
local isVisible = false;
local currentUnit = nil;
local currentLevel = 1;

local civilianClasses = {}
civilianClasses["UNITCLASS_SETTLER"] = true;
civilianClasses["UNITCLASS_WORKER"] = true;
civilianClasses["UNITCLASS_EARTHLING_SETTLER"] = true;
civilianClasses["UNITCLASS_TRADER"] = true;
civilianClasses["UNITCLASS_SEA_TRADER"] = true;

local standardClasses = {}
standardClasses["UNIT_AIR_FIGHTER"] = true;
standardClasses["UNIT_CAVALRY"] = true;
standardClasses["UNIT_EXPLORER"] = true;
standardClasses["UNIT_MARINE"] = true;
standardClasses["UNIT_NAVAL_CARRIER"] = true;
standardClasses["UNIT_NAVAL_FIGHTER"] = true;
standardClasses["UNIT_NAVAL_MELEE"] = true;
standardClasses["UNIT_RANGED_MARINE"] = true;
standardClasses["UNIT_SIEGE"] = true;
standardClasses["UNIT_SUBMARINE"] = true;




local harmonyClasses = {}
harmonyClasses["UNIT_ROCKTOPUS"] = true;
harmonyClasses["UNIT_XENO_CAVALRY"] = true;
harmonyClasses["UNIT_XENO_SWARM"] = true;
harmonyClasses["UNIT_XENO_TITAN"] = true;

local supremacyClasses = {}
supremacyClasses["UNIT_ANGEL"] = true;
supremacyClasses["UNIT_CNDR"] = true;
supremacyClasses["UNIT_CARVR"] = true;
supremacyClasses["UNIT_SABR"] = true;

local purityClasses = {}
purityClasses["UNIT_AEGIS"] = true;
purityClasses["UNIT_BATTLESUIT"] = true;
purityClasses["UNIT_LEV_DESTROYER"] = true;
purityClasses["UNIT_LEV_TANK"] = true;

local supremacyPurityClasses  = {}
supremacyPurityClasses["UNIT_DRONE_CAGE"] = true;
supremacyPurityClasses["UNIT_AUTOSLED"] = true;
supremacyPurityClasses["UNIT_GOLEM"] = true;

local purityHarmonyClasses    = {}
purityHarmonyClasses["UNIT_IMMORTAL"] = true;
purityHarmonyClasses["UNIT_ARCHITECT"] = true;
purityHarmonyClasses["UNIT_THRONE"] = true;

local harmonySupremacyClasses = {}
harmonySupremacyClasses["UNIT_NANOHIVE"] = true;
harmonySupremacyClasses["UNIT_GELIOPOD"] = true;
harmonySupremacyClasses["UNIT_AQUILON"] = true;





local alienClasses = {}
alienClasses["UNIT_ALIEN_AMPHIBIAN"] = true;
alienClasses["UNIT_ALIEN_FLYER"] = true;
alienClasses["UNIT_ALIEN_HYDRA_LVL1"] = true;
alienClasses["UNIT_ALIEN_HYDRA_LVL2"] = true;
alienClasses["UNIT_ALIEN_HYDRA_LVL3"] = true;
alienClasses["UNIT_ALIEN_KRAKEN"] = true;
alienClasses["UNIT_ALIEN_MANTICORE"] = true;
alienClasses["UNIT_ALIEN_POD_HUNTER"] = true;
alienClasses["UNIT_ALIEN_RAPTOR_BUG"] = true;
alienClasses["UNIT_ALIEN_SCARAB"] = true;
alienClasses["UNIT_ALIEN_SEA_DRAGON"] = true;
alienClasses["UNIT_ALIEN_SIEGE_WORM"] = true;
alienClasses["UNIT_ALIEN_WOLF_BEETLE"] = true;


local orbitalClasses = {}
orbitalClasses["UNIT_ALL_SEEING_EYE"] = true;
orbitalClasses["UNIT_COMM_RELAY"] = true;
orbitalClasses["UNIT_DEEP_SPACE_TELESCOPE"] = true;
orbitalClasses["UNIT_HOLOMATRIX"] = true;
orbitalClasses["UNIT_LASERCOM_SATELLITE"] = true;
orbitalClasses["UNIT_MIASMIC_CONDENSER"] = true;
orbitalClasses["UNIT_MIASMIC_REPULSOR"] = true;
orbitalClasses["UNIT_ORBITAL_FABRICATOR"] = true;
orbitalClasses["UNIT_ORBITAL_LASER"] = true;
orbitalClasses["UNIT_PAEAN"] = true;
orbitalClasses["UNIT_PHASAL_TRANSPORTER"] = true;
orbitalClasses["UNIT_PLANET_CARVER"] = true;
orbitalClasses["UNIT_ROCKTOPUS"] = true;
orbitalClasses["UNIT_SOLAR_COLLECTOR"] = true;
orbitalClasses["UNIT_SPY_SATELLITE"] = true;
orbitalClasses["UNIT_STATION_SENTINEL"] = true;
orbitalClasses["UNIT_TACNET_HUB"] = true;
orbitalClasses["UNIT_WEATHER_CONTROLLER"] = true;
orbitalClasses["UNIT_XENO_SIREN"] = true;

--===============================================================================================
-- CORE EVENTS
--===============================================================================================
local function OnSharingGlobalAndOptions(_IGE)
	IGE = _IGE;
end
LuaEvents.IGE_SharingGlobalAndOptions.Add(OnSharingGlobalAndOptions);

-------------------------------------------------------------------------------------------------
function OnInitialize()
	print("IGE_UnitsPanel.OnInitialize");
	SetUnitsData(data);

	Resize(Controls.Container);
	Resize(Controls.ScrollPanel);

	civilianGroupInstance = eraItemManager:GetInstance();
	if civilianGroupInstance then
		civilianUnitManager = CreateInstanceManager("ListItemInstance", "Button", civilianGroupInstance.List );
		civilianGroupInstance.Header:SetText(L("TXT_KEY_IGE_CIVILIAN_UNITS"));
	end

	standardGroupInstance = eraItemManager:GetInstance();
	if standardGroupInstance then
		standardUnitManager = CreateInstanceManager("ListItemInstance", "Button", standardGroupInstance.List );
		standardGroupInstance.Header:SetText(L("TXT_KEY_COMBAT_HEADING1_TITLE"));
	end

	harmonyGroupInstance = eraItemManager:GetInstance();
	if harmonyGroupInstance then
		harmonyUnitManager = CreateInstanceManager("ListItemInstance", "Button", harmonyGroupInstance.List );
		harmonyGroupInstance.Header:SetText(L("TXT_KEY_AFFINITY_HARMONY_HEADING2_TITLE"));
	end

	supremacyGroupInstance = eraItemManager:GetInstance();
	if supremacyGroupInstance then
		supremacyUnitManager = CreateInstanceManager("ListItemInstance", "Button", supremacyGroupInstance.List );
		supremacyGroupInstance.Header:SetText(L("TXT_KEY_AFFINITY_SUPREMACY_HEADING2_TITLE"));
	end

	purityGroupInstance = eraItemManager:GetInstance();
	if purityGroupInstance then
		purityUnitManager = CreateInstanceManager("ListItemInstance", "Button", purityGroupInstance.List );
		purityGroupInstance.Header:SetText(L("TXT_KEY_AFFINITY_PURITY_HEADING2_TITLE"));
	end

	alienGroupInstance = eraItemManager:GetInstance();
	if alienGroupInstance then
		alienUnitManager = CreateInstanceManager("ListItemInstance", "Button", alienGroupInstance.List );
		alienGroupInstance.Header:SetText(L("TXT_KEY_BARBARIAN_BARBARIANS_HEADING2_TITLE"));
	end

	orbitalGroupInstance = eraItemManager:GetInstance();
	if orbitalGroupInstance then
		orbitalUnitManager = CreateInstanceManager("ListItemInstance", "Button", orbitalGroupInstance.List );
		orbitalGroupInstance.Header:SetText(L("TXT_KEY_ORBITAL_UNIT_HEADING2_TITLE"));
	end

	unknownGroupInstance = eraItemManager:GetInstance();
	if unknownGroupInstance then
		unknownUnitManager = CreateInstanceManager("ListItemInstance", "Button", unknownGroupInstance.List );
		unknownGroupInstance.Header:SetText(L("TXT_KEY_MISC_UNKNOWN"));
	end

	--[[Create era groups
	local last = 0;
	for i, v in ipairs(data.eras) do
		if #v.units > 0 then
			local instance = eraItemManager:GetInstance();
			if instance then
				local manager = CreateInstanceManager("ListItemInstance", "Button", instance.List );
				instance.Header:SetText(v.name);
				groupInstances[i] = instance;
				unitItemManagers[i] = manager;
				last = i;
			end
		end
	end
	groupInstances[last].Separator:SetHide(true);]]

	-- Extract cunits
	for _, era in ipairs(data.eras) do
		local i = 1;
		local units0 = era.units;
		while true do
			if not units0[i] then break end
			local unit = units0[i];
			if civilianClasses[unit.class] or unit.isGreatPeople then
				table.remove(units0, i);
				table.insert(civilianUnits, unit);
				if civilianClasses[unit.class] then unit.priority = 100 end
			elseif standardClasses[unit.type] then
				table.remove(units0, i);
				table.insert(standardUnits, unit);
				if standardClasses[unit.type] then unit.priority = 100 end
			elseif harmonyClasses[unit.type] then
				table.remove(units0, i);
				table.insert(harmonyUnits, unit);
				if harmonyClasses[unit.type] then unit.priority = 100 end
			elseif supremacyClasses[unit.type] then
				table.remove(units0, i);
				table.insert(supremacyUnits, unit);
				if supremacyClasses[unit.type] then unit.priority = 100 end
			elseif purityClasses[unit.type] then
				table.remove(units0, i);
				table.insert(purityUnits, unit);
				if purityClasses[unit.type] then unit.priority = 100 end
			elseif alienClasses[unit.type] then
				table.remove(units0, i);
				table.insert(alienUnits, unit);
				if alienClasses[unit.type] then unit.priority = 100 end
			elseif orbitalClasses[unit.type] then
				table.remove(units0, i);
				table.insert(orbitalUnits, unit);
				if orbitalClasses[unit.type] then unit.priority = 100 end
			else
				table.remove(units0, i);
				table.insert(unknownUnits, unit);
				i = i + 1;
			end
		end
	end
	currentUnit = data.unitsByTypes["UNIT_WORKER"];

	local tt = L("TXT_KEY_IGE_UNITS_PANEL_HELP");
	LuaEvents.IGE_RegisterTab("UNITS", L("TXT_KEY_IGE_UNITS_PANEL"), 2, "paint",  tt, currentUnit)
	print("IGE_UnitsPanel.OnInitialize - Done");
end
LuaEvents.IGE_Initialize.Add(OnInitialize)

-------------------------------------------------------------------------------------------------
function OnSelectedPanel(ID)
	isVisible = (ID == "UNITS");
end
LuaEvents.IGE_SelectedPanel.Add(OnSelectedPanel);

-------------------------------------------------------------------------------------------------
function CreateUnit(plot)
	local pUnit;
	local pPlayer = Players[IGE.currentPlayerID];

	-- Regular unit, just use a good old and straight cheat
	pUnit = pPlayer:InitUnit(currentUnit.ID, plot:GetX(), plot:GetY());

	if currentLevel ~= 1 then
		local xp = GetXPForLevel(currentLevel);
		pUnit:SetExperience(xp);
		pUnit:SetPromotionReady(true);
	end

end

-------------------------------------------------------------------------------------------------
function OnPlop(mouseButtonDown, plot, shift)
	if not isVisible then return end

	if not shift then
		CreateUnit(plot);
	else
		-- Kill top unit
		local count = plot:GetNumUnits();
		if count > 0 then
			local pUnit = plot:GetUnit(count - 1);
			pUnit:Kill();
		end
	end
end
LuaEvents.IGE_Plop.Add(OnPlop);

-------------------------------------------------------------------------------------------------
function ClickHandler(unit)
	currentUnit = unit;
	OnUpdate();
	LuaEvents.IGE_SetTabData("UNITS", currentUnit);
end

--===============================================================================================
-- UPDATE
--===============================================================================================
UpdateLevel = HookNumericBox("Level",
	function() return currentLevel end,
	function(amount) currentLevel = amount end,
	1, nil, 1);

-------------------------------------------------------------------------------------------------
function UpdateUnitList(units, itemManager, instance)
	for _, unit in ipairs(units) do
		unit.selected = (unit == currentUnit);
		unit.label = unit.name;
	end

	UpdateHierarchizedList(units, itemManager, ClickHandler);

	-- Resize
	local width = instance.List:GetSizeX();
	instance.HeaderBackground:SetSizeX(width + 10);
end

-------------------------------------------------------------------------------------------------
function OnUpdate()
	Controls.Container:SetHide(not isVisible);
	if not isVisible then return end

	if currentUnit then
		LuaEvents.IGE_SetMouseMode(IGE_MODE_PLOP);
	else
		LuaEvents.IGE_SetMouseMode(IGE_MODE_NONE);
	end

	UpdateLevel(currentLevel);

	-- Units
	UpdateUnitList(civilianUnits, civilianUnitManager, civilianGroupInstance);
	UpdateUnitList(standardUnits, standardUnitManager, standardGroupInstance);
	UpdateUnitList(harmonyUnits, harmonyUnitManager, harmonyGroupInstance);
	UpdateUnitList(supremacyUnits, supremacyUnitManager, supremacyGroupInstance);
	UpdateUnitList(purityUnits, purityUnitManager, purityGroupInstance);
	UpdateUnitList(alienUnits, alienUnitManager, alienGroupInstance);
	UpdateUnitList(orbitalUnits, orbitalUnitManager, orbitalGroupInstance);


	--for i, era in ipairs(data.eras) do
	--	if #era.units > 0 then
	--		UpdateUnitList(era.units, unitItemManagers[i], groupInstances[i]);
	--	end
	--end

	-- Resize
	local availableWidth = Controls.Container:GetSizeX();
	Controls.ScrollPanel:SetSizeX(availableWidth - 16);

	Controls.EraList:CalculateSize();
	Controls.EraList:ReprocessAnchoring();
    Controls.ScrollPanel:CalculateInternalSize();
	Controls.ScrollPanel:ReprocessAnchoring();

	availableWidth = Controls.ScrollPanel:GetSizeX();
	Controls.ScrollBar:SetSizeX(availableWidth - 36);
end
LuaEvents.IGE_Update.Add(OnUpdate);
