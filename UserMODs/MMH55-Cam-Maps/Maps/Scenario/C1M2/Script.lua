doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

HERO_NAME = "Isabell"
function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M2");
	LoadHeroAllSetArtifacts( HERO_NAME , "C1M1" );
end

startThread(H55_InitSetArtifacts);

H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_BOOTS_OF_LEVITATION};
H55_CamFixTooManySkills(PLAYER_1,HERO_NAME);

m01= "c1_m2_t1" ;--"/Maps/Scenario/C1M2/tutorial/tutorial1.txt"
m02= "c1_m2_t2" ;--"/Maps/Scenario/C1M2/tutorial/tutorial2.txt"
m03= "c1_m2_t3" ;--"/Maps/Scenario/C1M2/tutorial/tutorial3.txt"
m04= "c1_m2_t4" ;--"/Maps/Scenario/C1M2/tutorial/tutorial4.txt"
m05= "c1_m2_t5" ;--"/Maps/Scenario/C1M2/tutorial/tutorial5.txt"
m06= "c1_m2_t6_1" ;--"/Maps/Scenario/C1M2/tutorial/tutorial6.txt"
m63= "c1_m2_t6_2" ;--"/Maps/Scenario/C1M2/tutorial/tutorial61.txt"
m61= "c1_m2_t6_3" ;--"/Maps/Scenario/C1M2/tutorial/tutorial62.txt"
m62= "c1_m2_t6_4" ;--"/Maps/Scenario/C1M2/tutorial/tutorial62.txt"
m07= "c1_m2_t7" ;--"/Maps/Scenario/C1M2/tutorial/tutorial7.txt"
m08= "c1_m2_t8" ;--"/Maps/Scenario/C1M2/tutorial/tutorial8.txt"
m09= "c1_m2_t9" ;--"/Maps/Scenario/C1M2/tutorial/tutorial9.txt"
m10= "c1_m2_t10" ;--"/Maps/Scenario/C1M2/tutorial/tutorial10.txt"
m11= "c1_m2_t11" ;--"/Maps/Scenario/C1M2/tutorial/tutorial11.txt"
m12= "c1_m2_t12" ;--"/Maps/Scenario/C1M2/tutorial/tutorial12.txt"
m13= "c1_m2_t13" ;--"/Maps/Scenario/C1M2/tutorial/tutorial13.txt"
s1="/DialogScenes/C1/M2/R1/DialogScene.xdb#xpointer(/DialogScene)";
s2="/DialogScenes/C1/M2/R2/DialogScene.xdb#xpointer(/DialogScene)";
s3="/DialogScenes/C1/M2/R3/DialogScene.xdb#xpointer(/DialogScene)";

CINEMATICS = {
    intro = function()
      StartDialogScene(s1);
    end,

    captureAshwood = function()
      StartDialogScene(s2);
    end,
    
    outro = function()
      StartDialogScene(s3);
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
    	{              m03,     REGION_ENTER_AND_STOP_TRIGGER,      "r03",               "TUTORIALS.luck", 0 },
    	{              m04,     REGION_ENTER_AND_STOP_TRIGGER,      "r04",             "TUTORIALS.morale", 0 },
    	{              m05,     REGION_ENTER_AND_STOP_TRIGGER,      "r05",        "TUTORIALS.attack_town", 0 },
    	{              m10,     REGION_ENTER_AND_STOP_TRIGGER,      "r12",            "TUTORIALS.defence", 0 },
    	{              m11,     REGION_ENTER_AND_STOP_TRIGGER,      "r11",             "TUTORIALS.attack", 0 },
    	{    "c1_m2_mines",            OBJECT_CAPTURE_TRIGGER,    "mine1",   "TUTORIALS.mineCapturedHint", 0 },
    	{    "c1_m2_mines",            OBJECT_CAPTURE_TRIGGER,    "mine2",   "TUTORIALS.mineCapturedHint", 0 },
    	{    "c1_m2_mines",            OBJECT_CAPTURE_TRIGGER,    "mine3",   "TUTORIALS.mineCapturedHint", 0 },
    	{    "c1_m2_build",            OBJECT_CAPTURE_TRIGGER,     "Hant",        "TUTORIALS.buildPerDay", 0 },
    	{ "c1_m2_heroperk",                            THREAD,          0,     "TUTORIALS.checkHeroPerks", 0 },
    	{              m01,                            THREAD,          0,          "TUTORIALS.seizeTown", 0 },
    	{              m08,            OBJECT_CAPTURE_TRIGGER,     "Hant",   "TUTORIALS.weeklyPopulation", 0 },
    	{ "c1_m2_savegame",                            THREAD,          0,           "TUTORIALS.saveGame", 0 },
    	{              m09,                            THREAD,          0,          "TUTORIALS.moonWeeks", 0 },
    	{    "hero_screen",                            WINDOW,          0,                              0, 0 },
    	{       "c1_m2_t2", REGION_ENTER_WITHOUT_STOP_TRIGGER,   "castle",  "TUTORIALS.DisableHeroScript", 0 },
    },

    run = function()
      SetGameVar(             "temp.tutorial", 1);
      SetGameVar(       "temp.C1M2_perk_hint", 0);
      SetGameVar(    "temp.C1M2_archers_hint", 0);
      SetGameVar("temp.C1M2_CountVisitToTown", 0); -- t6_1 t6_2 t6_3 t6_4
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
        local thisday = GetDate(ABSOLUTE_DAY);
        sleep(30);
        if (thisday == strongbowCaptureDay+1) then
          WaitForTutorialMessageBox();
          TutorialMessageBox(m08);
          TUTORIALS.markComplete("TUTORIALS.buildPerDay");
          return
        end
      end
    end,
    
    seizeTown = function()
      while true do
        local thisday = GetDate(ABSOLUTE_DAY);
        sleep(10);
        if thisday == 2 then
	        WaitForTutorialMessageBox();
	        TutorialMessageBox(m01);
	        TUTORIALS.markComplete("TUTORIALS.seizeTown");
          return
        end
      end
    end,

    weeklyPopulation = function()
      while true do
        sleep(30);
        local thisday = GetDate(ABSOLUTE_DAY);
        if (thisday == 8) then
          WaitForTutorialMessageBox();
          TutorialMessageBox(m08);
          TUTORIALS.markComplete("TUTORIALS.weeklyPopulation");
          return
        end
      end
    end,
    
    saveGame = function()
      while true do
        local thisday = GetDate(ABSOLUTE_DAY);
        sleep(20);
        if thisday == 12 then
          WaitForTutorialMessageBox();
          TutorialMessageBox("c1_m2_savegame");
          TUTORIALS.markComplete("TUTORIALS.saveGame");
          return
        end
      end
    end,
        
    moonWeeks = function()
      while true do
        local thisday = GetDate(ABSOLUTE_DAY);
        sleep(30);
        if thisday == 15 then
          WaitForTutorialMessageBox();
          TutorialMessageBox(m09);
          TUTORIALS.markComplete("TUTORIALS.moonWeeks");
          return
        end
      end
    end,

    checkHeroPerks = function()  -- hint about perks, see Isabell's combat script
      while true do
        sleep(20);
  		  if HasHeroSkill(HERO_NAME, PERK_HOLY_CHARGE) or HasHeroSkill(HERO_NAME, PERK_DEMONIC_STRIKE) or HasHeroSkill(HERO_NAME, HERO_SKILL_POWERFULL_BLOW) or HasHeroSkill(HERO_NAME, PERK_PRAYER) then
  	 		  SetGameVar("temp.C1M2_perk_hint", 1);
	        TUTORIALS.markComplete("TUTORIALS.checkHeroPerks");
  			  return
  		  end
  	  end
    end,
    
    luck = function() --tutorial 03
      TUTORIALS.markComplete("TUTORIALS.luck");
      TutorialMessageBox(m03);
      Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r03', nil);
    end,

    morale = function() --tutorial 04
      TUTORIALS.markComplete("TUTORIALS.morale");
      TutorialMessageBox(m04);
      Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r04', nil)
    end,

    attack_town = function() --tutorial 05
      TUTORIALS.markComplete("TUTORIALS.attack_town");
      TutorialMessageBox(m05);
      Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r05', nil)
    end,
    
    defence = function() --tutorial 10
      TUTORIALS.markComplete("TUTORIALS.defence");
      TutorialMessageBox(m10);
      Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r12',nil)
    end,

    attack = function() --tutorial 11
      TUTORIALS.markComplete("TUTORIALS.attack");
      TutorialMessageBox(m11);
      Trigger(REGION_ENTER_AND_STOP_TRIGGER ,'r11',nil)
    end,
    
    mineCapturedHint = function()
      TUTORIALS.markComplete("TUTORIALS.mineCapturedHint");
      TutorialMessageBox( 'c1_m2_mines' );
      for i = 1, 3 do
        Trigger( OBJECT_CAPTURE_TRIGGER, 'mine'..i, nil );
      end
    end,
    
    DisableHeroScript = function()
	    ResetHeroCombatScript(HERO_NAME);
      Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER ,'castle', nil);
    end
}

OBJECTIVES = {
    state =  {  -- 0 quest is not active, 1-9 quest is active/custom states, 10 success, 11 fail
      captureStrongbow = { "prim1", 1 }, -- 1 quest active, 10 strongbow captured
      assembleArchers  = { "prim2", 1 }, -- 1 waiting to trigger quest, 2 gather archers, 10 success
      captureAshwood   = { "prim3", 1 }, -- 1 waiting to trigger cinmatic, 10 end of checks
      isAlive          = { "prim4", 1 },
    },

    start = function()
      OBJECTIVES.prepare();
      startThread( TUTORIALS.run );
      OBJECTIVES.run();
    end,
    
    prepare = function()
      SetPlayerStartResource( PLAYER_1,    WOOD,    5 );
      SetPlayerStartResource( PLAYER_1,     ORE,    0 );
      SetPlayerStartResource( PLAYER_1,     GEM,    0 );
      SetPlayerStartResource( PLAYER_1, CRYSTAL,    0 );
      SetPlayerStartResource( PLAYER_1,  SULFUR,    0 );
      SetPlayerStartResource( PLAYER_1, MERCURY,    0 );
      SetPlayerStartResource( PLAYER_1,    GOLD, 2000 );
      strongbowCaptureDay = 0;
      
      -- Game difficulty adjustment
      if __difficulty >= DIFFICULTY_NORMAL then
		    AddObjectCreatures( 'Tradeville',     CREATURE_ARCHER, ( __difficulty - 1 ) * 30 ); -- -1 is for new difficulty levels (VERSION: P0)
		    AddObjectCreatures( 'Tradeville',    CREATURE_FOOTMAN, ( __difficulty - 1 ) * 20 );
		    AddObjectCreatures( 'Tradeville', CREATURE_MILITIAMAN, ( __difficulty - 1 ) * 60 );
      end
      
      -- Set triggers
      Trigger( OBJECT_TOUCH_TRIGGER,  "tower",  "CINEMATICS.showTown" );
      Trigger( OBJECT_TOUCH_TRIGGER, "tower2", "CINEMATICS.showTown2" );

      CINEMATICS.intro();
    end,

    run = function()
     	while true do
        for key, value in OBJECTIVES.state do
          if value[2] > 0 and value[2] < 10 then
            OBJECTIVES[key]();
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
          SaveHeroAllSetArtifactsEquipped(HERO_NAME, "C1M2");
          sleep(5);
          Win();
         return
        end
        sleep(10);
      end
    end,

    captureStrongbow = function()
    -- completion of this task is handled by C1M2.xdb
    -- prize: 1000 gold
      if GetObjectiveState("prim1") == OBJECTIVE_UNKNOWN then
        SetObjectiveState('prim1',OBJECTIVE_ACTIVE);
      end
      if GetObjectOwner("Hant") == PLAYER_1 then
        strongbowCaptureDay = GetDate(ABSOLUTE_DAY);
        print("Strongbow captured on day " .. strongbowCaptureDay);
        OBJECTIVES.state.captureStrongbow[2] = 10;
      end
    end,
    
    assembleArchers = function()
      if OBJECTIVES.state.assembleArchers[2] == 1 and OBJECTIVES.state.captureStrongbow[2] == 10 then
        SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
        OBJECTIVES.state.assembleArchers[2] = 2;
      end
      if OBJECTIVES.state.assembleArchers[2] == 2 then
        if ( GetHeroCreatures( HERO_NAME, CREATURE_ARCHER ) + GetHeroCreatures( HERO_NAME, CREATURE_MARKSMAN ) + GetHeroCreatures( HERO_NAME, CREATURE_LONGBOWMAN ) ) >= 100 then
          SetObjectiveState( "prim2", OBJECTIVE_COMPLETED );
          GiveExp( HERO_NAME, 3000 );
          OBJECTIVES.state.assembleArchers[2] = 10;
		    end
		  end
    end,
    
    captureAshwood = function()
    -- completion of this task is handled by C1M2.xdb
    -- prize: None
      if OBJECTIVES.state.captureStrongbow[2] == 10 then
        if GetDate(ABSOLUTE_DAY) >= (strongbowCaptureDay + 3) then
          CINEMATICS.captureAshwood();
          SetObjectiveState('prim3', OBJECTIVE_ACTIVE)
          OBJECTIVES.state.captureAshwood[2] = 10;
        end
      end
    end,
      
    isAlive = function()
    -- start of this task is handled by C1M2.xdb
      if not IsHeroAlive(HERO_NAME) then
        SetObjectiveState( 'prim4', OBJECTIVE_FAILED );
        sleep(2);
      end
    end,
}
------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
