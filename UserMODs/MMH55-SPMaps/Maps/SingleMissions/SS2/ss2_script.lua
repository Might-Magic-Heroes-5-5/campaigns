doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep();
end

H55_PlayerStatus = {0,1,2,2,2,2,2,2};

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/Single/SS2/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	captureTown = function()
		StartDialogScene("/DialogScenes/Single/SS2/R3A1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	defeatElain = function()
		StartDialogScene("/DialogScenes/Single/SS2/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/Single/SS2/R3A2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
}

OBJECTIVES = {
	state = {
		  defeatFalcon = { "Prim1", 0 },	-- defeat FalconEmpire
		  isAlive	   = { "Prim2", 0 },	-- Jezbeth must survive
		  eventManager = { 	   "_", 1 },	-- Resurrect Maeve
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		CINEMATICS.intro();
		DeployReserveHero("Maeve", 83, 73, 0);
		sleep(10);
		RemoveHeroCreatures("Maeve", CREATURE_ARCHANGEL, 9);
		SetRegionBlocked("border", 1, PLAYER_2);
		SetRegionBlocked("M1", 1, PLAYER_2);
		SetRegionBlocked("M2", 1, PLAYER_2);
		SetRegionBlocked("M3", 1, PLAYER_2); 
		sleep(20);
		H55_NewDayTrigger = 1;
		sleep(20);
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
			
			if GetObjectiveState('Prim2') == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState('Prim1', PLAYER_1) == OBJECTIVE_COMPLETED then 
				CINEMATICS.outro();
				sleep(30);
				Win(PLAYER_1);
				return
			end
		end
	end,
	
	defeatFalcon = function()
		if OBJECTIVES.state.defeatFalcon[2] == 1 then
			if GetObjectOwner("Falconhill") == PLAYER_1 and IsHeroAlive("Maeve") ~= nil then 
				CINEMATICS.captureTown();
				OBJECTIVES.state.defeatFalcon[2] = 2;
			elseif IsHeroAlive("Maeve") == nil and GetObjectOwner("Falconhill") ~= PLAYER_1 then
				CINEMATICS.defeatElain();
				OBJECTIVES.state.defeatFalcon[2] = 2;
			elseif IsHeroAlive("Maeve") == nil and GetObjectOwner("Falconhill") == PLAYER_1 then
				OBJECTIVES.state.defeatFalcon[2] = 2;
			end
		elseif OBJECTIVES.state.defeatFalcon[2] == 2 and GetObjectOwner("Falconhill") == PLAYER_1 and IsHeroAlive("Maeve") == nil then
			SetObjectiveState('Prim1',OBJECTIVE_COMPLETED);
			OBJECTIVES.state.defeatFalcon[2] = 10;
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Oddrema") == nil then
			SetObjectiveState('Prim2', OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date >= OBJECTIVES.eventManager_day then
			if GetObjectOwner("Falconhill") ~= PLAYER_1 and GetObjectiveState('Prim1', PLAYER_1) ~= OBJECTIVE_COMPLETED and IsHeroAlive("Maeve") == nil then 
				DeployReserveHero("Maeve", 75, 70, 0);
				SetRegionBlocked("border", nil, PLAYER_2);
				sleep(20);
				MoveHero( "Maeve", 83, 79, 0 );
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.date + 1;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start )
