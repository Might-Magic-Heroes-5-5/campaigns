doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55c_AI_CONTROLLED = {
  player1 = {          -- player 1player/human so state should be 0 to skip control of the heroes
      state = 0,       -- 0 human, 1 unmanaged AI, 2 managed AI
	   heroes = {},
	  enemies = {},
  },
  player2 = { 		     -- Red Inferno AI player
      state = 2,       -- AI player with specific purpose so control set to 2
	   heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = 0.6, towns = 1.0, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
    }
  }
}

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M3");
	LoadHeroAllSetArtifacts( "Isabell" , "C1M2" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1, "Isabell" );
end

OUR_HERO_NAME = "Isabell";
ENEMY_HERO_NAME = "Calid";
OUR_TOWN = "Bobruisk";
townx, towny = 32, 28;

startThread(H55_InitSetArtifacts);
H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_BOOTS_OF_LEVITATION};

function SetInfernoArmy( heroname, strength, week, diff )
	local factor = {};
	factor[CREATURE_BALOR] = 0.75;
	factor[CREATURE_SUCCUBUS] = 4;
	factor[CREATURE_HELL_HOUND] = 7;
	factor[CREATURE_DEMON] = 8.5;
	factor[CREATURE_IMP] = 10.0;
	local total = 0;
	local coeff = 0;
	local crap = diff
	if crap < 0 then
		crap = 0;
	end
	local minfact = 6 + 4 * crap * week;
	for i = 15, 28 do
		total = total + creature_costs[i] * (factor[i] or 0);
	end
	if total * minfact >= strength then
		coeff = minfact;
	else
		coeff = strength / total;
	end
	print('strength = ', strength, '; coeff = ', coeff);
	for i = 15, 28 do
		if factor[i] then
			AddHeroCreatures( heroname, i, factor[i] * coeff );
		end
	end
end

BATTLES = {
	surprize = {
		start = function(hero)
			ShowFlyingSign("/Maps/Scenario/C1M3/ambush.txt",hero);
			local week = GetDate(WEEK);
			StartCombat(hero, nil, 5, CREATURE_SKELETON_ARCHER, 40 + 20*week, CREATURE_DISEASE_ZOMBIE, 25 + 12*week, CREATURE_POLTERGEIST, 15 + 8*week, CREATURE_NOSFERATU, 8 + 4 * week, CREATURE_LICH_MASTER, 1 + week, nil, 'BATTLES.surprize.finish');
		end,

		finish = function(hero, result)
			if result ~= nil then
				local rndartifact = random(table.length(H55_MinorArtifacts))+1;
				GiveArtefact(hero, H55_MinorArtifacts[rndartifact], 0);
			end
		end,
	}
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C1/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
	end,

	clearScouts = function()
		StartDialogScene("/DialogScenes/C1/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
	end,

	outro = function()
		StartDialogScene("/DialogScenes/C1/M3/D1/DialogScene.xdb#xpointer(/DialogScene)");
	end,

	showEnemy = function()
		sleep(10);
		OpenCircleFog( 118, 92, 0, 7, PLAYER_1 );
		sleep(2);
		MoveCamera( 119, 89, 0, 18, 0.925, 0.279 );
	end,
}

TUTORIALS = {
	list = {
    	{      "c1_m3_t1", REGION_ENTER_AND_STOP_TRIGGER,     "gold",      "TUTORIALS.treasure_found", 0 },
    	{      "c1_m3_t1", REGION_ENTER_AND_STOP_TRIGGER,    "gold2",      "TUTORIALS.treasure_found", 0 },
    	{      "c1_m3_t1", REGION_ENTER_AND_STOP_TRIGGER, "cristall",      "TUTORIALS.treasure_found", 0 },
    	{     "c1_m3_t11", REGION_ENTER_AND_STOP_TRIGGER,   "memory",        "TUTORIALS.memoryMentor", 0 },
    	-- {      "c1_m3_t2",          OBJECT_TOUCH_TRIGGER,     "gold",   "TUTORIALS.treasure_captured", 0 },
    	-- {      "c1_m3_t2",          OBJECT_TOUCH_TRIGGER,    "gold2",   "TUTORIALS.treasure_captured", 0 },
    	-- {      "c1_m3_t2",          OBJECT_TOUCH_TRIGGER, "cristall",   "TUTORIALS.treasure_captured", 0 },
    	{      "c1_m3_t6",                        THREAD,          0,    "TUTORIALS.buildingUpgraded", 0 },
    	--{    "c1_m3_t9_2",                        THREAD,          0, "TUTORIALS.heroBuiltWarmachine", 0 },
        {     "c1_m3_t10",                        THREAD,          0,       "TUTORIALS.meetEnemyHero", 0 },
    	{     "c1_m4_t11",                        THREAD,          0,     "TUTORIALS.checkHeroInTown", 0 },
    	{     "hero_meet",                        WINDOW,          0,                               0, 0 },
    	{ "c1_m3_levelup",                        WINDOW,          0,                               0, 0 },
    	{      "c1_m2_t7",    PLAYER_REMOVE_HERO_TRIGGER,   PLAYER_1,            "TUTORIALS.lostHero", 0 },
    },

	run = function()
		SetGameVar("temp.C1M3_Tradeville", 0);
		manageTutorials(TUTORIALS.list);
	end,

	markComplete = function(name)
		print(name);
		for _, item3 in TUTORIALS.list do
			if item3[4] == name then
				item3[5] = 2;
			end
		end
	end,
    
	lostHero = function( heroname )
		if heroname ~= OUR_HERO_NAME then
			TutorialMessageBox( 'c1_m2_t7' );
			TUTORIALS.markComplete("TUTORIALS.lostHero")
		end
	end,
    
	memoryMentor = function()
		WaitForTutorialMessageBox();
		TutorialMessageBox("c1_m3_t11");
		TUTORIALS.markComplete("TUTORIALS.memoryMentor");
	end,
    
	treasure_found = function()
		WaitForTutorialMessageBox()
		TutorialMessageBox("c1_m3_t1");
		for _, obj in {"gold", "gold2", "cristall"} do
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, obj, nil)
		end
		TUTORIALS.markComplete("TUTORIALS.treasure_found");
	end,
    
	treasure_captured = function()
		WaitForTutorialMessageBox();
		TutorialMessageBox("c1_m3_t2");
		for _, obj in {"gold", "gold2", "cristall"} do
			if Exists(obj) then
				Trigger(OBJECT_TOUCH_TRIGGER, obj, nil)
			end
		end
		TUTORIALS.markComplete("TUTORIALS.treasure_captured");
	end,

	buildingUpgraded = function()
		while true do
			sleep(10);
			if (GetTownBuildingLevel(OUR_TOWN, TOWN_BUILDING_DWELLING_1) > 1 or
				GetTownBuildingLevel(OUR_TOWN, TOWN_BUILDING_DWELLING_2) > 1 or
				GetTownBuildingLevel(OUR_TOWN, TOWN_BUILDING_DWELLING_3) > 1) then
				print("Player makes upgrade in his Town!!!");
				WaitForTutorialMessageBox();
				TutorialMessageBox("c1_m3_t6");
				TUTORIALS.markComplete("TUTORIALS.buildingUpgraded");
				break
			end
		end
	end,

	heroBuiltWarmachine = function()
		while true do
			sleep(5);
			if ( HasHeroWarMachine(OUR_HERO_NAME, 1) or HasHeroWarMachine(OUR_HERO_NAME, 3) or HasHeroWarMachine(OUR_HERO_NAME, 4) ) then
				print("Player has got war mashine");
				WaitForTutorialMessageBox();
				TutorialMessageBox("c1_m3_t9_2");
				TUTORIALS.markComplete("TUTORIALS.heroBuiltWarmachine");
			    break
			end
		end
	end,

    meetEnemyHero = function()
		while true do
			sleep(10);
			if Exists(OUR_HERO_NAME) and Exists(ENEMY_HERO_NAME) then
				if H55_GetDistance(OUR_HERO_NAME, ENEMY_HERO_NAME) < 30 and GetCurrentPlayer() == PLAYER_1 and GetObjectiveState("prim3") == OBJECTIVE_ACTIVE then
					WaitForTutorialMessageBox();
					TutorialMessageBox("c1_m3_t10");
					TUTORIALS.markComplete("TUTORIALS.meetEnemyHero");
					break
				end
			end
		end
    end,

    checkHeroInTown = function()
		heroes = {};
		hero_visiting = 0;
		while true do
			sleep(5)
			heroes = GetPlayerHeroes( PLAYER_1 );
			for i, hero in heroes do
				if GetTownHero(OUR_TOWN) ~= hero then
					x, y = GetObjectPos( hero );
					if ( x ~= townx ) or ( y ~= towny ) then
						if hero_visiting == 1 then
							SetGameVar( 'temp.hero_visiting', 0 );
							hero_visiting = 0;
						end
					elseif hero_visiting == 0 then
						SetGameVar( 'temp.hero_visiting', 1 );
						hero_visiting = 1;
						break;
				    end
				end
			end
		end
    end,
}

OBJECTIVES = {
    state = {
      clearScouts            = { "prim1", 1 },
      upgradeTrainingGrounds = { "prim2", 1 },
      defeatEnemyHero        = { "prim3", 1 },
      isAlive                = { "prim4", 1 },
    },

    start = function()
      OBJECTIVES.prepare();
      OBJECTIVES.run();
    end,

	prepare = function()
		SetPlayerStartResource(PLAYER_1,    WOOD,    6);
		SetPlayerStartResource(PLAYER_1,     ORE,   15);
		SetPlayerStartResource(PLAYER_1,     GEM,    3);
		SetPlayerStartResource(PLAYER_1, CRYSTAL,    3);
		SetPlayerStartResource(PLAYER_1, MERCURY,    3);
		SetPlayerStartResource(PLAYER_1,  SULFUR,   60);
		SetPlayerStartResource(PLAYER_1,    GOLD, 5000);
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "surprize", "BATTLES.surprize.start" );
		EnableHeroAI( ENEMY_HERO_NAME, nil );
		-- Game difficulty adjustment
		strcoeff_table = { 1.0, 1.1, 1.3, 1.5 }
		if ( __difficulty >= DIFFICULTY_NORMAL ) then
			CreateMonster( "monster1", 	  CREATURE_ARCHER, 35, 58, 46, 0, 0, 0 );
			CreateMonster( "monster2",    CREATURE_ARCHER, 33, 77, 26, 0, 0, 0 );
			CreateMonster( "monster3", CREATURE_SWORDSMAN, 24, 29, 63, 0, 0, 0 );
			CreateMonster( "monster4",   CREATURE_FOOTMAN, 27, 73, 36, 0, 0, 0 );
			CreateMonster( "monster5",   CREATURE_GRIFFIN, 14, 74, 65, 0, 0, 0 );
			CreateMonster( "monster6",  CREATURE_CAVALIER,  7, 85, 70, 0, 0, 0 );
			CreateMonster( "monster7",   CREATURE_GRIFFIN, 15, 42, 82, 0, 0, 0 );
		end
		CINEMATICS.intro()
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

			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and GetObjectiveState("prim2") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep(10);
				SetObjectiveState( "prim4", OBJECTIVE_COMPLETED );
				SaveHeroAllSetArtifactsEquipped(OUR_HERO_NAME, "C1M3");
				sleep(20);
				Win();
				return
			end
		end
    end,
    
	clearScouts = function()
		if GetObjectiveState("prim1") == OBJECTIVE_UNKNOWN then
			SetObjectiveState('prim1', OBJECTIVE_ACTIVE);
		end
		enemies_killed = 0;
		for i = 1, 11 do
			if not Exists( 'inferno'..i ) then
				enemies_killed = enemies_killed + 1;
			else
				break
			end
     	end
		if ( enemies_killed == 11 ) then
			CINEMATICS.clearScouts();
			sleep(2);
			SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED );
			GiveExp( OUR_HERO_NAME, 6000 );
			OBJECTIVES.state.clearScouts[2] = 10;
		end
	end,

	upgradeTrainingGrounds = function()
	-- start and completion of this task is handled by C1M3.xdb
		if GetObjectiveState( 'prim2' ) == OBJECTIVE_COMPLETED then
			GiveExp( OUR_HERO_NAME, 6000 );
			OBJECTIVES.state.upgradeTrainingGrounds[2] = 10;
		end
	end,
    
	defeatEnemyHero = function()
	-- start and completion of this task is handled by C1M3.xdb
		if OBJECTIVES.state.clearScouts[2] == 10 and OBJECTIVES.state.upgradeTrainingGrounds[2] == 10 then
			SetObjectPos(ENEMY_HERO_NAME, 118, 92, 0);
			sleep(5);
			local player_army_strength = CalcArmy( OUR_HERO_NAME )
			print( "player str = " .. player_army_strength );
			local strcoeff = strcoeff_table[__difficulty + 1]
			player_army_strength = player_army_strength * strcoeff;
			print( "str with difficulty = ", player_army_strength );
			local week = GetDate(WEEK) + 4 * ( GetDate(MONTH) - 1 );
			SetInfernoArmy( ENEMY_HERO_NAME, player_army_strength, week, __difficulty );
			H55c_AIAddHero(ENEMY_HERO_NAME);
			CINEMATICS.showEnemy();
			OBJECTIVES.state.defeatEnemyHero[2] = 10;
			if __difficulty > 0 then
	            GiveHeroSkill("Calid", SKILL_WAR_MACHINES);
	        end
	        if __difficulty > 1 then
				GiveHeroSkill("Calid", SKILL_WAR_MACHINES);
	        end
	        if __difficulty > 2 then 
				GiveHeroSkill("Calid", SKILL_WAR_MACHINES);
	        end
		end
	end,

	isAlive = function()
	-- start of this task is handled by C1M3.xdb
		if IsHeroAlive(OUR_HERO_NAME) == nil then
			SetObjectiveState( 'prim4', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
}
------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
startThread( TUTORIALS.run );
startThread( H55c_AI_main )
	  
------------------ DEBUG ------------------------

function c1m3_suprize()
	SetObjectPosition("Isabell", 90, 60, 0)
end

function c1m3_debug()
	UpgradeTownBuilding(OUR_TOWN, TOWN_BUILDING_DWELLING_6, 1);
	UpgradeTownBuilding(OUR_TOWN, TOWN_BUILDING_DWELLING_6, 2);
	sleep(10)
	for i = 1, 11 do
		if Exists('inferno'..i) then
			RemoveObject( 'inferno'..i );
			sleep(5)
		end
	end
end

function c1m3_sim(weeks)
	SetObjectPos(ENEMY_HERO_NAME, 29, 22, 0);
	sleep(5);
	local player_army_strength = CalcArmy( OUR_HERO_NAME )
	print( "player str = " .. player_army_strength );
	local strcoeff = strcoeff_table[__difficulty + 1]
	player_army_strength = player_army_strength * strcoeff;
	print( "str with difficulty = ", player_army_strength );
	local week = GetDate(WEEK) + 4 * ( GetDate(MONTH) - 1 );
	if weeks ~= 0 then
		week = weeks;
	end
	print("generate army for week "..week.." and difficulty "..__difficulty);
	SetInfernoArmy( ENEMY_HERO_NAME, player_army_strength, week, __difficulty );
	EnableHeroAI(ENEMY_HERO_NAME, nil);
end