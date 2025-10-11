doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M1");
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

HERO_NAME = "Isabell";
bObj1Done = 0;
bObj1aDone = 0;
AP = 0;
C1M1_C1 = 0;
C1M1_C2 = 0;
C1M1_C3 = 0;
t1 = 0;
t2 = 0;
t3 = 0;
t4 = 0;
t5 = 0;
t6 = 0;
t7 = 0;
t8 = 0;
t9_1 = 0;
t9_2 = 0;
t10 = 0;
t11_1 = 0;
t11_2 = 0;
t11_3 = 0;
t11_4 = 0;
t12 = 0;
start_x, start_y = GetObjectPosition( HERO_NAME );
IsTutorial = 1;--IsTutorialEnabled();

function test1()
	StartDialogScene("/DialogScenes/C1/M1/D2/DialogScene.xdb#xpointer(/DialogScene)");
end;

function test2()
	StartDialogScene("/DialogScenes/C1/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
end;

function messages( dialog )
	if dialog == 1 then
		C1M1_C1 = 1;
		--Save( "scene1" );
		StartDialogScene("/DialogScenes/C1/M1/D1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 2 then
		C1M1_C2 = 1;
		StartDialogScene("/DialogScenes/C1/M1/D2/DialogScene.xdb#xpointer(/DialogScene)");
		--sleep(1);
		StartCombat("Isabell", nil, 1, CREATURE_PEASANT, 13, '/Maps/Scenario/C1M1/C1M1-CombatScript.xdb#xpointer(/Script)', 'AfterCombat');
		sleep(2);
		RemoveObject( "enemy1" );
	end;
	if dialog == 3 then
		C1M1_C3 = 1;
		StartDialogScene("/DialogScenes/C1/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
end;

function AfterCombat()
	SetHeroCombatScript( 'Isabell', '/Maps/Scenario/C1M1/IsabellScript.xdb#xpointer(/Script)' );
end;

function PObjective1()
while 1 do
	sleep(3);
	if bObj1Done == 0 then
		nFootman = GetHeroCreatures(HERO_NAME, CREATURE_FOOTMAN) + GetHeroCreatures(HERO_NAME, CREATURE_SWORDSMAN) + GetHeroCreatures(HERO_NAME, CREATURE_VINDICATOR);
		if nFootman >= 25 then
			SetObjectiveState("prim1", OBJECTIVE_COMPLETED);
			GiveExp( 'Isabell', 500 );
			bObj1Done = 1;
		end;
	end;
	if bObj1aDone == 0 then
		nPeasant = GetHeroCreatures(HERO_NAME, CREATURE_PEASANT) + GetHeroCreatures(HERO_NAME, CREATURE_MILITIAMAN) + GetHeroCreatures(HERO_NAME, CREATURE_LANDLORD);
		if nPeasant >= 100 then
			SetObjectiveState("prim1a", OBJECTIVE_COMPLETED);
			GiveExp( 'Isabell', 500 );
			bObj1aDone = 1;
		end;
	end;
	if ( bObj1Done == 1 ) and ( bObj1aDone == 1 ) then
		SetObjectEnabled( 'zastava', 1 );
		Trigger( OBJECT_TOUCH_TRIGGER, "zastava", nil );
		sleep(1);
		Objective3();
		break;
	end;
end;
end;

function PObjective2()
	if GetObjectiveState("prim2") == OBJECTIVE_UNKNOWN then
		SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
	end;
--while 1 do
--	if IsHeroAlive("Isabell")==nil then
--		if GetObjectiveState("prim2") == OBJECTIVE_ACTIVE or GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
--			SetObjectiveState("prim2",OBJECTIVE_FAILED);
--		else
--			print("Warning!!! prim2 is not ACTIVE or COMPLETED");
--		end;
--		return 1;
--	end;
--	if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
--		if GetObjectiveState("prim2") == OBJECTIVE_ACTIVE  then
--			SetObjectiveState('prim2',OBJECTIVE_COMPLETED);
--		else
--			print("Warning!!! prim2 is not ACTIVE");
--		end;
--		return 1;
--	end;
--sleep();
--end;
end;

function Dialog2( nameHero )
	print("enemy1 is near");
	if C1M1_C2 == 0 and nameHero == "Isabell" then
		C1M1_C2 = 1;
		messages( 2 );
	end;
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "d2", nil );
end;

function Hint_Attack_04()
	print("Hint_Attack_04");
	--if t4 == 0 then 
		Tutorial( 4 );
	--end;
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "attack04", nil );
end;

function Hint_Movement_02_dupe()
	local AP = GetHeroStat( "Isabell", STAT_MOVE_POINTS );
	while GetHeroStat( "Isabell", STAT_MOVE_POINTS ) == AP do
		sleep( 1 );
	end;
	--if t2 == 0 then 
		--print("Hint_Movement_02_dupe!");
		Tutorial( 2 );
	--end;
end;

function Hint_Movement_02()
	--if t2 == 0 then 
		Tutorial( 2 );
	--end;
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop1", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop2", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop3", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop4", nil );
end;

function Hint_CameraControl_03()
	--if t3 == 0 then 
		Tutorial( 3 );
	--end;
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop5", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop6", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop7", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop8", nil );
end;

function Hint_EndOfTurn_06()
	while 1 do
		while GetHeroStat( "Isabell", STAT_MOVE_POINTS ) > 150 do
			sleep( 1 );
		end;
		TutorialMessageBox( "c1_m1_t6_1" );
		WaitForTutorialMessageBox();
		TutorialSetBlink( "end_of_turn_blink", 1 );
		TutorialMessageBox( "c1_m1_t6_2" );
		while GetHeroStat( "Isabell", STAT_MOVE_POINTS ) <= 150 do
			sleep( 1 );
		end;
		TutorialSetBlink( "end_of_turn_blink", 0 );
		sleep( 5 );
		consoleCmd( "setvar Options.Tutorial.Blink.end_of_turn_blink = 0" );
	end;
end;

function Hint_PickUpGold_07()
	--if t7 == 0 then 
		Tutorial( 7 );
	--end;
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t7", nil );
end;

function Hint_SimpleBuilding_08()
	--if t8 == 0 then 
		Tutorial( 8 );
	--end;
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t8", nil );
end;

function Hint_NearBuilding_09_1()
	--if t9_1 == 0 then 
		Tutorial( 91 );
	--end;
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t9_1", nil );
end;

function Hint_HeroInformation_10()
	--if t10 == 0 then 
		Tutorial( 10 );
	--end;
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t10", nil );
end;

function tsleep()
	while IsTutorialMessageBoxOpen() do
		sleep(1);
	end;
end;

function Tutorial( n )
	if n == 1 then
		t1 = 1;
		tsleep();
		TutorialMessageBox( "c1_m1_t1" );
		TutorialSetBlink( "scenario_info_blink", 1 );
		tsleep();
		sleep(5);
		TutorialSetBlink( "scenario_info_blink", 0 );
	end;
	if n == 2 then
		t2 = 1;
		tsleep();
		TutorialMessageBox( "c1_m1_t2" );
		TutorialSetBlink( "move_hero_blink", 1 );
		tsleep();
		sleep(5);
		TutorialSetBlink( "move_hero_blink", 0 );	
	end;
	if n == 3 then 
		t3 = 1;
		TutorialMessageBox( "c1_m1_t3_1" );
		--tsleep();
		--sleep(5);
		--TutorialMessageBox( "c1_m1_t3_2" );
		--tsleep();
		--TutorialMessageBox( "c1_m1_t3_3" );
	end;
	if n == 4 then
		t4 = 1;
		tsleep();
		TutorialMessageBox( "c1_m1_t4" );
	end;
	if n == 5 then
		t5 = 1;
		tsleep();
		TutorialMessageBox( "c1_m1_t5" );
	end;
	if n == 6 then
		t6 = 1;
		TutorialMessageBox( "c1_m1_t6_1" );
		TutorialSetBlink( "end_of_turn_blink", 1 );
		tsleep();
		TutorialMessageBox( "c1_m1_t6_2" );
		tsleep();
		sleep(5);
		TutorialSetBlink( "end_of_turn_blink", 0 );	
	end;
	if n == 7 then
		t7 = 1;
		tsleep();
		TutorialMessageBox( "c1_m1_t7" );
	end;
	if n == 8 then
		t8 = 1;
		tsleep();
		TutorialMessageBox( "c1_m1_t8" );
	end;
	if n == 91 then
		t9_1 = 1;
		tsleep();
		TutorialMessageBox( "c1_m1_t9_1" );
	end;
	if n == 92 then
		t9_2 = 1;
		tsleep();
		TutorialMessageBox( "c1_m1_t9_2" );
	end;
	if n == 10 then
		t10 = 1;
		sleep(5);
		tsleep();
		sleep(5);
		TutorialMessageBox( "c1_m1_t10" );
		TutorialSetBlink( "hero_blink", 1 );
		tsleep();
		sleep(5);
		TutorialSetBlink( "hero_blink", 0 );
	end;
end;

function WinLoose()
	while 1 do
		if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
			SaveHeroAllSetArtifactsEquipped("Isabell","C1M1");
			sleep(5)
			Win(); 
			return
		end;
		if GetObjectiveState("prim2") == OBJECTIVE_FAILED then
			sleep(5)
			Loose();
			return
		end;
		sleep(1);
	end;
end;

function Hint_CameraControl_new()
	TutorialMessageBox( "c1_m1_t3_2" );
	tsleep();
	TutorialMessageBox( "c1_m1_t3_3" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "cam1", nil );
end;

function Hint_MoveHero()
	pos_x, pos_y = GetObjectPosition( 'Isabell' );
	if ( pos_x == start_x ) and ( pos_y == start_y ) then
		Tutorial( 2 );
	end;
end;

function GarrisonVisit()
	MessageBox( '/Maps/Scenario/C1M1/notready.txt');
end;

function Objective3()
	if ( GetObjectiveState( 'prim3' ) ~= OBJECTIVE_ACTIVE ) then
		SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
		x, y, fl = GetObjectPosition( 'zastava' );
		OpenCircleFog( x, y, fl, 4, PLAYER_1 );
	end;
	sleep( 1 );
	if ( IsObjectExists( 'swordsman' ) ) then
		Trigger( OBJECT_TOUCH_TRIGGER, "swordsman", nil );
	end;
end;

function CompleteObjective3()
	sleep( 10 );
	messages( 3 );
	sleep( 1 );
	SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
	--GiveExp( 'Isabell', 500 );
	SaveHeroAllSetArtifactsEquipped("Isabell","C1M1");
	sleep( 3 );
	Win();
end;

function HeroLost( heroname )
	if heroname == 'Isabell' then
		SetObjectiveState( 'prim2', OBJECTIVE_FAILED );
		Loose();
	end;
end;

function Hint_Faerie()
	tsleep();
	TutorialMessageBox( "c1_m1_faerie" );
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER , "faerie", nil );
end;

function Hint_Mill()
	tsleep();
	TutorialMessageBox( "c1_m1_mill" );
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER , "windmill", nil );
end;

function EnableTutorial()
	SetGameVar( "temp.tutorial", 1 );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "windmill", "Hint_Mill" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "faerie", "Hint_Faerie" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "attack04", "Hint_Attack_04" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop5", "Hint_CameraControl_03" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop6", "Hint_CameraControl_03" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop7", "Hint_CameraControl_03" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop8", "Hint_CameraControl_03" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t7", "Hint_PickUpGold_07" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t8", "Hint_SimpleBuilding_08" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t9_1", "Hint_NearBuilding_09_1" );
	Trigger( HERO_LEVELUP_TRIGGER, "Isabell", "Hint_HeroInformation_10" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "cam1", "Hint_CameraControl_new" );
end;

function DisableTutorial()
	SetGameVar( "temp.tutorial", 0 );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "windmill", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "faerie", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "attack04", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop5", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop6", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop7", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "stop8", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t7", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t8", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t9_1", nil );
	Trigger( HERO_LEVELUP_TRIGGER, "Isabell", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "cam1", nil );
end;

COMBAT = 9999;
THREAD = 9998;

TutorialTriggers = {
	{ "c1_m1_mill", REGION_ENTER_AND_STOP_TRIGGER, "windmill", "Hint_Mill", 0 },
	{ "c1_m1_faerie", REGION_ENTER_AND_STOP_TRIGGER, "faerie", "Hint_Faerie", 0 },
	{ "c1_m1_t4", REGION_ENTER_AND_STOP_TRIGGER, "attack04", "Hint_Attack_04", 0 },
	{ "c1_m1_t3_1", REGION_ENTER_AND_STOP_TRIGGER, "stop5", "Hint_CameraControl_03", 0 },
	{ "c1_m1_t3_1", REGION_ENTER_AND_STOP_TRIGGER, "stop6", "Hint_CameraControl_03", 0 },
	{ "c1_m1_t3_1", REGION_ENTER_AND_STOP_TRIGGER, "stop7", "Hint_CameraControl_03", 0 },
	{ "c1_m1_t3_1", REGION_ENTER_AND_STOP_TRIGGER, "stop8", "Hint_CameraControl_03", 0 },
	{ "c1_m1_t7", REGION_ENTER_AND_STOP_TRIGGER, "t7", "Hint_PickUpGold_07", 0 },
	{ "c1_m1_t8", REGION_ENTER_AND_STOP_TRIGGER, "t8", "Hint_SimpleBuilding_08", 0 },
	{ "c1_m1_t9_1", REGION_ENTER_AND_STOP_TRIGGER, "t9_1", "Hint_NearBuilding_09_1", 0 },
	{ "c1_m1_t10", HERO_LEVELUP_TRIGGER, "Isabell", "Hint_HeroInformation_10", 0 },
	{ "c1_m1_t3_2", REGION_ENTER_AND_STOP_TRIGGER, "cam1", "Hint_CameraControl_new", 0 },
	--{ "c1_m1_t11_1", COMBAT, 0, 0, 0 },
	--{ "c1_m1_t11_hero", COMBAT, 0, 0, 0 },
	--{ "c1_m1_t11_new", COMBAT, 0, 0, 0 },
	{ "c1_m1_t6_1", THREAD, 0, Hint_EndOfTurn_06, 0 },
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

-----
SetGameVar( "temp.C1M1.num_combat", 0 );
SetObjectEnabled( 'zastava', nil );
SetPlayerResource( PLAYER_1, WOOD, 0 );
SetPlayerResource( PLAYER_1, ORE, 0 );
SetPlayerResource( PLAYER_1, MERCURY, 0 );
SetPlayerResource( PLAYER_1, CRYSTAL, 0 );
SetPlayerResource( PLAYER_1, SULFUR, 0 );
SetPlayerResource( PLAYER_1, GEM, 0 );
SetPlayerResource( PLAYER_1, GOLD, 0 );
--startThread( WinLoose );
startThread( PObjective1 ); 

Trigger( REGION_ENTER_AND_STOP_TRIGGER , "d2", "Dialog2" );
Trigger( PLAYER_REMOVE_HERO_TRIGGER , PLAYER_1, "HeroLost" );
Trigger( OBJECT_TOUCH_TRIGGER, "zastava", "GarrisonVisit" );
Trigger( OBJECT_CAPTURE_TRIGGER, "zastava", "CompleteObjective3" );
Trigger( OBJECT_TOUCH_TRIGGER, "swordsman", "Objective3" );

messages( 1 );
--UnblockGame();
sleep( 2 );
SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );
SetObjectiveState( 'prim1a', OBJECTIVE_ACTIVE );

-- tutorial related --
TutorialActivateHint( "level_up_hint" );
TutorialActivateHint( "creatures_join_hint" );
TutorialActivateHint( "creatures_flee_hint" );
TutorialActivateHint( "combat_results" );
TutorialActivateHint( "hero_screen" );
TutorialActivateHint( "barracks_hint" );

startThread( CheckTutorialTriggers );
SetGameVar( "temp.tutorial", 1 );

function Clicky()
	GiveExp( 'Isabell', 500 );	
end;

MessageBox({"/Text/Game/Scripts/CampaignHelper.txt"},"Clicky");

if IsTutorial then
	--startThreadOnce( Hint_EndOfTurn_06 );
	--EnableTutorial();
	sleep(40); -- fake
	Tutorial( 1 );
	sleep(12);
	Hint_MoveHero();
end;
--startThread( CheckTutorial );