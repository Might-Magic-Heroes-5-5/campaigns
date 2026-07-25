doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_PlayerStatus = {0,1,1,1,1,2,2,2};

H55c_AI_CONTROLLED = {
  player1 = {          -- Light Blue HUMAN player
      state = 0,
	   heroes = {},
	   enemies = {},
  },
  player2 = {
		state = 1,
		heroes = {},
		enemies = {},
  },
  player3 = {
		state = 1,
		heroes = {},
		enemies = {},
  },
  player4 = {
		state = 1,
		heroes = {},
		enemies = {},
  },
  player5 = { 		   -- Orange AI player
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
SL2_TOWNS = { "Academy", "Necropolis", "Inferno", "Sylvan" };
SL2_INVASION = {
	["Tan"] 	= { start = 	"SylvanStart", army = { CREATURE_ARCH_MAGI, 10, 		 CREATURE_MAGI, 10,		   CREATURE_GENIE,  5, 	CREATURE_RAKSHASA,   3, CREATURE_STONE_GARGOYLE, 20, 		   CREATURE_GREMLIN, 30 }  },
	["Faiz"] 	= { start =    "AcademyStart", army = { 	 CREATURE_MAGI, 10, 	 CREATURE_RAKSHASA, 10, CREATURE_MASTER_GENIE, 12, 	   CREATURE_GIANT,   4,    CREATURE_STEEL_GOLEM, 25, 	CREATURE_MASTER_GREMLIN, 40 }  },
	["Havez"] 	= { start =    "InfernoStart", army = { 	CREATURE_TITAN, 3, CREATURE_MASTER_GREMLIN, 30,  CREATURE_STEEL_GOLEM, 20, CREATURE_ARCH_MAGI,   8, 	CREATURE_IRON_GOLEM, 25, CREATURE_OBSIDIAN_GARGOYLE, 30 }  },
	["Astral"] 	= { start = "NecropolisStart", army = { 	CREATURE_GENIE, 15, 		CREATURE_TITAN,  5,    CREATURE_ARCH_MAGI, 20, 	 CREATURE_GREMLIN, 100, 	CREATURE_IRON_GOLEM, 40 }  },
}

function SetupEnemyHero(hero, unit_list )
	local ArmyMdf = GetDate(MONTH)*(0.5 + GetDifficulty());
	local size = table.length( unit_list );
	for i = 1, size, 2 do
		AddHeroCreatures( hero, unit_list[i], unit_list[i+1] * ArmyMdf );
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

function StartInvasion()
	BlockGame();
	for hero, info in SL2_INVASION do
		DeployReserveHero( hero, RegionToPoint( info.start ) );
		sleep(10);
		local x,y = GetObjectPosition( hero );
		OpenCircleFog(x,y,GROUND,15,PLAYER_1);
		MoveCamera(x,y,GROUND);
		startThread( SetupEnemyHero, hero, info.army );
		H55c_AIAddHero(hero);
		sleep(120);
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

OBJECTIVES = {
	date = 0,
	state = {
		captureTowns = { "CaptureTowns", 1 }, -- capture all towns
		repulseMages = {	  "Defence", 1 }, -- Occupy and hold the capital
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
		PlayerTowns = {};
		ReservedHeroes = {"Mardigo","Nathaniel","Orrin","Sarge"};
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
				sleep( 100 );
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
			StartInvasion();
			SetObjectiveState( "Defence", OBJECTIVE_ACTIVE );
			for i, town in SL2_TOWNS do
				Trigger( OBJECT_CAPTURE_TRIGGER, town, "SL2_RemoveOnslaught");
			end
			OBJECTIVES.state.repulseMages[2] = 2;
		elseif OBJECTIVES.state.repulseMages[2] == 2 and IsHeroAlive("Faiz") == nil and IsHeroAlive("Tan") == nil and IsHeroAlive("Astral") == nil and IsHeroAlive("Havez") == nil then
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
			if result == 4 or result == 5 then
				MessageBox("/Maps/SingleMissions/SL2/ResourcesPlus.txt");
				for i=1,Resources_plus.n do
					print("Resource type is ",Resources_plus[i][1],"Quantity(+) = ",Resources_plus[i][2]);
					SetPlayerResource(PLAYER_1,Resources_plus[i][1],GetPlayerResource(PLAYER_1,Resources_minus[i][1])+Resources_plus[i][2]);
				end
			elseif result == 6 then
				MessageBox("/Maps/SingleMissions/SL2/ResourcesMinus.txt");
				for i=1,Resources_minus.n do
					if GetPlayerResource(PLAYER_1,Resources_minus[i][1]) > Resources_minus[i][2] then
						print("Resource type is ",Resources_plus[i][1],"Quantity(-) = ",Resources_plus[i][2]);
						SetPlayerResource(PLAYER_1,Resources_minus[i][1],GetPlayerResource(PLAYER_1,Resources_minus[i][1])-Resources_minus[i][2]);
					else
						print("Resource type is ",Resources_plus[i][1],"Quantity(=) = ",GetPlayerResource(PLAYER_1,Resources_minus[i][1]));
						SetPlayerResource(PLAYER_1,Resources_minus[i][1],GetPlayerResource(PLAYER_1,Resources_minus[i][1]));
					end
				end
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.eventManager_day + 7;
		end
	end,
}

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
		for hero, value in SL2_INVASION do
			RemoveObject( hero );
		end
	end
end
