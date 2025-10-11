H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_STAFF_OF_VEXINGS,
ARTIFACT_CLOAK_OF_MOURNING,
ARTIFACT_RING_OF_DEATH,
ARTIFACT_SKULL_HELMET

};

-------------------------------------------------------------------
----------------- TITLE -------------------------------------------
-------------------------------------------------------------------
--       Creation Date: 23.10.06
--              Author: Ivan Myakishev
--       Author e-mail: Ivan.Myakishev@nival.com
--        Project Name: H5A2
--            Map Name: A2C1M3
--  Script Description: MapScript
 --------------------------------------------------------------------
 --------------------------------------------------------------------

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

--------------------------------------------------------------------
----------------- CONSTANTS ----------------------------------------
--------------------------------------------------------------------

POINT_LIGHTS = {{47,11},{45,18},{41,24},{37,39},{29,35},{24,42},{28,48},{21,36},{14,43},{13,36},{8,24},{2,40},{20,26},{22,17},{24,55},{26,61},
				{14,60},{13,68},{5,68},{21,72},{23,81},{13,79},{14,85},{8,86},{11,89},{35,56},{44,57},{51,70},{37,88},{43,84},{54,87},{53,78},
				{56,64},{60,70},{69,61},{77,64},{77,68},{85,72},{69,51},{63,53},{66,37},{62,28},{71,24},{67,20},{79,16},{83,7},{93,17},{104,5},
				{97,14},{100,9},{101,13},{93,38},{118,30},{115,37},{128,31},{130,22},{124,24},{127,43},{119,47},{120,53},{122,64},{111,68},{98,82},{108,82},
				{116,82},{120,88},{121,99},{107,107},{92,90},{84,100},{88,106},{85,121},{76,126},{68,113},{65,107},{71,123},{62,124},{53,119},{41,123},
				{34,128},{31,117},{23,125}, {89,33}, {103,29}};
POINT_LIGHTS.n = table.length(POINT_LIGHTS);

UNDEAD_EFFECTS	= {; grave1={45,56}, tower={14,35}, castle={{6,85},{6,86}}, grave2={45,56}, vamp={38,30}, lich={55,69}, zombie={68,25} };
UNDEAD_EFFECTS.n = table.length( UNDEAD_EFFECTS );

DAY_TO_OPEN_TELEPORT=35-GetDifficulty()*7;
-- EASY = 35, NORMAL=28, HARD=21, HEROIC=14

EFFECT_UNDEAD_GLOW = "/Effects/_(Effect)/Towns/Necropolis/UnearthedGrave01.xdb#xpointer(/Effect)";
EFFECT_PLAGUE = "/Effects/_(Effect)/Spells/Plague.xdb#xpointer(/Effect)";
EFFECT_RUINED_TOWER = "/Effects/_(Effect)/Buildings/Dwellings/Necropolis/Ruined_Tower.xdb#xpointer(/Effect)";

VOICEOVER_TOWER_CONVERTED = "/Maps/Scenario/A2C1M3/C1M3_VO5_Ornella_01sound.xdb#xpointer(/Sound)";
VOICEOVER_MILITARY_POST_CONVERTED = "/Maps/Scenario/A2C1M3/C1M3_VO6_Ornella_01sound.xdb#xpointer(/Sound)";
VOICEOVER_MEET_LICHES = "/Maps/Scenario/A2C1M3/C1M3_VO4_Lich_01sound.xdb#xpointer(/Sound)";
VOICEOVER_MISSION_START = "/Maps/Scenario/A2C1M3/C1M3_VO2_Ornella_01sound.xdb#xpointer(/Sound)";

SOUND_EFFECT_PLAGUE = "/Sounds/_(Sound)/Spells/Plague.xdb#xpointer(/Sound)";


HAVEN_TOWNS = {"SouthHavenTown", "EastHavenTown", "WestHavenTown"};
HAVEN_TOWNS.n = table.length( HAVEN_TOWNS );

NECROPOLIS = "Necropolis";

ARANTIR = "Arantir";
ORNELLA = "OrnellaNecro"; 
ENEMY_HERO_ORLANDO = "Orlando";

ZOMBIE_COUNT = 50;
WALKING_DEAD_COUNT = 60;
VAMPIRES_COUNT = 11;
LICHES_COUNT = 7;
SKELETONS_COUNT = 40;
NOSFERATU_COUNT = 14;

ZOMBIE_TAX = 300; -- константа для количества денег, которые каждый ход платят зомби

PATH = "Maps/Scenario/A2C1M3/"

-----------------------------------------------------------
--                 ADVMAP SCENES                         --
-----------------------------------------------------------
ADVMAPSCENE_ORNELLA_JOINS_VAMPIRES = 0;--  После взаимодействия со стеком крестьян, превращающихся в вампиров в первой деревне
ADVMAPSCENE_ENCOUNTER_WITH_RED_HEAVEN = 1;
ADVMAPSCENE_ORNELLA_MEETS_ARANTIR = 2;-- После уничтожения армии Red Heaven охраняющей перевал, откуда должен прийти Арантир
ADVMAPSCENE_END_OF_MISSION = 3; --Сцена про Нелеха убегающего от Орнеллы и Арантира
ADVMAPSCENE_ORNELLA_JOINS_WRAITHES = 4; -- После выполнения задания "собрать всех кричей некрополиса" (присоединение бонусных wraith'ов)
ADVMAPSCENE_ORNELLA_MEET_ZOMBIES = 5;--Орнелла встречается с зомби и вампирами в третьей деревне

--------------------------------------------------------------------
----------------- VARIABLES ----------------------------------------
--------------------------------------------------------------------

heroName_lichesJoin = "Arantir";
firstTownCaptured = 0;
graveyard1_first_visit = 0;
graveyard2_first_visit = 0;
heroWhoFoundLastCreature = ORNELLA;
x_vampire, y_vampire, floor_vampire = GetObjectPosition( "vampire" );
joinedCreaturesCount = 0;
firstNecropolisCapturing = 0;
isOkPressed = 0;
isFirstZombieVisit = 0;
heroWhoTouchesMonster  = "hz";
isMilitaryPostVoiceoverFinished = 1;
isTowerVoiceoverFinished = 1;
heroWhoAttacksAngels ="";
return_x, return_y, return_floor = GetObjectPosition( ORNELLA );

--------------------------------------------------------------------
----------------- START MAP SETTINGS -------------------------------
--------------------------------------------------------------------

--MakeHeroReturnToTavernAfterDeath("Nathaniel", not nil, 0);
--MakeHeroReturnToTavernAfterDeath("Giar", not nil, 0);
--MakeHeroReturnToTavernAfterDeath("Glen", not nil, 0);
--MakeHeroReturnToTavernAfterDeath("Ving", not nil, 0);
--MakeHeroReturnToTavernAfterDeath("Sarge", not nil, 0);
--MakeHeroReturnToTavernAfterDeath("Maeve", not nil, 0);
--MakeHeroReturnToTavernAfterDeath("Brem", not nil, 0);
--MakeHeroReturnToTavernAfterDeath("Christian", not nil, 0);
--MakeHeroReturnToTavernAfterDeath("RedHeavenHero01", not nil, 0);
--MakeHeroReturnToTavernAfterDeath("RedHeavenHero02", not nil, 0);
--MakeHeroReturnToTavernAfterDeath("RedHeavenHero03", not nil, 0);

SetObjectEnabled( "lich", nil );
SetObjectEnabled( "vampire", nil );
SetObjectEnabled( "zombie", nil );
SetObjectEnabled( "lich", nil );
SetObjectEnabled( "FootmanTower", nil );
SetObjectEnabled( "Castle", nil );

-- REGIONS
SetRegionBlocked( "meeting", not nil, PLAYER_2 );
SetRegionBlocked( "ArantirRegion", not nil, PLAYER_2 );
SetRegionBlocked( "ArantirRegion", not nil, PLAYER_1 );
SetRegionBlocked("OrnellaRegion", not nil, PLAYER_2);
SetRegionBlocked("OrnellaRegion", not nil, PLAYER_1);
SetRegionBlocked( "TeleportBlocker", not nil, PLAYER_2 );
SetRegionBlocked( "seraph_area_blocker", not nil );
SetRegionBlocked( "scene_ornella", not nil );

-- START SPELLS
TeachHeroSpell( ORNELLA, SPELL_WEAKNESS );
TeachHeroSpell( ORNELLA, SPELL_PLAGUE );
TeachHeroSpell( ORNELLA, SPELL_SLOW );

-- BOSS AI DISABLED
EnableHeroAI( "Orlando", nil );
SetHeroRoleMode( "Orlando", HERO_ROLE_MODE_HERMIT );

SetHeroesExpCoef(0.9);

if GetDifficulty() == DIFFICULTY_EASY then
	difLevel = 2;
	SetTownBuildingLimitLevel( "SouthHavenTown", TOWN_BUILDING_DWELLING_7, 0 );
	SetTownBuildingLimitLevel( "EastHavenTown", TOWN_BUILDING_DWELLING_7, 0 );
	SetTownBuildingLimitLevel( "WestHavenTown", TOWN_BUILDING_DWELLING_7, 0 );
	SetTownBuildingLimitLevel( "SouthHavenTown",TOWN_BUILDING_DWELLING_6, 0 );
	SetTownBuildingLimitLevel( "EastHavenTown", TOWN_BUILDING_DWELLING_6, 0 );
	SetTownBuildingLimitLevel( "WestHavenTown", TOWN_BUILDING_DWELLING_6, 0 );
	SetTownBuildingLimitLevel( "SouthHavenTown",TOWN_BUILDING_DWELLING_5, 0 );
	SetTownBuildingLimitLevel( "EastHavenTown", TOWN_BUILDING_DWELLING_5, 0 );
	SetTownBuildingLimitLevel( "WestHavenTown", TOWN_BUILDING_DWELLING_5, 0 );
	SetTownBuildingLimitLevel( "SouthHavenTown", TOWN_BUILDING_FORT, 1 );
	SetTownBuildingLimitLevel( "EastHavenTown", TOWN_BUILDING_FORT, 1 );
	SetTownBuildingLimitLevel( "WestHavenTown", TOWN_BUILDING_FORT, 1 );
	print ("Difficulty level is EASY");
elseif GetDifficulty() == DIFFICULTY_NORMAL then
	difLevel = 2;
	SetTownBuildingLimitLevel( "SouthHavenTown", TOWN_BUILDING_DWELLING_7, 0 );
	SetTownBuildingLimitLevel( "EastHavenTown", TOWN_BUILDING_DWELLING_7, 0 );
	SetTownBuildingLimitLevel( "WestHavenTown", TOWN_BUILDING_DWELLING_7, 0 );
	SetTownBuildingLimitLevel( "SouthHavenTown", TOWN_BUILDING_DWELLING_6, 0 );
	SetTownBuildingLimitLevel( "EastHavenTown", TOWN_BUILDING_DWELLING_6, 0 );
	SetTownBuildingLimitLevel( "WestHavenTown", TOWN_BUILDING_DWELLING_6, 0 );
	SetTownBuildingLimitLevel( "SouthHavenTown", TOWN_BUILDING_FORT, 2 );
	SetTownBuildingLimitLevel( "EastHavenTown", TOWN_BUILDING_FORT, 2 );
	SetTownBuildingLimitLevel( "WestHavenTown", TOWN_BUILDING_FORT, 2 );
	print ("Difficulty level is NORMAL");
elseif GetDifficulty() == DIFFICULTY_HARD then
	difLevel = 3;
	SetTownBuildingLimitLevel( "SouthHavenTown", TOWN_BUILDING_DWELLING_7, 0 );
	SetTownBuildingLimitLevel( "EastHavenTown", TOWN_BUILDING_DWELLING_7, 0 );
	SetTownBuildingLimitLevel( "WestHavenTown", TOWN_BUILDING_DWELLING_7, 0 );
	print ("Difficulty level is HARD");
elseif GetDifficulty() == DIFFICULTY_HEROIC then
	difLevel = 4;
	print ("Difficulty level is HEROIC");
end;

AddHeroCreatures( ORNELLA, CREATURE_SKELETON_ARCHER, 140-difLevel*25);
AddHeroCreatures( ORNELLA, CREATURE_ZOMBIE, 50-difLevel*8);
AddHeroCreatures( ORNELLA, CREATURE_VAMPIRE, 10-difLevel*2);

AddHeroCreatures( ENEMY_HERO_ORLANDO, CREATURE_SERAPH, 1*difLevel);
AddHeroCreatures( ENEMY_HERO_ORLANDO, CREATURE_CHAMPION, 1*difLevel);
AddHeroCreatures( ENEMY_HERO_ORLANDO, CREATURE_ZEALOT, 3*difLevel);
AddHeroCreatures( ENEMY_HERO_ORLANDO, CREATURE_BATTLE_GRIFFIN, 4*difLevel);
AddHeroCreatures( ENEMY_HERO_ORLANDO, CREATURE_VINDICATOR, 17*difLevel);
AddHeroCreatures( ENEMY_HERO_ORLANDO, CREATURE_LONGBOWMAN, 11*difLevel*2);
AddHeroCreatures( ENEMY_HERO_ORLANDO, CREATURE_LANDLORD, 30*difLevel);

SetPlayerStartResource( PLAYER_1, GOLD, 15500 - difLevel*1500 );
SetPlayerStartResource( PLAYER_1, ORE, 22 - difLevel*3 );
SetPlayerStartResource( PLAYER_1, WOOD, 22 - difLevel*3 );
SetPlayerStartResource( PLAYER_1, GEM, 11 - difLevel*2 );
SetPlayerStartResource( PLAYER_1, CRYSTAL, 9 - difLevel*2 );
SetPlayerStartResource( PLAYER_1, SULFUR, 9 - difLevel*2 );
SetPlayerStartResource( PLAYER_1, MERCURY, 16 - difLevel*2 );

DenyAIHeroFlee( ARANTIR, not nil );
DenyAIHeroFlee( ORNELLA, not nil );

SetObjectiveState( "prim1_MeetArantir", OBJECTIVE_ACTIVE );
--------------------------------------------------------------------
----------------- FUNCTIONS ----------------------------------------
--------------------------------------------------------------------

function GiveTransferribleArifacts()
    InitAllSetArtifacts( "A2C1M3" );
    --LoadHeroAllSetArtifacts( ORNELLA, "A2C1M1" );
end

function SetLight( level, time )
	SetAmbientLight( GROUND, "fog_light_level"..level, not nil, time);
end;

function MoveHeroRealTimeAndReachPoint( heroName, x, y, floor )
	moveCost = CalcHeroMoveCost( heroName, x, y, GROUND );
	ChangeHeroStat( heroName, STAT_MOVE_POINTS, moveCost );
	sleep(1);
	MoveHeroRealTime( heroName, x, y, GROUND );
end;

function SetPointLights( level )
	for i=1, POINT_LIGHTS.n do
		SetObjectFlashlight("light"..i, "undead_light"..level);
	end;
end;

function ResetPointLights()
	for i=1, POINT_LIGHTS.n do
		SetObjectFlashlight( "light"..i );
	end;
end;


function testLightsIn( delay )
	for i=1, 8 do
		SetObjectFlashlight("graveyard_1", "necrolight"..i);
		sleep(delay);
	end;
end;
function testLightsOut( delay )
	for i=8, 1, -1 do
		SetObjectFlashlight("graveyard_1", "necrolight"..i);
		sleep(delay);
	end;
end;
function testLightsInOut( delay )
	while 1 do
		for i=1, 8 do
			SetObjectFlashlight("graveyard_1", "necrolight"..i);
			sleep(delay);
		end;
		for i=7, 2, -1 do
			SetObjectFlashlight("graveyard_1", "necrolight"..i);
			sleep(delay);
		end;
	sleep(1);
	end;
end;

function CreatePointLights( level )
	for i=1, POINT_LIGHTS.n do
		CreateStatic("light"..i,"/MapObjects/Dirt/Misc/Will_o_the_wisp.(AdvMapStaticShared).xdb#xpointer(/AdvMapStaticShared)",POINT_LIGHTS[i][1],POINT_LIGHTS[i][2], GROUND);
	end;
	sleep( 1 );
	SetPointLights( level );
end;

print("variables defined");

function DisablePlayerHeroHiring()
	while 1 do
		while table.length( GetPlayerHeroes( PLAYER_1 ) ) < 6 do sleep(1); end;
		
		for race_id = 0, 7 do
			AllowPlayerTavernRace( PLAYER_1, race_id, 0 );
		end;
		
		while table.length( GetPlayerHeroes( PLAYER_1 ) ) >= 6 do sleep(1); end;
		
		for race_id = 0, 7 do
			AllowPlayerTavernRace( PLAYER_1, race_id, 1 );		
		end;
		sleep(1);
	end;
end;

------------------------------------------------------------------------
--     Function Name: startInitialConditions() 
--     Description: Показывает точку встречи с Арантиром
------------------------------------------------------------------------
function startInitialConditions()
	sleep(5);
	OpenCircleFog( 120, 63, GROUND, 12, PLAYER_1 );
	MoveCamera( 120, 63, GROUND, 50, 1.3, 0, 1, 1, 1 ); -- Показываем игроку точку встречи с Арантиром
	sleep(15);
	x,y = GetObjectPosition( ORNELLA );
	MoveCamera( x, y, GROUND, 50, 1.3, 0, 1, 1, 1);
end;

------------------------------------------------------------------------
--     Function Name: IsOrnellaMeetArantir( heroName ) heroName - имя героя, вошедшего в регион
--     Description: Запускается при входе любого героя игрока в регион встречи а Арантиром
------------------------------------------------------------------------

function IsOrnellaMeetArantir()
	while IsObjectExists( "angel" ) == not nil do sleep(5); end;
	if heroWhoAttacksAngels ~= ORNELLA then
		SetRegionBlocked( "scene_ornella", nil );
		return_x, return_y, return_floor = GetObjectPosition( ORNELLA );
		scene_x, scene_y = RegionToPoint( "scene_ornella" );
		SetObjectPosition( ORNELLA, scene_x, scene_y, GROUND );
		sleep(1);
		SetObjectRotation( ORNELLA, 45 );
	end;
	SetObjectiveState( "prim1_MeetArantir", OBJECTIVE_COMPLETED );
	SetRegionBlocked( "meeting", nil, PLAYER_2 );
	DeployReserveHero( ARANTIR, 83, 3, GROUND );
	sleep(1);
	H55_CamFixTooManySkills(PLAYER_1,"Arantir");
	LoadHeroAllSetArtifacts( ARANTIR, "A2C1M2" );
	sleep(1);
	SetObjectRotation( ARANTIR, 180 );
	sleep(7);
	SetRegionBlocked( "seraph_area_blocker", nil );
	MoveHeroRealTimeAndReachPoint( ARANTIR, 83, 4 );
	SetObjectiveState( "prim4_ArantirMustSurvive", OBJECTIVE_ACTIVE );
	StartAdvMapDialog( ADVMAPSCENE_ORNELLA_MEETS_ARANTIR, "ReturnOrnella" );
	SetPlayerResource( PLAYER_1, GOLD, GetPlayerResource( PLAYER_1, GOLD )+40000 );-- Арантир приходит с деньгами и ресурсами. Выдаем их игроку
	SetPlayerResource( PLAYER_1, ORE, GetPlayerResource( PLAYER_1, ORE )+40 );
	SetPlayerResource( PLAYER_1, WOOD, GetPlayerResource( PLAYER_1, WOOD )+40 );
	SetPlayerResource( PLAYER_1, CRYSTAL, GetPlayerResource( PLAYER_1, CRYSTAL )+20 );
	SetPlayerResource( PLAYER_1, GEM, GetPlayerResource( PLAYER_1, GEM )+20 );
	SetPlayerResource( PLAYER_1, SULFUR, GetPlayerResource( PLAYER_1, SULFUR )+20 );
	SetPlayerResource( PLAYER_1, MERCURY, GetPlayerResource( PLAYER_1, MERCURY )+30 );		
	--startThread( IsAllHavenTownsCaptured );
	Trigger( OBJECT_CAPTURE_TRIGGER, "WestHavenTown", "IsMainTownCaptured" );
	startThread( ArantirMustSurvive );
	SetLight( 2, 3 );
	sleep(25);
	CreatePointLights( 2 );
	SetObjectiveState( "prim2_CaptureAllTowns", OBJECTIVE_ACTIVE );
end;


function ReturnOrnella()
	if heroWhoAttacksAngels ~= ORNELLA then
		SetObjectPosition( ORNELLA, return_x, return_y, return_floor );
	end;
end;
------------------------------------------------------------------------
--     Function Name: IsAllHavenTownsCaptured() 
--     Description: Проверяет все ли города противника на карте захвачены
------------------------------------------------------------------------
function IsAllHavenTownsCaptured()
	SetObjectiveState( "prim2_CaptureAllTowns", OBJECTIVE_ACTIVE );
	repeat
		capturedTowns = 0;
		for i=1, HAVEN_TOWNS.n do
			if GetObjectOwner(HAVEN_TOWNS[i]) == PLAYER_1 then
				capturedTowns = capturedTowns  + 1;
			end;
		end;
		if capturedTowns == 1 and firstTownCaptured == 0 then
			firstTownCaptured = 1;
			SetLight( 3, 3 );
			sleep(25);
			SetPointLights( 3 );
			StartDialogScene( "/DialogScenes/A2C1/M3/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		end;
		sleep(1);
	until capturedTowns == 3;
	print("IsAllHavenTownsCaptured: all towns are captured");	
	--SetObjectiveState( "prim2_CaptureAllTowns", OBJECTIVE_COMPLETED );
end;

function IsMainTownCaptured( oldOwner, newOwner, heroName )
	if newOwner == PLAYER_1 then
		SetObjectiveState( "prim2_CaptureAllTowns", OBJECTIVE_COMPLETED );
		print( "Main enemy town was captured!" );
	end;
end;

------------------------------------------------------------------------
--     Function Name: PlayerWin() 
--     Description: Комплитит миссию, если задания "Встретиться с Арантиром" и "Захватить все города" выполнены
------------------------------------------------------------------------
function PlayerWin()
	while GetObjectiveState( "prim1_MeetArantir" ) ~= OBJECTIVE_COMPLETED or
		  GetObjectiveState( "prim2_CaptureAllTowns" ) ~= OBJECTIVE_COMPLETED
		do
		 sleep(5);
	end;
	SetObjectRotation( ARANTIR, 0 );
	SetRegionBlocked("ArantirRegion", nil, PLAYER_1);
	SetRegionBlocked("OrnellaRegion", nil, PLAYER_1);
	SetObjectPosition( ARANTIR, 23, 127, GROUND );
	SetObjectPosition( ORNELLA, 23, 123, GROUND );
	StartAdvMapDialog( ADVMAPSCENE_END_OF_MISSION, "win" );
end;

function win()
	SaveHeroAllSetArtifactsEquipped( ORNELLA, "A2C1M3" );
	SaveHeroAllSetArtifactsEquipped( ARANTIR, "A2C1M3" );
	sleep(5); --H55 fix
	Win( PLAYER_1 );
end;

------------------------------------------------------------------------
--     Function Name: ArantirMustSurvive() 
--     Description: Фейлит миссию, если герой Арантир уничтожен
------------------------------------------------------------------------
function ArantirMustSurvive()
	sleep(5);
	while IsHeroAlive( ARANTIR ) == not nil do sleep(10); end;
	print("Our glorious hero Arantir is dead");
	Loose(PLAYER_1);
end;

------------------------------------------------------------------------
--     Function Name: OrnellaMustSurvive() 
--     Description: Фейлит миссию, если герой Орнелла уничтожен
------------------------------------------------------------------------
function OrnellaMustSurvive()
	while IsHeroAlive( ORNELLA ) == not nil do sleep(10); end;
	print("Our glorious hero Ornella is dead");
	Loose(PLAYER_1);
end;

------------------------------------------------------------------------
--     Function Name: IsZombiesTouched() 
--     Description: Запускается при взаимодействии игрока с зомби - жителями третьей деревни. В появившемся окне игрока спрашивают,
--     желает ли он, чтобы зомби присоединились к его армии или предпочитает брать с них дань? В случае ответа ОК, запускается функция ZombiesWantJoin
--	   в случает ответа NO запускается функция ZombiesWantPayTax.
------------------------------------------------------------------------

function IsZombiesTouched( heroName, objectName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		if isFirstZombieVisit == 0 then
			isFirstZombieVisit = 1;
			BlockGame();	
			x_zombie, y_zombie, floor_zombie = GetObjectPosition( "zombie" );
			PlayVisualEffect( EFFECT_PLAGUE, "zombie" );
			Play2DSound( SOUND_EFFECT_PLAGUE );
			sleep(3);
			RemoveObject( "zombie" );
			RemoveObject("selection_zombie");
			sleep(1);
			CreateMonster( "not nil_zombie", CREATURE_ZOMBIE, ZOMBIE_COUNT-difLevel*8, x_zombie, y_zombie, floor_zombie , MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 0 );
			sleep(1);
			SetObjectEnabled( "not nil_zombie", nil );
			sleep(15);
			--MessageBox( PATH.."MessageBox12_LazyZombieAnswer.txt", "NosferatuDeploy" );
			startThread( NosferatuDeploy );
			Trigger( OBJECT_TOUCH_TRIGGER, "not nil_zombie", "IsZombiesTouched" );
			UnblockGame();
		else
			MessageBox( PATH.."MessageBox12_LazyZombieAnswer.txt" );
		end;
	end;
end;

function NosferatuDeploy()
	BlockGame()
	CreateMonster( "nosferatu", CREATURE_NOSFERATU, NOSFERATU_COUNT-difLevel*2, 70, 24, GROUND, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 0 );
	sleep(1);
	SetObjectEnabled( "nosferatu", nil );
	sleep(1);
	Trigger( OBJECT_TOUCH_TRIGGER, "nosferatu", "IsNosferatuTouched" );
	UnblockGame();
	StartAdvMapDialog( ADVMAPSCENE_ORNELLA_MEET_ZOMBIES );
end;

function IsNosferatuTouched( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		heroName_zombiesJoin = heroName;
		QuestionBox( PATH.."MessageBox13_NosferatuFirstVisit.txt", "ZombiesWantJoin", "ZombiesWantPayTax"  );
	end;
end;

------------------------------------------------------------------------
--     Function Name: ZombiesWantJoin() 
--     Description: Если в функции IsZombiesTouched() игрок ответил "да", к армии игрока присоединяются зомби.
------------------------------------------------------------------------
function ZombiesWantJoin()
	BlockGame();
	Trigger( OBJECT_TOUCH_TRIGGER, "not nil_zombie", "RedirectToNosferatu" );
	Trigger( OBJECT_TOUCH_TRIGGER, "nosferatu", nil );
	SetObjectEnabled( "not nil_zombie", not nil );
	sleep(1);
	UnblockGame();

	x_zombie, y_zombie = GetObjectPosition("not nil_zombie");
	MoveHeroRealTimeAndReachPoint( heroName_zombiesJoin, x_zombie, y_zombie, GROUND );
end;

function RedirectToNosferatu()
	SetObjectEnabled( "nosferatu", not nil );
	startThread( NosferatuJoin );
end;

function NosferatuJoin()
	-- Wait zombies joined or defeated
	--
	while IsObjectExists("not nil_zombie") == not nil and IsObjectExists("nosferatu") == not nil do
		sleep(2);
	end

	-- Go to nosferatu
	--
	if IsObjectExists("nosferatu") == not nil then
		x_nosferatu, y_nosferatu = GetObjectPosition( "nosferatu" );
		MoveHeroRealTimeAndReachPoint( heroName_zombiesJoin, x_nosferatu, y_nosferatu, GROUND );
	end

	-- No matter what happens increment joined and etc.
	--
	BlockGame();
	joinedCreaturesCount = joinedCreaturesCount + 1; --Увеличиваем счетчик собранных кричей Некрополиса на единицу
	SetObjectiveProgress( "sec2_JoinNecropolisCreatures", joinedCreaturesCount, PLAYER_1 );
	sleep(1);
	heroWhoFoundLastCreature = heroName_zombiesJoin;
	TransformToNecroDwelling( "ZombieVillageHouse01", CREATURE_SKELETON, CREATURE_SKELETON_WARRIOR, SKELETONS_COUNT - difLevel*5 );
	sleep(3);
	TransformToNecroDwelling( "ZombieVillageHouse02", CREATURE_SKELETON, CREATURE_SKELETON_WARRIOR, SKELETONS_COUNT - difLevel*5 );
	UnblockGame();
end;

------------------------------------------------------------------------
--     Function Name: ZombiesWantPayTax() 
--     Description: Если в функции IsZombiesTouched() игрок ответил "нет", запускается триггер на наступление нового дня.
------------------------------------------------------------------------
function ZombiesWantPayTax()
	H55_NewDayTrigger = 1;
	--Trigger(NEW_DAY_TRIGGER, "PayZombieTax");
end;

------------------------------------------------------------------------
--     Function Name: PayZombieTax() 
--     Description: Каждый день зомби платят игроку по 200 золота.
------------------------------------------------------------------------
function H55_TriggerDaily()
	if IsObjectExists("not nil_zombie") == not nil then
		SetPlayerResource( PLAYER_1, GOLD, GetPlayerResource( PLAYER_1, GOLD )+ZOMBIE_TAX );
		print("zombies pay tax. +300 gold");
	else
		H55_NewDayTrigger = 0;
		--Trigger(NEW_DAY_TRIGGER, nil);
	end;
end;

------------------------------------------------------------------------
--     Function Name: IsVampiresTouched() 
--     Description: Запускается при взаимодействии игрока со стеком крестьян в первой деревне.
------------------------------------------------------------------------
function IsVampiresTouched( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
	--StartDialogScene(); -- здесь должна быть диалоговая сцена про присоединение вампиров и рассказ о некрополисе поблизости
	BlockGame();	
	x_vampire, y_vampire, floor_vampire = GetObjectPosition( "vampire" );
	PlayVisualEffect( EFFECT_PLAGUE, "vampire" );
	Play2DSound( SOUND_EFFECT_PLAGUE );
	sleep(3);
	RemoveObject( "vampire" );
	RemoveObject("selection_vampire");
	sleep(1);
	CreateMonster( "not nil_vampire", CREATURE_VAMPIRE, VAMPIRES_COUNT, x_vampire, y_vampire, floor_vampire, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 0 );
	Trigger( OBJECT_CAPTURE_TRIGGER, "Necropolis", "IsNecropolisCaptured" );
	sleep(15);
	UnblockGame();
	startThread( VampiresWantJoin );
	end;
end;

function TransformToNecroDwelling( objectName, creatureType, guardType, guardCount )
	guardName = "creature_"..objectName;
	ReplaceDwelling( objectName, TOWN_HEAVEN, creatureType );
	SetObjectEnabled( objectName, not nil );
	OverrideObjectTooltipNameAndDescription( objectName, "", "Maps/Scenario/A2C1M3/SkeletonPeasantHut_Description.txt");
	local x,y,floor = GetObjectPosition( objectName );
	PlayVisualEffect( EFFECT_RUINED_TOWER, objectName );
	SetObjectOwner(  objectName, PLAYER_1 );
	sleep(5);
	if IsObjectExists( guardName )==not nil then
		angle = 0;
		if objectName == "VampireVillageHouse01" then
			angle = 90;
		elseif objectName == "VampireVillageHouse02" then
			angle = 270;
		elseif objectName == "LichVillageHouse01" then
			angle = 180;
		elseif objectName == "LichVillageHouse02" then
			angle = 270;
		elseif objectName == "ZombieVillageHouse01" then
			angle = 90;
		end;
		local x_guard, y_guard, floor_guard = GetObjectPosition( guardName );
		PlayVisualEffect( EFFECT_PLAGUE, guardName );
		Play2DSound( SOUND_EFFECT_PLAGUE );
		sleep(3);
		RemoveObject( guardName );
		sleep(1);
		CreateMonster( "not nil_"..guardName, guardType, guardCount, x_guard, y_guard, floor_guard, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, angle );
		sleep(1);
		PlayObjectAnimation( "not nil_"..guardName, "happy", ONESHOT );
	end;
end;


function IsOkPressed()
	isOkPressed = 1;
end;
------------------------------------------------------------------------
--     Function Name: VampiresWantJoin( heroName ) 
--     Description: К армии героя игрока присоединяются вампиры.
------------------------------------------------------------------------
function VampiresWantJoin()
	sleep(1);
	--MessageBox( "Maps/Scenario/A2C1M3/MessageBox04_VampireMessage.txt", "IsOkPressed" );
	StartAdvMapDialog( ADVMAPSCENE_ORNELLA_JOINS_VAMPIRES, "IsOkPressed" );
	while isOkPressed == 0 do sleep(1); end;
	isOkPressed = 0;
	joinedCreaturesCount = joinedCreaturesCount + 1; --Увеличиваем счетчик собранных кричей Некрополиса на единицу
	MoveHeroRealTimeAndReachPoint( ORNELLA, x_vampire, y_vampire, GROUND );
	
	while IsObjectExists("not nil_vampire")==not nil do sleep(1); end;
	BlockGame();
	print("VampiresWantJoin: Game is blocked");
	
	TransformToNecroDwelling( "VampireVillageHouse01", CREATURE_SKELETON, CREATURE_SKELETON, SKELETONS_COUNT - difLevel*5 );
	sleep(3);
	TransformToNecroDwelling( "VampireVillageHouse02", CREATURE_SKELETON, CREATURE_SKELETON, SKELETONS_COUNT - difLevel*5 );
	sleep(15);
	
	Ornella_x, Ornella_y = GetObjectPosition( ORNELLA ); 
	Necropolis_x, Necropolis_y = GetObjectPosition( NECROPOLIS ); 
	
	OpenCircleFog( Necropolis_x, Necropolis_y, GROUND, 12, PLAYER_1 );
	MoveCamera( Necropolis_x, Necropolis_y, GROUND, 50, 1.3, 0, 1, 1, 1 ); -- Показываем игроку Некрополис
	sleep(15);
	
	MoveCamera( Ornella_x, Ornella_y , GROUND, 50, 1.3, 0, 1, 1, 1);
	UnblockGame();
	print("VampiresWantJoin: Game is unblocked");
	
	--ShowFlyingSign( "Maps/Scenario/A2C1M3/MessageBox06_plusSkeletons.txt", ORNELLA, PLAYER_1, 7 );
	
	SetObjectiveState( "sec1_CaptureNecropolis", OBJECTIVE_ACTIVE );
	sleep(1);
	SetObjectiveState( "sec2_JoinNecropolisCreatures", OBJECTIVE_ACTIVE );
	sleep(1);
	SetObjectiveProgress( "sec2_JoinNecropolisCreatures", joinedCreaturesCount, PLAYER_1 );
	Trigger( OBJECT_CAPTURE_TRIGGER, NECROPOLIS, "IsNecropolisCaptured" );
	
	startThread( IsCreaturesJoined ); 
end;


------------------------------------------------------------------------
--     Function Name: IsLichesTouched( heroName ) 
--     Description: Запускается при взаимодействии игрока со стеком крестьян во второй деревне.
------------------------------------------------------------------------
function IsLichesTouched( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then		
		heroName_lichesJoin = heroName; -- в функции LichesWantJoin() необходимо знать имя героя, к которому мы будем присоединять личей
		BlockGame();	
		x_lich, y_lich, floor_lich = GetObjectPosition( "lich" );
		PlayVisualEffect( EFFECT_PLAGUE, "lich" );
		Play2DSound( SOUND_EFFECT_PLAGUE );
		sleep(3);
		RemoveObject( "lich" );
		RemoveObject("selection_lich");
		sleep(1);
		CreateMonster( "not nil_lich", CREATURE_LICH, LICHES_COUNT-difLevel, x_lich, y_lich, floor_lich, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 0 );
		Play2DSound( VOICEOVER_MEET_LICHES );
		sleep(15);
		UnblockGame();
		startThread( LichesWantJoin );
	end;
end;

------------------------------------------------------------------------
--     Function Name: LichesWantJoin() 
--     Description: Присоединение личей к армии героя игрока во второй деревне.
------------------------------------------------------------------------
function LichesWantJoin()
	--MessageBox("Maps/Scenario/A2C1M3/MessageBox03_lichMessage.txt", "IsOkPressed");
	--StartAdvMapDialog( ADVMAPSCENE_ORNELLA_JOINS_LICHES, "IsOkPressed" );
	--while isOkPressed == 0 do sleep(1); end;
	--isOkPressed = 0;
	joinedCreaturesCount = joinedCreaturesCount + 1; --Увеличиваем счетчик собранных кричей Некрополиса на единицу
	x_lich, y_lich, floor_lich = GetObjectPosition( "not nil_lich" );
	MoveHeroRealTimeAndReachPoint( heroName_lichesJoin, x_lich, y_lich, GROUND );
	heroWhoFoundLastCreature = heroName_lichesJoin;
	SetObjectiveProgress( "sec2_JoinNecropolisCreatures", joinedCreaturesCount, PLAYER_1 );
	TransformToNecroDwelling( "LichVillageHouse01", CREATURE_SKELETON, CREATURE_SKELETON_ARCHER, SKELETONS_COUNT - difLevel*5 );
	sleep(3);
	TransformToNecroDwelling( "LichVillageHouse02", CREATURE_SKELETON, CREATURE_SKELETON_ARCHER, SKELETONS_COUNT - difLevel*5 );
end;


------------------------------------------------------------------------
--     Function Name: IsNecropolisCaptured(oldOwner, newOwner, heroName) 
--     Description: Если Некрополис захвачен игроком - комплитить задание "Захватить Некрополис", если захвачен АИ - выдавать задание снова
------------------------------------------------------------------------
function IsNecropolisCaptured( oldOwner, newOwner, heroName )
	if newOwner == PLAYER_1 then
		if oldOwner ~= PLAYER_1 then
			SetObjectiveState( "sec1_CaptureNecropolis", OBJECTIVE_COMPLETED ); -- комплитим, если захватил игрок
			if firstNecropolisCapturing == 0 then
				firstNecropolisCapturing = 1;
				GiveArtefact( heroName, ARTIFACT_BONESTUDDED_LEATHER );
			end;
		end;
	else
		SetObjectiveState(  "sec1_CaptureNecropolis", OBJECTIVE_ACTIVE );-- выдаем снова, если АИ отбил город
	end;
end;


------------------------------------------------------------------------
--     Function Name: IsCreaturesJoined() 
--     Description: Комлпитит дополнительное задание "Собрать нежить", 
--	   когда количество найденных стеков созданий (joinedCreaturesCount) некрополиса достигнет 6-ти.
------------------------------------------------------------------------
function IsCreaturesJoined() 
	while joinedCreaturesCount < 7 do sleep(10); end;
	repeat sleep(2); until isMilitaryPostVoiceoverFinished == 1;
	repeat sleep(2); until isTowerVoiceoverFinished == 1;
	BlockGame();
	SetObjectiveState( "sec2_JoinNecropolisCreatures", OBJECTIVE_COMPLETED );
	local x,y = GetObjectPosition( heroWhoFoundLastCreature );
	CreateMonster( "wraith", CREATURE_WRAITH, 13 - difLevel, x,y, GROUND, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN );
	sleep(1);
	--SetObjectRotationToObject( "wraith", heroWhoFoundLastCreature );
	--SetObjectRotationToObject( heroWhoFoundLastCreature , "wraith" );
	UnblockGame();
	OverrideAdvMapDialogPos( ADVMAPSCENE_ORNELLA_JOINS_WRAITHES, GROUND, x, y, 7 );	
	StartAdvMapDialog( ADVMAPSCENE_ORNELLA_JOINS_WRAITHES, "JoinWraiths" );
	--MessageBox( PATH.."WraithsWantJoin.txt", "JoinWraiths" );		
end;

function JoinWraiths()
	x_monster, y_monster = GetObjectPosition( "wraith" );
	MoveHeroRealTimeAndReachPoint( heroWhoFoundLastCreature, x_monster, y_monster, GROUND );
end;

------------------------------------------------------------------------
--     Function Name: RazeBuildingWithEffects() 
--     Description: Унитожает объект objecName, проигрывая при этом два эффекта
------------------------------------------------------------------------
function RazeBuildingWithEffects( objectName )
	x, y, floor = GetObjectPosition( objectName );
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x, y, 0, floor ); -- Пыль
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)","","tag2", x, y, 0, floor ); -- Огонь
	RazeBuilding( objectName );
end;

------------------------------------------------------------------------
--     Function Name: GraveYardZombiesWantJoin() 
--     Description: Запускается при входе игрока в зону "graveyard1". Присоединяет к армии игрока стек зомби.
------------------------------------------------------------------------
function GraveYardZombiesWantJoin( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		if graveyard1_first_visit == 0 then
			graveyard1_first_visit = 1;
			joinedCreaturesCount = joinedCreaturesCount + 1; --Увеличиваем счетчик собранных кричей Некрополиса на единицу
			heroWhoFoundLastCreature = heroName;
			SetObjectiveProgress( "sec2_JoinNecropolisCreatures", joinedCreaturesCount, PLAYER_1 );
			
			PlayVisualEffect( EFFECT_PLAGUE, "graveyard_1" );
			Play2DSound( SOUND_EFFECT_PLAGUE );
			RemoveObject("selection_graveyard_1");
			sleep(5);
			
			addedCreatures = WALKING_DEAD_COUNT - difLevel*5;
			MessageBox({"Maps/Scenario/A2C1M3/MessageBox10_GraveYardZombie.txt"; quantity = addedCreatures } );
			AddHeroCreatures( heroName, CREATURE_WALKING_DEAD, addedCreatures );
		else
			MessageBox(PATH.."GraveYardEmpty.txt");
		end;
	end;
end;


------------------------------------------------------------------------
--     Function Name: GraveYardUpgradedZombiesWantJoin() 
--     Description: Запускается при входе игрока в зону "graveyard2". Присоединяет к армии игрока стек апгрейженных зомби.
------------------------------------------------------------------------
function GraveYardUpgradedZombiesWantJoin( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		if graveyard2_first_visit == 0 then
			graveyard2_first_visit = 1;
			joinedCreaturesCount = joinedCreaturesCount + 1; --Увеличиваем счетчик собранных кричей Некрополиса на единицу
			heroWhoFoundLastCreature = heroName;
			SetObjectiveProgress( "sec2_JoinNecropolisCreatures", joinedCreaturesCount, PLAYER_1 );	
			
			PlayVisualEffect( EFFECT_PLAGUE, "graveyard_2" );
			Play2DSound( SOUND_EFFECT_PLAGUE );
			RemoveObject("selection_graveyard_2");
			sleep(5);
			
			addedCreatures = ZOMBIE_COUNT - difLevel*5;
			MessageBox({"Maps/Scenario/A2C1M3/MessageBox10_GraveYardZombie.txt"; quantity = addedCreatures});
			AddHeroCreatures( heroName, CREATURE_ZOMBIE, addedCreatures );
		else
			MessageBox(PATH.."GraveYardEmpty.txt");
		end;
	end;
end;

------------------------------------------------------------------------
--     Function Name: ReplaceToNecropoisDwelling() 
--     Description: Заменяет двеллинги Heaven на двеллинги Necropolis. 
------------------------------------------------------------------------
function ReplaceToNecropoisDwelling( heroName, objectName )
	print("ReplaceToNecropoisDwelling started");
	if GetObjectOwner( heroName ) == PLAYER_1 then
		Trigger( OBJECT_TOUCH_TRIGGER, objectName, nil );
		heroWhoFoundLastCreature = heroName;
		SetObjectiveProgress( "sec2_JoinNecropolisCreatures", joinedCreaturesCount, PLAYER_1 );
		
		if objectName == "FootmanTower" then -- Если объект Footman tower, то выдаем сообщение об этом и заменяем на Ruined Tower
			isTowerPostVoiceoverFinished = 0;
			MessageBox("Maps/Scenario/A2C1M3/MessageBox01_CurseTower.txt");
			ReplaceDwelling( objectName, TOWN_NECROMANCY );
			PlayVoiceoverAndBlockGame( VOICEOVER_TOWER_CONVERTED );
			isTowerPostVoiceoverFinished = 1;
		else -- Если объект Heaven military post, то выдаем сообщение об этом и заменяем на Necropolis military post
			isMilitaryPostVoiceoverFinished = 0;
			MessageBox("Maps/Scenario/A2C1M3/MessageBox11_CurseCastle.txt");			
			ReplaceDwelling( objectName, TOWN_NECROMANCY, CREATURE_WIGHT, CREATURE_DEATH_KNIGHT, CREATURE_LICH, CREATURE_VAMPIRE );
			PlayVoiceoverAndBlockGame( VOICEOVER_MILITARY_POST_CONVERTED );
			isMilitaryPostVoiceoverFinished = 1;
		end;
		joinedCreaturesCount = joinedCreaturesCount + 1;
		sleep(1);
		SetObjectEnabled( objectName, not nil );
		SetObjectOwner( objectName, PLAYER_1 );
		RemoveObject( "selection_"..objectName );
	end;
end;


function test()
	DeployReserveHero("Ving", 7, 26, GROUND);
end;

function PlaySceneTownCaptured( oldOwner, newOwner, heroName )
	if newOwner == PLAYER_1 then
		StartDialogScene( "/DialogScenes/A2C1/M3/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		Trigger( OBJECT_CAPTURE_TRIGGER, "EastHavenTown", nil );
		Trigger( OBJECT_CAPTURE_TRIGGER, "SouthHavenTown", nil );
		SetLight( 3, 3 );
		sleep(25);
		SetPointLights( 3 );
	end;
end;

function OpenTeleportForAI()
	repeat sleep(1); until GetDate( DAY )==DAY_TO_OPEN_TELEPORT;
	SetRegionBlocked( "TeleportBlocker", nil, PLAYER_2 );
	print("Teleport was opened for AI heroes");
end;

function PlayVoiceoverAndBlockGame( voiceoverName )
	BlockGame();
	Play2DSound( voiceoverName );
	sleep( GetSoundTimeInSleeps( voiceoverName ) )
	UnblockGame();
end;

function SetHeroNameWhoTouchAngel( heroName )
	heroWhoAttacksAngels = heroName;
end;	

H55_CamFixTooManySkills(PLAYER_1,"OrnellaNecro");

startThread( IsOrnellaMeetArantir );
Trigger( OBJECT_TOUCH_TRIGGER, "graveyard_1", "GraveYardZombiesWantJoin" );
Trigger( OBJECT_TOUCH_TRIGGER, "graveyard_2", "GraveYardUpgradedZombiesWantJoin" );
Trigger( OBJECT_TOUCH_TRIGGER, "lich", "IsLichesTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "vampire", "IsVampiresTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "zombie", "IsZombiesTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "FootmanTower", "ReplaceToNecropoisDwelling" );
Trigger( OBJECT_TOUCH_TRIGGER, "Castle", "ReplaceToNecropoisDwelling" );
Trigger( OBJECT_TOUCH_TRIGGER, "angel", "SetHeroNameWhoTouchAngel" );

Trigger( OBJECT_CAPTURE_TRIGGER, "EastHavenTown", "PlaySceneTownCaptured" );
Trigger( OBJECT_CAPTURE_TRIGGER, "SouthHavenTown", "PlaySceneTownCaptured" );

startThread( PlayerWin );
startThread( OrnellaMustSurvive );
startThread( DisablePlayerHeroHiring );
startThread( GiveTransferribleArifacts );
startThread( OpenTeleportForAI );
startThread( PlayVoiceoverAndBlockGame, VOICEOVER_MISSION_START );
--startThread( startInitialConditions );
print("all functions are ran");