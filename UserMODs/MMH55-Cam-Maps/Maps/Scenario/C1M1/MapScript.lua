doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

startThread(InitAllSetArtifacts, "C1M1");
H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_BOOTS_OF_LEVITATION};
HERO_NAME = "Isabell";

TUTORIALS = {
    list = {
    --{          "c1_m1_mill", REGION_ENTER_AND_STOP_TRIGGER, "windmill",      "TUTORIALS.explainMillOffer", 0 },
    --{            "c1_m1_t4", REGION_ENTER_AND_STOP_TRIGGER, "attack04",           "TUTORIALS.howToAttack", 0 },
    	{      "howToUseCamera", REGION_ENTER_AND_STOP_TRIGGER,    "stop5",       "TUTORIALS.howToUseCamera", 0 },
    	{      "howToUseCamera", REGION_ENTER_AND_STOP_TRIGGER,    "stop6",       "TUTORIALS.howToUseCamera", 0 },
    	{      "howToUseCamera", REGION_ENTER_AND_STOP_TRIGGER,    "stop7",       "TUTORIALS.howToUseCamera", 0 },
    	{      "howToUseCamera", REGION_ENTER_AND_STOP_TRIGGER,    "stop8",       "TUTORIALS.howToUseCamera", 0 },
    	{      "howToUseCamera", REGION_ENTER_AND_STOP_TRIGGER,     "cam1",       "TUTORIALS.howToUseCamera", 0 },
    	{            "c1_m1_t7", REGION_ENTER_AND_STOP_TRIGGER,       "t7",      "TUTORIALS.explainResources", 0 },
    	{            "c1_m1_t8", REGION_ENTER_AND_STOP_TRIGGER,       "t8", "TUTORIALS.explainBoostBuildings", 0 },
    	{           "c1_m1_t10",          HERO_LEVELUP_TRIGGER,  HERO_NAME,      "TUTORIALS.howToInspectHero", 0 },
    	{         "c1_m1_t11_1",                        COMBAT,          0,                                 0, 0 },
    	{      "c1_m1_t11_hero",                        COMBAT,          0,                                 0, 0 },
    	{       "c1_m1_t11_new",                        COMBAT,          0,                                 0, 0 },
    	{          "c1_m1_t6_1",                        THREAD,          0,               "TUTORIALS.endTurn", 0 },
    	{			 "c1_m1_t1",                        THREAD,          0,       "TUTORIALS.explainTaskPane", 0 },
    	--{            "c1_m1_t2",                        THREAD,          0,         "TUTORIALS.howToMoveHero", 0 },
    	{       "level_up_hint",                        WINDOW,          0,                                 0, 0 },
    	--{ "creatures_join_hint",                        WINDOW,          0,                                 0, 0 },
    	--{ "creatures_flee_hint",                        WINDOW,          0,                                 0, 0 },
    	{         "hero_screen",                        WINDOW,          0,                                 0, 0 },
    	{       "barracks_hint",                        WINDOW,          0,                                 0, 0 }
    },

    run = function()
      SetGameVar( "temp.C1M1.num_combat", 0 );
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

    endTurn = function()
      while GetHeroStat(HERO_NAME, STAT_MOVE_POINTS) > 150 do
        sleep(5)
      end
      TutorialSetBlink("end_of_turn_blink", 1)
      WaitForTutorialMessageBox()
      TutorialMessageBox("c1_m1_t6_1")
      while GetHeroStat(HERO_NAME, STAT_MOVE_POINTS) <= 150 do
        sleep(5)
      end
      TutorialSetBlink("end_of_turn_blink", 0)
      TUTORIALS.markComplete("TUTORIALS.endTurn");
    end,

    explainTaskPane = function()
      WaitForTutorialMessageBox();
      TutorialSetBlink( "scenario_info_blink", 1 );
      TutorialMessageBox( "c1_m1_t1" );
      sleep(40);
      TutorialSetBlink( "scenario_info_blink", 0 );
    end,

    howToMoveHero = function()
      start_x, start_y = GetObjectPosition( HERO_NAME );
      repeat
        pos_x, pos_y = GetObjectPosition( HERO_NAME );
        sleep(5);
      until not (( pos_x == start_x ) and ( pos_y == start_y ))
	    TutorialSetBlink( "move_hero_blink", 1 );
 	  	WaitForTutorialMessageBox();
	    TutorialMessageBox( "c1_m1_t2" );
	    sleep(25);
	    TutorialSetBlink( "move_hero_blink", 0 );
	    TUTORIALS.markComplete("TUTORIALS.howToMoveHero");
    end,

    howToUseCamera = function()
	  WaitForTutorialMessageBox();
      TutorialMessageBox( "howToUseCamera" );
      Trigger(REGION_ENTER_AND_STOP_TRIGGER, "stop5", nil)
      Trigger(REGION_ENTER_AND_STOP_TRIGGER, "stop6", nil)
      Trigger(REGION_ENTER_AND_STOP_TRIGGER, "stop7", nil)
      Trigger(REGION_ENTER_AND_STOP_TRIGGER, "stop8", nil)
      Trigger(REGION_ENTER_AND_STOP_TRIGGER , "cam1", nil)
      TUTORIALS.markComplete("TUTORIALS.howToUseCamera");
    end,

    howToAttack = function()
		WaitForTutorialMessageBox();
		TutorialMessageBox( "c1_m1_t4" );
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "attack04", nil)
		TUTORIALS.markComplete("TUTORIALS.howToAttack");
    end,

    explainResources = function()
		WaitForTutorialMessageBox();
		TutorialMessageBox( "c1_m1_t7" );
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "t7", nil);
		TUTORIALS.markComplete("TUTORIALS.explainResources");
    end,

    explainBoostBuildings = function()
  		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "t8", nil)
		WaitForTutorialMessageBox();
  		TutorialMessageBox( "c1_m1_t8" );
 	    TUTORIALS.markComplete("TUTORIALS.explainBoostBuildings");
    end,

    explainDwelligs = function()
 	    Trigger(REGION_ENTER_AND_STOP_TRIGGER, "t9_1", nil)
		WaitForTutorialMessageBox();
 	    TutorialMessageBox( "c1_m1_t9_1" );
 	    TUTORIALS.markComplete("TUTORIALS.explainDwelligs");
    end,

    howToInspectHero = function()
 	    Trigger(REGION_ENTER_AND_STOP_TRIGGER, "t10", nil);
		TutorialSetBlink( "hero_blink", 1 );
		WaitForTutorialMessageBox();
		TutorialMessageBox( "c1_m1_t10" );
 	    sleep(20);
 	    TutorialSetBlink( "hero_blink", 0 );
 	    TUTORIALS.markComplete("TUTORIALS.howToInspectHero");
    end,

    explainMillOffer = function()
	    Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER , "windmill", nil );
		WaitForTutorialMessageBox();
		TutorialMessageBox( "c1_m1_mill" );
	    TUTORIALS.markComplete("TUTORIALS.explainMillOffer");
   end
}

BATTLES  = {
    rebels = {
      start = function(nameHero)
        if nameHero == HERO_NAME then
          CINEMATICS.rebels();
   		    StartCombat(HERO_NAME, nil, 1, CREATURE_PEASANT, 13, '/Maps/Scenario/C1M1/C1M1-CombatScript.xdb#xpointer(/Script)', 'BATTLES.rebels.finish');
  		    sleep(2);
  		    RemoveObject( "enemy1" );
          sleep(2);
          Trigger( REGION_ENTER_AND_STOP_TRIGGER , "d2", nil );
        end
      end,

      finish = function()
 	    SetHeroCombatScript( HERO_NAME, '/Maps/Scenario/C1M1/IsabellScript.xdb#xpointer(/Script)' );
      end
    }
}

CINEMATICS = {
    intro = function()
      StartDialogScene("/DialogScenes/C1/M1/D1/DialogScene.xdb#xpointer(/DialogScene)");
      sleep(2)
    end,

    rebels = function(nameHero)
      StartDialogScene("/DialogScenes/C1/M1/D2/DialogScene.xdb#xpointer(/DialogScene)");
      sleep(2)
    end,

    outro = function()
      StartDialogScene("/DialogScenes/C1/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
      sleep(2);
    end,

    garrison = function()
      MessageBox( '/Maps/Scenario/C1M1/notready.txt');
    end,
    
    showGarrison = function()
	  x, y, fl = GetObjectPosition( 'zastava' );
      sleep(30);
      MoveCamera(x, y, fl, 30, 0.9, 0.3, 1, 1, 1);
      sleep(2);
      OpenCircleFog( x, y, fl, 6, PLAYER_1 );
      sleep(10);
    end,
}

OBJECTIVES = {
    state =  {  -- 0 quest is not active or managed by map.xdb, 1 quest is active, 2-9 custom states, 10 success, 11 fail
      getPeasants  = { "prim1a", 1 },
      getFootmen   = { "prim1",  1 },
      --isAlive      = { "prim2",  0 }, -- this quest as well as map loss rules are managed by C1M1.xdb
      getGarrison  = { "prim3",  1 }
    },

    start = function()
      OBJECTIVES.prepare();
      OBJECTIVES.run();
    end,
    
    prepare = function()
      SetPlayerResource( PLAYER_1,    WOOD, 0 );
      SetPlayerResource( PLAYER_1,     ORE, 0 );
      SetPlayerResource( PLAYER_1, MERCURY, 0 );
      SetPlayerResource( PLAYER_1, CRYSTAL, 0 );
      SetPlayerResource( PLAYER_1,  SULFUR, 0 );
      SetPlayerResource( PLAYER_1,     GEM, 0 );
      SetPlayerResource( PLAYER_1,    GOLD, 0 );
      SetObjectEnabled( 'zastava', nil );

      Trigger( REGION_ENTER_AND_STOP_TRIGGER,        "d2",    "CINEMATICS.c1m1d2" );
      Trigger( REGION_ENTER_AND_STOP_TRIGGER,        "d2", "BATTLES.rebels.start" );
      Trigger(          OBJECT_TOUCH_TRIGGER,   "zastava",  "CINEMATICS.garrison" );

      GiveExp( HERO_NAME, 500 );
      MessageBox({"/Text/Game/Scripts/CampaignHelper.txt"});
      CINEMATICS.intro();
    end,

	run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] >= 1 and value[2] < 10 then
					if pcall(OBJECTIVES[key]) == nil then print(key) end;
				end
			end

			if GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
				SetObjectiveState( "prim2", OBJECTIVE_COMPLETED );
				sleep(10);
				CINEMATICS.outro();
				SaveHeroAllSetArtifactsEquipped(HERO_NAME, "C1M1");
				sleep(5)
				Win();
				return
			end
		end
    end,

    getPeasants = function()
      if ( GetObjectiveState( 'prim1a' ) == OBJECTIVE_UNKNOWN ) then
        SetObjectiveState( 'prim1a', OBJECTIVE_ACTIVE );
	    end
      nPeasant = GetHeroCreatures(HERO_NAME, CREATURE_PEASANT) + GetHeroCreatures(HERO_NAME, CREATURE_MILITIAMAN) + GetHeroCreatures(HERO_NAME, CREATURE_LANDLORD);
      if nPeasant >= 100 then
        SetObjectiveState("prim1a", OBJECTIVE_COMPLETED);
        GiveExp( HERO_NAME, 500 );
        OBJECTIVES.state.getPeasants[2] = 10;
	    end
    end,

    getFootmen = function()
      if ( GetObjectiveState( 'prim1' ) == OBJECTIVE_UNKNOWN ) then
        SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );
	    end
      nFootman = GetHeroCreatures(HERO_NAME, CREATURE_FOOTMAN) + GetHeroCreatures(HERO_NAME, CREATURE_SWORDSMAN) + GetHeroCreatures(HERO_NAME, CREATURE_VINDICATOR);
      if nFootman >= 25 then
        SetObjectiveState("prim1", OBJECTIVE_COMPLETED);
        GiveExp( HERO_NAME, 500 );
        OBJECTIVES.state.getFootmen[2] = 10;
      end
    end,

    getGarrison = function()
      if GetObjectiveState( 'prim3' ) == OBJECTIVE_UNKNOWN and OBJECTIVES.state.getPeasants[2] == 10 and OBJECTIVES.state.getFootmen[2] == 10 then
        SetObjectEnabled( 'zastava', 1 );
        Trigger( OBJECT_TOUCH_TRIGGER, "zastava", nil );
        CINEMATICS.showGarrison();
        SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
      end
      if GetObjectOwner("zastava") == PLAYER_1 then
        SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
        OBJECTIVES.state.getGarrison[2] = 10;
      end
    end
}
------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( TUTORIALS.run );