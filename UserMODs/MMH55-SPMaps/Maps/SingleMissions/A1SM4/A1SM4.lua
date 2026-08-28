doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
end

H55_PlayerStatus = {0,2,1,2,1,2,2,2};

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
		sleep(2);
	end,
	
	outro = function()
		SetObjectPosition( "KingTolghar", 80, 92, 1 );
		CreateMonster( "fake", CREATURE_BEAR_RIDER, 1, 85, 92, 1, 0, 0, 270 );
		sleep( 10 );
		SetObjectRotation( "KingTolghar", 90);
		CINEMATICS.playAndWait( 1 );
	end,
}

OBJECTIVES = {
	date = 0,
	state = {
		defeatClans   = { "obj1", 0 }, -- Defeat the other Dwarven clans
		occupyCapital = { "obj2", 1 }, -- Occupy and hold the capital
		isAlive		  = { "obj3", 1 }, -- King Tolghar must survive
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		CINEMATICS.intro();
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

			if GetObjectiveState("obj3") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and GetObjectiveState("obj1") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep( 100 );
				Win( PLAYER_1 );
				return
			end
		end
	end,
	
	defeatClans = function()
	-- lifeycle of this task is controlled by the map.xdb file
	end,

	occupyCapital = function()
	-- start of this task is handled by the map.xdb file
		if OBJECTIVES.state.occupyCapital[2] == 1 and GetObjectOwner("capital") == PLAYER_1 then
			SetObjectiveState( "obj2", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.occupyCapital[2] = 2;
		elseif OBJECTIVES.state.occupyCapital[2] == 2 and GetObjectOwner("capital") ~= PLAYER_1 then
			SetObjectiveState( "obj2", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.occupyCapital[2] = 1;
		end
	end,

	isAlive = function()
	-- start of this task is handled by the map.xdb file
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("KingTolghar") == nil then
			SetObjectiveState( "obj3", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)

function a1sm4_dbg(var)
	if var == 1 then
		H55_Speedrun(1);
		SetObjectOwner( "capital", 1 );
	elseif var == 2 then
		SetObjectPosition("KingTolghar", 155, 85);
	elseif var == 22 then
		SetObjectPosition("KingTolghar", 34, 131);
	end
end