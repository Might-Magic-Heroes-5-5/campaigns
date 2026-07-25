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
		StartDialogScene( "/DialogScenes/A1Single/SM2/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep(2);
	end,
	
	outro = function()
		SetObjectPosition( "Heam", 80, 76, 1 );
		CreateMonster( "fake", CREATURE_WAR_DANCER, 1, 84, 76, 1, 0, 0 );
		sleep(5);
		SetObjectRotation( "Heam", 90 );
		SetObjectRotation( "fake", 270 );
		sleep(20);
		CINEMATICS.playAndWait( 0 );
	end
}

OBJECTIVES = {
	date = 0,
	state = {
		defeatAlmegir = { "Prim1", 1 },
		isAlive		  = { "Prim2", 1 },
		captureTowns  = { "Prim3", 1 },
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

			if GetObjectiveState("Prim2") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("Prim1") == OBJECTIVE_COMPLETED and GetObjectiveState("Prim3") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep( 100 );
				Win( PLAYER_1 );
				return
			end
		end
	end,
	
	defeatAlmegir = function()
	-- objective state start is controlled by the map.xdb file
		if OBJECTIVES.state.defeatAlmegir[2] == 1 and IsHeroAlive("Almegir") == nil then
			SetObjectiveState( "Prim1", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.defeatAlmegir[2] = 10;
		end
	end,
	
	isAlive = function()
	-- objective state start is controlled by the map.xdb file
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Heam") == nil then
			SetObjectiveState( 'Prim2', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	captureTowns = function()
	-- objective state start is controlled by the map.xdb file
		if OBJECTIVES.state.captureTowns[2] == 1 and GetObjectOwner("Air") == PLAYER_1 and GetObjectOwner("Fire") == PLAYER_1 and GetObjectOwner("Water") == PLAYER_1 and GetObjectOwner("Earth") == PLAYER_1 and GetObjectOwner("Final") == PLAYER_1 and GetObjectOwner("First") == PLAYER_1 then
			SetObjectiveState( "Prim3", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.captureTowns[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)

function a1sm2_dbg(var)
	if var == 1 then
		for i, town in { "Air", "Water", "Fire", "Earth", "Final" } do
			SetObjectOwner( town, 1 );
		end
	elseif var == 2 then
		RemoveObject("Almegir");
	end
end