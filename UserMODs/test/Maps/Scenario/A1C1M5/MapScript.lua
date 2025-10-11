H55_PlayerStatus = {0,1,1,2,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
ARTIFACT_DWARVEN_MITHRAL_GREAVES,
ARTIFACT_DWARVEN_MITHRAL_HELMET,
ARTIFACT_DWARVEN_MITHRAL_SHIELD

};

H55_CamFixTooManySkills(PLAYER_1,"Freyda");

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C1M5");
	LoadHeroAllSetArtifacts( "Freyda" , "A1C1M4" );
end;

startThread(H55_InitSetArtifacts);

------------------------------------------BlockRegions
function Start_reg()
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 2 ) and (GetDate(DAY_OF_WEEK) == 1 ) then
		SetRegionBlocked("Ally1", nil, PLAYER_3); 
		SetRegionBlocked("Ally2", nil, PLAYER_3); 
		SetRegionBlocked("Ally3", nil, PLAYER_3);
		SetRegionBlocked("Ally4", nil, PLAYER_2);
		print("REG_INBL!!!!!!!!!!!!!1");	 
	end;
end;
------------------------------------------Diff
function Diff_level()
	slozhnost = GetDifficulty(); 
	if slozhnost == DIFFICULTY_NORMAL then
		AddObjectCreatures("Dgar", CREATURE_SERAPH, 2);
		AddObjectCreatures("Dgar", CREATURE_LONGBOWMAN, 30);
		AddObjectCreatures("Dgar", CREATURE_VINDICATOR, 20);
		AddObjectCreatures("Dgar", CREATURE_ZEALOT, 10);
		RemoveHeroCreatures("Freyda", CREATURE_ROYAL_GRIFFIN, 1);
	elseif slozhnost == DIFFICULTY_HARD then
		AddObjectCreatures("Dgar", CREATURE_SERAPH, 5);
		AddObjectCreatures("Dgar", CREATURE_LONGBOWMAN, 60);
		AddObjectCreatures("Dgar", CREATURE_VINDICATOR, 45);
		AddObjectCreatures("Dgar", CREATURE_ZEALOT, 35);
		RemoveHeroCreatures("Freyda", CREATURE_ROYAL_GRIFFIN, 4);
		RemoveHeroCreatures("Freyda", CREATURE_MARKSMAN, 5);
	elseif slozhnost == DIFFICULTY_HEROIC then
		AddObjectCreatures("Dgar", CREATURE_SERAPH, 8);
		AddObjectCreatures("Dgar", CREATURE_LONGBOWMAN, 90);
		AddObjectCreatures("Dgar", CREATURE_VINDICATOR, 75);
		AddObjectCreatures("Dgar", CREATURE_ZEALOT, 65);
		RemoveHeroCreatures("Freyda", CREATURE_ROYAL_GRIFFIN, 7);
		RemoveHeroCreatures("Freyda", CREATURE_MARKSMAN, 10);	
	end;
	print('difficulty = ',slozhnost);
end;

------------------------------------------Левеляем аи героев

GiveExp( "Sarge", 150000 ); ---addexp
GiveExp( "Duncan", 160000 ); ---addexp
GiveExp( "Brem", 160000 ); ---addexp
GiveExp( "Christian", 200000 ); ---addexp

------------------------------------------

SetObjectiveState('prim4',OBJECTIVE_ACTIVE);

EnableHeroAI("Sarge", nil);
EnableHeroAI("Duncan", nil);

------------------------------Блокируем регионы


SetRegionBlocked("deads", 1, PLAYER_2); 
SetRegionBlocked("deads", 1, PLAYER_3); 

SetRegionBlocked("Ally1", 1, PLAYER_3); 
SetRegionBlocked("Ally2", 1, PLAYER_3); 
SetRegionBlocked("Ally3", 1, PLAYER_3);
SetRegionBlocked("Ally4", 1, PLAYER_2);

SetRegionBlocked("Border1", 1, PLAYER_2); 
SetRegionBlocked("Border2", 1, PLAYER_2);

SetRegionBlocked("Prison", 1, PLAYER_2); 
SetRegionBlocked("Prison", 1, PLAYER_3); 

SetRegionBlocked("Tr1", 1, PLAYER_2); 
SetRegionBlocked("Tr2", 1, PLAYER_2); 

SetRegionBlocked("Tr1", 1, PLAYER_3); 
SetRegionBlocked("Tr2", 1, PLAYER_3); 

SetRegionBlocked("spec", 1, PLAYER_3);

SetRegionBlocked("stop1", 1, PLAYER_2);
SetRegionBlocked("stop1", 1, PLAYER_3);

SetRegionBlocked("AI_stop", 1, PLAYER_2);
SetRegionBlocked("AI_stop", 1, PLAYER_3);

------------------------------Открываем вход в подземелье
function Exit_zone_open()
	if (GetObjectOwner("Cradl") == PLAYER_1) then
		sleep( 5 );
		SetRegionBlocked("Enter_1", nil, PLAYER_1);
	end;
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Enter_1","Warningmess" );

function Warningmess ( heroname )
	if IsObjectInRegion ("Freyda", "Enter_1") == not nil and GetObjectOwner("Cradl") ~= PLAYER_1 then
		sleep( );
		HN = heroname;
		PlayVisualEffect( "/Effects/_(Effect)/Spells/FrostRing.xdb#xpointer(/Effect)", "enter", "enter1", 0, 0, 0, 0, 0 );
		SetObjectPosition( HN, 49, 165, 0 );
		sleep( 20 );
		MessageBox ("Maps/Scenario/A1C1M5/mess1.txt");
	end;
end;

--------------------------------------Встреча с повстанцами.

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Exit_1","AIAction", nil );

function AIAction()
	BlockGame();
	sleep(15);
	EnableHeroAI("Sarge", not nil); --H55 fix
	ChangeHeroStat( "Sarge", STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( "Sarge", 43, 118, 0 );
	sleep(20);
	UnblockGame();
	sleep(20);
	sleep(10);
	OpenCircleFog( 34, 26, 0, 4, PLAYER_1 ); ---фог c Дункана
end;
-------------------------------------Освобождаем Дункана

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Dun","AIAction_2", nil );

function AIAction_2() 
	SetObjectOwner ("Duncan", PLAYER_1);
	PlayVisualEffect( "/Effects/_(Effect)/Spells/Heal.xdb#xpointer(/Effect)", "Duncan", "Duncan1", 0, 0, 0, 0, 0 );	
	sleep(5);
	SetObjectiveState('prim2',OBJECTIVE_COMPLETED);
	sleep(5);
	SetObjectiveState('prim3',OBJECTIVE_ACTIVE);
	SetObjectiveState('prim5',OBJECTIVE_ACTIVE);
	startThread(PObjective3);
	sleep(10);
	StartDialogScene("/DialogScenes/A1C1/M5/S1/DialogScene.xdb#xpointer(/DialogScene)"); ----//Первая сцена
	startThread(PObjective5_defead);
	startThread(ChangeAllOwners);
	SetRegionBlocked("Ally1", nil, PLAYER_3);
	SetTownBuildingLimitLevel("Castlegate", TOWN_BUILDING_SHIPYARD, 1);
end;
--------------------------------Повстанцы переходят к игроку

function ChangeAllOwners()
	mines = GetObjectNamesByType( "BUILDING" );
	dwellings = GetObjectNamesByType( "DWELLING" );
	towns = GetObjectNamesByType( "TOWN" );
	heroes = GetObjectNamesByType( "HERO" );
	
	for i, mine in mines do
		if GetObjectOwner( mine ) == PLAYER_2 then
			SetObjectOwner( mine, PLAYER_1 );
		end;
	end;
	for i, mine in dwellings do
		if GetObjectOwner( mine ) == PLAYER_2 then
			SetObjectOwner( mine, PLAYER_1 );
		end;
	end;
	for i, mine in towns do
		if GetObjectOwner( mine ) == PLAYER_2 then
			SetObjectOwner( mine, PLAYER_1 );
		end;
	end;
	for i, mine in heroes do
		if GetObjectOwner( mine ) == PLAYER_2 then
			SetObjectOwner( mine, PLAYER_1 );
		end;
	end;
end;

------------------------------------В Город и отплываем
function PObjective3()
	while 1 do	
		sleep( 10 );
		if (GetObjectOwner("Castlegate") == PLAYER_1) and IsObjectInRegion("Freyda", "Final") then
			sleep( 4 );
			SetObjectiveState('prim3',OBJECTIVE_COMPLETED);
			sleep( 4 );
			startThread(AIAction3);
			break;
		end;
	end;
end;
-----------------------------------Финальная потасовка на море

function AIAction3()
	heroname = "Freyda"
	SaveHeroAllSetArtifactsEquipped("Freyda", "A1C1M5");
	BlockGame();
	sleep(5);
	DeployReserveHero( "Ving", 75, 4, GROUND );
	sleep(3);
	--EnableHeroAI("Ving", nil); --H55 fix
	PlayVisualEffect( "/Effects/_(Effect)/Spells/SummonBoat_end.xdb#xpointer(/Effect)", "Ving", "Ving1", 0, 0, 0, 0, 0 );
	sleep(15);	
	ChangeHeroStat( "Freyda", STAT_MOVE_POINTS, -30000 );
	ChangeHeroStat( "Ving", STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( "Ving", GetObjectPosition( heroname )  );
	sleep(30);
	UnblockGame();
	StartDialogScene("/DialogScenes/A1C1/M5/S2/DialogScene.xdb#xpointer(/DialogScene)"); ----//Вторая сцена
	SetObjectiveState('prim4',OBJECTIVE_COMPLETED);
	SetObjectiveState('prim5',OBJECTIVE_COMPLETED);
	sleep(30);
	Win();
end;

----------------------------------Герои погибают

function PObjective4_defead()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Freyda") == nil then
			SetObjectiveState('prim4',OBJECTIVE_FAILED);
			sleep(2);
			Loose();
			break;
		end;
	end;
end;

function PObjective5_defead()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Duncan") == nil then
			SetObjectiveState('prim5',OBJECTIVE_FAILED);
			sleep(2);
			Loose();
			break;
		end;
	end;
end;
---------------------------------add_fant

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "s1","Spec_1");

function Spec_1( heroname )
	HN = heroname;
	SetObjectPosition( HN, 9, 151, 0 );
	sleep(2);
	QuestionBox("Maps/Scenario/A1C1M5/sp_mess1.txt", "f_1");	
end;

function f_1() 
	StartCombat(HN,nil,4,CREATURE_AIR_ELEMENTAL,6,CREATURE_AIR_ELEMENTAL,5,CREATURE_AIR_ELEMENTAL,5,CREATURE_AIR_ELEMENTAL,6,nil);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "s1",nil);
end;

-------------------------H55 fix, moved down
StartAdvMapDialog( 0 );
print("Start_A1C1M5.................");
sleep( 3 );
SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
SetTownBuildingLimitLevel("Castlegate", TOWN_BUILDING_SHIPYARD, 0);
-------------------------//////Main
startThread(Start_reg);
startThread(Diff_level);
startThread(PObjective4_defead);
startThread(Exit_zone_open);