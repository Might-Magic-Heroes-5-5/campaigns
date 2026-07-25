doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
end

H55_PlayerStatus = {0,1,1,1,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_UNICORN_HORN_BOW,
	ARTIFACT_TREEBORN_QUIVER
};

DIFFICULTY = {
	[0] = function()
		AddHeroCreatures("Linaas", CREATURE_WOOD_ELF, 30);
		AddHeroCreatures("Linaas", CREATURE_DRUID, 6);
		RemoveObjectCreatures("G1", CREATURE_ASSASSIN, 100);
		RemoveObjectCreatures("G1", CREATURE_BLOOD_WITCH, 30);
		RemoveObjectCreatures("G1", CREATURE_MINOTAUR_KING, 40);
		RemoveObjectCreatures("G2", CREATURE_ASSASSIN, 100);
		RemoveObjectCreatures("G2", CREATURE_BLOOD_WITCH, 30);
		RemoveObjectCreatures("G2", CREATURE_MINOTAUR_KING, 40);
		print ("normal");
	end,

	[1] = function()
		AddHeroCreatures("Linaas", CREATURE_WOOD_ELF, 10);
		RemoveObjectCreatures("G1", CREATURE_ASSASSIN, 50);
		RemoveObjectCreatures("G1", CREATURE_BLOOD_WITCH, 20);
		RemoveObjectCreatures("G1", CREATURE_MINOTAUR_KING, 15);
		RemoveObjectCreatures("G2", CREATURE_ASSASSIN, 50);
		RemoveObjectCreatures("G2", CREATURE_BLOOD_WITCH, 20);
		RemoveObjectCreatures("G2", CREATURE_MINOTAUR_KING, 15);
		print ("hard");
	end,

	[2] = function()
		print ("heroic");
	end,

	[3] = function()
		print ("impossible");
	end,
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/A2Single/SM2/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	conquerTown = function()
		StartDialogScene("/DialogScenes/A2Single/SM2/S2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	destroyRenegadeElves = function()
		BlockGame();
		Play2DSound( "/Maps/SingleMissions/A2S2/SM2_VO3_Tieru_01sound.xdb#xpointer(/Sound)" );
		sleep( GetSoundTimeInSleeps( "/Maps/SingleMissions/A2S2/SM2_VO3_Tieru_01sound.xdb#xpointer(/Sound)" ) );
		UnblockGame();
	end,
	
	eliminateDarkElves = function()
		BlockGame();
		Play2DSound( "/Maps/SingleMissions/A2S2/SM2_VO4_Tieru_02sound.xdb#xpointer(/Sound)" );
		sleep( GetSoundTimeInSleeps( "/Maps/SingleMissions/A2S2/SM2_VO4_Tieru_02sound.xdb#xpointer(/Sound)" ) );
		UnblockGame();
	end,
	
	BowAndQuiverStart = function()
		BlockGame();
		Play2DSound( "/Maps/SingleMissions/A2S2/SM2_VO5_Tieru_01sound.xdb#xpointer(/Sound)" );
		sleep( GetSoundTimeInSleeps( "/Maps/SingleMissions/A2S2/SM2_VO5_Tieru_01sound.xdb#xpointer(/Sound)" ) );
		UnblockGame();
	end,
	
	findBowAndArrow = function()
		BlockGame();
		Play2DSound( "/Maps/SingleMissions/A2S2/SM2_VO6_Tieru_01sound.xdb#xpointer(/Sound)" )
		sleep( GetSoundTimeInSleeps( "/Maps/SingleMissions/A2S2/SM2_VO6_Tieru_01sound.xdb#xpointer(/Sound)" ) );
		UnblockGame();
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/A2Single/SM2/S3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

OBJECTIVES = {
	date = 0,
	state = {
		conquerTown 			= { 'Prim1', 1 },
		destroyRenegadeElves 	= { 'Prim2', 1 },
		eliminateDarkElves		= { 'Prim3', 1 },
		isAlive					= { 'Prim4', 1 },
		findBowAndArrow			= {  'sec1', 1 }, -- and sec2
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		for i, player in { PLAYER_2, PLAYER_3, PLAYER_4 } do
			SetRegionBlocked("block1", 1, player);
			SetRegionBlocked("block2", 1, player); 
		end
		CINEMATICS.intro();
		DIFFICULTY[GetDifficulty()]();
		OpenCircleFog( 44, 51, 0, 6, PLAYER_1 );
		OpenCircleFog( 80, 93, 0, 6, PLAYER_1 );
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

			if GetObjectiveState("Prim4") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("Prim2") == OBJECTIVE_COMPLETED and GetObjectiveState("Prim3") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep( 100 );
				Win();
				return
			end
		end
	end,
	
	conquerTown_warning = nil,	
	conquerTown = function()	
		if OBJECTIVES.state.conquerTown[2] == 1 then
			SetObjectiveState('Prim1',OBJECTIVE_ACTIVE);
			OBJECTIVES.state.conquerTown[2] = 2;
		elseif OBJECTIVES.state.conquerTown[2] == 2 then
			if OBJECTIVES.date == 6 and conquerTown_warning == nil then
				Play2DSound( "/Maps/SingleMissions/A2S2/SM2_VO7_Tieru_01sound.xdb#xpointer(/Sound)" );
				OBJECTIVES.conquerTown_warning = not nil;
			elseif GetObjectOwner("E1") == PLAYER_1 or GetObjectOwner("E2") == PLAYER_1 then
				CINEMATICS.conquerTown();
				SetObjectiveState('Prim1', OBJECTIVE_COMPLETED);
				sleep( 10 );
				Play2DSound( "/Maps/SingleMissions/A2S2/SM2_VO2_Tieru_01sound.xdb#xpointer(/Sound)" );
				OBJECTIVES.state.conquerTown[2] = 10;
			end
		end
	end,
	
	destroyRenegadeElves = function()
		if OBJECTIVES.state.destroyRenegadeElves[2] == 1 and OBJECTIVES.state.conquerTown[2] == 10 then
			SetObjectiveState('Prim2',OBJECTIVE_ACTIVE);
			OBJECTIVES.state.destroyRenegadeElves[2] = 2;
		elseif OBJECTIVES.state.destroyRenegadeElves[2] == 2 and GetPlayerState(PLAYER_2) == 3 then
			CINEMATICS.destroyRenegadeElves();
			SetObjectiveState( 'Prim2', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.destroyRenegadeElves[2] = 10;
		end
	end,
	
	eliminateDarkElves = function()
		if OBJECTIVES.state.eliminateDarkElves[2] == 1 and OBJECTIVES.state.conquerTown[2] == 10 then
			SetObjectiveState( 'Prim3', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.eliminateDarkElves[2] = 2;
		elseif OBJECTIVES.state.eliminateDarkElves[2] == 2 and GetPlayerState(PLAYER_3) == 3 and GetPlayerState(PLAYER_4) == 3 then
			CINEMATICS.eliminateDarkElves();
			SetObjectiveState( 'Prim3', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.eliminateDarkElves[2] = 10;
		end
	end,

	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState('Prim4', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 and IsHeroAlive("Linaas") == nil then
			SetObjectiveState('Prim4', OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	findBowAndArrow = function()
		if OBJECTIVES.state.findBowAndArrow[2] == 1 and OBJECTIVES.date >= 4 then
			SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE );
			SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE );
			CINEMATICS.BowAndQuiverStart();
			OBJECTIVES.state.findBowAndArrow[2] = 2;
		elseif OBJECTIVES.state.findBowAndArrow[2] == 2 and GetObjectiveState( "sec1" ) == OBJECTIVE_COMPLETED then
			CINEMATICS.findBowAndArrow();
			OBJECTIVES.state.findBowAndArrow[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
