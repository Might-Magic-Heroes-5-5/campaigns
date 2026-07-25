doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_PlayerStatus = {0,1,1,1,2,2,2,2};

H55c_AI_CONTROLLED = {
  player1 = {          -- Purple HUMAN player
      state = 0,
	   heroes = {},
	   enemies = {},
  },
  player2 = { 		   -- AI
		state = 1,
		heroes = {},
		enemies = {},
  },
  player3 = { 		   -- AI
		state = 1,
		heroes = {},
		enemies = {},
  },
  player4 = { 		   -- Green AI, controls Nadaur offensive
		state = 2,
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 1.0, towns = 0.7, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
		}
  }
}

DIFFICULTY = {
	[0] = function()
		diff = 2;
		weekun = 36;
		ChangeHeroStat("Brem", STAT_EXPERIENCE, 5000);
		ChangeHeroStat("Inagost", STAT_EXPERIENCE, 5000);
		AddObjectCreatures("Eruina", CREATURE_ASSASSIN, 30);
		print("Difficulty level is normal.");
	end,
	
	[1] = function()
		diff = 2;
		weekun = 28;
		ChangeHeroStat("Brem", STAT_EXPERIENCE, 7000);
		ChangeHeroStat("Inagost", STAT_EXPERIENCE, 8000);
		AddObjectCreatures("Eruina", CREATURE_ASSASSIN, 15);
		print("Difficulty level is hard.");
	end,
	
	[2] = function()
		diff = 3;
		weekun = 14;
		ChangeHeroStat("Brem", STAT_EXPERIENCE, 10000);
		ChangeHeroStat("Inagost", STAT_EXPERIENCE, 10000);
		AddObjectCreatures("Eruina", CREATURE_ASSASSIN, 5);		
		print("Difficulty level is heroic.");
	end,
	
	[3] = function()
		diff = 4;
		weekun = 2;
		ChangeHeroStat("Brem", STAT_EXPERIENCE, 15000);
		ChangeHeroStat("Inagost", STAT_EXPERIENCE, 15000);
		print("Difficulty level is impossible.");
	end,
}

function LostHero5( HeroName5 )
	if HeroName5 == "Inagost" then
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, nil );
		CINEMATICS.defeatInagost();
	end
end

function SetupEnemyTroops()
	local coef = GetDate(WEEK) + 4 * (GetDate(MONTH) - 1);
	ChangeHeroStat('Nadaur', STAT_EXPERIENCE, coef * 10000 );
	AddObjectCreatures('Nadaur', CREATURE_SPRITE, coef * 16 );
	AddObjectCreatures('Nadaur', CREATURE_WAR_DANCER, coef * 9 );
	AddObjectCreatures('Nadaur', CREATURE_GRAND_ELF, coef * 7 );
	AddObjectCreatures('Nadaur', CREATURE_DRUID_ELDER, coef * 4 );
	AddObjectCreatures('Nadaur', CREATURE_WAR_UNICORN, coef * 3 );
	AddObjectCreatures('Nadaur', CREATURE_TREANT_GUARDIAN, coef * 2 );
	AddObjectCreatures('Nadaur', CREATURE_GOLD_DRAGON, coef * 1 );
end

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/Single/SM2/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/Single/SM2/R6/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	defeatInagost = function()
		StartDialogScene("/DialogScenes/Single/SM2/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	armyArives = function()
		StartDialogScene("/DialogScenes/Single/SM2/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
}
	
OBJECTIVES = {
	state = {
		defendCapitol = { "DefendHome", 1 },	-- the capitol must never be conquered
		isAlive 	  = { 	"Survival", 1 },	-- Eruina must survive
		destroyArmy   = {	   "Final", 1 },    -- destroy the Elven army
		seizeTowns    = {	   "Start", 1 },	-- Seize other player towns
		eventManager  = {		   "_", 1 },	--
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		DIFFICULTY[GetDifficulty()]();
		SetRegionBlocked("block3", 1, PLAYER_2);
		SetRegionBlocked("block4", 1, PLAYER_2);
		SetRegionBlocked("block1", 1, PLAYER_3);
		SetRegionBlocked("block2", 1, PLAYER_3);
		SetRegionBlocked("blocking1", 1, PLAYER_2);
		SetRegionBlocked("blocking2", 1, PLAYER_2);
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "LostHero5" );
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
			
			if GetObjectiveState("DefendHome") == OBJECTIVE_FAILED or GetObjectiveState("Survival") == OBJECTIVE_FAILED then
				Loose();
			end
			
			if GetObjectiveState("Final") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep(100);
				Win(PLAYER1);
			end
		end
	end,

	defendCapitol = function()
	-- start of this task is handled by the map.xdb file
		if OBJECTIVES.state.defendCapitol[2] == 1 and GetObjectOwner("Home") ~= PLAYER_1 then
			SetObjectiveState("DefendHome", OBJECTIVE_FAILED);
			OBJECTIVES.state.defendCapitol[2] = 11;
		end
	end,
	
	isAlive = function()
	-- start of this task is handled by the map.xdb file
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Eruina") == nil then
			SetObjectiveState("Survival", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	destroyArmy = function()
		if OBJECTIVES.state.destroyArmy[2] == 1 and OBJECTIVES.state.seizeTowns[2] >= 10 then
			SetObjectiveState('Final', OBJECTIVE_ACTIVE); 
			OBJECTIVES.state.destroyArmy[2] = 2;
		elseif OBJECTIVES.state.destroyArmy[2] == 2 then
			DeployReserveHero('Nadaur', RegionToPoint('EnemyHere'));
			sleep(10);
			startThread(SetupEnemyTroops);
			OBJECTIVES.eventManager_armyDialog = OBJECTIVES.date + 2;
			H55c_AIAddHero('Nadaur');
			OBJECTIVES.state.destroyArmy[2] = 3;
		elseif OBJECTIVES.state.destroyArmy[2] == 3 and IsHeroAlive("Nadaur") == nil then
			SetObjectiveState("Final", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.destroyArmy[2] = 10;
		end
	end,
	
	seizeTowns = function()
		if OBJECTIVES.state.seizeTowns[2] == 1 then
			SetObjectiveState('Start', OBJECTIVE_ACTIVE); 
			OBJECTIVES.state.seizeTowns[2] = 2;
		elseif OBJECTIVES.state.seizeTowns[2] == 2 then
			if GetObjectOwner("Haven") == PLAYER_1 and GetObjectOwner("Dungeon") == PLAYER_1 then
				SetObjectiveState('Start', OBJECTIVE_COMPLETED);
				LevelUpHero("Eruina");
				OBJECTIVES.state.seizeTowns[2] = 10;
			elseif GetDate(MONTH) == 4 then
				SetObjectiveState('Start', OBJECTIVE_FAILED);
				OBJECTIVES.state.seizeTowns[2] = 11;
			end
		end
	end,
	
	eventManager_armyDialog = 99999,
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date >= OBJECTIVES.eventManager_day then
			if OBJECTIVES.date == weekun then
				print("Release the Kraken");
				SetRegionBlocked("blocking1", nil, PLAYER_2);
				SetRegionBlocked("blocking2", nil, PLAYER_2);
			end
			
			if OBJECTIVES.date == OBJECTIVES.eventManager_armyDialog then
				CINEMATICS.armyArives();
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.date + 1;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( H55c_AI_main );
