H55_PlayerStatus = {0,1,2,2,2,2,2,2};
H55_AICheatMode = 0;

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C6M1");
end

startThread(H55_InitSetArtifacts);

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C6/M1/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	captureTown = function()
		StartDialogScene("/DialogScenes/C6/M1/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	getLevel10 = function()
		StartDialogScene("/DialogScenes/C6/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

OBJECTIVES = {
	state = {
		captureTown	= { "prim1", 1 }, 			-- Capture Insarius
		isAlive		= { "prim2", 1 }, 			-- Defeat Nikolay
		getLevel10	= { "prim3", 1 }, 			-- Get level 10
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		CINEMATICS.intro();
		SetRegionBlocked('noway1', not nil, PLAYER_2);
		SetRegionBlocked('noway2', not nil, PLAYER_2);
		SetRegionBlocked('block', not nil, PLAYER_2);
	end,
	
	run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					OBJECTIVES[key]();
				end
			end

			if GetObjectiveState("prim1") == OBJECTIVE_FAILED or GetObjectiveState("prim2") == OBJECTIVE_FAILED or GetObjectiveState("prim3") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if  GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Zehir", "C6M1");
				sleep(50);
				Win();
				return
			end
		end
	end,
	
	captureTown = function()
		-- Objective is started by C6M1.xdb
		if OBJECTIVES.state.captureTown[2] == 1 and GetObjectOwner("insarius") == PLAYER_1 then
			ChangeHeroStat("Zehir", STAT_EXPERIENCE, 546);
			SetRegionBlocked('exit', not nil, PLAYER_2);
			CINEMATICS.captureTown();
			OBJECTIVES.state.captureTown[2] = 2;
		elseif OBJECTIVES.state.captureTown[2] == 2 and GetObjectOwner("insarius") == PLAYER_1 then
			SetObjectiveState('prim1', OBJECTIVE_COMPLETED);
			OBJECTIVES.state.captureTown[2] = 3;
		elseif OBJECTIVES.state.captureTown[2] == 3 and GetObjectOwner("insarius") ~= PLAYER_1 then
			SetObjectiveState('prim1', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.captureTown[2] = 2;
		end
	end,
	
	isAlive = function()
		-- Objective is started by C6M1.xdb
		if IsHeroAlive("Zehir") == nil then
			SetObjectiveState("prim2", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	getLevel10 = function()
		-- Objective is started by C6M1.xdb
		if OBJECTIVES.state.getLevel10[2] == 1 and GetHeroLevel("Zehir") >= 10 then
			CINEMATICS.getLevel10();
			SetObjectiveState('prim3', OBJECTIVE_COMPLETED);
			OBJECTIVES.state.getLevel10[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
