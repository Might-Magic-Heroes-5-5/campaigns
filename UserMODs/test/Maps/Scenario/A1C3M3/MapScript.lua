H55_PlayerStatus = {0,1,1,1,1,2,2,2};

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
	InitAllSetArtifacts("A1C3M3");
	LoadHeroAllSetArtifacts( "Shadwyn" , "A1C3M2" );
end;

startThread(H55_InitSetArtifacts);

--========================== RED HAVEN HEROES RESPAWN SCRIPT ===========================================
--###################################### BEGIN #########################################################
--CONSTANTS
--Must be filled for each map

RH_RespawnPoints_XYZ_Town = { {15, 66, UNDERGROUND, "Haven"} };
-- {X, Y, FLOOR, RESPAWN TOWN Script name (if needed, if not must be a nil)}
	

RH_heroes = { "RedHeavenHero01", "RedHeavenHero02"}; -- Pool of Red Haven heroes
	
AI_PLAYER = PLAYER_5; -- AI player side
RH_heroes_must_alive_count = 2; -- Minimum of AI Red Haven heroes who might be at same time on the map
 
--=======================================================================

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
								break;
							else
								lostRespawmTowns = lostRespawmTowns + 1;
							end;
						else
							print("Respawn point without town. Trying to deploy hero ", RH_heroes[i]);
							DeployReserveHero( RH_heroes[i], RH_RespawnPoints_XYZ_Town[j][1], RH_RespawnPoints_XYZ_Town[j][2], RH_RespawnPoints_XYZ_Town[j][3] );
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

 

startThread(RH_Respawn);
--====================================================================================================
--###################################### END #########################################################


--===================================== MAIN SCRIPT BODY =============================================


StartDialogScene("/DialogScenes/A1C3/M3/S1/DialogScene.xdb#xpointer(/DialogScene)");

training_array = {"training1" , "training2" , "training3" , "training4" , "training5", "training6" , "training7",
					"training8" , "training9" , "training10" , "training11" , "training12" , "training13", "training14"} --- Массив анимационных кричей

---------------------------------------------------------------------
------------------ СТАРТОВЫЕ МАССИВЫ И ПЕРЕМЕННЫЕ -------------------
---------------------------------------------------------------------

PlayerHero = "Shadwyn" --- константа для имени героя игрока

InfernoHero = "Efion" --- константа для имени героя Инферно

RedHavenHero = "RedHeavenHero03" --- константа для имени героя Ред Хевен

DungeonHero = "Almegir" --- константа для имени героя Данжена

FortressHero = "Una" --- константа для имени героя Дварфов

block_array = {"fighting1" , "fighting2" , "fighting3" , "fighting4" , "fighting5" , "fighting6" , "fighting7"} --- Массив блокируемых для АИ регионов

---------------------------------------------------------------------
---------------- МОДИФИКАТОРЫ ОТ УРОВНЯ СЛОЖНОСТИ -------------------
---------------------------------------------------------------------

if GetDifficulty() == DIFFICULTY_EASY then
	diff = 1;
    print ("easy");
---Тело функции
end;

if GetDifficulty() == DIFFICULTY_NORMAL then
	diff = 1;
    print ("normal");
---Тело функции
end;

if GetDifficulty() == DIFFICULTY_HARD then
	diff = 2;
    print ("Hard");
---Тело функции
end;

if GetDifficulty() == DIFFICULTY_HEROIC then
	diff = 3;
    print ("Impossible");
---Тело функции
end;

for a = 1,7 do
	for b = 2,5 do
		SetRegionBlocked(block_array[a], 1, b);
	end;
end;

---------------- Выдача героям АИ стртовых армий -------------------
DeployReserveHero(InfernoHero, RegionToPoint('INF'));
ChangeHeroStat(InfernoHero , STAT_EXPERIENCE , 10000*(4-diff));
AddHeroCreatures(InfernoHero , CREATURE_IMP , (5 + diff)*10);
AddHeroCreatures(InfernoHero , CREATURE_HORNED_DEMON , (5 + diff)*5);
AddHeroCreatures(InfernoHero , CREATURE_CERBERI , (5 + diff)*2);

DeployReserveHero(RedHavenHero, RegionToPoint('RHH'));
ChangeHeroStat(RedHavenHero , STAT_EXPERIENCE , 10000*(4-diff));
AddHeroCreatures(RedHavenHero , 106 , (5 + diff)*10);
AddHeroCreatures(RedHavenHero , 107 , (5 + diff)*5);
AddHeroCreatures(RedHavenHero , 108 , (5 + diff)*2);

DeployReserveHero(DungeonHero, RegionToPoint('DUNG'));
ChangeHeroStat(DungeonHero , STAT_EXPERIENCE , 10000*(4-diff));
AddHeroCreatures(DungeonHero , 72 , (5 + diff)*6);
AddHeroCreatures(DungeonHero , 74 , (5 + diff)*4);
AddHeroCreatures(DungeonHero , 76 , (5 + diff)*2);

DeployReserveHero(FortressHero, RegionToPoint('DWF'));
ChangeHeroStat(FortressHero , STAT_EXPERIENCE , 10000*(4-diff));
AddHeroCreatures(FortressHero , 93 , (5 + diff)*10);
AddHeroCreatures(FortressHero , 95 , (5 + diff)*5);
AddHeroCreatures(FortressHero , 97 , (5 + diff)*2);

---------------------------------------------------------------------
-------------------- ОСНОВНЫЕ ФУНКЦИОНАЛЬНОСТИ ----------------------
---------------------------------------------------------------------
SetObjectiveState("obj2", OBJECTIVE_ACTIVE);

function lostDragon() ---- Проверка потери дракона
	while 1 do
		sleep ( 10 );
		if GetHeroCreatures(PlayerHero, 84) == 0 then
			SetObjectiveState("obj2", OBJECTIVE_FAILED);
			sleep ( 10 );
			Loose();
			break
		end;
	end;
end;

Trigger(REGION_ENTER_AND_STOP_TRIGGER, "finish", "winmission"); --- Условие победы достигнуть региона на карте
function winmission(herowin)
	if herowin == PlayerHero then
		SaveHeroAllSetArtifactsEquipped("Shadwyn", "A1C3M3");
		SetObjectiveState("obj1", OBJECTIVE_COMPLETED);
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "finish",  nil );
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, nil );
		sleep (5);
		SetObjectPosition(PlayerHero, 50, 50, 0);
		sleep (1);
		--		RemoveObject(PlayerHero);
		Save("autosave");
		StartDialogScene("/DialogScenes/A1C3/M3/S2/DialogScene.xdb#xpointer(/DialogScene)");
		Win();
	end;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" ); --- триггер на потерю героя игроком
function LostHero( HeroName )
	if HeroName == PlayerHero then
		SetObjectiveState("obj3", OBJECTIVE_FAILED);
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, nil );
		sleep (15);
		Loose();
	end;
end;

function H55_TriggerDaily() ---- Кричи хавена скриптом заменяются на Красный апгрейд
	if GetObjectCreatures("Haven", 2) > 0 then
		milit = GetObjectCreatures("Haven", 2)
		RemoveObjectCreatures("Haven", 2, milit);
		AddObjectCreatures("Haven", 106, milit);
	end;
	if GetObjectCreatures("Haven", 4) > 0 then
		footm = GetObjectCreatures("Haven", 4)
		RemoveObjectCreatures("Haven", 4, footm);
		AddObjectCreatures("Haven", 107, footm);
	end;
	if GetObjectCreatures("Haven", 6) > 0 then
		footm = GetObjectCreatures("Haven", 6)
		RemoveObjectCreatures("Haven", 6, footm);
		AddObjectCreatures("Haven", 108, footm);
	end;
	if GetObjectCreatures("Haven", 8) > 0 then
		footm = GetObjectCreatures("Haven", 8)
		RemoveObjectCreatures("Haven", 8, footm);
		AddObjectCreatures("Haven", 109, footm);
	end;
	if GetObjectCreatures("Haven", 10) > 0 then
		footm = GetObjectCreatures("Haven", 10)
		RemoveObjectCreatures("Haven", 10, footm);
		AddObjectCreatures("Haven", 110, footm);
	end;
	if GetObjectCreatures("Haven", 12) > 0 then
		footm = GetObjectCreatures("Haven", 12)
		RemoveObjectCreatures("Haven", 12, footm);
		AddObjectCreatures("Haven", 111, footm);
	end;
	heroes = GetPlayerHeroes(PLAYER_5);
	for i, hero in heroes do
	sleep ( 1 );
		if GetHeroCreatures(hero, 2) > 0 then
			milit = GetHeroCreatures(hero, 2)
			RemoveHeroCreatures(hero, 2, milit);
			AddHeroCreatures(hero, 106, milit);
		end;
		if GetHeroCreatures(hero, 4) > 0 then
			footm = GetHeroCreatures(hero, 4)
			RemoveHeroCreatures(hero, 4, footm);
			AddHeroCreatures(hero, 107, footm);
		end;
		if GetHeroCreatures(hero, 6) > 0 then
			footm = GetHeroCreatures(hero, 6)
			RemoveHeroCreatures(hero, 6, footm);
			AddHeroCreatures(hero, 108, footm);
		end;
		if GetHeroCreatures(hero, 8) > 0 then
			footm = GetHeroCreatures(hero, 8)
			RemoveHeroCreatures(hero, 8, footm);
			AddHeroCreatures(hero, 109, footm);
		end;
		if GetHeroCreatures(hero, 10) > 0 then
			footm = GetHeroCreatures(hero, 10)
			RemoveHeroCreatures(hero, 10, footm);
			AddHeroCreatures(hero, 110, footm);
		end;
		if GetHeroCreatures(hero, 12) > 0 then
			footm = GetHeroCreatures(hero, 12)
			RemoveHeroCreatures(hero, 12, footm);
			AddHeroCreatures(hero, 111, footm);
		end;
	end;
end;

---------------------------------------------------------------------
-------------------- Квест на артефакты -----------------------------
---------------------------------------------------------------------

Trigger(OBJECT_TOUCH_TRIGGER, "hut", "quest");

function quest(hero_n)
	if hero_n == PlayerHero then
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", nil);
		SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE);
		sleep (1);
		startThread(quest_progress);
	else
		ShowFlyingSign("/Maps/Scenario/A1C3M3/flytext.txt", "hut", -1, 3.0);
	end;
end;

function quest_progress()
	while 1 do
		sleep (10);
		b = 0;
		sleep (1);
		for a = 36,43 do
			if HasArtefact(PlayerHero, a) == not nil then
				b = b+1;
			end;
		end;
		sleep (1);
		if b == 8 then
			SetObjectiveState( 'sec1', OBJECTIVE_COMPLETED);
			SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE);
			Trigger(OBJECT_TOUCH_TRIGGER, "hut", "quest_final");
			break;
		end;
	end;
end;

function quest_final(hero_n)
	if hero_n == PlayerHero then
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", nil);
		SetObjectiveState( 'sec2', OBJECTIVE_COMPLETED);
		for a = 36,43 do
			RemoveArtefact(PlayerHero, a);
		end;
		SetObjectPosition(PlayerHero, RegionToPoint('tele'));
	end;
end;

---------------------------------------------------------------------
----------------------- АНИМАЦИИ и ЭФФЕКТЫ --------------------------
---------------------------------------------------------------------

function Films() --- Бой кричей Первого тиера
	if random ( 2 ) == 0 then
		mover1 = training_array[1];
		mover2 = training_array[2];
	else
		mover1 = training_array[2];
		mover2 = training_array[1];
	end;
	PlayObjectAnimation(mover1 , "attack00", ONESHOT);
	sleep  ( 1 );
	if IsObjectExists(mover1) == nil then
		RemoveObject(mover2);
	end;
	if IsObjectExists(mover2) == nil then
		RemoveObject(mover1);
	end;
	if IsObjectExists(mover2) ~= nil then
		PlayObjectAnimation(mover2 , "hit", ONESHOT);
	end;
	sleep  ( 4 );
	if IsObjectExists(mover1) == nil then
		RemoveObject(mover2);
	end;
	if IsObjectExists(mover2) == nil then
		RemoveObject(mover1);
	end;
	sleep  ( 3 );
	if IsObjectExists(mover1) ~= nil and IsObjectExists(mover2) ~= nil then
		startThread(Films);
	else
		if IsObjectExists(mover1) ~= nil then
			RemoveObject(mover1);
		else
			RemoveObject(mover2);
		end;
	end;
end;

function Films1() --- Бой кричей Второго тиера
	if random ( 2 ) == 0 then
		mover3 = training_array[3];
		mover4 = training_array[4];
	else
		mover3 = training_array[4];
		mover4 = training_array[3];
	end;
	PlayObjectAnimation(mover3 , "attack00", ONESHOT);
	sleep  ( 1 );
	if IsObjectExists(mover3) == nil then
		RemoveObject(mover4);
	end;
	if IsObjectExists(mover4) == nil then
		RemoveObject(mover3);
	end;
	if IsObjectExists(mover4) ~= nil then
		PlayObjectAnimation(mover4 , "hit", ONESHOT);
	end;
	sleep  ( 4 );
	if IsObjectExists(mover3) == nil then
		RemoveObject(mover4);
	end;
	if IsObjectExists(mover4) == nil then
		RemoveObject(mover3);
	end;
	sleep  ( 3 );
	if IsObjectExists(mover3) ~= nil and IsObjectExists(mover4) ~= nil then
		startThread(Films1);
	else
		if IsObjectExists(mover3) ~= nil then
			RemoveObject(mover3);
		else
			RemoveObject(mover4);
		end;
	end;
end;

function Films2() --- Бой кричей Третьего тиера
	if random ( 2 ) == 0 then
		mover5 = training_array[5];
		mover6 = training_array[6];
	else
		mover5 = training_array[6];
		mover6 = training_array[5];
	end;
	PlayObjectAnimation(mover5 , "attack00", ONESHOT);
	sleep  ( 1 );
	if IsObjectExists(mover5) == nil then
		RemoveObject(mover6);
	end;
	if IsObjectExists(mover6) == nil then
		RemoveObject(mover5);
	end;
	if IsObjectExists(mover6) ~= nil then
		PlayObjectAnimation(mover6 , "hit", ONESHOT);
	end;
	sleep  ( 4 );
	if IsObjectExists(mover5) == nil then
		RemoveObject(mover6);
	end;
	if IsObjectExists(mover6) == nil then
		RemoveObject(mover5);
	end;
	sleep  ( 3 );
	if IsObjectExists(mover5) ~= nil and IsObjectExists(mover6) ~= nil then
		startThread(Films2);
	else
		if IsObjectExists(mover5) ~= nil then
			RemoveObject(mover5);
		else
			RemoveObject(mover6);
		end;
	end;
end;

function Films3() --- Бой кричей Четвертого тиера
	if random ( 2 ) == 0 then
		mover7 = training_array[7];
		mover8 = training_array[8];
	else
		mover7 = training_array[8];
		mover8 = training_array[7];
	end;
	PlayObjectAnimation(mover7 , "attack00", ONESHOT);
	sleep  ( 1 );
	if IsObjectExists(mover7) == nil then
		RemoveObject(mover8);
	end;
	if IsObjectExists(mover8) == nil then
		RemoveObject(mover7);
	end;
	if IsObjectExists(mover8) ~= nil then
		PlayObjectAnimation(mover8 , "hit", ONESHOT);
	end;
	sleep  ( 4 );
	if IsObjectExists(mover7) == nil then
		RemoveObject(mover8);
	end;
	if IsObjectExists(mover8) == nil then
		RemoveObject(mover7);
	end;
	sleep  ( 3 );
	if IsObjectExists(mover7) ~= nil and IsObjectExists(mover8) ~= nil then
		startThread(Films3);
	else
		if IsObjectExists(mover7) ~= nil then
			RemoveObject(mover7);
		else
			RemoveObject(mover8);
		end;
	end;
end;

function Films4() --- Бой кричей Пятого тиера
	if random ( 2 ) == 0 then
		mover9 = training_array[9];
		mover10 = training_array[10];
	else
		mover9 = training_array[10];
		mover10 = training_array[9];
	end;
	PlayObjectAnimation(mover9 , "attack00", ONESHOT);
	sleep  ( 1 );
	if IsObjectExists(mover9) == nil then
		RemoveObject(mover10);
	end;
	if IsObjectExists(mover10) == nil then
		RemoveObject(mover9);
	end;
	if IsObjectExists(mover10) ~= nil then
		PlayObjectAnimation(mover10 , "hit", ONESHOT);
	end;
	sleep  ( 4 );
	if IsObjectExists(mover9) == nil then
		RemoveObject(mover10);
	end;
	if IsObjectExists(mover10) == nil then
		RemoveObject(mover9);
	end;
	sleep  ( 3 );
	if IsObjectExists(mover9) ~= nil and IsObjectExists(mover10) ~= nil then
		startThread(Films4);
	else
		if IsObjectExists(mover9) ~= nil then
			RemoveObject(mover9);
		else
			RemoveObject(mover10);
		end;
	end;
end;

function Films5() --- Бой кричей Шестого тиера
	if random ( 2 ) == 0 then
		mover11 = training_array[11];
		mover12 = training_array[12];
	else
		mover11 = training_array[12];
		mover12 = training_array[11];
	end;
	PlayObjectAnimation(mover11 , "attack00", ONESHOT);
	sleep  ( 1 );
	if IsObjectExists(mover11) == nil then
		RemoveObject(mover12);
	end;
	if IsObjectExists(mover12) == nil then
		RemoveObject(mover11);
	end;
	if IsObjectExists(mover12) ~= nil then
		PlayObjectAnimation(mover12 , "hit", ONESHOT);
	end;
	sleep  ( 4 );
	if IsObjectExists(mover11) == nil then
		RemoveObject(mover12);
	end;
	if IsObjectExists(mover12) == nil then
		RemoveObject(mover11);
	end;
	sleep  ( 3 );
	if IsObjectExists(mover11) ~= nil and IsObjectExists(mover12) ~= nil then
		startThread(Films5);
	else
		if IsObjectExists(mover11) ~= nil then
			RemoveObject(mover11);
		else
			RemoveObject(mover12);
		end;
	end;
end;

function Films6() --- Бой Драконов
	if random ( 2 ) == 0 then
		mover13 = training_array[13];
		mover14 = training_array[14];
	else
		mover13 = training_array[14];
		mover14 = training_array[13];
	end;
	PlayObjectAnimation(mover13 , "attack00", ONESHOT);
	sleep  ( 1 );
	if IsObjectExists(mover13) == nil then
		RemoveObject(mover14);
	end;
	if IsObjectExists(mover14) == nil then
		RemoveObject(mover13);
	end;
	if IsObjectExists(mover14) ~= nil then
		PlayObjectAnimation(mover14 , "hit", ONESHOT);
	end;
	sleep  ( 4 );
	if IsObjectExists(mover13) == nil then
		RemoveObject(mover14);
	end;
	if IsObjectExists(mover14) == nil then
		RemoveObject(mover13);
	end;
	sleep  ( 3 );
	if IsObjectExists(mover13) ~= nil and IsObjectExists(mover14) ~= nil then
		startThread(Films6);
	else
		if IsObjectExists(mover13) ~= nil then
			RemoveObject(mover13);
		else
			RemoveObject(mover14);
		end;
	end;
end;

---------------------------------------------------------------------
-------------------- Стартовые команды ------------------------------
---------------------------------------------------------------------

H55_CamFixTooManySkills(PLAYER_1,"Shadwyn");
SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "RedHavenUpgrade" );
SetObjectEnabled('hut', nil);
startThread(lostDragon);
startThread(Films);
startThread(Films1);
startThread(Films2);
startThread(Films3);
startThread(Films4);
startThread(Films5);
startThread(Films6);