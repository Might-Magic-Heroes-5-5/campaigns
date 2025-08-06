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

--========================== RED HAVEN HEROES RESPAWN SCRIPT ===========================================
--###################################### BEGIN #########################################################
--CONSTANTS
--Must be filled for each map

RH_RespawnPoints_XYZ_Town = { {62, 10, GROUND, "Castlegate"}, {128, 45, GROUND, "Chillbury"} };
-- {X, Y, FLOOR, RESPAWN TOWN Script name (if needed, if not must be a nil)}
	

RH_heroes = { "RedHeavenHero01", "RedHeavenHero02"}; -- Pool of Red Haven heroes
	
AI_PLAYER = PLAYER_3; -- AI player side
RH_heroes_must_alive_count = 2; -- Minimum of AI Red Haven heroes who might be at same time on the map
 
--=======================================================================
DeployReserveHero( "RedHeavenHero01", 128, 45, GROUND );

RH_RespawnPoints_XYZ_Town.n = table.length( RH_RespawnPoints_XYZ_Town );
RH_heroes.n = table.length( RH_heroes );

RH_TownsTotal = 0;
for i=1, RH_RespawnPoints_XYZ_Town.n do
	if RH_RespawnPoints_XYZ_Town[i][4] ~= nil then
		EnableAIHeroHiring(AI_PLAYER, RH_RespawnPoints_XYZ_Town[i][4], nil);
		RH_TownsTotal = RH_TownsTotal + 1;
		print("AI hero hiring was disabled at town ", RH_RespawnPoints_XYZ_Town[i][4]);
	end;
end;
print("AI has ",RH_TownsTotal," towns for respawn");

function RH_Respawn()
	print( "Function RH_respawn has started...");
	while 1 do
		sleep(5);
		while GetCurrentPlayer() ~= AI_PLAYER do
			sleep(10);
		end;
		print("RH_Respawn: AI player's turn");
		RH_dead_heroes = 0;
		for i=1, RH_heroes.n do
			if IsHeroAlive( RH_heroes[i] ) == nil then
				print("RH_Respawn: AI hero ", RH_heroes[i]," is dead.");
				RH_dead_heroes = RH_dead_heroes + 1;	
				if RH_heroes.n - RH_dead_heroes < RH_heroes_must_alive_count then
					print("Count of AI RH heroes less than needed (",RH_heroes_must_alive_count,"). Hero ",RH_heroes[i]," must be placed.");
					lostRespawmTowns = 0;
					for j=1, RH_RespawnPoints_XYZ_Town.n do
						if IsObjectExists ( RH_RespawnPoints_XYZ_Town[j][4] )==not nil then
							if GetObjectOwner( RH_RespawnPoints_XYZ_Town[j][4] )==AI_PLAYER then
								print("AI has Respawn point ", j," and town ", RH_RespawnPoints_XYZ_Town[j][4]);
								DeployReserveHero( RH_heroes[i], RH_RespawnPoints_XYZ_Town[j][1], RH_RespawnPoints_XYZ_Town[j][2], RH_RespawnPoints_XYZ_Town[j][3] );
								startThread( transformTroops, RH_heroes[i] );
								break;
							else
								lostRespawmTowns = lostRespawmTowns + 1;
							end;
						else
							print("Respawn point without town. Trying to deploy hero ", RH_heroes[i]);
							DeployReserveHero( RH_heroes[i], RH_RespawnPoints_XYZ_Town[j][1], RH_RespawnPoints_XYZ_Town[j][2], RH_RespawnPoints_XYZ_Town[j][3] );
							startThread( transformTroops, RH_heroes[i] );
						end;
					end;
					if lostRespawmTowns == RH_RespawnPoints_XYZ_Town.n then print("RH_Respawn: AI doen't have any towns for respawn"); end;
				else
					print("Hero can't be deployed");
				end;		
			end;
			if RH_dead_heroes == 0 then print("All AI heroes are alive."); end;
		end;
		while GetCurrentPlayer() == AI_PLAYER do
			sleep(10);
		end;
		print("RH_Respawn: AI player's turn has ended");
	end;
end;

function transformTroops( heroName )
	sleep(3);
	print("function transformTroops for hero ", heroName ," has started...");
	while IsHeroAlive ( heroName ) == not nil do
		for i=1,14 do
			creaturesCount = GetHeroCreatures( heroName, i );
			if creaturesCount  > 0 then
				RemoveHeroCreatures( heroName, i, 10000);
				n = i;
				if mod(i,2) ~= 0 then n = i + 1; end;
				AddHeroCreatures( heroName, 105 + (n/2), creaturesCount );
			end;
		end;
		sleep(2);
	end;
	print("Hero ", heroName, " is dead. Function transformTroops terminated");
end;

 

startThread(RH_Respawn);
--====================================================================================================
--###################################### END #########################################################



--==================================== MAIN SCRIPT BODY ==============================================
StartAdvMapDialog( 0 );
print("Start_A1C1M5.................");
sleep( 3 );
SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
SetTownBuildingLimitLevel("Castlegate", TOWN_BUILDING_SHIPYARD, 0);

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
sleep(3);
GiveExp( "Sarge", 150000 ); ---addexp
GiveExp( "Duncan", 160000 ); ---addexp
GiveExp( "Brem", 160000 ); ---addexp
GiveExp( "RedHeavenHero01", 200000 ); ---addexp

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
	EnableHeroAI("Sarge", not nil);
	ChangeHeroStat( "Sarge", STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( "Sarge", 43, 118, 0 );
	sleep(20);
	UnblockGame();
	sleep(10);
	OpenCircleFog( 34, 26, 0, 4, PLAYER_1 ); ---фог c Дункана
	MoveCamera(34, 26, 0, 50, 1);
	sleep(20);
	MoveCamera(43, 114, 0, 50, 1);	
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Exit_1",nil);
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
		if (GetObjectOwner("Castlegate") == PLAYER_1) then
--		if (GetObjectOwner("Castlegate") == PLAYER_1) and IsObjectInRegion("Freyda", "Final") then
			sleep( 3 );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Final","Sail", nil );
--			SetObjectiveState('prim3',OBJECTIVE_COMPLETED);
--			sleep( 4 );
--			startThread(AIAction3);
			break;
		end;
	end;
end;
--------------------###################
FREYDA = "Freyda"

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Final","Sail", nil );

function Sail( heroname )
	if heroname == FREYDA then
		SetObjectiveState('prim3',OBJECTIVE_COMPLETED);
		sleep(4);
		startThread(AIAction3);
	end;
end;

-----------------------------------Финальная потасовка на море

function AIAction3()
	heroname = "Freyda"
	BlockGame();
	sleep(5);
	DeployReserveHero( "Ving", 75, 4, GROUND );
	sleep(3);
	EnableHeroAI("Ving", not nil);
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

-------------------------//////Main
startThread(Start_reg);
startThread(Diff_level);
startThread(PObjective4_defead);
startThread(Exit_zone_open);
startThread( transformTroops, "RedHeavenHero01" );