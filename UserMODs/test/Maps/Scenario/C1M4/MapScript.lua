doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M4");
	LoadHeroAllSetArtifacts( "Isabell" , "C1M3" );
end;

startThread(H55_InitSetArtifacts);

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

---Start level abjustment---
C1M4_C1 = 0;
C1M4_C2 = 0;
C1M4_C3 = 0;
C1M4_C4 = 0;
C1M4_C5 = 0;
C1M4_C6 = 0;
C1M4_C7 = 0;
BOOTS = 0;
startweek = 0;

IsTutorial = 1;--IsTutorialEnabled();
once = 0;
t9 = 0;
oracle_visited="/Maps/Scenario/C1M4/visited.txt"

SetGameVar("temp.CountVisitToTown", 0);
SetGameVar("temp.CombatCount", 0);
SetGameVar("temp.SpellLearned", 0);
SetGameVar("temp.ArhangelsCaptured", 0);

---Objective check sequence---
function messages( dialog )
	if dialog == 1 then
		C1M4_C1 = 1; -- mission start !
		StartDialogScene("/DialogScenes/C1/M4/D1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 2 then
		C1M4_C2 = 1; -- isabel captures town !
		StartDialogScene("/DialogScenes/C1/M4/R1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 3 then
		C1M4_C3 = 1; -- built 3d level mage guild !
		StartDialogScene("/DialogScenes/C1/M4/R2/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 4 then
		C1M4_C4 = 1; -- destroyed bridge !
		StartDialogScene("/DialogScenes/C1/M4/D2/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 5 then
		C1M4_C5 = 1; -- oracle visited !
		StartDialogScene("/DialogScenes/C1/M4/R3/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 6 then
		C1M4_C6 = 1; -- boots of levitation !
		StartDialogScene("/DialogScenes/C1/M4/R4/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 7 then
		C1M4_C7 = 1; -- isabel visits place (not ready)
		Save("scene2" );
		StartCutScene( "/Maps/Cutscenes/C1M4/_.(AnimScene).xdb#xpointer(/AnimScene)")
		sleep( 3 );
		Win();
	end;
	if dialog == 8 then -- not isabel visited place (message)
		MessageBox ("/Maps/Scenario/C1M4/tutorial/C1M4_C8.txt");
		C1M4_C8 = 1;
	end;
end;

function Objective1( heroname )
	if heroname == 'Isabell' then
		SaveHeroAllSetArtifactsEquipped("Isabell", "C1M4");
		messages( 7 );
		sleep( 5 );
		Win();
	elseif ( once == 0 ) then
		messages( 8 );
		once = 1;
	end;
end;

function Objective2()
	if GetObjectiveState( 'prim2a' ) == OBJECTIVE_COMPLETED then
		messages( 2 );
		startweek = GetDate(WEEK) + GetDate( MONTH ) * 4;
	end;
	--startThread( Objective2part2 );
end;

function Objective2part2()
	--while 1 do
		--sleep( 2 );
		--if GetObjectOwner("mirakl") == PLAYER_1 and GetTownBuildingLevel( "mirakl", TOWN_BUILDING_MAGIC_GUILD ) == 3 then
	if GetObjectiveState( 'prim2' ) == OBJECTIVE_COMPLETED then
			messages( 3 );
			sleep( 1 );
			--SetObjectiveState( "prim2",OBJECTIVE_COMPLETED );
			GiveExp( 'Isabell', 20000 );
			Trigger( OBJECT_TOUCH_TRIGGER , "outpost", nil );
			SetObjectEnabled( "outpost", 1 ); -- outpost
			SetRegionBlocked( 'block', nil, PLAYER_1 );
			--break;
	end;
	--end;
end;

function SObjective1()
	messages( 4 );
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER , "brige", nil );
	Trigger( OBJECT_TOUCH_TRIGGER , "hut", "SObjective1Complete" );
	sleep( 1 );
	SetObjectiveState( "sec1", OBJECTIVE_ACTIVE );
	x, y, fl = GetObjectPos( "hut" );
	OpenCircleFog( x, y, fl, 4, PLAYER_1 );
end;

function OracleVisited()
	MessageBox( oracle_visited );
end;

function SObjective1Complete()
	messages( 5 );
	Trigger( OBJECT_TOUCH_TRIGGER , "hut", "OracleVisited" );
	MarkObjectAsVisited( 'hut', 'Isabell' );
	--SetObjectEnabled("hut", not nil);
	if GetObjectiveState( "sec2" ) == OBJECTIVE_UNKNOWN then
		SetObjectiveState( "sec2", OBJECTIVE_ACTIVE );
	end;
	SetObjectiveState( "sec1", OBJECTIVE_COMPLETED );
	x, y, fl = GetObjectPos( "crypt" );
	OpenCircleFog( x, y, fl, 4, PLAYER_1 );
end;

function Crypt( heroname )
	--sleep( 5 );
	local coeffs = { 0.4, 0.8, 1.4, 2.0 };
	local coeff = coeffs[ __difficulty + 1 ];
	local weeks = GetDate( WEEK ) + GetDate( MONTH ) * 4 - startweek;
	print( 'weeks passed = ', weeks );
	local archers = 52 + coeff * 20 * weeks;
	local zombies = 39 + coeff * 15 * weeks;
	local ghosts = 25 + coeff * 9 * weeks;
	local lichs = 10 + coeff * 3 * weeks;
	local wraiths = 5 + coeff * 2 * weeks;
	print( 'army: '..archers..' '..zombies..' '..ghosts..' '..lichs..' '..wraiths);
	StartCombat( heroname, nil, 5, CREATURE_ZOMBIE, zombies, CREATURE_SKELETON_ARCHER, archers,
		CREATURE_GHOST, ghosts, CREATURE_WRAITH, wraiths, CREATURE_LICH, lichs, nil, 'CryptResult' );
end;

function CryptResult( heroname, res )
 --	if ( IsHeroAlive( heroname ) ) then
if res then
		messages( 6 );
		GiveArtefact( heroname, ARTIFACT_BOOTS_OF_LEVITATION );
		Trigger( OBJECT_TOUCH_TRIGGER, "crypt", nil );
		heroes = GetPlayerHeroes( PLAYER_1 );
		for i, hero in heroes do
			if GetTownHero( 'mirakl' ) ~= hero then
				MarkObjectAsVisited( 'crypt', hero );
			end;
		end;
		--Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "brige", nil );
		sleep( 3 );
		if GetObjectiveState( "sec2" ) ~= OBJECTIVE_ACTIVE then
			SetObjectiveState( "sec2", OBJECTIVE_ACTIVE );
		end;
		sleep( 1 );
		SetObjectiveState( "sec2", OBJECTIVE_COMPLETED );
	end;
end;

function Tutorial( n )
	TutorialMessageBox( "c1_m4_t"..n );
end;

function len( x, y )
local l = sqrt( x * x + y * y );
	return l;
end;

function Hint_FirstSpell1( heroName )
	Tutorial( 1 );
	startThread( Hint_MagicSchools2, heroName );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t1", nil );
end;

function Hint_MagicSchools2( heroName )
	local x, y, l = GetObjectPos( heroName );
	local cx, cy, cl;
	cx, cy, cl = x, y, l;
	while len( cx - x + 1, cy - y ) < 10 do
		cx, cy, cl = GetObjectPos( heroName );
		sleep(2);
	end;
	print("len=", len( cx - x + 1, cy - y ));
	Tutorial( 2 );
end;

function Hint_SpellPower_and_Knowledge4()
	Tutorial( 4 );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t4", nil );
end;

function Learning()
	SetGameVar( "temp.SpellLearned", 1 );
	Trigger( OBJECT_TOUCH_TRIGGER , "FirstSpell", nil );
end;

function Hint_MagicMagicWell7()
	Tutorial( 7 );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t7_1", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t7_2", nil );
end;

function Hint_MagicOnAdventure8()
	Tutorial( 8 );
	Trigger( OBJECT_TOUCH_TRIGGER  , "t9_2", nil );
end;

function Hint_MagicCircles9()
	local x, y, l;
	local cx, cy, cl;
	while GetObjectOwner("mirakl") ~= PLAYER_1 do
		if t9 == 1 then
			return
		end;
		sleep(1);
	end;
	x, y, l = GetObjectPos( "Isabell" );
	cx, cy, cl = x, y, l;
	while len( cx - x + 1, cy - y ) < 10 do
		cx, cy, cl = GetObjectPos( "Isabell" );
		sleep(1);
	end;
	print("len=", len( cx - x + 1, cy - y ));
	Tutorial( 9 );
	t9 = 1;
	Trigger(OBJECT_TOUCH_TRIGGER, "t9_1", nil);
--	Trigger(OBJECT_TOUCH_TRIGGER, "t9_3", nil);
	Trigger(OBJECT_TOUCH_TRIGGER, "t9_4", nil);
	Trigger(OBJECT_TOUCH_TRIGGER, "t9_5", nil);
end;

function HindMagicCircles9dupe()
	Tutorial( 9 );
	t9 = 1;
	Trigger(OBJECT_TOUCH_TRIGGER, "t9_1", nil);
--	Trigger(OBJECT_TOUCH_TRIGGER, "t9_3", nil);
	Trigger(OBJECT_TOUCH_TRIGGER, "t9_4", nil);
	Trigger(OBJECT_TOUCH_TRIGGER, "t9_5", nil);
end;

function IsAnyHeroPlayerHasCreature( playerID, creatureID )
	local heroes = {};
	local m, h;
	heroes = GetPlayerHeroes( playerID );
	for m, h in heroes do
		if GetHeroCreatures( h, creatureID ) > 0 then
			print( "hero ", h, " has ", creatureID );
    		return not nil;
	    end;
	end;
	return nil;
end;

function Hint_ResurrectAllies14()
	while IsAnyHeroPlayerHasCreature( PLAYER_1, CREATURE_ARCHANGEL ) == nil do
		sleep(10);
	end;
	--Tutorial( 14 );
	SetGameVar("temp.ArhangelsCaptured", 1);
	SetHeroCombatScript( 'Isabell', '/Maps/Scenario/C1M4/IsabellCombat.xdb#xpointer(/Script)' );
	startThread( CheckIsabellCombatScript2 );
end;

function Hint_FeedExQuests15()
	Tutorial( 15 );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t15_1", nil);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t15_2", nil);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t15_3", nil);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t15_4", nil );
end;

function LostHero( heroname )
	if heroname == 'Isabell' then
		SetObjectiveState( 'prim3', OBJECTIVE_FAILED );
		sleep( 2 );
		Loose();
	end;
end;

function Outpost()
	MessageBox ("/Maps/Scenario/C1M4/outpost.txt");
end;

function CheckHeroSpells()
	while 1 do
		sleep( 2 );
		if KnowHeroSpell( 'Isabell', SPELL_SUMMON_CREATURES ) then
			sleep( 5 );
			Tutorial( 8 );
			break;
		end;
	end;
end;

function EnableTutorial()
	SetGameVar( "temp.tutorial", 1 );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t7_1", "Hint_MagicMagicWell7" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t7_2", "Hint_MagicMagicWell7" );
	--Trigger( OBJECT_TOUCH_TRIGGER , "t9_2", "Hint_MagicOnAdventure8" );

	Trigger(OBJECT_TOUCH_TRIGGER, "t9_1", "HindMagicCircles9dupe");
	Trigger(OBJECT_TOUCH_TRIGGER, "t9_4", "HindMagicCircles9dupe");
	Trigger(OBJECT_TOUCH_TRIGGER, "t9_5", "HindMagicCircles9dupe");

	--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t15_3", "Hint_FeedExQuests15" );

	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t1", "Hint_FirstSpell1" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t4", "Hint_SpellPower_and_Knowledge4" );
end;

function DisableTutorial()
	SetGameVar( "temp.tutorial", 0 );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t7_1", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t7_2", nil );
	--Trigger( OBJECT_TOUCH_TRIGGER , "t9_2", nil );

	Trigger(OBJECT_TOUCH_TRIGGER, "t9_1", nil );
	Trigger(OBJECT_TOUCH_TRIGGER, "t9_4", nil );
	Trigger(OBJECT_TOUCH_TRIGGER, "t9_5", nil );
	--Trigger( OBJECT_TOUCH_TRIGGER , "FirstSpell", nil );

	--Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t15_3", nil );

	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t1", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t4", nil );
end;

COMBAT = 9999;
THREAD = 9998;

TutorialTriggers = {
	{ "c1_m4_t7", REGION_ENTER_AND_STOP_TRIGGER, "t7_1", "Hint_MagicMagicWell7", 0 },
	{ "c1_m4_t7", REGION_ENTER_AND_STOP_TRIGGER, "t7_2", "Hint_MagicMagicWell7", 0 },
	{ "c1_m4_t9", OBJECT_TOUCH_TRIGGER, "t9_1", "HindMagicCircles9dupe", 0 },
	{ "c1_m4_t9", OBJECT_TOUCH_TRIGGER, "t9_4", "HindMagicCircles9dupe", 0 },
	{ "c1_m4_t9", OBJECT_TOUCH_TRIGGER, "t9_5", "HindMagicCircles9dupe", 0 },
	{ "c1_m4_t1", REGION_ENTER_AND_STOP_TRIGGER, "t1", "Hint_FirstSpell1", 0 },
	{ "c1_m4_t4", REGION_ENTER_AND_STOP_TRIGGER, "t4", "Hint_SpellPower_and_Knowledge4", 0 },
--	{ "c1_m4_t5", OBJECT_TOUCH_TRIGGER, "FirstSpell", "Learning", 0 },
	{ "c1_m4_t9", THREAD, 0, Hint_MagicCircles9, 0 },
--	{ "c1_m4_t14", THREAD, 0, Hint_ResurrectAllies14, 0 }
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

function CheckIsabellCombatScript1()
	while 1 do
		sleep( 3 );
		if GetGameVar("temp.SpellLearned") == "2" then
			ResetHeroCombatScript( 'Isabell' );
			break;
		end;
	end;
end;

function CheckIsabellCombatScript2()
	while 1 do
		sleep( 3 );
		if GetGameVar("temp.ArhangelsCaptured") == "2" then
			ResetHeroCombatScript( 'Isabell' );
			break;
		end;
	end;
end;

-----
SetPlayerResource(PLAYER_1,WOOD,0);
SetPlayerResource(PLAYER_1,ORE,0);
SetPlayerResource(PLAYER_1,GEM,0);
SetPlayerResource(PLAYER_1,CRYSTAL,0);
SetPlayerResource(PLAYER_1,MERCURY,0);
SetPlayerResource(PLAYER_1,SULFUR,0);
SetPlayerResource(PLAYER_1,GOLD,0);

SetRegionBlocked( 'block', 1, PLAYER_1 );
SetObjectEnabled( "hut", nil ); -- functionality hut disabled
SetObjectEnabled( "crypt", nil ); --
SetObjectEnabled( "outpost", nil ); -- outpost

messages( 1 );

--Trigger( OBJECT_TOUCH_TRIGGER , "hut", "SObjective1Complete" );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER , "brige", "SObjective1" );

Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER , "meeting_place", "Objective1" );
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER , "meeting_place1", "Objective1" );
--Trigger( OBJECT_CAPTURE_TRIGGER , 'mirakl', "Objective2" );
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, 'prim2a', 'Objective2' );
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, 'prim2', 'Objective2part2' );
Trigger( OBJECT_TOUCH_TRIGGER , "crypt", "Crypt" );
Trigger( OBJECT_TOUCH_TRIGGER , "outpost", "Outpost" );

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );

sleep( 1 );
SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );
--SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );

OpenCircleFog( 34, 161, 0, 8, PLAYER_1 );
OpenCircleFog( 81, 165, 0, 8, PLAYER_1 );

startThreadOnce( Hint_ResurrectAllies14 );
startThread( CheckHeroSpells );
startThread( CheckIsabellCombatScript1 );
Trigger( OBJECT_TOUCH_TRIGGER , "FirstSpell", "Learning" );

-- tutorial related
TutorialActivateHint( "magic_skills" );
startThread( CheckTutorialTriggers );
SetGameVar( "temp.tutorial", 1 );

if IsTutorial == 1 then
	--EnableTutorial();
	--startThreadOnce( Hint_MagicCircles9 );
end;
--startThread( CheckTutorial );
x,y,z = RegionToPoint('Fog');
OpenCircleFog(x, y, z, 5 , PLAYER_1);
H55_CamFixTooManySkills(PLAYER_1,"Isabell");