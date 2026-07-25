doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep();
end

H55_PlayerStatus = {0,1,1,2,2,2,2,2};

VOICEOVER_FIRST_EMPRY_CHEST = "/Maps/SingleMissions/A2S1/SM1_VO2_Kunyak_01sound.xdb#xpointer(/Sound)";
VOICEOVER_SECOND_EMPRY_CHEST = "/Maps/SingleMissions/A2S1/SM1_VO3_Kunyak_01sound.xdb#xpointer(/Sound)";
VOICEOVER_CUP_OF_RAIN_FOUND = "/Maps/SingleMissions/A2S1/SM1_VO5_Kunyak_01sound.xdb#xpointer(/Sound)";
--VOICEOVER_MISSION_START = "/Maps/SingleMissions/A2S1/SM1_VO1_Kunyak_01sound.xdb#xpointer(/Sound)";

HERO_NAME = "Hero4"; -- константа для имени главного героя 
LEVELS = 7; 
START_ATTACK = 130 - GetDifficulty()*15; -- константа для времени атаки имперского флота (асболютный день)
HAVEN_HEROES = {"Maeve", "Christian", "Brem", "Orrin", "Ving", "Sarge"}; -- массив героев армии вторжения
HAVEN_HEROES.n = table.length( HAVEN_HEROES ); -- длина массива героев армии вторжения
CHEST_ARTIFACTS = {	ARTIFACT_SWORD_OF_RUINS, 
					ARTIFACT_GREAT_AXE_OF_GIANT_SLAYING,
					ARTIFACT_RING_OF_HASTE,
					ARTIFACT_DRAGON_EYE_RING,
					ARTIFACT_MOONBLADE,
					ARTIFACT_OGRE_CLUB,
					ARTIFACT_OGRE_SHIELD,
					ARTIFACT_RUNIC_WAR_AXE,
					ARTIFACT_RUNIC_WAR_HARNESS,
					ARTIFACT_DWARVEN_SMITHY_HUMMER,
					ARTIFACT_TREEBORN_QUIVER,
					ARTIFACT_DRAGON_SCALE_ARMOR
					};
TOWNS = {   "main_orcish_town", "west_orcish_town", "east_orcish_town", "north_east_orcish_town", "south_east_orcish_town", "academy_town1", "academy_town2", "heaven_town"	};
TOWNS.n = table.length( TOWNS );
cupOfRain = "cupOfRain"..(1+random(12)); -- переменная для имени артефакта. Значение выбирается случайным образом.
current_chest_id  = 0;
print("Cup of Rain is ", cupOfRain);

DIFFICULTY = {
	[0] = function()
		diff = 0;
		SetTownBuildingLimitLevel( "academy_town1", TOWN_BUILDING_DWELLING_7, 0 );
		SetTownBuildingLimitLevel( "academy_town2", TOWN_BUILDING_DWELLING_7, 0 );
		SetTownBuildingLimitLevel( "heaven_town", TOWN_BUILDING_DWELLING_7, 0 );
		SetTownBuildingLimitLevel( "academy_town1", TOWN_BUILDING_DWELLING_6, 0 );
		SetTownBuildingLimitLevel( "academy_town2", TOWN_BUILDING_DWELLING_6, 0 );
		SetTownBuildingLimitLevel( "heaven_town", TOWN_BUILDING_DWELLING_6, 0 );
		SetTownBuildingLimitLevel( "academy_town1", TOWN_BUILDING_FORT, 1 );
		SetTownBuildingLimitLevel( "academy_town2", TOWN_BUILDING_FORT, 1 );
		SetTownBuildingLimitLevel( "heaven_town", TOWN_BUILDING_FORT, 1 );
		AddHeroCreatures( HERO_NAME, CREATURE_GOBLIN, 100 );
		AddHeroCreatures( HERO_NAME, CREATURE_SHAMAN, 30 );
		AddHeroCreatures( HERO_NAME, CREATURE_ORCCHIEF_BUTCHER, 4 );
		print("Difficulty level is normal.");
	end,
	
	[1] = function()
		diff = 1;
		SetTownBuildingLimitLevel( "academy_town1", TOWN_BUILDING_DWELLING_7, 0 );
		SetTownBuildingLimitLevel( "academy_town2", TOWN_BUILDING_DWELLING_7, 0 );
		SetTownBuildingLimitLevel( "heaven_town", TOWN_BUILDING_DWELLING_7, 0 );
		SetTownBuildingLimitLevel( "academy_town1", TOWN_BUILDING_FORT, 2 );
		SetTownBuildingLimitLevel( "academy_town2", TOWN_BUILDING_FORT, 2 );
		SetTownBuildingLimitLevel( "heaven_town", TOWN_BUILDING_FORT, 2 );
		AddHeroCreatures( HERO_NAME, CREATURE_GOBLIN, 50 );
		AddHeroCreatures( HERO_NAME, CREATURE_SHAMAN, 15 );
		print("Difficulty level is hard.");
	end,
	
	[2] = function()
		diff=2;
		print("Difficulty level is heroic.");
	end,
	
	[3] = function()
		diff=3;
		print("Difficulty level is impossible.");
	end,
}

function RemoveCupOfRainEffects( hero, object )
	StopVisualEffects(object.."Effect");
	current_chest_id = current_chest_id + 1;
	GiveArtefact( hero, CHEST_ARTIFACTS[current_chest_id] );
	if object ~= cupOfRain then
		Play2DSound( VOICEOVER_SECOND_EMPRY_CHEST );
	end
end

function CloserOrfurtherNotification()
	print("funstion CloserOrfurtherNotification has started...");
	local initialDestination = H55_GetDistance( cupOfRain, HERO_NAME );
	local step = LEVELS; -- количество рубежей, при пересечении которых, выводится сообщение
	print( "Initial Destination = ", initialDestination );
	print( "step = ", step );
	while IsHeroAlive( HERO_NAME ) ~= nil and IsObjectExists( cupOfRain ) ~= nil do
		local currentDestination = H55_GetDistance( cupOfRain, HERO_NAME );
		if currentDestination < ( initialDestination * step )/(LEVELS+1) then -- если расстояние меньше чем текущий рубеж
			step = step - 1; -- перейти к проверке следующего (более близкого к артефакту) рубежа
			ShowFlyingSign("Maps/SingleMissions/A2S1/FlyingMessage_IsCloser.txt", HERO_NAME, PLAYER_1, 3);
			print("HOT. We are closer to cupOfRain. step = ",step,"cur.Destination = ", currentDestination, "nxtStep = ",( initialDestination * step )/(LEVELS+1));
		end
		if currentDestination > ( initialDestination * (step+1) )/(LEVELS+1) and currentDestination < initialDestination then -- если расстояние стало больше, чем предыдущий рубеж
			step = step + 1; -- перейти к проверке предыдущего (более далекого от артефакта) рубежа
			ShowFlyingSign("Maps/SingleMissions/A2S1/FlyingMessage_IsFurther.txt", HERO_NAME, PLAYER_1, 3);
			print("COLD. We are further to cupOfRain. step = ",step,"cur Destination = ", currentDestination,"prvStep = ",( initialDestination * step+1 )/(LEVELS+1));
		end
		sleep(10);
	end
	print("Cup of Rain is found or main hero is dead. Function CloserOrfurtherNotification terminated...");
end

function visitPrison( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( OBJECT_TOUCH_TRIGGER, "prison", nil );
		CINEMATICS.releaseHeroFromPrison();
		if IsObjectExists("fake") ~= nil then
			local x_chest, y_chest, floor_chest = GetObjectPosition( "fake" );
			local x_hero, y_hero, floor_hero = GetObjectPosition( hero );
			OpenCircleFog( x_chest, y_chest, floor_chest, 10, PLAYER_1);
			MoveCamera( x_chest, y_chest, floor_chest, 50, 1.2, 0, 0, 0, 1);
			sleep(100);
			MoveCamera( x_hero, y_hero, floor_hero, 50, 1.2, 0, 0, 0, 1);
			Trigger(OBJECT_TOUCH_TRIGGER, "fake", "Is_fakeCupOfRain_found" );
		end
	end
end

function Is_fakeCupOfRain_found( hero )
	GiveArtefact( hero, ARTIFACT_PEDANT_OF_MASTERY );
	Play2DSound( VOICEOVER_FIRST_EMPRY_CHEST );
end

function meetGoblins()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "shaman_gate", nil );
	OBJECTIVES.state.rescueShaman[2] = 1;
end

function ButarAnswers()
	MessageBox( "Maps/SingleMissions/A2S1/MsgBox_Butar1.txt" );
end

function ShamanGuardTouched(hero)
	OBJECTIVES.rescueShaman_rescuer = hero;
end

function butarNotAtHome( heroName, objectName )
	MessageBox( "Maps/SingleMissions/A2S1/MsgBox_nobodyHome.txt" );
end

function meetFisherman( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( OBJECT_TOUCH_TRIGGER, "fisher", nil );
		OBJECTIVES.killWaterElementals_hero = hero;
		OBJECTIVES.state.killWaterElementals[2] = 1;
	end
end

function Fisher_answers( hero )
	if GetObjectOwner(hero) == PLAYER_1 and IsObjectExists("elemental_1") then
		MessageBox("Maps/SingleMissions/A2S1/MessageBox_fisherAnswer.txt");
		return
	end
	OBJECTIVES.killWaterElementals_hero = hero;
	OBJECTIVES.state.killWaterElementals[2] = 3;
end

function AttackWaterElementalsInRegion( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		StartCombat( hero, nil, 4, CREATURE_WATER_ELEMENTAL, 4+diff*2, CREATURE_WATER_ELEMENTAL, 4+diff*2, CREATURE_WATER_ELEMENTAL, 4+diff*2, CREATURE_WATER_ELEMENTAL, 4+diff*2, nil, "PlayerDefeatElementals" );
	end
end

function PlayerDefeatElementals( heroName, combatResult )
	if combatResult ~= nil then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "water_elementals", nil );
		RemoveObject("elemental_1");
		RemoveObject("elemental_2");
		RemoveObject("elemental_3");
		MessageBox( "Maps/SingleMissions/A2S1/MsgBox_KuinakKilledWaterElementals.txt" );
	end
end

function KillFisher()
	QuestionBox("Maps/SingleMissions/A2S1/MessageBox_wantToKillFisher.txt","WantToKillFisher");
end
	
function WantToKillFisher()
	Trigger( OBJECT_TOUCH_TRIGGER, "fisher", nil );
	PlayObjectAnimation( "fisher", "death", ONESHOT_STILL );
	sleep(100);
	RemoveObject( "fisher" );
end

function RazeFisherHut( hero, object )
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)",  object );
	sleep(25);
	PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)", object );
	RazeBuilding( object );
end

finderHero = HERO_NAME;
function IsCupOfRainFound( hero )
	QuestionBox("Maps/SingleMissions/A2S1/QuestionBox_WantFightElementals.txt", "FightForArtifact" );
	finderHero = hero;
end

function FightForArtifact()
	StartCombat( finderHero, nil, 4, CREATURE_FIRE_ELEMENTAL, 40+diff*15, CREATURE_FIRE_ELEMENTAL, 40+diff*15, CREATURE_FIRE_ELEMENTAL, 40+diff*15, CREATURE_FIRE_ELEMENTAL, 40+diff*15, nil, "IsArtifactGuardDefeated" );
end

function IsArtifactGuardDefeated( heroName, combatResult )
	if combatResult ~= nil then
		print("Artifact guards are defeated.");
		OBJECTIVES.state.findCupOfRain[2] = 3;
	end
end

function SinkHavenHeroes( heroName )
	while IsHeroInBoat( heroName ) ~= not nil do sleep(5); end; -- ждать пока герой не сел на корабль
	if IsHeroAlive( heroName )==not nil then
		BlockGame();	
		local x, y = GetObjectPosition( heroName );
		OpenCircleFog( x, y, GROUND, 15, PLAYER_1 );
		sleep( 10 );
		MoveCamera( x, y, GROUND , 50, 1.2, 0, 0, 0, 1);
		PlayVisualEffect( "/Effects/_(Effect)/Arenas/Boat/Surf06.xdb#xpointer(/Effect)", heroName, "effect"..heroName );
		SinkHero( heroName );
		sleep(80);
		StopVisualEffects( "effect"..heroName );
		UnblockGame();
	end
end

function IsAllDefeated()
	local countAiTowns = 0;
	for i=1,TOWNS.n do
		if GetObjectOwner(TOWNS[i]) == PLAYER_3 or GetObjectOwner(TOWNS[i]) == PLAYER_2 then
			countAiTowns = countAiTowns+1;
		end
	end
	local aiHeroes = table.length(GetPlayerHeroes(PLAYER_2))+table.length(GetPlayerHeroes(PLAYER_3));
	return aiHeroes == 0 and countAiTowns == 0;
end

function ApproachPrisonIslandVoiceover( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_prison_island", nil );
		Play2DSound( "/Maps/SingleMissions/A2S1/SM1_VO6_Kunyak_01sound.xdb#xpointer(/Sound)" );
	end
end

function ApproachCupOfRainIslandVoiceover( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_1", nil );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_2", nil );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_3", nil );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_4", nil );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_1_west_north", nil );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_2_west_north", nil );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_1_east_north", nil );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_2_east_north", nil );
		Play2DSound( "/Maps/SingleMissions/A2S1/SM1_VO4_Kunyak_01sound.xdb#xpointer(/Sound)" );
	end
end

function IsFleetDestroyed()
	for i, hero in HAVEN_HEROES do
		if IsHeroAlive(hero) then
			return nil
		end
	end
	return not nil
end

function DeployImperialFleet()
	BlockGame();
	OpenCircleFog( 120, 5, GROUND, 15, PLAYER_1 );
	MoveCamera( 120, 5, GROUND , 50, 1.2, 0, 0, 0, 1);
	sleep( 50 );
	DeployReserveHero( HAVEN_HEROES[1], 112, 2, GROUND );
	DeployReserveHero( HAVEN_HEROES[2], 115, 5, GROUND );
	DeployReserveHero( HAVEN_HEROES[3], 120, 8, GROUND );
	DeployReserveHero( HAVEN_HEROES[4], 110, 6, GROUND );
	DeployReserveHero( HAVEN_HEROES[5], 122, 4, GROUND );
	DeployReserveHero( HAVEN_HEROES[6], 128, 7, GROUND );
	sleep( 1 );
	SetObjectRotation(HAVEN_HEROES[1], 180);
	SetObjectRotation(HAVEN_HEROES[2], 180);
	SetObjectRotation(HAVEN_HEROES[3], 180);
	SetObjectRotation(HAVEN_HEROES[4], 180);
	SetObjectRotation(HAVEN_HEROES[5], 180);
	SetObjectRotation(HAVEN_HEROES[6], 180);
	sleep( 10 );
	MoveHeroRealTime( HAVEN_HEROES[1], 112, 4, GROUND );
	MoveHeroRealTime( HAVEN_HEROES[2], 115, 7, GROUND );
	MoveHeroRealTime( HAVEN_HEROES[3], 120, 10, GROUND );
	MoveHeroRealTime( HAVEN_HEROES[4], 110, 8, GROUND );
	MoveHeroRealTime( HAVEN_HEROES[5], 122, 6, GROUND );
	MoveHeroRealTime( HAVEN_HEROES[6], 128, 9, GROUND );
	UnblockGame();
end

A2S1_BUILD_TABLE = {
	[4]	 = { 			TOWN_BUILDING_DWELLING_1, 2 },
	[6]  = { 		   TOWN_BUILDING_MARKETPLACE, 1 },
	[11] = { 			TOWN_BUILDING_DWELLING_1, 3 },
	[15] = { 			 TOWN_BUILDING_TOWN_HALL, 2 },
	[16] = { 			TOWN_BUILDING_DWELLING_2, 2 },
	[18] = { 			TOWN_BUILDING_DWELLING_3, 2 },
	[22] = { 				  TOWN_BUILDING_FORT, 2 },
	[23] = { 			TOWN_BUILDING_DWELLING_3, 3 },
	[24] = { 		   TOWN_BUILDING_MAGIC_GUILD, 3 },
	[26] = { 				  TOWN_BUILDING_FORT, 3 },
	[29] = { 			TOWN_BUILDING_DWELLING_4, 2 },
	[32] = { 			TOWN_BUILDING_DWELLING_4, 3 },
	[35] = { 			TOWN_BUILDING_DWELLING_5, 2 },
	[38] = {  TOWN_BUILDING_ACADEMY_ARCANE_FORGE, 2 },
	[43] = { 	   TOWN_BUILDING_ACADEMY_LIBRARY, 2 },
	[48] = { TOWN_BUILDING_ACADEMY_TREASURE_CAVE, 2 },
	[53] = { 		   TOWN_BUILDING_MAGIC_GUILD, 5 },
}

function GreatImproveAISpecialForUbisoft(town)
	if GetObjectOwner(town) ~= PLAYER_3 then
		return
	end

	local build = A2S1_BUILD_TABLE[GetDate(ABSOLUTE_DAY)]

	if build ~= nil then
		BuildStructure(build[1], build[2], town)
	end
end

function BuildStructure( structureType, structureLimit, town )
	if GetTownBuildingLevel( town, structureType ) < structureLimit then
		UpgradeTownBuilding( town, structureType );
		print("building "..structureType.." was builded in town"..town );
	end
end

CINEMATICS = {
	are_playing = nil,
	playAndWait = function( id )
		CINEMATICS.are_playing = not nil;
		StartAdvMapDialog( id, CINEMATICS.end_play() );
		repeat sleep(30); until CINEMATICS.are_playing == nil;
	end,
		
	end_play = function()
		CINEMATICS.are_playing = nil;
	end,
	
	intro = function()
		StartDialogScene( "/DialogScenes/A2Single/SM1/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep(2);
	end,
	
	meetGoblins = function() 
		CINEMATICS.playAndWait( 1 );
	end,
	
	rescueShaman = function() 
		CINEMATICS.playAndWait( 2 );
	end,
	
	releaseHeroFromPrison = function()
		CINEMATICS.playAndWait( 0 );
	end,
}

OBJECTIVES = {
	state = {
		isAlive 			= {	   "prim1_HeroMustSurvive", 1 },	
		destroyFleet		= {  "prim2_DestroyHavenFleet", 1 },
		findCupOfRain		= {		 "prim3_findCupOfRain", 1 },
		rescueShaman 		= {			  "sec2_HelpButar", 0 },
		killWaterElementals	= { "sec3_KillWaterElementals", 0 },
		eventManager		= {						   "_", 1 },
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		for i=0,12 do
			PlayVisualEffect("/Effects/_(Effect)/Artefacts/General/Blue.xdb#xpointer(/Effect)", "cupOfRain"..i, "cupOfRain"..i.."Effect" );
			Trigger( OBJECT_TOUCH_TRIGGER, "cupOfRain"..i, "RemoveCupOfRainEffects" );
		end
		SetObjectEnabled( 	 cupOfRain, nil );
		SetObjectEnabled( 	   "butar", nil );
		SetObjectEnabled(  "butar_hut", nil );
		SetObjectEnabled( 	  "fisher", nil );
		SetObjectEnabled( "fisher_hut", nil );
		for i, player in { PLAYER_2, PLAYER_3 } do
			SetRegionBlocked ( "water_elementals", 1, player );
			SetRegionBlocked ( "shaman_gate", 1, player );
			SetRegionBlocked ( "cup1", 1, player );
			SetRegionBlocked ( "cup2", 1, player );
			SetRegionBlocked ( "cup3", 1, player );
			SetRegionBlocked ( "fisher_region", 1, player );
			SetRegionBlocked ( "prison", 1, player );
		end
		for i, race in { TOWN_INFERNO, TOWN_ACADEMY, TOWN_HEAVEN, TOWN_NECROMANCY, TOWN_PRESERVE, TOWN_FORTRESS, TOWN_DUNGEON } do
			AllowPlayerTavernRace( PLAYER_1, race, 0 );
		end
		SetPlayerHeroesCountNotForHire( PLAYER_2, 6 );
		MakeHeroReturnToTavernAfterDeath( "Nathaniel", not nil, 1 );
		CINEMATICS.intro();
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "shaman_gate", "meetGoblins" );
		Trigger( OBJECT_TOUCH_TRIGGER, "butar", nil );
		Trigger( OBJECT_TOUCH_TRIGGER, "butar_hut", "butarNotAtHome");
		Trigger( OBJECT_TOUCH_TRIGGER, "fisher", "meetFisherman" );
		Trigger( OBJECT_TOUCH_TRIGGER, "prison", "visitPrison" );
		Trigger( OBJECT_TOUCH_TRIGGER, "shaman_guard", "ShamanGuardTouched" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "water_elementals", "AttackWaterElementalsInRegion" );
		Trigger( PLAYER_REMOVE_HERO_TRIGGER , PLAYER_1, "KuinakMustSurvive" );
		Trigger( OBJECT_TOUCH_TRIGGER, cupOfRain, "IsCupOfRainFound");
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_prison_island", "ApproachPrisonIslandVoiceover" );

		local cup_x, cup_y = GetObjectPosition( cupOfRain );
		if cup_x>=4 and cup_x<=25 and cup_y>=154 and cup_y<=172 then 
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_1_west_north", "ApproachCupOfRainIslandVoiceover" );
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_2_west_north", "ApproachCupOfRainIslandVoiceover" );
		end;
		if cup_x>=154 and cup_x<=167 and cup_y>=142 and cup_y<=168 then 
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_1_east_north", "ApproachCupOfRainIslandVoiceover" );
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_2_east_north", "ApproachCupOfRainIslandVoiceover" );
		end;
		if cup_x>=102 and cup_x<=128 and cup_y>=35 and cup_y<=51 then 
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_1", "ApproachCupOfRainIslandVoiceover" );
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_2", "ApproachCupOfRainIslandVoiceover" );
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_3", "ApproachCupOfRainIslandVoiceover" );
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "approach_cup_of_rain_area_4", "ApproachCupOfRainIslandVoiceover" );
		end;
		DIFFICULTY[GetDifficulty()]();
		print( "All triggers and functions started..." );
	end,
	
	run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					if pcall(OBJECTIVES[key]) == nil then print(key) end;
				end
			end
			
			if GetObjectiveState('prim1_HeroMustSurvive') == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState('prim2_DestroyHavenFleet') == OBJECTIVE_COMPLETED then
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive(HERO_NAME) == nil then
			SetObjectiveState("prim1_HeroMustSurvive", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	destroyFleet = function()
		if OBJECTIVES.state.destroyFleet[2] == 1 then
			SetObjectiveState( "prim2_DestroyHavenFleet", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.destroyFleet[2] = 2;
		elseif OBJECTIVES.state.destroyFleet[2] == 2 and ( OBJECTIVES.date >= START_ATTACK or IsAllDefeated() ~= nil ) then
			DeployImperialFleet();
			OBJECTIVES.state.destroyFleet[2] = 4;
		elseif OBJECTIVES.state.destroyFleet[2] == 4 and IsFleetDestroyed() ~= nil then
			StartDialogScene( "/DialogScenes/A2Single/SM1/S2/DialogScene.xdb#xpointer(/DialogScene)" );
			SetObjectiveState( "prim2_DestroyHavenFleet", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.destroyFleet[2] = 10;
		end
	end,
	
	findCupOfRain = function()
		if OBJECTIVES.state.findCupOfRain[2] == 1 then
			SetObjectiveState( "prim3_findCupOfRain", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.findCupOfRain[2] = 2;
		elseif OBJECTIVES.state.findCupOfRain[2] == 3 then
			pcall( RemoveObject, cupOfRain );
			SetObjectiveState( "prim3_findCupOfRain", OBJECTIVE_COMPLETED );
			BlockGame();
			local soundTime = GetSoundTimeInSleeps( VOICEOVER_CUP_OF_RAIN_FOUND );
			Play2DSound( VOICEOVER_CUP_OF_RAIN_FOUND  );
			sleep( soundTime );
			UnblockGame();
			if OBJECTIVES.state.destroyFleet[2] == 4 then
				for i=1, HAVEN_HEROES.n do
					startThread( SinkHavenHeroes, HAVEN_HEROES[i] );
					sleep(120);
				end
			else
				DeployImperialFleet();
				sleep(15);
				for i=1, HAVEN_HEROES.n do
					SinkHero( HAVEN_HEROES[i] );
					PlayVisualEffect( "/Effects/_(Effect)/Arenas/Boat/Surf06.xdb#xpointer(/Effect)", HAVEN_HEROES[i] );
					sleep(250);
				end
				OBJECTIVES.state.destroyFleet[2] = 4;
			end
			OBJECTIVES.state.findCupOfRain[2] = 10;
		end
	end,
	
	rescueShaman_rescuer = HERO_NAME,
	rescueShaman = function()
		if OBJECTIVES.state.rescueShaman[2] == 1 then
			CINEMATICS.meetGoblins();
			Trigger( OBJECT_TOUCH_TRIGGER, "butar", "ButarAnswers" );
			SetObjectiveState( "sec2_HelpButar", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.rescueShaman[2] = 2;
		elseif OBJECTIVES.state.rescueShaman[2] == 2 and IsObjectExists( "shaman_guard") == nil then
			CINEMATICS.rescueShaman();
			SetObjectiveState( "sec2_HelpButar", OBJECTIVE_COMPLETED );
			startThread( CloserOrfurtherNotification );
			SetObjectEnabled( "butar", not nil );
			Trigger( OBJECT_TOUCH_TRIGGER, "butar", nil );
			pcall (TeachHeroSpell, OBJECTIVES.rescueShaman_rescuer, SPELL_SUMMON_CREATURES );
			OBJECTIVES.state.rescueShaman[2] = 10;
		end
	end,
	
	killWaterElementals_hero = HERO_NAME,
	killWaterElementals = function()
		if OBJECTIVES.state.killWaterElementals[2] == 1 then
			SetObjectiveState( "sec3_KillWaterElementals", OBJECTIVE_ACTIVE );
			if IsObjectExists("elemental_1") then -- если игрок еще не уничтожил водяных элементалов
				Trigger( OBJECT_TOUCH_TRIGGER, "fisher", "Fisher_answers" ); -- если еще трогаем рыбака, он интересуется не выполнено ли еще его задание?
				local x_hero, y_hero, floor_hero = GetObjectPosition( OBJECTIVES.killWaterElementals_hero ); 
				OpenCircleFog( 155, 35, GROUND, 10, PLAYER_1);
				MoveCamera( 155, 35, GROUND, 50, 1.2, 0, 0, 0, 1); -- показываем место где находятся элементалы
				sleep(80);
				MoveCamera( x_hero, y_hero, floor_hero, 50, 1.2, 0, 0, 0, 1); -- возвращаем камеру назад
				OBJECTIVES.state.killWaterElementals[2] = 2;
			else
				OBJECTIVES.state.killWaterElementals[2] = 3;
			end
		elseif OBJECTIVES.state.killWaterElementals[2] == 3 then
			SetObjectiveState( "sec3_KillWaterElementals", OBJECTIVE_COMPLETED );
			Trigger( OBJECT_TOUCH_TRIGGER, "fisher", "KillFisher" );
			Trigger( OBJECT_TOUCH_TRIGGER, "fisher_hut", "RazeFisherHut" );
			MessageBox("Maps/SingleMissions/A2S1/MessageBox_FisherThx.txt");
			GiveArtefact( OBJECTIVES.killWaterElementals_hero, ARTIFACT_GOLDEN_SEXTANT );
			OBJECTIVES.state.killWaterElementals[2] = 10;
		end
	end,
	
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date >= OBJECTIVES.eventManager_day then
			GreatImproveAISpecialForUbisoft( "academy_town1" );
			GreatImproveAISpecialForUbisoft( "academy_town2" );
			OBJECTIVES.eventManager_day = OBJECTIVES.date + 1;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start )

function a2s1_dbg(var)
	if var == 1 then
		MakeHeroInteractWithObject(HERO_NAME, cupOfRain);
	end
end
