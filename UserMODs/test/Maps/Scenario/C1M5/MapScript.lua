doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M5");
	--LoadHeroAllSetArtifacts( "Isabell" , "C1M4" );
end;

startThread(H55_InitSetArtifacts);

H55_PlayerStatus = {0,1,1,2,2,2,2,2};

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

SetRegionBlocked("t2", 1, 2);
SetRegionBlocked("t2_1", 1, 2);
SetRegionBlocked("t2_2", 1, 2);

STAGE_RESCUE_ISABEL = 0;
STAGE_SURVIVE_ASSAULT = 1;

OBJ_RESC_ISABEL = "prim1";
OBJ_CAPT_DUMMAR = "prim1"; -- for compatibility with old script -- function General()

PORTAL1_X = 38;
PORTAL1_Y = 27;
PORTAL2_X = 71;
PORTAL2_Y = 86;

portals = { {38, 27}, {71, 86} };

--** crap
crap = __difficulty - 1;
if crap < 0 then
	crap = 0;
end;
--** end of crap

--ASSAULT_START_DAY = 2*7;
ASSAULT_START_DAY = 14; --debug
ASSAULT_DELAY = 8 - crap; -- 7
ASSAULT_COUNT = 3;

if __difficulty == DIFFICULTY_EASY then
	easyfactor = 0.35;
elseif __difficulty == DIFFICULTY_NORMAL then
	easyfactor = 0.7;
else
	easyfactor = 1.0;
end;

nCurrentStage = STAGE_RESCUE_ISABEL;
bIsabellSpawned = 0;
bIsabellObjSet = 0;
bGodricGone = 0;
bAgraelDefeated = 0;
bNicDead = 0;
Graal_Found = 0;
Attacking = 0;
TheShow = 0;
GrailBuilt = 0;
NoMoreDefeatChecks = 0;

nAssaultCount = 0;
nAssaultCountFinished = 0;
assault_hero_names = { "Nymus", "Jazaz", "Efion" };
DumX, DumY, DumLayer = GetObjectPos( "Dummar" );

C1M5_C1 = 0; -- C1/M5/D1
C1M5_C2 = 0; -- C1/M5/D4A
C1M5_C3 = 0; -- C1/M5/D3
C1M5_C4 = 0; -- C1/M5/D4
C1M5_C5 = 0; -- C1/M5/R1
C1M5_C6 = 0; -- C1/M5/D5
C1M5_C7 = 0; -- C1/M5/R2
C1M5_C8 = 0; -- C1/M5/R3
C1M5_C9 = 0; -- C1/M5/R4
C1M5_C10 = 0; -- cutscene
C1M5_C11 = 0; -- text

t2 = 0;
t3 = 0;
t4 = 0;
t5 = 0;

IsTutorial = 1;--IsTutorialEnabled();

--oldStartDialogScene = StartDialogScene;
--function StartDialogScene( name )
--	print( name );
--end;

function messages( dialog )
	if dialog == 1 then
		C1M5_C1 = 1;
		StartDialogScene("/DialogScenes/C1/M5/D1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 2 then
		C1M5_C2 = 1;
		StartDialogScene("/DialogScenes/C1/M5/D4A/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 3 then
		C1M5_C3 = 1;
		StartDialogScene("/DialogScenes/C1/M5/D3/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 4 then
		C1M5_C4 = 1;
		StartDialogScene("/DialogScenes/C1/M5/D4/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 5 then
		C1M5_C5 = 1;
		StartDialogScene("/DialogScenes/C1/M5/R1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 6 then
		C1M5_C6 = 1;
		StartDialogScene("/DialogScenes/C1/M5/D5/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 7 then
		C1M5_C7 = 1;
		StartDialogScene("/DialogScenes/C1/M5/R2/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 8 then
		if C1M5_C8 == 0 then
			StartDialogScene("/DialogScenes/C1/M5/R3/DialogScene.xdb#xpointer(/DialogScene)");
		end;
		C1M5_C8 = 1;
	end;
	if dialog == 9 then
		C1M5_C9 = 1;
	end;
	if dialog == 10 then
		Save("scene3" );
		StartCutScene( "/Maps/Cutscenes/C1M5/_.(AnimScene).xdb#xpointer(/AnimScene)" );
		sleep( 5 );
	end;
	if dialog == 11 then
		MessageBox ("/Maps/Scenario/C1M5/Tutorial/C1M5_C11.txt", "MessageBox11" );
		C1M5_C11 = 1;
	end;
end;

function MessageBox11()
	MessageBox ("/Maps/Scenario/C1M5/Tutorial/C1M5_C11_2.txt" );
end;

function LastScene( heroName )
	if heroName == 'Isabell' then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "exit1", nil );
		messages( 10 );
		sleep( 3 );
		Win();
	end;
end;

function PObjective1()
	if IsHeroAlive( "Isabell" ) and GetObjectOwner("Dummar") == PLAYER_1 then
		--messages( 3 );
		--sleep(1);
		SetObjectiveState( "prim2", OBJECTIVE_ACTIVE );
		SetObjectiveState( "prim1", OBJECTIVE_COMPLETED );
		--GiveExp( 'Isabell', 70000 );
		sleep( 1 );
		startThread( AgraelAttack );
	end;
end;

function TownCaptured( prevowner, newowner )
	if newowner == PLAYER_1 then
		if bIsabellSpawned == 0 then
			messages( 11 );
		end;
		PObjective1();
	else
		SetObjectiveState( "prim2", OBJECTIVE_FAILED );
		sleep( 2 );
		Loose();
	end;
end;

function IsabellRescued( heroName )
	bIsabellSpawned = 1;
	Trigger( OBJECT_TOUCH_TRIGGER, "Prison", nil );
	SetRegionBlocked( 'AIblock', nil, PLAYER_2 );
	messages( 3 );
	sleep(1);	
	GiveExp( 'Godric', 2000 );
	PObjective1();
	LoadHeroAllSetArtifacts("Isabell","C1M4");
	H55_CamFixTooManySkills(PLAYER_1,"Isabell");
end;

function PObjective3()
	while 1 do
		sleep( 2 );
		if GetTownBuildingLevel( "Dummar", TOWN_BUILDING_GRAIL ) == 1 then
			messages( 5 );
			sleep( 1 );
			SetObjectiveState( "prim3", OBJECTIVE_COMPLETED );
			GiveExp( 'Isabell', 10000 );
			if IsObjectExists( 'Godric') then
				sleep( 1 );
				GiveExp( 'Godric', 2000 );
			end;
			GrailBuilt = 1;
			return
		end;
		if ( Graal_Found == not nil ) and ( IsAnyHeroPlayerHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) == nil ) then
			MessageBox( "/Maps/Scenario/C1M5/GrailLost.txt" );
			SetObjectiveState( "prim3", OBJECTIVE_FAILED );
			sleep( 3 );
			Loose();
			return
		end;
	end;
end;

function PObjective4( heroName )
	if heroName ~= "Godric" then
		return
	end;
	SaveHeroAllSetArtifactsEquipped("Godric", "C1M5");
	Attacking = 0;
	bGodricGone = 1;
	MoveHeroRealTime( "Godric", 134, 11, 0 );
	local n = 0;
	while GetObjectPos( "Godric" ) ~= 134 do
		n = n + 1;
		sleep( 1 );
		if (n > 30 ) then
			break;
		end;
	end;
	RemoveObject("Godric");
	sleep( 2 );
	messages( 7 );
	sleep( 3 );
	SetObjectiveState( "prim4", OBJECTIVE_COMPLETED );
	--GiveExp( 'Isabell', 10000 );
	
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "exit", nil );
	
	--if GetObjectOwner( "InfTown" ) == PLAYER_2 then
		--DeployReserveHero( "Agrael", 120, 55, GROUND );
	--else
		DeployReserveHero( "Agrael", 132, 40, GROUND );
	--end;
	sleep( 1 );
	--EnableHeroAI( "Agrael", not nil );
	EnableHeroAI( "Agrael", nil );
	sleep( 1 );
	mult = GetDate(MONTH);
	AddHeroCreatures( "Agrael", CREATURE_HELL_HOUND, 600*mult );
	AddHeroCreatures( "Agrael", CREATURE_HORNED_DEMON, 1000*mult );
	AddHeroCreatures( "Agrael", CREATURE_ARCHDEVIL, 50*mult );
	AddHeroCreatures( "Agrael", CREATURE_BALOR, 120*mult );
	AddHeroCreatures( "Agrael", CREATURE_INFERNAL_SUCCUBUS, 200*mult );
	--sleep( 1 );
	--MoveHero( "Agrael", 120, 34, GROUND );
	--sleep( 1 );

	--startThread( PlaceNicolai );
	--startThread( DisableAgrael );
	TheShow = 1;
end;

-- function PlaceNicolai()
	-- while GetCurrentPlayer() == PLAYER_1 do
		-- sleep( 1 );
	-- end;
	-- DeployReserveHero( 'Nicolai', 133, 12, 0 );
	-- sleep( 1 );
	-- EnableHeroAI( 'Nicolai', not nil );
	-- sleep( 1 );
	-- MoveHero( 'Nicolai', 124, 27, 0 );
-- end;

-- function DisableAgrael()
	-- while H55_ReachedDestination("Agrael",120,34,GROUND) ~= 1 do
		-- sleep( 1 );
	-- end;
	-- EnableHeroAI( "Agrael", nil );
-- end;

function H55_SecTriggerDaily()
	if TheShow == 1 then
		DeployReserveHero( 'Nicolai', 133, 12, 0 );
		-- sleep( 1 );
		-- EnableHeroAI( 'Nicolai', not nil );
		-- sleep( 1 );
		-- MoveHero( 'Nicolai', 124, 27, 0 );
		-- messages( 8 );
		-- sleep( 3 );
		-- SetObjectiveState( 'prim5', OBJECTIVE_ACTIVE );
		-- SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
		-- Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "exit1", "LastScene" ); -- crap?
		-- MoveHero( 'Nicolai', 121, 32, 0 );
		TheShow = 2;
	elseif TheShow == 2 then
		messages( 8 );
		sleep( 3 );
		SetObjectiveState( 'prim5', OBJECTIVE_ACTIVE );
		SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "exit1", "LastScene" ); -- crap?
		EnableHeroAI( 'Nicolai', not nil );
		if CanMoveHero('Nicolai', 121, 32, 0) then
			MoveHero( 'Nicolai', 121, 32, 0 );
		end;
		TheShow = 3;
	elseif TheShow == 3 then
		if IsObjectExists('Agrael') then
			EnableHeroAI( 'Agrael', not nil );
			if CanMoveHero('Agrael', 120, 34, 0) then
				MoveHero( 'Agrael', 120, 34, 0 );
			end;
			sleep( 10 );
		end;
		LastScene('Isabell');
	-- elseif TheShow >= 2 and IsHeroAlive('Agrael') == nil then
		-- LastScene('Isabell');
	end;
	if Attacking == 1 then
		if GetDate() == nAssaultDay then
			nAssaultCount = nAssaultCount + 1;
			--if GrailBuilt == 0 then
			nAssaultDay = nAssaultDay + ASSAULT_DELAY + (4 - crap);
			--else
			--	nAssaultDay = nAssaultDay + ASSAULT_DELAY + (5 - __difficulty * 2);
			--end;
			DeployAssaultHero( nAssaultCount );
			print("nAssaultCount = ".. nAssaultCount);
			print("nAssaultDay = ".. nAssaultDay);
			--Attacking = 0;
		end;
	end;
	AddObjectCreatures("Garnison", CREATURE_ARCHDEVIL , 5);
	AddObjectCreatures("Garnison", CREATURE_BALOR , 10);
	AddObjectCreatures("Garnison", CREATURE_FRIGHTFUL_NIGHTMARE , 15);
	AddObjectCreatures("Garnison", CREATURE_INFERNAL_SUCCUBUS , 20);
end;

function len( x, y )
local l = sqrt( x * x + y * y );
	return l;
end;

function AgraelAttack()	
	EnableHeroAI( "Agrael", not nil );
	sleep( 1 );
	GiveArtefact( 'Agrael', ARTIFACT_SHACKLES_OF_WAR );
	SetHeroLootable( 'Agrael', nil );
	sleep( 1 );
	if ( __difficulty == DIFFICULTY_NORMAL ) or ( __difficulty == DIFFICULTY_EASY ) then
		RemoveHeroCreatures( 'Agrael', CREATURE_DEVIL, 5 );
		RemoveHeroCreatures( 'Agrael', CREATURE_HORNED_DEMON, 20 );
	end;
	sleep( 1 );
	H55_AttackTown( "Agrael" ,"Dummar");
	--MoveHero( "Agrael", DumX, DumY, DumLayer );
end;

function AgraelDefeated( looserHero, winnerHero )
	print("looserHero = ", looserHero);
	if looserHero == "Agrael" and bAgraelDefeated == 0 then
		bAgraelDefeated = 1;
		if C1M5_C4 == 0 then
			messages( 4 );
		end;
		Attacking = 1;
		nAssaultDay = GetDate() + ASSAULT_DELAY;
		H55_NewDayTrigger = 0;
		H55_SecNewDayTrigger = 1;
		--Trigger( NEW_DAY_TRIGGER, 'NewDay' );
	elseif (looserHero == "Nymus" or looserHero == "Jazaz" or looserHero == "Efion") and (NoMoreDefeatChecks == 0) then
		nAssaultCountFinished = nAssaultCountFinished + 1;
		if nAssaultCountFinished == 1 then
			messages( 2 );
			sleep( 3 );
			SetObjectiveState( "prim3", OBJECTIVE_ACTIVE );
			startThread( PObjective3 );
		elseif GrailBuilt == 1 then
			messages( 6 );
			sleep( 3 );
			SetObjectiveState( 'prim4', OBJECTIVE_ACTIVE );
			OpenCircleFog( 129, 15, 0, 6, PLAYER_1 );
			Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "exit", "PObjective4" );
			local balors = (2 - crap) * 6;
			local nightmares = (2 - crap) * 8;
			local succubus = (2 - crap) * 12;
			if balors > 0 then
				RemoveObjectCreatures( 'garrison', CREATURE_BALOR, balors );
			end;
			if nightmares > 0 then
				RemoveObjectCreatures( 'garrison', CREATURE_NIGHTMARE, nightmares );
			end;
			if succubus > 0 then
				RemoveObjectCreatures( 'garrison', CREATURE_INFERNAL_SUCCUBUS, succubus );
			end;
			NoMoreDefeatChecks = 1;
			if ( __difficulty == DIFFICULTY_EASY ) or ( __difficulty == DIFFICULTY_NORMAL ) then
				Attacking = 0;
			end;
		end;
	end;
end;

function DeployAssaultHero( heroNumber )
	local modulus = mod( heroNumber, 3 );
	local pos = random( 2 ) + 1;
	local name = assault_hero_names[modulus + 1];
	DeployReserveHero( name, portals[pos][1], portals[pos][2], GROUND );
	--sleep(1);
	--GiveExp( name, (heroNumber + 3) * 3000 * (__difficulty + 1) );
	sleep(1);
	EnableHeroAI( name, not nil );
	sleep(1);
	if modulus == 0 then
		numcreatures = (100 + heroNumber * 15 + random( 5 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_IMP, numcreatures );
		end;
		
		numcreatures = (36 + heroNumber * 12 + random( 5 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_HORNED_DEMON, numcreatures );
		end;
		
		numcreatures = (20 + heroNumber * 8 + random( 3 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_CERBERI, numcreatures );
		end;
		
		numcreatures = (9 + heroNumber * 4) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_INFERNAL_SUCCUBUS, numcreatures );
		end;
		
		numcreatures = (2 + heroNumber) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_DEVIL, numcreatures );
		end;
	elseif modulus == 1 then
		numcreatures = (90 + heroNumber * 16 + random( 5 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_FAMILIAR, numcreatures );
		end;
		
		numcreatures = (42 + heroNumber * 10 + random( 5 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_DEMON, numcreatures );
		end;
		
		numcreatures = (36 + heroNumber * 6 + random( 3 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_CERBERI, numcreatures );
		end;
		
		numcreatures = (9 + heroNumber * 2) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_FRIGHTFUL_NIGHTMARE, numcreatures );
		end;
		
		numcreatures = (1 + heroNumber) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_ARCHDEVIL, numcreatures );
		end;
	elseif modulus == 2 then
		numcreatures = (40 + heroNumber * 9 + random( 4 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_HORNED_DEMON, numcreatures );
		end;
		
		numcreatures = (30 + heroNumber * 7 + random( 3 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_HELL_HOUND, numcreatures );
		end;
		
		numcreatures = (12 + heroNumber * 4) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_SUCCUBUS, numcreatures );
		end;
		
		numcreatures = (6 + heroNumber * 3) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_NIGHTMARE, numcreatures );
		end;
		
		numcreatures = (4 + heroNumber * 2) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_BALOR, numcreatures );
		end;
	end;
	print(" ",name," is going");
	sleep(1);
	H55_AttackTown(name,"Dummar");
	--MoveHero( name, DumX, DumY, DumLayer );
end;

--------------------------------------------------------------------------------
------------------------------------Tutorial------------------------------------
function Tutorial( n )
	if n == 2 then
		t2 = 1;
		TutorialMessageBox( "c1_m5_t2" );
		--WaitForTutorialMessageBox();
		--TutorialMessageBox( "c1_m5_t2_2" );
	end;
	if n == 3 then
		t3 = 1;
		TutorialMessageBox( "c1_m5_t3" );
	end;
	if n == 4 then
		t4 = 1;
--		TutorialMessageBox( "c1_m5_t4" ); -- in Dummar
	end;
	if n == 5 then
		t5 = 1;
--		TutorialMessageBox( "c1_m5_t5" ); -- нет англ текстов
	end;
end;

function Hint_Obelisk2(nameHero)
	if GetObjectOwner(nameHero) ~= PLAYER_1 then
		return
	end;
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t2", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t2_1", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER , "t2_2", nil );
	--if t2 == 0 then
		Tutorial( 2 );
	--end;
end;

function Hint_Dig3(nameHero)
	if GetObjectOwner(nameHero) ~= PLAYER_1 then
		return
	end;
	Trigger( OBJECT_TOUCH_TRIGGER, "t3_1", nil );
	Trigger( OBJECT_TOUCH_TRIGGER, "t3_2", nil );
	--Trigger( OBJECT_TOUCH_TRIGGER, "t3_3", nil );
	Trigger( OBJECT_TOUCH_TRIGGER, "t3_4", nil );
	--if t3 == 0 then
		sleep(10);
		Tutorial( 3 );
	--end;
end;

function Graal()
	while IsAnyHeroPlayerHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) == nil do
		sleep(2);
	end;
	
--	if ( IsTutorial == 1 ) then
--		TutorialActivateHint( "town_hint" );
--	end;
	
	Graal_Found = 1;
--	Trigger( OBJECT_TOUCH_TRIGGER, "Dummar", nil );
end;

function IsAnyHeroPlayerHasArtifact( playerID, artifID )
	local heroes = {};
	local m = 0;
	local h = 0;
	heroes = GetPlayerHeroes( playerID );
	for m, h in heroes do
		if HasArtefact( h, artifID ) then
			return not nil;
	    end;
	end;
	return nil;
end;

function PlayerLostHero( heroname )
	if ( ( heroname == 'Godric' ) and ( bGodricGone == 0 ) ) or ( heroname == 'Isabell' ) then
		print(heroname);
		SetObjectiveState( 'prim6', OBJECTIVE_FAILED );
		sleep(1);
		Loose();
	end;
end;

function EnableTutorial()
	SetGameVar( "temp.tutorial", 1 );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2", "Hint_Obelisk2" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2_1", "Hint_Obelisk2" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2_2", "Hint_Obelisk2" );
	Trigger( OBJECT_TOUCH_TRIGGER, "t3_1", "Hint_Dig3" );
	Trigger( OBJECT_TOUCH_TRIGGER, "t3_2", "Hint_Dig3" );
	--Trigger( OBJECT_TOUCH_TRIGGER, "t3_3", "Hint_Dig3" );
	Trigger( OBJECT_TOUCH_TRIGGER, "t3_4", "Hint_Dig3" );
end;

function DisableTutorial()
	SetGameVar( "temp.tutorial", 0 );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2_1", nil );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2_2", nil );
	Trigger( OBJECT_TOUCH_TRIGGER, "t3_1", nil );
	Trigger( OBJECT_TOUCH_TRIGGER, "t3_2", nil );
	--Trigger( OBJECT_TOUCH_TRIGGER, "t3_3", nil );
	Trigger( OBJECT_TOUCH_TRIGGER, "t3_4", nil );
end;

COMBAT = 9999;
THREAD = 9998;

TutorialTriggers = {
	{ "c1_m5_t2", REGION_ENTER_AND_STOP_TRIGGER, "t2", "Hint_Obelisk2", 0 },
	{ "c1_m5_t2", REGION_ENTER_AND_STOP_TRIGGER, "t2_1", "Hint_Obelisk2", 0 },
	{ "c1_m5_t2", REGION_ENTER_AND_STOP_TRIGGER, "t2_2", "Hint_Obelisk2", 0 },
	{ "c1_m5_t3", OBJECT_TOUCH_TRIGGER, "t3_1", "Hint_Dig3", 0 },
	{ "c1_m5_t3", OBJECT_TOUCH_TRIGGER, "t3_2", "Hint_Dig3", 0 },
	{ "c1_m5_t3", OBJECT_TOUCH_TRIGGER, "t3_4", "Hint_Dig3", 0 },
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

function ResetScript()
	while GetGameVar("temp.C1M5_firstcombat" ) == '1' do
		sleep( 5 );
	end;
	ResetHeroCombatScript( 'Godric' );
end;

function H55_TriggerDaily()
	if GetDate(DAY) == 8 then
		if bIsabellSpawned == 0 then
			SetObjectiveState( 'prim1', OBJECTIVE_FAILED );
			Loose();
		end;
	end;
end;

function UpdateDifficulty()
	GiveExp( 'Jazaz', 50000 + crap * 35000 );
	GiveExp( 'Efion', 50000 + crap * 35000 );
	GiveExp( 'Nymus', 50000 + crap * 35000 );
end;
--------------------------------------------------------------------------------

SetGameVar("temp.C1M5_firstcombat", 1 );
--EnableHeroAI("Agrael", nil);
--SetObjectOwner("Dummar", PLAYER_NONE);
UpdateDifficulty();
DeployReserveHero( 'Agrael', 120, 55, 0 );

SetRegionBlocked( 'AIblock', 1, PLAYER_2 );
for i = 1, 3 do
	SetRegionBlocked( 'grail_block'..i, 1, PLAYER_2 );
end;
SetPlayerStartResource(PLAYER_1,WOOD,10);
SetPlayerStartResource(PLAYER_1,ORE,10);
SetPlayerStartResource(PLAYER_1,GEM,5);
SetPlayerStartResource(PLAYER_1,CRYSTAL,5);
SetPlayerStartResource(PLAYER_1,MERCURY,5);
SetPlayerStartResource(PLAYER_1,SULFUR,5);
SetPlayerStartResource( PLAYER_1, GOLD, 7000 - crap * 2000 );

messages( 1 );
sleep( 2 );

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "PlayerLostHero" );
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "AgraelDefeated" );
Trigger( OBJECT_TOUCH_TRIGGER, "Prison", "IsabellRescued" );
Trigger( OBJECT_CAPTURE_TRIGGER, "Dummar", "TownCaptured" );
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, 'CheckObj1date' );

--startThread(ChangePlayerForDummar);
startThread( Graal );
startThread( ResetScript );

SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );
OpenCircleFog( 26, 109, 0, 7, PLAYER_1 );
startThread( CheckTutorialTriggers );
SetGameVar( "temp.tutorial", 1 );

-- tutorial related --
if IsTutorial == 1 then
	--EnableTutorial();
end;
--startThread( CheckTutorial );