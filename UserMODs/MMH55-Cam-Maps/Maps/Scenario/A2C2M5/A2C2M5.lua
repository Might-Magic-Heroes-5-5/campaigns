doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_TAROT_DECK,
	ARTIFACT_ENDLESS_BAG_OF_GOLD
};

PATH = "Maps/Scenario/A2C2M5/";
ALL_TOWNS = {"academy_town_center", "academy_town_west", "academy_town_north", "HeavenTown", "MainAcademyTown", "main_orcish_town", "secondary_orcish_town", "necropolis"};
ALL_TOWNS.n = table.length( ALL_TOWNS );
DAY_OF_NECROMANTS_OUTCOME = 28;

function GiveTransferrableArtifacts()
	InitAllSetArtifacts( "A2C2M5", "Gottai" );
    LoadHeroAllSetArtifacts( "Gottai", "A2C2M3" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Gottai" );
end

function IsHeroHasGremlins( heroName )
	if GetHeroCreatures( heroName, CREATURE_GREMLIN ) > 0 or GetHeroCreatures( heroName, CREATURE_MASTER_GREMLIN ) > 0 or GetHeroCreatures( heroName, CREATURE_GREMLIN_SABOTEUR ) > 0 
		then
		return not nil;
	end
	return nil;
end

function BrokenGolemsVisit( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		OBJECTIVES.repairGolems_visitor = hero;
		if OBJECTIVES.state.repairGolems[2] == 0 then OBJECTIVES.state.repairGolems[2] = 1 end;
		if OBJECTIVES.state.repairGolems[2] == 2 then OBJECTIVES.state.repairGolems[2] = 3 end;
	end
end

function NecromantsGoAway()
	local NecropolisHeroes = GetPlayerHeroes( PLAYER_3 );
	for i=1, ALL_TOWNS.n do
		EnableAIHeroHiring( PLAYER_3, ALL_TOWNS[i], nil );
	end
	while table.length( NecropolisHeroes ) ~= 0 do
		while GetCurrentPlayer() ~= PLAYER_3 do sleep(20); end
		NecropolisHeroes = GetPlayerHeroes( PLAYER_3 );
		for i=0, (table.length( NecropolisHeroes ) -1 ) do
			EnableHeroAI( NecropolisHeroes[i], not nil );
			pcall (MoveHero, NecropolisHeroes[i], 174, 133, GROUND );
		end
		while GetCurrentPlayer() == PLAYER_3 do sleep(20); end
		sleep(40);
	end
end

function RemoveHero( heroName )
	if GetObjectOwner( heroName ) == PLAYER_3 then
		RemoveObject( heroName );
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
		StartDialogScene( "/DialogScenes/A2C2/M5/S1/DialogScene.xdb#xpointer(/DialogScene)" );
	end,
	
	repairGolems = function()
		BlockGame()
		for i=1,4 do
			local x,y,floor = GetObjectPosition("golem"..i);
			RemoveObject("golem"..i);
			PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "", "tag1", x, y, 0, floor );
			repeat sleep(5) until IsObjectExists("golem"..i) == nil;
			CreateMonster( "repared_golem"..i, CREATURE_IRON_GOLEM, 400, x,y, floor, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 110 );
			repeat sleep(5) until IsObjectExists("repared_golem"..i) ~= nil;
			PlayObjectAnimation( "repared_golem"..i, "happy", ONESHOT );
		end
		PlayObjectAnimation( "broken_golem", "happy", ONESHOT );
		sleep(50);
		UnblockGame();
	end,
	
	talkWithKenji = function()
		CreateMonster( "scene_goblin", CREATURE_GOBLIN_TRAPPER, 1, 77, 161, GROUND, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 200 );
		local x, y, z = GetObjectPosition( "Gottai" );
		SetObjectPosition( "Gottai", 72, 162 );
		sleep(60);
		SetObjectRotation( "Gottai", 100 );
		CINEMATICS.playAndWait( 0 );
		RemoveObject("scene_goblin");
		SetRegionBlocked( "gotai_region", nil );
		SetObjectPosition( "Gottai", x, y, z );
	end,
	
	captureMainTown = function()
		StartDialogScene( "/DialogScenes/A2C2/M5/S2/DialogScene.xdb#xpointer(/DialogScene)" );
	end,
	
	outro = function()
		StartDialogScene( "/DialogScenes/A2C2/M5/S3/DialogScene.xdb#xpointer(/DialogScene)" );
	end,
}

function SetupEnemyHeroesArmy()
	AddHeroCreatures(	  "Tan",			 CREATURE_TITAN, 1 +  10 * (diff - 1));
	AddHeroCreatures( 	  "Tan",	 CREATURE_RAKSHASA_RUKH, 1 +  20 * (diff - 1));
	AddHeroCreatures( 	  "Tan",	  CREATURE_MASTER_GENIE, 1 +  40 * (diff - 1));
	AddHeroCreatures( 	  "Tan",		 CREATURE_ARCH_MAGI, 1 +  50 * (diff - 1));
	AddHeroCreatures( 	  "Tan",	   CREATURE_STEEL_GOLEM, 1 +  70 * (diff - 1));
	AddHeroCreatures( 	  "Tan", CREATURE_OBSIDIAN_GARGOYLE, 1 + 100 * (diff - 1));
	AddHeroCreatures( 	  "Tan",	CREATURE_MASTER_GREMLIN, 1 + 200 * (diff - 1));
	AddHeroCreatures( "Aberrar",   CREATURE_SKELETON_ARCHER, 1 +  10 * (diff - 1));
	AddHeroCreatures( "Aberrar",			  CREATURE_LICH, 1 +   1 * (diff - 1));
	AddHeroCreatures( "Aberrar", 	  CREATURE_WALKING_DEAD, 1 +   3 * (diff - 1));
	AddHeroCreatures( "Aberrar", 		   CREATURE_VAMPIRE, 1 +   2 * (diff - 1));
	AddHeroCreatures(  "Maahir", 		   CREATURE_GREMLIN, 1 +  10 * (diff - 1));
	AddHeroCreatures(  "Maahir", 		CREATURE_IRON_GOLEM, 1 +   3 * (diff - 1));
	AddHeroCreatures(  "Maahir", 			  CREATURE_MAGI, 1 +   1 * (diff - 1));
	AddHeroCreatures(  "Maahir", 			 CREATURE_GENIE, 1 +   1 * (diff - 1));
	AddHeroCreatures(    "Sufi", 	CREATURE_MASTER_GREMLIN, 1 +   7 * (diff - 1));
	AddHeroCreatures(    "Sufi", 	   CREATURE_STEEL_GOLEM, 1 +   3 * (diff - 1));
	AddHeroCreatures(    "Sufi", CREATURE_OBSIDIAN_GARGOYLE, 1 +   5 * (diff - 1));
	AddHeroCreatures(    "Sufi", 			  CREATURE_MAGI, 1 +   1 * (diff - 1));
	AddHeroCreatures(   "Orrin", 			CREATURE_ARCHER, 1 +  15 * (diff - 1));
	AddHeroCreatures(   "Orrin", 		CREATURE_MILITIAMAN, 1 +  20 * (diff - 1));
	AddHeroCreatures(   "Orrin", 		   CREATURE_FOOTMAN, 1 +  10 * (diff - 1));
	AddHeroCreatures(   "Orrin", 		   CREATURE_GRIFFIN, 1 +   7 * (diff - 1));
end

function SetupGarrisions()
	AddObjectCreatures("outpost1", 				CREATURE_MAGI, 1 +  50 * diff);
	AddObjectCreatures("outpost1", 			   CREATURE_TITAN, 1 +   4 * diff);
	AddObjectCreatures("outpost1", 		 CREATURE_STEEL_GOLEM, 1 +  80 * diff);
	AddObjectCreatures("outpost1", 	  CREATURE_MASTER_GREMLIN, 1 + 100 * diff);
	AddObjectCreatures("outpost1", 	  CREATURE_STONE_GARGOYLE, 1 +  90 * diff);
	AddObjectCreatures("outpost2", CREATURE_OBSIDIAN_GARGOYLE, 1 +  95 * diff);
	AddObjectCreatures("outpost2",		  CREATURE_IRON_GOLEM, 1 +  85 * diff);
	AddObjectCreatures("outpost2",		 CREATURE_STEEL_GOLEM, 1 +  80 * diff);
	AddObjectCreatures("outpost2",	  CREATURE_MASTER_GREMLIN, 1 + 100 * diff);
	AddObjectCreatures("outpost2",	  CREATURE_STONE_GARGOYLE, 1 +  90 * diff);
	AddObjectCreatures("outpost2",			   CREATURE_GENIE, 1 +  25 * diff);
	AddObjectCreatures("outpost3",		   CREATURE_ARCH_MAGI, 1 +  45 * diff);
	AddObjectCreatures("outpost3",			   CREATURE_TITAN, 1 +   4 * diff);
	AddObjectCreatures("outpost3",	   CREATURE_RAKSHASA_RUKH, 1 +  12 * diff);
	AddObjectCreatures("outpost3",			CREATURE_RAKSHASA, 1 +  15 * diff);
	AddObjectCreatures("outpost3",		CREATURE_MASTER_GENIE, 1 +  20 * diff);
	AddObjectCreatures("outpost4",	  CREATURE_MASTER_GREMLIN, 1 + 100 * diff);
	AddObjectCreatures("outpost4",		  CREATURE_STORM_LORD, 1 +   4 * diff);
	AddObjectCreatures("outpost4",	CREATURE_RAKSHASA_KSHATRI, 1 +  12 * diff);
	AddObjectCreatures("outpost4",	  CREATURE_OBSIDIAN_GOLEM, 1 +  85 * diff);
	AddObjectCreatures("outpost4",		CREATURE_DJINN_VIZIER, 1 +  20 * diff);
end

DIFFICULTY = {
	[0] = function()
		diff = 1;
	end,
	
	[1] = function()
		diff = 2;
		GiveExp("Tan", 211000);
		ChangeHeroStat ("Tan", STAT_ATTACK, 5);
		ChangeHeroStat ("Tan", STAT_DEFENCE, 5);
		ChangeHeroStat ("Tan", STAT_SPELL_POWER, 7);
		ChangeHeroStat ("Tan", STAT_KNOWLEDGE, 7);
		GiveExp("Alaric", 211000);
		ChangeHeroStat ("Alaric", STAT_ATTACK, 8);
		ChangeHeroStat ("Alaric", STAT_DEFENCE, 8);
		ChangeHeroStat ("Alaric", STAT_SPELL_POWER, 4);
		ChangeHeroStat ("Alaric", STAT_KNOWLEDGE, 4);
	end,
	
	[2] = function()
		diff = 3;
		GiveExp("Tan", 435000);
		ChangeHeroStat ("Tan", STAT_ATTACK, 5);
		ChangeHeroStat ("Tan", STAT_DEFENCE, 5);
		ChangeHeroStat ("Tan", STAT_SPELL_POWER, 7);
		ChangeHeroStat ("Tan", STAT_KNOWLEDGE, 7);
		GiveExp("Alaric", 435000);
		ChangeHeroStat ("Alaric", STAT_ATTACK, 8);
		ChangeHeroStat ("Alaric", STAT_DEFENCE, 8);
		ChangeHeroStat ("Alaric", STAT_SPELL_POWER, 4);
		ChangeHeroStat ("Alaric", STAT_KNOWLEDGE, 4);
	end,
	
	[3] = function()
		diff = 4;
		GiveExp("Tan", 894000);	
		ChangeHeroStat ("Tan", STAT_ATTACK, 5);
		ChangeHeroStat ("Tan", STAT_DEFENCE, 5);
		ChangeHeroStat ("Tan", STAT_SPELL_POWER, 7);
		ChangeHeroStat ("Tan", STAT_KNOWLEDGE, 7);
		GiveExp("Alaric", 894000);
		ChangeHeroStat ("Alaric", STAT_ATTACK, 8);
		ChangeHeroStat ("Alaric", STAT_DEFENCE, 8);
		ChangeHeroStat ("Alaric", STAT_SPELL_POWER, 4);
		ChangeHeroStat ("Alaric", STAT_KNOWLEDGE, 4);
	end,
}

OBJECTIVES = {
	state = {
		 captureMainTown  = { "prim1_CaptureMainAcademyTown", 1 }, 	--Capture the mage city
		 defeatAlaric 	  = { 			  "prim2_KillAlaric", 1 },  -- Defeat the main enemy hero Alaric
		 isAlive 		  = { 		"prim2_GotaiMustSurvive", 1 }, 	-- Gottai must survive
		 captureRiverTown = { 		"sec3_CaptureHeavenTown", 1 },  -- Capture northwest town above the river
		 repairGolems 	  = { 			 "sec1_RepareGolems", 0 },  -- Bring gremlins to repair the broken golems
		 eventManager 	  = { 							 "_", 1 },
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		for i, race in  { TOWN_HEAVEN, TOWN_INFERNO, TOWN_PRESERVE, TOWN_ACADEMY, TOWN_NECROMANCY, TOWN_DUNGEON, TOWN_FORTRESS } do
			AllowPlayerTavernRace( PLAYER_1, race, 0 );
		end
		startThread( GiveTransferrableArtifacts );
		DIFFICULTY[GetDifficulty()]();
		startThread( SetupGarrisions );
		startThread( SetupEnemyHeroesArmy );
		EnableHeroAI( "Tan", nil );
		AllowHeroHiringByRaceForAI( PLAYER_2, 	 TOWN_INFERNO, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_2, TOWN_NECROMANCY, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_2, TOWN_STRONGHOLD, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_2, 	 TOWN_DUNGEON, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_3, 	 TOWN_INFERNO, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_3, 	 TOWN_ACADEMY, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_3, 	TOWN_FORTRESS, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_3, TOWN_STRONGHOLD, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_4, 	 TOWN_INFERNO, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_4,  	 TOWN_DUNGEON, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_4, 	TOWN_FORTRESS, 0 );
		AllowHeroHiringByRaceForAI( PLAYER_4, TOWN_STRONGHOLD, 0 );
		MakeHeroReturnToTavernAfterDeath( "Timerkhan", not nil, 0);
		MakeHeroReturnToTavernAfterDeath(	   "Sufi", not nil, 0);
		MakeHeroReturnToTavernAfterDeath(	 "Razzak", not nil, 0);
		MakeHeroReturnToTavernAfterDeath(		"Nur", not nil, 0);
		MakeHeroReturnToTavernAfterDeath(	 "Maahir", not nil, 0);
		MakeHeroReturnToTavernAfterDeath(	  "Isher", not nil, 0);
		MakeHeroReturnToTavernAfterDeath(	  "Havez", not nil, 0);
		MakeHeroReturnToTavernAfterDeath(	   "Faiz", not nil, 0);
		MakeHeroReturnToTavernAfterDeath(	 "Astral", not nil, 0);
		SetRegionBlocked( 	   "guardAI", not nil, PLAYER_4 );
		SetRegionBlocked( "gotai_region", not nil );
		SetObjectEnabled( "broken_golem", 	  nil );
		SetDisabledObjectMode( "broken_golem", DISABLED_ATTACK );
		PlayObjectAnimation( "broken_golem", "stir00", ONESHOT_STILL );
		PlayObjectAnimation( "golem1", "death", ONESHOT_STILL );
		PlayObjectAnimation( "golem2", "death", ONESHOT_STILL );
		PlayObjectAnimation( "golem3", "death", ONESHOT_STILL );
		PlayObjectAnimation( "golem4", "death", ONESHOT_STILL );
		DenyAIHeroFlee( "Gottai", not nil );
		CINEMATICS.intro();
		Trigger( OBJECT_TOUCH_TRIGGER, "broken_golem", "BrokenGolemsVisit" );
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
			
			if GetObjectiveState('prim2_GotaiMustSurvive') == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("prim1_CaptureMainAcademyTown") == OBJECTIVE_COMPLETED and  GetObjectiveState("prim2_KillAlaric") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped( "Gottai", "A2C2M5" );
				sleep( 100 );
				Win();
				return
			end
		end
	end,
	
	captureMainTown = function()
		if OBJECTIVES.state.captureMainTown[2] == 1 then
			SetObjectiveState( "prim1_CaptureMainAcademyTown", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureMainTown[2] = 2;
		elseif OBJECTIVES.state.captureMainTown[2] == 2 and GetObjectOwner("MainAcademyTown") == PLAYER_1 then
			SetObjectiveState( "prim1_CaptureMainAcademyTown", OBJECTIVE_COMPLETED );
			CINEMATICS.captureMainTown();
			H55c_Message.show( PATH.."MsgBox_GotaiStatsBoosted.txt" );
			ChangeHeroStat( "Gottai", STAT_ATTACK, 15 );
			ChangeHeroStat( "Gottai", STAT_DEFENCE, 15 );
			ChangeHeroStat( "Gottai", STAT_SPELL_POWER, 15 );
			ChangeHeroStat( "Gottai", STAT_KNOWLEDGE, 15 );
			OBJECTIVES.state.captureMainTown[2] = 10;
		end
	end,
	
	defeatAlaric = function()
		if OBJECTIVES.state.defeatAlaric[2] == 1 and OBJECTIVES.state.captureMainTown[2] == 10 then
			DeployReserveHero( "Alaric", 62, 173, GROUND );
			sleep(10);
			DenyAIHeroFlee( "Alaric", not nil );
			AddHeroCreatures( "Alaric", CREATURE_SERAPH, 1+50*(diff - 1));
			AddHeroCreatures( "Alaric", CREATURE_CHAMPION, 1+125*(diff - 1));
			AddHeroCreatures( "Alaric", CREATURE_ZEALOT, 1+250*(diff - 1));
			AddHeroCreatures( "Alaric", CREATURE_BATTLE_GRIFFIN, 1+500*(diff - 1));
			AddHeroCreatures( "Alaric", CREATURE_VINDICATOR, 1+1000*(diff - 1));
			AddHeroCreatures( "Alaric", CREATURE_LONGBOWMAN, 1+2000*(diff - 1));
			AddHeroCreatures( "Alaric", CREATURE_LANDLORD, 1+4000*(diff - 1));
			H55c_AIAddHero( "Alaric" );
			OpenCircleFog( 62, 173, GROUND, 10, PLAYER_1 );
			sleep(10);
			MoveCamera( 62, 173, GROUND, 31, 1.2, 0, 0, 0, 1);
			sleep(50);
			H55c_Message.show( PATH.."MessageBox05_AlaricArrive.txt" );
			local hero_x, hero_y = GetObjectPosition( "Gottai" );
			MoveCamera( hero_x, hero_y, GROUND, 31, 1.2, 0, 0, 0, 1 );
			SetObjectiveState( "prim2_KillAlaric", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.defeatAlaric[2] = 2;
		elseif OBJECTIVES.state.defeatAlaric[2] == 2 and IsHeroAlive( "Alaric" ) == nil then
			CINEMATICS.outro();
			SetObjectiveState( "prim2_KillAlaric", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.defeatAlaric[2] = 10;
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive( "Gottai" ) == nil then
			SetObjectiveState( "prim2_GotaiMustSurvive", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	captureRiverTown = function()
		if OBJECTIVES.state.captureRiverTown[2] == 1 and GetObjectOwner("secondary_orcish_town") == PLAYER_1 and GetObjectOwner( "HeavenTown" ) ~= PLAYER_1 then
			SetObjectiveState( "sec3_CaptureHeavenTown", OBJECTIVE_ACTIVE );
			CINEMATICS.talkWithKenji();
			OBJECTIVES.state.captureRiverTown[2] = 2;
		elseif OBJECTIVES.state.captureRiverTown[2] == 2 and GetObjectOwner( "HeavenTown" ) == PLAYER_1 then
			SetObjectiveState( "sec3_CaptureHeavenTown", OBJECTIVE_COMPLETED );
			GiveArtefact( "Gottai", ARTIFACT_ENDLESS_BAG_OF_GOLD );
			OBJECTIVES.state.captureRiverTown[2] = 10;
		end
	end,
	
	repairGolems_visitor = "Gottai",
	repairGolems = function()
		if OBJECTIVES.state.repairGolems[2] == 1 then
			H55c_Message.show( PATH.."MessageBox04_GolemsFirstVisit.txt" );
			SetObjectiveState( "sec1_RepareGolems", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.repairGolems[2] = 3;
		elseif OBJECTIVES.state.repairGolems[2] == 3 then
			if IsHeroHasGremlins( OBJECTIVES.repairGolems_visitor ) ~= nil	then
				Trigger( OBJECT_TOUCH_TRIGGER, "broken_golem", nil );
				H55c_Message.show( PATH.."MessageBox02_GolemsRepared.txt" );
				SetObjectiveState( "sec1_RepareGolems", OBJECTIVE_COMPLETED );
				CINEMATICS.repairGolems();
				SetObjectEnabled( "broken_golem", not nil );
				SetMonsterCourageAndMood( "broken_golem", PLAYER_1, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN );
				local x,y, floor = GetObjectPosition( "broken_golem" );
				MoveHeroRealTime( OBJECTIVES.repairGolems_visitor, x, y, floor );
				OBJECTIVES.state.repairGolems[2] = 10;
			else
				H55c_Message.show(PATH.."MessageBox03_GolemsNeedHelp.txt");
				OBJECTIVES.state.repairGolems[2] = 2;
			end
		end
	end,
		
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date > OBJECTIVES.eventManager_day then
			if OBJECTIVES.date == DAY_OF_NECROMANTS_OUTCOME and GetPlayerState( PLAYER_3 ) == 1 then
				Trigger( REGION_ENTER_AND_STOP_TRIGGER, "outcome", "RemoveHero" );
				MessageBox( PATH.."NecromantsGoAway.txt" );
				startThread( NecromantsGoAway );
			end
			
			OBJECTIVES.eventManager_day = OBJECTIVES.date;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( H55c_AI_main );

function a2c2m5_dbg(var)
	if var == 1 then
		H55_Speedrun(1);
		SetObjectPosition("Gottai", 75, 160);
		H55_NoFog(1);
	elseif var == 11 then
		SetObjectPosition("Gottai", 21, 120);	
	elseif var == 111 then
		SetObjectPosition("Gottai", 12, 68);	
	elseif var == 2 then
		AddHeroCreatures("Gottai", CREATURE_MASTER_GREMLIN, 30);
	end
end
