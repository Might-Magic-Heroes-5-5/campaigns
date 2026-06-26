doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = { ARTIFACT_BOOTS_OF_LEVITATION };

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M2");
	LoadHeroAllSetArtifacts( "Isabell", "C1M1" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills(  PLAYER_1, "Isabell" );
end

startThread(H55_InitSetArtifacts);

-- Unused tutorial messages
m63= "c1_m2_t6_2" ;--"/Maps/Scenario/C1M2/tutorial/tutorial61.txt"
m62= "c1_m2_t6_4" ;--"/Maps/Scenario/C1M2/tutorial/tutorial62.txt"
m07= "c1_m2_t7" ;--"/Maps/Scenario/C1M2/tutorial/tutorial7.txt"

CINEMATICS = {
    intro = function()
      StartDialogScene("/DialogScenes/C1/M2/R1/DialogScene.xdb#xpointer(/DialogScene)");
    end,

    captureAshwood = function()
      StartDialogScene("/DialogScenes/C1/M2/R2/DialogScene.xdb#xpointer(/DialogScene)");
    end,
    
    outro = function()
      StartDialogScene("/DialogScenes/C1/M2/R3/DialogScene.xdb#xpointer(/DialogScene)");
    end,
    
    showTown = function()
	    x, y, f = GetObjectPos( 'Hant' );
	    OpenCircleFog( x, y, f, 7, PLAYER_1 );
	    sleep(2);
	    MoveCamera( x, y, f, 40, 0.925, 0.279 );
	    Trigger( OBJECT_TOUCH_TRIGGER, "tower", nil );
    end,

    showTown2 = function()
	    x, y, f = GetObjectPos( 'Tradeville' );
	    OpenCircleFog( x, y, f, 7, PLAYER_1 );
	    sleep(2);
	    MoveCamera( x, y, f, 40, 0.925, 0.279 );
	    Trigger( OBJECT_TOUCH_TRIGGER, "tower2", nil );
    end,
}

TUTORIALS = {
    list = {
    	{       "c1_m2_t3",     REGION_ENTER_AND_STOP_TRIGGER,      "r03",               "TUTORIALS.luck", 0 }, -- Luck artifact
    	{       "c1_m2_t4",     REGION_ENTER_AND_STOP_TRIGGER,      "r04",             "TUTORIALS.morale", 0 }, -- Morale artifact
    	-- {       "c1_m2_t5",     REGION_ENTER_AND_STOP_TRIGGER,      "r05",        "TUTORIALS.attack_town", 0 },
    	{      "c1_m2_t10",     REGION_ENTER_AND_STOP_TRIGGER,      "r12",            "TUTORIALS.defence", 0 }, -- Defense artifact
    	{      "c1_m2_t11",     REGION_ENTER_AND_STOP_TRIGGER,      "r11",             "TUTORIALS.attack", 0 }, -- Attack artifact
    	{    "c1_m2_mines",            OBJECT_CAPTURE_TRIGGER,    "mine1",   "TUTORIALS.mineCapturedHint", 0 }, -- capture mine
    	{    "c1_m2_mines",            OBJECT_CAPTURE_TRIGGER,    "mine2",   "TUTORIALS.mineCapturedHint", 0 },
    	{    "c1_m2_mines",            OBJECT_CAPTURE_TRIGGER,    "mine3",   "TUTORIALS.mineCapturedHint", 0 },
    	{  	  "c1_m2_t6_1",            				   THREAD,     "Hant",        "TUTORIALS.buildPerDay", 0 }, -- town captured. Explanation of daily town actions
    	{ "c1_m2_heroperk",                            THREAD,          0,     "TUTORIALS.checkHeroPerks", 0 }, -- if hero has activatable perks enable combat tutorial
    	{       "c1_m2_t1",                            THREAD,          0,          "TUTORIALS.seizeTown", 0 }, -- Hint to find a town ASAP
    	{       "c1_m2_t8",           				   THREAD,    		0,   "TUTORIALS.weeklyPopulation", 0 }, -- start of week hiring advice
    	{ "c1_m2_savegame",                            THREAD,          0,           "TUTORIALS.saveGame", 0 }, -- How to save a game
    	{       "c1_m2_t9",                            THREAD,          0,          "TUTORIALS.moonWeeks", 0 }, -- Explanation of moon weeks
    	{    "hero_screen",                            WINDOW,          0,                              0, 0 }, -- explanation of hero skill and wheel
    },

    run = function()
      SetGameVar( 		 'temp.creaturehired', 0);
      SetGameVar(       "temp.C1M2_perk_hint", 0);
      SetGameVar(    "temp.C1M2_archers_hint", 0);
      SetGameVar("temp.C1M2_CountVisitToTown", 0);
      manageTutorials(TUTORIALS.list);
    end,

    markComplete = function(name)
		print(name);
		for _, item in TUTORIALS.list do
			if item[4] == name then
				item[5] = 2;
			end
		end
	end,

	buildPerDay = function()
		while true do
			local thisday = GetDate(DAY_OF_WEEK);
			sleep(30);
			if thisday ~= 1 and GetObjectOwner("Hant") == PLAYER_1 then
				sleep(50)
				TUTORIALS.markComplete("TUTORIALS.buildPerDay");
				TutorialMessageBox("c1_m2_t6_1");
				return
			end
		end
    end,
    
    seizeTown = function()
		while true do
			TUTORIALS.markComplete("TUTORIALS.seizeTown");
			WaitForTutorialMessageBox();
			TutorialMessageBox("c1_m2_t1");
			return
		end
	end,

	weeklyPopulation = function()
		while true do
			sleep(50);
			local thisday = GetDate(DAY_OF_WEEK);
			if thisday == 1 and GetObjectOwner("Hant") == PLAYER_1 then
				TUTORIALS.markComplete("TUTORIALS.weeklyPopulation");
				WaitForTutorialMessageBox();
				TutorialMessageBox("c1_m2_t8");
				return
			end
		end
    end,
    
	saveGame = function()
		while true do
			local thisday = GetDate(ABSOLUTE_DAY);
			sleep(30);
			if thisday == 12 then
				TUTORIALS.markComplete("TUTORIALS.saveGame");
				WaitForTutorialMessageBox();
				TutorialMessageBox("c1_m2_savegame");
				return
			end
		end
	end,
        
	moonWeeks = function()
		while true do
			local thisday = GetDate(ABSOLUTE_DAY);
			sleep(30);
			if thisday == 15 then
				TUTORIALS.markComplete("TUTORIALS.moonWeeks");
				WaitForTutorialMessageBox();
				TutorialMessageBox("c1_m2_t9");
				return
			end
		end
	end,

    checkHeroPerks = function()  -- hint about perks, see Isabell's combat script
		while true do
			sleep(30);
			if HasHeroSkill("Isabell", PERK_HOLY_CHARGE) or HasHeroSkill("Isabell", PERK_DEMONIC_STRIKE) or HasHeroSkill("Isabell", HERO_SKILL_POWERFULL_BLOW) or HasHeroSkill("Isabell", PERK_PRAYER) then
				SetGameVar("temp.C1M2_perk_hint", 1);
				TUTORIALS.markComplete("TUTORIALS.checkHeroPerks");
				return
			end
		end
    end,
    
	luck = function() --tutorial 03
		Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r03', nil);
		TUTORIALS.markComplete("TUTORIALS.luck");
		WaitForTutorialMessageBox();
		TutorialMessageBox("c1_m2_t3");
    end,

    morale = function() --tutorial 04
		Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r04', nil)
		TUTORIALS.markComplete("TUTORIALS.morale");
		WaitForTutorialMessageBox();
		TutorialMessageBox("c1_m2_t4");
    end,

    attack_town = function() --tutorial 05
      Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r05', nil)
      TUTORIALS.markComplete("TUTORIALS.attack_town");
	  WaitForTutorialMessageBox();
      TutorialMessageBox("c1_m2_t5");
    end,
    
    defence = function() --tutorial 10
      Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r12', nil)
      TUTORIALS.markComplete("TUTORIALS.defence");
	  WaitForTutorialMessageBox();
      TutorialMessageBox("c1_m2_t10");
    end,

	attack = function() --tutorial 11
		Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r11', nil)
		TUTORIALS.markComplete("TUTORIALS.attack");
		WaitForTutorialMessageBox();
		TutorialMessageBox("c1_m2_t11");
    end,
    
    mineCapturedHint = function()
		for i = 1, 3 do
			Trigger( OBJECT_CAPTURE_TRIGGER, 'mine'..i, nil );
		end
		TUTORIALS.markComplete("TUTORIALS.mineCapturedHint");
		WaitForTutorialMessageBox();
		TutorialMessageBox( 'c1_m2_mines' );
	end,
    
    DisableHeroScript = function()
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER ,'castle', nil);
		ResetHeroCombatScript("Isabell");
    end
}

OBJECTIVES = {
    state =  {  -- 0 quest is not active, 1-9 quest is active/custom states, 10 success, 11 fail
      captureStrongbow = { "prim1", 0 }, -- 
      assembleArchers  = { "prim2", 1 }, -- 1 waiting to trigger quest, 2 gather archers, 10 success
      captureAshwood   = { "prim3", 1 }, -- 1 waiting to trigger cinmatic, 10 end of checks
      isAlive          = { "prim4", 1 },
    },

    start = function()
      OBJECTIVES.prepare();
      OBJECTIVES.run();
    end,
    
    prepare = function()
		SetPlayerStartResources( PLAYER_1, 5, 0, 0, 0, 0, 0, 2000 );
		strongbowCaptureDay = 0;
      
		if __difficulty >= DIFFICULTY_NORMAL then
			AddObjectCreatures( 'Tradeville',     CREATURE_ARCHER, 1 + ( __difficulty - 1 ) * 30 );
			AddObjectCreatures( 'Tradeville',    CREATURE_FOOTMAN, 1 + ( __difficulty - 1 ) * 20 );
			AddObjectCreatures( 'Tradeville', CREATURE_MILITIAMAN, 1 + ( __difficulty - 1 ) * 60 );
		end

		Trigger( OBJECT_TOUCH_TRIGGER,  "tower",  "CINEMATICS.showTown" );
		Trigger( OBJECT_TOUCH_TRIGGER, "tower2", "CINEMATICS.showTown2" );

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
        
			if GetObjectiveState( 'prim4') == OBJECTIVE_FAILED then
				Loose();
				return
			end
      
			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and GetObjectiveState("prim2") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep(1);
				SetObjectiveState( "prim4", OBJECTIVE_COMPLETED );
				SaveHeroAllSetArtifactsEquipped("Isabell", "C1M2");
				sleep(5);
				Win();
				return
			end
		end
    end,

	captureStrongbow = function()
	-- start and finish of this task is handled by C1M2.xdb
    -- prize: 1000 gold
	end,
    
    assembleArchers = function()
	  -- start of this task is handled by C1M2.xdb
		if OBJECTIVES.state.assembleArchers[2] == 1 and GetObjectOwner("Hant") == PLAYER_1 then
			if ( GetHeroCreatures( "Isabell", CREATURE_ARCHER ) + GetHeroCreatures( "Isabell", CREATURE_MARKSMAN ) + GetHeroCreatures( "Isabell", CREATURE_LONGBOWMAN ) ) >= 100 then
				SetObjectiveState( "prim2", OBJECTIVE_COMPLETED );
				GiveExp( "Isabell", 3000 );
				OBJECTIVES.state.assembleArchers[2] = 10;
			end
		end
    end,
    
    captureAshwood = function()
    -- completion of this task is handled by C1M2.xdb
		if OBJECTIVES.state.captureAshwood[2] == 1 and GetObjectOwner("Hant") == PLAYER_1 then
			strongbowCaptureDay = OBJECTIVES.date;
			OBJECTIVES.state.captureAshwood[2] = 2;
		elseif OBJECTIVES.state.captureAshwood[2] == 2 and OBJECTIVES.date >= (strongbowCaptureDay + 3) then
			CINEMATICS.captureAshwood();
			SetObjectiveState('prim3', OBJECTIVE_ACTIVE)
			OBJECTIVES.state.captureAshwood[2] = 10;
		end
	end,
      
	isAlive = function()
    -- start of this task is handled by C1M2.xdb
		if IsHeroAlive("Isabell") == nil then
			SetObjectiveState( 'prim4', OBJECTIVE_FAILED );
			sleep(2);
		end
	end,
}
------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( TUTORIALS.run );
