doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

StartDialogScene("/DialogScenes/A2C3/M1/S1/DialogScene.xdb#xpointer(/DialogScene)"); -- START DIALOGSCENE

function f_artifacts_sets()
	InitAllSetArtifacts( "A2C3M1" );
end;

startThread( f_artifacts_sets );

doFile("/scripts/A2_Zehir/A2_Zehir.lua");

SetRegionBlocked( "YlayaSpot", not nil, PLAYER_1 );
SetObjectEnabled( "Razzak", nil );

function summon_creatures( heroName )
	if heroName == "Zehir" then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Nraxes", nil );
		BlockGame();
		print( "Game blocked" );
		if GetDifficulty() == DIFFICULTY_EASY then
			diff = 2;
			H55_NewDayTrigger = 1;
			--Trigger(NEW_DAY_TRIGGER, "f_difficulty_easy");
		elseif GetDifficulty() == DIFFICULTY_NORMAL then
			diff = 2;
			H55_SecNewDayTrigger = 1;
			--Trigger(NEW_DAY_TRIGGER, "f_difficulty_normal");
		elseif GetDifficulty() == DIFFICULTY_HARD then
			diff = 3;
			H55_ThrNewDayTrigger = 1;
			--Trigger(NEW_DAY_TRIGGER, "f_difficulty_hard");
		elseif GetDifficulty() == DIFFICULTY_HEROIC then
			diff = 4;
			H55_FrtNewDayTrigger = 1;
			--Trigger(NEW_DAY_TRIGGER, "f_difficulty_heroic");
		end;
		EnableHeroAI( "Razzak", nil );
		SetObjectRotation( "Razzak", 180 );
		SetObjectPosition(  "Razzak", 12, 19, GROUND );
		sleep( 2 );
		StartAdvMapDialog( 2, "AdvMapDialog4" );
	end;
end;

function AdvMapDialog4()
	UnblockGame();
	print( "Game unblocked" );
	SetObjectPosition( "Razzak", 132, 129, GROUND );
	DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes ( PLAYER_8, 1 );
	ZehirAbilitiesInit("Zehir");
	if diff == 1 then
		ZehirCreaturesAdd( CREATURE_OBSIDIAN_GOLEM, 60, SULFUR, 5, 1500);
		print( "diff == 1" );
	elseif diff == 2 then
		ZehirCreaturesAdd( CREATURE_OBSIDIAN_GOLEM, 50, SULFUR, 5, 1500);
		print( "diff == 2" );
	elseif diff == 3 then
		ZehirCreaturesAdd( CREATURE_OBSIDIAN_GOLEM, 40, SULFUR, 5, 1500);
		print( "diff == 3" );
	elseif diff == 4 then
		ZehirCreaturesAdd( CREATURE_OBSIDIAN_GOLEM, 30, SULFUR, 5, 1500);
		print( "diff == 4" );
	end;
end;	
	
--startThread( summon_creatures );

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Nraxes", "summon_creatures" );

function difficulty_setup()
	if diff == 1 then
		print ("easy");
		SetPlayerStartResources(PLAYER_2, 80, 80, 40, 40, 60, 40, 30000);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_3, STAT_EXPERIENCE, 1300);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_4, STAT_EXPERIENCE, 2000);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_5, STAT_EXPERIENCE, 2400);	
		AddHeroCreatures(HERO_PLAYER, CREATURE_MAGI, 10);
		AddHeroCreatures(HERO_PLAYER, CREATURE_GENIE, 10);
		AddHeroCreatures(HERO_PLAYER, CREATURE_RAKSHASA, 5);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, ZONE_BLOCK_AI2_8, "f_ZONE_BLOCK_AI2_8_deactivate_easy");
	elseif diff == 2 then
		print ("normal");
		SetPlayerStartResources(PLAYER_2, 120, 120, 60, 60, 90, 60, 60000);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_3, STAT_EXPERIENCE, 2600);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_4, STAT_EXPERIENCE, 4000);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_5, STAT_EXPERIENCE, 5400);
		AddHeroCreatures(HERO_PLAYER, CREATURE_IRON_GOLEM, 21);
		AddHeroCreatures(HERO_PLAYER, CREATURE_MAGI, 9);
		AddHeroCreatures(HERO_PLAYER, CREATURE_GENIE, 5);	
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, DEACTIVATOR_FOR_ZONE_BLOCK_AI2_8, "f_ZONE_BLOCK_AI2_8_deactivate_normal");
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, ZONE_BLOCK_AI2_3, "f_ZONE_BLOCK_AI2_8_deactivate_normal");
		Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_2, "f_ZONE_BLOCK_AI2_8_deactivate_normal");	
	elseif diff == 3 then
		print ("hard");
		SetPlayerStartResources(PLAYER_2, 160, 160, 80, 80, 120, 80, 100000);
		AddObjectCreatures(OBJECT_ENEMY_TOWN_1, CREATURE_MINOTAUR , 18);	
		AddObjectCreatures(OBJECT_ENEMY_TOWN_2, CREATURE_MINOTAUR, 18);
		AddObjectCreatures(OBJECT_ENEMY_TOWN_2, CREATURE_RIDER, 10);	
		AddObjectCreatures(OBJECT_ENEMY_TOWN_3, CREATURE_MINOTAUR, 18);
		AddObjectCreatures(OBJECT_ENEMY_TOWN_3, CREATURE_RIDER, 10);
		AddObjectCreatures(OBJECT_ENEMY_TOWN_3, CREATURE_HYDRA, 6);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_3, STAT_EXPERIENCE, 12400);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_4, STAT_EXPERIENCE, 24320);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_5, STAT_EXPERIENCE, 17600);
		AddHeroCreatures(HERO_PLAYER, CREATURE_GREMLIN, 38);
		AddHeroCreatures(HERO_PLAYER, CREATURE_STONE_GARGOYLE, 19);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, ZONE_BLOCK_AI2_5, "f_ZONE_BLOCK_AI2_8_deactivate_hard");
	elseif diff == 4 then
		print ("heroic");
		SetPlayerStartResources(PLAYER_2, 300, 300, 140, 140, 200, 140, 500000);
		AddObjectCreatures(OBJECT_ENEMY_TOWN_1, CREATURE_MINOTAUR , 36);	
		AddObjectCreatures(OBJECT_ENEMY_TOWN_2, CREATURE_HYDRA, 12);
		AddObjectCreatures(OBJECT_ENEMY_TOWN_2, CREATURE_MATRON, 4);	
		AddObjectCreatures(OBJECT_ENEMY_TOWN_3, CREATURE_HYDRA, 12);
		AddObjectCreatures(OBJECT_ENEMY_TOWN_3, CREATURE_MATRON, 4);
		AddObjectCreatures(OBJECT_ENEMY_TOWN_3, CREATURE_DEEP_DRAGON, 2);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_3, STAT_EXPERIENCE, 40570);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_4, STAT_EXPERIENCE, 28785);
		ChangeHeroStat(HERO_AI_2_ENEMY_HERO_5, STAT_EXPERIENCE, 24320);	
		AddHeroCreatures(HERO_PLAYER, CREATURE_MASTER_GENIE, 2);
	end;
end;
	
---------------------------------------------------------------------------------------------------
--------------------------------- CONSTANTS ----------------------------------------------
---------------------------------------------------------------------------------------------------

diff = 0;

HERO_PLAYER = 'Zehir';
ACADEMY_HERO_1 = 'Astral';
ACADEMY_HERO_2 = 'Faiz';
ACADEMY_HERO_3 = 'Havez';
ACADEMY_HERO_4 = 'Isher';
ACADEMY_HERO_5 = 'Nur';
ACADEMY_HERO_6 = 'Razzak';
ACADEMY_HERO_7 = 'Sufi';

HERO_YLAYA = 'Shadwyn';

HERO_AI_2_ENEMY_HERO_1 = 'Almegir';
HERO_AI_2_ENEMY_HERO_2 = 'Dalom';
HERO_AI_2_ENEMY_HERO_3 = 'Eruina';
HERO_AI_2_ENEMY_HERO_4 = 'Ferigl';
HERO_AI_2_ENEMY_HERO_5 = 'Inagost';
HERO_AI_2_ENEMY_HERO_6 = 'Menel';
HERO_AI_2_ENEMY_HERO_7 = 'Ohtarig';
HERO_AI_2_ENEMY_HERO_8 = 'Urunir';

DWARF_HERO = 'Ottar';


--*-- CREATURES SCRIPT NAMES --*--
CREATURE_MENTOR_DJINN = 'Djinn';
ASSASSIN = 'Assasin';

--*-- OBJECTS SCRIPT NAMES --*--
OBJECT_HOME_TOWN = 'Mutazz';
OBJECT_GARRISON_1 = 'Garrison1';
OBJECT_GARRISON_2 = 'Garrison2';
OBJECT_ENEMY_TOWN_1 = 'Sorfail';
OBJECT_ENEMY_TOWN_2 = 'Colris';
OBJECT_ENEMY_TOWN_3 = 'Thilgathal';
OBJECT_NEAR_YLAYA = 'Near_Ylaya';
OBJECT_NEAR_ACADEMY_HERO_6 = 'Meet_with_ACADEMY_HERO_6';

--*-- ZONES SCRIPT NAMES --*--
ZONE_MEET_WITH_YLAYA = 'ZONE_MEET_WITH_YLAYA';
ZONE_DWARF = 'Dwarf';
ZONE_BLOCK_AI2_1 = 'ZONE_BLOCK_AI2_1';
ZONE_BLOCK_AI2_2 = 'ZONE_BLOCK_AI2_2';
ZONE_BLOCK_AI2_3 = 'ZONE_BLOCK_AI2_3';
ZONE_BLOCK_AI2_4 = 'ZONE_BLOCK_AI2_4';
ZONE_BLOCK_AI2_5 = 'ZONE_BLOCK_AI2_5';
ZONE_BLOCK_AI2_6 = 'ZONE_BLOCK_AI2_6';
ZONE_BLOCK_AI2_7 = 'ZONE_BLOCK_AI2_7';
ZONE_BLOCK_AI2_8 = 'ZONE_BLOCK_AI2_8';
DEACTIVATOR_FOR_ZONE_BLOCK_AI2_8 = 'Deactivator_for_ZONE_BLOCK_AI2_8';
ZONE_BLOCK_ONE_WAY_TELEPORT = 'Zone_Block_One_Way_Teleport';
ZONE_BLOCK_UPPER_TEMP = 'Block_upper_temp';

---------------------------------------------------------------------------------------------------
-------------------------------- VARIABLES -------------------------------------------------
---------------------------------------------------------------------------------------------------

TraitorWait = 0;
TraitorsCount = 0;
HeroBringArtifact = 0;

SetObjectEnabled( CREATURE_MENTOR_DJINN, nil );
SetObjectEnabled( ASSASSIN, nil );
SetObjectEnabled( OBJECT_GARRISON_1, nil );

SetRegionBlocked( "ZONE_TO_ZEHIR_TELEPORT", not nil );

--pri1

function f_pri1_success() 
	if GetObjectiveState( "pri2" ) == OBJECTIVE_COMPLETED and GetObjectiveState( "pri3" ) == OBJECTIVE_FAILED then
		SetObjectiveState( "pri1", OBJECTIVE_COMPLETED );
		StartDialogScene( "/DialogScenes/A2C3/M1/S2/DialogScene.xdb#xpointer(/DialogScene)", "f_win" );
	end;
end;

function f_pri1_fail() 
	if IsHeroAlive( HERO_PLAYER ) == nil and GetObjectOwner( OBJECT_HOME_TOWN ) ~= PLAYER_1 then
		print( "player looser his hero and town");
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, 1, nil );
		startThread( f_loose );
    end;
end;

--pri2

function f_meet_with_Ylaya( heroName )
	if heroName == HERO_PLAYER then
		BlockGame();
		DeployReserveHero( HERO_YLAYA, 4, 40, 1 );
		sleep( 1 );
		SetObjectEnabled( HERO_YLAYA, nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, ZONE_MEET_WITH_YLAYA, nil );
		SetObjectiveState( "pri3", OBJECTIVE_FAILED );	
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", OBJECT_NEAR_YLAYA, 0, -1, 1, 0, 0 );
		sleep(3);
		SetObjectPosition( HERO_YLAYA, 25, 22, 1 );
		StartAdvMapDialog( 4, "f_meet_with_Ylaya_finish" );
	end;
end;	
	
function f_meet_with_Ylaya_finish()
	sleep(5);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", OBJECT_NEAR_YLAYA, 0, -1, 1, 0, 0 );
	sleep(3);
	RemoveObject( HERO_YLAYA );
	SetRegionBlocked( "YlayaSpot", nil, PLAYER_1 );
	UnblockGame();
	SetObjectiveState( 'pri2', OBJECTIVE_ACTIVE, PLAYER_1 );
	sleep(4);
	Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, "pri2", "f_pri1_success" );
end;

function f_check_capture_enemy_castles()
	local p_count = 0;
	
	if IsHeroAlive( HERO_PLAYER ) == nil and GetObjectOwner( OBJECT_HOME_TOWN ) ~= PLAYER_1 then
		startThread( f_loose );
	end;
	if GetObjectOwner(OBJECT_ENEMY_TOWN_1) == PLAYER_1 then p_count = p_count + 1 end;
	if GetObjectOwner(OBJECT_ENEMY_TOWN_2) == PLAYER_1 then p_count = p_count + 1 end;	
	if GetObjectOwner(OBJECT_ENEMY_TOWN_3) == PLAYER_1 then p_count = p_count + 1 end;
	if IsHeroAlive(HERO_AI_2_ENEMY_HERO_1) == nil then p_count = p_count + 1 end;
	if IsHeroAlive(HERO_AI_2_ENEMY_HERO_2) == nil then p_count = p_count + 1 end;
	if IsHeroAlive(HERO_AI_2_ENEMY_HERO_3) == nil then p_count = p_count + 1 end;
	if IsHeroAlive(HERO_AI_2_ENEMY_HERO_4) == nil then p_count = p_count + 1 end;
	if IsHeroAlive(HERO_AI_2_ENEMY_HERO_5) == nil then p_count = p_count + 1 end;
	if IsHeroAlive(HERO_AI_2_ENEMY_HERO_6) == nil then p_count = p_count + 1 end;
	if IsHeroAlive(HERO_AI_2_ENEMY_HERO_7) == nil then p_count = p_count + 1 end;
	if IsHeroAlive(HERO_AI_2_ENEMY_HERO_8) == nil then p_count = p_count + 1 end;
	if GetObjectiveState( "pri2" ) == OBJECTIVE_ACTIVE and p_count == 11 then	
		SetObjectiveState("pri2", OBJECTIVE_COMPLETED);
		SubObjective2Fail();
	end;
end;

-----------------------------------------------------------------------
--*-- SECONDARY QUESTS START FUNCTIONS --*--
-----------------------------------------------------------------------

assassins_live_count = 0;
assassin_died_count = 0;
assassin_report_stop = 0;
combat_result_last = -1;
assassins_touches = 0;

function combat_results( c )
	print("CombatResultsFunc");
	local we = -1
	if GetSavedCombatArmyPlayer(c,1) == PLAYER_1 then we = 1 end;
	if GetSavedCombatArmyPlayer(c,0) == PLAYER_1 then we = 0 end;
	if we ~= -1 then
		print("CombatResultsFunc: we=",we);
		if GetSavedCombatArmyHero(c,we) == HERO_PLAYER then
			print("CombatResultsFunc: hero found");
			local stackscount = GetSavedCombatArmyCreaturesCount(c,we);
			for i = 0,stackscount-1,1 do
				creature,creaturescount,died = GetSavedCombatArmyCreatureInfo(c,we,i);
				if creature == CREATURE_ASSASSIN and died > 0 then
					print("CombatResultsFunc: assassins died = ",died);
					assassin_died_count = assassin_died_count + died;
					assassins_live_count = assassins_live_count - died;
					assassin_rided();
				end;
			end;
		end;
	end;
	combat_result_last = c;
end;

function assassin_rided()
	if assassin_died_count >= 100 then
		SetObjectiveState( "sec1", OBJECTIVE_COMPLETED );
		Trigger( COMBAT_RESULTS_TRIGGER, nil );
		assassin_report_stop = 1;
		startThread( voice_over_2 );
	end;
end;		

function voice_over_2()
	Play2DSound( "/Maps/Scenario/A2C3M1/C3M1_VO2_Zehir_01sound.xdb#xpointer(/Sound)" );
end;	
	
function assassin_report()
	while 1 do
		
		if IsObjectExists( ASSASSIN ) == nil and assassins_live_count > 0 and GetHeroCreatures( HERO_PLAYER, CREATURE_ASSASSIN ) < assassins_live_count then
			while combat_result_last < GetLastSavedCombatIndex() do
				print( "Waiting for combat result ", GetLastSavedCombatIndex(), " - current is ", combat_result_last );
				sleep( 1 );
			end;
			local count = GetHeroCreatures( HERO_PLAYER, CREATURE_ASSASSIN );
			if count < assassins_live_count then
				print("CombatResultsFunc: Zehir still has ", GetHeroCreatures( HERO_PLAYER, CREATURE_ASSASSIN ), " assassins" );
				Trigger( COMBAT_RESULTS_TRIGGER, nil );
				RemoveHeroCreatures( HERO_PLAYER, CREATURE_ASSASSIN, assassins_live_count );
				print("CombatResultsFunc: Zehir still has ", GetHeroCreatures( HERO_PLAYER, CREATURE_ASSASSIN ), " assassins", "Died ", assassin_died_count );
				SetObjectiveState( "sec1", OBJECTIVE_FAILED );
				StartCombat( HERO_PLAYER, nil, 1, CREATURE_ASSASSIN, assassins_live_count, nil, "assassin_combat_results" );
				startThread( objects_check_for_assassins );
				break;
			else
				assassins_live_count = count;
			end;
		end;
		if assassin_report_stop == 1 then
			break;
		end;
		if TraitorWait == 1 then
			Trigger( COMBAT_RESULTS_TRIGGER, nil );
			break;
		end;
	sleep( 1 );
	end;
end;

function assassin_join()
	local assassins_count = GetObjectCreatures( ASSASSIN, CREATURE_ASSASSIN );
	AddHeroCreatures( HERO_PLAYER, CREATURE_ASSASSIN, assassins_count );
	
	local touches = assassins_touches;
	while GetHeroCreatures( HERO_PLAYER, CREATURE_ASSASSIN ) <= 0 do
		if assassins_touches > touches then return end;
		sleep(1);
	end;
	if assassins_touches > touches then return end;
	
	Trigger( OBJECT_TOUCH_TRIGGER, ASSASSIN, nil );
	SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE, PLAYER_1 );
	
	RemoveObject( ASSASSIN );
	assassins_live_count = assassins_count;
	Trigger( COMBAT_RESULTS_TRIGGER, "combat_results" );
	startThread( assassin_report );

end;

function assassin_combat_results( hero, isWinner )
	if isWinner == not nil then
		f_show_after_combat_with_killers_011();
	else
		f_show_after_combat_with_killers_012();
	end;
end;

function objects_check_for_assassins()
	local heroes = GetPlayerHeroes( PLAYER_1 );
	local amount = 0;
	local hamount = 0;	
	for i,hero in heroes do
		if GetHeroCreatures( hero, CREATURE_STALKER ) > 0 then
			amount = GetHeroCreatures( hero, CREATURE_STALKER );
			sleep( 1 );
			RemoveHeroCreatures( hero, CREATURE_STALKER, amount );
		end;
	end;
	if GetObjectCreatures( OBJECT_HOME_TOWN, CREATURE_STALKER ) > 0 then
		hamount = GetObjectCreatures( OBJECT_HOME_TOWN, CREATURE_STALKER );
		sleep( 1 );
		RemoveObjectCreatures( OBJECT_HOME_TOWN, CREATURE_STALKER, hamount );
	end;
end;
------------------------------------- sub objective1 -----------------------------------

AssassinDialogPlayed = 0;

function f_sec1( heroName )
	if heroName == HERO_PLAYER then
		assassins_touches = assassins_touches + 1;
		QuestionBox( "/Maps/Scenario/A2C3M1/messagebox_002.txt", "f_report_yes", "f_report_no" );
	else
		startThread( f_show_message_box_go_away_003 );
	end;
end;

function f_report_yes()
	if 	AssassinDialogPlayed == 0 then
		AssassinDialogPlayed = 1;
		StartAdvMapDialog( 5, "assassin_join" );
	elseif AssassinDialogPlayed > 0 then
		assassin_join();
	end;
end;

function f_report_no( heroName )
	heroName = HERO_PLAYER;
	Trigger( OBJECT_TOUCH_TRIGGER, ASSASSIN, nil );
	SetObjectEnabled( ASSASSIN, not nil );
	SetDisabledObjectMode( ASSASSIN , DISABLED_DEFAULT );
	sleep( 1 );
	MakeHeroInteractWithObject( HERO_PLAYER, ASSASSIN );
end;

function f_player_1_attack_OBJECT_GARRISON_1( hero )
	local assassins = GetHeroCreatures( HERO_PLAYER, CREATURE_ASSASSIN )
	if assassins > 0 then
		if hero ~= HERO_PLAYER then
			startThread( f_show_message_box_garrison_go_away_005 );
			return
		else
			if TraitorWait == 0 then
				TraitorWait = 1;
				BlockGame();
				startThread( voice_over_3 );
				sleep(2);
				TraitorsCount = GetHeroCreatures( HERO_PLAYER, CREATURE_ASSASSIN );
				RemoveHeroCreatures( HERO_PLAYER, CREATURE_ASSASSIN, TraitorsCount );
				AddObjectCreatures( OBJECT_GARRISON_1, CREATURE_ASSASSIN, TraitorsCount );
				sleep(2);
				SetObjectEnabled( OBJECT_GARRISON_1, not nil );
				Trigger( OBJECT_TOUCH_TRIGGER, OBJECT_GARRISON_1, nil );
				SetRegionBlocked( ZONE_BLOCK_AI2_5, nil, PLAYER_2 );		
				sleep(2);
				UnblockGame();
				sleep(1);
				f_show_message_box_garrison_attack_006();
				if GetObjectiveState( "sec1" ) == OBJECTIVE_ACTIVE then
					SetObjectiveState( "sec1", OBJECTIVE_FAILED );
				end;
				MakeHeroInteractWithObject( HERO_PLAYER, OBJECT_GARRISON_1 );				
				return
			end;
			print( "ERROR!" );
			return
		end;
	end;
	SetObjectEnabled( OBJECT_GARRISON_1, not nil );
	Trigger( OBJECT_TOUCH_TRIGGER, OBJECT_GARRISON_1, nil );
	SetRegionBlocked( ZONE_BLOCK_AI2_5, nil, PLAYER_2 );		
	sleep(1);
	MakeHeroInteractWithObject( hero, OBJECT_GARRISON_1 );
end;

function voice_over_3()
	Play2DSound( "/Maps/Scenario/A2C3M1/C3M1_VO3_Zehir_01sound.xdb#xpointer(/Sound)" );
end;
	
------------------------------------- sub objective2 -----------------------------------

EnableHeroAI( DWARF_HERO, nil );
SetObjectEnabled( DWARF_HERO, nil );

x_to_return, y_to_return, floor_to_return = GetObjectPosition ( HERO_PLAYER );
f_sec2_start_hero = ""
first_check = 0;

function f_sec2_start( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then	
		if heroName~=HERO_PLAYER then
			x_to_return, y_to_return, floor_to_return = GetObjectPosition ( HERO_PLAYER );
			local x, y = RegionToPoint( 'ZONE_TO_ZEHIR_TELEPORT' );
			SetRegionBlocked( 'ZONE_TO_ZEHIR_TELEPORT', nil );
			SetObjectRotation( HERO_PLAYER, 200 );
			SetObjectPosition( HERO_PLAYER, x, y, UNDERGROUND );
			BlockGame();
			sleep(2)
			UnblockGame();
		end;
		f_sec2_start_hero = heroName;
		StartAdvMapDialog( 6, "f_sec2_start_1" );
	end;
end;

	
function f_sec2_start_1()
	if table.length(GetObjectsInRegion( 'ZONE_TO_ZEHIR_TELEPORT', OBJECT_HERO ))>0 then
		SetObjectPosition( HERO_PLAYER, x_to_return, y_to_return, floor_to_return );
	end;
	if GetObjectiveState( "sec2" ) == OBJECTIVE_UNKNOWN and HasArtefact( f_sec2_start_hero, ARTIFACT_RUNE_OF_FLAME) == nil then
		OpenCircleFog(84, 115, 1, 5, 1);		
		sleep(4);
		MoveCamera(84, 115, 1, 30, 1, 0, 0, 0, 1);
		sleep(2);
		SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE, PLAYER_1 );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, ZONE_DWARF, "f_check_artifact" );
		f_check_artifact( f_sec2_start_hero );
		startThread( f_starter_for_random_message_007_and_008 );
	elseif GetObjectiveState( "sec2" ) == OBJECTIVE_UNKNOWN and HasArtefact( f_sec2_start_hero, ARTIFACT_RUNE_OF_FLAME) == not nil then
		SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE, PLAYER_1 );
		f_check_artifact( f_sec2_start_hero );
	end;
end;

messageShown = 0;

function f_check_artifact( heroName )
	if first_check == 0 then
		heroName = f_sec2_start_hero
	elseif first_check > 0 then
		f_sec2_start_hero = heroName
	end;
	sleep( 1 );
	if GetObjectOwner( heroName ) == PLAYER_1 then	
		if HasArtefact( heroName, ARTIFACT_RUNE_OF_FLAME) then
			HeroBringArtifact = 1;
			RemoveArtefact( heroName, ARTIFACT_RUNE_OF_FLAME );			
			--OpenCircleFog(80, 26, 1, 5, 1);		
			--sleep( 3 );
			--MoveCamera(80, 26, 1, 30, 1, 1.57, 0, 0, 1);		
			--sleep( 3 );
			f_show_thanks_010();
			GiveArtefact( heroName, 40 );
			sleep( 3 );
			PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", DWARF_HERO, 0, 0, 0, 0, 0 );
			sleep( 2 );
			RemoveObject( DWARF_HERO );			
			SetObjectiveState( "sec2", OBJECTIVE_COMPLETED );
			SetGameVar( "BONUS_A2C3M1", "1" );
		elseif HasArtefact( heroName, ARTIFACT_RUNE_OF_FLAME) == nil and GetObjectiveState( "sec2" ) == OBJECTIVE_ACTIVE and messageShown == 0 then
			messageShown = 1;
			startThread( f_show_message_box_Dwarf_speak_hello_001 );
		end;
	end;
end;

function SubObjective2Fail()
	if GetObjectiveState( "pri2" ) == OBJECTIVE_COMPLETED and GetObjectiveState( "sec2" ) == OBJECTIVE_ACTIVE then
		HeroBringArtifact = 2;
		OpenCircleFog(80, 26, 1, 5, 1);		
		sleep(3);
		MoveCamera(80, 26, 1, 30, 1, 1.57, 0, 0, 1);		
		sleep(3);
		startThread( f_show_message_dwarf_009 );
		sleep(20);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", DWARF_HERO, 0, 0, 0, 0, 0 );
		sleep(2);
		RemoveObject( DWARF_HERO );
		sleep(10);
		SetObjectiveState("sec2", OBJECTIVE_FAILED, PLAYER_1);
	end;
end;	
	
function f_starter_for_random_message_007_and_008()
	sleep( 120 );
	while 1 do
		if HeroBringArtifact ~= 0 or 
		GetObjectiveState( "sec2" ) == OBJECTIVE_FAILED or 
		GetObjectiveState( "sec2" ) == OBJECTIVE_COMPLETED then
			break;		
		else
			startThread( f_dwarf_random_message_007_or_008 );		
		end;
		sleep(120);
	end;			
end;

function f_dwarf_random_message_007_or_008()
	x = random(2);
	print( 'random message #', x );
	if (x == 0) then f_show_message_dwarf_007(); end;
	if (x == 1) then f_show_message_dwarf_008(); end;
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, ZONE_DWARF, "f_sec2_start" );

-----------------------------------------------------
--*-- MISC ACTIONS FUNCTIONS --*--
-----------------------------------------------------

function f_win()
	if GetObjectiveState( "pri2" ) == OBJECTIVE_COMPLETED and GetObjectiveState( "pri1" ) == OBJECTIVE_COMPLETED then	
		print( "roflmao nop" )
		SaveHeroAllSetArtifactsEquipped( HERO_PLAYER, "A2C3M1" );
		sleep(5);
		Win();
	end;
end;

function f_loose()
	SetObjectiveState( "pri1", OBJECTIVE_FAILED, PLAYER_1 );
	Loose();
end;

function f_djinn()
	-->>
	Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_MENTOR_DJINN, nil);
	StartAdvMapDialog( 0, "f_djinn_1" );
end;

function f_djinn_1()
	MakeTownMovable( "Mutazz" );
	OpenCircleFog( 13, 11, GROUND, 10, PLAYER_1 );
	sleep( 1 );
	Play2DSound( "/Maps/Scenario/A2C3M1/SummonEarthsound.xdb#xpointer(/Sound)" );
	sleep( 2 );
	PlayVisualEffect( "/Effects/_(Effect)/Spells/DivineVengeance/FX_DivineVengeance.(Effect).xdb#xpointer(/Effect)", "FX_object", 0, 0, 0, 0, 0 );
	sleep( 4 );
	PlayVisualEffect( "/Effects/_(Effect)/Spells/DivineVengeance/FX_DivineVengeance.(Effect).xdb#xpointer(/Effect)", "FX_object1", 0, 0, 0, 0, 0 );
	sleep( 3 );
	PlayVisualEffect( "/Effects/_(Effect)/Spells/DivineVengeance/FX_DivineVengeance.(Effect).xdb#xpointer(/Effect)", "FX_object2", 0, 0, 0, 0, 0 );
	sleep( 3 );
	SetObjectPosition( "Mutazz",13, 11, GROUND );
	SetObjectOwner( "Mutazz", PLAYER_1 );
	print ("before")
	TakeAwayHeroExpFlying ( "Zehir", 200000 );
	print ("past");
	sleep(5);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", CREATURE_MENTOR_DJINN, 0, 0, 0, 0, 0 );
	sleep(3);
	RemoveObject( CREATURE_MENTOR_DJINN );
end;

---------------------------------------------------
--*-- MESSAGEBOX FUNCTIONS --*--
---------------------------------------------------

function f_show_message_box_Dwarf_speak_hello_001()
	MessageBox("/Maps/Scenario/A2C3M1/messagebox_001.txt");
end;

function f_show_message_box_go_away_003()
	MessageBox("/Maps/Scenario/A2C3M1/messagebox_003.txt");
end;

function f_show_message_box_assasin_destroy_004( hero, isWinner )
	if isWinner == not nil then
		RemoveObject( ASSASSIN );
		sleep(2);
		MessageBox("/Maps/Scenario/A2C3M1/messagebox_004.txt");
	end;
end;

function f_show_message_box_garrison_go_away_005()
	MessageBox("/Maps/Scenario/A2C3M1/messagebox_005.txt");
end;

function f_show_message_box_garrison_attack_006()
	MessageBox("/Maps/Scenario/A2C3M1/messagebox_006.txt");
end;

function f_show_message_dwarf_007()
	ShowFlyingSign("/Maps/Scenario/A2C3M1/messagebox_007.txt", DWARF_HERO, PLAYER_1, 7.0);
end;

function f_show_message_dwarf_008()
	ShowFlyingSign("/Maps/Scenario/A2C3M1/messagebox_008.txt", DWARF_HERO, PLAYER_1, 7.0);
end;

function f_show_message_dwarf_009()
	ShowFlyingSign("/Maps/Scenario/A2C3M1/messagebox_009.txt", DWARF_HERO, PLAYER_1, 9.0);
end;

function f_show_thanks_010()
	MessageBox("/Maps/Scenario/A2C3M1/messagebox_010.txt");
end;

function f_show_after_combat_with_killers_011()
	MessageBox("/Maps/Scenario/A2C3M1/messagebox_011.txt");
end;

function f_show_after_combat_with_killers_012()
	MessageBox("/Maps/Scenario/A2C3M1/messagebox_012.txt");
end;

---------------------------------------------------
--*-- GAMEPLAY FUNCTIONS --*--
---------------------------------------------------

function f_ZONE_BLOCK_AI2_3_deactivate() 
	SetRegionBlocked(ZONE_BLOCK_AI2_3, nil, PLAYER_2);
	SetRegionBlocked(ZONE_BLOCK_UPPER_TEMP, nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_3_deactivate");
end;

function f_ZONE_BLOCK_AI2_4_deactivate()
	SetRegionBlocked(ZONE_BLOCK_AI2_4, nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_4_deactivate");
end;

function f_ZONE_BLOCK_AI2_6_deactivate()
	SetRegionBlocked(ZONE_BLOCK_AI2_6, nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_6_deactivate");
end;

function f_ZONE_BLOCK_AI2_8_deactivate_easy()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, ZONE_BLOCK_AI2_8, nil);
	SetRegionBlocked(ZONE_BLOCK_AI2_8, nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_8_deactivate");
end;

function f_ZONE_BLOCK_AI2_8_deactivate_normal()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, DEACTIVATOR_FOR_ZONE_BLOCK_AI2_8, nil);
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, ZONE_BLOCK_AI2_3, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_2, nil);
	SetRegionBlocked(ZONE_BLOCK_AI2_8, nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_8_deactivate");
end;

function f_ZONE_BLOCK_AI2_8_deactivate_hard()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, ZONE_BLOCK_AI2_5, nil);
	SetRegionBlocked(ZONE_BLOCK_AI2_8, nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_8_deactivate");
end;

function f_ZONE_BLOCK_AI2_8_deactivate_heroic()
	SetRegionBlocked(ZONE_BLOCK_AI2_8, nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_8_deactivate");
end;

function H55_TriggerDaily()
	if (GetDate( DAY ) == 36) then
		SetRegionBlocked(ZONE_BLOCK_AI2_3, nil, PLAYER_2);
		SetRegionBlocked(ZONE_BLOCK_ONE_WAY_TELEPORT, nil, PLAYER_2);
		print("Teleport_open_for_Ai");
	end;
	if (GetDate( DAY ) == 56) then
		startThread( f_ZONE_BLOCK_AI2_4_deactivate );
	end;		
end;

function H55_SecTriggerDaily()
	if (GetDate( DAY ) == 29) then
		SetRegionBlocked(ZONE_BLOCK_AI2_3, nil, PLAYER_2);
		SetRegionBlocked(ZONE_BLOCK_ONE_WAY_TELEPORT, nil, PLAYER_2);
		print("Teleport_open_for_Ai");
	end;
	if (GetDate( DAY ) == 42) then
		startThread( f_ZONE_BLOCK_AI2_6_deactivate );
	end;
	if (GetDate( DAY ) == 49) then
		startThread( f_ZONE_BLOCK_AI2_4_deactivate );
	end;		
end;

function H55_ThrTriggerDaily()
	if (GetDate( DAY ) == 22) then
		SetRegionBlocked(ZONE_BLOCK_AI2_3, nil, PLAYER_2);
		SetRegionBlocked(ZONE_BLOCK_ONE_WAY_TELEPORT, nil, PLAYER_2);
		print("Teleport_open_for_Ai");
	end;
	if (GetDate( DAY ) == 35) then
		startThread( f_ZONE_BLOCK_AI2_6_deactivate );
	end;
	if (GetDate( DAY ) == 49) then
		startThread( f_ZONE_BLOCK_AI2_4_deactivate );
	end;		
end;

function H55_FrtTriggerDaily()
	if (GetDate( DAY ) == 15) then
		startThread( f_ZONE_BLOCK_AI2_8_deactivate_heroic );
	end;
	if (GetDate( DAY ) == 8) then
		SetRegionBlocked(ZONE_BLOCK_AI2_3, nil, PLAYER_2);
		SetRegionBlocked(ZONE_BLOCK_ONE_WAY_TELEPORT, nil, PLAYER_2);
		print("Teleport_open_for_Ai");
	end;	
	if (GetDate( DAY ) == 28) then
		startThread( f_ZONE_BLOCK_AI2_6_deactivate );
	end;
	if (GetDate( DAY ) == 42) then
		startThread( f_ZONE_BLOCK_AI2_4_deactivate );
	end;		
end;

--ChangeHeroStat("Zehir",STAT_SPELL_POWER,2);

SetRegionBlocked(ZONE_BLOCK_AI2_1, 1, PLAYER_2);
SetRegionBlocked(ZONE_BLOCK_AI2_2, 1, PLAYER_2);
SetRegionBlocked(ZONE_BLOCK_AI2_3, 1, PLAYER_2);
SetRegionBlocked(ZONE_BLOCK_AI2_4, 1, PLAYER_2);
SetRegionBlocked(ZONE_BLOCK_AI2_5, 1, PLAYER_2);
SetRegionBlocked(ZONE_BLOCK_AI2_6, 1, PLAYER_2);
SetRegionBlocked(ZONE_BLOCK_AI2_7, 1, PLAYER_2);
SetRegionBlocked(ZONE_BLOCK_AI2_8, 1, PLAYER_2);
SetRegionBlocked(ZONE_BLOCK_UPPER_TEMP, 1, PLAYER_2);
SetRegionBlocked(ZONE_BLOCK_ONE_WAY_TELEPORT, 1, PLAYER_2);
EnableHeroAI(DWARF_HERO, nil);
DenyAIHeroFlee(HERO_PLAYER, not nil);
AllowPlayerTavernHero( PLAYER_1, HERO_PLAYER, 1 );
MakeHeroReturnToTavernAfterDeath(HERO_PLAYER, 1, 1 );
MakeHeroReturnToTavernAfterDeath(ACADEMY_HERO_1, 1);
MakeHeroReturnToTavernAfterDeath(ACADEMY_HERO_2, 1);
MakeHeroReturnToTavernAfterDeath(ACADEMY_HERO_3, 1);
MakeHeroReturnToTavernAfterDeath(ACADEMY_HERO_4, 1);
MakeHeroReturnToTavernAfterDeath(ACADEMY_HERO_5, 1);
--MakeHeroReturnToTavernAfterDeath(ACADEMY_HERO_6, 1);
MakeHeroReturnToTavernAfterDeath(ACADEMY_HERO_7, 1);
SetDisabledObjectMode( CREATURE_MENTOR_DJINN , DISABLED_INTERACT );
SetDisabledObjectMode( ASSASSIN , DISABLED_INTERACT );
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_1, 1);
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_2, 1);
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_3, 1);
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_4, 1);
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_5, 1);
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_6, 1);
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_7, 1);
MakeHeroReturnToTavernAfterDeath(HERO_AI_2_ENEMY_HERO_8, 1);
--SetHeroesExpCoef( 0.5 ); -- Изменение количества получаемого опыта.
startThread( difficulty_setup );
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "f_pri1_fail" );
Trigger(REGION_ENTER_AND_STOP_TRIGGER, ZONE_MEET_WITH_YLAYA, "f_meet_with_Ylaya");
Trigger(OBJECT_TOUCH_TRIGGER, CREATURE_MENTOR_DJINN, "f_djinn");
Trigger(OBJECT_TOUCH_TRIGGER, ASSASSIN, "f_sec1");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_GARRISON_1, "f_ZONE_BLOCK_AI2_3_deactivate");
Trigger(OBJECT_TOUCH_TRIGGER, OBJECT_GARRISON_1, "f_player_1_attack_OBJECT_GARRISON_1");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_1, "f_check_capture_enemy_castles");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_2, "f_check_capture_enemy_castles");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_ENEMY_TOWN_3, "f_check_capture_enemy_castles");
Trigger(OBJECT_CAPTURE_TRIGGER, OBJECT_HOME_TOWN, "f_check_capture_enemy_castles");
Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "f_check_capture_enemy_castles");