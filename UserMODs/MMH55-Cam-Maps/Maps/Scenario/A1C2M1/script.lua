doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_PlayerStatus = {0,1,2,2,2,2,2,2};
function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C2M1");
end

H55c_AI_CONTROLLED = {
	player1 = {          -- player 1player/human so state should be 0 to skip control of the heroes
		state = 0,       -- 0 human, 1 unmanaged AI, 2 managed AI
		heroes = {},
		enemies = {},
	},
	player2 = { 		   -- Red Haven player.
		state = 2,         -- Leads onslaught against player town.
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = -1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes =  1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
		}
	},
}

BATTLES = {
	wave = {
		id = 1,
		size = {
			[1] = { 1, 2, 2, 2, 1, 1, 1 }, -- 10
			[2] = { 2, 2, 2, 2, 1, 1, 1 }, -- 11
			[3] = { 2, 2, 3, 3, 1, 1, 1 }, -- 13
			[4] = { 3, 3, 3, 3, 1, 1, 1 }, -- 15
		},
	},
	heroes = { "Christian", "Maeve", "Brem", "Sarge", "Ving", "Orrin" },
	army_idx = 1,
	army_multiplier = 0,
	army = {
		{ CREATURE_LONGBOWMAN,  39, CREATURE_BATTLE_GRIFFIN,  15, CREATURE_VINDICATOR,  26 },   -- Wave 1, hero 1
		{   CREATURE_LANDLORD, 150, CREATURE_BATTLE_GRIFFIN,  15,	  CREATURE_ZEALOT,   8 },	-- Wave 1, hero 2
		{ CREATURE_LONGBOWMAN,  39, CREATURE_BATTLE_GRIFFIN,  15, CREATURE_VINDICATOR,  26 },	-- Wave 1, hero 3
		{ CREATURE_LONGBOWMAN,  67, CREATURE_BATTLE_GRIFFIN,  26, CREATURE_VINDICATOR,  46 },	-- Wave 2, hero 1
		{   CREATURE_LANDLORD, 200, CREATURE_BATTLE_GRIFFIN,  26,	  CREATURE_ZEALOT,  13 },	-- Wave 2, hero 2
		{ CREATURE_LONGBOWMAN,  67, CREATURE_BATTLE_GRIFFIN,  26, CREATURE_VINDICATOR,  46 },	-- Wave 2, hero 3
		{ CREATURE_LONGBOWMAN,  95, CREATURE_BATTLE_GRIFFIN,  37, CREATURE_VINDICATOR,  66 },	-- Wave 3, hero 1
		{   CREATURE_LANDLORD, 200, CREATURE_BATTLE_GRIFFIN,  37,	  CREATURE_ZEALOT,  18 },	-- Wave 3, hero 2
		{ CREATURE_LONGBOWMAN,  95, CREATURE_BATTLE_GRIFFIN,  37, CREATURE_VINDICATOR,  66 },	-- Wave 3, hero 3
		{ CREATURE_LONGBOWMAN, 151, CREATURE_BATTLE_GRIFFIN,  55, CREATURE_VINDICATOR, 106 },	-- Wave 4, hero 1
		{   CREATURE_LANDLORD, 300, CREATURE_BATTLE_GRIFFIN,  55,	  CREATURE_ZEALOT,  28 },	-- Wave 4, hero 2
		{ CREATURE_LONGBOWMAN, 151, CREATURE_BATTLE_GRIFFIN,  55, CREATURE_VINDICATOR, 106 },	-- Wave 4, hero 3
		{   CREATURE_LANDLORD, 390,		CREATURE_LONGBOWMAN, 180, CREATURE_VINDICATOR, 140, CREATURE_BATTLE_GRIFFIN,  65, CREATURE_CHAMPION, 10 }, -- wave 5
		{ CREATURE_VINDICATOR, 185, CREATURE_BATTLE_GRIFFIN,  65,	  CREATURE_ZEALOT,  30,		  CREATURE_CHAMPION,  20 }, -- wave 6
		{ CREATURE_VINDICATOR, 235, CREATURE_BATTLE_GRIFFIN,  90,	  CREATURE_ZEALOT,  45,		  CREATURE_CHAMPION,  30 }, -- wave 7
	},

	sources = { { 86,  3, GROUND }, { 34,  7, GROUND }, { 19, 13, GROUND } },

	sendWave = function()
		local wave = math.mod(BATTLES.wave.id - 1, table.length(BATTLES.wave.size[GetDifficulty() + 1])) + 1;
		if wave == 1 then
			BATTLES.army_idx = 1;
			BATTLES.army_multiplier = BATTLES.army_multiplier + 1;
		end
		for i = 1, BATTLES.wave.size[GetDifficulty() + 1][wave] do
			local hero = BATTLES.chooseHero();
			if hero ~= nil then
				local xp = GetExpToLevel( 1 + 3 * (BATTLES.wave.id - 1));
				local roster = BATTLES.army[BATTLES.army_idx];
				startThread(BATTLES.sendHero, hero, xp, roster, BATTLES.army_multiplier, BATTLES.sources[i]);
				BATTLES.army_idx = BATTLES.army_idx + 1;
				sleep( 30 ); -- wait for deployment before next hero is selected
			end
		end
		BATTLES.wave.id = BATTLES.wave.id + 1;
	end,

	chooseHero = function()
		local loop_guard = 0;
		while loop_guard < 20 do
			local hero = BATTLES.heroes[math.random(1, table.length(BATTLES.heroes))];
			if IsHeroAlive(hero) == nil then return hero; end
			loop_guard = loop_guard + 1;
		end
	end,
	
	sendHero = function(hero, xp, roster, multiplier, source)
		DeployReserveHero( hero, source[1], source[2], source[3] );
		sleep( 20 ); -- Wait until hero deployment completes
		SetHeroRoleMode( hero, HERO_ROLE_MODE_HERMIT );
		GiveExp( hero, xp);
		pcall(BATTLES.setArmy, hero, roster, multiplier);
		H55c_AIAddHero( hero );
	end,

	setArmy = function(hero, roster, multiplier)
		for i = 1, table.length(roster), 2 do
			AddHeroCreatures( hero, roster[i], roster[i+1] * multiplier );
		end
		sleep(40);
		RemoveHeroCreatures( hero, CREATURE_LANDLORD, 1 );
	end,
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/A1C2/M1/S1/DialogScene.xdb#xpointer(/DialogScene)", "", "autosave");
		sleep( 2 );
	end,
}

OBJECTIVES = {
	date = 0,
	state = {
		holdTowns   = { "prim1", 1 },	-- hold at least two towns
		getArmy		= { "prim2", 0 },	-- Wulfstan must collect 500 defenders
		isAlive		= { "prim3", 1 },	-- Wulfstan must survive
		buildShrine = {  "sec1", 1 },	-- build Runic shrine of the first circle
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		CINEMATICS.intro();
		startThread(H55_InitSetArtifacts);
		GiveHeroSkill( "Wulfstan", HERO_SKILL_RUNELORE );
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

			if GetObjectiveState("prim1") == OBJECTIVE_FAILED or GetObjectiveState("prim3") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Wulfstan", "A1C2M1");
				sleep(100);
				Win();
				return
			end
		end
	end,

	holdTowns_attackDate = 8,
	holdTowns = function()
	-- start of this task is handled by map.xdb
		local enemy_towns = 0;
		for i, town in { "town1", "town2", "town3" } do
			if GetObjectOwner(town) == PLAYER_2 then
				enemy_towns = enemy_towns + 1;
			end
		end
		if enemy_towns > 1 then
			SetObjectiveState( "prim1", OBJECTIVE_FAILED );
			OBJECTIVES.state.holdTowns[2] = 11;
		end

		if OBJECTIVES.date >= OBJECTIVES.holdTowns_attackDate then
			BATTLES.sendWave();
			OBJECTIVES.holdTowns_attackDate = OBJECTIVES.holdTowns_attackDate + 7;
		end
	end,

	getArmy = function()
	-- start and end of this task is handled by map.xdb
	end,

	isAlive = function()
	-- start of this task is handled by map.xdb
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Wulfstan") == nil then
			SetObjectiveState( 'prim3', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,

	buildShrine = function()
	-- start of this task is handled by map.xdb
		if OBJECTIVES.state.buildShrine[2] == 1 and ( GetTownBuildingLevel('town1', TOWN_BUILDING_FORTRESS_RUNIC_SHRINE) == 1 or GetTownBuildingLevel('town2', TOWN_BUILDING_FORTRESS_RUNIC_SHRINE) == 1 or GetTownBuildingLevel('town3', TOWN_BUILDING_FORTRESS_RUNIC_SHRINE) == 1 ) then
			SetObjectiveState( 'sec1', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.buildShrine[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( H55c_AI_main );
