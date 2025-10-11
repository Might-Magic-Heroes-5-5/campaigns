H55_PlayerStatus = {0,1,1,1,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_STAFF_OF_VEXINGS,
ARTIFACT_CLOAK_OF_MOURNING,
ARTIFACT_RING_OF_DEATH,
ARTIFACT_SKULL_HELMET

};

StartAdvMapDialog( 1, "voice_over_1" ); 
SetGameVar("BONUS_A2C1M4", "0"); -------------------!!!
print( "BONUS_checked_0" );

function voice_over_1()
	Play2DSound( "/Maps/Scenario/A2C1M4/C1M4_VO2_Arantir_01sound.xdb#xpointer(/Sound)" );
end;	

-----------------------------------------------------------------------------------------------------
--------------------------------- TITLE ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--	Creation Date: 27.12.06
--	Author: zomg mega script by Vladimir Degen
-- 	Author e-mail: vladimir.degen@nival.com
--	Project Name: H5A2
--	Map Name: A2C1M4
--	Script Description: MapScript
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

--*-- SCRIPT BEGINNING --*--

function print_to()
end;
--*-- ARTIFACTS SETS TRANSACTION --*--

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

--*-- Logfile beginning - for testing purposes --*--
	
---------------------------------------------------------------------------------------------------
----------------------------- CONSTANTS --------------------------------------------------
---------------------------------------------------------------------------------------------------
PLAYER_HERO = "Arantir"
HERO_PLAYER_MAIN = 'Arantir';
HERO_PLAYER_SEC = 'OrnellaNecro';
HERO_AI_INFERNO_01 = 'Deleb';
HERO_AI_INFERNO_02 = 'Marder';
HERO_AI_INFERNO_03 = 'Nymus';
HERO_AI_ORC_TRAP = 'Hero9';
HERO_AI_ORC_KUJIN = 'Hero7';
HERO_AI_ORC_GUARD = 'Hero3';
CREATURE_WIZARD_TRAP_STARTER = 'WIZARD_TRAP_STARTER';
CREATURE_FIRST_ORC_ENCOUNTER = 'FIRST_ORC_ENCOUNTER';
CREATURE_HAVEN_PRIEST = 'CREATURE_HAVEN_PRIEST';
--ORC_TOWN_01 = 'ORC_TOWN_01';
--ORC_TOWN_02 = 'ORC_TOWN_02';
TOWN_INFERNO = 'TOWN_INFERNO';
TOWN_FINAL_ORC = 'FINAL_ORC_TOWN';
PLAYER_TOWN_01 = 'PLAYER_TOWN_01';
PORTAL_INFERNO = 'PORTAL_INFERNO';
PORTAL_FIRE_01 = 'PORTAL_FIRE_01';
PORTAL_FIRE_02 = 'PORTAL_FIRE_02';
PORTAL_GUARD_01 = 'PORTAL_GUARD_01';
PORTAL_GUARD_02 = 'PORTAL_GUARD_02';
PORTAL_CRYSTAL_01 = 'PORTAL_CRYSTAL_01';
PORTAL_CRYSTAL_02 = 'PORTAL_CRYSTAL_02';
PORTAL_GATING_01 = 'PORTAL_GATING_01';
PORTAL_GATING_02 = 'PORTAL_GATING_02';
GOLD_MINE_01 = 'GOLD_MINE_01';
GOLD_MINE_02 = 'GOLD_MINE_02';
GOLD_MINE_03 = 'GOLD_MINE_03';
GOLD_MINE_04 = 'GOLD_MINE_04';
GOLD_MINE_05 = 'GOLD_MINE_05';
GOLD_MINE_06 = 'GOLD_MINE_06';
CREATURE_BANDIT_ARMY = 'CREATURE_BANDIT_ARMY';
ITEM_LOG = 'ITEM_LOG';

--*-- OBJECTIVES --*--
OBJECTIVE_PRI_01 = 'OBJECTIVE_PRI_01'; -- Find traces of Demonlord Mochab
OBJECTIVE_PRI_02 = 'OBJECTIVE_PRI_02'; -- Arantir Must Survive
OBJECTIVE_PRI_03 = 'OBJECTIVE_PRI_03'; -- Find Orc Leader and make a deal
OBJECTIVE_PRI_04 = 'OBJECTIVE_PRI_04'; -- Find a way across the river on the north-west
OBJECTIVE_SEC_01 = 'OBJECTIVE_SEC_01'; -- Build All Defense Structures In Town
OBJECTIVE_SEC_02 = 'OBJECTIVE_SEC_02'; -- Capture All Gold Mines
OBJECTIVE_SEC_03 = 'OBJECTIVE_SEC_03'; -- Find Demons Portal
OBJECTIVE_SEC_04 = 'OBJECTIVE_SEC_04'; -- Destroy Portal

---------------------------------------------------------------------------------------------------
----------------------------- VARIABLES  ---------------------------------------------------
---------------------------------------------------------------------------------------------------

DUNGEON_TRAP_STARTED = 0;
ORC_GUARDIAN_ATTACKED = 0;
ORC_GUARDIAN_KILLED = 0;
INFERNO_PORTAL_DESTROYED = 0;
INFERNO_PORTAL_GUARD_01_DEAD = 0;
INFERNO_PORTAL_GUARD_02_DEAD = 0;
ALL_GOLD_MINES_CAPTURED = 0;
GOLD_MINE_01_CAPTURED = 0;
GOLD_MINE_02_CAPTURED = 0;
GOLD_MINE_03_CAPTURED = 0;
GOLD_MINE_04_CAPTURED = 0;
GOLD_MINE_05_CAPTURED = 0;
GOLD_MINE_06_CAPTURED = 0;
HERO_NAME_ACTIVE_01 = 0;
HERO_NAME_ACTIVE_02 = 0;
DEFENSIVE_STRUCTURES_BUILT = 0;
ROAD_BLOCK_DESTROYED = 0;
MOCHAB_TRACE_FOUND = 0;
DIFF_RATE = 0;
AI_WAKE_UP_DATE = 0;

---------------------------------------------------------------------------------------------------
----------------------------- START MAP SETTINGS ------------------------------------
---------------------------------------------------------------------------------------------------

--SetObjectEnabled(CREATURE_WIZARD_TRAP_STARTER, nil);
SetObjectEnabled(CREATURE_HAVEN_PRIEST, nil);

SetRegionBlocked('REGION_BLOCK_ORCS_TO_INF', 1, PLAYER_2);
SetRegionBlocked('REGION_BLOCK_ORCS_01', 1, PLAYER_2);
SetRegionBlocked('REGION_BLOCK_ORCS_02', 1, PLAYER_2);
SetRegionBlocked('REGION_BLOCK_ORCS_03', 1, PLAYER_2);

SetRegionBlocked('REGION_BLOCK_INF_TO_SUBTER', 1, PLAYER_4);
SetRegionBlocked('REGION_BLOCK_INF_TO_ORCS', 1, PLAYER_4);
SetRegionBlocked('REGION_BLOCK_INF_TO_HAVEN', 1, PLAYER_4);
SetRegionBlocked('REGION_BLOCK_INF_CREATURE', 1, PLAYER_4);
SetRegionBlocked('REGION_BLOCK_INF_TO_STASH', 1, PLAYER_4);
SetRegionBlocked('REGION_BLOCK_INF_TO_SWAMP', 1, PLAYER_4);
SetRegionBlocked('REGION_BLOCK_WIZARD', 1, PLAYER_4);
SetRegionBlocked('REGION_BLOCK_HILL_FORT', 1, PLAYER_4);
SetRegionBlocked('REGION_AI_BLOCKED_01', 1, PLAYER_4);
SetRegionBlocked('REGION_AI_BLOCKED_02', 1, PLAYER_4);
SetRegionBlocked('REGION_BLOCK_INF_01', 1, PLAYER_4);
SetRegionBlocked('REGION_BLOCK_INF_02', 1, PLAYER_4);
SetRegionBlocked('REGION_BLOCK_INF_03', 1, PLAYER_4);
SetRegionBlocked('REGION_FOR_ARANTIR_TELEPORTING', not nil, PLAYER_1);
SetRegionBlocked('REGION_FOR_ARANTIR_TELEPORTING', not nil, PLAYER_2);
SetRegionBlocked('REGION_FOR_ARANTIR_TELEPORTING', not nil, PLAYER_3);
SetRegionBlocked('REGION_FOR_ARANTIR_TELEPORTING', not nil, PLAYER_4);

SetRegionBlocked('REGION_BLOCK_HAVEN_TO_INF', 1, PLAYER_3);
SetRegionBlocked('REGION_BLOCK_HAVEN_TO_SUBTER', 1, PLAYER_3);
--SetRegionBlocked('REGION_BLOCK_HAVEN_TO_NECRO', 1, PLAYER_3);
SetRegionBlocked('REGION_BLOCK_HAVEN_01', 1, PLAYER_3);
SetRegionBlocked('REGION_BLOCK_HAVEN_02', 1, PLAYER_3);
SetRegionBlocked('REGION_BLOCK_HAVEN_03', 1, PLAYER_3);
SetRegionBlocked('REGION_BLOCK_HAVEN_04', 1, PLAYER_3);

--OpenCircleFog(22, 108, 0, 5, 1); -- OpenCircleFog

EnableHeroAI(HERO_AI_ORC_TRAP, nil);
EnableHeroAI(HERO_AI_ORC_KUJIN, nil);
EnableHeroAI(HERO_AI_ORC_GUARD, nil);

--EnableAIHeroHiring(PLAYER_2, ORC_TOWN_01, nil);
--EnableAIHeroHiring(PLAYER_2, ORC_TOWN_02, nil);
EnableAIHeroHiring(PLAYER_2, TOWN_FINAL_ORC, nil);

DenyAIHeroFlee(HERO_PLAYER_MAIN, 1);
DenyAIHeroFlee(HERO_PLAYER_SEC, 1);

SetHeroesExpCoef( 0.5 );

--*-- Artifacts Sets Loading--*--
function f_artifacts_sets()
	InitAllSetArtifacts( "A2C1M4", HERO_PLAYER_MAIN, HERO_PLAYER_SEC );
	LoadHeroAllSetArtifacts( HERO_PLAYER_MAIN, "A2C1M3");
	LoadHeroAllSetArtifacts( HERO_PLAYER_SEC, "A2C1M3");
end;

startThread( f_artifacts_sets );
SetObjectiveState(OBJECTIVE_PRI_04, OBJECTIVE_ACTIVE, PLAYER_1); -- OBJECTIVE - DESTROY DEMONS - ACTIVE

BlockTownGarrisonForAI(TOWN_INFERNO, not nil);

---------------------------------------------------------------------------------------------------
----------------------------- FUNCTIONS ---------------------------------------------------
---------------------------------------------------------------------------------------------------

---------------------------------------------------------------------------------------------------
-- Function Name: f_setup_difficulty() 
-- Description: This function calculates the coefficient for AI army deployment depending on the chosen difficulty level.
---------------------------------------------------------------------------------------------------

function f_setup_difficulty()
	DIFFICULTY = GetDifficulty();
	if DIFFICULTY == DIFFICULTY_EASY then
		DIFF_RATE = 3;
	elseif DIFFICULTY == DIFFICULTY_NORMAL then
		DIFF_RATE = 3;
	elseif DIFFICULTY == DIFFICULTY_HARD then
		DIFF_RATE = 2;
	elseif DIFFICULTY == DIFFICULTY_HEROIC then
		DIFF_RATE = 1;
	end;
	print('=Logfile_A2C1M4=.txt', 'Difficulty = ', DIFFICULTY);
end;

--*-- NEW DAY FUNCTION --*--

function H55_TriggerDaily()
	if (GetDate( DAY_OF_WEEK ) == 4) then
		if (INFERNO_PORTAL_DESTROYED == 0) then
			print('=Logfile_A2C1M4=.txt',"Today is 4-th day of the week!");
			startThread( f_deploy_ai_hero_01 );
			--sleep(10);
		end;
	else
		print('=Logfile_A2C1M4=.txt',"Today is NOT the 4-th day of the week!");
	end;
	
	f_setup_difficulty();

	
	AI_WAKE_UP_DATE = DIFF_RATE*6;
	
	if (GetDate( DAY ) == AI_WAKE_UP_DATE) then
		print("Today is ", AI_WAKE_UP_DATE, " day, Player 2 is now ACTIVE!");
		--EnableAIHeroHiring(PLAYER_2, ORC_TOWN_01, 1);
		--EnableAIHeroHiring(PLAYER_2, ORC_TOWN_02, 1);
		EnableAIHeroHiring(PLAYER_2, TOWN_FINAL_ORC, 1);
	end;
	if new_day_check == 1 then
		startThread( orcish_harass );
	end;
end;

function player_2_hero_check()
	heroes = GetPlayerHeroes( PLAYER_2 );
	print( "Player 2 active heroes are ", heroes );
	for i,hero in heroes do 
		if hero ~= HERO_AI_ORC_KUJIN then
			MakeHeroReturnToTavernAfterDeath( hero, not nil );
			print( "Hero ", hero, " will be in tavern after death" );
		end;
	end;
	print( "Heroes checked" );
end;

Trigger( PLAYER_ADD_HERO_TRIGGER, PLAYER_2, "player_2_hero_check" );
	
---------------------------------------------------------------------------------------------------------------
-- Description: This part deploys AI orcish heroes on the map and defines his attractor level to player's town.
---------------------------------------------------------------------------------------------------------------

sound_played = 0;
day_count = 7;
harass_start = 0;
new_day_check = 0;
ActiveEnemyHero = "Hero8"
diff = 0;
setup_once = 0;

function FinalTownSetUp()
	for creatureID = 1, CREATURES_COUNT - 1 do 
		CreatureSetUp = GetObjectCreatures( TOWN_FINAL_ORC, creatureID );
		if GetObjectCreatures( TOWN_FINAL_ORC, creatureID ) > 2 then
			RemoveObjectCreatures( TOWN_FINAL_ORC, creatureID, CreatureSetUp );
			AddObjectCreatures( TOWN_FINAL_ORC, creatureID, CreatureSetUp + CreatureSetUp * diff );
		end;
	end;
end;

function orcish_harass_difficulty()
	if GetDifficulty() == DIFFICULTY_EASY then
		diff = 2;
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		diff = 2;
	elseif GetDifficulty() == DIFFICULTY_HARD then
		diff = 3;
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		diff = 4;
	end;
	print( diff );
	FinalTownSetUp();
	startThread( first_orc_deploy );
end;

function first_orc_deploy()
	while 1 do
		if harass_start == 1 then
			setup_once = 1;
			DeployReserveHero( ActiveEnemyHero, 21, 37, GROUND );
			print( "first Orc has been deployed" );
			sleep( 3 );
			SetHeroRoleMode( ActiveEnemyHero, HERO_ROLE_MODE_FREEMAN  );
			enemy_heroes_setup();
			new_day_check = 1;
			print( "while 1 do closed" );
			break;
		end;
	sleep( 3 );	
	end;
end;

function orcish_harass()
	if GetDate( DAY ) == day_count + 7 and DEFENSIVE_STRUCTURES_BUILT ~= 1 then
		day_count = GetDate( DAY );
		print( "day count = ", day_count )
		orcish_raiders();
	end;
	local tx,ty,tlevel = GetObjectPosition( ActiveEnemyHero );	
	if GetObjectiveState( OBJECTIVE_SEC_01 ) == OBJECTIVE_ACTIVE then	
		if IsHeroAlive( ActiveEnemyHero ) == not nil then
			if CanMoveHero( ActiveEnemyHero, 117, 13, GROUND ) then
				print( "CanMoveHero move" );
				MoveHero( ActiveEnemyHero, 117, 13, GROUND );
				print( "MoveHero move" );
			else
				print( "else, MoveHero at current position" )
				MoveHero( ActiveEnemyHero, tx, ty, tlevel );
			end;
		end;
	elseif GetObjectiveState( OBJECTIVE_SEC_01 ) == OBJECTIVE_COMPLETED then
		SetAIHeroAttractor( PLAYER_HERO, ActiveEnemyHero, 1 );
	end;
end;

function enemy_heroes_setup()
	print( "enemy_heroes_setup started" ); 
	if setup_once == 1 then	
		for creatureID = CREATURE_GOBLIN, CREATURE_CYCLOP_BLOODEYED do 
			CreatureSetUp = GetHeroCreatures( ActiveEnemyHero, creatureID );
			if GetHeroCreatures( ActiveEnemyHero, creatureID ) > 2 then
				RemoveHeroCreatures( ActiveEnemyHero, creatureID, CreatureSetUp );
				AddHeroCreatures( ActiveEnemyHero, creatureID, CreatureSetUp * diff );
			end;
		end;
		setup_once = 0;
		ChangeHeroStat( ActiveEnemyHero, STAT_EXPERIENCE, ( 1000 + day_count * 100 ) * diff );
		if GetObjectiveState( OBJECTIVE_SEC_01 ) == OBJECTIVE_ACTIVE then
			SetAIHeroAttractor( PLAYER_TOWN_01, ActiveEnemyHero, 2 );
		end;
		print( "Lock'n'Load ", ActiveEnemyHero ); 
		print( "setup_once = ", setup_once ); 
		
	end;
end;

function orcish_raiders()
	if GetObjectiveState( OBJECTIVE_SEC_01 ) == OBJECTIVE_ACTIVE then	
		if IsHeroAlive( ActiveEnemyHero ) == nil then
			if ActiveEnemyHero == "Hero8" then
				ActiveEnemyHero = "Hero4"
			elseif ActiveEnemyHero == "Hero4" then
				ActiveEnemyHero = "Hero1"
			elseif ActiveEnemyHero == "Hero1" then
				ActiveEnemyHero = "Hero6"
			elseif ActiveEnemyHero == "Hero6" then
				ActiveEnemyHero = "Hero8"
			end;
			DeployReserveHero( ActiveEnemyHero, 21, 37, GROUND );
			setup_once = 1;
			sleep( 2 );
			SetHeroRoleMode( ActiveEnemyHero, HERO_ROLE_MODE_FREEMAN  );
			enemy_heroes_setup();
		end;
	end;
end;

orcish_harass_difficulty();	

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_hero_01()
-- Description: This function deploys first AI hero on the map and defines his attractor level to player's town.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_hero_01()

--*-- This function part defines local variables: hero name + hero deployment location --*--
	local HERO_NAME_1 = HERO_AI_INFERNO_01;
	local START_X = 111;
	local START_Y = 114;
	local START_FLOOR = 1;
	local DEPLOY_HERO_01 = 0;

--*-- This function part checks this hero state --*--
--*-- If this hero still alive, the next attack wave is not deployed, and this hero gets a maximum attractor level --*--
if (IsObjectExists(HERO_NAME_1) ~= nil) then
		if CanMoveHero( HERO_NAME_1, 117, 13, 0 ) then	
			MoveHero( HERO_NAME_1, 117, 13, 0 );
		end;
		sleep(5);
		DEPLOY_HERO_01 = 0;
	else
		HERO_NAME_ACTIVE_01 = HERO_NAME_1;
		DEPLOY_HERO_01 = 1;
	end;

--*-- This function part deploys AI hero on the map --*--
	if (DEPLOY_HERO_01 == 1) then
		DeployReserveHero(HERO_NAME_ACTIVE_01, START_X, START_Y, START_FLOOR);
		sleep(10);
		if sound_played == 0 then
			--Play2DSound( "/Sounds/_(Sound)/Heroes/Biara/Happy.xdb#xpointer(/Sound)" ) -- C1M4_VO2
			sound_played =1	
		end;

--*-- This function part defines the attractor level for this AI hero --*--
		if (random(2) ~= 0) then
			--MoveHero( HERO_NAME_ACTIVE_01, 117, 13, 0 );
			SetAIHeroAttractor(PLAYER_TOWN_01, HERO_NAME_ACTIVE_01, 2);
		else
			SetAIHeroAttractor(PLAYER_TOWN_01, HERO_NAME_ACTIVE_01, 1);
		end;
		sleep(5);
	else
		print_to('=Logfile_A2C1M4=.txt',"This time attack will not be sent!");
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_hero_02()
-- Description: This function deploys first AI hero on the map and defines his attractor level to player's town.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_hero_02()

--*-- This function part defines local variables: hero name + hero deployment location --*--
	local HERO_NAME_2 = HERO_AI_INFERNO_02;
	local START_X = 110;
	local START_Y = 114;
	local START_FLOOR = 1;
	local DEPLOY_HERO_02 = 0;

--*-- This function part checks this hero state --*--
--*-- If this hero still alive, the next attack wave is not deployed, and this hero gets a maximum attractor level --*--
if (IsObjectExists(HERO_NAME_2) ~= nil) then
		MoveHero( HERO_NAME_2, 117, 13, 0 );
		sleep(5);
		DEPLOY_HERO_02 = 0;
	else
		HERO_NAME_ACTIVE_02 = HERO_NAME_2;
		DEPLOY_HERO_02 = 1;
	end;

--*-- This function part deploys AI hero on the map --*--
	if (DEPLOY_HERO_02 == 1) then
		DeployReserveHero(HERO_NAME_ACTIVE_02, START_X, START_Y, START_FLOOR);
		sleep(10);

--*-- This function part defines the attractor level for this AI hero --*--
		if (random(2) ~= 0) then
			MoveHero( HERO_NAME_ACTIVE_02, 117, 13, 0 );
		else
			SetAIHeroAttractor(PLAYER_TOWN_01, HERO_NAME_ACTIVE_02, 1);
		end;
		sleep(5);
	else
		print_to('=Logfile_A2C1M4=.txt',"This time attack will not be sent!");
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_wizard_trap_start()
-- Description: This function launches the sub-quest about the dungeon passage under the Inferno Garrison.
---------------------------------------------------------------------------------------------------

ox = 0;
oy = 0;
olevel = 0;
TemporaryHero = ""

oxm = 0;
oym = 0;
olevelm = 0;

oxs = 0;
oys = 0;
olevels = 0;

pass = 0;

function f_wizard_trap_start( HERO_NAME )
	--if (IsObjectInRegion(HERO_PLAYER_MAIN, "REGION_WIZARD_CHAT") ~= 0) then
	if (GetObjectOwner( HERO_NAME ) == PLAYER_1) then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_WIZARD_CHAT", nil);
		if HERO_NAME == HERO_PLAYER_SEC then
			TemporaryHero = HERO_PLAYER_MAIN;
			ox,oy,olevel = GetObjectPosition( TemporaryHero );
			SetObjectRotation( TemporaryHero, 180 );
			SetObjectPosition( TemporaryHero, 68, 66, GROUND );
		elseif HERO_NAME == HERO_PLAYER_MAIN then
			TemporaryHero = HERO_PLAYER_SEC;
			ox,oy,olevel = GetObjectPosition( TemporaryHero );
			SetObjectRotation( TemporaryHero, 180 );
			SetObjectPosition( TemporaryHero, 68, 66, GROUND );
		elseif HERO_NAME ~= HERO_PLAYER_MAIN and HERO_NAME ~= HERO_PLAYER_SEC then
			pass = 1;
			oxm,oym,olevelm = GetObjectPosition( HERO_PLAYER_MAIN );
			oxs,oys,olevels = GetObjectPosition( HERO_PLAYER_SEC );
			SetObjectRotation( HERO_PLAYER_MAIN, 90 );
			SetObjectPosition( HERO_PLAYER_MAIN, 67, 68, GROUND );
			SetObjectRotation( HERO_PLAYER_SEC, 180 );
			SetObjectPosition( HERO_PLAYER_SEC, 68, 66, GROUND );
		end;
		DUNGEON_TRAP_STARTED = 1; -- Dungeon Trap Started = 1
		SetObjectEnabled(CREATURE_WIZARD_TRAP_STARTER, 1); -- Wizard Unblocked (can be attacked now)
		--MessageBox("/Maps/Scenario/A2C1M4/messagebox_01.txt"); -- MESSAGEBOX
		StartAdvMapDialog( 2, "f_show_dungeon_entrance" ); -- DIALOG SCENE - About Underground passage
	end;
end;

function UndoPosition()
	SetObjectPosition( HERO_PLAYER_MAIN, oxm, oym, olevelm );
	SetObjectPosition( HERO_PLAYER_SEC, oxs, oys, olevels );
end;	

function f_show_dungeon_entrance()
	startThread( voice_over_8 );
	OpenCircleFog(8, 10, 0, 5, 1); -- OpenCircleFog
	sleep(2);
	MoveCamera(9, 12, 0, 50, 1, 2.5, 0, 0, 1);
	sleep(20);
	MoveCamera(68, 68, 0, 40, 1, 5, 0, 0, 1);
	if TemporaryHero == HERO_PLAYER_MAIN or TemporaryHero == HERO_PLAYER_SEC then	
		SetObjectPosition( TemporaryHero, ox, oy, olevel );
	end;
	if pass == 1 then
		UndoPosition();
	end;
end;

function voice_over_8()
	Play2DSound( "/Maps/Scenario/A2C1M4/C1M4_VO8_Arantir_01sound.xdb#xpointer(/Sound)" );
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_first_orc_combat_start()
-- Description: This function launches the combat with Orc Guardian.
---------------------------------------------------------------------------------------------------

function f_first_orc_combat_start()
	ORC_GUARDIAN_ATTACKED = 1; -- Orc Guardian Attacked = 1
	f_first_orc_combat_check();
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_first_orc_combat_result()
-- Description: This function launches at the final of combat with Orc Guardian.
---------------------------------------------------------------------------------------------------

function f_first_orc_combat_result()
	ORC_GUARDIAN_KILLED = 1; -- Orc Guardian Killed = 1
	sleep(1);
end;

function f_first_orc_combat_check()
	while (ORC_GUARDIAN_KILLED ~= 1) do
		if (IsObjectExists(CREATURE_FIRST_ORC_ENCOUNTER) ~= 1) then
			f_first_orc_combat_result();
		else
			print('=Logfile_A2C1M4=.txt', 'Orc Guardian is STILL ALIVE!');
		end;
		sleep(10);
	end;
end;

function f_defensive_structures_check()
	while (DEFENSIVE_STRUCTURES_BUILT ~= 1) do
		if (GetObjectiveState(OBJECTIVE_SEC_01, PLAYER_1) == OBJECTIVE_ACTIVE) then
			if (GetTownBuildingLevel(PLAYER_TOWN_01, TOWN_BUILDING_FORT) >= 3) and (GetObjectOwner(PLAYER_TOWN_01) == PLAYER_1) then
				DEFENSIVE_STRUCTURES_BUILT = 1;
				SetObjectiveState(OBJECTIVE_SEC_01, OBJECTIVE_COMPLETED, PLAYER_1); -- Objective Completed - Build All Defensive Structures in Main Town
				ChangeHeroStat(HERO_PLAYER_MAIN, STAT_EXPERIENCE, 3000);
				MessageBox("/Maps/Scenario/A2C1M4/messagebox_006.txt");
				SetRegionBlocked( "REGION_BLOCK_AI", not nil, PLAYER_2);
				SetRegionBlocked( "REGION_BLOCK_AI", not nil, PLAYER_3);
				startThread( voice_over_6 );
			else
				--print('=Logfile_A2C1M4=.txt', 'All Defensive Strutcures are NOT BUILT!');
			end;
		end;
		sleep(5);
	end;
end;

function voice_over_6()
	Play2DSound( "/Maps/Scenario/A2C1M4/C1M4_VO6_Arantir_01sound.xdb#xpointer(/Sound)" );
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_destroy_inferno_portal()
-- Description: This function launches the destruction of Inferno Portal.
---------------------------------------------------------------------------------------------------

function f_destroy_inferno_portal()
	INFERNO_PORTAL_DESTROYED = 1; -- Inferno Portal Destroyed = 1
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	PlayVisualEffect("/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", PORTAL_INFERNO, 0, 0.5);-- Animation Effect - Big Explosion
	PlayVisualEffect("/Effects/_(Effect)/Characters/Creatures/Academy/Titan/idle00.xdb#xpointer(/Effect)", PORTAL_INFERNO, 0, 0.5);-- Animation Effect - Small Explosion
	RemoveObject(PORTAL_FIRE_01); -- Remove Inferno Fire 01
	RemoveObject(PORTAL_FIRE_02); -- Remove Inferno Fire 02
		if (GetObjectiveState(OBJECTIVE_SEC_04, PLAYER_1) == OBJECTIVE_ACTIVE) then
			SetObjectiveState(OBJECTIVE_SEC_04, OBJECTIVE_COMPLETED, PLAYER_1); -- Objective Completed - Find Inferno Portal
		else
			SetObjectiveState(OBJECTIVE_SEC_04, OBJECTIVE_ACTIVE, PLAYER_1); -- Objective Completed - Find Inferno Portal
			sleep(5);
			SetObjectiveState(OBJECTIVE_SEC_04, OBJECTIVE_COMPLETED, PLAYER_1); -- Objective Completed - Find Inferno Portal
		end;
	sleep(1);
	Trigger(OBJECT_TOUCH_TRIGGER, PORTAL_INFERNO, 'f_portal_message_01'); -- Object Touch Trigger on Inferno Portal - Messagebox function
	-- Dialogscene (?)
	sleep(2);
	startThread( voice_over_4 );
end;

function voice_over_4()
	Play2DSound( "/Maps/Scenario/A2C1M4/C1M4_VO4_Arantir_01sound.xdb#xpointer(/Sound)" );
end;

function f_destroy_portal_guard_01()
	INFERNO_PORTAL_GUARD_01_DEAD = 1;
	PlayVisualEffect("/Effects/_(Effect)/Spells/LandMineHit.xdb#xpointer(/Effect)", PORTAL_GATING_01);-- Animation Effect - Small Explosion
	RemoveObject(PORTAL_GATING_01); -- Remove Portal Key 01 fire
	RemoveObject(PORTAL_CRYSTAL_01); -- Remove Portal Key 01 fire
	sleep(2);
	f_inferno_portal_guards_check();
end;

function f_destroy_portal_guard_02()
	INFERNO_PORTAL_GUARD_02_DEAD = 1;
	PlayVisualEffect("/Effects/_(Effect)/Spells/LandMineHit.xdb#xpointer(/Effect)", PORTAL_GATING_02);-- Animation Effect - Small Explosion
	RemoveObject(PORTAL_GATING_02); -- Remove Portal Key 02 fire
	RemoveObject(PORTAL_CRYSTAL_02); -- Remove Portal Key 02 fire
	sleep(2);
	f_inferno_portal_guards_check();
end;

function f_inferno_portal_guards_check()
	if (IsObjectExists(PORTAL_GUARD_01) ~= 1) and (IsObjectExists(PORTAL_GUARD_02) ~= 1) then
		print('=Logfile_A2C1M4=.txt', 'BOTH Portal Guardians are DEAD!');
		f_destroy_inferno_portal();
	else
		print('=Logfile_A2C1M4=.txt', 'Portal Guardians are STILL ALIVE!');
	end;
	sleep(5);
end;

function f_portal_message_01()
	MessageBox("/Maps/Scenario/A2C1M4/messagebox_02.txt"); -- MESSAGEBOX
end;
---------------------------------------------------------------------------------------------------
-- Function Name: f_player_main_hero_death()
-- Description: This function launches the check of Arantir's death. If he is dead - the player fails this mission.
---------------------------------------------------------------------------------------------------

function f_player_main_hero_death()
	if (IsObjectExists(HERO_PLAYER_MAIN) ~= nil) then -- If Arantir Exists ~= 0 then (alive)
		print('=Logfile_A2C1M4=.txt', 'Arantir is STILL ALIVE!');
	else
		print('=Logfile_A2C1M4=.txt', 'Arantir is DEAD!');
		SetObjectiveState(OBJECTIVE_PRI_02, OBJECTIVE_FAILED, PLAYER_1); -- Objective Failed - Arantir and Ornella must survive
		Lose();
	end;
	if (IsObjectExists(HERO_PLAYER_SEC) ~= nil) then -- If Arantir Exists ~= 0 then (alive)
		print('=Logfile_A2C1M4=.txt', 'Ornella is STILL ALIVE!');
	else
		print('=Logfile_A2C1M4=.txt', 'Ornella is DEAD!');
		SetObjectiveState(OBJECTIVE_PRI_02, OBJECTIVE_FAILED, PLAYER_1); -- Objective Failed - Arantir and Ornella must survive
		Lose();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_enemy_hero_trap()
-- Description: This function launches the deployment of enemy hero in subterrain passage, behind the player's hero.
---------------------------------------------------------------------------------------------------

function f_deploy_enemy_hero_trap(HERONAME)
--*-- This function part defines local variables: hero name + hero deployment location --*--
	local HERO_NAME_3 = HERO_AI_INFERNO_03;
	local START_X = 97;
	local START_Y = 51;
	local START_FLOOR = 1;
	local DEPLOY_HERO_02 = 0;
	
	print('=Logfile_A2C1M4=.txt', 'Enemy Hero Trap is deployed!');
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_TRAP_SUBTERRAIN", nil);-- Disable Region Enter Trigger - so trap cannot be launched several times

	print_to('=Logfile_A2C1M4=.txt',"This hero will be ", HERO_NAME_3);
	MoveCamera(97, 51, 1, 30, 1, 5.5, 0, 0, 0); -- MoveCamera there
	sleep(1);
	DeployReserveHero(HERO_NAME_3, START_X, START_Y, START_FLOOR); -- DeployReserveHero - location - underground passage not far from Trap Region, so player's hero cannot evade the combat.
	sleep(1);
	PlayVisualEffect("/Effects/_(Effect)/Spells/DimesionDoorEnd.xdb#xpointer(/Effect)", HERO_NAME_3, 0, 0.5); -- PlayVisualEffect on Hero's location - Dimensional Gate Exit
	print_to('=Logfile_A2C1M4=.txt', HERO_NAME_3, "'s attractor level is 2");
	SetAIHeroAttractor(HERONAME, HERO_NAME_3, 2); -- Set attractor on hero, that entered Trap Region - HIGH.
	startThread( voice_over_9 );
end;

function voice_over_9()
	Play2DSound( "/Maps/Scenario/A2C1M4/C1M4_VO9_Arantir_01sound.xdb#xpointer(/Sound)" );
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_disable_trap_region()
-- Description: This function disables the functionality of Trap Start Region.
---------------------------------------------------------------------------------------------------

function f_disable_trap_region()
	print('=Logfile_A2C1M4=.txt', 'Trap Region is disabled!');
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_TRAP_SUBTERRAIN", nil); -- Disable Region Enter Trigger - so trap cannot be launched several times
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_objective_destroy_inferno_portal()
-- Description: This function gives the objective - destruction of Inferno Portal.
---------------------------------------------------------------------------------------------------

function f_objective_destroy_inferno_portal(HERO_NAME)
	if (GetObjectOwner(HERO_NAME) == PLAYER_1) then
		if (GetObjectiveState(OBJECTIVE_SEC_04, PLAYER_1) == OBJECTIVE_ACTIVE) then
			SetObjectiveState(OBJECTIVE_SEC_04, OBJECTIVE_COMPLETED, PLAYER_1); -- Objective Completed - Find Inferno Portal
		else
			SetObjectiveState(OBJECTIVE_SEC_04, OBJECTIVE_ACTIVE, PLAYER_1); -- Objective Completed - Find Inferno Portal
			sleep(5);
			SetObjectiveState(OBJECTIVE_SEC_04, OBJECTIVE_COMPLETED, PLAYER_1); -- Objective Completed - Find Inferno Portal
		end;	
	else
		print('=Logfile_A2C1M4=.txt', 'Some other hero has entered trigger region!');
	end;
end;

--*-----------------------------------------------------------*--
--*-- FUNCTION SET: SECONDARY QUESTS --*--
--*-----------------------------------------------------------*--

--*-- QUEST 3: Capture and hold all gold mines to get the bonus.
--*-- QUEST 3 DESCRIPTION: Capture and hold all four gold mines to get additional bonus +5000 gold per day. If any mine lost - bonus is cancelled until all four mines are captured again. Bonus works only for human player.

---------------------------------------------------------------------------------------------------
-- Function Name: f_capture_gold_mine_01()
-- Description: This function checks the state of gold mine #1.
---------------------------------------------------------------------------------------------------

function f_capture_gold_mine_01()
	if (GetObjectOwner('GOLD_MINE_01') == 1) then
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹1 belongs to player: 1");
		GOLD_MINE_01_CAPTURED = 1;
		SetAIPlayerAttractor('GOLD_MINE_01', PLAYER_2, 2);
		f_gold_mines_quest_check();
		sleep(1);
	else
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹1 DOES NOT belong to player: 1");
		GOLD_MINE_01_CAPTURED = 0;
		SetAIPlayerAttractor('GOLD_MINE_01', PLAYER_2, 0);
		f_gold_mines_quest_not_completed();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_capture_gold_mine_02()
-- Description: This function checks the state of gold mine #2.
---------------------------------------------------------------------------------------------------

function f_capture_gold_mine_02()
	if (GetObjectOwner('GOLD_MINE_02') == 1) then
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹2 belongs to player: 1");
		GOLD_MINE_02_CAPTURED = 1;
		SetAIPlayerAttractor('GOLD_MINE_02', PLAYER_2, 2);
		f_gold_mines_quest_check();
		sleep(1);
	else
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹2 DOES NOT belong to player: 1");
		GOLD_MINE_02_CAPTURED = 0;
		SetAIPlayerAttractor('GOLD_MINE_02', PLAYER_2, 0);
		f_gold_mines_quest_not_completed();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_capture_gold_mine_03()
-- Description: This function checks the state of gold mine #3.
---------------------------------------------------------------------------------------------------

function f_capture_gold_mine_03()
	if (GetObjectOwner('GOLD_MINE_03') == 1) then
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹3 belongs to player: 1");
		GOLD_MINE_03_CAPTURED = 1;
		SetAIPlayerAttractor('GOLD_MINE_03', PLAYER_2, 2);
		f_gold_mines_quest_check();
		sleep(1);
	else
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹3 DOES NOT belong to player: 1");
		GOLD_MINE_03_CAPTURED = 0;
		SetAIPlayerAttractor('GOLD_MINE_03', PLAYER_2, 0);
		f_gold_mines_quest_not_completed();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_capture_gold_mine_04()
-- Description: This function checks the state of gold mine #4.
---------------------------------------------------------------------------------------------------

function f_capture_gold_mine_04()
	if (GetObjectOwner('GOLD_MINE_04') == 1) then
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹4 belongs to player: 1");
		GOLD_MINE_04_CAPTURED = 1;
		SetAIPlayerAttractor('GOLD_MINE_04', PLAYER_2, 2);
		f_gold_mines_quest_check();
		sleep(1);
	else
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹4 DOES NOT belong to player: 1");
		GOLD_MINE_04_CAPTURED = 0;
		SetAIPlayerAttractor('GOLD_MINE_04', PLAYER_2, 0);
		f_gold_mines_quest_not_completed();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_capture_gold_mine_05()
-- Description: This function checks the state of gold mine #5.
---------------------------------------------------------------------------------------------------

function f_capture_gold_mine_05()
	if (GetObjectOwner('GOLD_MINE_05') == 1) then
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹5 belongs to player: 1");
		GOLD_MINE_05_CAPTURED = 1;
		SetAIPlayerAttractor('GOLD_MINE_05', PLAYER_2, 2);
		f_gold_mines_quest_check();
		sleep(1);
	else
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹5 DOES NOT belong to player: 1");
		GOLD_MINE_05_CAPTURED = 0;
		SetAIPlayerAttractor('GOLD_MINE_05', PLAYER_2, 0);
		f_gold_mines_quest_not_completed();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_capture_gold_mine_06()
-- Description: This function checks the state of gold mine #6.
---------------------------------------------------------------------------------------------------

function f_capture_gold_mine_06()
	if (GetObjectOwner('GOLD_MINE_06') == 1) then
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹6 belongs to player: 1");
		GOLD_MINE_06_CAPTURED = 1;
		SetAIPlayerAttractor('GOLD_MINE_06', PLAYER_2, 2);
		f_gold_mines_quest_check();
		sleep(1);
	else
		print('=Logfile_A2C1M4=.txt',"Gold mine ¹6 DOES NOT belong to player: 1");
		GOLD_MINE_06_CAPTURED = 0;
		SetAIPlayerAttractor('GOLD_MINE_06', PLAYER_2, 0);
		f_gold_mines_quest_not_completed();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_gold_mines_quest_check()
-- Description: This function checks the state of all gold mines. If all mines captured - secondary objective completed.
---------------------------------------------------------------------------------------------------

function f_gold_mines_quest_check()
	if (GOLD_MINE_01_CAPTURED == 1) and (GOLD_MINE_02_CAPTURED == 1) and (GOLD_MINE_03_CAPTURED == 1) and (GOLD_MINE_04_CAPTURED == 1) and (GOLD_MINE_05_CAPTURED == 1)and (GOLD_MINE_06_CAPTURED == 1) then
		ALL_GOLD_MINES_CAPTURED = 1;
		f_gold_mines_quest_completed();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_gold_mines_quest_completed()
-- Description: This function sets secondary objective completed.
---------------------------------------------------------------------------------------------------

function f_gold_mines_quest_completed()
	if (GetObjectiveState(OBJECTIVE_SEC_02, PLAYER_1) ~= 3) then
		SetObjectiveState(OBJECTIVE_SEC_02, OBJECTIVE_COMPLETED, PLAYER_1);
		print('=Logfile_A2C1M4=.txt','Objective "Gold Mines" completed');
		SetGameVar("BONUS_A2C1M4", "1");
		MessageBox("/Maps/Scenario/A2C1M4/messagebox_008.txt"); -- MESSAGEBOX - You have captured all gold mines!
		startThread( voice_over_7 );
	else
		print('=Logfile_A2C1M4=.txt','Objective "Gold Mines" already completed');
	end;
end;

function voice_over_7()
	Play2DSound( "/Maps/Scenario/A2C1M4/C1M4_VO7_Arantir_01sound.xdb#xpointer(/Sound)" );
end;	

---------------------------------------------------------------------------------------------------
-- Function Name: f_gold_mines_quest_not_completed()
-- Description: This function sets secondary objective un-completed, if any gold mine does not belong to player.
---------------------------------------------------------------------------------------------------

function f_gold_mines_quest_not_completed()
	if (GetObjectiveState(OBJECTIVE_SEC_02, PLAYER_1) == 3) then
		ALL_GOLD_MINES_CAPTURED = 0;
		SetObjectiveState(OBJECTIVE_SEC_02, OBJECTIVE_ACTIVE, PLAYER_1);
		print('=Logfile_A2C1M4=.txt','Objective "Gold Mines" UNcompleted');
		SetGameVar("BONUS_A2C1M4", "0");
	else
		print('=Logfile_A2C1M4=.txt','Objective "Gold Mines" already UNcompleted');
	end;
end;

function f_mission_completed()
	if (GetObjectOwner(TOWN_FINAL_ORC) == PLAYER_1) then
		SetObjectiveState(OBJECTIVE_PRI_03, OBJECTIVE_COMPLETED, PLAYER_1);
		print('=Logfile_A2C1M4=.txt','FINAL ORC TOWN CAPTURED!!!');
		StartDialogScene("/DialogScenes/A2C1/M4/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end;
end;

function f_autosave()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_AUTOSAVE", nil);
	Save("Autosave");
end;

function f_objective_defeat_orcs( heroName )
	if (GetObjectOwner( heroName ) == PLAYER_1) then
		SetObjectiveState(OBJECTIVE_PRI_01, OBJECTIVE_COMPLETED, PLAYER_1);
		SetObjectiveState(OBJECTIVE_PRI_03, OBJECTIVE_ACTIVE, PLAYER_1);
	end;
end;

TPLAYER_HERO = ""

function f_orc_trap_start( heroName )
	if (GetObjectOwner( heroName ) == PLAYER_1) then
		TPLAYER_HERO = heroName
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_ORC_TRAP_START", nil);
		SetObjectiveState(OBJECTIVE_PRI_03, OBJECTIVE_ACTIVE, PLAYER_1);
		--SetRegionBlocked('REGION_BLOCK_HAVEN_TO_NECRO', nil, PLAYER_3);
		BlockGame();
		startThread( f_orc_trap_start1 );
	end;
end;

function f_orc_trap_start1()
	sleep( 1 );
	EnableHeroAI(HERO_AI_ORC_TRAP,not nil);
	MoveHeroRealTime( HERO_AI_ORC_TRAP, 68, 42, GROUND );
	sleep( 2 );
	MessageBox( "/Maps/Scenario/A2C1M4/messagebox_003.txt", "f_orc_trap_start3" ); -- DIALOG SCENE - Orc Hero jumps from the forest and attacks player hero, shouting a battlecry
end;

--function f_orc_trap_start2()
--	StartAdvMapDialog( 0, "f_orc_trap_start3" ); -- C1M4_AM1
--end;

function f_orc_trap_start3()
	x,y,level = GetObjectPosition( TPLAYER_HERO );
	EnableHeroAI(HERO_AI_ORC_TRAP,not nil);
	ChangeHeroStat(HERO_AI_ORC_TRAP, STAT_MOVE_POINTS, 3000);
	MoveHeroRealTime(HERO_AI_ORC_TRAP, x, y, level);
	--*-- Moving Ornella for Dialog Scene --*--
	sleep(5);
	
	UnblockGame();
	f_orc_trap_start4();
end;

function f_orc_trap_start4()
	x,y,level = GetObjectPosition( TPLAYER_HERO )
	SetObjectiveState(OBJECTIVE_SEC_01, OBJECTIVE_ACTIVE, PLAYER_1);
	if TPLAYER_HERO == HERO_PLAYER_MAIN then
		SetObjectPosition(HERO_PLAYER_SEC, x, y + 3, level);
		sleep(1);
		SetObjectRotation(HERO_PLAYER_SEC, 0);
		f_advmap_dscene();
		print("triggered hero is", TPLAYER_HERO);
	elseif TPLAYER_HERO == HERO_PLAYER_SEC then
		SetObjectPosition(HERO_PLAYER_MAIN, x, y + 3, level);
		sleep(1);
		SetObjectRotation(HERO_PLAYER_MAIN, 0);
		f_advmap_dscene();
		print("triggered hero is", TPLAYER_HERO);
	else
		SetObjectPosition(HERO_PLAYER_MAIN, x - 2, y + 1, level);
		SetObjectPosition(HERO_PLAYER_SEC, x, y + 3, level);
		sleep(1);
		SetObjectRotation(HERO_PLAYER_SEC, 0);
		SetObjectRotation(HERO_PLAYER_SEC, 0);
		f_advmap_dscene();
		print("triggered hero is", TPLAYER_HERO);
	end;
end;

function f_advmap_dscene()
	harass_start = 1;
	StartAdvMapDialog( 3 ); -- C1M4_AM2
end;

function f_objectives_switch()
	if (MOCHAB_TRACE_FOUND == 0) then
		MOCHAB_TRACE_FOUND = 1;	
		startThread( f_objectives_switch_1 );
	end;
end;

function f_objectives_switch_1()
	RazeTown("TOWN_INFERNO");
	MessageBox("/Maps/Scenario/A2C1M4/messagebox_004.txt"); -- DIALOG SCENE - Arantir captures Inferno town, tortures some Infernals and learns, that Mochab went to Flammschreine. Also he learns about the small Portal to Inferno.
	--StartAdvMapDialog( 3, "f_objectives_switch_2" ); -- DialogScene - Player Captures Inferno Town and interrogates some Demons and learns about the Mochab whereabouts.
	f_objectives_switch_2();
	startThread( voice_over_5 );
end;

function voice_over_5()
	Play2DSound( "/Maps/Scenario/A2C1M4/C1M4_VO5_Arantir_01sound.xdb#xpointer(/Sound)" );
end;
	
function f_objectives_switch_2()
	if (GetObjectiveState(OBJECTIVE_PRI_04, PLAYER_1) == OBJECTIVE_UNKNOWN) then
		SetObjectiveState(OBJECTIVE_PRI_04, OBJECTIVE_ACTIVE, PLAYER_1);
		sleep(1);
		SetObjectiveState(OBJECTIVE_PRI_04, OBJECTIVE_COMPLETED, PLAYER_1);
	else
		SetObjectiveState(OBJECTIVE_PRI_04, OBJECTIVE_COMPLETED, PLAYER_1);
	end;

	if (GetObjectiveState(OBJECTIVE_SEC_04, PLAYER_1) == OBJECTIVE_UNKNOWN) then
		MessageBox("/Maps/Scenario/A2C1M4/messagebox_005.txt"); -- DIALOG SCENE - Arantir learns about the small Portal to Inferno.
		--StartAdvMapDialog( 4, "f_objectives_switch_3" ); -- DialogScene - Player Captures Inferno Town and interrogates some Demons and learns about the Portal to Inferno.
		f_objectives_switch_3();
		return
	end;

	sleep(2);
end;

function f_objectives_switch_3()
	SetObjectiveState(OBJECTIVE_SEC_04, OBJECTIVE_ACTIVE, PLAYER_1); -- Objective Active - Find Inferno Portal
	sleep(2);
end;

function f_road_block_check()
	while (ROAD_BLOCK_DESTROYED ~= 1) do
		if (IsObjectExists(CREATURE_BANDIT_ARMY) ~= 1) then
			ROAD_BLOCK_DESTROYED = 1;
			print('=Logfile_A2C1M4=.txt', 'Bandit Army is DEAD!');
			RemoveObject(ITEM_LOG);
			MessageBox("/Maps/Scenario/A2C1M4/messagebox_007.txt"); -- MESSAGEBOX - Arantir kills brigands and cleard the road from the fallen tree.
		end;
		sleep(10);
	end;
end;

function f_objectives_check()
	if (GetObjectiveState(OBJECTIVE_PRI_01, PLAYER_1) == OBJECTIVE_COMPLETED) and (GetObjectiveState(OBJECTIVE_PRI_03, PLAYER_1) == OBJECTIVE_COMPLETED) and (GetObjectiveState(OBJECTIVE_PRI_04, PLAYER_1) == OBJECTIVE_COMPLETED) and (GetObjectiveState(OBJECTIVE_SEC_04, PLAYER_1) == OBJECTIVE_COMPLETED) then
		SaveHeroAllSetArtifactsEquipped( HERO_PLAYER_MAIN, "A2C1M4" );
		SaveHeroAllSetArtifactsEquipped( HERO_PLAYER_SEC, "A2C1M4" );
		sleep(1);
		print('=Logfile_A2C1M4=.txt', 'All PRIMARY Objectives Completed!');
		Win();
	end;
end;

Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, OBJECTIVE_PRI_01, "f_objectives_check" );
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, OBJECTIVE_PRI_03, "f_objectives_check" );
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, OBJECTIVE_PRI_04, "f_objectives_check" );
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, OBJECTIVE_SEC_04, "f_objectives_check" );

BridgeCheck = 0;

pxm = 0;
pym = 0;
plevelm = 0;

pxs = 0;
pys = 0;
plevels = 0;

function f_priest_chat( HERO_NAME )
	if (GetObjectOwner( HERO_NAME ) == PLAYER_1) then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_PRIEST_CHAT", nil);
		if HERO_NAME == HERO_PLAYER_SEC then
			BridgeCheck = 1;
			pxm,pym,plevelm = GetObjectPosition( HERO_PLAYER_MAIN );
			SetObjectPosition( HERO_PLAYER_MAIN, 22, 113, GROUND );
			sleep( 1 );
			SetObjectRotation( HERO_PLAYER_MAIN, 0 );	
		elseif HERO_NAME == HERO_PLAYER_MAIN then
			BridgeCheck = 2;
			pxs,pys,plevels = GetObjectPosition( HERO_PLAYER_SEC );
			SetObjectPosition( HERO_PLAYER_SEC, 22, 113, GROUND );
			sleep( 1 );
			SetObjectRotation( HERO_PLAYER_SEC, 0 );
		elseif HERO_NAME ~= HERO_PLAYER_MAIN and HERO_NAME ~= HERO_PLAYER_SEC then
			BridgeCheck = 3;
			pxm,pym,plevelm = GetObjectPosition( HERO_PLAYER_MAIN );
			pxs,pys,plevels = GetObjectPosition( HERO_PLAYER_SEC );
			SetObjectPosition( HERO_PLAYER_MAIN, 22, 113, GROUND );
			sleep( 1 );
			SetObjectRotation( HERO_PLAYER_MAIN, 80 );
			SetObjectPosition( HERO_PLAYER_SEC, 22, 111, GROUND );
			sleep( 1 );
			SetObjectRotation( HERO_PLAYER_SEC, 100 );
		end;
		priest_chat_complete();
	end;
end;

function priest_chat_complete()
	SetObjectiveState(OBJECTIVE_PRI_01, OBJECTIVE_COMPLETED, PLAYER_1); -- OBJECTIVE - FIND WAY TO FLAMMSCHREINE - COMPLETED
	StartAdvMapDialog( 0, "priest_UndoPosition" ); -- C1M4_AM? - BLUE HAVEN PRIEST ADVMAP DIALOG
end;



function priest_UndoPosition()
	if BridgeCheck == 1 then
		SetObjectPosition( HERO_PLAYER_MAIN, pxm, pym, plevelm );
	elseif BridgeCheck == 2 then
		SetObjectPosition( HERO_PLAYER_SEC, pxs, pys, plevels );
	elseif BridgeCheck == 3 then
		SetObjectPosition( HERO_PLAYER_MAIN, pxm, pym, plevelm );
		SetObjectPosition( HERO_PLAYER_SEC, pxs, pys, plevels );
	end;
end;


function f_demon_invasion(HERO_NAME)
	if (GetObjectOwner(HERO_NAME) == PLAYER_4) then
		--SetObjectiveState(OBJECTIVE_PRI_04, OBJECTIVE_ACTIVE, PLAYER_1); -- OBJECTIVE - DESTROY DEMONS - ACTIVE
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_DEMON_INVASION", nil);
	end;
end;


function f_warning( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		MessageBox("/Maps/Scenario/A2C1M4/messagebox_009.txt");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_MIGHTY_TOWN_WARNING", nil);
	end;
end;

x_to_return, y_to_return, floor_to_return = GetObjectPosition ( HERO_PLAYER_MAIN );

function AdvMapDialogSecene( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then	
		if heroName ~= HERO_PLAYER_MAIN then
			x_to_return, y_to_return, floor_to_return = GetObjectPosition ( HERO_PLAYER_MAIN );
			local x, y = RegionToPoint( 'REGION_FOR_ARANTIR_TELEPORTING' );
			SetRegionBlocked( 'REGION_FOR_ARANTIR_TELEPORTING', nil );
			SetObjectRotation( HERO_PLAYER_MAIN, 270 );
			SetObjectPosition( HERO_PLAYER_MAIN, x, y, GROUND );
			BlockGame();
			sleep(2)
			UnblockGame();
		end;
		StartAdvMapDialog( 4, "ReturnArantirBack" );
	end;
end;

setExpStat = 0;

function ReturnArantirBack()
	setExpStat = GetHeroStat( HERO_PLAYER_MAIN, STAT_EXPERIENCE );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "DIALOG_SCENE_KUJIN", nil );
	changeGuardExp();
	if table.length(GetObjectsInRegion( 'REGION_FOR_ARANTIR_TELEPORTING', OBJECT_HERO ))>0 then
		SetObjectPosition( HERO_PLAYER_MAIN, x_to_return, y_to_return, floor_to_return );
	end;
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "DIALOG_SCENE_KUJIN", "AdvMapDialogSecene" );

function ownerChange()
	while 1 do	
		if GetObjectiveState( OBJECTIVE_SEC_04 ) == OBJECTIVE_COMPLETED and GetObjectiveState( OBJECTIVE_PRI_04 ) == OBJECTIVE_COMPLETED then
			local enemyBuildings = GetObjectNamesByType( "BUILDING" );
			print( table.length( enemyBuildings ) )
			sleep( 1 );
			for i,eBuilding in enemyBuildings do
				if GetObjectOwner( eBuilding ) == PLAYER_4 then
					SetObjectOwner( eBuilding, PLAYER_NONE );
					print( eBuilding );
				end;
			end;
			break;
		end;
		sleep( 1 );
	end;
end;

startThread( ownerChange );

function changeGuardExp()
	print( "setExpStat = ",( setExpStat / 100 ) * ( 10 * diff ) )
	ChangeHeroStat( HERO_AI_ORC_GUARD, STAT_EXPERIENCE, ( setExpStat / 100 ) * ( 10 * diff ) );
end;

---------------------------------------------------------------------------------------------------
--*-- Main NEW DAY trigger - starts main functions every new game day --*--
---------------------------------------------------------------------------------------------------

H55_CamFixTooManySkills(PLAYER_1,"OrnellaNecro");
H55_CamFixTooManySkills(PLAYER_1,"Arantir");
H55_NewDayTrigger = 1;
--Trigger(NEW_DAY_TRIGGER, 'f_new_day_function');

---------------------------------------------------------------------------------------------------
--*-- OBJECT TOUCH trigger - starts Wizard Trap function --*--
---------------------------------------------------------------------------------------------------

--Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_WIZARD_TRAP_STARTER, 'f_wizard_trap_start');
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_WIZARD_CHAT", 'f_wizard_trap_start');

---------------------------------------------------------------------------------------------------
--*-- OBJECT TOUCH trigger - starts First Orc Combat function --*--
---------------------------------------------------------------------------------------------------

--Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_FIRST_ORC_ENCOUNTER, 'f_first_orc_combat_start');

---------------------------------------------------------------------------------------------------
--*-- OBJECT TOUCH trigger - starts Inferno Portal Destroy function --*--
---------------------------------------------------------------------------------------------------

Trigger(OBJECT_TOUCH_TRIGGER, PORTAL_GUARD_01, 'f_destroy_portal_guard_01');

---------------------------------------------------------------------------------------------------
--*-- OBJECT TOUCH trigger - starts Inferno Portal Destroy function --*--
---------------------------------------------------------------------------------------------------

Trigger(OBJECT_TOUCH_TRIGGER, PORTAL_GUARD_02, 'f_destroy_portal_guard_02');

---------------------------------------------------------------------------------------------------
--*-- HERO REMOVE trigger - starts Player Main Hero Death function --*--
---------------------------------------------------------------------------------------------------

Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, 'f_player_main_hero_death');

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - starts Hero Trap Deploy function --*--
---------------------------------------------------------------------------------------------------

Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_TRAP_SUBTERRAIN", 'f_deploy_enemy_hero_trap');

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - starts Hero Trap Disable function --*--
---------------------------------------------------------------------------------------------------

Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_TRAP_DISABLE", 'f_disable_trap_region');

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - starts Objective Destroy Inferno Portal function --*--
---------------------------------------------------------------------------------------------------

--Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_OBJECTIVE_DESTROY_PORTAL", 'f_objective_destroy_inferno_portal');

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - starts Objective Destroy Orks function --*--
---------------------------------------------------------------------------------------------------

--Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_OBJECTIVE_DESTROY_ORCS", 'f_objective_defeat_orcs');

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - starts Objective Destroy Orks function --*--
---------------------------------------------------------------------------------------------------

Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_ORC_TRAP_START", 'f_orc_trap_start');

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - starts AUTOSAVE function --*--
---------------------------------------------------------------------------------------------------

Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_AUTOSAVE", 'f_autosave');

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - starts Priest Chat function --*--
---------------------------------------------------------------------------------------------------

Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_PRIEST_CHAT", 'f_priest_chat');

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - Warning messagebox appeares --*--
---------------------------------------------------------------------------------------------------

Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_MIGHTY_TOWN_WARNING", 'f_warning');

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - starts Demons Invasion function --*--
---------------------------------------------------------------------------------------------------

Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_DEMON_INVASION", 'f_demon_invasion');

------------------------------------------------------------------------------------------
--*-- OBJECT CAPTURE triggers - checks gold mines state --*--
------------------------------------------------------------------------------------------
Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_01", "f_capture_gold_mine_01");
Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_02", "f_capture_gold_mine_02");
Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_03", "f_capture_gold_mine_03");
Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_04", "f_capture_gold_mine_04");
Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_05", "f_capture_gold_mine_05");
Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_06", "f_capture_gold_mine_06");

Trigger(OBJECT_CAPTURE_TRIGGER, "FINAL_ORC_TOWN", "f_mission_completed");

Trigger(OBJECT_CAPTURE_TRIGGER, "TOWN_INFERNO", "f_objectives_switch");

startThread( f_defensive_structures_check );
startThread( f_road_block_check );

--*-- END OF FILE --*--