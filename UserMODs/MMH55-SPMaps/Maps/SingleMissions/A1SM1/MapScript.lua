doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
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
		StartDialogScene( "/DialogScenes/A1Single/SM1/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep(2);
	end,
	
	outro = function()
		SetObjectPosition( "Giovanni", 67, 118, 0 );
		SetObjectPosition( "Ornella", 71, 118, 0 );
		SetObjectRotation( "Giovanni", 90 );
		SetObjectRotation( "Ornella", 270 );
		sleep( 20 );
		CINEMATICS.playAndWait( 0 );
	end
}

OBJECTIVES = {
	date = 0,
	state = {
		captureTowns = { "prim1", 1 },
		isAlive		 = { "prim2", 1 },
		eventManager = {	 "_", 1 },
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		CINEMATICS.intro();
		slozhnost = GetDifficulty(); 
		if slozhnost == DIFFICULTY_EASY then 
			print("Closed"); 
			SetRegionBlocked("bl1", 1, PLAYER_2);
			SetRegionBlocked("bl2", 1, PLAYER_2);
			SetRegionBlocked("bl3", 1, PLAYER_2);
		end
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

			if GetObjectiveState("prim2") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep(100);
				Win( PLAYER_1 );
				return
			end
		end
	end,
	
	captureTowns = function()
		if OBJECTIVES.state.captureTowns[2] == 1 and GetObjectOwner("Town1") == PLAYER_1 and GetObjectOwner("Town2") == PLAYER_1 and GetObjectOwner("Town3") == PLAYER_1 then
			SetObjectiveState( "prim1", OBJECTIVE_COMPLETED );
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 and ( IsHeroAlive("Giovanni") == nil or IsHeroAlive("Ornella") == nil ) then
			SetObjectiveState( 'prim2', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	eventManager_day = 0,
	eventManager = function()
		if OBJECTIVES.date > OBJECTIVES.eventManager_day then
			if OBJECTIVES.date == 29 and slozhnost == DIFFICULTY_EASY then 
				print("Open_all");
				SetRegionBlocked("bl1", nil, PLAYER_2);
				SetRegionBlocked("bl2", nil, PLAYER_2);
				SetRegionBlocked("bl3", nil, PLAYER_2);
				OBJECTIVES.state.eventManager[2] = 10;
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.date;
		end
	end
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
