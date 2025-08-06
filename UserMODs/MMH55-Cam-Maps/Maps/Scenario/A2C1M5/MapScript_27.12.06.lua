---------------------------------------------------------------------------------------------------
--------------------------------- TITLE --------------------------------------------------------
---------------------------------------------------------------------------------------------------
--	Creation Date: 27.12.06
-- 	Author: Arseny Adamov
--	Author e-mail: Arseny.Adamov@nival.com
--	Project Name: H5A2
--	Map Name: A2C1M5
--	Script Description: MapScript
---------------------------------------------------------------------------------------------------
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
--------------------------------- CONSTANTS ----------------------------------------------
---------------------------------------------------------------------------------------------------

-- SETTING STARTING OBJECTIVES VISIBILITY
SetObjectiveVisible('pri1', not nil, PLAYER_1);
SetObjectiveVisible('pri2', not nil, PLAYER_1);
SetObjectiveVisible('pri3', not nil, PLAYER_1);
SetObjectiveVisible('pri4', nil, PLAYER_1);
SetObjectiveVisible('sec1', nil, PLAYER_1);
SetObjectiveVisible('sec2', nil, PLAYER_1);

--*-- HEROES SCRIPT NAMES --*--
HERO_PLAYER = 'Tamika';

--*-- CREATURES SCRIPT NAMES --*--
CREATURE_QUEST_DEALER = 'Ghost';

--*-- OBJECTS SCRIPT NAMES --*--
OBJECT_EVIL_TOWN = 'Flammschrein';
OBJECT_ORACLE = 'Oracle';
OBJECT_ENEMY_TOWN_NORD = 'Merlon';
OBJECT_ENEMY_TOWN_CENTER = 'Stormdale';
OBJECT_ENEMY_TOWN_SUD_WEST = 'RChillbury';
OBJECT_ENEMY_TOWN_OST = 'Vigil';
OBJECT_HERO_TOWN = 'Nergal-shum';
OBJECT_TOMB = 'Tomb';
OBJECT_TELEPORT_TO_GOLD = 'Teleport_to_gold';
OBJECT_TELEPORT_TO_HERO = 'Teleport_to_hero';
OBJECT_TELEPORT_TO_TREES = 'Teleport_to_trees';
OBJECT_GARRISON_OST = 'Garrison_ost';
OBJECT_GARRISON_OST = 'Garrison_center';
OBJECT_GATE_TO_FLAMMSCHREIN = 'Gate_to_Flammschrein';


---------------------------------------------------------------------------------------------------
-------------------------------- VARIABLES -------------------------------------------------
---------------------------------------------------------------------------------------------------


---------------------------------------------------------------------------------------------------
------------------------------- START MAP SETTINGS -----------------------------------
---------------------------------------------------------------------------------------------------

SetObjectEnabled(OBJECT_ORACLE, nil);
SetObjectEnabled(CREATURE_QUEST_DEALER, nil);
SetObjectEnabled(OBJECT_TELEPORT_TO_GOLD, nil);
SetObjectEnabled(OBJECT_TELEPORT_TO_HERO, nil);
SetObjectEnabled(OBJECT_TELEPORT_TO_TREES, nil);
SetObjectEnabled(OBJECT_GATE_TO_FLAMMSCHREIN, nil);

---------------------------------------------------------------------------------------------------
-------------------------------- FUNCTIONS ------------------------------------------------
---------------------------------------------------------------------------------------------------

------------------------------------------------------------------
--*-- PRIMARY QUESTS CHECK FUNCTIONS --*--
------------------------------------------------------------------


-----------------------------------------------------------------------
--*-- SECONDARY QUESTS CHECK FUNCTIONS --*--
-------------------------------------------------------------------------------------+


------------------------------------------------------------------
--*-- PRIMARY QUESTS START FUNCTIONS --*--
------------------------------------------------------------------

--pri1
function f_check_player_main_hero_death()
	if (IsObjectExists(HERO_PLAYER) == nil) then
	    Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
		SetObjectiveState("pri1", OBJECTIVE_FAILED);
		sleep(2);		
		Loose();
end;

--pri2
function f_check_Flammschrein_captured()
	if (GetObjectOwner(OBJECT_EVIL_TOWN) == 1) then
	    Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, nil);
		SetObjectiveState("pri2", OBJECTIVE_COMPLETED);
		OpenCircleFog(158, 156, 0, 15, 1);
        sleep(2);
        MoveCamera(158, 156, 0, 90, 1, 0, 0, 0, 1);
        sleep(2);
        PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
        sleep(16);
        SetAmbientLight(0, "Default", not nil, 1);
		sleep(4);		
		Win();
end;

--pri3
function f_check_find_oracle()
        SetObjectiveState("pri3", OBJECTIVE_COMPLETED);
		Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, nil);
	    SetObjectiveState('pri4', OBJECTIVE_ACTIVE, PLAYER_1);	
		Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, "f_show_message_box_Oracle_001");
end;

--pri4
function f_check_capture_enemy_castles()
	if (GetObjectOwner(OBJECT_ENEMY_TOWN_NORD) == 1) and
	   (GetObjectOwner(OBJECT_ENEMY_TOWN_CENTER) == 1) and
	   (GetObjectOwner(OBJECT_ENEMY_TOWN_SUD_WEST) == 1) and
	   (GetObjectOwner(OBJECT_ENEMY_TOWN_OST) == 1) then
        Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, nil);
        Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_NORD, nil);
        Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_OST, nil);
        Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, nil);
        Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, nil);		
        SetObjectEnabled(OBJECT_GATE_TO_FLAMMSCHREIN, not nil);		
        SetObjectiveState("pri4", OBJECTIVE_COMPLETED);
end;

-----------------------------------------------------------------------
--*-- PRIMARY QUESTS FINISH FUNCTIONS --*--
-----------------------------------------------------------------------


-----------------------------------------------------------------------
--*-- SECONDARY QUESTS START FUNCTIONS --*--
-----------------------------------------------------------------------

--sec1
function f_check_kill_demons()
end

--sec2
function f_check_ghost_talk()
SetObjectiveState('sec2', OBJECTIVE_ACTIVE, PLAYER_1);
end;

----------------------------------------------------------------------------
--*-- SECONDARY QUESTS FINISH FUNCTIONS --*--
----------------------------------------------------------------------------


-----------------------------------------------------
--*-- MISC ACTIONS FUNCTIONS --*--
-----------------------------------------------------


---------------------------------------------------
--*-- CAMERA MOVE FUNCTIONS --*--
---------------------------------------------------


---------------------------------------------------
--*-- MESSAGEBOX FUNCTIONS --*--
---------------------------------------------------

function f_show_message_box_Oracle_001()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_001.txt");
	sleep(2);
end;

function f_show_message_box_Gate_to_Flammschrein_002()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_002.txt");
	sleep(2);
end;

--*---------------------------------------------------------------------------------------------*--
--*--------------------------- ANIMATIONS AND EFFECTS -------------------------*--
--*---------------------------------------------------------------------------------------------*--

---------------------------------------------------------------------------------------------------
--------------------------------------- MAIN --------------------------------------------------
---------------------------------------------------------------------------------------------------
Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, "f_check_player_main_hero_death");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, "f_check_Flammschrein_captured");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, "function f_check_find_oracle");
Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_DEALER, "f_check_ghost_talk");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "function f_show_message_box_Gate_to_Flammschrein_002");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_NORD, "f_check_capture_enemy_castles");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_OST, "f_check_capture_enemy_castles");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, "f_check_capture_enemy_castles");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, "f_check_capture_enemy_castles");

--*-- END OF FILE --*--


sleep (40)
OpenCircleFog(158, 156, 0, 15, 1);
sleep(2);
MoveCamera(158, 156, 0, 90, 1, 0, 0, 0, 1);
sleep(2);
PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
sleep(16);
SetAmbientLight(0, "Daylight", not nil, 1);
