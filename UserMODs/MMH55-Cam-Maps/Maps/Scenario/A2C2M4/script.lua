H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_TAROT_DECK,
ARTIFACT_ENDLESS_BAG_OF_GOLD

};
------------------------a2c2m4---------------------------

--print("Start_A2C1M2.................");

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua"); ----!!!

function x2()
InitAllSetArtifacts("A2C2M4", "Kujin");
LoadHeroAllSetArtifacts("Kujin",  "A2C2M2"  );
end


MAIN_HERO = "Kujin"
ENEMY_HERO = "Efion"

EnableHeroAI(ENEMY_HERO, nil);
GiveExp(ENEMY_HERO, 202000 ); ---addexp
H55_NewDayTrigger = 1;
--Trigger (NEW_DAY_TRIGGER, "DisableAI_TURN")

function H55_TriggerDaily() -- Turn AI off on 2nd day to dont bore player
	print ("New day");
	if GetDate( DAY ) == 2 then 
		DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes (PLAYER_2, not nil);
		print ("AI disabled");
	end; 
end;

SetRegionBlocked("Andr_mobs", 1, PLAYER_1); 



-------------------------------------------------------D_Level
function Diff_level()
	slozhnost = GetDifficulty(); 
	if slozhnost == DIFFICULTY_EASY then
		CreateMonster( "M1", CREATURE_GOBLIN, 60, 72, 73, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 0 );
		CreateMonster( "M2", CREATURE_CENTAUR, 40, 108, 43, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 0 );
		CreateMonster( "M3", CREATURE_ORC_WARRIOR, 50, 41, 45, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 180 );
		CreateMonster( "M4", CREATURE_SHAMAN, 40, 46, 83, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 90 );
	elseif slozhnost == DIFFICULTY_NORMAL then
		CreateMonster( "M5", CREATURE_ORC_WARRIOR, 30, 41, 45, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 180 );
	elseif slozhnost == DIFFICULTY_HARD then
		RemoveHeroCreatures(MAIN_HERO, CREATURE_CENTAUR, 8);	
		RemoveHeroCreatures(MAIN_HERO, CREATURE_ORC_WARRIOR, 10);
		AddHeroCreatures(ENEMY_HERO, CREATURE_INFERNAL_SUCCUBUS, 60);
		AddHeroCreatures(ENEMY_HERO, CREATURE_FAMILIAR, 200);
	elseif slozhnost == DIFFICULTY_HEROIC then
		RemoveHeroCreatures(MAIN_HERO, CREATURE_CENTAUR, 10);	
		RemoveHeroCreatures(MAIN_HERO, CREATURE_ORC_WARRIOR, 15);
		AddHeroCreatures(ENEMY_HERO, CREATURE_INFERNAL_SUCCUBUS, 95);
		AddHeroCreatures(ENEMY_HERO, CREATURE_FAMILIAR, 275);
		RemoveObject( "1_1" );
		RemoveObject( "1_2" );
		RemoveObject( "1_3" );
		RemoveObject( "1_4" );
		RemoveObject( "1_5" );
	end;
	print('difficulty = ',slozhnost);
end;

--RemoveObject( "1_1" );
------------------------------------------------------Start_mission
SetPlayerResource(1, 0, 0);
SetPlayerResource(1, 1, 0);
SetPlayerResource(1, 2, 0);
SetPlayerResource(1, 3, 0);
SetPlayerResource(1, 4, 0);
SetPlayerResource(1, 5, 0);
SetPlayerResource(1, 6, 500);

SetObjectEnabled("h1", nil);
SetObjectEnabled("h2", nil);
SetObjectEnabled("h3", nil);

sleep( 5 );
SetObjectiveState('prim1',OBJECTIVE_ACTIVE);
OpenCircleFog( 5, 112, 0, 4, PLAYER_1 );
PlayVisualEffect( "/Effects/_(Effect)/Spells/LuckGood.xdb#xpointer(/Effect)", MAIN_HERO, "Kujin1", 0, 0, 0, 0, 0 );
sleep( 5 );
MoveCamera(6, 112, GROUND, 25, 3.14/3, 0, 1, 1, 1);
sleep( 8 );
MoveCamera(101, 129, GROUND, 25, 3.14/3, 0, 1, 1, 1);
sleep( 5 );
--Play2DSound( "/Sounds/_(Sound)/Heroes/Biara/Happy.xdb#xpointer(/Sound)" ); ----------------VO	
print("CHECK");

--------------------------------------------------Defeat

function Herkill()  
	while 1 do
		sleep(10);
		if IsHeroAlive(MAIN_HERO) == nil then
			SetObjectiveState('prim3',OBJECTIVE_FAILED);
			sleep(2);
			Loose();
			break;
		end;
	end;
end;
-------------------------------------------------Kill_inferno_mob

function Mob() 
	while 1 do
		sleep ( 10 );
		if IsObjectExists("Monster") == nil then
			sleep( 5 );
			SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
			break;
		end;
	end;
end;

-------------------------------------------------Kill_inferno_hero
function Obj2_complete()  
	while 1 do
		sleep(10);
		if IsHeroAlive(ENEMY_HERO) == nil then
			sleep(5);
			SetObjectiveState("prim2", OBJECTIVE_COMPLETED);
			sleep(5);
			Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO3_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO
			break;
		end;
	end;
end;
-------------------------------------------------Final_combat

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Finalcombat","AIAction", nil );

function AIAction()
	BlockGame();
	sleep(15);
	EnableHeroAI(ENEMY_HERO, not nil);
	ChangeHeroStat( ENEMY_HERO, STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( ENEMY_HERO, GetObjectPosition( MAIN_HERO ) );
	sleep(25);
	UnblockGame();	
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Finalcombat",nil);
end;

-------------------------------------------------Winners

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Final","Pobeda", nil );

function Pobeda()
	sleep(5);
	StartDialogScene("/DialogScenes/A2C2/M4/S2/DialogScene.xdb#xpointer(/DialogScene)"); ----///Noaia oeiaeuiay 
	sleep(20);
	SaveHeroAllSetArtifactsEquipped( "Kujin",  "A2C2M4" );
	Win();
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Final",nil);
end;

-------------------------------------------------Andrey
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Andr_zone","Andrey", nil );

function Andrey()
	sleep(5);
	StartDialogScene("/DialogScenes/A2C2/M4/S1/DialogScene.xdb#xpointer(/DialogScene)"); ----///Noaia iia?aaaiey Aia?ay
	sleep(10);
	OpenCircleFog( 82, 10, 0, 4, PLAYER_1 );
	MoveCamera(82, 10, GROUND, 50, 1);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Andr_zone",nil);
end;

-------------------------------------------------Teleport1

Trigger (OBJECT_TOUCH_TRIGGER, "h1", "Spec_1");

function Spec_1( heroname )
	HN = heroname;
	StartAdvMapDialog (0);   --------------------------------0_advmap_dialog
	sleep(3);
	QuestionBox("Maps/Scenario/A2C2M4/mess1.txt", "f_1");	
end;


function f_1() 
	if GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) < 2 then
		startThread(Rand_1);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) == 2 then
		startThread(Rand_2);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) > 2 then
		startThread(Rand_3);	
	end;
end;

function Rand_1()
local x = random(10);
	if x <= 8 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_SUCCUBUS,3,CREATURE_SUCCUBUS,3,CREATURE_SUCCUBUS,3,nil);
	end;
	if x == 9 then
	SetObjectPos(MAIN_HERO, 122, 12, GROUND);
	end;
end;

function Rand_2()
local x = random(10);
	if x <= 4 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_SUCCUBUS,3,CREATURE_SUCCUBUS,3,CREATURE_SUCCUBUS,3,nil);
	end;
	if x >= 5 then
	SetObjectPos(MAIN_HERO, 122, 12, GROUND);
	end;
end;

function Rand_3()
local x = random(10);
	if x <= 7 then
	SetObjectPos(MAIN_HERO, 122, 12, GROUND);
	end;
	if x >= 8 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_SUCCUBUS,3,CREATURE_SUCCUBUS,3,CREATURE_SUCCUBUS,3,nil);
	end;
end;
--------------------------------------------------------Teleport2
Trigger (OBJECT_TOUCH_TRIGGER, "h2", "Spec_2");

function Spec_2( heroname )
	HN = heroname;
	StartAdvMapDialog (1);   --------------------------------1_advmap_dialog
	sleep(3);
	QuestionBox("Maps/Scenario/A2C2M4/mess1.txt", "f_2");	
end;


function f_2() 
	if GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) < 3 then
		startThread(Rand_11);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) == 3 then
		startThread(Rand_22);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) > 3 then
		startThread(Rand_33);	
	end;
end;


function Rand_11()
local x = random(10);
	if x <= 8 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,nil);
	end;
	if x == 9 then
	SetObjectPos(MAIN_HERO, 14, 16, GROUND);
	end;
end;

function Rand_22()
local x = random(10);
	if x <= 4 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,nil);
	end;
	if x >= 5 then
	SetObjectPos(MAIN_HERO, 14, 16, GROUND);
	end;
end;

function Rand_33()
local x = random(10);
	if x <= 7 then
	SetObjectPos(MAIN_HERO, 14, 16, GROUND);
	end;
	if x >= 8 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,nil);
	end;
end;
----------------------------------------------------Teleport3

Trigger (OBJECT_TOUCH_TRIGGER, "h3", "Spec_3");

function Spec_3( heroname )
	HN = heroname;
	StartAdvMapDialog (2);   --------------------------------2_advmap_dialog
	sleep(2);
	QuestionBox("Maps/Scenario/A2C2M4/mess1.txt", "f_3");	
end;


function f_3() 
	if GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) < 4 then
		startThread(Rand_111);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) == 4 then
		startThread(Rand_222);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) > 4 then
		startThread(Rand_333);	
	end;
end;

function Rand_111()
local x = random(10);
	if x <= 8 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_BALOR,1,CREATURE_BALOR,1,CREATURE_BALOR,1,nil);
	end;
	if x == 9 then
	SetObjectPos(MAIN_HERO, 61, 102, GROUND);
	end;
end;

function Rand_222()
local x = random(10);
	if x <= 4 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_BALOR,1,CREATURE_BALOR,1,CREATURE_BALOR,1,nil);
	end;
	if x >= 5 then
	SetObjectPos(MAIN_HERO, 61, 102, GROUND);
	end;
end;

function Rand_333()
local x = random(10);
	if x <= 7 then
	SetObjectPos(MAIN_HERO, 61, 102, GROUND);
	end;
	if x >= 8 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_BALOR,1,CREATURE_BALOR,1,CREATURE_BALOR,1,nil);
	end;
end;


----------------------------------------Sec_Objs1

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "secondary1","SecObj1", nil );

function SecObj1()
	sleep(2);	
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "secondary1",nil);
	sleep(5);
	SetObjectiveState('sec1',OBJECTIVE_ACTIVE);
	Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO4_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO
	startThread(Artef_1);
	print("CHECK1.................");
end;

function Artef_1()
	while HasArtefact("Kujin", 87 ) ~= not nil do sleep(5) end;
	SetObjectiveState("sec1", OBJECTIVE_COMPLETED);
end;
------------------------------------------Sec_1_faled

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "secondary2","SecObj2_faled", nil );

function SecObj2_faled()
	sleep(2);	
	if GetObjectiveState("sec1") == OBJECTIVE_ACTIVE then
		sleep(2)
		SetObjectiveState('sec1',OBJECTIVE_FAILED);
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "secondary2",nil);
		print("Secondary1_faled!!!.................");
	else print("Secondary1_no_active.................");
	end;
end;
----------------------------------------Sec_Objs2_SINK_TEMPLE

function SecObj2()
	sleep(3);	
	SetObjectiveState('sec2',OBJECTIVE_ACTIVE);
	sleep(3);
	Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO11_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Temple_1",nil);
	
	-- startThread(GotBank); --Nival messed this up
	sleep(1);
	SetObjectiveState("sec2", OBJECTIVE_COMPLETED);
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Temple_1","SecObj2", nil );

-- function GotBank( hero, obj )
  -- if hero == MAIN_HERO and obj == "temple" then
	-- SetObjectiveState("sec2", OBJECTIVE_COMPLETED);
  -- end;
-- end;

-------------------------------------------Traps

function Combat1()
	CreateMonster( "ms1", CREATURE_SUCCUBUS, 65, 123, 45, 0, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, 180 );
	sleep(2);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Bloodlust.xdb#xpointer(/Effect)", "ms1", "ms11", 0, 0, 0, 0, 0 );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "trap1",nil);	
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "trap1","Combat1", nil );
-------------------------------------------DIALOGS--------------------------------
function dialog_1(hero)
	print(hero.." enter");
	if hero == MAIN_HERO then
		sleep(5);
		StartAdvMapDialog (3);   --------------------------------3_advmap_dialog
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dialog_one",nil);
	end;
end;


function Dialog_mage()
	while 1 do	
		sleep( 8 );
		if IsPlayerHeroesInRegion ( PLAYER_1, "bridge" ) == not nil then
			sleep( 2 );
			Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO2_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO
--			Play2DSound( "/Maps/Scenario/A2C1M2/C1M2_VO5_Arantir_01sound.xdb#xpointer(/Sound)" ); ----------------VO
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dialog_one",nil);
			break;
		end;
	end;
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dialog_one","dialog_1");
------------------------------------------------------------------VO_SURHAT_QUESTS

--function x_volw()
--	sleep( 6 );
--	Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO7_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO	
--	Trigger(OBJECT_TOUCH_TRIGGER, "SUR2", nil);
--end;

--Trigger(OBJECT_TOUCH_TRIGGER, "SUR2", "x_volw");
-------------------------------------------
--function x_merc()
--	sleep( 6 );
--	Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO9_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO	
--	Trigger(OBJECT_TOUCH_TRIGGER, "SUR3", nil);
--end;

--Trigger(OBJECT_TOUCH_TRIGGER, "SUR3", "x_merc");
----------------------------------------------------------------VO_LOST_TEMPLE
--function VO_11(hero)
--	print(hero.." enter");
--	if hero == MAIN_HERO then
--		sleep(5);
--		Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO11_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO
--		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Temple_1",nil);
--	end;
--end;

--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Temple_1","VO_11");
-----------------------------------------
function VO_12(hero)
	print(hero.." enter");
	if hero == MAIN_HERO then
		sleep(5);
		Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO12_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Temple_1",nil);
	end;
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Temple_2","VO_12");
-----------------------------------------------------------------VO_TAROT_QUEST
--function Tarot_objective1()
--	while 1 do
--		if GetObjectiveState("Assa") == OBJECTIVE_ACTIVE then
--			Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO5_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO
--			sleep(5);
--			startThread(Tarot_objective2);
--			break;
--		end;
--	sleep( 3 );
--	end;	
--end;

--function Tarot_objective2()
--	while 1 do
--		if GetObjectiveState("Assa") == OBJECTIVE_COMPLETED then
--			Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO6_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO
--			break;
--		end;
--	sleep( 3 );
--	end;	
--end;

--function Wolves_1()
--	while 1 do
--		if GetObjectiveState("Q1") == OBJECTIVE_ACTIVE then
--			Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO8_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO
--			sleep(2);
--			break;
--		end;
--	sleep( 3 );
--	end;	
--end;

--function Orks_1()
--	while 1 do
--		if GetObjectiveState("Q2") == OBJECTIVE_ACTIVE then
--			Play2DSound( "/Maps/Scenario/A2C2M4/C2M4_VO10_Kujin_01sound.xdb#xpointer(/Sound)" ); ----------------VO
--			sleep(2);
--			break;
--		end;
--	sleep( 3 );
--	end;	
--end;
-------------------------------------------Main-----------------------------------
--startThread(Orks_1);
--startThread(Wolves_1);
--startThread(Tarot_objective1);

H55_CamFixTooManySkills(PLAYER_1,"Kujin");

startThread(x2);

startThread(Dialog_mage);

startThread(Herkill);
startThread(Mob);
startThread(Obj2_complete);
startThread(Diff_level);