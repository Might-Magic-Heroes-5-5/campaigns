doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_STAFF_OF_VEXINGS,
	ARTIFACT_CLOAK_OF_MOURNING,
	ARTIFACT_RING_OF_DEATH,
	ARTIFACT_SKULL_HELMET
};

PlayerHero = "Ornella"
necro_towns = {"apelsin", "outpost1", "outpost2"}
AiHeroes    = {"Aberrar", "Straker"}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/A2C1/M1/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	findKeyParts = function()
		OpenCircleFog(41, 56, GROUND, 8, PLAYER_1);
		sleep( 20 );
		MoveCamera(41, 56, GROUND, 30, 3.14/3, 0, 0, 1, 1);
		sleep( 40 );
		MessageBox("/Maps/Scenario/A2C1M1/pmessage.txt");
		sleep( 40 );
		MoveCamera(24, 56, GROUND, 50, 3.14/3, 0, 0, 1, 1);
	end,
	
	foundLowerKey = function()
		BlockGame();
		DeployReserveHero("Giovanni", 15, 28, GROUND);
		sleep(10);
		SetObjectRotation( "Giovanni", 170 );
		local x, y = RegionToPoint( 'regionToOrnellaTeleport_1' );
		SetRegionBlocked( 'regionToOrnellaTeleport_1', nil );
		SetObjectRotation( PlayerHero, 0 );
		SetObjectRotation( PlayerHero, 0 );
		sleep(20)
		UnblockGame();
		StartAdvMapDialog(1, "RemoveGiovanni");
		sleep(20);
		MessageBox("/Maps/Scenario/A2C1M1/key_lower.txt");
	end,
	
	foundUpperKey = function()
		BlockGame();
		DeployReserveHero("Giovanni", 84, 18, GROUND);
		sleep(10);
		local x, y = RegionToPoint( 'regionToOrnellaTeleport_2' );
		SetRegionBlocked( 'regionToOrnellaTeleport_2', nil );
		SetObjectRotation( PlayerHero, 90 );
		sleep(20);
		UnblockGame();
		StartAdvMapDialog(6, "RemoveGiovanni");
		sleep(20);
		MessageBox("/Maps/Scenario/A2C1M1/key_upper.txt");
	end,
	
	meetLibrarian = function()
		BlockGame();
		sleep( 20 );
		CreateMonster( "mage", CREATURE_MAGI, 10, 19, 59, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
		SetObjectRotation( PlayerHero, 90 );
		sleep(20);
		UnblockGame();
		StartAdvMapDialog(0);  -------------------------0_adv_map_scene
		sleep( 10 );
		RemoveObject( "mage" ) 
		sleep( 20 );
	end,
	
	meetLibrarian2 = function()
		BlockGame();
		sleep( 20 );
		CreateMonster( "mage", CREATURE_MAGI, 10, 70, 13, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 180 );
		sleep( 50 );
		SetObjectRotation( PlayerHero, 0 );
		sleep( 50 );
		UnblockGame();
		StartAdvMapDialog (7);  -------------------------0_adv_map_scene
		sleep( 50 );
		RemoveObject( "mage" ) 
		sleep( 20 );
	end,
	
    throughPortal = function()
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dialog", nil);
		BlockGame();
		sleep(5);
		DeployReserveHero("Giovanni", 52, 52, GROUND);
		DeployReserveHero("Gles", 55, 52, GROUND);
		sleep(50);
		StartAdvMapDialog(3);
		sleep(10);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/LuckGood.xdb#xpointer(/Effect)", PlayerHero,  "orn1", 0, 0, 2, 0, 0 );
		PlayVisualEffect(  "/Effects/_(Effect)/Spells/LuckBad.xdb#xpointer(/Effect)",     "Gles", "mage1", 0, 0, 2, 0, 0 );
		sleep(30);
		RemoveObject( "Giovanni" );
		RemoveObject(     "Gles" );
		sleep(10);
		UnblockGame();
		Play2DSound( "/Maps/Scenario/A2C1M1/C1M1_AM4_Giovanni_03sound.xdb#xpointer(/Sound)" );
	end,

	specialTroopsStart = function()
		local x, y, level = GetObjectPosition(PlayerHero)
		DeployReserveHero("Giovanni", 28, 19, GROUND);
		StartAdvMapDialog (2, "RemoveGiovanni" );
		sleep( 20 );
		OpenCircleFog(77, 5, GROUND, 8, PLAYER_1);
		MoveCamera(77, 5, GROUND, 30, 3.14/3, 0, 0, 1, 1);
		sleep( 80 );
		MessageBox("/Maps/Scenario/a2c1m1/witch_message.txt");
		sleep( 30 );
		MoveCamera(x, y, level, 50, 3.14/3, 0, 0, 1, 1);
	end,

	specialTroopsFinish = function()
		local x, y, level = GetObjectPosition(PlayerHero)
		OpenCircleFog(5, 65, GROUND, 6, PLAYER_1);
		MoveCamera(5, 65, GROUND, 30, 3.14/3, 0, 0, 1, 1);
		sleep( 30 );
		MessageBox("/Maps/Scenario/a2c1m1/message03.txt");
		sleep( 20 );
		MoveCamera(x, y, level, 50, 3.14/3, 0, 0, 1, 1);
	end,

	whichTaskFinish = function()
		BlockGame();	
		SetObjectRotation( PlayerHero, 180 )
		DeployReserveHero("Giovanni", 75, 9, GROUND);
		sleep( 10 );
		StartAdvMapDialog( 5, "RemoveGiovanni" );
		sleep( 10 );
		UnblockGame();
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/A2C1/M1/S2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(10);
	end
}

function TownsSetUp()
	for i,building in necro_towns do
		for creatureID = 1, CREATURES_COUNT - 1 do 
			CreatureSetUp = GetObjectCreatures(building, creatureID);
			if GetObjectCreatures(building, creatureID) > 2 then
				RemoveObjectCreatures(building, creatureID, CreatureSetUp);
				AddObjectCreatures(building, creatureID, CreatureSetUp * diff/2);
			end
		end
	end
end

function HowToOpenPortal(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		BlockGame();
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "bolt", nil );
		OBJECTIVES.state.findUpperKeyPart[2] = 1;
		OBJECTIVES.state.findLowerKeyPart[2] = 1;
	end
end

function RemoveGiovanni()
	RemoveObject( "Giovanni" );
end

function A2C1M1_saveArtifacts(hero)
	local i = 0;
	local result = not nil;
	migrateArtifacts_store = {};
	repeat
		result = pcall(HasArtefact,hero, i, 1);
		if result ~= nil and result[1] ~= nil then
			table.insert(migrateArtifacts_store, i);
		end
		i = i+1;
	until result == nil
end

function A2C1M1_loadArtifacts(hero)
	for i = 1, migrateArtifacts_store.n do
		GiveArtifact(hero, migrateArtifacts_store[i]);
	end
end

function ornella_ex()
	pexp = GetHeroStat(PlayerHero, STAT_EXPERIENCE);
	PlayVisualEffect("/Effects/_(Effect)/Spells/Phantom_Out.xdb#xpointer(/Effect)", PlayerHero, 0, 0, GROUND);
	sleep( 30 );
	RemoveObject(PlayerHero);
	sleep( 10 );
	DeployReserveHero("OrnellaNecro", 53, 84, GROUND);
	sleep( 20 );
	GiveHeroSkill("OrnellaNecro", SKILL_NECROMANCY);
	sleep( 50 );
	ChangeHeroStat("OrnellaNecro", STAT_EXPERIENCE, pexp);
	InitAllSetArtifacts( "A2C1M1", "OrnellaNecro" );
	A2C1M1_loadArtifacts("OrnellaNecro");
	sleep(20);
	SaveHeroAllSetArtifactsEquipped("OrnellaNecro", "A2C1M1");
end

function StrangeMineOre(hero)
	if GetObjectOwner(hero) == PLAYER_1  then
		if OBJECTIVES.state.whichTask[2] < 2 then
			MessageBox("/Maps/Scenario/a2c1m1/message02.txt");
		elseif OBJECTIVES.whichTask_strangeOre == 0 then	
			ShowFlyingSign("/Maps/Scenario/a2c1m1/message04.txt", "StrangeMine", PLAYER_1, 10)
			sleep( 20 );
			OBJECTIVES.whichTask_strangeOre = 1
			MarkObjectAsVisited("StrangeMine", hero);
		else 
			ShowFlyingSign("/Maps/Scenario/a2c1m1/message100.txt", "StrangeMine", PLAYER_1, 10)
		end
	end
end	

function PlaySceneIfTownCapured()
	while 1 do
		sleep(10);
		if GetObjectOwner("outpost1") == PLAYER_1 then
			CINEMATICS.meetLibrarian();
			return
		elseif GetObjectOwner("outpost2") == PLAYER_1 then
			CINEMATICS.meetLibrarian2();
			return
		end
	end
end

DIFFICULTY = {
	[0] = function()
		diff = 2;
		print("Difficulty Level is NORMAL");
	end,
	[1] = function()
		diff = 2;
		print("Difficulty Level is HARD");
	end,
	[2] = function()
		diff = 3;
		print("Difficulty Level is HEROIC");
	end,
	[3] = function()
		diff = 4;
		print("Difficulty Level is IMPOSSIBLE");
	end,
}

OBJECTIVES = {
	state = {
		captureNadin     = { "obj1", 1 },       -- Capture Illuma-nadin town in 3 months
		findUpperKeyPart = { "obj2", 0 },		-- Find lower key part
		findLowerKeyPart = { "obj3", 0 },		-- Find upper key part
		mendTheKey       = { "obj4", 1 },		-- Merge the key in the forge
		isAlive          = { "obj5", 1 },		-- Ornella must survive
		specialTroops    = { "sobj1", 1 },		-- Find how to grow special undead units
		whichTask        = { "sobj2", 0 },		-- Bring the ingredients to the witch
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		OverrideObjectTooltipNameAndDescription ( "forge", "/Maps/Scenario/a2c1m1/tyltip1.txt", "/Maps/Scenario/a2c1m1/tyltip2.txt" );
		GiveExp( "Isher", 20000 );
		CINEMATICS.intro();
		PlayVisualEffect( "/Effects/_(Effect)/Buildings/Dwellings/Necropolis/Ruined_Tower.xdb#xpointer(/Effect)", "",   "keeper_fx", 16, 29, 0, 0, 0 ); -- lower key part location
		PlayVisualEffect(        "/Effects/_(Effect)/Towns/Necropolis/NecromancyAmplifier.xdb#xpointer(/Effect)", "",  "keeper_fx1", 16, 29, 0, 0, 0 ); -- lower key part location
		PlayVisualEffect( "/Effects/_(Effect)/Buildings/Dwellings/Necropolis/Ruined_Tower.xdb#xpointer(/Effect)", "",  "keeper1_fx", 83, 19, 0, 0, 0 ); -- upper key part location
		PlayVisualEffect(        "/Effects/_(Effect)/Towns/Necropolis/NecromancyAmplifier.xdb#xpointer(/Effect)", "", "keeper1_fx1", 83, 19, 0, 0, 0 ); -- upper key part location

		startThread(PlaySceneIfTownCapured);
		DIFFICULTY[GetDifficulty()]();
		TownsSetUp();
		SetHeroesExpCoef( 0.3 );	
		MakeHeroNecromancer( PlayerHero, 1 ); 
		OpenCircleFog(47, 84, GROUND, 10, PLAYER_1);
		sleep( 30 );
		
		SetObjectEnabled(  "witch_hut", nil);
		SetObjectEnabled(      "forge", nil);
		SetObjectEnabled(     "portal", nil);
		SetObjectEnabled("StrangeMine", nil);
		
		Trigger(OBJECT_TOUCH_TRIGGER, "StrangeMine",                       "StrangeMineOre");
		Trigger(OBJECT_TOUCH_TRIGGER,      "portal",   "OBJECTIVES._mendTheKey_visitPortal");
		Trigger(OBJECT_TOUCH_TRIGGER,       "forge",    "OBJECTIVES._mendTheKey_visitForge");
		Trigger(OBJECT_TOUCH_TRIGGER,   "witch_hut", "OBJECTIVES._specialTroops_visitWhich");

		Trigger(REGION_ENTER_AND_STOP_TRIGGER,   "bolt",          "HowToOpenPortal", nil );
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "dialog", "CINEMATICS.throughPortal", nil );
		
		SetRegionBlocked( "regionToOrnellaTeleport_1", not nil );
		SetRegionBlocked( "regionToOrnellaTeleport_2", not nil );
		SetRegionBlocked(      "ai1", not nil, PLAYER_2);
		SetRegionBlocked(      "ai2", not nil, PLAYER_2);
		SetRegionBlocked(      "aix", not nil, PLAYER_2); 
		SetRegionBlocked(  "stop_ai", not nil, PLAYER_2); 
		SetRegionBlocked("tutorial3", not nil, PLAYER_2); 
		EnableHeroAI("Isher", nil);
		
		BlockTownGarrisonForAI( "apelsin", not nil );
		BlockTownGarrisonForAI( "outpost1", not nil );
		BlockTownGarrisonForAI( "outpost2", not nil );
		
		SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_1, 1);
		SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_2, 1);
		SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_3, 1);
		SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_4, 1);
		SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_5, 1);
		SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_6, 1);
		SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_7, 0);
		
		SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_1, 1);
		SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_2, 1);
		SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_3, 1);
		SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_4, 1);
		SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_5, 1);
		SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_6, 1);
		SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_7, 0);
		
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_DUNGEON, 0);	
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_HEAVEN, 0);	
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_INFERNO, 0);	
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_STRONGHOLD, 0);
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_ACADEMY, 0);
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_FORTRESS, 0);
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_PRESERVE, 0);
		AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_NECROMANCY, 0);
		SetDisabledObjectMode( "StrangeMine", DISABLED_INTERACT ) -- Disable mine to use it for special purpose
		--	SetDisabledObjectMode( "crypt", DISABLED_INTERACT );
		sleep( 45 );
	--	Play2DSound( "/Sounds/_(Sound)/Heroes/Biara/Happy.xdb#xpointer(/Sound)" )	
	end,
	
	run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					OBJECTIVES[key]();
				end
			end
			
			if GetObjectiveState("obj1") == OBJECTIVE_FAILED or GetObjectiveState("obj5") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED then
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	_captureNadin_day = 999,
	captureNadin = function()
		if OBJECTIVES.state.captureNadin[2] == 1 then
			SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
			sleep(20);
			MessageBox("/Maps/Scenario/a2c1m1/warning.txt");
			OBJECTIVES.state.captureNadin[2] = 2;
		elseif OBJECTIVES.state.captureNadin[2] == 2 and GetObjectOwner("apelsin") == PLAYER_1 then
			startThread(A2C1M1_saveArtifacts, "Ornella")
			SetObjectiveState("obj1", OBJECTIVE_COMPLETED);
			CINEMATICS.outro();
			sleep( 50 );
			ornella_ex();
			sleep( 100 );
			OBJECTIVES.state.captureNadin[2] = 10;
		end
		
		if OBJECTIVES._captureNadin_day ~= OBJECTIVES.date and GetDate(MONTH) == 3 and GetDate(WEEK) == 4 and GetDate(DAY_OF_WEEK) == 1 then
			MessageBox("/Maps/Scenario/a2c1m1/warning4.txt");
		end
		
		if GetDate(MONTH) == 4 and GetDate(WEEK) == 1 and GetDate(DAY_OF_WEEK) == 1 then
			SetObjectiveState("obj1", OBJECTIVE_FAILED);
			OBJECTIVES.state.captureNadin[2] = 11;
		end
		OBJECTIVES._captureNadin_day = OBJECTIVES.date;
	end,
	
	findLowerKeyPart = function()
		if OBJECTIVES.state.findLowerKeyPart[2] == 1 then
			SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
			CINEMATICS.findKeyParts();
			UnblockGame();
			OBJECTIVES.state.findLowerKeyPart[2] = 2;
		elseif OBJECTIVES.state.findLowerKeyPart[2] == 2 and IsObjectExists("keeper") == nil then
			StopVisualEffects("keeper_fx");
			StopVisualEffects("keeper_fx1");
			if OBJECTIVES.state.findUpperKeyPart[2] < 3 then
				CINEMATICS.foundLowerKey();
			end
			OBJECTIVES.state.findLowerKeyPart[2] = 3;
		elseif OBJECTIVES.state.findLowerKeyPart[2] == 3 then
			SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.findLowerKeyPart[2] = 10;
		end
	end,
	
	findUpperKeyPart = function()
		if OBJECTIVES.state.findUpperKeyPart[2] == 1 then
			SetObjectiveState("obj3", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.findUpperKeyPart[2] = 2;
		elseif OBJECTIVES.state.findUpperKeyPart[2] == 2 and IsObjectExists("keeper1") == nil then
			StopVisualEffects("keeper1_fx");
			StopVisualEffects("keeper1_fx1");		
			if OBJECTIVES.state.findLowerKeyPart[2] < 3 then
				CINEMATICS.foundUpperKey();
			end
			OBJECTIVES.state.findUpperKeyPart[2] = 3;
		elseif OBJECTIVES.state.findUpperKeyPart[2] == 3 then
			SetObjectiveState("obj3", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.findUpperKeyPart[2] = 10;
		end
	end,
	
	_mendTheKey_visitPortal = function( heroName )
		if GetObjectOwner(heroName) == PLAYER_1 then
			if OBJECTIVES.state.mendTheKey[2] < 3 then
				sleep( 5 );
				MessageBox("/Maps/Scenario/a2c1m1/portal_closed.txt");
				return
			elseif heroName ~= PlayerHero then
				MessageBox( "/Maps/Scenario/A2C1M1/MsgBox_OnlyOrnellaCanPass.txt" );
			end
		end
	end,

	_mendTheKey_visitForge = function()
		if OBJECTIVES.state.mendTheKey[2] == 2 then
			OBJECTIVES.state.mendTheKey[2] = 3;
		elseif OBJECTIVES.state.mendTheKey[2] == 10 then
			MessageBox("/Maps/Scenario/a2c1m1/forge_message3.txt");  -- admire the forge
		else
			MessageBox("/Maps/Scenario/a2c1m1/Forge_last.txt");		 -- not sure about the forge purpose
		end
	end,

	mendTheKey = function()
		if OBJECTIVES.state.mendTheKey[2] == 1 and OBJECTIVES.state.findLowerKeyPart[2] == 10 and OBJECTIVES.state.findUpperKeyPart[2] == 10 then
			BlockGame();
			SetObjectiveState("obj4", OBJECTIVE_ACTIVE);
			a,b,terrain = GetObjectPosition( PlayerHero )
			OpenCircleFog(7, 89, GROUND, 8, PLAYER_1);
			MoveCamera(7, 89, GROUND, 30, 3.14/3, 0, 0, 1, 1);
			sleep( 60 );
			UnblockGame();
			MessageBox("/Maps/Scenario/a2c1m1/forge_message.txt");
			sleep( 30 );
			MoveCamera(a, b, terrain, 50, 3.14/3, 0, 0, 1, 1);
			OBJECTIVES.state.mendTheKey[2] = 2;
		elseif OBJECTIVES.state.mendTheKey[2] == 3 then
			local p_ore = GetPlayerResource(PLAYER_1, ORE);
			if p_ore < 15 then
				MessageBox("/Maps/Scenario/a2c1m1/forge_message1.txt");
				OBJECTIVES.state.mendTheKey[2] = 2;
			else
				SetPlayerResource(PLAYER_1, ORE, p_ore - 15);
				SetRegionAutoObjectEnable( "blocker_not_ornella", REGION_AUTOACTION_ON_ENTER, -1, -1, PlayerHero, "portal", 1 );
				SetRegionAutoObjectEnable( "blocker_not_ornella", REGION_AUTOACTION_ON_EXIT, -1, -1, PlayerHero, "portal", 0 );
				ShowFlyingSign("/Maps/Scenario/A2C1M1/portal.txt", "forge", 1, 8);
				SetObjectiveState("obj4", OBJECTIVE_COMPLETED);
				OBJECTIVES.state.mendTheKey[2] = 10;
			end
		end
	end,
	
	isAlive = function()
		-- start of this task is handled by A2C1M1.xdb
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive(PlayerHero) == nil then
			SetObjectiveState( 'obj5', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		elseif OBJECTIVES.state.captureNadin[2] == 10 then
			SetObjectiveState("obj5", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.isAlive[2] = 10;
		end
	end,
	
	_specialTroops_visitWhich = function(hero)
		if hero ~= PlayerHero then
			MessageBox("/Maps/Scenario/a2c1m1/orn_need.txt");
			return
		elseif OBJECTIVES.state.specialTroops[2] == 2 then
			OBJECTIVES.state.specialTroops[2] = 3;
		elseif OBJECTIVES.state.whichTask[2] == 2 then
			OBJECTIVES.state.whichTask[2] = 3;
		elseif OBJECTIVES.state.whichTask[2] == 10 then
			MessageBox("/Maps/Scenario/A2C1M1/wich_empty.txt");
		end
	end,
	
	specialTroops = function()
		if OBJECTIVES.state.specialTroops[2] == 1 and IsObjectExists("skeleton_warrior") == nil then
			SetObjectiveState("sobj1", OBJECTIVE_ACTIVE);
			CINEMATICS.specialTroopsStart();
			OBJECTIVES.state.specialTroops[2] = 2;
		elseif OBJECTIVES.state.specialTroops[2] == 3 then
			SetObjectiveState("sobj1", OBJECTIVE_COMPLETED);
			MarkObjectAsVisited("witch_hut", PlayerHero);
			CINEMATICS.specialTroopsFinish();
			OBJECTIVES.state.whichTask[2] = 1;
			OBJECTIVES.state.specialTroops[2] = 10;
		end
	end,
	
	whichTask_strangeOre = 0,
	whichTask = function()
		if OBJECTIVES.state.whichTask[2] == 1 then 
			SetObjectiveState("sobj2", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.whichTask[2] = 2;
		elseif OBJECTIVES.state.whichTask[2] == 3 then
			local p_mercury = GetPlayerResource(PLAYER_1, MERCURY);
			if p_mercury < 10 or OBJECTIVES.whichTask_strangeOre == 0 or GetHeroCreatures(PlayerHero, CREATURE_WALKING_DEAD) < 50 then
				MessageBox("/Maps/Scenario/a2c1m1/res_need.txt");
				OBJECTIVES.state.whichTask[2] = 2;
			else
				SetPlayerResource(PLAYER_1, MERCURY, p_mercury - 10);
				RemoveHeroCreatures(PlayerHero, CREATURE_WALKING_DEAD, 50);
				SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_1, 2);
				SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_2, 2);
				SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_3, 2);
				SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_4, 2);
				SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_5, 2);
				SetTownBuildingLimitLevel("outpost1", TOWN_BUILDING_DWELLING_6, 2);
				SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_1, 2);
				SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_2, 2);
				SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_3, 2);
				SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_4, 2);
				SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_5, 2);
				SetTownBuildingLimitLevel("outpost2", TOWN_BUILDING_DWELLING_6, 2);
				CINEMATICS.whichTaskFinish();
				SetObjectiveState("sobj2", OBJECTIVE_COMPLETED);
				OBJECTIVES.state.whichTask[2] = 10;
			end
		end
	end,
}

----------------------------------   MAIN   --------------------------------------------
startThread(OBJECTIVES.start);

function a2c1m1_dbg(state)
	if state == 1 then
		H55_Speedrun(1);
		RemoveObject("skeleton_warrior");
	elseif state == 11 then
		MakeHeroInteractWithObject("Ornella", "witch_hut");
	elseif state == 2 then
		SetObjectPosition("Ornella", 24, 56);
	elseif state == 22 then
		SetObjectPosition("Ornella", 15, 32);
	elseif state == 222 then
		SetObjectPosition("Ornella", 81, 19);
	elseif state == 2222 then
		MakeHeroInteractWithObject("Ornella", "forge");
	elseif state == 3 then
		SetObjectPosition("Ornella", 38, 58);
	end
end
