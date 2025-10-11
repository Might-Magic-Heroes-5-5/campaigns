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

--*-- HEROES SCRIPT NAMES --*--
HERO_PLAYER = 'Tamika';

--*-- CREATURES SCRIPT NAMES --*--
CREATURE_QUEST_DEALER = 'Ghost';

--*-- OBJECTS SCRIPT NAMES --*--
OBJECT_EVIL_TOWN = 'Flammschrein';
OBJECT_ORACLE = 'Oracle';
OBJECT_ENEMY_TOWN_NORD = 'Merlon';
OBJECT_ENEMY_TOWN_CENTER = 'Stormdale';
OBJECT_ENEMY_TOWN_SUD_WEST = 'Chillbury';
OBJECT_ENEMY_TOWN_OST = 'Vigil';
OBJECT_HERO_TOWN = 'Nergal-shum';
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
--*-- PRIMARY QUESTS --*--
------------------------------------------------------------------

--pri1
function f_check_player_main_hero_death()
	if (IsObjectExists(HERO_PLAYER) == nil) then
	    Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
		SetObjectiveState("pri1", OBJECTIVE_FAILED, PLAYER_1);
		sleep(2);		
		f_loose()
    end;
end;

--pri2
function f_check_Flammschrein_captured()
	if (GetObjectOwner(OBJECT_EVIL_TOWN) == 1) then
		print_to('=Logfile_A2C1M5=.txt', "Flammschrein captured!");
	    Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, nil);
		print_to('=Logfile_A2C1M5=.txt', "Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, nil);");
		SetObjectiveState("pri2", OBJECTIVE_COMPLETED, PLAYER_1);
		print_to('=Logfile_A2C1M5=.txt', "SetObjectiveState");		
		OpenCircleFog(158, 156, 0, 15, 1);
		print_to('=Logfile_A2C1M5=.txt', "OpenCircleFog");			
        sleep(4);
        MoveCamera(158, 156, 0, 90, 1, 0, 0, 0, 1);
		print_to('=Logfile_A2C1M5=.txt', "MoveCamera");			
        sleep(4);
        PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		print_to('=Logfile_A2C1M5=.txt', "PlayVisualEffect");			
        sleep(30);
        SetAmbientLight(0, "Default", not nil, 1);
		print_to('=Logfile_A2C1M5=.txt', "SetAmbientLight");			
		sleep(10);		
		f_win()
    end;
end;

--pri3--вставить ролик - общение с оракулом - гарантированно до того как активируется Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, "f_show_message_box_Oracle_001");
function f_check_find_oracle()
        SetObjectiveState("pri3", OBJECTIVE_COMPLETED, PLAYER_1);
		Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, nil);
        SetObjectiveState('pri4', OBJECTIVE_ACTIVE, PLAYER_1);
		Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, "f_show_message_box_Oracle_001");
		sleep (4)
	        if (GetObjectOwner(OBJECT_ENEMY_TOWN_NORD) == 1) and
	        (GetObjectOwner(OBJECT_ENEMY_TOWN_CENTER) == 1) and
	        (GetObjectOwner(OBJECT_ENEMY_TOWN_SUD_WEST) == 1) and
	        (GetObjectOwner(OBJECT_ENEMY_TOWN_OST) == 1) then
                SetObjectEnabled(OBJECT_GATE_TO_FLAMMSCHREIN, not nil);
                Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "f_check_capture_gate_to_Flammschrein");		
                SetObjectiveState("pri4", OBJECTIVE_COMPLETED, PLAYER_1) else
		            Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_NORD, "f_check_capture_enemy_castles");
                    Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_OST, "f_check_capture_enemy_castles");
                    Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, "f_check_capture_enemy_castles");
                    Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, "f_check_capture_enemy_castles");
                    end;
            end;

--pri4
function f_check_capture_enemy_castles()
	if (GetObjectOwner(OBJECT_ENEMY_TOWN_NORD) == 1) and
	   (GetObjectOwner(OBJECT_ENEMY_TOWN_CENTER) == 1) and
	   (GetObjectOwner(OBJECT_ENEMY_TOWN_SUD_WEST) == 1) and
	   (GetObjectOwner(OBJECT_ENEMY_TOWN_OST) == 1) then
        Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_NORD, nil);
        Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_OST, nil);
        Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, nil);
        Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, nil);
        SetObjectEnabled(OBJECT_GATE_TO_FLAMMSCHREIN, not nil);
        Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "f_check_capture_gate_to_Flammschrein");		
        SetObjectiveState("pri4", OBJECTIVE_COMPLETED, PLAYER_1);
    end;
end;

-----------------------------------------------------------------------
--*-- SECONDARY QUESTS --*--
-----------------------------------------------------------------------

--sec1
--function f_check_kill_demons()
--end

--sec2--развить квест - герой выслушивает призрака, получает задание, далее при взаимодействии с призраком должно выдаваться универсальое сообщение, после выполнения задания призрака универсальное сообщение заменится финальным текстом.
function f_check_ghost_talk()
    f_show_message_box_Ghosts_quest_003()
    SetObjectiveState('sec2', OBJECTIVE_ACTIVE, PLAYER_1);
end;

-----------------------------------------------------
--*-- WIN/LOOSE FUNCTIONS --*--
-----------------------------------------------------

--win
function f_win()	
		Win();
end;

--loose
function f_loose()	
		Loose();
end;

-----------------------------------------------------
--*-- MISC ACTIONS FUNCTIONS --*--
-----------------------------------------------------

function f_check_capture_gate_to_Flammschrein()
    if (GetObjectOwner(OBJECT_GATE_TO_FLAMMSCHREIN) == 1) then
	SetAmbientLight(0, "Daylight", not nil, 10);
	sleep (2)
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, nil);
    end;
end;
	

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

function f_show_message_box_Ghosts_quest_003()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_003.txt");
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
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, "f_check_find_oracle");
Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_DEALER, "f_check_ghost_talk");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "f_show_message_box_Gate_to_Flammschrein_002");

--*-- END OF FILE --*--