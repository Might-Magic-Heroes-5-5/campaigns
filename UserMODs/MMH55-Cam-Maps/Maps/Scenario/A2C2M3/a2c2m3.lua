H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_TAROT_DECK,
ARTIFACT_ENDLESS_BAG_OF_GOLD

};
-------------------------------------------------------------------
----------------- TITLE -------------------------------------------
-------------------------------------------------------------------
--       Creation Date: 12.02.07
--              Author: Ivan Myakishev
--       Author e-mail: Ivan.Myakishev@nival.com
--        Project Name: H5A2
--            Map Name: A2C2M3
--  Script Description: MapScript
 --------------------------------------------------------------------
 --------------------------------------------------------------------


-- PLAYER_1 - Игрок (green) (Orcs)
-- PLAYER_2 - Rebel (blue) heaven
-- PLAYER_3 - Red (Red) heaven



--------------------------------------------------------------------
----------------- CONSTANT -----------------------------------------
--------------------------------------------------------------------
-- Массив городов, которые должны быть под контролем игрока для выполнения условия победы
TOWNS = {"blue_haven_west_town",
		 "blue_haven_center_town",
		 "blue_haven_east_town",
		 "red_haven_west_town",
		 "red_haven_center_town", 
		 "red_haven_east_town",
		 "orcish_town" 
		};
TOWNS.n = table.length( TOWNS ); -- Константа для длины массива городов TOWNS
PEASANT_HUTS_COUNT = 14; -- Константа для количества домиков крестьян, которые необходимо сжечь, чтобы выполнить задание "Сжечь деревни"
OUR_HERO_GOTAI = "Gottai"; -- Константа для именя героя Готай (главный герой игрока) must survive
PATH = "Maps/Scenario/A2C2M3/";

SHOOT_COST = 15;
REPAIR_GOLD_COST = 1000;
REPAIR_WOOD_COST = 15;

DAY_OPEN_DUNGEON_FOR_AI = 56;
DAY_TO_START_CATAPULT_HARRASMENT = 15;
--DAY_TO_START_CATAPULT_HARRASMENT = 2; -- debug mode
CATAPULT_TARGETS = {; sw_windmill = { 29,125, 0 }, sw_center_blue_town = { 56,102, 0 },
					  sw_bridge_blue2 = { 72, 73, 0 }, sw_bridge_blue1 = { 79, 76, 0 },
					  sw_bridge_red = { 57, 75, 0}, sw_red_town_east = { 149, 32, 0 },
					  sw_megamonster = { 140, 24, 0 }, sw_red_town_west = { 43, 32, 0 } };

FIREBALL = "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)";
PRIEST_HIT = "/Effects/_(Effect)/Characters/Creatures/Haven/Cleric/Hit.xdb#xpointer(/Effect)";
EFFECT_DUST = "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)";
EFFECT_ICEBOLT = "/Effects/_(Effect)/Spells/IceBolt.xdb#xpointer(/Effect)"; 
EFFECT_ARMAGEDDON = "/Effects/_(Effect)/Spells/Armageddon.xdb#xpointer(/Effect)"
EFFECT_FIRE = "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)";
EFFECT_TOWN_BURN = "/Effects/_(Effect)/Towns/Inferno/MagicGuild.xdb#xpointer(/Effect)";
EFFECT_ICE_EXPLOSIVE = "/Effects/_(Effect)/Spells/Dispel.xdb#xpointer(/Effect)";
EFFECT_FIREWALL = "/Effects/_(Effect)/Spells/FireWall.(Effect).xdb#xpointer(/Effect)";
EFFECT_FIRE_01 = "/Effects/_(Effect)/Towns/Inferno/MagicGuild.xdb#xpointer(/Effect)";
EFFECT_FIRE_02 = "/Effects/_(Effect)/Towns/Inferno/DemonGate.xdb#xpointer(/Effect)";
EFFECT_GLOW = "/Effects/_(Effect)/Environment/Inferno/Hellpikes/Hellpikes4x4_3.xdb#xpointer(/Effect)";

SOUND_EFFECT_ICE_EXPLOSIVE = "/Sounds/_(Sound)/Spells/Dispel.xdb#xpointer(/Sound)";
SOUND_EFFECT_ARMAGEDDON = "/Sounds/_(Sound)/Spells/Armageddon.xdb#xpointer(/Sound)";
SOUND_EFFECT_ICE_BOLT = "/Sounds/_(Sound)/Spells/IceBolt.xdb#xpointer(/Sound)";
SOUND_EFFECT_EXPLOSIVE_3D = "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)";


ELEMENTALS_X, ELEMENTALS_Y = RegionToPoint( "PlaceForGotai_elementals" );

--ADVMAPSCENE_CATAPULT_HARASSMENT = 3; -- Заглушка для сцены про обстрел вражеской катапультой нашего милитари поста
ADVMAPSCENE_FIGHT_VS_DEAMONS = 2; -- Заглушка для сцены про первую встречу с демонами
ADVMAPSCENE_GOTAI_DEFEATS_WATER_ELEMENTAL = 1; -- Сцена благодарности водяного элементала, если побежден огненный элеметнал
ADVMAPSCENE_GOTAI_DEFEATS_FIRE_ELEMENTAL = 0; -- Сцена благодарности огненного элементала, если побежден водяной элеметнал


VOICEOVER_MISSION_START = "/Maps/Scenario/A2C2M3/A2C2M3_VO1_MissionStart.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_GOTAI_SEES_ELEMENTALS = "/Maps/Scenario/A2C2M3/A2C3M2_VO2_SeesElementals.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_CATAPULT_HARRASMENT = "/Maps/Scenario/A2C2M3/A2C3M2_VO3_CatapultHarrasment.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_FIRST_CATAPULT_INTERACT = "/Maps/Scenario/A2C2M3/A2C3M2_VO4_FirstCatapult.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_GOTAI_SEES_HAVEN_FIGHTING = "/Maps/Scenario/A2C2M3/A2C3M2_VO5_CivilWar.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_UNDERGROUND = "/Maps/Scenario/A2C2M3/A2C3M2_VO9_Underground.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_LOOTZONE = "/Maps/Scenario/A2C2M3/C2M3_AM6_Goblin_01sound.xdb#xpointer(/Sound)";
VOICEOVER_GOBLIN_ABOUT_DUNGEON = "/Maps/Scenario/A2C2M3/C2M3_AM4_Goblin_01sound.xdb#xpointer(/Sound)";
VOICEOVER_OBJECTIVE_DESTOY_TOWNS_ACTIVE = "/Maps/Scenario/A2C2M3/A2C3M2_VO6_DestroyTownsObj.(Sound).xdb#xpointer(/Sound)";
VOICEOVER_COLLECT_ARTIFACTS = "/Maps/Scenario/A2C2M3/C2M3_AM5_Goblin_01sound.xdb#xpointer(/Sound)";


CIVIL_WAR_UNITS = {"crossbowman1", "crossbowman2", "crossbowman3", "archer1", "archer2", "archer3", 
					"champion", "paladin", "squire", "vindicator1", "vindicator2", "peasant1", "peasant2", "priest",
					"footman_catapulter1", "footman_catapulter2", "brute" };

IsCatapultTouched_objectName = "";
IsCatapultTouched_heroName = "";
hero_in_region = "";
startScene = 0;
WaterElementalsHelp_heroName = "";
FireElementalsHelp_heroName = "";
isOKPressed = 0;
isFirstCatapultTouch = 0;
voiceover_about_underground_already_played=0;
voiceoverNotPlayed = 0;
isTownDestroyed = 0;

print("MAIN: All Constants are defined");

SetDisabledObjectMode( "demon", DISABLED_ATTACK );
SetRegionBlocked("dungeon", not nil, PLAYER_2);
SetRegionBlocked("dungeon", not nil, PLAYER_3);
SetRegionBlocked("CatapultGuard_1", not nil, PLAYER_2);
SetRegionBlocked("CatapultGuard_2", not nil, PLAYER_2);
SetRegionBlocked("CatapultGuard_1", not nil, PLAYER_3);
SetRegionBlocked("CatapultGuard_2", not nil, PLAYER_3);
SetRegionBlocked( "demon_block1", not nil );
SetRegionBlocked( "demon_block2", not nil );
SetRegionBlocked( "PlaceForGotai_elementals", not nil, PLAYER_1 );

SetRegionBlocked( "scene_orc1", not nil );
SetRegionBlocked( "scene_orc2", not nil );
SetRegionBlocked( "scene_orc3", not nil );
SetRegionBlocked( "scene_khengi", not nil );
SetRegionBlocked( "scene_demon2", not nil );
SetRegionBlocked( "scene_block_2", not nil );
SetRegionBlocked( "scene_block_1", not nil );

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

DisableAutoEnterTown( "blue_haven_west_town", not nil );
DisableAutoEnterTown( "blue_haven_center_town", not nil );
DisableAutoEnterTown( "blue_haven_east_town", not nil );
DisableAutoEnterTown( "red_haven_west_town", not nil );
DisableAutoEnterTown( "red_haven_center_town", not nil );
DisableAutoEnterTown( "red_haven_east_town", not nil );

SetHeroRoleMode( "RedHeavenHero02", HERO_ROLE_MODE_HERMIT );
SetHeroRoleMode( "RedHeavenHero03", HERO_ROLE_MODE_HERMIT );
SetHeroRoleMode( "Maeve", HERO_ROLE_MODE_HERMIT );
EnableHeroAI( "RedHeavenHero02", nil );
EnableHeroAI( "RedHeavenHero03", nil );
EnableHeroAI( "Maeve", nil );


MakeTownMovable( "red_haven_center_town" );
--------------------------------------------------------------------
----------------- VARIABLES ----------------------------------------
--------------------------------------------------------------------

razedBuildings = 0; -- Переменная (integer) для подсчета количества сожженных домиков
firstVisit_PeasantHut = 0; -- Переменная (bool). Если игрок еще не посещал домики крестьян = 0. В противном случае = 1
heroName_startDemonScene = "fake_hero"; -- Переменная (string) для хранения имени героя, напавшего на стек демонов "demon"
heroName_EnterGroundWhirlpool = "fake_hero"; -- Переменная (string) для хранения имени героя, воошедшего в водоворот
currentCapturedTowns = 0; -- Переменная (integer) для хранения количества контроллируемых игроком городов
targetObject = "titan";
effectName = EFFECT_ICEBOLT;

print("MAIN: All Variables are defined");

--------------------------------------------------------------------
----------------- START MAP SETTINGS -------------------------------
--------------------------------------------------------------------

if (GetGameVar("A2C2M1_orcs_saved") ~= "") and (GetGameVar("A2C2M1_orcs_saved") ~= "0") then
	AddHeroCreatures( OUR_HERO_GOTAI, CREATURE_ORC_WARRIOR, GetGameVar("A2C2M1_orcs_saved"));	
	print(GetGameVar("A2C2M1_orcs_saved")," orcs has been added to hero.");
end;
	
function AllowRedHaven( playerID, allow )
	AllowPlayerTavernHero( playerID, "RedHeavenHero01", allow );
	AllowPlayerTavernHero( playerID, "RedHeavenHero02", allow );
	AllowPlayerTavernHero( playerID, "RedHeavenHero03", allow );
	AllowPlayerTavernHero( playerID, "RedHeavenHero04", allow );
	AllowPlayerTavernHero( playerID, "RedHeavenHero05", allow );
	AllowPlayerTavernHero( playerID, "RedHeavenHero06", allow );
end;

AllowRedHaven( PLAYER_1, 0 );
AllowRedHaven( PLAYER_2, 0 );

function GiveTransferrableArtifacts()
    InitAllSetArtifacts( "A2C2M3", OUR_HERO_GOTAI );
    LoadHeroAllSetArtifacts( OUR_HERO_GOTAI, "A2C2M1" );--Загрузить сетовые артефакты из миссии А2С2М1
end;


-- Отключение стандартной функциональности у домиков крестьян
for i=1, PEASANT_HUTS_COUNT do
	SetObjectEnabled( "peasant_hut"..i, nil );
end;
--SetPlayerStartResources( PLAYER_1, 0, 0, 0, 0, 0, 0, 0);
-- Отключение стандартной функциональности у стека демонов "demon"
SetObjectEnabled( "demon", nil );
-- Отключение стандартной функциональности у входа в водоворот и выхода из него
SetObjectEnabled( "whirlpool_ground", nil );
SetObjectEnabled( "whirlpool_underground", nil );
SetObjectEnabled( "fire_elemental", nil );
SetObjectEnabled( "water_elemental", nil );
SetRegionBlocked( "shipyard", not nil, PLAYER_2);
SetRegionBlocked( "shipyard", not nil, PLAYER_3);
SetDisabledObjectMode( "fire_elemental", DISABLED_ATTACK  );
SetDisabledObjectMode( "water_elemental", DISABLED_ATTACK  );

-- Отключение АИ у героя Рольф

--Запретить PLAYER_2 (Rebel Heaven)	нанимать героев фракций dungeon, necromancy, inferno, stronghold
AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_DUNGEON, 0);	
AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_NECROMANCY, 0);	
AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_INFERNO, 0);	
AllowHeroHiringByRaceForAI(PLAYER_2, TOWN_STRONGHOLD, 0);	

--Запретить PLAYER_3 (Red Heaven)	нанимать героев фракций dungeon, necromancy, inferno, stronghold
AllowHeroHiringByRaceForAI(PLAYER_3, TOWN_DUNGEON, 0);	
AllowHeroHiringByRaceForAI(PLAYER_3, TOWN_NECROMANCY, 0);	
AllowHeroHiringByRaceForAI(PLAYER_3, TOWN_INFERNO, 0);
AllowHeroHiringByRaceForAI(PLAYER_3, TOWN_STRONGHOLD, 0);		


MakeHeroReturnToTavernAfterDeath( "RedHeavenHero01", not nil, 0);
MakeHeroReturnToTavernAfterDeath( "RedHeavenHero04", not nil, 0);
MakeHeroReturnToTavernAfterDeath( "RedHeavenHero05", not nil, 0);
MakeHeroReturnToTavernAfterDeath( "RedHeavenHero06", not nil, 0);

SetObjectPosition( "champion", 67 ,73 );
SetObjectPosition( "paladin", 65 ,73 );
sleep(1);
for i=1, table.length( CIVIL_WAR_UNITS ) do
	SetObjectEnabled( CIVIL_WAR_UNITS[i], nil );
end;

DenyAIHeroFlee( OUR_HERO_GOTAI, not nil );

print("MAIN: All Initial conditions are defined");

if GetDifficulty() == DIFFICULTY_EASY then
	difLevel = 1;
	for i=1, TOWNS.n-1 do
		SetTownBuildingLimitLevel( TOWNS[i], TOWN_BUILDING_DWELLING_7, 0 );
		--SetTownBuildingLimitLevel( TOWNS[i], TOWN_BUILDING_DWELLING_6, 0 );
		--SetTownBuildingLimitLevel( TOWNS[i], TOWN_BUILDING_DWELLING_5, 0 );
		SetTownBuildingLimitLevel( TOWNS[i], TOWN_BUILDING_FORT, 2 );
		print("Town limit level for town ", TOWNS[i], " is defined");
	end;
	AddHeroCreatures( OUR_HERO_GOTAI, CREATURE_ORC_WARRIOR, 30);
	AddHeroCreatures( OUR_HERO_GOTAI, CREATURE_CENTAUR, 40);
	AddHeroCreatures( OUR_HERO_GOTAI, CREATURE_SHAMAN, 10);
	AddHeroCreatures( OUR_HERO_GOTAI, CREATURE_GOBLIN, 60);
	print("All creatures are added");
	SetPlayerStartResource( PLAYER_1, GOLD, 30000 );
	SetPlayerStartResource( PLAYER_1, WOOD, 15 );
	SetPlayerStartResource( PLAYER_1, ORE, 15 );
	SetPlayerStartResource( PLAYER_1, MERCURY, 5 );
	SetPlayerStartResource( PLAYER_1, GEM, 5 );
	SetPlayerStartResource( PLAYER_1, SULFUR, 5 );
	SetPlayerStartResource( PLAYER_1, CRYSTAL, 5 );
	print( "Difficulty level is EASY" );
elseif GetDifficulty() == DIFFICULTY_NORMAL then
	difLevel = 2;
	--for i=1, TOWNS.n-1 do
		--SetTownBuildingLimitLevel( TOWNS[i], TOWN_BUILDING_DWELLING_7, 0 );
		--SetTownBuildingLimitLevel( TOWNS[i], TOWN_BUILDING_DWELLING_6, 0 );
		--SetTownBuildingLimitLevel( TOWNS[i], TOWN_BUILDING_FORT, 2 );
	--end;
	AddHeroCreatures( OUR_HERO_GOTAI, CREATURE_ORC_WARRIOR, 20);
	AddHeroCreatures( OUR_HERO_GOTAI, CREATURE_CENTAUR, 30);
	AddHeroCreatures( OUR_HERO_GOTAI, CREATURE_SHAMAN, 5);
	AddHeroCreatures( OUR_HERO_GOTAI, CREATURE_GOBLIN, 50);
	SetPlayerStartResource( PLAYER_1, GOLD, 25000 );
	SetPlayerStartResource( PLAYER_1, WOOD, 10 );
	SetPlayerStartResource( PLAYER_1, ORE, 10 );
	SetPlayerStartResource( PLAYER_1, MERCURY, 3 );
	SetPlayerStartResource( PLAYER_1, GEM, 3 );
	SetPlayerStartResource( PLAYER_1, SULFUR, 3 );
	SetPlayerStartResource( PLAYER_1, CRYSTAL, 3 );
	print( "Difficulty level is NORMAL" );
elseif GetDifficulty() == DIFFICULTY_HARD then
	difLevel = 3;
	SetPlayerStartResource( PLAYER_1, GOLD, 12000 );
	SetPlayerStartResource( PLAYER_1, WOOD, 8 );
	SetPlayerStartResource( PLAYER_1, ORE, 8 );
	SetPlayerStartResource( PLAYER_1, MERCURY, 1 );
	SetPlayerStartResource( PLAYER_1, GEM, 1 );
	SetPlayerStartResource( PLAYER_1, SULFUR, 1 );
	SetPlayerStartResource( PLAYER_1, CRYSTAL, 1 );
	print( "Difficulty level is HARD" );
elseif GetDifficulty() == DIFFICULTY_HEROIC then
	difLevel = 4;
	SetPlayerStartResource( PLAYER_1, GOLD, 8000 );
	SetPlayerStartResource( PLAYER_1, WOOD, 5 );
	SetPlayerStartResource( PLAYER_1, ORE, 5 );
	SetPlayerStartResource( PLAYER_1, MERCURY, 1 );
	SetPlayerStartResource( PLAYER_1, GEM, 1 );
	SetPlayerStartResource( PLAYER_1, SULFUR, 1 );
	SetPlayerStartResource( PLAYER_1, CRYSTAL, 1 );
	print( "Difficulty level is HEROIC" );
end;


--Play2DSound( VOICEOVER_MISSION_START );
--------------------------------------------------------------------
----------------- FUNCTIONS BODY -----------------------------------
--------------------------------------------------------------------

function PlayRazedTownEffects( townName )
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	
	local x,y,floor = GetObjectPosition( townName );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x-1.5, y-1, 0, 90, floor );
	PlayVisualEffect( EFFECT_FIREWALL, "", "fire", x-1.5, y-1, 0, 90, floor );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x-1, y+0.5, 0, 0, floor );
	PlayVisualEffect( EFFECT_FIREWALL, "", "fire", x-1, y+0.5, 0, 0, floor );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x+1.5, y-1, 0, 0, floor );
	PlayVisualEffect( EFFECT_FIREWALL, "", "fire", x+1.5, y-1, 0, 90, floor );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x+1, y+0.5, 0, 0, floor );
	PlayVisualEffect( EFFECT_FIRE_01, "", "fire", x+1, y+0.5, 0, 0, floor );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x-1, y, 0, 0, floor );
	PlayVisualEffect( EFFECT_FIRE_01, "", "fire", x-1, y, 0, 0, floor );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x+4, y, 0, 0, floor );
	PlayVisualEffect( EFFECT_FIRE_02, "", "fire", x+4, y, 0, 0, floor );
end;

function Distance( object1, object2, x, y )
	distance = -1;
	if IsObjectExists( object1 ) or IsHeroAlive( object1 ) then
		if IsObjectExists( object2 ) or IsHeroAlive( object2 ) then
			x_1, y_1 = GetObjectPosition( object1 );
			x_2, y_2 = GetObjectPosition( object2 );
			distance = sqrt((x_1-x_2)*(x_1-x_2) + (y_1-y_2)*(y_1-y_2));
		else
			if x ~= nil and y~= nil then
				distance = sqrt((x_1-x)*(x_1-x) + (y_1-y)*(y_1-y));
			else
				print("Distance: ERROR. You must specify coorinates!");
			end;
		end;
	else
		print("Distance: ERROR. Object doesn't exist!");
	end;
	return distance;
end;

function GotaiSeesElementals( heroName )
	if GetObjectOwner( heroName )==PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ElementalsArea" ,nil );
		Play2DSound( VOICEOVER_GOTAI_SEES_ELEMENTALS );
		voiceoverNotPlayed = 1;
	end;
end;

------------------------------------------------------------------------
--     Function Name: StartDemonScene() 
--     Description: Запускается при взаимодействии со стеком демонов "demon"
------------------------------------------------------------------------
function StartDemonScene( heroName )
	if GetObjectOwner( heroName )==PLAYER_1 then
		heroName_startDemonScene = heroName;
		Trigger( OBJECT_TOUCH_TRIGGER, "demon", nil);
		monster_x, monster_y = RegionToPoint("scene_demon2");
		CreateMonster( "deamon2", CREATURE_HORNED_DEMON, 1, monster_x, monster_y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_CAN_FLEE_JOIN  );
		monster_x, monster_y = RegionToPoint("scene_orc1");
		CreateMonster( "orc1", CREATURE_ORC_WARRIOR, 1, monster_x, monster_y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_CAN_FLEE_JOIN  );
		monster_x, monster_y = RegionToPoint("scene_orc2");
		CreateMonster( "orc2", CREATURE_ORC_SLAYER, 1, monster_x, monster_y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_CAN_FLEE_JOIN  );
		monster_x, monster_y = RegionToPoint("scene_orc3");
		CreateMonster( "orc3", CREATURE_ORC_WARMONGER, 1, monster_x, monster_y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_CAN_FLEE_JOIN  );
		monster_x, monster_y = RegionToPoint("scene_khengi");
		CreateMonster( "khengi", CREATURE_GOBLIN_DEFILER, 1, monster_x, monster_y, GROUND, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_CAN_FLEE_JOIN  );
		sleep(1);
		SetObjectRotation( "deamon2", 135 );
		SetObjectRotation( "orc2", 270 );
		SetObjectRotation( "khengi", 285 );
		SetObjectEnabled( "orc1", nil );
		SetObjectEnabled( "orc2", nil );
		SetObjectEnabled( "orc3", nil );
		SetObjectEnabled( "deamon2", nil );
		SetObjectEnabled( "khengi", nil );
		StartAdvMapDialog( ADVMAPSCENE_FIGHT_VS_DEAMONS, "StartCombatVsDemon" ); -- После того как игрок нажал ОК запускает комбат
	end;
end;

------------------------------------------------------------------------
--     Function Name: StartCombatVsDemon() 
--     Description: Включает функциональность монстру и насильно заставляет героя атаковать его
------------------------------------------------------------------------
function StartCombatVsDemon()
	SetObjectEnabled( "demon", not nil );
	SetRegionBlocked( "demon_block1", nil, PLAYER_1 );
	SetRegionBlocked( "demon_block2", nil, PLAYER_1 );
	
	SetRegionBlocked( "scene_orc1", nil );
	SetRegionBlocked( "scene_orc2", nil );
	SetRegionBlocked( "scene_orc3", nil );
	SetRegionBlocked( "scene_khengi", nil );
	SetRegionBlocked( "scene_demon2", nil );
	SetRegionBlocked( "scene_block_2", nil );
	SetRegionBlocked( "scene_block_1", nil );
	RemoveObject("orc1");
	RemoveObject("orc2");
	RemoveObject("orc3");
	RemoveObject("deamon2");
	RemoveObject("khengi");
	
	sleep(1);
	demon_x, demon_y = GetObjectPosition("demon");
	MoveHeroRealTimeAndReachPoint( heroName_startDemonScene, demon_x, demon_y, GROUND );
end;

function MoveHeroRealTimeAndReachPoint( heroName, x, y, floor )
	moveCost = CalcHeroMoveCost( heroName, x, y, GROUND );
	ChangeHeroStat( heroName, STAT_MOVE_POINTS, moveCost );
	sleep(1);
	MoveHeroRealTime( heroName, x, y, GROUND );
end

------------------------------------------------------------------------
--     Function Name: BurnPeasantHut() 
--     Description: Запускается при взаимодействии героев игрока с первоуровневыми двеллингами haeven (peasant hut)
------------------------------------------------------------------------
function BurnPeasantHut( heroName, objectName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		if firstVisit_PeasantHut == 0 then -- Если взаимодействуем в первый раз, показать поясняющий мессаджбокс и выдать задание "сжечь деревни"
			firstVisit_PeasantHut = 1;
			MessageBox("Maps/Scenario/A2C2M3/MsgBox_CanBurnHuts.txt", "AllowContinueScript");
			while allowContinue == 0 do sleep(2); end; -- Замораживаем выполнение тела функции до момента пока игрок не нажмет ОК в мессаджбоксе
			SetObjectiveState( "sec_Objective01_BurnAllVillages", OBJECTIVE_ACTIVE );
			startThread(Obj_sec1_BurnAllVillages_completed);
		end;
		RazeBuildingWithEffects( objectName ); -- Сжигаем домики со эффектами дыма и огня
		razedBuildings = razedBuildings + 1; -- считаем количество посещенных домиков
		ChangeResource( GOLD, 1200+random(5)*100, heroName ); -- выдать игроку денег за сжигание домика
		sleep(3);
		ChangeResource( ORE,  1+random(2), heroName );
		sleep(3);
		ChangeResource( WOOD, 1+random(3), heroName );
	end;
end;


------------------------------------------------------------------------
--     Function Name: AllowContinueScript() 
--     Description: Запускается при нажатии ОК в мессаджбоксе из функции BurnPeasantHut. Позволяет продолжить дальнейшее ее выполнение.
------------------------------------------------------------------------
function AllowContinueScript()
	allowContinue = 1;
	print("you can continue");
end;


------------------------------------------------------------------------
--     Function Name: ChangeResource() 
--     Description: Добавляет игроку указанного ресурса resourceKind в количестве quantity.
--	                Над объектом objectName показывает отлетающее сообщение о типе взятого ресурса
------------------------------------------------------------------------
function ChangeResource( resourceKind, quantity, objectName )
	SetPlayerResource( PLAYER_1, resourceKind, GetPlayerResource( PLAYER_1, resourceKind ) + quantity, objectName );
end;


------------------------------------------------------------------------
--     Function Name: BurnTownOrNot() 
--     Description: Запускается при захвате игроком одного из городов из массива TOWNS. Предлагает сжечь город или оставить
------------------------------------------------------------------------
function BurnTownOrNot( oldOwner, newOwner, heroName, objectName )
	if newOwner == PLAYER_1 and oldOwner ~= PLAYER_1 and objectName ~= "orcish_town" then 
		objectName_BurnTownOrNot = objectName; -- Понадобиться в функции WantToBurn, для определения того, какой город надо уничтожить
		heroName_BurnTownOrNot = heroName;
		MessageBox( "Maps/Scenario/A2C2M3/MsgBox_WantToBurnTown.txt","WantToBurn" );
	end;
end;


------------------------------------------------------------------------
--     Function Name: WantToBurn() 
--     Description: Если игрок желает сжечь город, то замок удаляется с карты и игроку выдается за него ресурсы.
------------------------------------------------------------------------
function WantToBurn()
	PlayRazedTownEffects( objectName_BurnTownOrNot );
	sleep(1);
	RazeTown( objectName_BurnTownOrNot );
	ChangeResource( GOLD, 16000+random(4)*1000, heroName_BurnTownOrNot );
	sleep(3);
	ChangeResource( ORE,  20+random(10), heroName_BurnTownOrNot );
	sleep(3);
	ChangeResource( WOOD, 20+random(10), heroName_BurnTownOrNot );
	sleep(3);
	ChangeResource( GEM,  6+random(5), heroName_BurnTownOrNot );
	sleep(3);
	ChangeResource( CRYSTAL, 6+random(5), heroName_BurnTownOrNot );
	sleep(3);
	ChangeResource( SULFUR,  6+random(5), heroName_BurnTownOrNot );
	sleep(3);
	ChangeResource( MERCURY, 6+random(5), heroName_BurnTownOrNot );
end;


function RemoveHeroFromVisitingSlot( townName )
	print( "Town name is "..townName );
	local playerOwner = GetObjectOwner( townName );
	print("Player is "..playerOwner);
	local ownerHeroes = GetPlayerHeroes( playerOwner );
	for i=0, table.length( ownerHeroes )-1 do
		if IsHeroInTown( ownerHeroes[i], townName, 1, 0 ) == not nil then
			RemoveObject( ownerHeroes[i] );
			print("Hero "..ownerHeroes[i].." is in visiting slot. He was removed.");
			break;
		end;
	end;
	print("end");
end;
------------------------------------------------------------------------
--     Function Name: EnterGroundWhirlpool() 
--     Description: Запускается при попытке игрока войти в водоворот на поверхности. Спрашивает, угодно ли ему это сделать или все-таки потом?
------------------------------------------------------------------------
function EnterGroundWhirlpool( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		heroName_EnterGroundWhirlpool = heroName; -- Понадобится в функции WantToEnterWhirlpool, чтобы начать комбат с элементалами
		QuestionBox("Maps/Scenario/A2C2M3/MsgBox_WantToEnterWhirlPool.txt", "WantToEnterWhirlpool");
	end;
end;


------------------------------------------------------------------------
--     Function Name: WantToEnterWhirlpool() 
--     Description: Запускается если игроку все же хочется войти в водоворот и прянять бой с водяными элементалами
------------------------------------------------------------------------
function WantToEnterWhirlpool()
	StartCombat(heroName_EnterGroundWhirlpool, nil, 2, CREATURE_WATER_ELEMENTAL, 12, CREATURE_WATER_ELEMENTAL, 12, nil, "CombatResult", nil, not nil )
end;


------------------------------------------------------------------------
--     Function Name: CombatResult() 
--     Description: Запускается в случае победы героя игрока над водяными элементалами, охраняющими водоворот
------------------------------------------------------------------------
function CombatResult( heroName, result )
	if result == not nil then
		Trigger( OBJECT_TOUCH_TRIGGER, "whirlpool_ground", "EnterUndergroundThroughWhirlpool");
		pool_x, pool_y = GetObjectPosition( "whirlpool_ground" ); 
		MoveHeroRealTimeAndReachPoint( heroName, pool_x, pool_y, GROUND ); -- насильно отправить игрока в водоворот
	end;
end;

function EnterUndergroundThroughWhirlpool( heroName )
	if GetObjectOwner( heroName )==PLAYER_1 then
		BlockGame();
		whirlpool_x, whirlpool_y, whirlpool_floor = GetObjectPosition( "whirlpool_underground" );
		MoveCamera( whirlpool_x, whirlpool_y, whirlpool_floor, 31, 1.2, 0, 1, 1, 0);
		OpenCircleFog( whirlpool_x, whirlpool_y, whirlpool_floor, 7, PLAYER_1 );
		SetObjectPosition( heroName, whirlpool_x, whirlpool_y, whirlpool_floor );
		sleep(40);
		UnblockGame();
	end;
end;


------------------------------------------------------------------------
--     Function Name: startUndergroundWhirlpoolTrigger() 
--     Description: Запускается, когда герой игрока пройдет сквозь водоворот и окажется в подземелье.
------------------------------------------------------------------------
function startUndergroundWhirlpoolTrigger( heroName )
	print("startUndergroundWhirlpoolTrigger:  Hero ", heroName, " is in the underground.");
	SetObjectEnabled( "whirlpool_underground", nil );
	Trigger( OBJECT_TOUCH_TRIGGER, "whirlpool_underground", "WhirlpoolRejectMessage" ); -- при попытке взаимодействия с подземным водоворотом выдает
	sleep(1);																			-- сообщение, что в обратную сторону он не работает
	Trigger( OBJECT_TOUCH_TRIGGER, "whirlpool_ground", "EnterGroundWhirlpool"); -- Для водоворота на поверхности восстанавливается изначальная функциональность (скриптовая)
end;


------------------------------------------------------------------------
--     Function Name: WhirlpoolRejectMessage() 
--     Description: Запускается при попытке войти в подземный водоворот
------------------------------------------------------------------------
function WhirlpoolRejectMessage()
	MessageBox("Maps/Scenario/A2C2M3/MsgBox_whirlpool_reject.txt");
end;


function PlayVoiceoverInUnderground( heroName )
	print("PlayVoiceoverInUnderground: Hero is in underground");
	if GetObjectOwner( heroName )==PLAYER_1 then
		Play2DSound( VOICEOVER_UNDERGROUND );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_dungeon_2", nil );
	end;
end;
------------------------------------------------------------------------
--     Function Name: RazeBuildingWithEffects() 
--     Description: Разрушает объект objectName и показывает эффекты огня и дыма
------------------------------------------------------------------------
function RazeBuildingWithEffects( objectName )
	x, y, floor = GetObjectPosition( objectName );
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x, y, 0, floor ); -- Пыль
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag2", x, y, 0, floor ); -- Огонь
	RazeBuilding( objectName );
end;




--------------------------------------------------------------------
----------------- OBJECTIVES ---------------------------------------
--------------------------------------------------------------------


------------------------------------------------------------------------
--     Function Name: PlayerWin() 
--     Description: Запускается при старте карты. Комплитит миссию, если выполнены основные обжективы
------------------------------------------------------------------------
function PlayerWin()
	while GetObjectiveState("prim1_CaptureAllTowns")~=OBJECTIVE_COMPLETED do
		sleep(10);
	end;
	StartDialogScene("/DialogScenes/A2C2/M3/S1/DialogScene.xdb#xpointer(/DialogScene)");
	SaveHeroAllSetArtifactsEquipped( OUR_HERO_GOTAI, "A2C2M3" );
	sleep(5);
	Win(PLAYER_1);
end;


------------------------------------------------------------------------
--     Function Name: Obj_prim1_CaptureAllTowns_completed() 
--     Description: Запускается при старте карты. Комплитит задание "Захватить все города"
------------------------------------------------------------------------
function Obj_prim1_CaptureAllTowns_completed()
	sleep(1);
	SetObjectiveState( "prim1_CaptureAllTowns", OBJECTIVE_ACTIVE );
	sleep(1);
	repeat
		capturedTowns = 0;
		for i=1, TOWNS.n do
			if (GetObjectOwner(TOWNS[i]) == PLAYER_1) or (GetObjectOwner(TOWNS[i]) == PLAYER_NONE) then -- PLAYER_NONE - принадлежат города, которые игрок уничтожил
				capturedTowns = capturedTowns + 1;
			end;
		end;
		currentCapturedTowns = capturedTowns; -- тестовая переменная. Хранит количество имеющихся на данный момент у игрока городов
		sleep(10);
	until capturedTowns == TOWNS.n;
	SetObjectiveState( "prim1_CaptureAllTowns", OBJECTIVE_COMPLETED );	
end;


------------------------------------------------------------------------
--     Function Name: Obj_prim3_HeroMustSurvive_completed() 
--     Description: Если герой Готай убит, фейлит миссию
------------------------------------------------------------------------
function Obj_prim3_HeroMustSurvive_completed()
	while IsHeroAlive( OUR_HERO_GOTAI ) == not nil do sleep(10); end;
	print("Obj_prim2_HeroMustSurvive_completed: Our glorious hero", OUR_HERO_GOTAI, " is dead.");
	Loose();	
end;


------------------------------------------------------------------------
--     Function Name: Obj_sec1_BurnAllVillages_completed() 
--     Description: Когда все домики сожжены, комплитит дополнительное задание "Сжечь все деревни"
------------------------------------------------------------------------
function Obj_sec1_BurnAllVillages_completed()
	while razedBuildings ~= PEASANT_HUTS_COUNT do sleep(10); end;
	SetObjectiveState("sec_Objective01_BurnAllVillages", OBJECTIVE_COMPLETED );
	local PlayerHeroes=GetPlayerHeroes( PLAYER_1 );	
	for i=0, table.length(PlayerHeroes)-1 do
		ChangeHeroStat( PlayerHeroes[i], STAT_ATTACK, 2 );
		if GetHeroTown( PlayerHeroes[i] )==nil then
			ShowFlyingSign( PATH.."MsgBox_FlyngSignPlusAttack.txt", PlayerHeroes[i], PLAYER_1, 5 );
		end;
		print("Obj_sec1_BurnAllVillages_completed: Attack skill was increased by 2 to all heroes!");
	end;
end;


function IsBrokenCatapultTouched( heroName, objectName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		if heroName == OUR_HERO_GOTAI then
			QuestionBox( { PATH.."WantToRepare.txt"; gold = REPAIR_GOLD_COST, wood = REPAIR_WOOD_COST }, "WantToRepairCatapult");
		else
			MessageBox( PATH.."MsgBox_OnlyGotaiCanUse.txt" );
		end;
	end;
end;

function WantToRepairCatapult()
	catapult_x, catapult_y = GetObjectPosition( "broken_catapult" );
	WoodQuantity = GetPlayerResource( PLAYER_1, WOOD );
	GoldQuantity = GetPlayerResource( PLAYER_1, GOLD );
	if WoodQuantity >= REPAIR_WOOD_COST then
		if GoldQuantity >= REPAIR_GOLD_COST then
			PlayVisualEffect("/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "", "tag1", catapult_x, catapult_y, 0, 0, GROUND );
			RemoveObject( "broken_catapult");
			SetObjectPosition( "catapult2", catapult_x, catapult_y, GROUND );
			SetPlayerResource( PLAYER_1, WOOD, (WoodQuantity - REPAIR_WOOD_COST) );
			SetPlayerResource( PLAYER_1, GOLD, (GoldQuantity - REPAIR_GOLD_COST) );
		else
			MessageBox(PATH.."NotEnoughGold");
		end;
	else
		MessageBox(PATH.."NotEnoughWood");
	end;	
end;

function IsCatapultTouched( heroName, objectName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		if isFirstCatapultTouch == 0 then
			isFirstCatapultTouch=1;
			Play2DSound( VOICEOVER_FIRST_CATAPULT_INTERACT );
		end;
		--if heroName == OUR_HERO_GOTAI then
			QuestionBox( { PATH.."WantToShoot.txt"; ore = SHOOT_COST }, "WantToShootCatapult");
		--else
			--MessageBox( PATH.."MsgBox_OnlyGotaiCanUse.txt" );
		--end;
	end;
	IsCatapultTouched_objectName = objectName;
	IsCatapultTouched_heroName = heroName;
end;


function WantToShootCatapult()
	objectName = "catapult_"..IsCatapultTouched_objectName;
	index = IsCatapultTouched_objectName;
	hero_x, hero_y, hero_floor = GetObjectPosition( IsCatapultTouched_heroName );
	
	if index == "sw_bridge_red" then
		Heroes = GetObjectsInRegion( "enemy_hero", OBJECT_HERO );
		if table.length( Heroes ) > 0 then
			for i=1,table.length( Heroes ) do
				if GetObjectOwner( Heroes[i] ) ~= PLAYER_1 then
					hero_x, hero_y = GetObjectPosition( Heroes[i] );
					CATAPULT_TARGETS[index][1] = hero_x;
					CATAPULT_TARGETS[index][2] = hero_y;
					hero_in_region = Heroes[i];
					break;
				end;
			end;
		end;
	end;
	
	catapult_x, catapult_y = GetObjectPosition( objectName );
	StoneQuantity = GetPlayerResource( PLAYER_1, ORE );
	if StoneQuantity >= SHOOT_COST then
		SetPlayerResource( PLAYER_1, ORE, (StoneQuantity - SHOOT_COST) );
		PlayObjectAnimation( objectName, "rangeattack", ONESHOT );
		BlockGame();
		OpenCircleFog(CATAPULT_TARGETS[index][1], CATAPULT_TARGETS[index][2], GROUND, 7, PLAYER_1 );
		sleep(5);
		MoveCamera(CATAPULT_TARGETS[index][1], CATAPULT_TARGETS[index][2], GROUND, 31, 1.2, 0, 1, 1, 1);
		PlayVisualEffect( FIREBALL, '', 'boom', CATAPULT_TARGETS[index][1], CATAPULT_TARGETS[index][2], 0, 0, GROUND );
		Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", CATAPULT_TARGETS[index][1], CATAPULT_TARGETS[index][2], 0 );
		sleep(2);
		CATAPULT_TARGETS[index][3] = CATAPULT_TARGETS[index][3] + 1;
		sleep(20);
		UnblockGame();
		MoveCamera(hero_x, hero_y, GROUND, 31, 1.2, 0, 1, 1, 1 );
	else
		MessageBox( PATH.."NotEnoughStone.txt" );
	end;
end;

function KillEnemyHero( heroName )
	while CATAPULT_TARGETS["sw_bridge_red"][3] == 0 do sleep(5); end;
	RemoveObject( hero_in_region  );
end;


function test()
	print("object is touched");
	PlayObjectAnimation( "catapult", "rangeattack", ONESHOT );
end;

function WindmillCrush()
	index = "sw_windmill";
	while CATAPULT_TARGETS[index][3] == 0 do sleep(10); end;
	sleep(10);
	PlayVisualEffect("/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "", "tag1", CATAPULT_TARGETS[index][1], CATAPULT_TARGETS[index][2], 0, 0, GROUND );
	RazeBuilding( "windmill" );
	SetObjectPosition("windmill_gold", 28, 124, GROUND );
	SetObjectPosition("windmill_wood", 28, 125, GROUND );
	SetObjectPosition("windmill_ore", 28, 126, GROUND );
	SetObjectPosition("windmill_mercury", 28, 127, GROUND );
end;

function TownCrush()
	while CATAPULT_TARGETS["sw_center_blue_town"][3] < 3 do sleep(10); end;	
	RemoveHeroFromVisitingSlot( "blue_haven_center_town" );
	sleep(1);
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	RazeTown("blue_haven_center_town");	
end;

function OutpostCrush() -- Потом надо будет сделать уничтожение аутпоста не с первой попытки. С постепенным уничтожением гарнизона
	index = "outpost";
	while CATAPULT_TARGETS["sw_bridge_blue2"][3] == 0 do sleep(10); end;
	PlayVisualEffect( EFFECT_DUST, "","tag1", CATAPULT_TARGETS[index][1], CATAPULT_TARGETS[index][2], GROUND );
	--RazeBuilding( index );
	for i=1, 179 do
		RemoveObjectCreatures( "outpost", i, 10000);
	end;
end;

function PeasantHutCrush()
	index = "peasant_hut7";
	while CATAPULT_TARGETS["sw_bridge_blue1"][3] == 0 do sleep(10); end;
	if IsObjectExists("peasant_hut7") then
		RazeBuildingWithEffects( "peasant_hut7" );
		razedBuildings = razedBuildings + 1;
	end;
end;

function DeathKnightCrush()
	while CATAPULT_TARGETS["sw_megamonster"][3] == 0 do sleep(10); end;
	if IsObjectExists("megamonster")==not nil then
		PlayObjectAnimation( "megamonster", "death", ONESHOT_STILL );
		sleep(10);
		RemoveObject( "megamonster" );
	end;
end;

function RedTownEastCrush()
	while CATAPULT_TARGETS["sw_red_town_east"][3] < 3 do sleep(10); end;
	RemoveHeroFromVisitingSlot("red_haven_east_town");
	sleep(5);
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	RazeTown( "red_haven_east_town" );
end;

function RedTownWestCrush()
	while CATAPULT_TARGETS["sw_red_town_west"][3] < 3 do sleep(10); end;
	RemoveHeroFromVisitingSlot("red_haven_west_town");
	sleep(5);
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	RazeTown( "red_haven_west_town" );
end;


function IsCivilWarVisible()
	for i=1, table.length( CIVIL_WAR_UNITS ) do
		if IsObjectVisible( PLAYER_1, CIVIL_WAR_UNITS[i] ) == not nil then
			return 1;
		end;
	end;
	return 0;
end;

function IsFireElementalAttacked( heroName, objectName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		--PlayObjectAnimation( "water_elemental", "idle00", IDLE );
		--PlayObjectAnimation( "fire_elemental", "idle00", IDLE );
		Trigger( OBJECT_TOUCH_TRIGGER, "fire_elemental", nil );
		Trigger( OBJECT_TOUCH_TRIGGER, "water_elemental", nil );
		StartCombat( heroName, nil, 1, CREATURE_FIRE_ELEMENTAL, 20 + difLevel*5, nil, "IsHeroWinFireElementals", nil, nil );
	end;
end;

function PlaceGotaiToScene( heroName, regionName, heroRotation, returnIfObjectNotExistName )
	scene_x, scene_y = RegionToPoint( regionName );
	initialHero_x, initialHero_y, initialHero_floor = GetObjectPosition( heroName );
	SetRegionBlocked( regionName, nil );
	SetObjectPosition( heroName, scene_x, scene_y, GROUND );
	SetObjectRotation( heroName, heroRotation );
	repeat sleep(1); until IsObjectExists( returnIfObjectNotExistName )==nil;
	SetObjectPosition( heroName, initialHero_x, initialHero_y, initialHero_floor );
end;

function IsHeroWinFireElementals( heroName, result )
	if result == not nil then
		print("Our hero ", heroName, " has won fire elemetals!");
		WaterElementalsHelp_heroName = heroName;
		RemoveObject( "fire_elemental" );
		if heroName~=OUR_HERO_GOTAI then
			startThread( PlaceGotaiToScene, OUR_HERO_GOTAI, "PlaceForGotai_elementals", 90, "water_elemental" );
		end;
		StartAdvMapDialog( ADVMAPSCENE_GOTAI_DEFEATS_FIRE_ELEMENTAL, "WaterElementalsHelp" );
	else
		Trigger( OBJECT_TOUCH_TRIGGER, "fire_elemental", "IsFireElementalAttacked" );
		Trigger( OBJECT_TOUCH_TRIGGER, "water_elemental", "IsWaterElementalAttacked" );
	end;
end;

function WaterElementalsHelp()
	RemoveObject( "water_elemental" );
	heroName = WaterElementalsHelp_heroName;
	SetRegionAutoObjectEnable( "titan_area", REGION_AUTOACTION_ON_ENTER, -1, -1, heroName, "titan", 0 );
	SetRegionAutoObjectEnable( "megamonster_area", REGION_AUTOACTION_ON_ENTER, -1, -1, heroName, "megamonster", 0 );
	SetRegionAutoObjectEnable( "town_area", REGION_AUTOACTION_ON_ENTER, -1, -1, heroName, "red_haven_center_town", 0 );
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "titan_area", "HeroEntersTitanArea");
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "megamonster_area", "HeroEntersDeathKnightArea");
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "town_area", "HeroEntersTownArea");	
end;


function WaterElementalStrikeObject( heroName, objectName, messageText, functionName, effect_Name )
	if IsObjectExists( objectName ) == not nil then
		object_x, object_y, object_floor = GetObjectPosition( objectName );
		BlockGame();
		MoveCamera( object_x, object_y, object_floor, 40, 0.9, 0, 0, 0, 1 );
		OpenCircleFog( object_x, object_y, object_floor, 7, PLAYER_1 );
		sleep(1);
		MessageBox( messageText, functionName );
		PlayVisualEffect( effect_Name, objectName, "hz" );
		eff_x, eff_y, eff_floor = GetObjectPosition( objectName );
		if effect_Name==FIREBALL then
			Play3DSound( SOUND_EFFECT_EXPLOSIVE_3D, eff_x, eff_y, eff_floor );
		else
			if effect_Name==EFFECT_ICEBOLT then
				Play2DSound( SOUND_EFFECT_ICE_BOLT );
			end;
		end;
		sleep(10);
		PlayObjectAnimation( objectName, "death", ONESHOT_STILL );
		sleep(25);
		RemoveObject( objectName );
		UnblockGame();
	end;
	print("WaterElementalStrikeObject terminated");
end;

function WaterElementalStrikeTown( heroName )
	objectName = "red_haven_center_town";
	if IsHeroAlive( heroName ) == not nil and IsObjectExists( objectName )==not nil and GetObjectOwner( objectName )~=PLAYER_1 then
		object_x, object_y, object_floor = GetObjectPosition( objectName );
		BlockGame();
		MoveCamera( object_x, object_y, object_floor, 40, 0.9, 0, 0, 0, 1);
		targetObject = objectName;
		effectName = EFFECT_ICEBOLT;
		MessageBox( PATH.."WaterElementalWantDestroyTown.txt", "WaterElementalWantDestroyTown" );
	end;
	print("WaterElementalStrikeTown terminated");
end;

function WaterElementalWantDestroyTown()
	x,y = GetObjectPosition( targetObject );
	PlayVisualEffect( effectName, targetObject, "hz" );
	PlayVisualEffect( effectName, targetObject, "hz",3, 3, 0, 0, GROUND);
	PlayVisualEffect( effectName, targetObject, "hz",3, -2, 0, 0, GROUND);
	PlayVisualEffect( effectName, targetObject, "hz",-2, 2, 0, 0, GROUND);
	PlayVisualEffect( effectName, targetObject, "hz",-1, -1, 0, 0, GROUND);
	PlayVisualEffect( effectName, targetObject, "hz",3, -2, 0, 0, GROUND);
	PlayVisualEffect( effectName, targetObject, "hz",-3, 3, 0, 0, GROUND);
	PlayVisualEffect( effectName, targetObject, "hz",1, -4, 0, 0, GROUND);
	Play2DSound( SOUND_EFFECT_ICE_BOLT );
	sleep(6);
	PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, targetObject, "hz" );
	PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, targetObject, "hz",3, 3, 0, 0, GROUND);
	PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, targetObject, "hz",3, -2, 0, 0, GROUND);
	PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, targetObject, "hz",-2, 2, 0, 0, GROUND);
	PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, targetObject, "hz",-1, -1, 0, 0, GROUND);
	PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, targetObject, "hz",3, -2, 0, 0, GROUND);
	PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, targetObject, "hz",-3, 3, 0, 0, GROUND);
	PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, targetObject, "hz",1, -4, 0, 0, GROUND);
	PlayVisualEffect( EFFECT_ICE_EXPLOSIVE, targetObject, "hz",1, -4, 0, 0, GROUND);
	Play2DSound( SOUND_EFFECT_ICE_EXPLOSIVE );
	sleep(18);
	--RazeTown( targetObject );
	--SetObjectPosition( targetObject, 30, 155, UNDERGROUND ); -- После того как программерчеги полечат ассерты раскомментировать
	--sleep(2);
	RazeTown( targetObject );
	UnblockGame();
end;


function IsWaterElementalAttacked( heroName, objectName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		--PlayObjectAnimation( "fire_elemental", "idle00", IDLE );
		--PlayObjectAnimation( "water_elemental", "idle00", IDLE );
		Trigger( OBJECT_TOUCH_TRIGGER, "fire_elemental", nil );
		Trigger( OBJECT_TOUCH_TRIGGER, "water_elemental", nil );
		StartCombat( heroName, nil, 1, CREATURE_WATER_ELEMENTAL, 20 + difLevel*5, nil, "IsHeroWinWaterElementals", nil, nil );
	end;
end;

function IsHeroWinWaterElementals( heroName, result )
	if result == not nil then
		print("Our hero ", heroName, " has won water elemetals!");
		FireElementalsHelp_heroName = heroName;
		RemoveObject( "water_elemental" );
		if heroName~=OUR_HERO_GOTAI then
			startThread( PlaceGotaiToScene, OUR_HERO_GOTAI, "PlaceForGotai_elementals", 90, "fire_elemental" );
		end;		StartAdvMapDialog( ADVMAPSCENE_GOTAI_DEFEATS_WATER_ELEMENTAL, "FireElementalsHelp" );
		--MessageBox( PATH.."FireElementalsThanks.txt", "FireElementalsHelp" );--Здесь должна быть диалоговая сцена
	else
		Trigger( OBJECT_TOUCH_TRIGGER, "fire_elemental", "IsFireElementalAttacked" );
		Trigger( OBJECT_TOUCH_TRIGGER, "water_elemental", "IsWaterElementalAttacked" );
	end;
end;

function FireElementalsHelp()
	RemoveObject( "fire_elemental" );
	heroName = FireElementalsHelp_heroName; 
	SetRegionAutoObjectEnable( "titan_area", REGION_AUTOACTION_ON_ENTER, -1, -1, heroName, "titan", 0 );
	SetRegionAutoObjectEnable( "megamonster_area", REGION_AUTOACTION_ON_ENTER, -1, -1, heroName, "megamonster", 0 );
	SetRegionAutoObjectEnable( "town_area", REGION_AUTOACTION_ON_ENTER, -1, -1, heroName, "red_haven_center_town", 0 );
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "titan_area", "HeroEntersTitanArea");
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "megamonster_area", "HeroEntersDeathKnightArea");
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "town_area", "HeroEntersTownArea");	
end;

function HeroEntersTitanArea( heroName )
	if WaterElementalsHelp_heroName~="" and GetObjectOwner( heroName )==PLAYER_1 then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "titan_area", nil );
		startThread( WaterElementalStrikeObject, heroName, "titan", PATH.."WaterElementalWantKillMonster.txt", "IsOkPressed", EFFECT_ICEBOLT );
	end;
	if FireElementalsHelp_heroName~="" and GetObjectOwner( heroName )==PLAYER_1 then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "titan_area", nil );
		startThread( FireElementalStrikeObject, heroName, "titan", PATH.."FireElementalWantKillMonster.txt", "IsOkPressed", FIREBALL );
	end;
end;

function HeroEntersDeathKnightArea( heroName )
	if WaterElementalsHelp_heroName~="" and GetObjectOwner( heroName )==PLAYER_1 then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "megamonster_area", nil );
		startThread( WaterElementalStrikeObject, heroName, "megamonster", PATH.."WaterElementalWantKillMonster.txt", "IsOkPressed", EFFECT_ICEBOLT );
	end;
	if FireElementalsHelp_heroName~="" and GetObjectOwner( heroName )==PLAYER_1 then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "megamonster_area", nil );
		startThread( FireElementalStrikeObject, heroName, "megamonster", PATH.."FireElementalWantKillMonster.txt", "IsOkPressed", FIREBALL );
	end;
end;

function HeroEntersTownArea( heroName )
	if GetObjectOwner("red_haven_center_town")==PLAYER_NONE then -- if town alrady destroyed
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "town_area", nil );
		return
	end;
	if WaterElementalsHelp_heroName~="" and GetObjectOwner( heroName )==PLAYER_1 then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "town_area", nil );
		startThread( WaterElementalStrikeTown, heroName );
	end;
	if FireElementalsHelp_heroName~="" and GetObjectOwner( heroName )==PLAYER_1 then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "town_area", nil );
		startThread( FireElementalStrikeTown, heroName );
	end;
end;

function FireElementalStrikeObject( heroName, objectName, messageText, functionName, effect_Name )
	if IsHeroAlive( heroName ) == not nil and IsObjectExists( objectName )==not nil then
		object_x, object_y, object_floor = GetObjectPosition( objectName );
		BlockGame();
		MoveCamera( object_x, object_y, object_floor, 40, 0.9, 0, 0, 0, 1 );
		OpenCircleFog( object_x, object_y, object_floor, 7, PLAYER_1 );
		sleep(1);
		MessageBox( messageText, functionName );
		PlayVisualEffect( effect_Name, objectName, "hz" );
		eff_x, eff_y, eff_floor = GetObjectPosition( objectName );
		if effect_Name==FIREBALL then
			Play3DSound( SOUND_EFFECT_EXPLOSIVE_3D, eff_x, eff_y, eff_floor );
		else
			if effect_Name==EFFECT_ICEBOLT then
				Play2DSound( SOUND_EFFECT_ICE_BOLT );
			end;
		end;
		sleep(5);
		PlayObjectAnimation( objectName, "death", ONESHOT_STILL );
		sleep(20);
		RemoveObject( objectName );
		UnblockGame();
	end;
	print("FireElementalStrikeObject terminated");
end;

function IsOkPressed()
	isOKPressed = 1;
end;

function FireElementalStrikeTown( heroName )
	objectName = "red_haven_center_town";
	while Distance( heroName, objectName ) > 14 do sleep(2); end;
	if IsHeroAlive( heroName ) == not nil and IsObjectExists( objectName )==not nil and GetObjectOwner( objectName )~=PLAYER_1 then
		object_x, object_y, object_floor = GetObjectPosition( objectName );
		BlockGame();
		MoveCamera( object_x, object_y, object_floor, 40, 0.9, 0, 0, 0, 1);
		targetObject = objectName;
		effectName = EFFECT_ARMAGEDDON;
		MessageBox( PATH.."FireElementalWantDestroyTown.txt", "FireElementalWantDestroyTown" );
	end;
	print("FireElementalStrikeTown terminated");
end;

function FireElementalWantDestroyTown()
	x,y = GetObjectPosition( targetObject );
	PlayVisualEffect( effectName, targetObject, "hz" );
	if effectName == EFFECT_ARMAGEDDON then
		Play2DSound( SOUND_EFFECT_ARMAGEDDON );
	end;
	sleep(30);
	--RazeTown( targetObject );
	--RemoveObject( targetObject );
	--SetObjectPosition( targetObject, 30, 155, UNDERGROUND );
	sleep(2);
	RazeTown( targetObject );
	--SetObjectOwner( targetObject, PLAYER_1 );
	UnblockGame();
end;


function StartCivilWarScene()
	while IsCivilWarVisible() ~= not nil do sleep(3); end;
	if startScene == 0 then
		hero_x, hero_y, hero_floor = GetObjectPosition( OUR_HERO_GOTAI );
		OpenCircleFog( 64, 74, GROUND, 23, PLAYER_1 );
		BlockGame();	
		MoveCamera(54,69, GROUND, 31, 0.6, -0.55,0,0,1);
		sleep(10);
		PlayObjectAnimation( "archer1", "rangeattack", IDLE );
		PlayObjectAnimation( "archer2", "rangeattack", IDLE );
		PlayObjectAnimation( "archer3", "rangeattack", IDLE );
		PlayObjectAnimation( "vindicator1", "attack00", IDLE );
		PlayObjectAnimation( "vindicator2", "attack00", IDLE );
		PlayObjectAnimation( "squire", "attack00", IDLE );
		PlayObjectAnimation( "peasant1", "attack00", IDLE );
		PlayObjectAnimation( "peasant2", "attack00", IDLE );
		PlayObjectAnimation( "crossbowman1", "rangeattack", IDLE );
		PlayObjectAnimation( "crossbowman2", "rangeattack", IDLE );
		PlayObjectAnimation( "crossbowman3", "rangeattack", IDLE );
		PlayObjectAnimation( "champion", "attack00", IDLE );
		PlayObjectAnimation( "paladin", "attack00", IDLE );
		sleep(20);
		Play2DSound( VOICEOVER_GOTAI_SEES_HAVEN_FIGHTING );
		PlayObjectAnimation( "champion", "death", ONESHOT_STILL );
		sleep(10);
		PlayObjectAnimation( "paladin", "happy", ONESHOT );
		PlayObjectAnimation( "archer1", "happy", ONESHOT );
		PlayObjectAnimation( "archer2", "happy", ONESHOT );
		PlayObjectAnimation( "archer3", "happy", ONESHOT );
		sleep(15);
		PlayObjectAnimation( "brute", "attack00", ONESHOT );
		sleep(5);
		PlayObjectAnimation( "catapult_sw_bridge_red", "rangeattack", ONESHOT );
		sleep(10);
		x,y = GetObjectPosition( "archer2" );
		PlayVisualEffect( FIREBALL, '', 'boom', x, y, 0, 0, GROUND );
		Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", x, y, 0);
		sleep(2);
		PlayObjectAnimation( "archer1", "death", ONESHOT_STILL );
		PlayObjectAnimation( "archer2", "death", ONESHOT_STILL );
		PlayObjectAnimation( "archer3", "death", ONESHOT_STILL );
		sleep(15);
		PlayObjectAnimation( "paladin", "death", ONESHOT_STILL );
		sleep(5);
		PlayObjectAnimation( "crossbowman1", "happy", ONESHOT );
		PlayObjectAnimation( "crossbowman2", "happy", ONESHOT );
		PlayObjectAnimation( "crossbowman3", "happy", ONESHOT );
		sleep(5);
		
		PlayObjectAnimation( "footman_catapulter1", "attack00", ONESHOT );
		sleep(5);
		PlayObjectAnimation( "catapult_sw_bridge_blue1", "rangeattack", ONESHOT );
		sleep(5);
		PlayVisualEffect( FIREBALL, '', 'boom', 76, 81, 0, 0, GROUND );
		Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", x, y, 0);
		
		PlayObjectAnimation( "footman_catapulter2", "attack00", ONESHOT );
		sleep(5);
		PlayObjectAnimation( "catapult_sw_bridge_blue2", "rangeattack", ONESHOT );
		sleep(10);
		x,y = GetObjectPosition( "crossbowman2" );
		PlayVisualEffect( FIREBALL, '', 'boom', x, y, 0, 0, GROUND );
		Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", x, y, 0);
		sleep(2);
		PlayObjectAnimation( "crossbowman1", "death", ONESHOT_STILL );
		PlayObjectAnimation( "crossbowman2", "death", ONESHOT_STILL );
		PlayObjectAnimation( "crossbowman3", "death", ONESHOT_STILL );
		sleep(5);
		PlayObjectAnimation( "footman_catapulter1", "happy", ONESHOT );
		PlayObjectAnimation( "footman_catapulter2", "happy", ONESHOT );
		sleep(5);
		PlayObjectAnimation( "peasant1", "death", ONESHOT_STILL );
		sleep(5);
		PlayObjectAnimation( "priest", "rangeattack", ONESHOT_STILL );
		x,y = GetObjectPosition( "vindicator2" );
		PlayVisualEffect( PRIEST_HIT, "", "boom", x, y, 0, 180, GROUND );
		sleep(2);
		PlayObjectAnimation( "vindicator1", "death", ONESHOT_STILL );
		PlayObjectAnimation( "vindicator2", "death", ONESHOT_STILL );
		sleep(10);
		PlayObjectAnimation( "priest", "happy", ONESHOT );
		PlayObjectAnimation( "squire", "happy", ONESHOT );
		PlayObjectAnimation( "peasant2", "happy", ONESHOT );
		PlayObjectAnimation( "footman_catapulter1", "happy", ONESHOT );
		PlayObjectAnimation( "footman_catapulter2", "happy", ONESHOT );
		SetObjectEnabled( "priest", not nil );
		SetObjectEnabled( "squire", not nil );
		SetObjectEnabled( "peasant2", not nil );
		SetObjectEnabled( "footman_catapulter1", not nil );
		SetObjectEnabled( "footman_catapulter2", not nil );
		SetObjectEnabled( "brute", not nil );
		sleep(1);
		RemoveObject( "champion" );
		RemoveObject( "paladin" );
		RemoveObject( "archer1" );
		RemoveObject( "archer2" );
		RemoveObject( "archer3" );
		RemoveObject( "crossbowman1" );
		RemoveObject( "crossbowman2" );
		RemoveObject( "crossbowman3" );
		RemoveObject( "vindicator1" );
		RemoveObject( "vindicator2" );
		RemoveObject( "peasant1" );
		sleep(5);
		MoveCamera( hero_x, hero_y, hero_floor, 31, 0.6, -0.55, 0, 0, 1 );
		UnblockGame();
	end;
end;

function test2()
	DeployReserveHero( "Mardigo", 55, 79, GROUND );
end;

function H55_TriggerDaily()
	if IsObjectExists("footman_shooter") == not nil then
		local x, y, floor = GetObjectPosition( "orc_military_post" );
		if GetDate(DAY) == DAY_TO_START_CATAPULT_HARRASMENT then
			print("day 2");
			--StartAdvMapDialog( ADVMAPSCENE_CATAPULT_HARASSMENT );
			Play2DSound( VOICEOVER_CATAPULT_HARRASMENT );
			ShowMeHit();
			PlayVisualEffect( FIREBALL, '', 'boom', 120, 152, 0, 0, GROUND );
			Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", 120, 152, 0);
			sleep(20);
			MessageBox(PATH.."MsgBox_CatapultHarassment.txt");
		elseif GetDate(DAY) == DAY_TO_START_CATAPULT_HARRASMENT+7 then
			ShowMeHit();
			PlayVisualEffect( FIREBALL, 'orc_military_post' );
			Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", x, y, 0);
			ReplaceDwelling( 'orc_military_post', TOWN_STRONGHOLD, CREATURE_CYCLOP, CREATURE_WYVERN, CREATURE_ORCCHIEF_BUTCHER );
		elseif GetDate(DAY) == DAY_TO_START_CATAPULT_HARRASMENT+14 then
			ShowMeHit();
			PlayVisualEffect( FIREBALL, 'orc_military_post' );
			Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", x, y, 0);
			ReplaceDwelling( 'orc_military_post', TOWN_STRONGHOLD, CREATURE_CYCLOP, CREATURE_WYVERN );
		elseif GetDate(DAY) == DAY_TO_START_CATAPULT_HARRASMENT+21 then
			ShowMeHit();
			PlayVisualEffect( FIREBALL, 'orc_military_post' );
			Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", x, y, 0);
			ReplaceDwelling( 'orc_military_post', TOWN_STRONGHOLD, CREATURE_CYCLOP );
		elseif GetDate(DAY) == DAY_TO_START_CATAPULT_HARRASMENT+28 then
			ShowMeHit();
			PlayVisualEffect( FIREBALL, 'orc_military_post' );
			Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", x, y, 0);
			sleep(5);
			RazeBuilding( 'orc_military_post' );
		end;
	end;
end;

function ShowMeHit()
	BlockGame();
	OpenCircleFog( 129, 149, GROUND, 20, PLAYER_1 );
	MoveCamera( 119, 152, GROUND, 40, 0.68, 4.41, 0, 0, 1 );
	PlayObjectAnimation( "footman_shooter", "attack00", ONESHOT );
	sleep(5);
	PlayObjectAnimation( "damagun_catapult", "rangeattack", ONESHOT );
	sleep(15);
	UnblockGame();
end;

function IsCatapulterTouched()
	while IsObjectExists( "footman_shooter" ) == not nil do sleep(2); end;
	H55_NewDayTrigger = 0;
	PlayVisualEffect( EFFECT_DUST, "damagun_catapult" );
	x,y,floor = GetObjectPosition( "damagun_catapult" );	
	RemoveObject( "damagun_catapult" );	
	sleep(1);
	SetObjectPosition( "damagun_catapult_razed", x, y, floor );
	sleep(1);
	PlayObjectAnimation("damagun_catapult_razed", "death", ONESHOT_STILL );
end;

function OpenDungeonForAI()
	while GetDate(DAY) < DAY_OPEN_DUNGEON_FOR_AI do sleep(10); end;
	SetRegionBlocked( "dungeon", nil, PLAYER_2 );
	SetRegionBlocked( "dungeon", nil, PLAYER_2 );
	print("OpenDungeonForAI: Dungeon is opened fo AI" );
end;

function PlayObjectAnimationIdle( )
	while IsObjectExists( "fire_elemental" )==not nil and IsObjectExists( "water_elemental" )==not nil and voiceoverNotPlayed==0 do
		PlayObjectAnimation( "fire_elemental", "attack00", ONESHOT );
		PlayObjectAnimation( "water_elemental", "attack00", ONESHOT );
		sleep( 15 );
	end;
	BlockGame()
	sleep( GetSoundTimeInSleeps( VOICEOVER_GOTAI_SEES_ELEMENTALS ) );
	UnblockGame();
	while IsObjectExists( "fire_elemental" )==not nil and IsObjectExists( "water_elemental" )==not nil do
		PlayObjectAnimation( "fire_elemental", "attack00", ONESHOT );
		PlayObjectAnimation( "water_elemental", "attack00", ONESHOT );
		sleep( 15 );
	end;
end;

function PlayVoiceOverAboutUnderground()
	if voiceover_about_underground_already_played==0 then
		voiceover_about_underground_already_played=1;
		Play2DSound( VOICEOVER_GOBLIN_ABOUT_DUNGEON );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_dungeon", nil );
		Trigger( OBJECT_TOUCH_TRIGGER, "shipyard", nil );
	end;
end;

function PlayVoiceOverAboutLootZone()
	Play2DSound( VOICEOVER_LOOTZONE );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_lootzone", nil );
end;

function PlayVoiceOverCollectShield( heroName )
	if GetObjectOwner( heroName )==PLAYER_1 then
		Play2DSound( VOICEOVER_COLLECT_ARTIFACTS );
		BlockGame();
		sleep( GetSoundTimeInSleeps( VOICEOVER_COLLECT_ARTIFACTS  ) );
		UnblockGame();
	end;
end;


function InitialSleep()
	BlockGame();
	sleep(3);
	Play2DSound( VOICEOVER_OBJECTIVE_DESTOY_TOWNS_ACTIVE );
	sleep( GetSoundTimeInSleeps( VOICEOVER_OBJECTIVE_DESTOY_TOWNS_ACTIVE ) );
	UnblockGame();
end;

function MsgBoxAboutElementals( heroName )
	if GetObjectOwner( heroName )==PLAYER_1 then
		Trigger( OBJECT_TOUCH_TRIGGER, "mermaid", nil );
		MessageBox( PATH.."MsgBox_MermaidAboutElementals.txt" );
	end;
end;
	
--------------------------------------------------------------------
----------------- MAIN ---------------------------------------------
--------------------------------------------------------------------

H55_CamFixTooManySkills(PLAYER_1,"Gottai");

Trigger( OBJECT_TOUCH_TRIGGER, "demon", "StartDemonScene");
for i=1, PEASANT_HUTS_COUNT do
	Trigger( OBJECT_TOUCH_TRIGGER, "peasant_hut"..i, "BurnPeasantHut" );
end;
for i=1, TOWNS.n do
	Trigger( OBJECT_CAPTURE_TRIGGER, TOWNS[i], "BurnTownOrNot" );
end;
Trigger( OBJECT_TOUCH_TRIGGER, "whirlpool_ground", "EnterGroundWhirlpool");
Trigger( OBJECT_TOUCH_TRIGGER, "whirlpool_underground", "WhirlpoolRejectMessage");
Trigger( OBJECT_TOUCH_TRIGGER, "sw_windmill", "IsCatapultTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "sw_center_blue_town", "IsCatapultTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "sw_bridge_blue1", "IsCatapultTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "sw_bridge_blue2", "IsCatapultTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "sw_bridge_red", "IsCatapultTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "sw_red_town_east", "IsCatapultTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "sw_megamonster", "IsCatapultTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "sw_red_town_west", "IsCatapultTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "fire_elemental", "IsFireElementalAttacked" );
Trigger( OBJECT_TOUCH_TRIGGER, "water_elemental", "IsWaterElementalAttacked" );
Trigger( OBJECT_TOUCH_TRIGGER, "shipyard", "PlayVoiceOverAboutUnderground" );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_lootzone", "PlayVoiceOverAboutLootZone");
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "CatapultShoot" );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ElementalsArea" ,"GotaiSeesElementals" );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_dungeon", "PlayVoiceOverAboutUnderground");
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "voiceover_dungeon_2", "PlayVoiceoverInUnderground");
Trigger( OBJECT_TOUCH_TRIGGER, "mermaid", "MsgBoxAboutElementals" );
Trigger( OBJECT_TOUCH_TRIGGER, "ogreShield", "PlayVoiceOverCollectShield");


startThread( IsCatapulterTouched );
startThread( PlayerWin );
startThread( PeasantHutCrush );
startThread( OutpostCrush );
startThread( DeathKnightCrush );
startThread( RedTownEastCrush );
startThread( RedTownWestCrush );
startThread( Obj_prim1_CaptureAllTowns_completed );
startThread( Obj_prim3_HeroMustSurvive_completed );
startThread( WindmillCrush );
startThread( TownCrush );
startThread( StartCivilWarScene );
startThread( KillEnemyHero );
startThread( OpenDungeonForAI );
--startThread( PlayObjectAnimationIdle, "fire_elemental", "attack00", 15 );
--startThread( PlayObjectAnimationIdle, "water_elemental", "attack00", 15 );
startThread( PlayObjectAnimationIdle );
startThread( GiveTransferrableArtifacts );
startThread( InitialSleep );

print("MAIN: All functions have been started.");