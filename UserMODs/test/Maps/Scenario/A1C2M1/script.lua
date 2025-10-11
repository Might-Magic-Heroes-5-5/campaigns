H55_PlayerStatus = {0,1,2,2,2,2,2,2};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C2M1");
end;

startThread(H55_InitSetArtifacts);

sleep(10);
--Save("autosave");
StartDialogScene("/DialogScenes/A1C2/M1/S1/DialogScene.xdb#xpointer(/DialogScene)", "", "autosave"); ----//TEST!


--SetPlayerResource(1, 0, 10);
--SetPlayerResource(1, 1, 10);
--SetPlayerResource(1, 2, 0);
--SetPlayerResource(1, 3, 0);
--SetPlayerResource(1, 4, 0);
--SetPlayerResource(1, 5, 0);
--SetPlayerResource(1, 6, 10000);
---------------------------------Сложность
function Diff_level()
	slozhnost = GetDifficulty(); 
	if slozhnost == DIFFICULTY_EASY then
		AddHeroCreatures("Wulfstan", CREATURE_DEFENDER, 10);
		--AddHeroCreatures("Wulfstan", CREATURE_AXE_FIGHTER, 10);
		print("DIFFICULTY_EASY//////////////");	 
	elseif slozhnost == DIFFICULTY_NORMAL then
		AddHeroCreatures("Wulfstan", CREATURE_DEFENDER, 10);
		print("DIFFICULTY_NORMAL//////////////");
	end;
	print('difficulty = ',slozhnost);
end;

---------------------------------Атаки на города

function Random_castles1()
	if (GetObjectOwner("town2") ~= PLAYER_1) then
		if ( random( 2 ) == 1 ) then
			MoveHero( "Orrin", 17, 77, 0 )    
		else
			MoveHero( "Orrin", 86, 78, 0 )
		end
	else  
		MoveHero( "Orrin", 53, 53, 0 ) 
	end
	sleep(1)
end;

function Random_castles2()
	if (GetObjectOwner("town3") ~= PLAYER_1) then
		if ( random( 2 ) == 1 ) then
			MoveHero( "Sarge", 17, 77, 0 )    
		else
			MoveHero( "Sarge", 53, 53, 0 )
		end
	else  
		MoveHero( "Sarge", 86, 78, 0 ) 
	end
	sleep(1)
end;


----------------------------------Собираем кричей
function Objective2()
	while 1 do
		sleep( 2 );
		if  GetHeroCreatures( "Wulfstan", CREATURE_STOUT_DEFENDER ) >= 300 then
			SaveHeroAllSetArtifactsEquipped("Wulfstan", "A1C2M1");
			SetObjectiveState( "prim2", OBJECTIVE_COMPLETED );
			sleep( 2 );
			Win(); 
			break;
		end;
	end;
end;
---------------------------------Герой погиб
function Objective3_defead()  
	while 1 do
		sleep(10);
		if IsHeroAlive("Wulfstan") == nil then
			SetObjectiveState('prim3',OBJECTIVE_FAILED);
			sleep(20);
			Loose();
			break;
		end;
	end;
end;

--------------------------------Проверка городов на поражение
function Loose_towns()
	while 1 do
		if (GetObjectOwner("town1") == PLAYER_2) and (GetObjectOwner("town2") == PLAYER_2) then
			sleep(10);
			Loose();
			return
		end;
		if (GetObjectOwner("town1") == PLAYER_2) and (GetObjectOwner("town3") == PLAYER_2) then
			sleep(10);
			Loose();
			return
		end;
		if (GetObjectOwner("town2") == PLAYER_2) and (GetObjectOwner("town3") == PLAYER_2) then
			sleep(10);
			Loose();
			return
		end;
		sleep();
	end;
end;
--------------------------------Вызываем героев противника
function H55_TriggerDaily()
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 2 ) and (GetDate(DAY_OF_WEEK) == 2 ) then 
		DeployReserveHero( "Christian", 86, 3, GROUND ); -- деплоим 1 героя
		sleep(10);
		--EnableHeroAI("Christian",nil); --H55 fix
		MoveHero( "Christian", 53, 53, 0 )   
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 3 ) and (GetDate(DAY_OF_WEEK) == 1 ) then 
		DeployReserveHero( "Maeve", 34, 7, GROUND ); -- деплоим 1 героя аи для захвата шахт!!!
		GiveExp( "Maeve", 3000 ); ---addexp!!!
		sleep(10);
		SetAIPlayerAttractor('C1', PLAYER_2, 1);
		SetAIPlayerAttractor('C2', PLAYER_2, 1);
		SetAIPlayerAttractor('C3', PLAYER_2, 1);  
	end;
	if ( GetDate(MONTH) == 1 ) and ( GetDate(WEEK) == 4 ) and (GetDate(DAY_OF_WEEK) == 1 ) then 
		DeployReserveHero( "Orrin", 86, 3, GROUND ); -- деплоим 2 героя
		GiveExp( "Orrin", 6000 ); ---addexp!!!
		sleep(10);
		--EnableHeroAI("Orrin",nil); --H55 fix
		startThread( Random_castles1 ); 
	end;
	if ( GetDate(MONTH) == 2 ) and ( GetDate(WEEK) == 1 ) and (GetDate(DAY_OF_WEEK) == 3 ) then 
		DeployReserveHero( "Brem", 4, 20, GROUND ); -- деплоим 2 героя аи для захвата шахт!!!
		GiveExp( "Brem", 9000 ); ---addexp!!!
		sleep(10);
		SetAIPlayerAttractor('C1', PLAYER_2, 1);
		SetAIPlayerAttractor('C2', PLAYER_2, 1);
		SetAIPlayerAttractor('C3', PLAYER_2, 1);  
	end;
	if ( GetDate(MONTH) == 2 ) and ( GetDate(WEEK) == 3 ) and (GetDate(DAY_OF_WEEK) == 2 ) then 
		DeployReserveHero( "Sarge", 34, 7, GROUND ); -- деплоим 3 героя
		GiveExp( "Sarge", 15000 ); ---addexp!!!
		sleep(10);
		--EnableHeroAI("Sarge",nil); --H55 fix
		startThread( Random_castles2 ); 
	end;
	if ( GetDate(MONTH) == 3 ) and ( GetDate(WEEK) == 2 ) and (GetDate(DAY_OF_WEEK) == 5 ) then 
		DeployReserveHero( "Ving", 86, 3, GROUND ); -- деплоим 3 героя аи для захвата шахт!!!
		GiveExp( "Ving", 25000 ); ---addexp!!!
	end;
end;

-------------------------------//Учебное задание
function Objective4_sec()  
	while 1 do
		sleep(10);
		if GetTownBuildingLevel('town1', TOWN_BUILDING_FORTRESS_RUNIC_SHRINE) == 1 or GetTownBuildingLevel('town2', TOWN_BUILDING_FORTRESS_RUNIC_SHRINE) == 1 or GetTownBuildingLevel('town3', TOWN_BUILDING_FORTRESS_RUNIC_SHRINE) == 1 then
			sleep(10);
			SetObjectiveState('sec1',OBJECTIVE_COMPLETED);
			sleep(5);
			break;
		end;
	end;
end;

-------------------------------//////MAIN
GiveHeroSkill("Wulfstan",HERO_SKILL_RUNELORE);

startThread( Diff_level );
startThread( Objective2 );
startThread( Objective3_defead );

startThread( Loose_towns );

H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "Enemy",nil );

startThread( Objective4_sec );