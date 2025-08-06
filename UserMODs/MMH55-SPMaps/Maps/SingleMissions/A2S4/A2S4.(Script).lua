StartDialogScene("/DialogScenes/A2Single/SM4/S1/DialogScene.xdb#xpointer(/DialogScene)"); -- INTRO DIALOGSCENE
-----------------------------------------------------------------------------------------------------
--------------------------------- TITLE ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--	Creation Date: 10.11.06
--	Author: Script pwned by Vladimir Degen
-- 	Author e-mail: vladimir.degen@nival.com
--	Project Name: H5A2
--	Map Name: A2S4
--	Script Description: MapScript
-----------------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------------

--*-- SCRIPT BEGINNING --*--
H55_NewDayTrigger = 1;
H55_PlayerStatus = {0,1,1,2,2,2,2,2};

--*-- Logfile beginning - for testing purposes --*--
	
SetObjectiveState( "SEC_OBJECTIVE_CAPTURE_GOLD_MINES", OBJECTIVE_ACTIVE );
SetObjectiveState( "SEC_OBJECTIVE_ARTIFACT_STASH", OBJECTIVE_ACTIVE );

SetRegionBlocked( "VoiceOver6Region", not nil, PLAYER_2 );

SetRegionBlocked( "spawnRegion", not nil, PLAYER_1 );
SetRegionBlocked( "spawnRegion1", not nil, PLAYER_1 );
SetRegionBlocked( "spawnRegion2", not nil, PLAYER_1 );
SetRegionBlocked( "spawnRegion3", not nil, PLAYER_1 );


--function VoiceOver2()
--	Play2DSound( "/Maps/SingleMissions/A2S4/SM4_VO2_Agrael_01_READ_Bsound.xdb#xpointer(/Sound)" );
--end;

--startThread( VoiceOver2 );

function VoiceOver6( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "vo6_1", nil);
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "vo6_2", nil);
		OpenCircleFog( 131, 72, GROUND, 8, PLAYER_1 );
		Play2DSound( "/Maps/SingleMissions/A2S4/SM4_VO6_Agrael_01sound.xdb#xpointer(/Sound)" );
		SetObjectiveState( "SEC_OBJECTIVE_FREE_VEYER", OBJECTIVE_ACTIVE );
	end;
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "vo6_1", "VoiceOver6");
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "vo6_2", "VoiceOver6");
---------------------------------------------------------------------------------------------------
----------------------------- CONSTANTS --------------------------------------------------
---------------------------------------------------------------------------------------------------

--*-- Inferno Creatures Constants List --*--
CR_INFERNO_TIER_1 = 15;
CR_INFERNO_TIER_1_1 = 16;
CR_INFERNO_TIER_2 = 17;
CR_INFERNO_TIER_2_1 = 18;
CR_INFERNO_TIER_3 = 19;
CR_INFERNO_TIER_3_1 = 20;
CR_INFERNO_TIER_4 = 21;
CR_INFERNO_TIER_4_1 = 22;
CR_INFERNO_TIER_5 = 23;
CR_INFERNO_TIER_5_1 = 24;
CR_INFERNO_TIER_6 = 25;
CR_INFERNO_TIER_6_1 = 26;
CR_INFERNO_TIER_7 = 27;
CR_INFERNO_TIER_7_1 = 28;

--*-- Dungeon Creatures Constants List --*--
CR_DUNGEON_TIER_1 = 71;
CR_DUNGEON_TIER_1_1 = 72;
CR_DUNGEON_TIER_2 = 73;
CR_DUNGEON_TIER_2_1 = 74;
CR_DUNGEON_TIER_3 = 75;
CR_DUNGEON_TIER_3_1 = 76;
CR_DUNGEON_TIER_4 = 77;
CR_DUNGEON_TIER_4_1 = 78;
CR_DUNGEON_TIER_5 = 79;
CR_DUNGEON_TIER_5_1 = 80;
CR_DUNGEON_TIER_6 = 81;
CR_DUNGEON_TIER_6_1 = 82;
CR_DUNGEON_TIER_7 = 83;
CR_DUNGEON_TIER_7_1 = 84;

--*-- Hero Names Constants --*--
--*-- Player main hero --*--
HERO_NAME_PLAYER = 'Agrael';

--*-- AI player's ally hero --*--
HERO_NAME_ALLY_01 = 'Biara';

--*-- AI secondary heroes (regular attack) --*--
HERO_NAME_AI_01 = 'Efion';
HERO_NAME_AI_02 = 'Veyer'; 

function DenyAiHeroFleeFromPlayerSec()
	if	IsObjectExists( HERO_NAME_AI_01 ) == not nil then
		DenyAIHeroFlee(  HERO_NAME_AI_01, not nil );
	elseif IsObjectExists( HERO_NAME_AI_02 ) == not nil then	
		DenyAIHeroFlee(  HERO_NAME_AI_02, not nil );
	end;
end;

--*-- AI main "Inferno Lords" heroes --*--
HERO_NAME_ACTIVE_M_01 = 'Nymus';
HERO_NAME_ACTIVE_M_02 = 'Marder';
HERO_NAME_ACTIVE_M_03 = 'Grok';
HERO_NAME_ACTIVE_M_04 = 'Deleb';
ACTIVE_HERO_LEVEL = 0;

function DenyAiHeroFleeFromPlayer()	
	if	IsObjectExists( HERO_NAME_ACTIVE_M_01 ) == not nil then
		DenyAIHeroFlee(  HERO_NAME_ACTIVE_M_01, not nil );
	elseif	IsObjectExists( HERO_NAME_ACTIVE_M_02 ) == not nil then
		DenyAIHeroFlee(  HERO_NAME_ACTIVE_M_02, not nil );
	elseif	IsObjectExists( HERO_NAME_ACTIVE_M_03 ) == not nil then
		DenyAIHeroFlee(  HERO_NAME_ACTIVE_M_03, not nil );
	elseif	IsObjectExists( HERO_NAME_ACTIVE_M_04 ) == not nil then
		DenyAIHeroFlee(  HERO_NAME_ACTIVE_M_04, not nil );
	end;
end;

--*-- Special AI army coefficients after "Witch Curse" quest activation --*--
CURSE = 0;
ARMY_RATE_SPECIAL_CURSED = 0.5;
ARMY_MORALE_CURSED = -5;
ARMY_LUCK_CURSED = -5;

--*-- "Witch Curse" activation price --*--
CURSE_PRICE = 5000;

--*-- "Capture Gold Mines" quest reward bonus (+daily gold income) --*--
GOLD_BONUS = 5000;

DAY_TO_ALLY_DEPLOY = 20;
--DAY_TO_ALLY_DEPLOY = 2; --debug
---------------------------------------------------------------------------------------------------
----------------------------- VARIABLES  ---------------------------------------------------
---------------------------------------------------------------------------------------------------

--*-- Variables for deploying AI heroes --*--
HERO_NAME_ACTIVE_01 = 0;
HERO_NAME_ACTIVE_02 = 0;
DEPLOY_HERO_01 = 0;
DEPLOY_HERO_02 = 0;
ALLY_CHANGED_OWNER = 0;

--*-- Variables to check states of AI main heroes --*--
INFERNO_LORDS_APPEAR = 0;
INFERNO_LORD_01_DEAD = 0;
INFERNO_LORD_02_DEAD = 0;
INFERNO_LORD_03_DEAD = 0;
INFERNO_LORD_04_DEAD = 0;

--*-- Variables: base AI army coefficients --*--
ARMY_RATE = 1;
ARMY_DIFF_RATE = 1;
ARMY_RATE_SPECIAL = 1;
ARMY_MORALE = 0;
ARMY_LUCK = 0;

--*-- Variables to check states of gold mines --*--
GOLD_MINE_01_CAPTURED = 0;
GOLD_MINE_02_CAPTURED = 0;
GOLD_MINE_03_CAPTURED = 0;
GOLD_MINE_04_CAPTURED = 0;
ALL_GOLD_MINES_CAPTURED = 0;


DiffRate = 0;

---------------------------------------------------------------------------------------------------
----------------------------- START MAP SETTINGS ------------------------------------
---------------------------------------------------------------------------------------------------

--*-- Witch creature is disabled from the start, so player is unable to attack and kill her --*--

SetObjectEnabled('Witch', nil);

ChangeHeroStat(HERO_NAME_ACTIVE_M_01, STAT_EXPERIENCE, 35000);
ChangeHeroStat(HERO_NAME_ACTIVE_M_02, STAT_EXPERIENCE, 35000);
ChangeHeroStat(HERO_NAME_ACTIVE_M_03, STAT_EXPERIENCE, 35000);
ChangeHeroStat(HERO_NAME_ACTIVE_M_04, STAT_EXPERIENCE, 35000);


function DifficultySetup()
	if GetDifficulty() == DIFFICULTY_EASY then
		DiffRate = 1;
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		DiffRate = 2;
	elseif GetDifficulty() == DIFFICULTY_HARD then
		DiffRate = 3;
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		DiffRate = 4;
	end;
	bone_dragon_difficulty_rate();
	print( "bone_dragon_difficulty_rate started" );
	print( "DiffRate = ", DiffRate );
end;

function bone_dragon_difficulty_rate()
	if GetObjectCreatures("bone_dragon", CREATURE_BONE_DRAGON) >= 1 then
		AddObjectCreatures("bone_dragon", CREATURE_BONE_DRAGON, 2 * DiffRate);
	end;
end;	


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
		ARMY_DIFF_RATE = 0.5;
	elseif DIFFICULTY == DIFFICULTY_NORMAL then
		ARMY_DIFF_RATE = 1;
	elseif DIFFICULTY == DIFFICULTY_HARD then
		ARMY_DIFF_RATE = 1.5;
	elseif DIFFICULTY == DIFFICULTY_HEROIC then
		ARMY_DIFF_RATE = 2;
	end;
	--print_to('=Logfile_A2S4=.txt', 'Difficulty = ', DIFFICULTY);
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_army_calculations()
-- Description: This function calculates the coefficient for AI army deployment depending on the number of days passed in game.
---------------------------------------------------------------------------------------------------

function f_army_calculations()
	--print_to('=Logfile_A2S4=.txt'," ");
	--print_to('=Logfile_A2S4=.txt',"Today is ", GetDate( DAY ), " day of the game.");
	if (GetDate( DAY ) >= 28) then
		--print_to('=Logfile_A2S4=.txt',"Army coefficient = x5");
		ARMY_RATE=3;
	elseif (GetDate( DAY ) >= 21) then
		--print_to('=Logfile_A2S4=.txt',"Army coefficient = x3");
		ARMY_RATE=2.5;
	elseif (GetDate( DAY ) >= 14) then
		--print_to('=Logfile_A2S4=.txt',"Army coefficient = x2");
		ARMY_RATE=2;
	elseif (GetDate( DAY ) >= 7) then
		--print_to('=Logfile_A2S4=.txt',"Army coefficient = x2");
		ARMY_RATE=1.5;
	end;
	
	FINAL_ARMY_RATE = (ARMY_RATE * ARMY_DIFF_RATE * ARMY_RATE_SPECIAL);
	--print_to('=Logfile_A2S4=.txt',"Today's army coefficient is: x", FINAL_ARMY_RATE);
	
	f_setup_difficulty();
	--sleep(10);
	
--*-- Ths function part changes the amount of creatures in AI armies depending on the coefficients and adds a small random to the final amount --*--
	CR_TIER_1_AMOUNT = 16 * FINAL_ARMY_RATE + random(ARMY_RATE*10);
	CR_TIER_1_1_AMOUNT = 15 * FINAL_ARMY_RATE + random(ARMY_RATE*10);
	CR_TIER_2_AMOUNT = 15 * FINAL_ARMY_RATE + random(ARMY_RATE*5);
	CR_TIER_2_1_AMOUNT = 12 * FINAL_ARMY_RATE + random(ARMY_RATE*5);
	CR_TIER_3_AMOUNT = 8 * FINAL_ARMY_RATE + random(ARMY_RATE*2);
	CR_TIER_3_1_AMOUNT = 5 * FINAL_ARMY_RATE + random(ARMY_RATE*2);
	CR_TIER_4_AMOUNT = 5 * FINAL_ARMY_RATE + random(ARMY_RATE+4);
	CR_TIER_4_1_AMOUNT = 3 * FINAL_ARMY_RATE + random(ARMY_RATE+4);
	CR_TIER_5_AMOUNT = 3 * FINAL_ARMY_RATE + random(ARMY_RATE+3);
	CR_TIER_5_1_AMOUNT = 2 * FINAL_ARMY_RATE + random(ARMY_RATE+3);
	CR_TIER_6_AMOUNT = 2 * FINAL_ARMY_RATE + random(ARMY_RATE+2);
	CR_TIER_6_1_AMOUNT = 1 * FINAL_ARMY_RATE + random(ARMY_RATE+2);
	CR_TIER_7_AMOUNT = 1 * FINAL_ARMY_RATE + random(ARMY_RATE+1);
	CR_TIER_7_1_AMOUNT = 1 * FINAL_ARMY_RATE + random(ARMY_RATE+1);
end; 

---------------------------------------------------------------------------------------------------
-- Function Name: f_ai_level_up(HERO_NAME_ACTIVE)
-- Description: This function gives AI heroes experience to level up depending on the current week of the game.
---------------------------------------------------------------------------------------------------

function f_ai_level_up(HERO_NAME_ACTIVE)
	EXP_LEVEL = GetDate( WEEK )*ARMY_DIFF_RATE*2*1000;
	ChangeHeroStat(HERO_NAME_ACTIVE, STAT_EXPERIENCE, EXP_LEVEL);
	sleep(5);
	print('Hero ', HERO_NAME_ACTIVE, ' is now level: ', GetHeroLevel(HERO_NAME_ACTIVE));
	print('Hero ', HERO_NAME_ACTIVE, ' now has: ', GetHeroStat(HERO_NAME_ACTIVE, STAT_EXPERIENCE));
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_army_set(HERO_NAME_ACTIVE)
-- Description: This function selects AI army patterns depending on the number of days passed in game.
---------------------------------------------------------------------------------------------------

--*-- Local variables are here for map balancing purposes --*--

function f_army_set(HERO_NAME_ACTIVE)
	if (GetDate( DAY ) >= 28) then
	
--*-- This function part selects the pattern for AI armies --*--
		local ARMY_01 = CR_INFERNO_TIER_1_1;
		local ARMY_02 = CR_INFERNO_TIER_2_1;
		local ARMY_03 = CR_INFERNO_TIER_3_1;
		local ARMY_04 = CR_INFERNO_TIER_4_1;
		local ARMY_05 = CR_INFERNO_TIER_5_1;		
		local ARMY_06 = CR_INFERNO_TIER_6_1;
		local ARMY_07 = CR_INFERNO_TIER_7_1;

--*-- This function part deploys selected army (pattern + creatures amount)	to AI hero --*--
		sleep( 1 );
		if (IsObjectExists(HERO_NAME_ACTIVE) ~= nil) then
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_01, CR_TIER_1_AMOUNT);
			sleep( 1 );
			RemoveHeroCreatures(HERO_NAME_ACTIVE, CR_INFERNO_TIER_1, 1); --*-- Removes default 1 Imp to empty 1-st army slot --*--
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_02, CR_TIER_2_1_AMOUNT);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_03, CR_TIER_3_1_AMOUNT);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_04, CR_TIER_4_1_AMOUNT);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_05, CR_TIER_5_1_AMOUNT);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_06, CR_TIER_6_1_AMOUNT);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_07, CR_TIER_7_1_AMOUNT);
		end;
	elseif (GetDate( DAY ) >= 21) then

--*-- This function part selects the pattern for AI armies --*--
		local ARMY_01 = CR_INFERNO_TIER_1_1;
		local ARMY_02 = CR_INFERNO_TIER_2_1;
		local ARMY_03 = CR_INFERNO_TIER_3_1;
		local ARMY_04 = CR_INFERNO_TIER_4_1;
		local ARMY_05 = CR_INFERNO_TIER_5_1;		
		local ARMY_06 = CR_DUNGEON_TIER_1_1;
		local ARMY_07 = CR_DUNGEON_TIER_6_1;
		
--*-- This function part deploys selected army (pattern + creatures amount)	to AI hero --*--
		sleep( 1 );
		if (IsObjectExists(HERO_NAME_ACTIVE) ~= nil) then
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_01, CR_TIER_1_AMOUNT);
			sleep( 1 );
			RemoveHeroCreatures(HERO_NAME_ACTIVE, CR_INFERNO_TIER_1, 1); --*-- Removes default 1 Imp to empty 1-st army slot --*--
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_02, CR_TIER_2_AMOUNT);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_03, CR_TIER_3_AMOUNT);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_04, CR_TIER_4_AMOUNT);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_05, CR_TIER_5_AMOUNT);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_06, CR_TIER_1_AMOUNT);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_07, CR_TIER_6_AMOUNT);
		end;
	elseif (GetDate( DAY ) >= 14) then

--*-- This function part selects the pattern for AI armies --*--
		local ARMY_01 = CR_INFERNO_TIER_1_1;
		local ARMY_02 = CR_INFERNO_TIER_2_1;
		local ARMY_03 = CR_INFERNO_TIER_3_1;
		local ARMY_04 = CR_INFERNO_TIER_4;
		local ARMY_05 = CR_INFERNO_TIER_5;		
		local ARMY_06 = CR_INFERNO_TIER_6;
		local ARMY_07 = CR_DUNGEON_TIER_1_1;
		
--*-- This function part deploys selected army (pattern + creatures amount)	to AI hero --*--
		sleep(5);
		if (IsObjectExists(HERO_NAME_ACTIVE) ~= nil) then
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_01, CR_TIER_1_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_1_AMOUNT, "= of creature ID: ", ARMY_01, " to hero ", HERO_NAME_ACTIVE);
			sleep(1);
			RemoveHeroCreatures(HERO_NAME_ACTIVE, CR_INFERNO_TIER_1, 1); --*-- Removes default 1 Imp to empty 1-st army slot --*--
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_02, CR_TIER_2_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_2_AMOUNT, "= of creature ID: ", ARMY_02, " to hero ", HERO_NAME_ACTIVE);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_03, CR_TIER_3_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_3_AMOUNT, "= of creature ID: ", ARMY_03, " to hero ", HERO_NAME_ACTIVE);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_04, CR_TIER_4_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_4_AMOUNT, "= of creature ID: ", ARMY_04, " to hero ", HERO_NAME_ACTIVE);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_05, CR_TIER_5_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_5_AMOUNT, "= of creature ID: ", ARMY_05, " to hero ", HERO_NAME_ACTIVE);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_06, CR_TIER_6_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_6_AMOUNT, "= of creature ID: ", ARMY_06, " to hero ", HERO_NAME_ACTIVE);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_07, CR_TIER_1_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_1_AMOUNT, "= of creature ID: ", ARMY_07, " to hero ", HERO_NAME_ACTIVE);
		else
			--print_to('=Logfile_A2S4=.txt',"There is NO hero: ", HERO_NAME_ACTIVE)
		end;
	elseif (GetDate( DAY ) >= 7) then
	
--*-- This function part selects the pattern for AI armies --*--
		local ARMY_01 = CR_INFERNO_TIER_1_1;
		local ARMY_02 = CR_INFERNO_TIER_2_1;
		local ARMY_03 = CR_INFERNO_TIER_3;
		local ARMY_04 = CR_INFERNO_TIER_4;
		local ARMY_05 = CR_INFERNO_TIER_5;		
		
--*-- This function part deploys selected army (pattern + creatures amount)	to AI hero --*--
		sleep(5);
		if (IsObjectExists(HERO_NAME_ACTIVE) ~= nil) then
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_01, CR_TIER_1_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_1_AMOUNT, "= of creature ID: ", ARMY_01, " to hero ", HERO_NAME_ACTIVE);
			sleep(1);
			RemoveHeroCreatures(HERO_NAME_ACTIVE, CR_INFERNO_TIER_1, 1); --*-- Removes default 1 Imp to empty 1-st army slot --*--
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_02, CR_TIER_2_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_2_AMOUNT, "= of creature ID: ", ARMY_02, " to hero ", HERO_NAME_ACTIVE);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_03, CR_TIER_3_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_3_AMOUNT, "= of creature ID: ", ARMY_03, " to hero ", HERO_NAME_ACTIVE);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_04, CR_TIER_4_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_4_AMOUNT, "= of creature ID: ", ARMY_04, " to hero ", HERO_NAME_ACTIVE);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_05, CR_TIER_5_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_5_AMOUNT, "= of creature ID: ", ARMY_05, " to hero ", HERO_NAME_ACTIVE);
		else
			--print_to('=Logfile_A2S4=.txt',"There is NO hero: ", HERO_NAME_ACTIVE)
		end;
	elseif (GetDate( DAY ) >= 1) then
	
--*-- This function part selects the pattern for AI armies --*--
		local ARMY_01 = CR_INFERNO_TIER_1;
		local ARMY_02 = CR_INFERNO_TIER_2;
		local ARMY_03 = CR_INFERNO_TIER_3;
		local ARMY_04 = CR_INFERNO_TIER_4;
		
--*-- This function part deploys selected army (pattern + creatures amount)	to AI hero --*--
		sleep(5);
		if (IsObjectExists(HERO_NAME_ACTIVE) ~= nil) then
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_01, CR_TIER_1_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_1_AMOUNT, "= of creature ID: ", ARMY_01, " to hero ", HERO_NAME_ACTIVE);
			sleep(1);
			RemoveHeroCreatures(HERO_NAME_ACTIVE, CR_INFERNO_TIER_1, 1); --*-- Removes default 1 Imp to empty 1-st army slot --*--
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_02, CR_TIER_2_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_2_AMOUNT, "= of creature ID: ", ARMY_02, " to hero ", HERO_NAME_ACTIVE);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_03, CR_TIER_3_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_3_AMOUNT, "= of creature ID: ", ARMY_03, " to hero ", HERO_NAME_ACTIVE);
			AddHeroCreatures(HERO_NAME_ACTIVE, ARMY_04, CR_TIER_4_AMOUNT);
			--print_to('=Logfile_A2S4=.txt',"Added =", CR_TIER_4_AMOUNT, "= of creature ID: ", ARMY_04, " to hero ", HERO_NAME_ACTIVE);
		else
			--print_to('=Logfile_A2S4=.txt',"There is NO hero: ", HERO_NAME_ACTIVE)
		end;
	end;
end; 	

--*----------------------------------------------------------------------------------*--
--*-- FUNCTION SET: AI HEROES DEPLOYMENT FUNCTIONS --*--
--*----------------------------------------------------------------------------------*--

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_hero_01()
-- Description: This function deploys first AI hero on the map and defines his attractor level to player's town.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_hero_01()

--*-- This function part defines local variables: hero name + hero deployment location --*--
	local HERO_NAME_1 = HERO_NAME_AI_01;
	local START_X = 13;
	local START_Y = 19;
	local START_FLOOR = 1;

--*-- This function part checks this hero state --*--
--*-- If this hero still alive, the next attack wave is not deployed, and this hero gets a maximum attractor level --*--
if (IsObjectExists(HERO_NAME_1) ~= nil) then
		--print_to('=Logfile_A2S4=.txt',"Hero ", HERO_NAME_1, " is still alive!");
		--print_to('=Logfile_A2S4=.txt',"Attractor level for hero ", HERO_NAME_1, " has changed to maximum.");
			--MoveHero( HERO_NAME_1, 75, 71, 0 );
		SetAIHeroAttractor('Player_Town_01', HERO_NAME_1, 2);
		sleep(5);
		DEPLOY_HERO_01 = 0;
	else
		--print_to('=Logfile_A2S4=.txt',"Hero ", HERO_NAME_1, " is NOT alive!");
		HERO_NAME_ACTIVE_01 = HERO_NAME_1;
		DEPLOY_HERO_01 = 1;
	end;

--*-- This function part deploys AI hero on the map --*--
	if (DEPLOY_HERO_01 == 1) then
		--print_to('=Logfile_A2S4=.txt',"This hero will be ", HERO_NAME_ACTIVE_01);
		DeployReserveHero(HERO_NAME_ACTIVE_01, START_X, START_Y, START_FLOOR);
		sleep(10);

--*-- This function part defines the attractor level for this AI hero --*--
		if (random(2) ~= 0) then
			--print_to('=Logfile_A2S4=.txt',HERO_NAME_ACTIVE_01, "'s attractor level is 2");
			--MoveHero( HERO_NAME_ACTIVE_01, 75, 71, 0 );
			SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_01, 2);
		else
			--print_to('=Logfile_A2S4=.txt',HERO_NAME_ACTIVE_01, "'s attractor level is 1");
			SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_01, 1);
		end;
		sleep(1);

--*-- This function part gives the selected army to this AI hero --*--
		f_army_set(HERO_NAME_ACTIVE_01);

--*-- This function part changes Morale and Luck stats of this AI hero depending on the "Witch Curse" quest status --*--
		f_morale_set(HERO_NAME_ACTIVE_01);
		f_luck_set(HERO_NAME_ACTIVE_01);
		
		f_ai_level_up(HERO_NAME_ACTIVE_01);
--*-- This function part is for testing purposes --*--
	else
		--print_to('=Logfile_A2S4=.txt',"This time attack will not be sent!");
	end;

end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_hero_02()
-- Description: This function deploys second AI hero on the map and defines his attractor level to player's town.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_hero_02()

--*-- This function part defines local variables: hero name + hero deployment location --*--
	local HERO_NAME_1 = HERO_NAME_AI_02;
	local START_X = 120;
	local START_Y = 121;
	local START_FLOOR = 1;

--*-- This function part checks this hero state --*--
--*-- If this hero still alive, the next attack wave is not deployed, and this hero gets a maximum attractor level --*--
	if (IsObjectExists(HERO_NAME_1) ~= nil) then
		--print_to('=Logfile_A2S4=.txt',"Hero ", HERO_NAME_1, " is still alive!");
		--print_to('=Logfile_A2S4=.txt',"Attractor level for hero ", HERO_NAME_1, " has changed to maximum.");
			--MoveHero( HERO_NAME_1, 75, 71, 0 );
		SetAIHeroAttractor('Player_Town_01', HERO_NAME_1, 2);
		sleep(5);
		DEPLOY_HERO_02 = 0;
	else
		--print_to('=Logfile_A2S4=.txt',"Hero ", HERO_NAME_1, " is NOT alive!");
		HERO_NAME_ACTIVE_02 = HERO_NAME_1;
		DEPLOY_HERO_02 = 1;
	end;

--*-- This function part deploys AI hero on the map --*--
	if (DEPLOY_HERO_02 == 1) then
		--print_to('=Logfile_A2S4=.txt',"This hero will be ", HERO_NAME_ACTIVE_02);
		DeployReserveHero(HERO_NAME_ACTIVE_02, START_X, START_Y, START_FLOOR);
		sleep(10);

--*-- This function part defines the attractor level for this AI hero --*--
		if (random(2) ~= 0) then
			--print_to('=Logfile_A2S4=.txt',HERO_NAME_ACTIVE_02, "'s attractor level is 2");
			--MoveHero( HERO_NAME_ACTIVE_02, 75, 71, 0 );
			SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_02, 2);
		else
			--print_to('=Logfile_A2S4=.txt',HERO_NAME_ACTIVE_02, "'s attractor level is 1");
			SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_02, 1);
		end;
		sleep(1);

--*-- This function part gives the selected army to this AI hero --*--
		f_army_set(HERO_NAME_ACTIVE_02);

--*-- This function part changes Morale and Luck stats of this AI hero depending on the "Witch Curse" quest status --*--
		f_morale_set(HERO_NAME_ACTIVE_02);
		f_luck_set(HERO_NAME_ACTIVE_02);
		
		f_ai_level_up(HERO_NAME_ACTIVE_02);
--*-- This function part is for testing purposes --*--
	else
		--print_to('=Logfile_A2S4=.txt',"This time attack will not be sent!");
	end;

end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_hero_03()
-- Description: This function deploys third AI hero on the map and defines his attractor level to player's town.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_hero_03()

--*-- This function part defines local variables: hero name + hero deployment location --*--
	local HERO_NAME_1 = HERO_NAME_AI_01;
	local START_X = 18;
	local START_Y = 118;
	local START_FLOOR = 1;

--*-- This function part checks this hero state --*--
--*-- If this hero still alive, the next attack wave is not deployed, and this hero gets a maximum attractor level --*--
	if (IsObjectExists(HERO_NAME_1) ~= nil) then
		--print_to('=Logfile_A2S4=.txt',"Hero ", HERO_NAME_1, " is still alive!");
		--print_to('=Logfile_A2S4=.txt',"Attractor level for hero ", HERO_NAME_1, " has changed to maximum.");
			--MoveHero( HERO_NAME_1, 75, 71, 0 );
		SetAIHeroAttractor('Player_Town_01', HERO_NAME_1, 2);
		sleep(5);
		DEPLOY_HERO_01 = 0;
	else
		--print_to('=Logfile_A2S4=.txt',"Hero ", HERO_NAME_1, " is NOT alive!");
		HERO_NAME_ACTIVE_01 = HERO_NAME_1;
		DEPLOY_HERO_01 = 1;
	end;

--*-- This function part deploys AI hero on the map --*--
	if (DEPLOY_HERO_01 == 1) then
		--print_to('=Logfile_A2S4=.txt',"This hero will be ", HERO_NAME_ACTIVE_01);
		DeployReserveHero(HERO_NAME_ACTIVE_01, START_X, START_Y, START_FLOOR);
		sleep(10);

--*-- This function part defines the attractor level for this AI hero --*--
		if (random(2) ~= 0) then
			--print_to('=Logfile_A2S4=.txt',HERO_NAME_ACTIVE_01, "'s attractor level is 2");
			--MoveHero( HERO_NAME_ACTIVE_01, 75, 71, 0 );
			SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_01, 2);
		else
			--print_to('=Logfile_A2S4=.txt',HERO_NAME_ACTIVE_01, "'s attractor level is 1");
			SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_01, 1);
		end;
		sleep(1);

--*-- This function part gives the selected army to this AI hero --*--
		f_army_set(HERO_NAME_ACTIVE_01);

--*-- This function part changes Morale and Luck stats of this AI hero depending on the "Witch Curse" quest status --*--
		f_morale_set(HERO_NAME_ACTIVE_01);
		f_luck_set(HERO_NAME_ACTIVE_01);

		f_ai_level_up(HERO_NAME_ACTIVE_01);
--*-- This function part is for testing purposes --*--
	else
		--print_to('=Logfile_A2S4=.txt',"This time attack will not be sent!");
	end;

end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_hero_04()
-- Description: This function deploys fourth AI hero on the map and defines his attractor level to player's town.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_hero_04()

--*-- This function part defines local variables: hero name + hero deployment location --*--
	local HERO_NAME_1 = HERO_NAME_AI_02;
	local START_X = 125;
	local START_Y = 25;
	local START_FLOOR = 1;

--*-- This function part checks this hero state --*--
--*-- If this hero still alive, the next attack wave is not deployed, and this hero gets a maximum attractor level --*--
	if (IsObjectExists(HERO_NAME_1) ~= nil) then
		--print_to('=Logfile_A2S4=.txt',"Hero ", HERO_NAME_1, " is still alive!");
		--print_to('=Logfile_A2S4=.txt',"Attractor level for hero ", HERO_NAME_1, " has changed to maximum.");
			--MoveHero( HERO_NAME_1, 75, 71, 0 );
		SetAIHeroAttractor('Player_Town_01', HERO_NAME_1, 2);
		sleep(5);
		DEPLOY_HERO_02 = 0;
	else
		--print_to('=Logfile_A2S4=.txt',"Hero ", HERO_NAME_1, " is NOT alive!");
		HERO_NAME_ACTIVE_02 = HERO_NAME_1;
		DEPLOY_HERO_02 = 1;
	end;

--*-- This function part deploys AI hero on the map --*--
	if (DEPLOY_HERO_02 == 1) then
		--print_to('=Logfile_A2S4=.txt',"This hero will be ", HERO_NAME_ACTIVE_02);
		DeployReserveHero(HERO_NAME_ACTIVE_02, START_X, START_Y, START_FLOOR);
		sleep(10);

--*-- This function part defines the attractor level for this AI hero --*--
		if (random(2) ~= 0) then
			--print_to('=Logfile_A2S4=.txt',HERO_NAME_ACTIVE_02, "'s attractor level is 2");
			--MoveHero( HERO_NAME_ACTIVE_02, 75, 71, 0 );
			SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_02, 2);
		else
			--print_to('=Logfile_A2S4=.txt',HERO_NAME_ACTIVE_02, "'s attractor level is 1");
			SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_02, 1);
		end;
		sleep(1);

--*-- This function part gives the selected army to this AI hero --*--
		f_army_set(HERO_NAME_ACTIVE_02);

--*-- This function part changes Morale and Luck stats of this AI hero depending on the "Witch Curse" quest status --*--
		f_morale_set(HERO_NAME_ACTIVE_02);
		f_luck_set(HERO_NAME_ACTIVE_02);

		f_ai_level_up(HERO_NAME_ACTIVE_02);
--*-- This function part is for testing purposes --*--
	else
		--print_to('=Logfile_A2S4=.txt',"This time attack will not be sent!");
	end;

end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_hero_main_01()
-- Description: This function deploys first main AI hero on the map and gives him an order to move to player's town.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_hero_main_01()

--*-- This function part defines local variables: hero deployment location --*--
	local START_X = 13;
	local START_Y = 19;
	local START_FLOOR = 1;

--*-- This function part deploys AI hero on the map + gives him an order to move to player's town --*--
	--print_to('=Logfile_A2S4=.txt',"This Inferno Lord is ", HERO_NAME_ACTIVE_M_01);
	DeployReserveHero(HERO_NAME_ACTIVE_M_01, START_X, START_Y, START_FLOOR);
	sleep(10);
	--MoveHero( HERO_NAME_ACTIVE_M_01, 75, 71, 0 );
	SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_M_01, 2);
	sleep(1);

--*-- This function part gives the selected army to this AI hero --*--
	f_army_set(HERO_NAME_ACTIVE_M_01);
end;

-----------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_hero_main_02()
-- Description: This function deploys second main AI hero on the map and gives him an order to move to player's town.
-----------------------------------------------------------------------------------------------------

function f_deploy_ai_hero_main_02()

--*-- This function part defines local variables: hero deployment location --*--
	local START_X = 18;
	local START_Y = 118;
	local START_FLOOR = 1;

--*-- This function part deploys AI hero on the map + gives him an order to move to player's town --*--
	--print_to('=Logfile_A2S4=.txt',"This Inferno Lord is ", HERO_NAME_ACTIVE_M_02);
	DeployReserveHero(HERO_NAME_ACTIVE_M_02, START_X, START_Y, START_FLOOR);
	sleep(10);
	--MoveHero( HERO_NAME_ACTIVE_M_02, 75, 71, 0 );
	SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_M_02, 2);
	sleep(1);
	
--*-- This function part gives the selected army to this AI hero --*--
	f_army_set(HERO_NAME_ACTIVE_M_02);
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_hero_main_03()
-- Description: This function deploys third main AI hero on the map and gives him an order to move to player's town.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_hero_main_03()
--*-- This function part defines local variables: hero deployment location --*--
	local START_X = 120;
	local START_Y = 121;
	local START_FLOOR = 1;

--*-- This function part deploys AI hero on the map + gives him an order to move to player's town --*--
	--print_to('=Logfile_A2S4=.txt',"This Inferno Lord is ", HERO_NAME_ACTIVE_M_03);
	DeployReserveHero(HERO_NAME_ACTIVE_M_03, START_X, START_Y, START_FLOOR);
	sleep(10);
	--MoveHero( HERO_NAME_ACTIVE_M_03, 75, 71, 0 );
	SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_M_03, 2);
	sleep(1);
		
--*-- This function part gives the selected army to this AI hero --*--
	f_army_set(HERO_NAME_ACTIVE_M_03);
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_hero_main_04()
-- Description: This function deploys fourth main AI hero on the map and gives him an order to move to player's town.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_hero_main_04()
--*-- This function part defines local variables: hero deployment location --*--
	local START_X = 125;
	local START_Y = 25;
	local START_FLOOR = 1;

--*-- This function part deploys AI hero on the map + gives him an order to move to player's town --*--
	--print_to('=Logfile_A2S4=.txt',"This Inferno Lord is ", HERO_NAME_ACTIVE_M_04);
	DeployReserveHero(HERO_NAME_ACTIVE_M_04, START_X, START_Y, START_FLOOR);
	sleep(10);
	--MoveHero( HERO_NAME_ACTIVE_M_04, 75, 71, 0 );
	SetAIHeroAttractor('Player_Town_01', HERO_NAME_ACTIVE_M_04, 2);
	sleep(1);
	
--*-- This function part gives the selected army to this AI hero --*--
	f_army_set(HERO_NAME_ACTIVE_M_04);
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_heroes_1()
-- Description: This function deploys two secondary AI heroes on the map every 3-d day of the week.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_heroes_1()
	if (GetDate( DAY_OF_WEEK ) == 4) and (GetDate( DAY ) <= 22) then
		--print_to('=Logfile_A2S4=.txt',"Today is 3-d day of the week!");
		f_deploy_ai_hero_01();
		f_deploy_ai_hero_02();
		sleep(1);
		
--*-- This function part removes the effects of "Witch Curse" quest --*--
		f_witch_curse_remove();
		
	else
		--print_to('=Logfile_A2S4=.txt',"Today is NOT 3-d day of the week!");
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_heroes_2()
-- Description: This function deploys two secondary AI heroes on the map every 7-th day of the week.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_heroes_2()
	if (GetDate( DAY_OF_WEEK ) == 7) and (GetDate( DAY ) <= 22) then
		--print_to('=Logfile_A2S4=.txt',"Today is 7-th day of the week!");
		f_deploy_ai_hero_03();
		f_deploy_ai_hero_04();
		sleep(1);
		
--*-- This function part removes the effects of "Witch Curse" quest --*--
		f_witch_curse_remove()
		
	else
		--print_to('=Logfile_A2S4=.txt',"Today is NOT 7-th day of the week!");
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_heroes_3()
-- Description: This function deploys four main AI heroes on the map on 56-th day of the game.
---------------------------------------------------------------------------------------------------

function f_deploy_ai_heroes_3()
	if (GetDate( DAY ) == 29) then
		--print_to('=Logfile_A2S4=.txt',"Today is 56-th day!");
		
--*-- This function part removes the effects of "Witch Curse" quest before the effects take place --*--
		f_witch_curse_remove_special();
		
		startThread( f_deploy_ai_hero_main_01 );
		startThread( f_deploy_ai_hero_main_02 );
		startThread( f_deploy_ai_hero_main_03 );
		startThread( f_deploy_ai_hero_main_04 );
		MessageBox("/Maps/SingleMissions/A2S4/messagebox_001.txt");
		startThread( VoiceOver8 );
		INFERNO_LORDS_APPEAR=1;
	else
		--print_to('=Logfile_A2S4=.txt',"Today is NOT 56-th day!");
	end;
end;

function VoiceOver8()
	Play2DSound( "/Maps/SingleMissions/A2S4/SM4_VO8_Agrael_01sound.xdb#xpointer(/Sound)" );
end;

function f_dialog_scene_launch()
	if (GetDate( DAY ) == 14) then
		StartDialogScene("/DialogScenes/A2Single/SM4/S2/DialogScene.xdb#xpointer(/DialogScene)"); -- SUCCUBUS CHAT DIALOGSCENE
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ai_heroes_main()
-- Description: This function controls placement AI heroes on the map.
---------------------------------------------------------------------------------------------------

function H55_TriggerDaily()
	f_army_calculations();
	f_deploy_ai_heroes_1();
	f_deploy_ai_heroes_2();
	f_deploy_ai_heroes_3();
	f_deploy_ally_help();
	f_gold_bonus();
	f_dialog_scene_launch();
	DenyAiHeroFleeFromPlayer();
	DenyAiHeroFleeFromPlayerSec();
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_check_ai_main_heroes_death()
-- Description: This function checks the state of main AI heroes. If all four of them dead - player wins.
---------------------------------------------------------------------------------------------------

function f_check_ai_main_heroes_death()
	if (INFERNO_LORDS_APPEAR ~= 0) then
		f_check_ai_main_hero_death_01();
		f_check_ai_main_hero_death_02();
		f_check_ai_main_hero_death_03();
		f_check_ai_main_hero_death_04();
		INFERNO_LORDS=4 - INFERNO_LORD_01_DEAD - INFERNO_LORD_02_DEAD - INFERNO_LORD_03_DEAD - INFERNO_LORD_04_DEAD; 
		sleep(5);
		if (INFERNO_LORDS <= 0) then
			StartDialogScene("/DialogScenes/A2Single/SM4/S3/DialogScene.xdb#xpointer(/DialogScene)", "f_check_ai_main_heroes_death_complete"); -- OUTRO DIALOGSCENE
		else
			--print_to('=Logfile_A2S4=.txt',"Inferno Lords remained: ", INFERNO_LORDS);
		end;
	else
		--print_to('=Logfile_A2S4=.txt',"Lords of Inferno have not appeared yet!");
	end;
end;

function f_check_ai_main_heroes_death_complete()
	MessageBox("/Maps/SingleMissions/A2S4/messagebox_002.txt");
	SetObjectiveState('MAIN_OBJECTIVE', OBJECTIVE_COMPLETED, PLAYER_1);
	SetObjectiveState('OBJECTIVE_AGRAEL_SURVIVE', OBJECTIVE_COMPLETED, PLAYER_1);
	Win(0);
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_check_ai_main_hero_death_01()
-- Description: This function checks the state of first main AI hero.
---------------------------------------------------------------------------------------------------
function f_check_ai_main_hero_death_01()
	if (IsObjectExists(HERO_NAME_ACTIVE_M_01) == nil) then
		--print_to('=Logfile_A2S4=.txt',"Inferno Lord ", HERO_NAME_ACTIVE_M_01, " is dead!");
		INFERNO_LORD_01_DEAD = 1;
	else
		--print_to('=Logfile_A2S4=.txt',"Inferno Lord ", HERO_NAME_ACTIVE_M_01, "is still ALIVE!");
	end;
end; 

---------------------------------------------------------------------------------------------------
-- Function Name: f_check_ai_main_hero_death_02()
-- Description: This function checks the state of second main AI hero.
---------------------------------------------------------------------------------------------------
function f_check_ai_main_hero_death_02()
	if (IsObjectExists(HERO_NAME_ACTIVE_M_02) == nil) then
		--print_to('=Logfile_A2S4=.txt',"Inferno Lord ", HERO_NAME_ACTIVE_M_02, " is dead!");
		INFERNO_LORD_02_DEAD = 1;
	else
		--print_to('=Logfile_A2S4=.txt',"Inferno Lord ", HERO_NAME_ACTIVE_M_02, "is still ALIVE!");
	end;
end; 

---------------------------------------------------------------------------------------------------
-- Function Name: f_check_ai_main_hero_death_03()
-- Description: This function checks the state of third main AI hero.
---------------------------------------------------------------------------------------------------
function f_check_ai_main_hero_death_03()
	if (IsObjectExists(HERO_NAME_ACTIVE_M_03) == nil) then
		--print_to('=Logfile_A2S4=.txt',"Inferno Lord ", HERO_NAME_ACTIVE_M_03, " is dead!");
		INFERNO_LORD_03_DEAD = 1;		
	else
		--print_to('=Logfile_A2S4=.txt',"Inferno Lord ", HERO_NAME_ACTIVE_M_03, "is still ALIVE!");
	end;
end; 

---------------------------------------------------------------------------------------------------
-- Function Name: f_check_ai_main_hero_death_04()
-- Description: This function checks the state of fourth main AI hero.
---------------------------------------------------------------------------------------------------
function f_check_ai_main_hero_death_04()
	if (IsObjectExists(HERO_NAME_ACTIVE_M_04) == nil) then
		--print_to('=Logfile_A2S4=.txt',"Inferno Lord ", HERO_NAME_ACTIVE_M_04, " is dead!");
		INFERNO_LORD_04_DEAD = 1;		
	else
		--print_to('=Logfile_A2S4=.txt',"Inferno Lord ", HERO_NAME_ACTIVE_M_04, "is still ALIVE!");
	end;
end; 

---------------------------------------------------------------------------------------------------
-- Function Name: f_check_player_main_hero_death()
-- Description: This function checks the state of main player hero. If he is dead - player loses the game.
---------------------------------------------------------------------------------------------------
function f_check_player_main_hero_death()
	if (IsHeroAlive(HERO_NAME_PLAYER) == nil) then
		--print_to('=Logfile_A2S4=.txt',"You have been DEFEATED!!!");
		Loose();		
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_report_castle_captured()
-- Description: This function sends the 7-day warning to player, if his town was captured.
---------------------------------------------------------------------------------------------------
function f_report_castle_captured()
	if GetObjectOwner( "Player_Town_01" ) ~= PLAYER_1 and IsHeroAlive( HERO_NAME_PLAYER ) == not nil then
		MessageBox("/Maps/SingleMissions/A2S4/messagebox_003.txt");
	end;
end;

--*-----------------------------------------------------------*--
--*-- FUNCTION SET: SECONDARY QUESTS --*--
--*-----------------------------------------------------------*--

--*-- QUEST 1: Pay requested price to the Witch to weaken enemy armies.
--*-- QUEST 1 DESCRIPTION: Get to the Witch's house, talk to her. Pay the price. Next wave of AI attackers will be "cursed" - will get lowered amount of creatures and low morale and luck.
--*-- Quest can be repeated each time after you defeat "cursed armies".

---------------------------------------------------------------------------------------------------
-- Function Name: f_witch_quest()
-- Description: This function opens the Witch dialog menu.
---------------------------------------------------------------------------------------------------
SADPlayed = 0;
weekCheck = 0;
weekCount = 0;
cusrePriceAmount = 0;

function f_witch_quest( heroName )
	weekCount = GetDate( WEEK );
	print( "weekCheck", weekCheck );
	print( "weekCount", weekCount );
	if GetObjectOwner( heroName ) == PLAYER_1 then
		if SADPlayed == 0 then
			SADPlayed = 1;
			StartAdvMapDialog( 0, "RequirementsCheck" );
		elseif SADPlayed == 1 then
			RequirementsCheck();
		end;
	end;
end;

function RequirementsCheck()
	if GetPlayerResource( PLAYER_1, GOLD ) > CURSE_PRICE and weekCount > weekCheck then
		f_witch_quest_callback();
	elseif GetPlayerResource( PLAYER_1, GOLD ) < CURSE_PRICE and weekCount > weekCheck then
		MessageBox( {"/Maps/SingleMissions/A2S4/messagebox_10.txt"; cusrePriceAmount = CURSE_PRICE} );
	elseif weekCount <= weekCheck then
		MessageBox( "/Maps/SingleMissions/A2S4/messagebox_11.txt" );
	end;
end;

function f_witch_quest_callback()
	if (CURSE ~= 1) then 
		QuestionBox( {"/Maps/SingleMissions/A2S4/questionbox_001.txt"; PRICE = CURSE_PRICE}, "f_witch_quest_yes", "f_witch_quest_no");
	else
		MessageBox("/Maps/SingleMissions/A2S4/messagebox_005.txt");
	end;
end;
---------------------------------------------------------------------------------------------------
-- Function Name: f_witch_quest_yes()
-- Description: This function confirms the "Witch Curse" activation.
---------------------------------------------------------------------------------------------------

function f_witch_quest_yes()
	weekCheck = weekCount
	MessageBox( {"/Maps/SingleMissions/A2S4/messagebox_004.txt"; PRICE = CURSE_PRICE} );
	PRICE = GetPlayerResource(PLAYER_1, GOLD) - CURSE_PRICE;
	CURSE_PRICE = CURSE_PRICE + 1000;
	SetPlayerResource(PLAYER_1, GOLD, PRICE);
	f_witch_curse();
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_witch_quest_no()
-- Description: This function denies the "Witch Curse" activation.
---------------------------------------------------------------------------------------------------

function f_witch_quest_no()
	MessageBox("/Maps/SingleMissions/A2S4/messagebox_006.txt");
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_witch_curse()
-- Description: This function describes the "Witch Curse" effects.
---------------------------------------------------------------------------------------------------

function f_witch_curse()
	if (IsObjectExists('Witch') ~= nil) then
		CURSE = 1;
		ARMY_RATE_SPECIAL = ARMY_RATE_SPECIAL_CURSED;
		ARMY_MORALE = ARMY_MORALE_CURSED;
		ARMY_LUCK = ARMY_LUCK_CURSED;
		enemyHeroes = GetPlayerHeroes( PLAYER_2 );
		for i=0, table.length(enemyHeroes)-1 do
			ChangeHeroStat( enemyHeroes[i], STAT_MORALE, -GetHeroStat( enemyHeroes[i], STAT_MORALE )+ARMY_MORALE_CURSED );
			ChangeHeroStat( enemyHeroes[i], STAT_LUCK, -GetHeroStat( enemyHeroes[i], STAT_LUCK )+ARMY_LUCK_CURSED );
			print("Morale and Luck were decreased for hero "..enemyHeroes[i]);
		end;
	else
		--print_to('=Logfile_A2S4=.txt',"The Witch is DEAD! *cry* ");
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_morale_set(HERO_NAME_ACTIVE)
-- Description: This function changes the morale of AI heroes with "Witch Curse" effect.
---------------------------------------------------------------------------------------------------

function f_morale_set(HERO_NAME_ACTIVE)
	if (GetHeroStat(HERO_NAME_ACTIVE, STAT_MORALE) ~= 0) then
		STAT_MORALE_TEMP = 0 - GetHeroStat(HERO_NAME_ACTIVE, STAT_MORALE);
		ChangeHeroStat(HERO_NAME_ACTIVE, STAT_MORALE, STAT_MORALE_TEMP);
		--print_to('=Logfile_A2S4=.txt', "Morale for hero ", HERO_NAME_ACTIVE, " has changed by: ", GetHeroStat(HERO_NAME_ACTIVE, STAT_MORALE));
		--print_to('=Logfile_A2S4=.txt', "Morale for hero ", HERO_NAME_ACTIVE, " was ", GetHeroStat(HERO_NAME_ACTIVE, STAT_MORALE));
	else
		--print_to('=Logfile_A2S4=.txt', "Morale for hero ", HERO_NAME_ACTIVE, " was ", GetHeroStat(HERO_NAME_ACTIVE, STAT_MORALE));
	end;
	ChangeHeroStat(HERO_NAME_ACTIVE, STAT_MORALE, ARMY_MORALE);
	sleep(10);
	--print_to('=Logfile_A2S4=.txt', "Morale for hero ", HERO_NAME_ACTIVE, " is ", GetHeroStat(HERO_NAME_ACTIVE, STAT_MORALE));
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_luck_set(HERO_NAME_ACTIVE)
-- Description: This function changes the luck of AI heroes with "Witch Curse" effect.
---------------------------------------------------------------------------------------------------

function f_luck_set(HERO_NAME_ACTIVE)
	if (GetHeroStat(HERO_NAME_ACTIVE, STAT_LUCK) ~= 0) then
		STAT_LUCK_TEMP = 0 - GetHeroStat(HERO_NAME_ACTIVE, STAT_LUCK);
		ChangeHeroStat(HERO_NAME_ACTIVE, STAT_LUCK, STAT_LUCK_TEMP);
		--print_to('=Logfile_A2S4=.txt', "Luck for hero ", HERO_NAME_ACTIVE, " has changed by: ", GetHeroStat(HERO_NAME_ACTIVE, STAT_LUCK));
		--print_to('=Logfile_A2S4=.txt', "Luck for hero ", HERO_NAME_ACTIVE, " was ", GetHeroStat(HERO_NAME_ACTIVE, STAT_LUCK));
	else
		--print_to('=Logfile_A2S4=.txt', "Luck for hero ", HERO_NAME_ACTIVE, " was ", GetHeroStat(HERO_NAME_ACTIVE, STAT_LUCK));
	end;
	ChangeHeroStat(HERO_NAME_ACTIVE, STAT_LUCK, ARMY_LUCK);
	sleep(10);
	--print_to('=Logfile_A2S4=.txt', "Luck for hero ", HERO_NAME_ACTIVE, " is ", GetHeroStat(HERO_NAME_ACTIVE, STAT_LUCK));
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_witch_curse_remove()
-- Description: This function returns "Witch Curse" variables to normal after the "curse" has been applied on AI armies.
---------------------------------------------------------------------------------------------------

function f_witch_curse_remove()
	if (CURSE ~= 0) then
		--print_to('=Logfile_A2S4=.txt',"The Witch's Curse has been applied! Army Rates for next enemy waves are back to normal!");
		CURSE = 0;
		ARMY_RATE_SPECIAL = 1;
		ARMY_MORALE = 0;
		ARMY_LUCK = 0;
		--print_to('=Logfile_A2S4=.txt', "Morale rate is: ", ARMY_MORALE);
		--print_to('=Logfile_A2S4=.txt', "Luck rate is: ", ARMY_LUCK);
	else
		--print_to('=Logfile_A2S4=.txt',"The Witch's Curse has NOT been applied!");
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_witch_curse_remove_special()
-- Description: This function returns "Witch Curse" variables to normal before the "curse" has been applied on main AI armies.
--*-- Main AI heroes are immune to the "curse" effects.
---------------------------------------------------------------------------------------------------

function f_witch_curse_remove_special()
	if (CURSE ~= 0) then
		--print_to('=Logfile_A2S4=.txt',"The Lords of Inferno have dispelled the witch's curse! Army Rates are back to normal!");
		CURSE=0;
		ARMY_RATE_CURSED=1;
	else
		--print_to('=Logfile_A2S4=.txt',"The Witch's Curse has NOT been applied!");
	end;
end;

--*-- QUEST 2: Get the reinforcements from allies.
--*-- QUEST 2 DESCRIPTION: The ally hero with reinforcements will appear on the map on 21-th day of the game. IF this hero reaches player's town, he will change his owner and will go under player's control.

---------------------------------------------------------------------------------------------------
-- Function Name: f_deploy_ally_help()
-- Description: This function places ally AI hero on the map and orders him to go to player's town.
---------------------------------------------------------------------------------------------------

function f_deploy_ally_help()
	if GetDate( DAY ) == DAY_TO_ALLY_DEPLOY then
		startThread( VoiceOver4 );
--*-- This function part describes the starting location of ally AI hero --*--
		local START_X = 90;
		local START_Y = 1;
		local START_FLOOR = 0;
		
		MessageBox("/Maps/SingleMissions/A2S4/messagebox_007.txt");
		if IsObjectExists(HERO_NAME_ALLY_01) ~= 1 then
			DeployReserveHero(HERO_NAME_ALLY_01, START_X, START_Y, START_FLOOR);
			sleep( 2 );
			EnableHeroAI(HERO_NAME_ALLY_01, not nil);
			sleep( 2 );
			MoveHero( HERO_NAME_ALLY_01,  75, 69, 0 );
			startThread( VoiceOver5Starter );
		elseif IsHeroAlive( HERO_NAME_ALLY_01 ) == not nil then
			EnableHeroAI(HERO_NAME_ALLY_01, not nil);
			if CanMoveHero( HERO_NAME_ALLY_01,  75, 69, 0 ) then	
				MoveHero( HERO_NAME_ALLY_01,  75, 69, 0 );
			end;
		end;
		
		startThread( f_ally_change_owner );
	end;
end;

function VoiceOver4()
	Play2DSound( "/Maps/SingleMissions/A2S4/SM4_VO4_Agrael_01sound.xdb#xpointer(/Sound)" );
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_ally_change_owner()
-- Description: This function changes the ownership of ally AI hero when he reaches player's town.
---------------------------------------------------------------------------------------------------

hx = 0;
hy = 0;
hlevel = 0;

function f_ally_change_owner()
	while ALLY_CHANGED_OWNER ~= 1 do
		sleep( 10 );
		if IsObjectInRegion(HERO_NAME_ALLY_01, 'REGION_CHANGE_OWNER') == 1 then
			if GetCurrentPlayer() ~= 3 then
				hx,hy,hlevel = GetObjectPosition( HERO_NAME_PLAYER );
				SetObjectOwner(HERO_NAME_ALLY_01, 1);
				SetObjectPosition( HERO_NAME_PLAYER, 75, 70, GROUND );
				ALLY_CHANGED_OWNER = 1;
				MessageBox("/Maps/SingleMissions/A2S4/messagebox_008.txt", "PlaySceneAllyArrived");
			else
				--print_to('=Logfile_A2S4=.txt',"AI's TURN! CANNOT CHANGE OWNER!");
			end;
		end;
	end;
end;

function PlaySceneAllyArrived()
	StartAdvMapDialog( 2, "UndoHeroPosition" );
end;

function UndoHeroPosition()
	SetObjectPosition( HERO_NAME_PLAYER, hx, hy, hlevel );
end;

function VoiceOver5Starter()
	while ALLY_CHANGED_OWNER < 1 do
		if IsHeroAlive( HERO_NAME_ALLY_01 ) == nil then
			startThread( VoiceOver5 );
			break;
		end;
	sleep( 1 );
	end;
end;	

function VoiceOver5()
	Play2DSound( "/Maps/SingleMissions/A2S4/SM4_VO5_Agrael_01sound.xdb#xpointer(/Sound)" );
end;


--*-- QUEST 3: Capture and hold all gold mines to get the bonus.
--*-- QUEST 3 DESCRIPTION: Capture and hold all four gold mines to get additional bonus +5000 gold per day. If any mine lost - bonus is cancelled until all four mines are captured again. Bonus works only for human player.

---------------------------------------------------------------------------------------------------
-- Function Name: f_capture_gold_mine_01()
-- Description: This function checks the state of gold mine #1.
---------------------------------------------------------------------------------------------------

function f_capture_gold_mine_01()
	if (GetObjectOwner('GOLD_MINE_01') == 1) then
		--print_to('=Logfile_A2S4=.txt',"Gold mine ¹1 belongs to player: 1");
		GOLD_MINE_01_CAPTURED = 1;
		SetAIPlayerAttractor('GOLD_MINE_01', PLAYER_2, 2);
		f_gold_mines_quest_check();
		sleep(1);
	else
		--print_to('=Logfile_A2S4=.txt',"Gold mine ¹1 DOES NOT belong to player: 1");
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
		--print_to('=Logfile_A2S4=.txt',"Gold mine ¹2 belongs to player: 1");
		GOLD_MINE_02_CAPTURED = 1;
		SetAIPlayerAttractor('GOLD_MINE_02', PLAYER_2, 2);
		f_gold_mines_quest_check();
		sleep(1);
	else
		--print_to('=Logfile_A2S4=.txt',"Gold mine ¹2 DOES NOT belong to player: 1");
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
		--print_to('=Logfile_A2S4=.txt',"Gold mine ¹3 belongs to player: 1");
		GOLD_MINE_03_CAPTURED = 1;
		SetAIPlayerAttractor('GOLD_MINE_03', PLAYER_2, 2);
		f_gold_mines_quest_check();
		sleep(1);
	else
		--print_to('=Logfile_A2S4=.txt',"Gold mine ¹3 DOES NOT belong to player: 1");
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
		--print_to('=Logfile_A2S4=.txt',"Gold mine ¹4 belongs to player: 1");
		GOLD_MINE_04_CAPTURED = 1;
		SetAIPlayerAttractor('GOLD_MINE_04', PLAYER_2, 2);
		f_gold_mines_quest_check();
		sleep(1);
	else
		--print_to('=Logfile_A2S4=.txt',"Gold mine ¹4 DOES NOT belong to player: 1");
		GOLD_MINE_04_CAPTURED = 0;
		SetAIPlayerAttractor('GOLD_MINE_04', PLAYER_2, 0);
		f_gold_mines_quest_not_completed();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_gold_mines_quest_check()
-- Description: This function checks the state of all gold mines. If all mines captured - secondary objective completed.
---------------------------------------------------------------------------------------------------

function f_gold_mines_quest_check()
	if (GOLD_MINE_01_CAPTURED == 1) and (GOLD_MINE_02_CAPTURED == 1) and (GOLD_MINE_03_CAPTURED == 1) and (GOLD_MINE_04_CAPTURED == 1) then
		ALL_GOLD_MINES_CAPTURED = 1;
		f_gold_mines_quest_completed();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_gold_bonus()
-- Description: This function checks the state of gold mines quest. If all mines captured - player gets gold bonus.
---------------------------------------------------------------------------------------------------

function f_gold_bonus()
	local DAILY_GOLD_BONUS = GetPlayerResource(PLAYER_1, GOLD) + GOLD_BONUS;

	if (ALL_GOLD_MINES_CAPTURED == 1) then
		SetPlayerResource(PLAYER_1, GOLD, DAILY_GOLD_BONUS);
		--print_to('=Logfile_A2S4=.txt',"BONUS: Player 1 recieved: ", GOLD_BONUS, " gold.");
		f_gold_mines_quest_completed();
	else
		--print_to('=Logfile_A2S4=.txt',"Player 1 does not own all four gold mines!");
		f_gold_mines_quest_not_completed();
	end;
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_gold_mines_quest_completed()
-- Description: This function sets secondary objective completed.
---------------------------------------------------------------------------------------------------

function f_gold_mines_quest_completed()
	if (GetObjectiveState('SEC_OBJECTIVE_CAPTURE_GOLD_MINES', PLAYER_1) ~= 3) then
		SetObjectiveState('SEC_OBJECTIVE_CAPTURE_GOLD_MINES', OBJECTIVE_COMPLETED, PLAYER_1);
		startThread( VoiceOver3 );
		--print_to('=Logfile_A2S4=.txt','Objective "Gold Mines" completed');
	else
		--print_to('=Logfile_A2S4=.txt','Objective "Gold Mines" already completed');
	end;
end;

function VoiceOver3()
	Play2DSound( "/Maps/SingleMissions/A2S4/SM4_VO3_Agrael_01sound.xdb#xpointer(/Sound)" );
end;

---------------------------------------------------------------------------------------------------
-- Function Name: f_gold_mines_quest_not_completed()
-- Description: This function sets secondary objective un-completed, if any gold mine does not belong to player.
---------------------------------------------------------------------------------------------------

function f_gold_mines_quest_not_completed()
	if (GetObjectiveState('SEC_OBJECTIVE_CAPTURE_GOLD_MINES', PLAYER_1) == 3) then
		ALL_GOLD_MINES_CAPTURED = 0;
		SetObjectiveState('SEC_OBJECTIVE_CAPTURE_GOLD_MINES', OBJECTIVE_ACTIVE, PLAYER_1);
	else
		--print_to('=Logfile_A2S4=.txt','Objective "Gold Mines" already UNcompleted');
	end;
end;

--*-- QUEST 4: Free demonlord Veyer from prison.
--*-- QUEST 4 DESCRIPTION: Free demonlord Veyer from prison, and he will join player's army. Veyer is quite strong and knows some useful spells.

---------------------------------------------------------------------------------------------------
-- Function Name: f_prison_quest_completed()
-- Description: This function sets secondary objective completed.
---------------------------------------------------------------------------------------------------

teleportMainHero = 0;

pmx = 0;
pmy = 0;
pmlevel = 0;

function f_prison_quest_completed( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		if heroName ~= HERO_NAME_PLAYER then
			pmx,pmy,pmlevel = GetObjectPosition( HERO_NAME_PLAYER );
			sleep( 1 );
			SetObjectPosition( HERO_NAME_PLAYER, 128, 70, GROUND );
			sleep( 1 );
			SetObjectRotation( HERO_NAME_PLAYER, 90 );
			teleportMainHero = 1
		end;
		StartAdvMapDialog( 1, "pqc_callback" );
	end;
end;

function pqc_callback()
	if teleportMainHero == 1 then
		SetObjectPosition( HERO_NAME_PLAYER, pmx, pmy, pmlevel );
	end;
	SetObjectiveState('SEC_OBJECTIVE_FREE_VEYER', OBJECTIVE_COMPLETED, PLAYER_1);
	ChangeHeroStat(HERO_NAME_PLAYER, STAT_EXPERIENCE, 10000);
	ChangeHeroStat(HERO_NAME_PLAYER, STAT_DEFENCE, 1);
	ChangeHeroStat(HERO_NAME_PLAYER, STAT_MORALE, 1);
	Trigger( OBJECT_TOUCH_TRIGGER, 'PRISON_VEYER', nil );	
end;

--*-- QUEST 4: Free demonlord Veyer from prison.
--*-- QUEST 4 DESCRIPTION: Free demonlord Veyer from prison, and he will join player's army. Veyer is quite strong and knows some useful spells.

---------------------------------------------------------------------------------------------------
-- Function Name: f_devil_guard_dialog()
-- Description: This function opens Devil Guard dialog menu.
---------------------------------------------------------------------------------------------------

SetObjectEnabled( "DEVIL_GUARD", nil );

TouchedHero = "Agrael"

mx = 0;
my = 0;
mlevel = 0;

function f_devil_guard_dialog( heroName )
	BlockGame();
	TouchedHero = heroName
	if GetObjectOwner( heroName ) == PLAYER_1 then
		mx,my,mlevel = GetObjectPosition( HERO_NAME_PLAYER );
		if heroName ~= HERO_NAME_PLAYER then
			SetObjectPosition( HERO_NAME_PLAYER, 92, 81, UNDERGROUND );
			sleep( 1 );
			SetObjectRotation( HERO_NAME_PLAYER, 100 );
		end;
		sleep( 4 );
		StartAdvMapDialog( 3, "AdvmapDialog3" ); 	
	end;
end;

function AdvmapDialog3()
	RemoveObject( "DEVIL_GUARD" );
	sleep( 1 );
	AddHeroCreatures( HERO_NAME_PLAYER, CREATURE_ARCHDEVIL, 1 );
	SetObjectiveState('SEC_OBJECTIVE_ARTIFACT_STASH', OBJECTIVE_COMPLETED, PLAYER_1);
	RemoveObject( "dsc" );
	RemoveObject( "dss" );
	RemoveObject( "dsa" );
	GiveArtefact( HERO_NAME_PLAYER, ARTIFACT_DRAGON_TALON_CROWN );
	GiveArtefact( HERO_NAME_PLAYER, ARTIFACT_DRAGON_SCALE_ARMOR );
	GiveArtefact( HERO_NAME_PLAYER, ARTIFACT_DRAGON_SCALE_SHIELD );
	sleep( 3 );
	if TouchedHero ~= HERO_NAME_PLAYER then
		SetObjectPosition( HERO_NAME_PLAYER, mx, my, mlevel );
	end;
	UnblockGame();
end;

--Trigger(OBJECT_TOUCH_TRIGGER, 'DEVIL_GUARD', "f_devil_guard_dialog");
Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'guardRegion', "f_devil_guard_dialog");

--function f_remove_player_resources()
--end;
---------------------------------------------------------------------------------------------------
----------------------------- MAIN ------------------------------------------------------------
---------------------------------------------------------------------------------------------------

DifficultySetup();

---------------------------------------------------------------------------------------------------
--*-- Main NEW DAY trigger - starts main functions every new game day --*--
---------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------
--*-- Main REMOVE HERO trigger - checks map state for victory conditions --*--
-------------------------------------------------------------------------------------------------------

Trigger(PLAYER_REMOVE_HERO_TRIGGER, 2, "f_check_ai_main_heroes_death");

---------------------------------------------------------------------------------------------------
--*-- Main REMOVE HERO trigger - checks map state for lose conditions --*--
---------------------------------------------------------------------------------------------------
Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "f_check_player_main_hero_death");

------------------------------------------------------------------------------------------
--*-- Main OBJECT CAPTURE trigger - checks player's town state --*--
------------------------------------------------------------------------------------------
Trigger(OBJECT_CAPTURE_TRIGGER, "Player_Town_01", "f_report_castle_captured");

---------------------------------------------------------------------------------------------------------
--*-- Main OBJECT TOUCH trigger - launches Witch Curse quest dialog menu --*--
---------------------------------------------------------------------------------------------------------

Trigger(OBJECT_TOUCH_TRIGGER, 'Witch', "f_witch_quest");

------------------------------------------------------------------------------------------
--*-- Main OBJECT CAPTURE triggers - checks gold mines state --*--
------------------------------------------------------------------------------------------
Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_01", "f_capture_gold_mine_01");
Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_02", "f_capture_gold_mine_02");
Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_03", "f_capture_gold_mine_03");
Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_04", "f_capture_gold_mine_04");

------------------------------------------------------------------------------------------
--*-- Main OBJECT TOUCH trigger - checks player's town state --*--
------------------------------------------------------------------------------------------

Trigger(OBJECT_TOUCH_TRIGGER, 'PRISON_VEYER', "f_prison_quest_completed");

--startThread( f_remove_player_resources );

--*-- END OF FILE --*--