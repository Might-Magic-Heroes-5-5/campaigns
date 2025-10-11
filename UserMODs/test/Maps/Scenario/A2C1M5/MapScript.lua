H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_STAFF_OF_VEXINGS,
ARTIFACT_CLOAK_OF_MOURNING,
ARTIFACT_RING_OF_DEATH,
ARTIFACT_SKULL_HELMET

};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

---------------------------------------------------------------------------------------------------
--------------------------------- CONSTANTS ----------------------------------------------
---------------------------------------------------------------------------------------------------

--*-- HEROES SCRIPT NAMES --*--
HERO_PLAYER = 'Arantir';
HERO_PLAYER_2 = 'OrnellaNecro';
HERO_FREE = 'Gles';
HERO_FREE_2 = 'Effig';
HERO_FREE_3 = 'Muscip';

HERO_PRISONER = 'RedHeavenHero03';

-- HERO_PRISONER_2 = 'Straker';
--RITUAL_STARTS = 0; -------------------------------1.300

HERO_AI_2_ENEMY_HERO_1 = 'RedHeavenHero04';
HERO_AI_2_ENEMY_HERO_2 = 'RedHeavenHero02';
HERO_AI_2_ENEMY_HERO_3 = 'RedHeavenHero06';
HERO_AI_2_ENEMY_HERO_4 = 'RedHeavenHero05';
HERO_AI_2_ENEMY_HERO_5 = 'RedHeavenHero01';

HERO_AI_3_ENEMY_HERO_1 = 'Jazaz';
HERO_AI_3_ENEMY_HERO_2 = 'Grok';
HERO_AI_3_ENEMY_HERO_3 = 'Oddrema';
HERO_AI_3_ENEMY_HERO_4 = 'Deleb';
MOCHAB = 'Orlando'; 
HERO_SOULKEEPER = 'Efion';

HERO_GHOST_OF_FLAMMSCHREIN = "GhostFSLord";

--*-- CREATURES SCRIPT NAMES --*--
-- CREATURE_QUEST_DEALER = 'Ghost';
CREATURE_QUEST_TARGET = 'Assasin';
CREATURE_INFERNO_1 = 'Ritual_Succubus';
-- CREATURE_SOULKEEPER = 'Soulkeeper';
CREATURE_FALLEN_PALADIN = 'Paladin';
CREATURE_FINAL_GIFT = 'Final_gift';

CREATURE_ELEMENTAL_OUT_15 = 'Elemental_Out_15';
CREATURE_ELEMENTAL_OUT_16 = 'Elemental_Out_16';
CREATURE_ELEMENTAL_OUT_17 = 'Elemental_Out_17';
CREATURE_ELEMENTAL_OUT_18 = 'Elemental_Out_18';
CREATURE_ELEMENTAL_OUT_19 = 'Elemental_Out_19';
CREATURE_ELEMENTAL_OUT_20 = 'Elemental_Out_20';
CREATURE_ELEMENTAL_OUT_21 = 'Elemental_Out_21';

--*-- OBJECTS SCRIPT NAMES --*--
OBJECT_EVIL_TOWN = 'Flammschrein';
--OBJECT_ORACLE = 'Oracle';
OBJECT_ENEMY_TOWN_NORD = 'Merlon';
OBJECT_ENEMY_TOWN_CENTER = 'Stormdale';
OBJECT_ENEMY_TOWN_SUD_WEST = 'Chillbury';
OBJECT_ENEMY_TOWN_OST = 'Vigil';
OBJECT_HERO_TOWN = 'Nergal-shum';
OBJECT_TELEPORT_TO_GOLD = 'Teleport_to_gold';
OBJECT_TELEPORT_TO_HERO = 'Teleport_to_hero';
OBJECT_TELEPORT_TO_TREES = 'Teleport_to_trees';
OBJECT_GARRISON_OST = 'Garrison_ost';
OBJECT_GARRISON_CENTER = 'Garrison_center';
OBJECT_GARRISON_NORD = 'Garrison_nord';
OBJECT_GARRISON_SUD_WEST = 'Garrison_sud_west';
OBJECT_GARRISON_CENTER_NORD = 'Garrison_center_nord';
OBJECT_GATE_TO_FLAMMSCHREIN = 'Gate_to_Flammschrein';
OBJECT_FIRE_WALL = 'Fire_wall';
--OBJECT_SEER_QUEST_DEALER = 'Death_knight_seer';
OBJECT_TOMB = 'Tomb';
OBJECT_RITUAL_TILE_1 = 'Tile_44_154';
OBJECT_RITUAL_TILE_2 = 'Tile_65_111';
OBJECT_RITUAL_TILE_3 = 'Tile_20_12';
OBJECT_RITUAL_TILE_4 = 'Tile_149_67';
OBJECT_INFERNO_REMOVED = 'Smoke_1';
OBJECT_INFERNO_REMOVED_2 = 'Smoke_2';
OBJECT_INFERNO_REMOVED_3 = 'Smoke_3';
OBJECT_INFERNO_REMOVED_4 = 'Smoke_4';
OBJECT_INFERNO_REMOVED_5 = 'Smoke_5';
OBJECT_INFERNO_REMOVED_6 = 'Smoke_6';
OBJECT_INFERNO_REMOVED_7 = 'Smoke_7';
OBJECT_INFERNO_REMOVED_8 = 'Smoke_8';
OBJECT_INFERNO_REMOVED_9 = 'Smoke_9';
OBJECT_INFERNO_REMOVED_10 = 'Smoke_10';
OBJECT_INFERNO_REMOVED_11 = 'Inferno_exit1';
OBJECT_INFERNO_ALTAR = 'Inferno_altar';
OBJECT_SMOKE_FOR_ALTAR = 'Smoke_for_move_to_altar';
OBJECT_SMOKE_FOR_ALTAR_2 = 'Smoke_11';
OBJECT_FIRE_FOR_ALTAR = 'Fire_for_move_to_altar';
OBJECT_UNDER_SUCCUBUS = 'Under_succubus';
OBJECT_UNDER_ASSASSIN = 'Under_assassin';
OBJECT_PLACE_FOR_SUMMON_GHOST = 'Summon_ghost';
OBJECT_SULFUR_01 = 'Sulfur1';
OBJECT_SIGN_01 = 'Sign1';
OBJECT_SIGN_02 = 'Sign2';
OBJECT_SIGN_03 = 'Sign3';
--------------------------------------



---------------------------------------

function InitTeleportsPairs()
	TeleportsPairs = {};
	TeleportsPairs.Count = 7;
	for i = 1, TeleportsPairs.Count do
		TeleportsPairs[i] = {};
		local nGroup = i + 14;
		TeleportsPairs[i].In = "In"..nGroup;
		TeleportsPairs[i].Out = "Out"..nGroup;
		TeleportsPairs[i].Elemental_Out = "Elemental_Out_"..nGroup;
		TeleportsPairs[i].Blocked = 1;
		TeleportsPairs[i].Angle = 0;
		SetObjectEnabled(TeleportsPairs[i].In, nil);
		Trigger(OBJECT_TOUCH_TRIGGER, TeleportsPairs[i].In, "TouchTeleportPairIn");
		Trigger(OBJECT_TOUCH_TRIGGER, TeleportsPairs[i].Out, "TouchTeleportPairOut");
	end;
	TeleportsPairs[1].Angle = 1.57;
	TeleportsPairs[2].Angle = 4.71;
	TeleportsPairs[3].Angle = 1.57;
	TeleportsPairs[4].Angle = 0;
	TeleportsPairs[5].Angle = 1.57;
	TeleportsPairs[6].Angle = 4.71;
	TeleportsPairs[7].Angle = 1.57;
	startThread(CheckTeleportPairOutElementals);
end;

function TouchTeleportPairIn(heroName, objectName)
	if GetObjectOwner(heroName) == PLAYER_1 then
		for i = 1, TeleportsPairs.Count do
			if TeleportsPairs[i].In == objectName then	
				if TeleportsPairs[i].Blocked == 1 then
					local x, y, f = GetObjectPosition(TeleportsPairs[i].Out);
					OpenCircleFog(x, y, f, 4, 1);
					MoveCamera(x, y, f, 35, 1, TeleportsPairs[i].Angle, 0, 0, 1);		
					MessageBox("/Maps/Scenario/A2C1M5/messagebox_027.txt");
				end;
			end;
		end;
	end;
end;

function TouchTeleportPairOut(heroName, objectName)
	if GetObjectOwner(heroName) == PLAYER_1 then
		for i = 1, TeleportsPairs.Count do
			if TeleportsPairs[i].Out == objectName then	
				if TeleportsPairs[i].Blocked == 1 then
					Trigger(OBJECT_TOUCH_TRIGGER, TeleportsPairs[i].In, nil);
					Trigger(OBJECT_TOUCH_TRIGGER, TeleportsPairs[i].Out, nil);
					SetObjectEnabled(TeleportsPairs[i].In, not nil);
					TeleportsPairs[i].Blocked = 0;
				end;
			end;
		end;
	end;
end;

function CheckTeleportPairOutElementals()
	while 1 do
		local count = 0;
		for i = 1, TeleportsPairs.Count do
			if TeleportsPairs[i].Blocked == 1 then
				if IsObjectExists(TeleportsPairs[i].Elemental_Out) == 1 then
					count = count + 1;
				else
					SetObjectEnabled(TeleportsPairs[i].In, not nil);
					TeleportsPairs[i].Blocked = 0;
				end;
			end;
		end;
		if count == 0 then
			break;
		end;
		sleep (2);
	end;
end;

InitTeleportsPairs();

OBJECT_IN_15 = 'In15';
OBJECT_IN_16 = 'In16';
OBJECT_IN_17 = 'In17';
OBJECT_IN_18 = 'In18';
OBJECT_IN_19 = 'In19';
OBJECT_IN_20 = 'In20';
OBJECT_IN_21 = 'In21';
OBJECT_OUT_15 = 'Out15';
OBJECT_OUT_16 = 'Out16';
OBJECT_OUT_17 = 'Out17';
OBJECT_OUT_18 = 'Out18';
OBJECT_OUT_19 = 'Out19';
OBJECT_OUT_20 = 'Out20';
OBJECT_OUT_21 = 'Out21';

CARAVAN = "caravan";
DevastatorName = "";
NearSoulkeeperName = "";
AvengerName = "";
GoToFlammschreinName = "";
heroInRegionName = "";
NearToGhostName = "";
ValeriaInGame = 0; -- Валерия не активна

---------------------------------------------------------------------------------------------------
-------------------------------- VARIABLES -------------------------------------------------
---------------------------------------------------------------------------------------------------
count = 0; -- переменная, обозначающая количество городов RH под управлением игрока.
count_1 = 0;
count_2 = 0;
count_3 = 0;
count_4 = 0;

PLAYER_GOLD = 0;
GOLD_BONUS = 10000;
ALTAR_BROKEN = 0;
---------------------------------------------------------------------------------------------------
------------------------------- START MAP SETTINGS -----------------------------------
---------------------------------------------------------------------------------------------------


SetObjectEnabled(CREATURE_QUEST_TARGET, nil);
SetObjectEnabled(CREATURE_INFERNO_1, nil);

SetObjectEnabled(CREATURE_FALLEN_PALADIN, nil);
SetObjectEnabled(OBJECT_TELEPORT_TO_GOLD, nil);
SetObjectEnabled(OBJECT_TELEPORT_TO_HERO, nil);
SetObjectEnabled(OBJECT_TELEPORT_TO_TREES, nil);
SetObjectEnabled(OBJECT_GATE_TO_FLAMMSCHREIN, nil);
SetObjectEnabled(OBJECT_INFERNO_ALTAR, nil);
SetObjectEnabled(OBJECT_TOMB, nil);

SetObjectiveState('pri1', OBJECTIVE_ACTIVE, PLAYER_1);
SetObjectiveState('pri5', OBJECTIVE_ACTIVE, PLAYER_1);
SetObjectiveState('pri2', OBJECTIVE_ACTIVE, PLAYER_1);
SetRegionBlocked( "RegionToArantir", not nil );

---------------------------------------------------------------------------------------------------
-------------------------------- FUNCTIONS ------------------------------------------------
---------------------------------------------------------------------------------------------------

--*-- Artifacts Sets Loading--*--
function f_artifacts_sets()

	InitAllSetArtifacts( "A2C1M5", "Arantir",  "OrnellaNecro" );

	LoadHeroAllSetArtifacts(  "OrnellaNecro",  "A2C1M4"  );
	LoadHeroAllSetArtifacts(  "Arantir",  "A2C1M4"  );
end;

startThread( f_artifacts_sets );

------------------------------------------------------------------
--*-- PRIMARY QUESTS CHECK FUNCTIONS --*--
------------------------------------------------------------------


-----------------------------------------------------------------------
--*-- SECONDARY QUESTS CHECK FUNCTIONS --*--
-------------------------------------------------------------------------------------+


------------------------------------------------------------------
--*-- PRIMARY QUESTS --*--
------------------------------------------------------------------

--pri1 и pri5
function f_check_player_main_hero_death()
	if (IsHeroAlive(HERO_PLAYER) == nil) then
	    Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
		SetObjectiveState("pri1", OBJECTIVE_FAILED, PLAYER_1);
		sleep(2);		
		f_loose();
	end;
	if (IsHeroAlive(HERO_PLAYER_2) == nil) then
		Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
		SetObjectiveState("pri5", OBJECTIVE_FAILED, PLAYER_1);
		sleep(2);		
		f_loose();		
	end;
end;

function f_check_player_main_hero_death_2()
	print ("CHECK003");
	if (IsHeroAlive(HERO_PLAYER) == nil) then
	    Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
		SetObjectiveState("pri1", OBJECTIVE_FAILED, PLAYER_1);
		sleep(2);	
	end;
end;

function f_check_Flammschrein_captured()
	if (GetObjectOwner(OBJECT_EVIL_TOWN) == 1) then
	    Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, nil);	
		OpenCircleFog(158, 156, 0, 15, 1);		
        sleep(4);
        MoveCamera(158, 156, 0, 90, 1, 0, 0, 0, 1);		
        sleep(4);
        PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		sleep(4);
		Play2DSound( "/Sounds/_(Sound)/Spells/Earthquake.xdb#xpointer(/Sound)" ); ----------------DESTROY_FLAMM_SDN
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		sleep(4);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
        sleep(4);
        SetAmbientLight(0, "Default", not nil, 1);		
		sleep(41);
		SetObjectiveState("pri2", OBJECTIVE_COMPLETED, PLAYER_1);
		sleep(5);
		StartDialogScene("/DialogScenes/A2C1/M5/S1/DialogScene.xdb#xpointer(/DialogScene)", "f_win"); -- выкинуть, заменив на вызов функции. Как ниже, например
    end;
end;

function f_check_Flammschrein_captured_2()
	if (GetObjectOwner(OBJECT_EVIL_TOWN) == 1) then
	    Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, nil);	
		OpenCircleFog(158, 156, 0, 15, 1);		
        sleep(4);
        MoveCamera(158, 156, 0, 90, 1, 0, 0, 0, 1);		
        sleep(4);
        PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		sleep(4);
		Play2DSound( "/Sounds/_(Sound)/Spells/Earthquake.xdb#xpointer(/Sound)" ); ----------------DESTROY_FLAMM_SDN
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		sleep(4);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Earthquake.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", "Flammschrein", 0, 0, 0, 0, 0 );
        sleep(4);
        SetAmbientLight(0, "Default", not nil, 1);		
		sleep(41);
		SetObjectiveState("pri2", OBJECTIVE_COMPLETED, PLAYER_1);
		sleep(5);
		StartDialogScene("/DialogScenes/A2C1/M5/S1/DialogScene.xdb#xpointer(/DialogScene)", "f_win"); -- выкинуть, заменив на вызов функции. Как ниже, например
    end;
end;

--pri3--вставить ролик - общение с оракулом - гарантированно до того как активируется Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, "f_show_message_box_Oracle_001");

function f_check_find_oracle()
	f_show_message_box_Oracle_speak_009();
	SetObjectiveState("pri3", OBJECTIVE_COMPLETED, PLAYER_1);
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, nil);
	sleep(2);
	SetObjectiveState('pri4', OBJECTIVE_ACTIVE, PLAYER_1);
	sleep(2);
--	startThread(Fail_sec2); ---------------------------!!!!
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, "f_show_message_box_Oracle_001");
	sleep(2);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_NORD, "f_check_capture_enemy_castles");
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_OST, "f_check_capture_enemy_castles");
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, "f_check_capture_enemy_castles");
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, "f_check_capture_enemy_castles");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_1", "f_check_capture_enemy_castles");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_2", "f_check_capture_enemy_castles");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_3", "f_check_capture_enemy_castles");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_4", "f_check_capture_enemy_castles");
	f_check_capture_enemy_castles();
end;

function f_check_hero_in_ritual_zone( heroName )
	if ( IsObjectInRegion( heroName, 'Ritual_1' ) == not nil ) then return not nil end;
	if ( IsObjectInRegion( heroName, 'Ritual_2' ) == not nil ) then return not nil end;
	if ( IsObjectInRegion( heroName, 'Ritual_3' ) == not nil ) then return not nil end;
	if ( IsObjectInRegion( heroName, 'Ritual_4' ) == not nil ) then return not nil end;
	return nil;
end;

--pri4 -- Вставить ролик - разговор Арантира с призраком Фламмшрайна

function f_check_barrier_touch_new() -- Запускается триггером Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "f_check_barrier_touch_new");
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, nil);
	BlockGame();
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Flammschrein_Ghost_arrives", "f_speak_with_Flammschrein_ghost");	
	OpenCircleFog(145, 122, GROUND, 4, 1);
	sleep(3);
	MoveCamera(145, 122, 0, 40, 1, 0, 0, 0, 1);
	sleep(5);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", OBJECT_PLACE_FOR_SUMMON_GHOST, 0, 0, 0, 0, 0 );
	sleep(5);
	DeployReserveHero(HERO_GHOST_OF_FLAMMSCHREIN, 145, 123, GROUND);
	sleep(5);
	SetObjectRotation(HERO_GHOST_OF_FLAMMSCHREIN, 270);
	sleep(5);
	EnableHeroAI(HERO_GHOST_OF_FLAMMSCHREIN, not nil);	
	MoveHeroRealTime(HERO_GHOST_OF_FLAMMSCHREIN, 139, 128, GROUND);
	OpenCircleFog(139, 128, GROUND, 4, 1);
	sleep(2);
	MoveCamera(139, 128, 0, 40, 1, 0.785, 0, 0, 1);
	
	sleep(2); --fix H55
	startThread(H55_PinGhost);
end;

function H55_PinGhost()
	sleep(25);
	EnableHeroAI(HERO_GHOST_OF_FLAMMSCHREIN, nil);
end;

x_ara_scene, y_ara_scene, floor_ara_scene = GetObjectPosition( HERO_PLAYER );
x_orn_scene, y_orn_scene, floor_orn_scene = GetObjectPosition( HERO_PLAYER_2 );

function f_speak_with_Flammschrein_ghost() -- Запускается триггером Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Flammschrein_Ghost_arrives", "f_speak_with_Flammschrein_ghost");
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Flammschrein_Ghost_arrives", nil);
	print("trigget_Flammschrein_Ghost_arrives_clear");
	SetObjectRotation(HERO_GHOST_OF_FLAMMSCHREIN, 270);
	sleep(1);
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "f_show_message_box_Gate_to_Flammschrein_002_2");
	sleep(3);
	SetObjectiveState('pri4', OBJECTIVE_ACTIVE, PLAYER_1);
	sleep(3);
	x_ara_scene, y_ara_scene, floor_ara_scene = GetObjectPosition( HERO_PLAYER );
	x_orn_scene, y_orn_scene, floor_orn_scene = GetObjectPosition( HERO_PLAYER_2 );
	SetObjectPosition( HERO_PLAYER, 134, 128, GROUND );
	SetObjectPosition( HERO_PLAYER_2, 132, 128, GROUND );
	SetObjectRotation( HERO_PLAYER, 90 );
	SetObjectRotation( HERO_PLAYER_2, 90 );
	UnblockGame();	
	StartAdvMapDialog (0, "f_speak_with_Flammschrein_ghost_continue");   -------------------------------------------------------------------2_advmap_dialog!!
end;

function f_speak_with_Flammschrein_ghost_continue()
	print("f_speak_with_Flammschrein_ghost_continue_start");

	BlockGame();
	print ("Teleport_heroes");
	sleep(1);

	SetObjectPosition( HERO_PLAYER, x_ara_scene, y_ara_scene, floor_ara_scene );
	SetObjectPosition( HERO_PLAYER_2, x_orn_scene, y_orn_scene, floor_orn_scene );
	sleep(4);

	UnblockGame();
	print( "Game unblocked." );
	
	if ALTAR_BROKEN == 0 then
		print ("detected Altar is not broken");
		Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_NORD, "f_check_capture_enemy_castles");
		Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_OST, "f_check_capture_enemy_castles");
		Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, "f_check_capture_enemy_castles");
		Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, "f_check_capture_enemy_castles");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_1", "f_check_capture_enemy_castles");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_2", "f_check_capture_enemy_castles");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_3", "f_check_capture_enemy_castles");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_4", "f_check_capture_enemy_castles");
		ALTAR_BROKEN = 2;
		f_check_capture_enemy_castles();
	end;		
	if ALTAR_BROKEN == 1 then
		print ("detected Altar is broken");
		Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_NORD, "f_check_capture_enemy_castles_altar_broken");
		Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_OST, "f_check_capture_enemy_castles_altar_broken");
		Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, "f_check_capture_enemy_castles_altar_broken");
		Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, "f_check_capture_enemy_castles_altar_broken");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_1", "f_check_capture_enemy_castles_altar_broken");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_2", "f_check_capture_enemy_castles_altar_broken");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_3", "f_check_capture_enemy_castles_altar_broken");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_4", "f_check_capture_enemy_castles_altar_broken");
		f_check_capture_enemy_castles_altar_broken();
	end;

	f_check_ghost_talk();
end;

function f_check_capture_enemy_castles()
	
	town_counter();
	
	if( GetObjectOwner(OBJECT_ENEMY_TOWN_NORD) ~= PLAYER_1 ) then return end;
	if( GetObjectOwner(OBJECT_ENEMY_TOWN_CENTER) ~= PLAYER_1 ) then return end;
	if( GetObjectOwner(OBJECT_ENEMY_TOWN_SUD_WEST) ~= PLAYER_1 ) then return end;
	if( GetObjectOwner(OBJECT_ENEMY_TOWN_OST) ~= PLAYER_1 ) then return end;
	
	if( IsObjectExists(HERO_PLAYER_2) == nil ) then return end;
	if( IsObjectExists(HERO_FREE) == nil ) then return end;
	if( IsObjectExists(HERO_FREE_2) == nil ) then return end;
	if( IsObjectExists(HERO_FREE_3) == nil ) then return end;

	if ( f_check_hero_in_ritual_zone( HERO_PLAYER_2 ) == nil ) then return end;
	if ( f_check_hero_in_ritual_zone( HERO_FREE ) == nil ) then return end;
	if ( f_check_hero_in_ritual_zone( HERO_FREE_2 ) == nil ) then return end;
	if ( f_check_hero_in_ritual_zone( HERO_FREE_3 ) == nil ) then return end;

	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_1", nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_2", nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_3", nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_4", nil);
	
	startThread(Start_ritual_scene_1);	
end;

function Start_ritual_scene_1()		
	startThread(Orn_dialog);
end;

function Start_ritual_scene_2()
	--	BlockGame(); ---------------------------!!!!
	MakeHeroReturnToTavernAfterDeath(HERO_FREE, 0); -- НЕВозвращение героя в таверну
	MakeHeroReturnToTavernAfterDeath(HERO_FREE_2, 0); -- НЕВозвращение героя в таверну
	MakeHeroReturnToTavernAfterDeath(HERO_FREE_3, 0); -- НЕВозвращение героя в таверну
	MakeHeroReturnToTavernAfterDeath(HERO_PLAYER_2, 0); -- НЕВозвращение героя в таверну
	print("RITUAL_START_0");
	OpenCircleFog(44, 154, 0, 10, 1);		
	sleep(4);
	MoveCamera(44, 154, 0, 30, 1, 3.14, 0, 0, 1);		
	sleep(6);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", OBJECT_RITUAL_TILE_1, 0, 0, 0, 0, 0 )
	print("0_________________0");
	if	RITUAL_STARTS ~= 1 then ---------------------------1.300
		Play2DSound( "/Sounds/_(Sound)/Spells/Plague.xdb#xpointer(/Sound)" ); ----------------SFX_plague
	end; ---------------------------------------------1.300		
	sleep(25);
	OpenCircleFog(65, 111, 0, 10, 1);		
	sleep(4);
	MoveCamera(65, 111, 0, 30, 1, 1.57, 0, 0, 1);		
	sleep(6);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", OBJECT_RITUAL_TILE_2, 0, 0, 0, 0, 0 );
	print("0_________________0");
	if	RITUAL_STARTS ~= 1 then ---------------------------1.300
		Play2DSound( "/Sounds/_(Sound)/Spells/Plague.xdb#xpointer(/Sound)" ); ----------------SFX_plague
	end; ---------------------------------------------1.300			
	sleep(25);
	OpenCircleFog(20, 12, 0, 10, 1);		
	sleep(4);
	MoveCamera(20, 12, 0, 30, 1, 1.57, 0, 0, 1);		
	sleep(6);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", OBJECT_RITUAL_TILE_3, 0, 0, 0, 0, 0 );
	print("0_________________0");
	if	RITUAL_STARTS ~= 1 then ---------------------------1.300
		Play2DSound( "/Sounds/_(Sound)/Spells/Plague.xdb#xpointer(/Sound)" ); ----------------SFX_plague
	end; ---------------------------------------------1.300		
	sleep(25);
	OpenCircleFog(149, 67, 0, 10, 1);		
	sleep(4);
	MoveCamera(149, 67, 0, 30, 1, 3.925, 0, 0, 1);		
	sleep(6);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", OBJECT_RITUAL_TILE_4, 0, 0, 0, 0, 0 );
	print("0_________________0");
	if	RITUAL_STARTS ~= 1 then ---------------------------1.300
		Play2DSound( "/Sounds/_(Sound)/Spells/Plague.xdb#xpointer(/Sound)" ); ----------------SFX_plague
	end; ---------------------------------------------1.300				
	sleep(5);							
	SetObjectiveVisible('pri5', nil, PLAYER_1);
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, nil);
	sleep(3);
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, "f_check_player_main_hero_death_2");
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, "f_check_Flammschrein_captured_2");
	OpenCircleFog(137, 128, 0, 10, 1);		
	sleep(5);
	print ("CHECK001");
		if (IsHeroAlive(HERO_FREE) == not nil) then	
			RemoveObject(HERO_FREE);
		end;
		if (IsHeroAlive(HERO_FREE_2) == not nil) then	
			RemoveObject(HERO_FREE_2);
		end;
		if (IsHeroAlive(HERO_FREE_3) == not nil) then	
			RemoveObject(HERO_FREE_3);
		end;
		if (IsHeroAlive(HERO_PLAYER_2) == not nil) then	
			RemoveObject(HERO_PLAYER_2);
		end;
	print ("CHECK002");
		if (IsHeroAlive(HERO_GHOST_OF_FLAMMSCHREIN) == not nil) then
			RemoveObject(HERO_GHOST_OF_FLAMMSCHREIN);
		end;
	if	RITUAL_STARTS ~= 1 then ---------------------------1.300
		f_show_message_magic_barrier_disappears_022();
	end; ---------------------------------------------1.300	
	MoveCamera(137, 128, 0, 30, 1, 4.71, 0, 0, 1);
	sleep(6);
	if (IsObjectExists( OBJECT_FIRE_WALL ) == not nil) then
		if	RITUAL_STARTS ~= 1 then ---------------------------1.300
			PlayVisualEffect( "/Effects/_(Effect)/Spells/UnholyWord.xdb#xpointer(/Effect)", OBJECT_FIRE_WALL, 0, 0, 0, 6, 0 );
			sleep(4);
			Play2DSound( "/Sounds/_(Sound)/Spells/UnholyWord.xdb#xpointer(/Sound)" ); ----------------BARIER
			end; ---------------------------------------------1.300	
		end;
	print ("CHECK003");
	sleep(45);
		if (IsObjectExists( OBJECT_FIRE_WALL ) == not nil) then	
			RemoveObject(OBJECT_FIRE_WALL);
		end;
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "1_block_zone_for_player2", nil);	
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_NORD, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_OST, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, nil);
	SetObjectEnabled(OBJECT_GATE_TO_FLAMMSCHREIN, not nil);
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "f_check_capture_gate_to_Flammschrein");
	sleep(3);
	UnblockGame();
		if GetObjectiveState("pri4") ~= OBJECTIVE_COMPLETED  then	
			SetObjectiveState("pri4", OBJECTIVE_COMPLETED, PLAYER_1);
		end;
	sleep(10);
	Play2DSound( "/Maps/Scenario/A2C1M5/C1M5_AM3_Arantir_01sound.xdb#xpointer(/Sound)" ); ----------------VO-------1.300
end;

function f_check_capture_enemy_castles_altar_broken()
	
	town_counter_altar_broken();
	
	if( GetObjectOwner(OBJECT_ENEMY_TOWN_NORD) ~= PLAYER_1 ) then return end;
	if( GetObjectOwner(OBJECT_ENEMY_TOWN_CENTER) ~= PLAYER_1 ) then return end;
	if( GetObjectOwner(OBJECT_ENEMY_TOWN_SUD_WEST) ~= PLAYER_1 ) then return end;
	if( GetObjectOwner(OBJECT_ENEMY_TOWN_OST) ~= PLAYER_1 ) then return end;
	
	if( IsObjectExists(HERO_PLAYER_2) == nil ) then return end;
	if( IsObjectExists(HERO_FREE) == nil ) then return end;
	if( IsObjectExists(HERO_FREE_2) == nil ) then return end;
	if( IsObjectExists(HERO_FREE_3) == nil ) then return end;

	if ( f_check_hero_in_ritual_zone( HERO_PLAYER_2 ) == nil ) then return end;
	if ( f_check_hero_in_ritual_zone( HERO_FREE ) == nil ) then return end;
	if ( f_check_hero_in_ritual_zone( HERO_FREE_2 ) == nil ) then return end;
	if ( f_check_hero_in_ritual_zone( HERO_FREE_3 ) == nil ) then return end;
		
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_1", nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_2", nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_3", nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_4", nil);
		
	startThread(Orn_dialog);
	sleep(5);           -----------------------------------------------------------------------!!!!

	BlockGame();	
	MakeHeroReturnToTavernAfterDeath(HERO_FREE, 0); -- НЕВозвращение героя в таверну
	MakeHeroReturnToTavernAfterDeath(HERO_FREE_2, 0); -- НЕВозвращение героя в таверну
	MakeHeroReturnToTavernAfterDeath(HERO_FREE_3, 0); -- НЕВозвращение героя в таверну
	MakeHeroReturnToTavernAfterDeath(HERO_PLAYER_2, 0); -- НЕВозвращение героя в таверну
	
	print("RITUAL_START_1");
	RITUAL_STARTS = 1; -------------------------------1.300
	OpenCircleFog(44, 154, 0, 10, 1);		
	sleep(4);
	MoveCamera(44, 154, 0, 30, 1, 3.14, 0, 0, 1);		
	sleep(6);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", OBJECT_RITUAL_TILE_1, 0, 0, 0, 0, 0 );
	print("1_________________1");
	Play2DSound( "/Sounds/_(Sound)/Spells/Plague.xdb#xpointer(/Sound)" ); ----------------SFX_plague		
	sleep(25);
	OpenCircleFog(65, 111, 0, 10, 1);		
	sleep(4);
	MoveCamera(65, 111, 0, 30, 1, 1.57, 0, 0, 1);		
	sleep(6);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", OBJECT_RITUAL_TILE_2, 0, 0, 0, 0, 0 );
	print("1_________________1");
	Play2DSound( "/Sounds/_(Sound)/Spells/Plague.xdb#xpointer(/Sound)" ); ----------------SFX_plague		
	sleep(25);
	OpenCircleFog(20, 12, 0, 10, 1);		
	sleep(4);
	MoveCamera(20, 12, 0, 30, 1, 1.57, 0, 0, 1);		
	sleep(6);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", OBJECT_RITUAL_TILE_3, 0, 0, 0, 0, 0 );
	print("1_________________1");
	Play2DSound( "/Sounds/_(Sound)/Spells/Plague.xdb#xpointer(/Sound)" ); ----------------SFX_plague		
	sleep(25);
	OpenCircleFog(149, 67, 0, 10, 1);		
	sleep(4);
	MoveCamera(149, 67, 0, 30, 1, 3.925, 0, 0, 1);		
	sleep(6);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", OBJECT_RITUAL_TILE_4, 0, 0, 0, 0, 0 );
	print("1_________________1");
	Play2DSound( "/Sounds/_(Sound)/Spells/Plague.xdb#xpointer(/Sound)" ); ----------------SFX_plague		
	sleep(5);							
	SetObjectiveVisible('pri5', nil, PLAYER_1);
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, nil);
	sleep(3);
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, "f_check_player_main_hero_death_2");
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, "f_check_Flammschrein_captured_2");
	OpenCircleFog(137, 128, 0, 10, 1);		
	sleep(5);
	print ("CHECK0011");
		if (IsHeroAlive(HERO_FREE) == not nil) then	
			RemoveObject(HERO_FREE);
		end;
		if (IsHeroAlive(HERO_FREE_2) == not nil) then	
			RemoveObject(HERO_FREE_2);
		end;
		if (IsHeroAlive(HERO_FREE_3) == not nil) then	
			RemoveObject(HERO_FREE_3);
		end;
		if (IsHeroAlive(HERO_PLAYER_2) == not nil) then	
			RemoveObject(HERO_PLAYER_2);
		end;
	print ("CHECK0022");
		if (IsHeroAlive(HERO_GHOST_OF_FLAMMSCHREIN) == not nil) then
			RemoveObject(HERO_GHOST_OF_FLAMMSCHREIN);
		end;
	f_show_message_magic_barrier_disappears_022();
	MoveCamera(137, 128, 0, 30, 1, 4.71, 0, 0, 1);
	sleep(3);
		if (IsObjectExists( OBJECT_FIRE_WALL ) == not nil) then
			PlayVisualEffect( "/Effects/_(Effect)/Spells/UnholyWord.xdb#xpointer(/Effect)", OBJECT_FIRE_WALL, 0, 0, 0, 6, 0 );
			sleep(4);
			Play2DSound( "/Sounds/_(Sound)/Spells/UnholyWord.xdb#xpointer(/Sound)" ); ----------------BARIER
		end;
	sleep(45);	
		if (IsObjectExists( OBJECT_FIRE_WALL ) == not nil) then	
			RemoveObject(OBJECT_FIRE_WALL);
		end;
--	Play2DSound( "/Maps/Scenario/A2C1M5/C1M5_AM3_Arantir_01sound.xdb#xpointer(/Sound)" ); ----------------VO ------1.300
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "1_block_zone_for_player2", nil);	
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_NORD, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_OST, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, nil);
	
	SetObjectEnabled(OBJECT_GATE_TO_FLAMMSCHREIN, not nil);
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "f_check_capture_gate_to_Flammschrein");
	sleep(1);
--	f_StartAdvMapDialog_AM1(); -- Заглушка. Должно быть C1M5_AM3	
	UnblockGame();
		if GetObjectiveState("pri4") ~= OBJECTIVE_COMPLETED  then	
			SetObjectiveState("pri4", OBJECTIVE_COMPLETED, PLAYER_1);
		end;	
--	startThread(Orn_dialog);
end;

x_ara, y_ara, floor_ara = 0,0,0
x_orn, y_orn, floor_orn = 0,0,0
function Orn_dialog() 
	f_show_message_box_touch_Ghosts_idle_008(); ------------------------------!!!!!!
	sleep(2)
	BlockGame();
	x_ara, y_ara, floor_ara = GetObjectPosition( HERO_PLAYER );
	x_orn, y_orn, floor_orn = GetObjectPosition( HERO_PLAYER_2 );
	SetObjectPosition( HERO_PLAYER, 23, 13, GROUND );
	SetObjectPosition( HERO_PLAYER_2, 23, 11, GROUND );
	sleep(1)
	SetObjectRotation( HERO_PLAYER, 0 );
	SetObjectRotation( HERO_PLAYER_2, 180 );
	sleep(2)
	StartAdvMapDialog (8, "Orn_dialog2");   -------------------------------------------------------------------8_advmap_dialog!!
end;

function Orn_dialog2()
	SetObjectPosition( HERO_PLAYER, x_ara, y_ara, floor_ara );
	SetObjectPosition( HERO_PLAYER_2, x_orn, y_orn, floor_orn );
	startThread(Start_ritual_scene_2);	
end;


--pri6
function f_pri6() --Запускается триггером Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Stop_for_player", "f_pri6")
	BlockGame();
	DeployReserveHero(MOCHAB, 153, 133, GROUND);
	OpenCircleFog(153, 133, GROUND, 4, 1);
	sleep(3);
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Mochab_in_town", "f_Mochab_in_town");
	SetObjectRotation(MOCHAB, 270);
	MoveCamera(153, 133, 0, 40, 1, 4.71, 0, 0, 1);		
	sleep(6);
	f_show_message_meet_Mochab_020();
	sleep(8);
	MoveHeroRealTime(MOCHAB, 158, 151, GROUND);
end;

function f_Mochab_in_town() --Запускается триггером Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Mochab_in_town", "f_Mochab_in_town");
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Mochab_in_town", nil);
	Trigger(PLAYER_REMOVE_HERO_TRIGGER, 3, "f_pri6_success");
	SetObjectiveState('pri6', OBJECTIVE_ACTIVE, PLAYER_1);	
	SetRegionBlocked("2_block_zone_for_player2", 1, PLAYER_3);
	SetRegionBlocked("Flammschrein_Ghost_arrives", 1, PLAYER_1);
	sleep(4);
	UnblockGame();
	sleep(2);
	f_save();
end;

function f_pri6_success() --Запускается триггером Trigger(PLAYER_REMOVE_HERO_TRIGGER, 3, "f_pri6_success")
	if (IsHeroAlive(MOCHAB) == nil) then
	    Trigger(PLAYER_REMOVE_HERO_TRIGGER, 3, nil);
		SetObjectiveState('pri6', OBJECTIVE_COMPLETED, PLAYER_1);
	end;
end;

-----------------------------------------------------------------------
--*-- SECONDARY QUESTS --*--
-----------------------------------------------------------------------

--sec2
function f_check_ghost_talk()
	print("f_check_ghost_talk_start");
	BlockGame();
	--Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_DEALER, nil);
	Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_TARGET, nil);
	print ("Assasins_quest_disable_1");
    f_show_message_box_Ghosts_quest_003()
	sleep(3);
	Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_TARGET, "f_sec1");
    SetObjectiveState('sec2', OBJECTIVE_ACTIVE, PLAYER_1);
	--Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_DEALER, "f_check_ghost_talk2");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "1_block_zone_for_player2", "f_check_ghost_talk2");
	OpenCircleFog(93, 57, GROUND, 6, 1);		
	sleep(4);
	MoveCamera(93, 57, 0, 30, 1, 1.57, 0, 0, 1);	
	OpenCircleFog(100, 60, GROUND, 6, 1);		
	sleep(17);
	MoveCamera(100, 60, 0, 30, 1, 1.57, 0, 0, 1);	
	OpenCircleFog(122, 120, GROUND, 6, 1);		
	sleep(17);
	MoveCamera(122, 120, 0, 30, 1, 1.57, 0, 0, 1);
	UnblockGame();
end;

f_check_ghost_talk2_done = 0;
f_ghost_talk2_msgno = 0;
function f_check_ghost_talk2()
	if f_check_ghost_talk2_done ~= 0 then return end;
	if (IsObjectExists(CREATURE_QUEST_TARGET) == not nil) then
		print ("Trigger_on");
		heroesInRegion = table.length(GetObjectsInRegion( '1_block_zone_for_player2', OBJECT_HERO ));
		sleep(4);
		if heroesInRegion > 0 then
			MoveCamera(139, 128, 0, 40, 1, 0.785, 0, 0, 1);
			sleep(8);
			if f_ghost_talk2_msgno == 0 then
				startThread( f_show_message_box_Ghosts_quest_005 );
				print ("message_chost");	
			end;
		end;	
		return 
	end;
	if (IsObjectExists(CREATURE_QUEST_TARGET) ~= not nil) then
		heroesInRegion = table.length(GetObjectsInRegion( '1_block_zone_for_player2', OBJECT_HERO ));
		sleep(2);
			print( "heroesInRegion " .. heroesInRegion )
		if heroesInRegion > 0 then
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "1_block_zone_for_player2", nil );			
			f_check_ghost_talk2_done = 1;
			BlockGame();
			MoveCamera(139, 128, 0, 40, 1, 0.785, 0, 0, 1);
			Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_GOLD, nil);
			Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_HERO, nil);
			Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_TREES, nil);
			Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TOMB, nil);
			SetObjectEnabled(OBJECT_TOMB, not nil);
			SetObjectEnabled(OBJECT_TELEPORT_TO_GOLD, not nil);
			SetObjectEnabled(OBJECT_TELEPORT_TO_HERO, not nil);
			SetObjectEnabled(OBJECT_TELEPORT_TO_TREES, not nil);
			sleep(12);
			f_show_message_box_Ghosts_quest_006();
			x_ara_scene, y_ara_scene, floor_ara_scene = GetObjectPosition( HERO_PLAYER );
			x_orn_scene, y_orn_scene, floor_orn_scene = GetObjectPosition( HERO_PLAYER_2 );
			SetObjectPosition( HERO_PLAYER, 134, 128, GROUND );
			SetObjectPosition( HERO_PLAYER_2, 132, 128, GROUND );
			SetObjectRotation( HERO_PLAYER, 90 );
			SetObjectRotation( HERO_PLAYER_2, 90 );
			UnblockGame();
			StartAdvMapDialog (2, "f_check_ghost_talk2_continue");   ----------------------------------------------------2_advmap_dialog
		end;
	end;
end;


function f_check_ghost_talk2_continue()
	BlockGame();
	sleep(3);
	SetObjectiveState("sec2", OBJECTIVE_COMPLETED, PLAYER_1);
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_GOLD, "f_check_portal_gold");
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_HERO, "f_check_portal_hero");
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_TREES, "f_check_portal_trees");
	sleep(1);
	SetObjectPosition( HERO_PLAYER, x_ara_scene, y_ara_scene, floor_ara_scene );
	SetObjectPosition( HERO_PLAYER_2, x_orn_scene, y_orn_scene, floor_orn_scene );
	sleep(3);		
	OpenCircleFog(104, 60, GROUND, 6, 1);		
	sleep(4);
	MoveCamera(104, 60, 0, 30, 1, 0, 0, 0, 1);
	OpenCircleFog(100, 64, GROUND, 6, 1);		
	sleep(8);
	MoveCamera(100, 64, 0, 30, 1, 0, 0, 0, 1);
	OpenCircleFog(97, 60, GROUND, 6, 1);		
	sleep(8);
	MoveCamera(97, 60, 0, 30, 1, 0, 0, 0, 1);		
	UnblockGame();
end;

function f_CREATURE_QUEST_TARGET_is_alive(hero) -- Запускается триггером Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_TARGET, "f_CREATURE_QUEST_TARGET_is_alive");
	BlockGame();
	Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_TARGET, nil);
	print ("Assasins_trigger_disable");
	SetObjectEnabled(CREATURE_QUEST_TARGET, not nil);
	print ("Assasins_mobs_enable");
	AvengerName = hero;
	sleep(4);
	MakeHeroInteractWithObject( hero, CREATURE_QUEST_TARGET );
	sleep(10);
	AvengerName = "";
	UnblockGame();	

	while (IsObjectExists(CREATURE_QUEST_TARGET) == not nil) do sleep(5); end;
	f_check_ghost_talk2();
end;

function f_check_portal_gold()
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_HERO, "f_show_message_box_touch_closed_portal_007");
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_TREES, "f_show_message_box_touch_closed_portal_007");
	SetObjectEnabled(OBJECT_TELEPORT_TO_HERO, nil);
	SetObjectEnabled(OBJECT_TELEPORT_TO_TREES, nil);
end;

function f_check_portal_hero()
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_GOLD, "f_show_message_box_touch_closed_portal_007");
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_TREES, "f_show_message_box_touch_closed_portal_007");
	SetObjectEnabled(OBJECT_TELEPORT_TO_GOLD, nil);
	SetObjectEnabled(OBJECT_TELEPORT_TO_TREES, nil);
end;

function f_check_portal_trees()
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_HERO, "f_show_message_box_touch_closed_portal_007");
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_GOLD, "f_show_message_box_touch_closed_portal_007");
	SetObjectEnabled(OBJECT_TELEPORT_TO_GOLD, nil);
	SetObjectEnabled(OBJECT_TELEPORT_TO_HERO, nil);
end;

function f_sec1(hero)
	AvengerName = hero;
	BlockGame();
	x_ara, y_ara, floor_ara = GetObjectPosition( HERO_PLAYER );
	sleep(3);
	SetObjectPosition( HERO_PLAYER, 94, 60, GROUND );
	SetObjectRotation( HERO_PLAYER, 0 );
	sleep(2);
	StartAdvMapDialog ( 3, "f_sec1_continue" );   -------------------------------------------------------------3_advmap_dialog
end;

function f_sec1_continue()
	sleep(5);
	UnblockGame();
	QuestionBox("/Maps/Scenario/A2C1M5/messagebox_015.txt", "f_report_yes", "f_report_no");
end;

-- Функция выдающая положительный отчет.
function f_report_yes(hero)
	f_check_ghost_talk2_done = 1;
	sleep(5);
	SetObjectPosition( HERO_PLAYER, x_ara, y_ara, floor_ara );

	BlockGame();
	OpenCircleFog(16, 140, 0, 6, 1);
	OpenCircleFog(23, 138, 0, 5, 1);
	RemoveObject(CREATURE_QUEST_TARGET);
	RemoveObject(OBJECT_FIRE_FOR_ALTAR);
	RemoveObject(CREATURE_INFERNO_1);
	sleep(4);
	CreateMonster("Succubus_target", CREATURE_INFERNAL_SUCCUBUS , 1, 22, 138, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, 90);
	sleep(4);
	MoveCamera(21, 138, 0, 27, 1, 0, 0, 0, 1);
	sleep(9);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", OBJECT_UNDER_ASSASSIN, 0, 0, 0, 0, 0 );
	sleep(3);
	CreateMonster("Assassin_killer", CREATURE_ASSASSIN, 1, 20, 138, GROUND, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 90);
	sleep(6);
	StartAdvMapDialog (4);   ---------------------------------------------------------------4_advmap_dialog
	sleep(3);
	PlayObjectAnimation( "Assassin_killer", "attack00", ONESHOT_STILL );
	sleep(6);
	PlayObjectAnimation( "Succubus_target", "death", ONESHOT_STILL );
	sleep(9);
	PlayObjectAnimation( "Assassin_killer", "stir02", ONESHOT_STILL );
	sleep(9);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", OBJECT_UNDER_SUCCUBUS, 0, 0, 0, 0, 0 );
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", OBJECT_UNDER_ASSASSIN, 0, 0, 0, 0, 0 );
	sleep(3);
	RemoveObject("Succubus_target");
	RemoveObject("Assassin_killer");
    SetObjectiveState('sec1', OBJECTIVE_ACTIVE, PLAYER_1);
	SetObjectiveState('sec2', OBJECTIVE_FAILED, PLAYER_1);
	-- Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_DEALER, nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Alarm_succubus", nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Fire_hug", nil);	
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Post_Alarm_succubus", nil);
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_INFERNO_ALTAR, "f_ready_destroy_altar");
	-- Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_DEALER, "f_show_message_sec2_failed_016");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "1_block_zone_for_player2", "f_show_message_sec2_failed_016");
	AvengerName = "";
	UnblockGame();
	startThread(f_check_capture_enemy_castles);  
end;

-- Функция, выдающая отрицательный отчет.
function f_report_no()
	sleep(5);
	SetObjectPosition( HERO_PLAYER, x_ara, y_ara, floor_ara );

	BlockGame();
	Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_TARGET, nil);
	print ("Assasins_quest_disable_3");
	SetObjectEnabled(CREATURE_QUEST_TARGET, not nil);
	print ("Assasins_ENABLE_2");
	sleep(4);
	MakeHeroInteractWithObject( AvengerName, CREATURE_QUEST_TARGET );
	sleep(10);
	AvengerName = "";
	UnblockGame();
	
	f_ghost_talk2_msgno = 1;

	while (IsObjectExists(CREATURE_QUEST_TARGET) == not nil) do sleep(5); end;
	f_check_ghost_talk2();
end;

function f_ready_destroy_altar(hero) -- запускается триггером Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_INFERNO_ALTAR, "f_ready_destroy_altar")
	if ( GetObjectOwner( hero ) == PLAYER_1 ) then 
		if (GetHeroStat(hero, STAT_SPELL_POWER) <= 9) then
			f_show_message_not_enough_SP_to_destroy_altar_033() return not nil end;
		if (GetHeroStat(hero, STAT_SPELL_POWER) >= 10) then	
			if ALTAR_BROKEN == 0 then
				ALTAR_BROKEN = 1;				
				BlockGame();
				sleep(4);
				SetObjectPosition(hero, 19, 138, GROUND);	
				sleep(8);			
				Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_INFERNO_ALTAR, nil);
				Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_NORD, "town_counter_altar_broken");
				Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, "town_counter_altar_broken");
				Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, "town_counter_altar_broken");
				Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_OST, "town_counter_altar_broken");				
				MoveCamera(23, 138, 0, 35, 1, 4.71, 0, 0, 1);
				sleep(2);
				PlayVisualEffect( "/Effects/_(Effect)/Spells/Armageddon.xdb#xpointer(/Effect)", OBJECT_INFERNO_ALTAR, 0, 0, 0, 0, 0 );
				Play2DSound( "/Sounds/_(Sound)/Spells/Armageddon.xdb#xpointer(/Sound)" ); ----------------DESTROY_ALTAR_SDN
				sleep(24);
				RemoveObject(OBJECT_INFERNO_REMOVED);
				RemoveObject(OBJECT_INFERNO_REMOVED_2);
				RemoveObject(OBJECT_INFERNO_REMOVED_3);
				RemoveObject(OBJECT_INFERNO_REMOVED_4);
				RemoveObject(OBJECT_INFERNO_REMOVED_5);
				RemoveObject(OBJECT_INFERNO_REMOVED_6);
				RemoveObject(OBJECT_INFERNO_REMOVED_7);
				RemoveObject(OBJECT_INFERNO_REMOVED_8);
				RemoveObject(OBJECT_INFERNO_REMOVED_9);
				RemoveObject(OBJECT_INFERNO_REMOVED_10);
				SetObjectPosition(OBJECT_SMOKE_FOR_ALTAR_2, 16, 139, GROUND);
				Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_INFERNO_ALTAR, "f_show_message_broken_altar_touch_019");
				UnblockGame();	
				SetObjectiveState('sec1', OBJECTIVE_COMPLETED, PLAYER_1);
			end;
			if ALTAR_BROKEN == 2 then
				BlockGame();
				sleep(4);
				SetObjectPosition(hero, 19, 138, GROUND);	
				sleep(8);
				Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_INFERNO_ALTAR, nil);
				Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_NORD, "f_check_capture_enemy_castles_altar_broken");
				Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_OST, "f_check_capture_enemy_castles_altar_broken");
				Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, "f_check_capture_enemy_castles_altar_broken");
				Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, "f_check_capture_enemy_castles_altar_broken");
				Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_1", "f_check_capture_enemy_castles_altar_broken");
				Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_2", "f_check_capture_enemy_castles_altar_broken");
				Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_3", "f_check_capture_enemy_castles_altar_broken");
				Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Ritual_4", "f_check_capture_enemy_castles_altar_broken");
				MoveCamera(23, 138, 0, 35, 1, 4.71, 0, 0, 1);
				sleep(2);
				PlayVisualEffect( "/Effects/_(Effect)/Spells/Armageddon.xdb#xpointer(/Effect)", OBJECT_INFERNO_ALTAR, 0, 0, 0, 0, 0 );
				Play2DSound( "/Sounds/_(Sound)/Spells/Armageddon.xdb#xpointer(/Sound)" ); ----------------DESTROY_ALTAR_SDN
				sleep(24);
				RemoveObject(OBJECT_INFERNO_REMOVED);
				RemoveObject(OBJECT_INFERNO_REMOVED_2);
				RemoveObject(OBJECT_INFERNO_REMOVED_3);
				RemoveObject(OBJECT_INFERNO_REMOVED_4);
				RemoveObject(OBJECT_INFERNO_REMOVED_5);
				RemoveObject(OBJECT_INFERNO_REMOVED_6);
				RemoveObject(OBJECT_INFERNO_REMOVED_7);
				RemoveObject(OBJECT_INFERNO_REMOVED_8);
				RemoveObject(OBJECT_INFERNO_REMOVED_9);
				RemoveObject(OBJECT_INFERNO_REMOVED_10);
				SetObjectPosition(OBJECT_SMOKE_FOR_ALTAR_2, 16, 139, GROUND);
				Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_INFERNO_ALTAR, "f_show_message_broken_altar_touch_019");
				UnblockGame();	
				SetObjectiveState('sec1', OBJECTIVE_COMPLETED, PLAYER_1);
			end;
		end;			
	end;			
end;

function f_succubus(hero) -- запускается триггером Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Alarm_succubus", "f_succubus")
	BlockGame();
	DevastatorName = hero;
	SetObjectPosition(CREATURE_INFERNO_1, 141, 166, GROUND);
	SetObjectPosition(OBJECT_FIRE_FOR_ALTAR, 22, 138, GROUND);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Fire_hug", "f_show_message_fire_hug_017");
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Post_Alarm_succubus", "f_succubus_return");
	f_show_message_incinerate_fire_028();
	UnblockGame();
end;

function f_succubus_return(hero) -- запускается триггером Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Post_Alarm_succubus", "f_succubus_return")
	if DevastatorName == hero then
		DevastatorName = "";
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Post_Alarm_succubus", nil);
		SetObjectPosition(CREATURE_INFERNO_1, 22, 138, GROUND);
		SetObjectPosition(OBJECT_FIRE_FOR_ALTAR, 140, 166, GROUND);
		MoveCamera(22, 138, 0, 35, 1, 4.71, 0, 0, 1);
		sleep(1);
		startThread( f_show_message_succubus_return_018 );
	end;
end;

x_to_return, y_to_return, floor_to_return = GetObjectPosition( "Arantir" );

function f_meet_paladin( heroName ) -- Запускается триггером Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_FALLEN_PALADIN, "f_meet_paladin");
	Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_FALLEN_PALADIN, "f_show_message_paladin_speak_save_us_025");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Soulkeeper_speaks_go_away", nil);
	SetRegionBlocked("6_block_zone_for_AI_players", nil, PLAYER_1);
	if heroName ~= "Arantir" then
		SetRegionBlocked( "RegionToArantir", nil );
		local x, y = RegionToPoint( "RegionToArantir" );
		x_to_return, y_to_return, floor_to_return = GetObjectPosition( "Arantir" );
		SetObjectRotation( "Arantir", 315 );
		SetObjectPosition( "Arantir", x, y, GROUND );
		BlockGame();
		sleep(2);
		UnblockGame();
	end;
	SetObjectPosition( HERO_PLAYER, 129, 3, GROUND );
	SetObjectRotation( HERO_PLAYER, 270 );
	StartAdvMapDialog (5, "ReturnArantirBack");   --------------------------------5_advmap_dialog
end;

function ReturnArantirBack()
	if table.length(GetObjectsInRegion( "RegionToArantir", OBJECT_HERO )) > 0 then -- if Arantir is in region he needs to return back
		SetObjectPosition( "Arantir", x_to_return, y_to_return, floor_to_return );
	end;
	sleep(5);
	OpenCircleFog(169, 67, 0, 12, 1);		
	sleep(4);
	MoveCamera(169, 67, 0, 40, 1, 0.935, 0, 0, 1);
	SetObjectiveState('sec3', OBJECTIVE_ACTIVE, PLAYER_1);
	startThread( f_sec_3_success );
end;

function f_sec_3_success()
	while 1 do
		if (IsObjectExists(HERO_SOULKEEPER) == nil) then
			SetObjectPosition(OBJECT_SULFUR_01, 169, 66, GROUND);
			Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_FALLEN_PALADIN, nil);
			OpenCircleFog(126, 2, 0, 5, 1);		
			sleep(2);
			MoveCamera(126, 2, 0, 30, 1, 2.355, 0, 0, 1);
			sleep(3);
			PlayVisualEffect( "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)", CREATURE_FALLEN_PALADIN, 0, 0, 0, 0, 0 );
			sleep(3);
			RemoveObject(CREATURE_FALLEN_PALADIN);
			sleep(3);
			CreateMonster("Death_Knight", CREATURE_DEATH_KNIGHT, 15, 126, 2, GROUND, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 135);
			SetObjectiveState("sec3", OBJECTIVE_COMPLETED, PLAYER_1);
			x_ara_scene, y_ara_scene, floor_ara_scene = GetObjectPosition( HERO_PLAYER );
			BlockGame();
			sleep(5);
			SetObjectPosition( HERO_PLAYER, 129, 3, GROUND );
			SetObjectRotation( HERO_PLAYER, 270 );
			StartAdvMapDialog (6);   --------------------------------6_advmap_dialog
			sleep(15);
			UnblockGame();
			SetDisabledObjectMode( "Death_Knight" , DISABLED_INTERACT );
			sleep(10);
			SetObjectPosition( HERO_PLAYER, x_ara_scene, y_ara_scene, floor_ara_scene );
			break;
		end;
		sleep(2);
	end;			
end;

function f_Deactivator_for_Soulkeeper_speaks_go_away(hero) -- Запускается триггером Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Deactivator_Soulkeeper_speaks_go_away", "f_Deactivator_for_Soulkeeper_speaks_go_away");
	if NearSoulkeeperName == hero then
		NearSoulkeeperName = "";
		SetRegionBlocked("6_block_zone_for_AI_players", nil, PLAYER_1);
	end;
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
		Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, nil);
		SetAmbientLight(0, "Daylight", not nil, 10);
    end;
end;

function f_save() -- Первоначально запускается функцией function f_Mochab_in_town(). После - триггером Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Stop_for_player", "f_save");
-- ВАЖНО! Сейчас к этому моменту у игрока может быть максимум два героя - Арантир и Валерия. Если в очередной раз сюжет перелопатят - надо добавить вариант с другими героями. Фламмшрайн сейчас должен штурмовать только Арантир.	
	if ( IsObjectInRegion( HERO_PLAYER, 'Stop_for_player' ) == not nil ) then
		SetRegionBlocked("Flammschrein_Ghost_arrives", nil, PLAYER_1);
		print ("Flamm_on_Arantir!!!");
		GoToFlammschreinName = HERO_PLAYER;
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Deactivator_for_Flammschrein_Ghost_arrives", "f_HERO_PLAYER_Deactivator_for_Flammschrein_Ghost_arrives");
		f_show_message_Arantir_ready_go_to_Flammschrein_029();
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Stop_for_player", nil); -----Add_stop message
		sleep(2);
--		Save("The_Mysteries_of_Flammschrein");
	end;

	if (IsObjectExists(HERO_PRISONER) == not nil) then	
		if ( IsObjectInRegion( HERO_PRISONER, 'Stop_for_player' ) == not nil ) then
			SetRegionBlocked("Flammschrein_Ghost_arrives", 1, PLAYER_1);
			print ("Flamm_of_warning_Valeria!!!");
			GoToFlammschreinName = HERO_PRISONER;
			Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Deactivator_for_Flammschrein_Ghost_arrives", "f_HERO_PRISONER_Deactivator_for_Flammschrein_Ghost_arrives");
			f_show_message_Valeria_does_not_wish_go_to_Flammschrein_030();
		end;
	end;	
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Stop_for_player", "f_save");
--	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Stop_for_player", nil); -----Add_stop message
end;

function f_HERO_PLAYER_Deactivator_for_Flammschrein_Ghost_arrives(hero) -- Запускается триггером Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Deactivator_for_Flammschrein_Ghost_arrives", "f_HERO_PLAYER_Deactivator_for_Flammschrein_Ghost_arrives");
	if hero == HERO_PLAYER then
		SetRegionBlocked("Flammschrein_Ghost_arrives", nil, PLAYER_1);
		GoToFlammschreinName = "";
	end;
end;

function f_HERO_PRISONER_Deactivator_for_Flammschrein_Ghost_arrives(hero) -- Запускается триггером Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Deactivator_for_Flammschrein_Ghost_arrives", "f_HERO_PRISONER_Deactivator_for_Flammschrein_Ghost_arrives");
	if hero == HERO_PRISONER then
		SetRegionBlocked("Flammschrein_Ghost_arrives", nil, PLAYER_1);
		GoToFlammschreinName = "";
	end;
end;



function f_StartDialogScene_S1()
	StartDialogScene("/DialogScenes/A2C1/M5/S1/DialogScene.xdb#xpointer(/DialogScene)", "f_win"); -- FINAL DIALOGSCENE
end;

---------------------------------------------------
--*-- CAMERA MOVE FUNCTIONS --*--
---------------------------------------------------
function f_open_fog_115_81()
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_SIGN_01, nil);
	OpenCircleFog(115, 81, 0, 3, 1);
end;

function f_open_fog_123_124()
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_SIGN_02, nil);
	OpenCircleFog(123, 124, 0, 3, 1);
end;

function f_open_fog_137_128()
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_SIGN_03, nil);
	OpenCircleFog(137, 128, 0, 9, 1);
end;

---------------------------------------------------
--*-- MESSAGEBOX FUNCTIONS --*--
---------------------------------------------------

function f_show_message_box_Oracle_001()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_001.txt");
end;

function f_show_message_box_Oracle_011()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_011.txt");
end;	

function f_show_message_box_Gate_to_Flammschrein_002()
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, nil);
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, nil);
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_002.txt");
	SetObjectiveState('pri3', OBJECTIVE_ACTIVE, PLAYER_1);
	sleep(4);
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, "f_check_find_oracle");	
	Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "f_show_message_box_Gate_to_Flammschrein_002_2");
end;

function f_show_message_box_Gate_to_Flammschrein_002_2()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_002.txt");	
end;

function f_show_message_box_Ghosts_quest_003()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_003.txt");
end;

function f_show_message_box_Assasin_talk_004()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_004.txt");
end;

function f_show_message_box_Ghosts_quest_005()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_005.txt");
end;

function f_show_message_box_Ghosts_quest_006()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_006.txt");
end;

function f_show_message_box_touch_closed_portal_007()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_007.txt");
end;

function f_show_message_box_touch_Ghosts_idle_008()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_008.txt");
end;

function f_show_message_box_Oracle_speak_009()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_009.txt");
end;

function f_show_message_box_touch_Tomb_010()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_010.txt");
end;

function f_show_message_hilfe_012()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_012.txt");
end;

function f_show_message_hilfe_013()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_013.txt");
end;

function f_show_message_hilfe_014()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_014.txt");
end;


function f_show_message_sec2_failed_016()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_016.txt");
end;

function f_show_message_fire_hug_017()
	if DevastatorName ~= "" then
		MessageBox("/Maps/Scenario/A2C1M5/messagebox_017.txt");
		sleep(1);
		RemoveObject(DevastatorName);
	end;
end;

function f_show_message_succubus_return_018()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_018.txt");
end;

function f_show_message_broken_altar_touch_019()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_019.txt");
end;

function f_show_message_meet_Mochab_020()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_020.txt");
end;

function f_show_message_old_alchemist_021()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_021.txt");
end;

function f_show_message_magic_barrier_disappears_022()
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_022.txt");
end;

function f_show_message_soulkeeper_speak_go_away_023(hero) -- Запускается триггером Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Soulkeeper_speaks_go_away", "f_show_message_soulkeeper_speak_go_away_023");
	BlockGame();
	NearSoulkeeperName = hero;
	SetRegionBlocked("6_block_zone_for_AI_players", 1, PLAYER_1);
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Deactivator_Soulkeeper_speaks_go_away", "f_Deactivator_for_Soulkeeper_speaks_go_away");	
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_023.txt");
	UnblockGame();
end;

function f_show_message_paladin_speak_save_us_025() -- Запускается триггером Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_FALLEN_PALADIN, "f_show_message_paladin_speak_save_us_025");
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_025.txt");
end;

function f_show_message_incinerate_fire_028() -- Запускается функцией function f_succubus(hero)
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_028.txt");
end;

function f_show_message_Arantir_ready_go_to_Flammschrein_029() -- Запускается функцией function f_save(hero)
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_029.txt");
end;

function f_show_message_Valeria_does_not_wish_go_to_Flammschrein_030() -- Запускается функцией function f_save(hero)
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_030.txt");
end;



function f_show_mummy_join_us_032() -- Запускатеся триггером Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Mummy_speaks", "f_show_mummy_join_us_032");
	if (IsObjectExists(CREATURE_FINAL_GIFT) == nil) then
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Mummy_speaks", nil);
		print("Mummy_nil");
	else
		ShowFlyingSign("/Maps/Scenario/A2C1M5/messagebox_032.txt", CREATURE_FINAL_GIFT, PLAYER_1, 9.0);
	end;	
end;

function f_show_message_not_enough_SP_to_destroy_altar_033() -- Запускается функцией function f_ready_destroy_altar(hero)
	MessageBox("/Maps/Scenario/A2C1M5/messagebox_033.txt");
end;	

---------------------------------------------------
--*-- GAMEPLAY FUNCTIONS --*--
---------------------------------------------------

if GetDifficulty() == DIFFICULTY_EASY then
	print ("easy");	
	
function SetObjectCreatures( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;
 
function SetObjectCreatures_2( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;

function SetObjectCreatures_3( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;

sleep(1);	
	SetObjectCreatures( CREATURE_FINAL_GIFT, CREATURE_DEATH_KNIGHT, 60 );
	SetObjectCreatures_2( CREATURE_FINAL_GIFT, CREATURE_MUMMY, 120 );
	SetObjectCreatures_3( CREATURE_FINAL_GIFT, CREATURE_ZOMBIE, 430 );	
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_BONE_DRAGON, 7);
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_WIGHT, 14);
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_LICH, 20);
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_DEATH_KNIGHT, 12);
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_MUMMY, 20);	
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_ARCHER, 30);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_FOOTMAN, 18);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_ARCHER, 30);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_FOOTMAN, 18);
	Trigger(PLAYER_ADD_HERO_TRIGGER, PLAYER_1, "f_add_creatures_to_prisoner_easy");	
end;
if GetDifficulty() == DIFFICULTY_NORMAL then
	print ("normal");
	
function SetObjectCreatures( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;
 
function SetObjectCreatures_2( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;

function SetObjectCreatures_3( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;

sleep(1);
	SetObjectCreatures( CREATURE_FINAL_GIFT, CREATURE_DEATH_KNIGHT, 40 );
	SetObjectCreatures_2( CREATURE_FINAL_GIFT, CREATURE_MUMMY, 120 );
	SetObjectCreatures_3( CREATURE_FINAL_GIFT, CREATURE_ZOMBIE, 430 );	
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_LICH, 15);
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_DEATH_KNIGHT, 8);
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_MUMMY, 15);	
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_ARCHER, 30);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_FOOTMAN, 18);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_GRIFFIN, 10);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_ARCHER, 30);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_FOOTMAN, 18);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_GRIFFIN, 10);
	Trigger(PLAYER_ADD_HERO_TRIGGER, PLAYER_1, "f_add_creatures_to_prisoner_normal");
end;
if GetDifficulty() == DIFFICULTY_HARD then
	print ("hard");
	
function SetObjectCreatures( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;
 
function SetObjectCreatures_2( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;

function SetObjectCreatures_3( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;

	sleep(1);
	SetObjectCreatures( CREATURE_FINAL_GIFT, CREATURE_DEATH_KNIGHT, 25 );
	SetObjectCreatures_2( CREATURE_FINAL_GIFT, CREATURE_MUMMY, 90 );
	SetObjectCreatures_3( CREATURE_FINAL_GIFT, CREATURE_ZOMBIE, 360 );	
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_DEATH_KNIGHT, 6);
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_MUMMY, 8);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_ARCHER, 30);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_FOOTMAN, 18);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_GRIFFIN, 10);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_PRIEST, 6);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_ARCHER, 30);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_FOOTMAN, 18);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_GRIFFIN, 10);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_PRIEST, 6);
	Trigger(PLAYER_ADD_HERO_TRIGGER, PLAYER_1, "f_add_creatures_to_prisoner_hard");
end;
if GetDifficulty() == DIFFICULTY_HEROIC then
	print ("heroic");
	
	function SetObjectCreatures( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;
 
function SetObjectCreatures_2( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;

function SetObjectCreatures_3( objName, creatureID, newCount )
   local count = GetObjectCreatures( objName, creatureID );
   if count == newCount then
     return
   end;
   if count > newCount then
     RemoveObjectCreatures( objName, creatureID, count - newCount );
   else
     AddObjectCreatures( objName, creatureID, newCount - count );
   end;
end;

	sleep(1);
	SetObjectCreatures( CREATURE_FINAL_GIFT, CREATURE_DEATH_KNIGHT, 15 );
	SetObjectCreatures_2( CREATURE_FINAL_GIFT, CREATURE_MUMMY, 70 );
	SetObjectCreatures_3( CREATURE_FINAL_GIFT, CREATURE_ZOMBIE, 300 );
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_LICH, 2);
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_DEATH_KNIGHT, 1);
	AddObjectCreatures(OBJECT_HERO_TOWN, CREATURE_MUMMY, 2);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_ARCHER, 15);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_FOOTMAN, 9);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_GRIFFIN, 5);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_PRIEST, 3);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_SUD_WEST, CREATURE_CAVALIER, 2);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_ARCHER, 15);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_FOOTMAN, 9);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_GRIFFIN, 5);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_PRIEST, 3);
	AddObjectCreatures(OBJECT_ENEMY_TOWN_OST, CREATURE_CAVALIER, 2);
	AddObjectCreatures("Garrison_sud_west", CREATURE_LONGBOWMAN, 75); ----------add
	AddObjectCreatures("Garrison_sud_west", CREATURE_VINDICATOR, 55); ----------add
	AddObjectCreatures("Garrison_sud_west", CREATURE_CHAMPION , 5); ----------add
	AddObjectCreatures("Garrison_ost", CREATURE_BATTLE_GRIFFIN , 30); ----------add
	AddObjectCreatures("Garrison_ost", CREATURE_VINDICATOR , 80); ----------add
	AddObjectCreatures("Garrison_ost", CREATURE_LONGBOWMAN , 60); ----------add
end;

function f_add_creatures_to_prisoner_easy()
	if (IsObjectExists(HERO_PRISONER) == not nil) then
		AddHeroCreatures(HERO_PRISONER, CREATURE_SERAPH, 12);
		AddHeroCreatures(HERO_PRISONER, CREATURE_CHAMPION, 24);
		AddHeroCreatures(HERO_PRISONER, CREATURE_ZEALOT, 40);
		AddHeroCreatures(HERO_PRISONER, CREATURE_VINDICATOR, 112);
		Trigger(PLAYER_ADD_HERO_TRIGGER, PLAYER_1, nil);
	end;
end;

function f_add_creatures_to_prisoner_normal()
	if (IsObjectExists(HERO_PRISONER) == not nil) then
		AddHeroCreatures(HERO_PRISONER, CREATURE_SERAPH, 8);
		AddHeroCreatures(HERO_PRISONER, CREATURE_CHAMPION, 18);
		AddHeroCreatures(HERO_PRISONER, CREATURE_ZEALOT, 32);
		AddHeroCreatures(HERO_PRISONER, CREATURE_VINDICATOR, 96);
		Trigger(PLAYER_ADD_HERO_TRIGGER, PLAYER_1, nil);
	end;
end;

function f_add_creatures_to_prisoner_hard()
	if (IsObjectExists(HERO_PRISONER) == not nil) then
		AddHeroCreatures(HERO_PRISONER, CREATURE_SERAPH, 4);
		AddHeroCreatures(HERO_PRISONER, CREATURE_CHAMPION, 8);
		AddHeroCreatures(HERO_PRISONER, CREATURE_ZEALOT, 12);
		AddHeroCreatures(HERO_PRISONER, CREATURE_VINDICATOR, 36);
		Trigger(PLAYER_ADD_HERO_TRIGGER, PLAYER_1, nil);
	end;
end;

function f_start_west_block()
	SetRegionBlocked("Start_west_block", 1, PLAYER_2); -- Стартовая временная блокировка у западного города
end;

function f_start_ost_block()
	SetRegionBlocked("Start_ost_block", 1, PLAYER_2); -- Стартовая временная блокировка у восточного города
end;

function f_start_west_block_disabled()
	SetRegionBlocked("Start_west_block", nil, PLAYER_2); -- Упраздняет блокировку зоны у западного города
end;

function f_start_ost_block_disabled()
	SetRegionBlocked("Start_ost_block", nil, PLAYER_2); -- Упраздняет блокировку зоны у восточного города
end;

function H55_TriggerDaily()
	if (GetDate( DAY ) == 22) then
		f_start_west_block_disabled();
		f_start_ost_block_disabled();
		print("open");
	end;
	if (GetDate( DAY_OF_WEEK ) == 5) then
		car = CARAVAN..GetDate(DAY);
		CreateCaravan(car, PLAYER_1, GROUND, 130, 1, GROUND, 136, 14 );
		sleep(4);
		SetObjectRotation(car, 180);
		AddObjectCreatures(car, CREATURE_BONE_DRAGON, 4);
		AddObjectCreatures(car, CREATURE_WIGHT, 8);
		AddObjectCreatures(car, CREATURE_LICH, 12);
		AddObjectCreatures(car, CREATURE_VAMPIRE, 20);
		AddObjectCreatures(car, CREATURE_MANES, 36);
		AddObjectCreatures(car, CREATURE_WALKING_DEAD, 60);
		AddObjectCreatures(car, CREATURE_SKELETON, 80);
		OpenCircleFog(130, 1, 0, 4, 1);		
		sleep(4);
		MoveCamera(130, 1, 0, 30, 1, 3.14, 0, 0, 1);
		f_random_caravan_message();
	end;
	if (GetDate( DAY_OF_WEEK ) == 1) then
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_ARCH_DEMON, 1);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_PIT_SPAWN, 2);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_HELLMARE, 3);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_SUCCUBUS_SEDUCER, 5);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_FIREBREATHER_HOUND, 9);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_HORNED_LEAPER, 15);
	end;		
end;

function H55_SecTriggerDaily()
	if (GetDate( DAY ) == 15) then
		f_start_west_block_disabled();
		f_start_ost_block_disabled();
		print("open");
	end;
	if (GetDate( DAY_OF_WEEK ) == 5) then
		car = CARAVAN..GetDate(DAY);
		CreateCaravan(car, PLAYER_1, GROUND, 130, 1, GROUND, 136, 14 );
		sleep(4);
		SetObjectRotation(car, 180);
		AddObjectCreatures(car, CREATURE_BONE_DRAGON, 1);
		AddObjectCreatures(car, CREATURE_WIGHT, 2);
		AddObjectCreatures(car, CREATURE_LICH, 3);
		AddObjectCreatures(car, CREATURE_VAMPIRE, 5);
		AddObjectCreatures(car, CREATURE_MANES, 9);
		AddObjectCreatures(car, CREATURE_WALKING_DEAD, 15);
		AddObjectCreatures(car, CREATURE_SKELETON, 20);
		OpenCircleFog(130, 1, 0, 4, 1);		
		sleep(4);
		MoveCamera(130, 1, 0, 30, 1, 3.14, 0, 0, 1);
		f_random_caravan_message();
	end;
	if (GetDate( DAY_OF_WEEK ) == 1) then
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_ARCH_DEMON, 1);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_PIT_SPAWN, 2);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_HELLMARE, 4);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_SUCCUBUS_SEDUCER, 7);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_FIREBREATHER_HOUND, 12);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_HORNED_LEAPER, 20);
	end;		
end;

function H55_ThrTriggerDaily()
	if (GetDate( DAY ) == 8) then
		f_start_west_block_disabled();
		f_start_ost_block_disabled();
		print("open");
	end;
	if (GetDate( DAY_OF_WEEK ) == 5) then
		car = CARAVAN..GetDate(DAY);
		CreateCaravan(car, PLAYER_1, GROUND, 130, 1, GROUND, 136, 14 );
		sleep(4);
		SetObjectRotation(car, 180);
		AddObjectCreatures(car, CREATURE_VAMPIRE, 3);
		AddObjectCreatures(car, CREATURE_MUMMY, 2);
		AddObjectCreatures(car, CREATURE_DEATH_KNIGHT, 1);
		OpenCircleFog(130, 1, 0, 4, 1);		
		sleep(4);
		MoveCamera(130, 1, 0, 30, 1, 3.14, 0, 0, 1);
		f_random_caravan_message();
	end;
	if (GetDate( DAY_OF_WEEK ) == 1) then
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_ARCH_DEMON, 2);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_PIT_SPAWN, 4);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_HELLMARE, 6);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_SUCCUBUS_SEDUCER, 10);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_FIREBREATHER_HOUND, 18);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_HORNED_LEAPER, 45);
	end;		
end;

function H55_FrtTriggerDaily()
	if (GetDate( DAY ) == 2) then
		f_start_west_block_disabled();
		f_start_ost_block_disabled();
		print("open");
	end;
	if (GetDate( DAY_OF_WEEK ) == 5) then
		car = CARAVAN..GetDate(DAY);
		CreateCaravan(car, PLAYER_1, GROUND, 130, 1, GROUND, 136, 14 );
		sleep(4);
		SetObjectRotation(car, 180);
		AddObjectCreatures(car, CREATURE_LICH, 1);
		AddObjectCreatures(car, CREATURE_MUMMY, 1);
		OpenCircleFog(130, 1, 0, 4, 1);		
		sleep(4);
		MoveCamera(130, 1, 0, 30, 1, 3.14, 0, 0, 1);
		f_random_caravan_message();
	end;
	if (GetDate( DAY_OF_WEEK ) == 1) then
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_ARCH_DEMON, 2);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_PIT_SPAWN, 4);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_HELLMARE, 6);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_SUCCUBUS_SEDUCER, 10);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_FIREBREATHER_HOUND, 36);
		AddObjectCreatures(OBJECT_EVIL_TOWN, CREATURE_HORNED_LEAPER, 30);
	end;		
end;

if GetDifficulty() == DIFFICULTY_EASY then
	H55_NewDayTrigger = 1;
	--Trigger(NEW_DAY_TRIGGER, "f_difficulty_easy");
	CreateArtifact("", ARTIFACT_LION_HIDE_CAPE , 138, 7, GROUND);
end;
if GetDifficulty() == DIFFICULTY_NORMAL then
	H55_SecNewDayTrigger = 1;
	--Trigger(NEW_DAY_TRIGGER, "f_difficulty_normal");
end;
if GetDifficulty() == DIFFICULTY_HARD then
	H55_ThrNewDayTrigger = 1;
	--Trigger(NEW_DAY_TRIGGER, "f_difficulty_hard");
end;
if GetDifficulty() == DIFFICULTY_HEROIC then
	H55_FrtNewDayTrigger = 1;
	--Trigger(NEW_DAY_TRIGGER, "f_difficulty_heroic");
end;

function f_random_caravan_message()
	x = random(3);
	print( 'random caravan message #', x );
	if (x == 0) then f_show_message_hilfe_012() end;
	if (x == 1) then f_show_message_hilfe_013() end;
	if (x == 2) then f_show_message_hilfe_014() end;
end;

function f_activate_castle_OBJECT_ENEMY_TOWN_NORD() -- Запускается триггерами Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_OST, "f_activate_castle_OBJECT_ENEMY_TOWN_NORD") или Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_SUD_WEST, "f_activate_castle_OBJECT_ENEMY_TOWN_NORD")
	SetRegionBlocked("4_block_zone_for_player2", nil, PLAYER_2);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_OST, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_SUD_WEST, nil);
	SetRegionBlocked("Temp_block_player2", nil, PLAYER_2);
	SetRegionBlocked("Temp_block_player2_2", nil, PLAYER_2);
	print("nord_free");
end;

function f_activate_castle_OBJECT_ENEMY_TOWN_CENTER() -- Запускается триггерами Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_NORD, "f_activate_castle_OBJECT_ENEMY_TOWN_CENTER") или Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_CENTER_NORD, "f_activate_castle_OBJECT_ENEMY_TOWN_CENTER")
	SetRegionBlocked("3_block_zone_for_player2", nil, PLAYER_2);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_NORD, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_CENTER_NORD, nil);
	print("center_free");
end;

function town_counter()
	count = 0;
	sleep(2);
	if GetObjectOwner(OBJECT_ENEMY_TOWN_NORD) == PLAYER_1 then
		count = count + 1
	end;
	if GetObjectOwner(OBJECT_ENEMY_TOWN_CENTER) == PLAYER_1 then
		count = count + 1
	end;
	if GetObjectOwner(OBJECT_ENEMY_TOWN_SUD_WEST) == PLAYER_1 then
		count = count + 1
	end;
	if GetObjectOwner(OBJECT_ENEMY_TOWN_OST) == PLAYER_1 then
		count = count + 1
	end;
	if count == 4 and count_4 == 0 then
		DeployReserveHero(HERO_AI_3_ENEMY_HERO_4, 18, 140, GROUND);
		sleep(2);
		UnreserveHero(HERO_AI_3_ENEMY_HERO_4);
		count_4 = 1
	end;
	if count == 3 and count_3 == 0 then
		DeployReserveHero(HERO_AI_3_ENEMY_HERO_3, 18, 140, GROUND);
		sleep(2);
		UnreserveHero(HERO_AI_3_ENEMY_HERO_3);
		count_3 = 1
	end;
	if count == 2 and count_2 == 0 then
		DeployReserveHero(HERO_AI_3_ENEMY_HERO_2, 18, 140, GROUND);
		sleep(2);
		UnreserveHero(HERO_AI_3_ENEMY_HERO_2);
		count_2 = 1
	end;
	if count == 1 and count_1 == 0 then
		DeployReserveHero(HERO_AI_3_ENEMY_HERO_1, 18, 140, GROUND);
		sleep(2);
		UnreserveHero(HERO_AI_3_ENEMY_HERO_1);
		count_1 = 1
	end;
end;

function town_counter_altar_broken()
	count = 0
	sleep(2);
	if GetObjectOwner(OBJECT_ENEMY_TOWN_NORD) == PLAYER_1 then
		count = count + 1
	end;
	if GetObjectOwner(OBJECT_ENEMY_TOWN_CENTER) == PLAYER_1 then
		count = count + 1
	end;
	if GetObjectOwner(OBJECT_ENEMY_TOWN_SUD_WEST) == PLAYER_1 then
		count = count + 1
	end;
	if GetObjectOwner(OBJECT_ENEMY_TOWN_OST) == PLAYER_1 then
		count = count + 1
	end;
	if count == 4 and count_4 == 0 then
		count_4 = 1
	end;
	if count == 3 and count_3 == 0 then
		count_3 = 1
	end;
	if count == 2 and count_2 == 0 then
		count_2 = 1
	end;
	if count == 1 and count_1 == 0 then
		count_1 = 1
	end;
end;
	
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_NORD, "town_counter");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_CENTER, "town_counter");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_SUD_WEST, "town_counter");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_OST, "town_counter");

--*---------------------------------------------------------------------------------------------*--
--*--------------------------- ANIMATIONS AND EFFECTS -------------------------*--
--*---------------------------------------------------------------------------------------------*--

---------------------------------------------------------------------------------------------------
--------------------------------------- MAIN --------------------------------------------------
---------------------------------------------------------------------------------------------------

function GameVarBonus()
	print("GameVarBonus: start");
	if GetGameVar("BONUS_A2C1M4") =="1" then
		PLAYER_GOLD = GetPlayerResource(PLAYER_1, GOLD);
		sleep(2);
		PLAYER_GOLD_BONUS = PLAYER_GOLD + GOLD_BONUS;
		sleep(2);
		SetPlayerResource(PLAYER_1, GOLD, PLAYER_GOLD_BONUS)
		print ("gold");
		print( "BONUS_checked_1" );
	end;
end;



startThread( GameVarBonus );

sleep(4);
SetPlayerStartResources(PLAYER_2, 240, 240, 80, 140, 80, 80, 100000);
SetPlayerStartResources(PLAYER_3, 80, 80, 30, 45, 30, 30, 40000);
OpenCircleFog(165, 39, 0, 3, 1);
UnreserveHero(HERO_FREE);
UnreserveHero(HERO_FREE_2);
UnreserveHero(HERO_AI_2_ENEMY_HERO_1); -- Заменить на скриптовое рождение если Ai будет тупить.
UnreserveHero(HERO_AI_2_ENEMY_HERO_2); -- Заменить на скриптовое рождение если Ai будет тупить.
UnreserveHero(HERO_AI_2_ENEMY_HERO_3); -- Заменить на скриптовое рождение если Ai будет тупить.

EnableHeroAI(HERO_SOULKEEPER, nil);
SetRegionBlocked("1_block_zone_for_player2", 1, PLAYER_2);
SetRegionBlocked("2_block_zone_for_player2", 1, PLAYER_2);
SetRegionBlocked("1_block_zone_for_player3", 1, PLAYER_3);
SetRegionBlocked("2_block_zone_for_player3", 1, PLAYER_3);
SetRegionBlocked("3_block_zone_for_player3", 1, PLAYER_3);
SetRegionBlocked("3_block_zone_for_player2", 1, PLAYER_2);
SetRegionBlocked("4_block_zone_for_player2", 1, PLAYER_2);
SetRegionBlocked("1_block_zone_for_AI_players", 1, PLAYER_2);
SetRegionBlocked("1_block_zone_for_AI_players", 1, PLAYER_3);
SetRegionBlocked("2_block_zone_for_AI_players", 1, PLAYER_2);
SetRegionBlocked("2_block_zone_for_AI_players", 1, PLAYER_3);
SetRegionBlocked("3_block_zone_for_AI_players", 1, PLAYER_2);
SetRegionBlocked("3_block_zone_for_AI_players", 1, PLAYER_3);
SetRegionBlocked("4_block_zone_for_AI_players", 1, PLAYER_2);
SetRegionBlocked("4_block_zone_for_AI_players", 1, PLAYER_3);
SetRegionBlocked("5_block_zone_for_AI_players", 1, PLAYER_2);
SetRegionBlocked("5_block_zone_for_AI_players", 1, PLAYER_3);
SetRegionBlocked("6_block_zone_for_AI_players", 1, PLAYER_2);
SetRegionBlocked("6_block_zone_for_AI_players", 1, PLAYER_3);
SetRegionBlocked("Alarm_succubus", 1, PLAYER_2);
SetRegionBlocked("Alarm_succubus", 1, PLAYER_3);
SetRegionBlocked("Stop_for_player", 1, PLAYER_2);
SetRegionBlocked("Stop_for_player", 1, PLAYER_3);
SetRegionBlocked("Temp_block_player2", 1, PLAYER_2);
SetRegionBlocked("Temp_block_player2_2", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_1", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_1", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_2", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_2", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_3", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_3", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_4", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_4", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_5", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_5", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_6", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_6", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_7", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_7", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_8", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_8", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_9", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_9", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_10", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_10", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_11", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_11", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_12", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_12", 1, PLAYER_3);
SetRegionBlocked("Block_teleport_13", 1, PLAYER_2);
SetRegionBlocked("Block_teleport_13", 1, PLAYER_3);
f_start_west_block();
f_start_ost_block();
AllowPlayerTavernHero( PLAYER_1, HERO_FREE, 1 );
AllowPlayerTavernHero( PLAYER_1, HERO_FREE_2, 1 );
AllowPlayerTavernHero( PLAYER_2, HERO_AI_2_ENEMY_HERO_1, 1 );
AllowPlayerTavernHero( PLAYER_2, HERO_AI_2_ENEMY_HERO_2, 1 );
AllowPlayerTavernHero( PLAYER_2, HERO_AI_2_ENEMY_HERO_3, 1 );
AllowPlayerTavernHero( PLAYER_3, HERO_AI_3_ENEMY_HERO_1, 1 );
AllowPlayerTavernHero( PLAYER_3, HERO_AI_3_ENEMY_HERO_2, 1 );
AllowPlayerTavernHero( PLAYER_3, HERO_AI_3_ENEMY_HERO_3, 1 );
AllowPlayerTavernHero( PLAYER_3, HERO_AI_3_ENEMY_HERO_4, 1 );
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_1, 1); -- Возвращение героя в таверну
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_2, 1); -- Возвращение героя в таверну
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_3, 1); -- Возвращение героя в таверну
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_4, 1); -- Возвращение героя в таверну
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_5, 1); -- Возвращение героя в таверну
MakeHeroReturnToTavernAfterDeath(HERO_FREE, 1); -- Возвращение героя в таверну
MakeHeroReturnToTavernAfterDeath(HERO_FREE_2, 1); -- Возвращение героя в таверну
MakeHeroReturnToTavernAfterDeath(HERO_FREE_3, 1); -- Возвращение героя в таверну
DenyAIHeroFlee(HERO_PLAYER, not nil);
DenyAIHeroFlee(HERO_PLAYER_2, not nil);
Trigger(PLAYER_REMOVE_HERO_TRIGGER, 1, "f_check_player_main_hero_death");
--Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_ORACLE, "f_show_message_box_Oracle_011");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_EVIL_TOWN, "f_check_Flammschrein_captured");
-- Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_DEALER, "f_check_ghost_talk");
Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_QUEST_TARGET, "f_show_message_box_Assasin_talk_004");
Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_FALLEN_PALADIN, "f_meet_paladin");
-- Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_SOULKEEPER, "f_show_message_soulkeeper_speak_go_away_023");
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Soulkeeper_speaks_go_away", "f_show_message_soulkeeper_speak_go_away_023");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TOMB, "f_show_message_box_touch_Tomb_010");
--Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "f_show_message_box_Gate_to_Flammschrein_002");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GATE_TO_FLAMMSCHREIN, "f_check_barrier_touch_new");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_GOLD, "f_show_message_box_touch_closed_portal_007");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_HERO, "f_show_message_box_touch_closed_portal_007");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_TELEPORT_TO_TREES, "f_show_message_box_touch_closed_portal_007");

Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Stop_for_player", "f_pri6");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_OST, "f_activate_castle_OBJECT_ENEMY_TOWN_NORD");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_SUD_WEST, "f_activate_castle_OBJECT_ENEMY_TOWN_NORD");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_NORD, "f_activate_castle_OBJECT_ENEMY_TOWN_CENTER");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_CENTER_NORD, "f_activate_castle_OBJECT_ENEMY_TOWN_CENTER");
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Alarm_succubus", "f_succubus");

Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_SIGN_01, "f_open_fog_115_81");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_SIGN_02, "f_open_fog_123_124");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_SIGN_03, "f_open_fog_137_128");
Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Mummy_speaks", "f_show_mummy_join_us_032");


SetDisabledObjectMode( CREATURE_FALLEN_PALADIN , DISABLED_INTERACT );
SetDisabledObjectMode( CREATURE_QUEST_TARGET , DISABLED_ATTACK );
SetDisabledObjectMode( CREATURE_INFERNO_1 , DISABLED_ATTACK );
SetDisabledObjectMode( CREATURE_FINAL_GIFT , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_TELEPORT_TO_GOLD , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_TELEPORT_TO_HERO , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_TELEPORT_TO_TREES , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_IN_15 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_IN_16 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_IN_17 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_IN_18 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_IN_19 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_IN_20 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_IN_21 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_OUT_15 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_OUT_16 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_OUT_17 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_OUT_18 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_OUT_19 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_OUT_20 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_OUT_21 , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_GATE_TO_FLAMMSCHREIN , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_TOMB , DISABLED_INTERACT );
SetDisabledObjectMode( OBJECT_INFERNO_ALTAR , DISABLED_INTERACT );
--------------------------------------
function Main_hero_de()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Arantir") == nil then 
			sleep(2);
			Loose();
			break;
		end;
	end;
end;

function Complete_valeria()
	while 1 do	
		sleep( 6 );
		if IsObjectExists( "RedHeavenHero03" ) == not nil then
			if GetObjectOwner("RedHeavenHero03") == PLAYER_1 then
				sleep(2);
				StartAdvMapDialog (7);   --------------------------------7_advmap_dialog
				break;
			end;
		end;
	end;
end;


--------------------------------------MAIN///////
H55_CamFixTooManySkills(PLAYER_1,"Arantir");
H55_CamFixTooManySkills(PLAYER_1,"OrnellaNecro");
startThread(Main_hero_de);
startThread(Complete_valeria);
print("MAIN: end script isEqual reached");
-------------------------------------

--*-- END OF FILE --*--