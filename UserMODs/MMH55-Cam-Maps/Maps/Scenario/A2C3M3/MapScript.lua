doFile("/scripts/A2_Zehir/A2_Zehir.lua");
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_PlayerStatus = {0,1,1,2,2,2,2,2};

function f_artifacts_sets()
	InitAllSetArtifacts( "A2C3M3", "Zehir" );
	LoadHeroAllSetArtifacts( "Zehir", "A2C3M2" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Wulfstan" );
	H55_CamFixTooManySkills( PLAYER_1,    "Zehir" );
end

startThread( f_artifacts_sets );
OBJECT_SUB_GATE_EXIT_AI = 'Sub_gate_exit_ai';

function f_init_zehir_abilities()
	ZehirCreaturesAdd(CREATURE_RAKSHASA_KSHATRI, 12 - diff * 2, MERCURY, 20, 4500);
	ZehirAbilitiesInit( "Zehir" );
	ZehirTownInit("Mutazz");
	AddTownPoint(27, 48, GROUND, 0, "Checker_place_for_town", 20000, "Get_out")
end

function PlayVoiceoverIfZehirExitUnderground()
	local x, y, floor;
	repeat 
		sleep(20); 
		x,y,floor = GetObjectPosition('Zehir'); 
	until floor == GROUND;
	MessageBox("/Maps/Scenario/A2C3M3/message_007.txt", "Play2DSound('/Maps/Scenario/A2C3M3/C3M3_VO3_Zehir_01sound.xdb#xpointer(/Sound)')");
end

function PlayVoiceoverIfZehirHasKey()
	repeat sleep(20); until HasBorderguardKey( PLAYER_1, RED_KEY )==not nil;
	Play2DSound( "/Maps/Scenario/A2C3M3/C3M3_VO5_Zehir_01sound.xdb#xpointer(/Sound)" );
end

function PlayVoiceoverIfZehirNearExit( hero )
	if hero == 'Zehir' then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "Ai_block_zone2", nil );
		Play2DSound( "/Maps/Scenario/A2C3M3/C3M3_VO2_Zehir_01sound.xdb#xpointer(/Sound)" );
	end
end

function PlayVoiceoverIfZehirNearShrine( hero )
	if hero == 'Zehir' then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ShrineRegion", nil );
		Play2DSound( "/Maps/Scenario/A2C3M3/C3M3_VO4_Zehir_01sound.xdb#xpointer(/Sound)" );
	end
end

function f_AtDwarenDragonGodPortal(hero)
	if hero == 'Zehir' then
		OBJECTIVES.state.findDragonGod[2] = 3;
	else
		MessageBox("/Maps/Scenario/A2C3M3/MsgBox_OnlyZehirCanEnterGate.txt");
	end
end

function f_one_way_teleport_blocked()
	SetObjectEnabled('One_way_teleport_ai', nil);
	startThread( MessageBox, "/Maps/Scenario/A2C3M3/message_003.txt" );
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "About_Block_player_zone", "f_deactivator_one_way_teleport_blocked" );
	Trigger( OBJECT_TOUCH_TRIGGER, 'One_way_teleport_ai', "MessageBox('/Maps/Scenario/A2C3M3/message_003.txt')" );
end;

function f_deactivator_one_way_teleport_blocked()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "About_Block_player_zone", nil);
	SetObjectEnabled('One_way_teleport_ai', not nil);
end

function f_show_message_002()
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Warning_zone2", nil);
	MessageBox("/Maps/Scenario/A2C3M3/message_002.txt");
end

function f_show_message_005() --Запускается триггером Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Warning_zone", "f_show_message_005")
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Warning_zone", nil);
	OpenCircleFog(77, 67, 1, 5, 1);
	sleep(2);
	MoveCamera(77, 67, 1, 30, 1, 0, 0, 0, 1);
	MessageBox("/Maps/Scenario/A2C3M3/message_005.txt");
end

function SubTerrainEntranceInteract( hero )
	if hero == 'Wulfstan' then
		MessageBox("/Maps/Scenario/A2C3M3/message_001.txt");
	elseif hero ~= 'Zehir' then
		MessageBox("/Maps/Scenario/A2C3M3/message_006.txt");
	end
end

function ShowMessageOnlyZehirCanPass( hero )
	if hero ~= "Zehir" then
		MessageBox( "/Maps/Scenario/A2C3M3/MsgBox_OnlyZehirCanEnterGate.txt" );
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
		CINEMATICS.playAndWait( 0 );
	end,

	outro = function()
		StartDialogScene("/DialogScenes/A2C3/M3/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	meetRolf = function()
		BlockGame();
		SetObjectPosition( 'Rolf', 13, 81, GROUND );
		CINEMATICS.playAndWait( 1 );
		UnblockGame();
	end,
}

DIFFICULTY = {
	[0] = function()
		diff = 1;
		AddHeroCreatures( 'Zehir', CREATURE_ARCH_MAGI, 10 );
		AddHeroCreatures( 'Zehir', CREATURE_GENIE, 5 );
		AddHeroCreatures( 'Zehir', CREATURE_RAKSHASA_KSHATRI, 3 );
		print( "normal" );
	end,
	
	[1] = function()
		diff = 2;
		AddHeroCreatures( 'Zehir', CREATURE_ARCH_MAGI, 7 );
		AddHeroCreatures( 'Zehir', CREATURE_GENIE, 4 );
		AddHeroCreatures( 'Zehir', CREATURE_RAKSHASA_KSHATRI, 2 );
		print( "hard" );
	end,
	
	[2] = function()
		diff = 3;
		AddHeroCreatures( 'Zehir', CREATURE_ARCH_MAGI, 4 );
		AddHeroCreatures( 'Zehir', CREATURE_RAKSHASA_KSHATRI, 1 );
		print( "heroic" );
	end,
	
	[3] = function()
		diff = 4;
		print( "impossible" );
	end,
}
		
OBJECTIVES = {
	state = {
		isWulfstanAlive = { "pri1", 1 },	-- Wulfstan must stay alive
		isZehirAlive 	= { "pri2", 1 },	-- Zehir must stay alive
		isHangvulAlive 	= { "pri3", 1 },	-- Hangvul must stay alive
		findDragonGod 	= { "pri4", 1 },	-- find the dwarven dragon god of fire
		defeatRolf 		= { "pri5", 1 },	-- defeat enemy hero Rolf
		eventManager	= {    "_", 1 },	-- Controls enemy hero deployment
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		if GetGameVar("A2C3M2_ZehirHasGrail") == "1" then
			GiveArtefact('Zehir', ARTIFACT_GRAAL);
		end
		DIFFICULTY[GetDifficulty()]();
		startThread( f_init_zehir_abilities );
		SetObjectEnabled('Teleport_to_Dragon', nil);
		SetDisabledObjectMode( 'Teleport_to_Dragon', DISABLED_INTERACT );
		Trigger(OBJECT_TOUCH_TRIGGER, 'Teleport_to_Dragon', "f_AtDwarenDragonGodPortal");
		SetObjectEnabled( "BorderGuard", nil );
		SetDisabledObjectMode( "BorderGuard", DISABLED_INTERACT );
		SetPlayerStartResources( PLAYER_2, 100, 100,  50, 50,  100,  50, 90000 );
		SetPlayerStartResources (PLAYER_3, 100, 100, 100, 100, 100, 100, 100000 );
		SetRegionBlocked(  "Ai_block_zone", 1, PLAYER_2 );
		SetRegionBlocked( "Ai_block_zone2", 1, PLAYER_2 );
		SetRegionBlocked( "Ai_block_zone3", 1, PLAYER_2 );
		SetRegionBlocked( "Ai_block_zone4", 1, PLAYER_2 );
		AllowPlayerTavernHero( PLAYER_1, 'Zehir', 1 );
		AllowPlayerTavernHero( PLAYER_1,  'Rolf', 0 );
		AllowPlayerTavernHero( PLAYER_2,  'Rolf', 0 );
		AllowPlayerTavernHero( PLAYER_3,  'Rolf', 0 );
		EnableHeroAI( 'Rolf', nil );
		EnableHeroAI( 'Hangvul', nil );
		SetHeroRoleMode( 'Rolf', HERO_ROLE_MODE_HERMIT );
		-- Block SubTerrainEntrance for anyone but Zehir
		SetDisabledObjectMode( 'Sub_gate_exit_home' , DISABLED_INTERACT );
		Trigger( OBJECT_TOUCH_TRIGGER, 'Sub_gate_exit_home', "SubTerrainEntranceInteract" );
		SetRegionAutoObjectEnable( "check1b", REGION_AUTOACTION_ON_ENTER, -1, PLAYER_1, "", 'Sub_gate_exit_home', 0 );
		SetRegionAutoObjectEnable( "check1b", REGION_AUTOACTION_ON_EXIT,  -1, PLAYER_1, "", 'Sub_gate_exit_home', 1 );
		SetRegionAutoObjectEnable( "check1b", REGION_AUTOACTION_ON_ENTER, -1, PLAYER_1, 'Zehir', 'Sub_gate_exit_home', -1 );
		SetRegionAutoObjectEnable( "check1b", REGION_AUTOACTION_ON_EXIT,  -1, PLAYER_1, 'Zehir', 'Sub_gate_exit_home', -1 );
		SetDisabledObjectMode( 'One_way_teleport_ai' , DISABLED_INTERACT );
		SetRegionBlocked( "Get_out", not nil ); -- reserve region for Zehir's town
		AllowHeroHiringByRaceInTown( 'Mutazz', -1, 0 );
		AllowHiringOfHeroInTown( 'Mutazz', 'Zehir', 1 );
		AllowHiringOfHeroInTown( 'Kolvard', 'Zehir', 0 );
		MakeHeroReturnToTavernAfterDeath('Zehir', 1, 1 );
		DenyAIHeroFlee('Zehir', not nil);
		DenyAIHeroFlee('Wulfstan', not nil);
		DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes( PLAYER_3, not nil );		
		CINEMATICS.intro();
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Block_player_zone", "f_one_way_teleport_blocked");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Warning_zone", "f_show_message_005");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Warning_zone2", "f_show_message_002");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "ShrineRegion", "PlayVoiceoverIfZehirNearShrine");
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "Ai_block_zone2", "PlayVoiceoverIfZehirNearExit" );
		--Trigger(REGION_ENTER_AND_STOP_TRIGGER, "Dragon_hall_zone", "f_show_message_004");
		SetRegionAutoObjectEnable( "shrine_blocker", REGION_AUTOACTION_ON_ENTER, -1, PLAYER_1, 'Zehir', "BorderGuard", 1 );
		SetRegionAutoObjectEnable( "shrine_blocker", REGION_AUTOACTION_ON_EXIT, -1, PLAYER_1, 'Zehir', "BorderGuard", 0 );
		Trigger( OBJECT_TOUCH_TRIGGER, "BorderGuard", "ShowMessageOnlyZehirCanPass" );
		startThread( OpenCircleFog, 13, 14, 1, 4, 1 );
		startThread( PlayVoiceoverIfZehirExitUnderground );
		startThread( PlayVoiceoverIfZehirHasKey );
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
			
			if GetObjectiveState("pri1") == OBJECTIVE_FAILED or GetObjectiveState("pri2") == OBJECTIVE_FAILED or GetObjectiveState("pri3") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("pri4") == OBJECTIVE_COMPLETED then
				if HasArtefact( 'Zehir', ARTIFACT_GRAAL ) ~= nil then 
					SetGameVar("A2C3M3_Graal", "1");
				elseif GetTownBuildingLevel('Mutazz', TOWN_BUILDING_GRAIL) ~= nil then
					SetGameVar("A2C3M3_Graal", "2");
				end
				SaveHeroAllSetArtifactsEquipped( 	"Zehir", "A2C3M3" );
				SaveHeroAllSetArtifactsEquipped( "Wulfstan", "A2C3M3" );
				CINEMATICS.outro();
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	isWulfstanAlive = function()
		if OBJECTIVES.state.isWulfstanAlive[2] == 1 then
			 SetObjectiveState( 'pri1', OBJECTIVE_ACTIVE, PLAYER_1 );
			OBJECTIVES.state.isWulfstanAlive[2] = 2;
		elseif OBJECTIVES.state.isWulfstanAlive[2] == 2 and IsHeroAlive('Wulfstan') == nil then
			SetObjectiveState("pri1", OBJECTIVE_FAILED, PLAYER_1);		
			OBJECTIVES.state.isWulfstanAlive[2] = 11;
		end
	end,
	
	isZehirAlive = function()
		if OBJECTIVES.state.isZehirAlive[2] == 1 then
			SetObjectiveState( 'pri2', OBJECTIVE_ACTIVE, PLAYER_1 );
			OBJECTIVES.state.isZehirAlive[2] = 2;
		elseif OBJECTIVES.state.isZehirAlive[2] == 2 and IsHeroAlive('Zehir') == nil and GetObjectOwner('Mutazz') ~= PLAYER_1 then
			SetObjectiveState("pri2", OBJECTIVE_FAILED, PLAYER_1);
			OBJECTIVES.state.isZehirAlive[2] = 11;
		end
	end,
	
	isHangvulAlive = function()
		if OBJECTIVES.state.isHangvulAlive[2] == 1 then
			SetObjectiveState( 'pri3', OBJECTIVE_ACTIVE, PLAYER_1 );
			OBJECTIVES.state.isHangvulAlive[2] = 2;
		elseif OBJECTIVES.state.isHangvulAlive[2] == 2 and IsHeroAlive('Hangvul') == nil then
			SetObjectiveState("pri3", OBJECTIVE_FAILED, PLAYER_1);
			OBJECTIVES.state.isHangvulAlive[2] = 11;
		end
	end,
	
	findDragonGod_armyDay = 15,
	findDragonGod = function()
		if OBJECTIVES.state.findDragonGod[2] == 1 then
			SetObjectiveState( 'pri4', OBJECTIVE_ACTIVE, PLAYER_1 );
			OBJECTIVES.state.findDragonGod[2] = 2;
		elseif OBJECTIVES.state.findDragonGod[2] == 3 then
			if GetHeroLevel('Zehir') < 25 then 
				MessageBox("/Maps/Scenario/A2C3M3/message_008.txt");
				OBJECTIVES.state.findDragonGod[2] = 2;
			else
				SetObjectiveState( "pri4", OBJECTIVE_COMPLETED, PLAYER_1 );
				OBJECTIVES.state.findDragonGod[2] = 10;
			end
		end
		
		if OBJECTIVES.date >= OBJECTIVES.findDragonGod_armyDay then	
			AddObjectCreatures( "HangvulHide", CREATURE_LAVA_DRAGON, 9*diff);
			AddObjectCreatures( "HangvulHide", CREATURE_THUNDER_THANE, 18*diff);
			AddObjectCreatures( "HangvulHide", CREATURE_FLAME_KEEPER, 27*diff);
			AddObjectCreatures( "HangvulHide", CREATURE_BATTLE_RAGER, 45*diff);
			AddObjectCreatures( "HangvulHide", CREATURE_WHITE_BEAR_RIDER, 63*diff);
			AddObjectCreatures( "HangvulHide", CREATURE_HARPOONER, 126*diff);
			AddObjectCreatures( "HangvulHide", CREATURE_STONE_DEFENDER, 144*diff);
			OBJECTIVES.findDragonGod_armyDay = OBJECTIVES.findDragonGod_armyDay + 7;			
		end
	end,
	
	defeatRolf = function()
		if OBJECTIVES.state.defeatRolf[2] == 1 and IsObjectExists("BorderGuard") == nil then
			CINEMATICS.meetRolf();
			SetObjectiveState( "pri5", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.defeatRolf[2] = 2;
		elseif OBJECTIVES.state.defeatRolf[2] == 2 and IsHeroAlive( 'Rolf' ) == nil then
			SetObjectiveState( "pri5", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.defeatRolf[2] = 10;
		end
	end,
	
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date > OBJECTIVES.eventManager_day then
			if OBJECTIVES.state.eventManager[2] == 1 then
				if OBJECTIVES.date == 2 then
					DeployReserveHero('Bersy', 67, 64, 1);
					sleep(20);
					ChangeHeroStat('Bersy', STAT_EXPERIENCE, diff * 3000 );
				elseif OBJECTIVES.date == 8 then
					DeployReserveHero('Egil', 67, 64, 1);
					sleep(4);
					ChangeHeroStat('Egil', STAT_EXPERIENCE, diff * 15000 );
				elseif OBJECTIVES.date >= 20 then
					DeployReserveHero('Ottar', 67, 64, 1);			
					sleep(4);
					ChangeHeroStat('Ottar', STAT_EXPERIENCE, diff * 30000 );
					sleep(6);
					OBJECTIVES.state.eventManager[2] = 2;
				end
			elseif OBJECTIVES.state.eventManager[2] == 2 then
				for i, ofender in { { "Bersy", 1 }, { "Egil", 3 }, { "Ottar", 7 }, } do
					if GetDate( DAY_OF_WEEK ) == ofender[2] and IsHeroAlive( ofender[1] ) == nil then
						DeployReserveHero( ofender[1], 67, 64, 1);
					end
				end
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.date;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
