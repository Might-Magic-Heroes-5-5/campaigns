---------------------------------------------------------------------------------------------------
--------------------------------- TITLE --------------------------------------------------------
---------------------------------------------------------------------------------------------------
--	Creation Date: 29.01.07
-- 	Author: Arseny Adamov
--	Author e-mail: Arseny.Adamov@nival.com
--	Project Name: H5A2
--	Map Name: A2C0M1
--	Script Description: MapScript
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


--*-- Logfile beginning - for testing purposes --*--


 -- MOVE CAMERA TO PROPER STARTING POSITION

--*-- ECONOMIC VARIABLES --*--


--*-- Setting starting player resources --*--


--*-- Setting deadline --*--


-- SETTING STARTING OBJECTIVES VISIBILITY


---------------------------------------------------------------------------------------------------
--------------------------------- CONSTANTS ----------------------------------------------
---------------------------------------------------------------------------------------------------

--*-- HEROES SCRIPT NAMES --*--
HERO_PLAYER = 'Razzak'; -- Изменить после появления Великого Мага
HERO_PLAYER_ORC = 'Kujin'; --Заменить на другого персонажа
AI_2_HERO = 'Deleb';
AI_3_HERO = 'Glen'; -- Изменить после появления достойного кандидата

--*-- CREATURES SCRIPT NAMES --*--
MONSTER_IMP = 'Imp';
MONSTER_HORNED_DEMON = 'Horned_demon';
MONSTER_NIGHTMARE = 'Nightmare';
MONSTER_FOOTMAN = 'Footman';
MONSTER_PEASANT = 'Peasant';
MONSTER_BALOR = 'Balor';
MONSTER_HUMAN_GUARD = 'Villain_guard';
MONSTER_INFERNO_GUARD = 'Inferno_guard';

--*-- OBJECTS SCRIPT NAMES --*--
OBJECT_HOME_TOWN = 'Tharaa';

--*-- CREATURES ID --*--
CREATURE_PEASANT = 1;
CREATURE_FOOTMAN = 5;
CREATURE_IMP = 16;
CREATURE_HORNED_DEMON = 17;
CREATURE_NIGHTMARE = 24;
CREATURE_BALOR = 136;
CREATURE_GOBLIN = 117;
CREATURE_CENTAUR = 119;
CREATURE_ORC = 121;

--*-- QUEST OBJECTS SCRIPT NAMES --*--


---------------------------------------------------------------------------------------------------
-------------------------------- VARIABLES -------------------------------------------------
---------------------------------------------------------------------------------------------------
--*-- QUESTS STATES:
--*-- 	0 - Quest NOT taken
--*-- 	1 - Quest is taken, NOT completed
--*-- 	2 - Quest is taken AND completed
--*-- 	3 - Quest is NOT accessible

--*-- PRIMARY QUESTS ACTIVITY VARIABLES --*--

IMP_AT_MAP = 1;
HORNED_DEMON_AT_MAP = 1;
NIGHTMARE_AT_MAP = 1;
FOOTMAN_AT_MAP = 1;
PEASANT_AT_MAP = 1;
HUMAN_HERO_AT_MAP = 1;
DEMON_HERO_AT_MAP = 1;
BALOR_AT_MAP = 1;

--*-- SECONDARY QUESTS ACTIVITY VARIABLES --*--


--*-- SUB-MAIN-QUESTS --*--


---------------------------------------------------------------------------------------------------
------------------------------- START MAP SETTINGS -----------------------------------
---------------------------------------------------------------------------------------------------

--*-- Blocking standard interaction algorythms --*--
SetObjectEnabled(MONSTER_HORNED_DEMON, nil);
SetObjectEnabled(MONSTER_NIGHTMARE, nil);
SetObjectEnabled(MONSTER_FOOTMAN, nil);
SetObjectEnabled(MONSTER_PEASANT, nil);
SetObjectEnabled(MONSTER_BALOR, nil);
SetObjectEnabled(MONSTER_HUMAN_GUARD, nil);
SetObjectEnabled(MONSTER_INFERNO_GUARD, nil);

--*-- ROOMS MUSIC --*--


---------------------------------------------------------------------------------------------------
-------------------------------- FUNCTIONS ------------------------------------------------
---------------------------------------------------------------------------------------------------

------------------------------------------------------------------
--*-- PRIMARY QUESTS CHECK FUNCTIONS --*--
------------------------------------------------------------------

--pri1
function f_pri1() --Запускается стартером
    SetObjectiveState('pri1', OBJECTIVE_ACTIVE, PLAYER_1);
end;

function f_pri1_fail() --Запускается стартером, после рождения орка-героя заменится функцией f_pri1_fail_2
	if (IsHeroAlive(HERO_PLAYER) == nil) then
	        Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
		    SetObjectiveState("pri1", OBJECTIVE_FAILED, PLAYER_1);
		    sleep(4);		
		    startThread( f_loose );
    end;
end;

function f_pri1_fail_2() --Запускается стартером функцией f_when_one_from_two_player_hero_dead
		    SetObjectiveState("pri1", OBJECTIVE_FAILED, PLAYER_1);
		    sleep(4);		
		    startThread( f_loose );
end;

function f_pri1_success() --Запускается функцией f_win
    SetObjectiveState("pri1", OBJECTIVE_COMPLETED, PLAYER_1);
end;

--pri2
function f_pri2() --Запускается стартером
    SetObjectiveState('pri2', OBJECTIVE_ACTIVE, PLAYER_1);
	OpenCircleFog(87, 14, 0, 3, 1);
    startThread( f_imp_destroy );
end;

function f_imp_destroy() --Запускается функцией f_pri2
	while (IsObjectExists(MONSTER_IMP) == not nil) do 
		sleep(1);
	end;
	
	startThread( f_show_message_003 );
	sleep(3);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", HERO_PLAYER, 0, 0, 0, 0, 0 );
	IMP_AT_MAP = 0;
    startThread( f_gremlin_in_town );
end;

function f_gremlin_in_town() --Запускается функцией f_imp_destroy
	while 1 do
		if 	(GetObjectCreatures(OBJECT_HOME_TOWN, 57) ~= 0) then
			SetObjectPosition(HERO_PLAYER, 54, 8, GROUND);	
			sleep(3);
			AddObjectCreatures(OBJECT_HOME_TOWN, CREATURE_GOBLIN, 100);
				startThread( f_pri2_success );			
				break;
		end;
		sleep(5);
	end;
end;

function f_pri2_success() --Запускается функцией f_gremlin_in_town
    SetObjectiveState("pri2", OBJECTIVE_COMPLETED, PLAYER_1);
	startThread( f_pri3 );
end;

--pri3
function f_pri3() --Запускается функцией f_pri2_success
    Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_HORNED_DEMON, nil);
    Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_NIGHTMARE, nil);
    Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_FOOTMAN, nil);
    Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_PEASANT, nil);
    SetObjectiveState('pri3', OBJECTIVE_ACTIVE, PLAYER_1);
    SetObjectEnabled(MONSTER_HORNED_DEMON, not nil);
	SetObjectEnabled(MONSTER_NIGHTMARE, not nil);
    SetObjectEnabled(MONSTER_FOOTMAN, not nil);
	SetObjectEnabled(MONSTER_PEASANT, not nil);
	OpenCircleFog(79, 26, 0, 3, 1);
	OpenCircleFog(86, 40, 0, 3, 1);
	OpenCircleFog(88, 56, 0, 3, 1);
	OpenCircleFog(89, 67, 0, 3, 1);
    startThread( f_demon_destroy );
	startThread( f_nightmare_destroy );
	startThread( f_footman_destroy );
	startThread( f_peasant_destroy );
	startThread( f_demon_nightmare_footman_and_peasant_destroy );
end;

function f_demon_destroy()
while 1 do
		if (IsObjectExists(MONSTER_HORNED_DEMON) == nil) then
				startThread( f_show_message_003 );
				sleep(3);
				PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", HERO_PLAYER, 0, 0, 0, 0, 0 );
			break;
		end;		
			sleep(1);
	end;
end;

function f_nightmare_destroy()
while 1 do
		if (IsObjectExists(MONSTER_NIGHTMARE) == nil) then
				startThread( f_show_message_003 );
				sleep(3);
				PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", HERO_PLAYER, 0, 0, 0, 0, 0 );
			break;
		end;		
			sleep(1);
	end;
end;

function f_footman_destroy()
while 1 do
		if (IsObjectExists(MONSTER_FOOTMAN) == nil) then
				startThread( f_show_message_003 );
				sleep(3);
				PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", HERO_PLAYER, 0, 0, 0, 0, 0 );
			break;
		end;		
			sleep(1);
	end;
end;

function f_peasant_destroy()
while 1 do
		if (IsObjectExists(MONSTER_PEASANT) == nil) then
				startThread( f_show_message_003 );
				sleep(3);
				PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", HERO_PLAYER, 0, 0, 0, 0, 0 );
			break;
		end;		
			sleep(1);
	end;
end;

function f_demon_nightmare_footman_and_peasant_destroy() --Запускается функцией f_pri3
	while 1 do
		if (IsObjectExists(MONSTER_HORNED_DEMON) == nil) and (IsObjectExists(MONSTER_NIGHTMARE) == nil) and (IsObjectExists(MONSTER_FOOTMAN) == nil) and (IsObjectExists(MONSTER_PEASANT) == nil) then
			SetObjectPosition(HERO_PLAYER, 54, 8, GROUND);	
			sleep(3);
			AddObjectCreatures(OBJECT_HOME_TOWN, CREATURE_CENTAUR, 60);
			AddObjectCreatures(OBJECT_HOME_TOWN, CREATURE_ORC, 40);			
			HORNED_DEMON_AT_MAP = 0;
			NIGHTMARE_AT_MAP = 0;
			FOOTMAN_AT_MAP = 0;
			PEASANT_AT_MAP = 0;
			startThread( f_pri3_success );
			break;
		end;		
			sleep(1);
	end;
end;

function f_pri3_success() --Запускается функцией f_demon_nightmare_footman_and_peasant_destroy
    SetObjectiveState("pri3", OBJECTIVE_COMPLETED, PLAYER_1);
	startThread( f_pri4 );
end;

--pri4
function f_pri4() --Запускается функцией f_pri3_success
    Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_HUMAN_GUARD, nil);
    Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_INFERNO_GUARD, nil);
    SetObjectiveState('pri4', OBJECTIVE_ACTIVE, PLAYER_1);
	SetObjectEnabled(MONSTER_HUMAN_GUARD, not nil);
	SetObjectEnabled(MONSTER_INFERNO_GUARD, not nil);
	OpenCircleFog(84, 84, 0, 3, 1);
	OpenCircleFog(10, 9, 0, 3, 1);	
	startThread( f_all_enemy_heroes_destroy );
	startThread( f_human_hero_destroy );
	startThread( f_demon_hero_destroy );
end;

function f_human_hero_destroy()
while 1 do
		if (IsHeroAlive(AI_3_HERO) == nil) then
				startThread( f_show_message_003 );
				sleep(3);
				PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", HERO_PLAYER, 0, 0, 0, 0, 0 );
			break;
		end;		
			sleep(1);
	end;
end;

function f_demon_hero_destroy()
while 1 do
		if (IsHeroAlive(AI_2_HERO) == nil) then
				startThread( f_show_message_003 );
				sleep(3);
				PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", HERO_PLAYER, 0, 0, 0, 0, 0 );
			break;
		end;		
			sleep(1);
	end;
end;

function f_all_enemy_heroes_destroy() --Запускается функцией f_pri4
	while (IsHeroAlive(AI_2_HERO) == not nil) or (IsHeroAlive(AI_3_HERO) == not nil) do 
		sleep(1);
	end;
	Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_BALOR, HERO_PLAYER, "f_show_message_002");
	SetObjectPosition(HERO_PLAYER, 54, 8, GROUND);	
    HUMAN_HERO_AT_MAP = 0;
    DEMON_HERO_AT_MAP = 0;
	startThread( f_pri4_success );
end;

function f_pri4_success() --Запускется функцией f_all_enemy_heroes_destroy
	SetObjectiveState("pri4", OBJECTIVE_COMPLETED, PLAYER_1);
	startThread( f_pri5 );	
end;

--pri5
function f_pri5() --Запускается функцией f_pri4_success
	DeployReserveHero(HERO_PLAYER_ORC, 55, 7, GROUND);
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
	sleep(5);
    SetObjectiveState('pri5', OBJECTIVE_ACTIVE, PLAYER_1);
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, "f_when_one_from_two_player_hero_dead");
	startThread( f_pri6 );
end;

function f_pri5_fail() --Запускается функцией f_when_one_from_two_player_hero_dead
		SetObjectiveState("pri1", OBJECTIVE_FAILED, PLAYER_1);		
		sleep(4);		
		startThread( f_loose );
end;

function f_when_one_from_two_player_hero_dead() --Запускается триггером Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, "f_when_one_from_two_player_hero_dead")
	if (IsHeroAlive(HERO_PLAYER) == nil) then
	        Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
		    SetObjectiveState("pri1", OBJECTIVE_FAILED, PLAYER_1);
		    sleep(4);		
			startThread( f_pri1_fail_2 );
    end;
				if (IsHeroAlive(HERO_PLAYER_ORC) == nil) then
					Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
					SetObjectiveState("pri5", OBJECTIVE_FAILED, PLAYER_1);
					sleep(4);	
					startThread( f_pri5_fail );
				end;
end;

function f_pri5_success() --Запускается функцией f_win
    SetObjectiveState("pri5", OBJECTIVE_COMPLETED, PLAYER_1);
end;

--pri6
function f_pri6() --Запускается функцией f_pri5
    Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_BALOR, nil);
    SetObjectiveState('pri6', OBJECTIVE_ACTIVE, PLAYER_1);
	OpenCircleFog(48, 52, 0, 3, 1);
	sleep(4);
	Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_BALOR, "f_script_combat_with_balor");
end;

function f_script_combat_with_balor(hero)
	if hero == HERO_PLAYER_ORC then
		StartCombat(HERO_PLAYER_ORC, nil, 1, CREATURE_BALOR, 47, nil, "f_balor_destroy");
		sleep( 2 );
	elseif hero == HERO_PLAYER then
		startThread( f_show_message_002 );
	end;
end;

function f_balor_destroy(hero, isWinner) --Запускается функцией f_pri6
	if isWinner == not nil then
			RemoveObject(MONSTER_BALOR);
			SetObjectPosition(HERO_PLAYER, 54, 8, GROUND);	
			SetObjectPosition(HERO_PLAYER_ORC, 55, 7, GROUND);	
			BALOR_AT_MAP = 0;
			startThread( f_pri6_success );		
	end;	
end;

function f_pri6_success() --Запускается функцией f_balor_destroy
    SetObjectiveState("pri6", OBJECTIVE_COMPLETED, PLAYER_1);
	sleep(5);
	startThread( f_win );
end;

-----------------------------------------------------------------------
--*-- SECONDARY QUESTS CHECK FUNCTIONS --*--
-----------------------------------------------------------------------


------------------------------------------------------------------
--*-- PRIMARY QUESTS START FUNCTIONS --*--
------------------------------------------------------------------


-----------------------------------------------------------------------
--*-- PRIMARY QUESTS FINISH FUNCTIONS --*--
-----------------------------------------------------------------------


-----------------------------------------------------------------------
--*-- SECONDARY QUESTS START FUNCTIONS --*--
-----------------------------------------------------------------------


----------------------------------------------------------------------------
--*-- SECONDARY QUESTS FINISH FUNCTIONS --*--
----------------------------------------------------------------------------


-----------------------------------------------------
--*-- MISC ACTIONS FUNCTIONS --*--
-----------------------------------------------------

function f_win() --Запускается функцией f_pri6_success
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
	startThread( f_pri1_success );
	startThread( f_pri5_success );	
	sleep(20);
	Win();
end;

function f_loose() --Запускается сначала f_pri1_fail, после - f_pri1_fail_2 или f_pri5_fail
	sleep(20);
	Loose();
end;

---------------------------------------------------
--*-- CAMERA MOVE FUNCTIONS --*--
---------------------------------------------------


---------------------------------------------------
--*-- MESSAGEBOX FUNCTIONS --*--
---------------------------------------------------

function f_show_message_001()
	MessageBox("/Maps/Scenario/A2C0M1/message_001.txt");
end;

function f_show_message_002()
	MessageBox("/Maps/Scenario/A2C0M1/message_002.txt");
end;

function f_show_message_003()
	MessageBox("/Maps/Scenario/A2C0M1/message_003.txt");
end;

--*---------------------------------------------------------------------------------------------*--
--*--------------------------- ANIMATIONS AND EFFECTS -------------------------*--
--*---------------------------------------------------------------------------------------------*--

---------------------------------------------------------------------------------------------------
--------------------------------------- MAIN --------------------------------------------------
---------------------------------------------------------------------------------------------------


--*--- Starting Cutscene  ---*--

--*-- TRIGGERS --*--

Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, "f_pri1_fail");
Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_HUMAN_GUARD, "f_show_message_001");
Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_INFERNO_GUARD, "f_show_message_001");
Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_HORNED_DEMON, "f_show_message_001");
Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_NIGHTMARE, "f_show_message_001");
Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_FOOTMAN, "f_show_message_001");
Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_PEASANT, "f_show_message_001");
Trigger(OBJECT_TOUCH_TRIGGER, MONSTER_BALOR, "f_show_message_001");

--*-- PRIMARY QUESTS TRIGGERS --*--

--*-- SECONDARY QUESTS TRIGGERS --*--

--*-- MISC ACTIONS TRIGGERS --*--

--*-- GATES TRIGGERS --*--

---------------------------------------------------
--*-- GAMEPLAY FUNCTIONS --*--
---------------------------------------------------

--Starter
sleep(4);
startThread( f_pri1 );
startThread( f_pri1_fail );
startThread( f_pri2 );
EnableHeroAI(AI_2_HERO, nil);
EnableHeroAI(AI_3_HERO, nil);

--*-- END OF FILE --*--