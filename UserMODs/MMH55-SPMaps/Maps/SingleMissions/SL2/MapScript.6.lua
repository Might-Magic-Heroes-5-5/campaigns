doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_PlayerStatus = {0,1,1,1,1,2,2,2};

H55c_AI_CONTROLLED = {
  player1 = {          -- Teal HUMAN player
      state = 0,
	   heroes = {},
	   enemies = {},
  },
  player2 = {          -- Green AI player - Sylvan
		state = 1,
		heroes = {},
		enemies = {},
  },
  player3 = {         -- Red AI player - Inferno
		state = 1,
		heroes = {},
		enemies = {},
  },
  player4 = {         -- Yellow AI player - Accademy
		state = 1,
		heroes = {},
		enemies = {},
  },
  player5 = { 		   -- Orange AI player - Accademy invasion 
		state = 2,
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 0.6, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER5
		}
  },
}

function SL2_GetStart(region)
	local x, y, z = RegionToPoint(region);
	return { x, y, z };
end

SL2_TOWNS = { "Academy", "Necropolis", "Inferno", "Sylvan" };
SL2_INVASION = {
	["Tan"] 	= { start = 	SL2_GetStart( "SylvanStart" ), army = {    CREATURE_ARCH_MAGI, 10,	   CREATURE_COMBAT_MAGE, 10,		CREATURE_GENIE,  5,	 		CREATURE_RAKSHASA,   3, CREATURE_MARBLE_GARGOYLE, 20, 		   CREATURE_GREMLIN_SABOTEUR, 30 }  },
	["Faiz"] 	= { start =    SL2_GetStart( "AcademyStart" ), army = {	 CREATURE_COMBAT_MAGE, 10,		  CREATURE_RAKSHASA, 10, CREATURE_MASTER_GENIE, 12,		  CREATURE_STORM_LORD,   4,		CREATURE_STEEL_GOLEM, 25, 	CREATURE_MASTER_GREMLIN, 40 }  },
	["Havez"] 	= { start =    SL2_GetStart( "InfernoStart" ), army = {		   CREATURE_TITAN,  3,	CREATURE_MASTER_GREMLIN, 30,  CREATURE_STEEL_GOLEM, 20, 	   CREATURE_ARCH_MAGI,   8,	 CREATURE_OBSIDIAN_GOLEM, 25, CREATURE_OBSIDIAN_GARGOYLE, 30 }  },
	["Astral"] 	= { start = SL2_GetStart( "NecropolisStart" ), army = {	CREATURE_DJINN_VIZIER, 15,			 CREATURE_TITAN,  5,	CREATURE_ARCH_MAGI, 20,	CREATURE_GREMLIN_SABOTEUR, 100,	 CREATURE_OBSIDIAN_GOLEM, 40 }  },
	["Sufi"]    = { start = {  87, 174, GROUND }, army = { 	 CREATURE_MASTER_GREMLIN, 67, CREATURE_OBSIDIAN_GARGOYLE, 44, 	 CREATURE_STEEL_GOLEM, 42, 	 CREATURE_ARCH_MAGI, 27, CREATURE_DJINN_VIZIER, 17, CREATURE_RAKSHASA_KSHATRI, 10, CREATURE_STORM_LORD, 4 } },
	["Razzak"]  = { start = {   1,  87, GROUND }, army = { CREATURE_GREMLIN_SABOTEUR, 75, 	CREATURE_MARBLE_GARGOYLE, 58, CREATURE_OBSIDIAN_GOLEM, 44, CREATURE_COMBAT_MAGE, 30, 	CREATURE_MASTER_GENIE, 19, CREATURE_RAKSHASA_RUKH, 10, CREATURE_TITAN, 5 } },
	["Minasli"] = { start = { 174,  87, GROUND }, army = { 	 CREATURE_MASTER_GREMLIN, 76, 		CREATURE_STEEL_GOLEM, 43, CREATURE_OBSIDIAN_GOLEM, 43, CREATURE_COMBAT_MAGE, 29, CREATURE_RAKSHASA_KSHATRI, 11, CREATURE_RAKSHASA_RUKH, 11, CREATURE_TITAN, 4 } },
}

function SetupEnemyHero(hero, unit_list, modifier )
	local size = table.length( unit_list );
	for i = 1, size, 2 do
		AddHeroCreatures( hero, unit_list[i], unit_list[i+1] * modifier );
	end
end

function PlayerHasCapturedAllTowns()
	for i, town in SL2_TOWNS do
		if GetObjectOwner(town) ~= PLAYER_1 then
			return nil
		end
	end
	return 1;
end

function SL2_RemoveOnslaught( oldOwner, newOwner, hero, object )
	if newOwner == PLAYER_5 then
		H55c_AIRemoveHero(hero);
	end
end

function StartInvasion(army_mod)
	BlockGame();
	for _, hero in ARMADA_DEPLOYMENT do
		local info = SL2_INVASION[hero];
		local x, y, z = info.start[1], info.start[2], info.start[3];
		DeployReserveHero( hero, x, y, z);
		sleep(10);
		OpenCircleFog(x, y, GROUND, 15, PLAYER_1);
		MoveCamera(x, y, GROUND, 80, 1.57, 0, 1, 1, 1);
		startThread( SetupEnemyHero, hero, info.army, army_mod );
		H55c_AIAddHero(hero);
		sleep(35);
	end
	CINEMATICS.startInvasion();
	UnblockGame();
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
		StartDialogScene("/DialogScenes/Single/SL2/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	captureTowns = function()
		StartDialogScene("/DialogScenes/Single/SL2/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	startInvasion = function()
		StartDialogScene("/DialogScenes/Single/SL2/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/Single/SL2/R4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
}

DIFFICULTY = {
	[0] = function()
		diff = 1;
		ARMADA_DEPLOYMENT = { "Tan", "Faiz", "Havez", "Astral" };
	    H55c_SetCampaignResources( PLAYER_5, 50, 50, 50, 50, 50, 50, 30000); -- Give the chance to Faiz to create mini-artifacts for his units
	end,
	
	[1] = function()
		diff = 2;
		ARMADA_DEPLOYMENT = { "Tan", "Faiz", "Havez", "Astral", "Sufi" };
		H55c_SetCampaignResources( PLAYER_5, 75, 75, 75, 75, 75, 75, 40000); -- Give the chance to Faiz and Minasli to create mini-artifacts for their units
	end,
	
	[2] = function()
		diff = 3;
		ARMADA_DEPLOYMENT = { "Tan", "Faiz", "Havez", "Astral", "Sufi", "Razzak" };
		H55c_SetCampaignResources( PLAYER_5, 100, 100, 100, 100, 100, 100, 50000); -- Give the chance to Faiz, Minasli and Narxes to create mini-artifacts for their units
	end,
	
	[3] = function()
		diff = 4;
		ARMADA_DEPLOYMENT = { "Tan", "Faiz", "Havez", "Astral", "Sufi", "Razzak", "Minasli" };
		H55c_SetCampaignResources( PLAYER_5, 200, 200, 200, 200, 200, 200, 100000);	-- Give the chance to Faiz, Narxes and Jhora to create mini-artifacts for their units
	end,
}

function MagesDestroyed()
	for _, hero in ARMADA_DEPLOYMENT do
		if IsHeroAlive(hero) ~= nil then
			return nil;
		end
	end
	return 1;
end
	
OBJECTIVES = {
	date = 0,
	state = {
		captureTowns = { "CaptureTowns", 1 }, -- capture all towns
		repulseMages = {	  "Defence", 1 }, -- Defeat all 4 orange mages (up to 7 in higher difficulty)
		isAlive 	 = {  "MustSurvive", 1 }, -- Raven must survive
		eventManager = { 			"_", 1 }, -- Chance for give/take random resource each week
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		Resources_plus = {{WOOD,5},{ORE,5},{GEM,3},{CRYSTAL,3},{SULFUR,3},{MERCURY,3},{GOLD,3000}};
		Resources_minus = {{WOOD,-10},{ORE,-10},{GEM,-5},{CRYSTAL,-5},{SULFUR,-5},{MERCURY,-5},{GOLD,-5000}};
		Resources_plus.n = 7;
		Resources_minus.n = 7;
		DIFFICULTY[GetDifficulty()]();
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

			if GetObjectiveState("MustSurvive") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("Defence") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				Win( PLAYER_1 );
				return
			end
		end
	end,
	
	captureTowns = function()
		if OBJECTIVES.state.captureTowns[2] == 1 and PlayerHasCapturedAllTowns() ~= nil then
			CINEMATICS.captureTowns();
			SetObjectiveState("CaptureTowns", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.captureTowns[2] = 10;
		end
	end,

	repulseMages = function()
		if OBJECTIVES.state.repulseMages[2] == 1 and OBJECTIVES.state.captureTowns[2] == 10 then
			-- 4.5 / 9 / 13.5 / 18 / 22.5 / 27
			local army_mod = GetDate(MONTH) * ( 0.5 + diff );
			StartInvasion(army_mod);
			SetObjectiveState( "Defence", OBJECTIVE_ACTIVE );
			for i, town in SL2_TOWNS do
				Trigger( OBJECT_CAPTURE_TRIGGER, town, "SL2_RemoveOnslaught");
			end
			OBJECTIVES.state.repulseMages[2] = 2;
		elseif OBJECTIVES.state.repulseMages[2] == 2 and MagesDestroyed() ~= nil then
			SetObjectiveState( "Defence", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.repulseMages[2] = 10;
		end
	end,

	isAlive = function()
	-- start of this task is handled by the map.xdb file
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Effig") == nil then
			SetObjectiveState( "MustSurvive", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	eventManager_day = 8,
	eventManager = function()
		if OBJECTIVES.date >= OBJECTIVES.eventManager_day then
			local result = 1 + random(6);
			CheckResource(result);
			OBJECTIVES.eventManager_day = OBJECTIVES.eventManager_day + 7;
		end
	end,
}

function CheckResource(result)
	local changes;
	local message;
	
	if result == 4 or result == 5 then
		changes = Resources_plus;
		message = "/Maps/SingleMissions/SL2/ResourcePlus.txt";
	elseif result == 6 then
		changes = Resources_minus;
		message = "/Maps/SingleMissions/SL2/ResourcesMinus.txt";
	end
	
	if changes then
		MessageBox(message);

		for i = 1, changes.n do
			local resource = changes[i][1];
			local delta    = changes[i][2];
			local current  = GetPlayerResource(PLAYER_1, resource);
			local updated  = math.max(0, current + delta);

			SetPlayerResource(PLAYER_1, resource, updated);
			print("Resource type: ", resource, " Change: ", updated - current);
		end
	end
end

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( H55c_AI_main );

function sl2_dbg(var)
	if var == 1 then
		H55_Speedrun(1);
		for i, town in SL2_TOWNS do
			SetObjectOwner(town, PLAYER_1);
		end
	elseif var == 2 then
		for hero, value in ARMADA_DEPLOYMENT do
			RemoveObject( hero );
		end
	end
end
