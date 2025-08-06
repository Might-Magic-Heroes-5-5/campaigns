H55_PlayerStatus = {0,1,2,2,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_DRAGON_SCALE_ARMOR,
ARTIFACT_DRAGON_SCALE_SHIELD,
ARTIFACT_DRAGON_BONE_GRAVES,
ARTIFACT_DRAGON_WING_MANTLE,
ARTIFACT_DRAGON_TEETH_NECKLACE,
ARTIFACT_DRAGON_TALON_CROWN,
ARTIFACT_DRAGON_EYE_RING,
ARTIFACT_DRAGON_FLAME_TONGUE

};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C3M2");
	LoadHeroAllSetArtifacts( "Shadwyn" , "A1C3M1" );
end;

startThread(H55_InitSetArtifacts);

StartAdvMapDialog( 0 );
------------A1C3M2---------------
SetPlayerResource(1, 0, 0);
SetPlayerResource(1, 1, 0);
SetPlayerResource(1, 2, 0);
SetPlayerResource(1, 3, 0);
SetPlayerResource(1, 4, 0);
SetPlayerResource(1, 5, 0);
SetPlayerResource(1, 6, 500);

-----------------------------------------
function Diff_level()
	slozhnost = GetDifficulty(); 
	if slozhnost == DIFFICULTY_EASY then
		AddHeroCreatures("Shadwyn", CREATURE_BLACK_DRAGON, 1);
		RemoveObject("Skelet");
		sleep(10);
		CreateArtifact("Sword", ARTIFACT_SWORD_OF_RUINS, 129, 14, 0);
	elseif slozhnost == DIFFICULTY_NORMAL then
		AddObjectCreatures("R_01", CREATURE_SCOUT, 1);
		RemoveObject("k1");
		RemoveObject("k2");
		RemoveObject("k3");
	elseif slozhnost == DIFFICULTY_HARD then
		AddObjectCreatures("R_01", CREATURE_SCOUT, 15);
		AddObjectCreatures("R_02", CREATURE_ASSASSIN, 15);
		AddObjectCreatures("R_02", CREATURE_RAVAGER, 5);
		AddObjectCreatures("R_03", CREATURE_ASSASSIN, 30);
		AddObjectCreatures("R_03", CREATURE_MINOTAUR_KING, 20);
		RemoveObject("k1");
		RemoveObject("k2");
		RemoveObject("k3");
	elseif slozhnost == DIFFICULTY_HEROIC then
		AddObjectCreatures("R_01", CREATURE_SCOUT, 20);
		AddObjectCreatures("R_02", CREATURE_ASSASSIN, 30);
		AddObjectCreatures("R_02", CREATURE_RAVAGER, 15);
		AddObjectCreatures("R_03", CREATURE_ASSASSIN, 45);
		AddObjectCreatures("R_03", CREATURE_MINOTAUR_KING, 45);
		RemoveObject("k1");
		RemoveObject("k2");
		RemoveObject("k3");	
	end;
	print('difficulty = ',slozhnost);
end;
--------------------------------------------
--GiveExp( "Shadwyn", 22000 ); ---addexp!!!

heroname = "Shadwyn"
--ENEMY_HERO_NAME = "Eruina"
;
SetObjectiveState('prim1',OBJECTIVE_ACTIVE);
SetObjectiveState('prim2',OBJECTIVE_ACTIVE);


--SetRegionBlocked("R1", 1, PLAYER_2);
--SetRegionBlocked("R2", 1, PLAYER_2);
--SetRegionBlocked("R3", 1, PLAYER_2);

---------------------------------Победа и поражение
function Objective1_defead()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Shadwyn") == nil then
			SetObjectiveState('prim1',OBJECTIVE_FAILED);
			sleep(20);
			Loose();
			break;
		end;
	end;
end;

function Winner()
	while 1 do
		sleep(10);
		if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3") == OBJECTIVE_COMPLETED and GetObjectiveState("prim4") == OBJECTIVE_COMPLETED then
			SaveHeroAllSetArtifactsEquipped("Shadwyn", "A1C3M2");
			sleep(30);
			StartDialogScene("/DialogScenes/A1C3/M2/S1/DialogScene.xdb#xpointer(/DialogScene)"); ----//Финальная сцена
			SetObjectiveState('prim1',OBJECTIVE_COMPLETED);
			sleep(10);
			Win();
			break;
		end;
	end;
end;
---------------------------------------------------------------------------------
--------------------------------------------------------Появление вражеских героев
function H55_TriggerDaily()
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 2 ) and (GetDate(DAY_OF_WEEK) == 7 ) then 
		MessageBox ("Maps/Scenario/A1C3M2/mes1.txt"); ---предупреждение1
		sleep(10); 
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 3 ) and (GetDate(DAY_OF_WEEK) == 1 ) then 
		DeployReserveHero( "Eruina", 121, 6, GROUND ); -- деплоим 1 героя
		GiveExp( "Eruina", 10000 ); ---addexp!!!
		sleep(10);
		H55_NewDayTrigger = 0;
		H55_ThrNewDayTrigger = 0;
		H55_SecNewDayTrigger = 1;
		--Trigger( NEW_DAY_TRIGGER, "Stop_one",nil );
--		startThread( Stop_one );  
	end;
	if ( GetDate(MONTH) == 2 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 7 ) then 
		MessageBox ("Maps/Scenario/A1C3M2/mes1.txt"); ---предупреждение2
		OpenCircleFog( 122, 128, 0, 6, PLAYER_1 ); ---фог у выхода с карты
		sleep(10); 
	end;
	if ( GetDate(MONTH) == 2 ) and ( GetDate(WEEK) == 2 ) and (GetDate(DAY_OF_WEEK) == 1 ) then 
		DeployReserveHero( "Ohtar", 123, 130, GROUND ); -- деплоим 2 героя
		OpenCircleFog( 123, 130, 0, 6, PLAYER_1 ); ---фог 
		GiveExp( "Ohtar", 15000 ); ---addexp!!!
		sleep(10);
		H55_NewDayTrigger = 0;
		H55_SecNewDayTrigger = 0;
		H55_ThrNewDayTrigger = 1;
		--Trigger( NEW_DAY_TRIGGER, "Stop_two",nil );
--		startThread( Stop_two );    
	end;
	if ( GetDate(MONTH) == 3 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 7 ) then 
		MessageBox ("Maps/Scenario/A1C3M2/mes1.txt"); ---предупреждение3
		OpenCircleFog( 13, 8, 0, 6, PLAYER_1 ); ---фог у выхода с карты
		sleep(10); 
	end;
	if ( GetDate(MONTH) == 3 ) and ( GetDate(WEEK) == 2 ) and (GetDate(DAY_OF_WEEK) == 1 ) then 
		DeployReserveHero( "Ferigl", 13, 6, GROUND ); -- деплоим 3 героя
		OpenCircleFog( 13, 6, 0, 6, PLAYER_1 ); ---фог
		GiveExp( "Ferigl", 20000 ); ---addexp!!!
		sleep(10); 
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 3 ) and ( random( 2 ) == 1 ) then  ---!!!
		QuestionBox("Maps/Scenario/A1C3M2/d1.txt", "s_2");
		sleep(10); 
	end;
end;
----------------------------Бантик!
function s_2() 
	if ( random( 2 ) == 1 ) then
		MessageBox ("Maps/Scenario/A1C3M2/d2.txt");
		SetPlayerResource(PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) + 500);
	else
		MessageBox ("Maps/Scenario/A1C3M2/d3.txt");
	end
	sleep(20); 
end

----------------------------Герои через несколько дней идут к воротам и там стоят

function H55_SecTriggerDaily()
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 3 ) and (GetDate(DAY_OF_WEEK) == 7 ) and IsHeroAlive ("Eruina") == not nil then 
		--EnableHeroAI("Eruina",nil); --H55 fix
		MoveHero( "Eruina", 105, 59, 0 )  
		sleep(10);
		H55_SecNewDayTrigger = 0;
		H55_ThrNewDayTrigger = 0;
		H55_NewDayTrigger = 1;
		--Trigger( NEW_DAY_TRIGGER, "Enemy",nil ); 
	end;
end;

function H55_ThrNewDayTrigger()
	if ( GetDate(MONTH) == 2 ) and ( GetDate(WEEK) == 2 ) and (GetDate(DAY_OF_WEEK) == 7 ) and IsHeroAlive("Ohtar") == not nil then 
		--EnableHeroAI("Ohtar",nil); --H55 fix
		MoveHero( "Ohtar", 61, 76, 0 ) 
		sleep(10);
		H55_SecNewDayTrigger = 0;
		H55_ThrNewDayTrigger = 0;
		H55_NewDayTrigger = 1;
		--Trigger( NEW_DAY_TRIGGER, "Enemy",nil );   
	end;
end;

----------------------------------------------преследование1_тест 
function EngageHero1( heroname )
	ENEMY_HERO_NAME = "Eruina";
	while IsHeroAlive( ENEMY_HERO_NAME ) and GetObjectOwner("R_01") ~= PLAYER_1 do
			while GetCurrentPlayer() ~= PLAYER_2 and GetObjectOwner("R_01") ~= PLAYER_1 do
			sleep( 5 );
		end;
		MoveHero( ENEMY_HERO_NAME, GetObjectPosition( heroname ) );
--		EnableHeroAI("Eruina",not nil);  ------!!!
			while GetCurrentPlayer() ~= PLAYER_1 do
			sleep( 5 );
		end;
	end;
end;
------------------------------------------------Ворота и обжективы
function Gate1()
	while 1 do
		sleep( 10 );
		if (GetObjectOwner("R_01") == PLAYER_1) then
			print("Garrison1_captured.................");
			sleep(3);
--			ShowFlyingSign("Maps/Scenario/A1C3M2/sp1.txt", "Shadwyn", -1, 3.0); --!!!
			SetObjectiveState('prim2',OBJECTIVE_COMPLETED);
			SetRegionBlocked("R1", 1, PLAYER_2);
			SetRegionBlocked("R1_1", 1, PLAYER_1);
			print("Regions_1_blocked.................");
			sleep(30);
			SetObjectiveState('prim3',OBJECTIVE_ACTIVE);
			break;
		end;
	end;
end;

function Gate2()
	while 1 do
		sleep( 10 );
		if GetObjectOwner("R_02") == PLAYER_1 then
			print("Garrison2_captured................."); 
			sleep(3);
--			ShowFlyingSign("Maps/Scenario/A1C3M2/sp1.txt", "Shadwyn", -1, 3.0); --!!!
			SetObjectiveState('prim3',OBJECTIVE_COMPLETED);
			SetRegionBlocked("R2", 1, PLAYER_2);
			SetRegionBlocked("R2_2", 1, PLAYER_1);
			print("Regions_2_blocked.................");
			sleep(30);
			SetObjectiveState('prim4',OBJECTIVE_ACTIVE);
			break;
		end;
	end;
end;

function Gate3()
	while 1 do
		sleep( 10 );
		if GetObjectOwner("R_03") == PLAYER_1 then
			print("Garrison3_captured................."); 
			sleep(3);
--			ShowFlyingSign("Maps/Scenario/A1C3M2/sp1.txt", "Shadwyn", -1, 3.0); --!!!
			SetObjectiveState('prim4',OBJECTIVE_COMPLETED);
			SetRegionBlocked("R3", 1, PLAYER_2);
			SetRegionBlocked("R3_3", 1, PLAYER_1);
			print("Regions_3_blocked.................");
			break;
		end;
	end;
end;

---------------------------------Всякая фигня 


Trigger( REGION_ENTER_AND_STOP_TRIGGER, "zone","Spec_1");

function Spec_1( heroname )
	HN = heroname;
	SetObjectPosition( HN, 9, 67, 0 );
	sleep(2);
	QuestionBox("Maps/Scenario/A1C3M2/sp_mess1.txt", "f_2");	
end;

function f_2() 
	StartCombat(HN,nil,4,CREATURE_MUMMY,3,CREATURE_MUMMY,2,CREATURE_MUMMY,3,CREATURE_MUMMY,2,nil);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "zone",nil);
end;

-------------------------------///////////////MAIN 

H55_CamFixTooManySkills(PLAYER_1,"Shadwyn");
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "Enemy",nil );
--Trigger( NEW_DAY_TRIGGER, "Enemy_stop",nil );

startThread( Objective1_defead );
startThread( Winner );
startThread( Gate1 );
startThread( Gate2 );
startThread( Gate3 );
startThread( Diff_level );