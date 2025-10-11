doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M2");
	LoadHeroAllSetArtifacts( "Isabell" , "C1M1" );
end;

startThread(H55_InitSetArtifacts);

H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_BOOTS_OF_LEVITATION};

__threads = {};
function startThreadOnce( func, p1, p2, p3 )
	if __threads[ func ] then
		return
	end;
	newfunc = function()
		%func( %p1, %p2, %p3);
		__threads[ %func ] = nil;
	end;
	__threads[ func ] = newfunc;
	startThread( newfunc );
end;

obj01 = 0;
obj02 = 0;
obj03 = 0;
mess01 = 0;
captureday=0;
poductionday=0;
calendarday=0;
eventday=0;
once = 0;
--Examples:
--TutorialActivateHint( szID )
--TutorialSetBlink( szID, nOn )
--TutorialMessageBox( szID )
--IsTutorialMessageBoxOpen()

m01= "c1_m2_t1" ;--"/Maps/Scenario/C1M2/tutorial_text/01.txt"
m02="c1_m2_t2" ;--"/Maps/Scenario/C1M2/tutorial_text/02.txt"
m03= "c1_m2_t3" ;--"/Maps/Scenario/C1M2/tutorial_text/03.txt"
m04= "c1_m2_t4" ;--"/Maps/Scenario/C1M2/tutorial_text/04.txt"
m05= "c1_m2_t5" ;--"/Maps/Scenario/C1M2/tutorial_text/05.txt"
m06= "c1_m2_t6_1" ;--"/Maps/Scenario/C1M2/tutorial_text/06.txt"
m63= "c1_m2_t6_2" ;--"/Maps/Scenario/C1M2/tutorial_text/61.txt"
m61= "c1_m2_t6_3" ;--"/Maps/Scenario/C1M2/tutorial_text/62.txt"
m62= "c1_m2_t6_4" ;--"/Maps/Scenario/C1M2/tutorial_text/62.txt"
m07= "c1_m2_t7" ;--"/Maps/Scenario/C1M2/tutorial_text/07.txt"
m08= "c1_m2_t8" ;--"/Maps/Scenario/C1M2/tutorial_text/08.txt"
m09= "c1_m2_t9" ;--"/Maps/Scenario/C1M2/tutorial_text/09.txt"
m10= "c1_m2_t10" ;--"/Maps/Scenario/C1M2/tutorial_text/10.txt"
m11= "c1_m2_t11" ;--"/Maps/Scenario/C1M2/tutorial_text/11.txt"
m12= "c1_m2_t12" ;--"/Maps/Scenario/C1M2/tutorial_text/12.txt"
m13= "c1_m2_t13" ;--"/Maps/Scenario/C1M2/tutorial_text/13.txt"
s1="/DialogScenes/C1/M2/R1/DialogScene.xdb#xpointer(/DialogScene)";
s2="/DialogScenes/C1/M2/R2/DialogScene.xdb#xpointer(/DialogScene)";
s3="/DialogScenes/C1/M2/R3/DialogScene.xdb#xpointer(/DialogScene)";

SetGameVar("temp.C1M2_CountVisitToTown", 0); -- t6_1 t6_2 t6_3
SetGameVar("temp.C1M2_archers_hint", 0);
SetGameVar("temp.C1M2_perk_hint", 0);
--SetGameVar("temp.C1M2_Tradeville", 0 ); -- t13
previous_town = {};
built = 0;

IsTutorial = 1;--IsTutorialEnabled();
dont_check_town = 0;

for i = TOWN_BUILDING_TOWN_HALL, TOWN_BUILDING_SPECIAL_5 do
	if ( i ~= 15 ) and ( i ~= 16 ) and ( i ~= 19 ) then
		previous_town[i] = GetTownBuildingLevel( 'Hant', i );
	end;
end;

function luck() --tutorial 03
	TutorialMessageBox(m03);
	print('message m03')
	Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r03', nil);
end

function morale() --tutorial 04
	TutorialMessageBox(m04);
	print('message m04')
	Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r04', nil)
end

function attack_town() --tutorial 05
	TutorialMessageBox(m05);
	print('message m05')
	Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r05', nil)
end

--function hero_death() --tutorial 07 +start timer for tutorials 08 and 09
--	TutorialMessageBox(m06);
--	print('message m06')
--	Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r05', nil)
--end

function Day8and15( thisday )
	if (thisday == 8) and (IsTutorial == 1) then
		sleep( 30 );
		WaitForTutorialMessageBox();
		TutorialMessageBox(m08);
	end;
	if (thisday == 15) and (IsTutorial == 1) then
		sleep( 30 );
		WaitForTutorialMessageBox();
		TutorialMessageBox(m09);
	end;
end;

function SaveHint( thisday )
	if (thisday == 12) and (IsTutorial == 1) then
		sleep( 2 );
		WaitForTutorialMessageBox();
		TutorialMessageBox( "c1_m2_savegame");
	end;
end;

function H55_SecTriggerDaily() --tutorials 08 & 09
	thisday = GetDate(ABSOLUTE_DAY);
	print(poductionday)
	print(calendarday)
	--if poductionday == thisday then
	--		TutorialMessageBox(m08);
	--		print('message m08')
	--		
	--end
	if eventday == thisday then
		StartDialogScene(s2);
		SetObjectiveState('prim3', OBJECTIVE_ACTIVE)
	end

	startThread( Day8and15, thisday );
	startThread( SaveHint, thisday );
	--if 	calendarday == thisday then
	--		TutorialMessageBox(m09);
	--		print('message m09')
	--end
	--if GetDate( DAY_OF_WEEK ) == 1 and once == 0 then
	--	sleep( 30 );
	--	TutorialMessageBox(m09);
	--	once = 1;
--end;
	if dont_check_town == 0 then
		local skip = 0
		for i = TOWN_BUILDING_TOWN_HALL, TOWN_BUILDING_SPECIAL_5 do
			if ( i ~= 15 ) and ( i ~= 16 ) and ( i ~= 19 ) then
				if previous_town[i] ~= GetTownBuildingLevel( 'Hant', i ) then
					previous_town[i] = GetTownBuildingLevel( 'Hant', i )
					skip = 1
					built = built + 1;
					if built == 2 then
						dont_check_town = 1;
					end;
				end;
			end;
		end;
		if ( skip == 0 ) then
			WaitForTutorialMessageBox();
			TutorialMessageBox( 'c1_m2_build' );
			dont_check_town = 1;
		end;
	end;
end

function defence() --tutorial 10
	TutorialMessageBox(m10);
	print('message m10')
	Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r12',nil)
end

function attack() --tutorial 11
	TutorialMessageBox(m11);
	print('message m11')
	Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r11',nil)
end

function objective1_done()
	--ResetHeroCombatScript('Isabell');
--	Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r05', 'hero_death') --trigger for tutorial 07
	captureday=GetDate(ABSOLUTE_DAY) --global for tutorials 08 & 09
	eventday=captureday+3 --global for prim3
	H55_SecNewDayTrigger = 1;
	--Trigger(NEW_DAY_TRIGGER ,'timers') --trigger for tutorials 08 & 09
	--SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
	startThread(Objective2);
end

function LostHero( heroname )
	if heroname == 'Isabell' then
		SetObjectiveState( 'prim4', OBJECTIVE_FAILED );
		Loose();
	end;
end;

function Objective2()
	while 1 do
		sleep( 2 );
		if ( GetHeroCreatures( 'Isabell', CREATURE_ARCHER ) + GetHeroCreatures( 'Isabell', CREATURE_MARKSMAN ) + GetHeroCreatures( 'Isabell', CREATURE_LONGBOWMAN ) ) >= 100 then
			SetObjectiveState( "prim2", OBJECTIVE_COMPLETED );
			GiveExp( 'Isabell', 3000 );
			break;
		end;
	end;
end;

function end_mission()
	while 1 do
		if GetObjectiveState("prim1")==OBJECTIVE_COMPLETED and GetObjectiveState("prim2")==OBJECTIVE_COMPLETED and GetObjectiveState("prim3")==OBJECTIVE_COMPLETED then
			StartDialogScene(s3);
			sleep(1);
			SetObjectiveState( "prim4", OBJECTIVE_COMPLETED );
			SaveHeroAllSetArtifactsEquipped("Isabell", "C1M2");
			sleep(5);
			Win();
			return
		end
		sleep(1)
	end
end

function H55_TriggerDaily()
	sleep( 5 );
	TutorialMessageBox(m01);
	H55_NewDayTrigger = 0;
end;

function MineCapturedHint()
	TutorialMessageBox( 'c1_m2_mines' );
	for i = 1, 3 do
		Trigger( OBJECT_CAPTURE_TRIGGER, 'mine'..i, nil );
	end;
end;

function CheckHeroPerks()
	while 1 do
		sleep( 2 );
		if HasHeroSkill( 'Isabell', PERK_HOLY_CHARGE ) or HasHeroSkill( 'Isabell', PERK_PRAYER ) then
			SetGameVar("temp.C1M2_perk_hint", 1); -- hint about perks, see Isabell's combat script
			print(GetGameVar("temp.C1M2_perk_hint"));
			break;
		end;
	end;
end;

function DisableHeroCombatScript()
	ResetHeroCombatScript('Isabell');
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER ,'castle', nil);
end;

function EnableTutorial()
	SetGameVar( "temp.tutorial", 1 );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'r03', 'luck');
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'r04', 'morale');
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'r05', 'attack_town');
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'r12', 'defence');
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'r11', 'attack');
	for i = 1, 3 do
		Trigger( OBJECT_CAPTURE_TRIGGER, 'mine'..i, 'MineCapturedHint' );
	end;
end;

function DisableTutorial()
	SetGameVar( "temp.tutorial", 0 );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'r03', nil );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'r04', nil );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'r05', nil );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'r12', nil );
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'r11', nil );
	for i = 1, 3 do
		Trigger( OBJECT_CAPTURE_TRIGGER, 'mine'..i, nil );
	end;
end;

COMBAT = 9999;
THREAD = 9998;

TutorialTriggers = {
	{ "c1_m2_t3", REGION_ENTER_AND_STOP_TRIGGER, "r03", "luck", 0 },
	{ "c1_m2_t4", REGION_ENTER_AND_STOP_TRIGGER, "r04", "morale", 0 },
	{ "c1_m2_t5", REGION_ENTER_AND_STOP_TRIGGER, "r05", "attack_town", 0 },
	{ "c1_m2_t10", REGION_ENTER_AND_STOP_TRIGGER, "r12", "defence", 0 },
	{ "c1_m2_t11", REGION_ENTER_AND_STOP_TRIGGER, "r11", "attack", 0 },
	{ "c1_m2_mines", OBJECT_CAPTURE_TRIGGER, "mine1", "MineCapturedHint", 0 },
	{ "c1_m2_mines", OBJECT_CAPTURE_TRIGGER, "mine2", "MineCapturedHint", 0 },
	{ "c1_m2_mines", OBJECT_CAPTURE_TRIGGER, "mine3", "MineCapturedHint", 0 },
};

function CheckTutorialTriggers()
	while 1 do
		sleep( 5 );
		for i, TutorialItem in TutorialTriggers do
			if IsTutorialItemEnabled( TutorialItem[1]  ) then
				if (TutorialItem[5] == 0) then
					if TutorialItem[2] == COMBAT then
						SetGameVar( "temp." .. TutorialItem[1], 1 );
					elseif TutorialItem[2] == THREAD then
						startThreadOnce( TutorialItem[4] );
					else
						Trigger( TutorialItem[2], TutorialItem[3], TutorialItem[4] );
					end;
					TutorialItem[5] = 1;
				end;
			else
				if (TutorialItem[5] == 1) then
					if TutorialItem[2] == COMBAT then
						SetGameVar( "temp." .. TutorialItem[1], 0 );
					elseif TutorialItem[2] ~= THREAD then
						Trigger( TutorialItem[2], TutorialItem[3], nil );
					end;
					TutorialItem[5] = 0;
				end;
			end;
		end;
	end;
end;

function CheckTutorial()
	while 1 do
		sleep( 5 );
		if IsTutorialEnabled() then
			if (IsTutorial == 0) then
				EnableTutorial();
				IsTutorial = 1;
			end;
		else
			if (IsTutorial == 1) then
				DisableTutorial();
				IsTutorial = 0;
			end;
		end;
	end;
end;

function UpdateTownCreatures()
	if ( __difficulty == DIFFICULTY_HARD ) or ( __difficulty == DIFFICULTY_HEROIC ) then
		AddObjectCreatures( 'Tradeville', CREATURE_ARCHER, ( __difficulty - 1 ) * 30 ); -- -1 is for new difficulty levels (VERSION: P0)
		AddObjectCreatures( 'Tradeville', CREATURE_FOOTMAN, ( __difficulty - 1 ) * 20 );
		AddObjectCreatures( 'Tradeville', CREATURE_MILITIAMAN, ( __difficulty - 1 ) * 60 );
	end;
end;

function ShowTown()
	x, y, f = GetObjectPos( 'Hant' );
	OpenCircleFog( x, y, f, 7, PLAYER_1 );
	sleep( 1 );
	MoveCamera( x, y, f, 40, 0.925, 0.279 );
	Trigger( OBJECT_TOUCH_TRIGGER, "tower", nil );
end;

function ShowTown2()
	x, y, f = GetObjectPos( 'Tradeville' );
	OpenCircleFog( x, y, f, 7, PLAYER_1 );
	sleep( 2 );
	MoveCamera( x, y, f, 40, 0.925, 0.279 );
	Trigger( OBJECT_TOUCH_TRIGGER, "tower2", nil );
end;

---SCRIPT C1M2---

SetPlayerStartResource( PLAYER_1, WOOD, 5 );
SetPlayerStartResource( PLAYER_1, ORE, 0 );
SetPlayerStartResource( PLAYER_1, GEM, 0 );
SetPlayerStartResource( PLAYER_1, CRYSTAL, 0 );
SetPlayerStartResource( PLAYER_1, SULFUR, 0 );
SetPlayerStartResource( PLAYER_1, MERCURY, 0 );
SetPlayerStartResource( PLAYER_1, GOLD, 2000 );
UpdateTownCreatures();

StartDialogScene(s1);
SetObjectiveState('prim1', OBJECTIVE_ACTIVE);
--SetObjectiveState('prim2', OBJECTIVE_ACTIVE);

startThread(end_mission);

Trigger(OBJECT_CAPTURE_TRIGGER ,"Hant", "objective1_done");
Trigger( OBJECT_TOUCH_TRIGGER, "tower", "ShowTown" );
Trigger( OBJECT_TOUCH_TRIGGER, "tower2", "ShowTown2" );
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, 'LostHero' );

--tutorial related--
TutorialActivateHint( "hero_screen" );
startThread(CheckHeroPerks);
Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER ,'castle', 'DisableHeroCombatScript');

startThread( CheckTutorialTriggers );
SetGameVar( "temp.tutorial", 1 );

if IsTutorial == 1 then
	--EnableTutorial();
	H55_NewDayTrigger = 1;
	--Trigger( NEW_DAY_TRIGGER, 'NewDay' );
end;

H55_CamFixTooManySkills(PLAYER_1,"Isabell");

--startThread( CheckTutorial );