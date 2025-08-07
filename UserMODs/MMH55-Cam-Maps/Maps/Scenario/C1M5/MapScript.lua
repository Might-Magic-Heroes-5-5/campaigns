doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not _AI_UpdateTargetWeight do
    sleep()
end

AI_CONTROLLED = {
  player1 = {
      state = 0,       -- 0 human
	   heroes = {},
	  enemies = {},
   },
  player2 = { 		     -- Red Inferno AI player
      state = 2,
	   heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = 0.1, towns = 1.0, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
    }
  }
}

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M5");
end

startThread(H55_InitSetArtifacts);

H55_PlayerStatus = {0,1,1,2,2,2,2,2};

CINEMATICS = {
  intro = function()
  	StartDialogScene("/DialogScenes/C1/M5/D1/DialogScene.xdb#xpointer(/DialogScene)");
  	sleep( 2 );
  	OpenCircleFog( 26, 109, 0, 7, PLAYER_1 );
  end,
  
  searchForGrail = function()
		StartDialogScene("/DialogScenes/C1/M5/D4A/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
  rescueIsabell = function()
		StartDialogScene("/DialogScenes/C1/M5/D3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

  defeatAgrael = function()
		StartDialogScene("/DialogScenes/C1/M5/D4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
  grailConstructed = function()
		StartDialogScene("/DialogScenes/C1/M5/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
  sendGodricOnMission = function()
		StartDialogScene("/DialogScenes/C1/M5/D5/DialogScene.xdb#xpointer(/DialogScene)");
    sleep( 2 );
		OpenCircleFog( 129, 15, 0, 6, PLAYER_1 );
	end,
	
  godricLeaves = function()
		StartDialogScene("/DialogScenes/C1/M5/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
  isabellJoinNikolai = function()
		StartDialogScene("/DialogScenes/C1/M5/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

  outro = function()
		StartCutScene("/Maps/Cutscenes/C1M5/_.(AnimScene).xdb#xpointer(/AnimScene)");
    sleep( 2 );
	end,

  GodrickLearnsIsabellPrisonLocation = function()
		MessageBox("/Maps/Scenario/C1M5/Tutorial/C1M5_C11.txt", "CINEMATICS.GodrickLearnsIsabellPrisonLocation2");
	end,
	
	GodrickLearnsIsabellPrisonLocation2 = function()
	  MessageBox("/Maps/Scenario/C1M5/Tutorial/C1M5_C11_2.txt");
  end,
}

function DeployAssaultHero( heroNumber )
	local modulus = mod( heroNumber, 3 );
	local pos = random( 2 ) + 1;
	local name = assault_hero_names[modulus + 1];
	DeployReserveHero( name, portals[pos][1], portals[pos][2], GROUND );
	sleep(3);
	ADD_ASSAULT_HERO(name);
  sleep(3);
	if modulus == 0 then
		numcreatures = (100 + heroNumber * 15 + random( 5 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_IMP, numcreatures );
		end
		
		numcreatures = (36 + heroNumber * 12 + random( 5 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_HORNED_DEMON, numcreatures );
    end
		
		numcreatures = (20 + heroNumber * 8 + random( 3 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_CERBERI, numcreatures );
    end
		
		numcreatures = (9 + heroNumber * 4) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_INFERNAL_SUCCUBUS, numcreatures );
    end
		
		numcreatures = (2 + heroNumber) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_DEVIL, numcreatures );
    end
	elseif modulus == 1 then
		numcreatures = (90 + heroNumber * 16 + random( 5 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_FAMILIAR, numcreatures );
    end
		
		numcreatures = (42 + heroNumber * 10 + random( 5 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_DEMON, numcreatures );
    end
		
		numcreatures = (36 + heroNumber * 6 + random( 3 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_CERBERI, numcreatures );
    end
		
		numcreatures = (9 + heroNumber * 2) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_FRIGHTFUL_NIGHTMARE, numcreatures );
    end
		
		numcreatures = (1 + heroNumber) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_ARCHDEVIL, numcreatures );
    end
	elseif modulus == 2 then
		numcreatures = (40 + heroNumber * 9 + random( 4 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_HORNED_DEMON, numcreatures );
    end
		
		numcreatures = (30 + heroNumber * 7 + random( 3 )) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_HELL_HOUND, numcreatures );
    end
		
		numcreatures = (12 + heroNumber * 4) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_SUCCUBUS, numcreatures );
    end
		
		numcreatures = (6 + heroNumber * 3) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_NIGHTMARE, numcreatures );
    end
		
		numcreatures = (4 + heroNumber * 2) * easyfactor;
		if numcreatures >= 1 then
			AddHeroCreatures( name, CREATURE_BALOR, numcreatures );
    end
 end
	print(" ",name," is going");
end

function IsAnyHeroPlayerHasArtifact( playerID, artifID )
	local heroes = {};
	local m = 0;
	local h = 0;
	heroes = GetPlayerHeroes( playerID );
	for m, h in heroes do
		if HasArtefact( h, artifID ) then
			return not nil;
	    end
	end
	return nil
end

TUTORIALS = {
    list = {
    	{ "c1_m5_t2", REGION_ENTER_AND_STOP_TRIGGER,   "t2", "TUTORIALS.obelisks", 0 },
    	{ "c1_m5_t2", REGION_ENTER_AND_STOP_TRIGGER, "t2_1", "TUTORIALS.obelisks", 0 },
      { "c1_m5_t2", REGION_ENTER_AND_STOP_TRIGGER, "t2_2", "TUTORIALS.obelisks", 0 },
    	{ "c1_m5_t3",          OBJECT_TOUCH_TRIGGER, "t3_1",  "TUTORIALS.digging", 0 },
    	{ "c1_m5_t3",          OBJECT_TOUCH_TRIGGER, "t3_2",  "TUTORIALS.digging", 0 },
    	{ "c1_m5_t3",          OBJECT_TOUCH_TRIGGER, "t3_4",  "TUTORIALS.digging", 0 },
    	--Trigger( OBJECT_TOUCH_TRIGGER, "t3_3", "TUTORIALS.digging" ); -- check if present or obsolete
    },

    run = function()
      SetGameVar(        "temp.tutorial", 1 );
      SetGameVar("temp.C1M5_firstcombat", 1 );
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
    
    obelisks = function(nameHero)
	    if GetObjectOwner(nameHero) ~= PLAYER_1 then
  	    TutorialMessageBox( "c1_m5_t2" );
  		  WaitForTutorialMessageBox();
  		  TutorialMessageBox( "c1_m5_t2_2" );
  		  WaitForTutorialMessageBox();
  	    Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "t2", nil );
  	    Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2_1", nil );
  	    Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2_2", nil );
  	    TUTORIALS.markComplete("TUTORIALS.obelisks");
	    end
    end,

    digging = function(nameHero)
	    if GetObjectOwner(nameHero) == PLAYER_1 then
        TutorialMessageBox( "c1_m5_t3" );
	      Trigger( OBJECT_TOUCH_TRIGGER, "t3_1", nil );
	      Trigger( OBJECT_TOUCH_TRIGGER, "t3_2", nil );
	      --Trigger( OBJECT_TOUCH_TRIGGER, "t3_3", nil );
	      Trigger( OBJECT_TOUCH_TRIGGER, "t3_4", nil );
	      TUTORIALS.markComplete("TUTORIALS.digging");
      end
    end,
}

OBJECTIVES = {
  state = { -- 0 quest is not active or managed by map.xdb, 1 quest is active, 2-9 custom states, 10 success, 11 fail
    rescueIsabell = { "prim1", 1 },   -- 2 Godric captures Dunmor and learns he has to free Isabel ASAP, 3 Isabel is freed, 10 Isabel is free and Dunmor is captured, 11 on 8th day mission will fail
    protectDunmor = { "prim2", 1 },   -- 2 Dunmor captured & Agrael attacks, 3 Agrael is defeated, 4 Infero heroes onslaught begins, 5-6 Agrael second attack.
    buildGrail    = { "prim3", 1 },   -- 1 waiting to activate/activated, 2 found the grail, 10 build the grail
    sendGodric    = { "prim4", 1 },   -- 1 missions active, 2,10 mission success
    joinNikolai   = { "prim5", 1 },
    isAlive       = { "prim6", 1 },
  },

  start = function()
    OBJECTIVES.prepare();
    startThread( TUTORIALS.run );
    OBJECTIVES.run();
  end,

  prepare = function()
  -- set difficulty
    factor_by_diffculty = { 0.35, 0.7, 1.0, 1.00 }
    easyfactor = factor_by_diffculty[__difficulty + 1]

    crap = __difficulty - 1;
    if crap < 0 then
    	crap = 0;
    end
    
    ASSAULT_DELAY = 8 - crap;
    nAssaultCount = 0;
    assault_hero_names = { "Nymus", "Jazaz", "Efion" };
    enemy_defeats = {
        Agrael = 0,
        Jazaz  = 0,
        Efion  = 0,
        Nymus  = 0,
    }
    Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "OBJECTIVES._CountEnemyDefeats" );
    Trigger( OBJECT_TOUCH_TRIGGER, "Prison", "OBJECTIVES._RescueIsabell" );
    
  -- set player resource
    SetPlayerStartResource( PLAYER_1,    WOOD, 10 );
    SetPlayerStartResource( PLAYER_1,     ORE, 10 );
    SetPlayerStartResource( PLAYER_1,     GEM,  5 );
    SetPlayerStartResource( PLAYER_1, CRYSTAL,  5 );
    SetPlayerStartResource( PLAYER_1, MERCURY,  5 );
    SetPlayerStartResource( PLAYER_1,  SULFUR,  5 );
    SetPlayerStartResource( PLAYER_1,    GOLD, 7000 - crap * 2000 );

  -- set enemy exp
    GiveExp( 'Jazaz', 50000 + crap * 35000 );
  	GiveExp( 'Efion', 50000 + crap * 35000 );
  	GiveExp( 'Nymus', 50000 + crap * 35000 );

    SetRegionBlocked( 'AIblock', 1, PLAYER_2 );
    for i = 1, 3 do
     	SetRegionBlocked( 'grail_block'..i, 1, PLAYER_2 );
    end
    
    SetRegionBlocked(  "t2", 1, 2);
    SetRegionBlocked("t2_1", 1, 2);
    SetRegionBlocked("t2_2", 1, 2);
    portals = { {38, 27}, {71, 86} };
    CINEMATICS.intro();
  end,

  run = function()
   	while true do
      for key, value in OBJECTIVES.state do
        if value[2] > 0 and value[2] < 10 then
          OBJECTIVES[key]();
        end
      end
      
      if GetObjectiveState( 'prim1') == OBJECTIVE_FAILED or GetObjectiveState('prim2') == OBJECTIVE_FAILED or GetObjectiveState('prim3') == OBJECTIVE_FAILED or GetObjectiveState( 'prim6') == OBJECTIVE_FAILED then
        Loose();
        return
      end
      
      if GetObjectiveState( "prim5") == OBJECTIVE_COMPLETED then
        CINEMATICS.outro();
	  	  Win();
	  	  return
      end
      sleep(10);
    end
  end,
  
  _RescueIsabell = function()
    OBJECTIVES.state.rescueIsabell[2] = 3;
  end,
  
  rescueIsabell = function()
    if GetObjectiveState('prim1') == OBJECTIVE_UNKNOWN then
      SetObjectiveState('prim1', OBJECTIVE_ACTIVE);
    end
    
    if OBJECTIVES.state.rescueIsabell[2] == 1 and OBJECTIVES.state.protectDunmor[2] == 2 then
      CINEMATICS.GodrickLearnsIsabellPrisonLocation();
      OBJECTIVES.state.rescueIsabell[2] = 2;
    end

    if OBJECTIVES.state.rescueIsabell[2] == 3 then
      CINEMATICS.rescueIsabell();
  	  sleep(1);
      GiveExp( 'Godric', 2000 );
      LoadHeroAllSetArtifacts( "Isabell", "C1M4" );
      SetRegionBlocked( 'AIblock', nil, PLAYER_2 );
      Trigger( OBJECT_TOUCH_TRIGGER, "Prison", nil );
      H55_CamFixTooManySkills( PLAYER_1, "Isabell" );
      OBJECTIVES.state.rescueIsabell[2] = 4;
    end
    
    if OBJECTIVES.state.rescueIsabell[2] < 4 and GetDate(DAY) == 8 then
      SetObjectiveState( 'prim1', OBJECTIVE_FAILED );
      OBJECTIVES.state.rescueIsabell[2] = 11;
    end

    if OBJECTIVES.state.rescueIsabell[2] == 4 and OBJECTIVES.state.protectDunmor[2] == 2 then
      SetObjectiveState( "prim1", OBJECTIVE_COMPLETED );
      OBJECTIVES.state.rescueIsabell[2] = 10;
    end
  end,

  _CountEnemyDefeats = function( looser, winner )
    enemy_defeats[looser] = enemy_defeats[looser] + 1;
  end,
  
  protectDunmor = function()
    if GetObjectiveState('prim2') == OBJECTIVE_UNKNOWN then
      SetObjectiveState('prim2', OBJECTIVE_ACTIVE);
      nAssaultDay = 999;
    end
    local owner = GetObjectOwner( "Dummar" )
    if owner == PLAYER_2 then
      SetObjectiveState( "prim2", OBJECTIVE_FAILED );
      OBJECTIVES.state.protectDunmor[2] = 11;
    end
    if OBJECTIVES.state.protectDunmor[2] == 1 and owner == PLAYER_1 then
      OBJECTIVES.state.protectDunmor[2] = 2;
    end
    
    if OBJECTIVES.state.protectDunmor[2] == 2 and OBJECTIVES.state.rescueIsabell[2] == 10 then
      DeployReserveHero( 'Agrael', 120, 55, 0 );
      sleep( 2 );
      ADD_ASSAULT_HERO('Agrael');
  	  GiveArtefact( 'Agrael', ARTIFACT_SHACKLES_OF_WAR );
      SetHeroLootable( 'Agrael', nil );
  	  sleep( 1 );
  	  if __difficulty <= DIFFICULTY_NORMAL then
  	 	  RemoveHeroCreatures( 'Agrael',        CREATURE_DEVIL,  5 );
 		    RemoveHeroCreatures( 'Agrael', CREATURE_HORNED_DEMON, 20 );
  	  end
      OBJECTIVES.state.protectDunmor[2] = 3;
  	end
  	
    if OBJECTIVES.state.protectDunmor[2] == 3 and enemy_defeats["Agrael"] == 1 then
      CINEMATICS.defeatAgrael();
		  nAssaultDay = GetDate() + ASSAULT_DELAY;
		  OBJECTIVES.state.protectDunmor[2] = 4;
    end

    if OBJECTIVES.state.protectDunmor[2] == 4 and GetDate() == nAssaultDay then
	    nAssaultCount = nAssaultCount + 1;
			nAssaultDay = nAssaultDay + ASSAULT_DELAY + (4 - crap);
			DeployAssaultHero( nAssaultCount );
			print("nAssaultCount = ".. nAssaultCount);
			print("nAssaultDay = ".. nAssaultDay);
			if nAssaultCount == 3 then
        OBJECTIVES.state.protectDunmor[2] = 5;
      end
		end
		
	  if OBJECTIVES.state.protectDunmor[2] == 5 then
      DeployReserveHero( "Agrael", 132, 40, GROUND );
      sleep( 1 );
	    EnableHeroAI( "Agrael", nil );
	    sleep( 1 );
	    mult = GetDate(MONTH);
     	AddHeroCreatures( "Agrael",        CREATURE_HELL_HOUND,  600*mult );
	    AddHeroCreatures( "Agrael",      CREATURE_HORNED_DEMON, 1000*mult );
	    AddHeroCreatures( "Agrael",         CREATURE_ARCHDEVIL,   50*mult );
 	    AddHeroCreatures( "Agrael",             CREATURE_BALOR,  120*mult );
	    AddHeroCreatures( "Agrael", CREATURE_INFERNAL_SUCCUBUS,  200*mult );
	    OBJECTIVES.state.protectDunmor[2] = 6;
    end
    
    if OBJECTIVES.state.joinNikolai[2] == 3 then
      SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
      OBJECTIVES.state.protectDunmor[2] = 10;
    end
  end,
  
  buildGrail = function()
    if GetObjectiveState('prim3') == OBJECTIVE_UNKNOWN and (enemy_defeats["Nymus"] > 0 or enemy_defeats["Jazaz"] > 0 or enemy_defeats["Efion"] > 0 ) then
      CINEMATICS.searchForGrail();
      SetObjectiveState('prim3', OBJECTIVE_ACTIVE);
    end
    
    if GetTownBuildingLevel( "Dummar", TOWN_BUILDING_GRAIL ) == 1 then
      CINEMATICS.grailConstructed();
  		GiveExp( 'Isabell', 10000 );
  		if IsObjectExists( 'Godric') then
 			  sleep( 1 );
	  	  GiveExp( 'Godric', 2000 );
	    end
      if( __difficulty <= DIFFICULTY_NORMAL ) and OBJECTIVES.state.protectDunmor[2] < 5 then
        OBJECTIVES.state.protectDunmor[2] = 5;
  	  end
	   	SetObjectiveState( "prim3", OBJECTIVE_COMPLETED );
	   	OBJECTIVES.state.buildGrail[2] = 10;
    end
    
    if OBJECTIVES.state.buildGrail[2] == 1 and IsAnyHeroPlayerHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) == 1 then
      OBJECTIVES.state.buildGrail[2] = 2;
	 	end
    
    if OBJECTIVES.state.buildGrail[2] == 2 and IsAnyHeroPlayerHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) == nil then
	  	MessageBox( "/Maps/Scenario/C1M5/GrailLost.txt" );
	 		SetObjectiveState( "prim3", OBJECTIVE_FAILED );
	 		OBJECTIVES.state.buildGrail[2] = 1;
	 	end
  end,

  _IsGodricAtExit = function( hero )
    if hero == 'Godric' then
      OBJECTIVES.state.sendGodric[2] = 3;
    end
  end,
  
  sendGodric = function()
    if GetObjectiveState('prim4') == OBJECTIVE_UNKNOWN and OBJECTIVES.state.buildGrail[2] == 10 then
      CINEMATICS.sendGodricOnMission();
      SetObjectiveState('prim4', OBJECTIVE_ACTIVE);
      Trigger( REGION_ENTER_AND_STOP_TRIGGER, "exit", "OBJECTIVES._IsGodricAtExit" );
  		local balors     = (2 - crap) * 6;
  		local nightmares = (2 - crap) * 8;
  		local succubus   = (2 - crap) * 12;
  		if balors > 0 then
  	    RemoveObjectCreatures( 'garrison',            CREATURE_BALOR,    balors );
  		end
    	if nightmares > 0 then
    	  RemoveObjectCreatures( 'garrison',        CREATURE_NIGHTMARE, nightmares );
    	end
    	if succubus > 0 then
    		RemoveObjectCreatures( 'garrison', CREATURE_INFERNAL_SUCCUBUS,  succubus );
    	end
    	OBJECTIVES.state.sendGodric[2] = 2;
    end
    
    if OBJECTIVES.state.sendGodric[2] == 3 then
	    SaveHeroAllSetArtifactsEquipped("Godric", "C1M5");
	    MoveHeroRealTime( "Godric", 134, 11, 0 );
	    local n = 0;
	    while GetObjectPos( "Godric" ) ~= 134 do
	   	  n = n + 1;
		    sleep( 1 );
		    if (n > 30 ) then
			    break
		    end
	    end
	    RemoveObject("Godric");
	    sleep( 2 );
	    CINEMATICS.godricLeaves();
      Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "exit", nil );
	    SetObjectiveState( "prim4", OBJECTIVE_COMPLETED );
	    OBJECTIVES.state.sendGodric[2] = 10;
    end
  end,
  
  isAlive = function()
  -- start of this task is handled by C1M5.xdb
    if ( not IsHeroAlive('Godric') and OBJECTIVES.state.sendGodric[2] < 3) or (not IsHeroAlive('Isabell') and OBJECTIVES.state.rescueIsabell[2] >= 3) then
	    SetObjectiveState( 'prim6', OBJECTIVE_FAILED );
    end
  end,

  joinNikolai = function()
    if OBJECTIVES.state.joinNikolai[2] == 1 and OBJECTIVES.state.sendGodric[2] == 10 then
      scene_time = GetDate(ABSOLUTE_DAY) + 1;
      OBJECTIVES.state.joinNikolai[2] = 2;
    elseif OBJECTIVES.state.joinNikolai[2] == 2 and scene_time == GetDate(ABSOLUTE_DAY) then
      DeployReserveHero( 'Nicolai', 133, 12, 0 );
      scene_time = GetDate(ABSOLUTE_DAY) + 1;
      OBJECTIVES.state.joinNikolai[2] = 3;
    elseif OBJECTIVES.state.joinNikolai[2] == 3 and scene_time == GetDate(ABSOLUTE_DAY) then
      CINEMATICS.isabellJoinNikolai()
		  SetObjectiveState( 'prim5', OBJECTIVE_ACTIVE );
		  EnableHeroAI( 'Nicolai', not nil );
	  	if CanMoveHero('Nicolai', 121, 32, 0) then
			  MoveHero( 'Nicolai', 121, 32, 0 );
		  end
		  scene_time = GetDate(ABSOLUTE_DAY) + 1;
		  OBJECTIVES.state.joinNikolai[2] = 4;
   elseif OBJECTIVES.state.joinNikolai[2] == 4 and scene_time == GetDate(ABSOLUTE_DAY) then
		  if IsObjectExists('Agrael') then
			  EnableHeroAI( 'Agrael', not nil );
			  if CanMoveHero('Agrael', 120, 34, 0) then
				  MoveHero( 'Agrael', 120, 34, 0 );
			  end
      end
			sleep( 10 );
      SetObjectiveState( "prim5", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.joinNikolai[2] = 10;
   end
 end,
}
------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( AI_main );

------------------ DEBUG ------------------------
function debug_c1m5(state)

  _fog();
  if state >= 1 then
    AddHeroCreatures( "Godric", CREATURE_INFERNAL_SUCCUBUS,  200 );
    AddHeroCreatures( "Godric", CREATURE_INFERNAL_SUCCUBUS,  200 );
    SetObjectPosition("Godric", 26, 103, 0)
  end
  
  if state >= 2 then
     SetObjectPosition("Agrael", 35, 100, 0)
  end
end