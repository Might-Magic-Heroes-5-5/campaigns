-- Initialize MMH55 specific config
H55_PlayerStatus = {0,1,1,2,2,2,2,2};
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");
doFile("/Maps/Scenario/C4M3/difficulty.lua");
doFile("/Maps/Scenario/C4M3/RedPlayerTroops.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not _AI_UpdateTargetWeight do
    sleep()
end

AI_CONTROLLED = {
  player1 = {
    state = 0,         -- 0 human player
    heroes = {},
    enemies = {},
  },
  player2 = {          -- Blue Dungeon AI player;
    state = 1,         -- AI player without specific purpose so control set to 1 (Unmanaged)
    heroes = {},
    enemies = {}
  },
  player3 = {          -- Red Inferno AI player
    state = 2,         -- AI player with specific purpose so control set to 2
    heroes = {},
    enemies = {
      { priority = 1.0, heroes = 1.0, towns = 1.5, is_enemy = 1 },  -- PLAYER1
      { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
      { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 }   -- PLAYER3
    }
  }
}

function H55_InitSetArtifacts()
  InitAllSetArtifacts("C4M3");
  LoadHeroAllSetArtifacts("Raelag", "C4M2" );
end

startThread(H55_InitSetArtifacts);

CINEMATICS = {
  intro = function()
    StartDialogScene("/DialogScenes/C4/M3/D1/DialogScene.xdb#xpointer(/DialogScene)");
    sleep( 2 );
  end,
  
  launchEnvasion = function()
    StartDialogScene("/DialogScenes/C4/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
    sleep( 2 );
  end,
  
  defeatEnvasion = function()
    StartDialogScene("/DialogScenes/C4/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
    sleep( 2 );
  end,
  
  outro = function()
    StartDialogScene("/DialogScenes/C4/M3/D2/DialogScene.xdb#xpointer(/DialogScene)");
    sleep( 2 );
  end,
  
  showHero = function()
    local x, y, z = RegionToPoint('EnemyHere');
    OpenCircleFog(x, y, z, 3, PLAYER_1);
    MoveCamera(x+1, y-1, z, 50, 1.57);
    sleep( 2 );
  end,
}

OBJECTIVES = {
  state = { -- 0 quest is not active or managed by map.xdb, 1 quest is active, 2-9 custom states, 10 success, 11 fail
    capturedTowns = {    "prim1", 1 },      -- primary: 1 quest active, 10 all seven towns captured
    Survival      = { "Survival", 1 },      -- primary: if Raleag or Kelodin die mission fails
    Envasion      = { "Envasion", 1 },      -- secondary: 2 quest active & launch wave 1, 3 launch wave 2, 4 launch wave 3, 9-10 player defeated all three waves
  },

  start = function()
    OBJECTIVES.prepare();
    OBJECTIVES.run();
  end,

  prepare = function()
    lists = {
      towns = GetObjectNamesByType("TOWN"),
      heroes = GetObjectNamesByType("HERO"),
    }

    envasion_army = {
      { hero = "Calid", troops = C4M3_AddTroops1 },
      { hero = "Deleb", troops = C4M3_AddTroops2 },
      { hero = "Efion", troops = C4M3_AddTroops3 }
     }
  
    deafeated_waves = 0;
    dang_array = {"Dalom", "Almegir", "Eruina", "Menel", "Inagost", "Ferigl", "Segref"};
    dif = SetMissionDifficulty();

    H55_CamFixTooManySkills(PLAYER_1, "Raelag");
    H55_CamFixTooManySkills(PLAYER_1, "Kelodin");
    CINEMATICS.intro();
  end,

  run = function()
     while true do
      for key, value in OBJECTIVES.state do
        if value[2] > 0 and value[2] < 10 then
          OBJECTIVES[key]();
        end
      end
      
      if GetObjectiveState( 'Survival') == OBJECTIVE_FAILED then
        Loose();
        return
      end
    
      if GetObjectiveState( 'prim1') == OBJECTIVE_COMPLETED then
        SaveHeroAllSetArtifactsEquipped("Raelag", "C4M3");
        Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, nil);
        Save("quicksave");
        CINEMATICS.outro();
        Win();
        return
      end
      sleep(10);
    end
  end,
  
  _CountOwnedTowns = function (towns, player)
    local cnt = 0;

    for _, town in towns do
      if GetObjectOwner(town) == player then
        cnt = cnt + 1;
      end
    end
    return cnt;
  end,

  capturedTowns = function()
    local owned_towns = OBJECTIVES._CountOwnedTowns(lists.towns, 1);
    if owned_towns >= 7 then
      SetObjectiveState( "prim1", OBJECTIVE_COMPLETED );
      OBJECTIVES.state.capturedTowns[2] = 10;
    end
  end,
  
  _EnvasionDefeated = function(hero)
    if hero == 'Calid' or hero == 'Deleb' or hero == 'Efion' then
      deafeated_waves = deafeated_waves + 1;
      if deafeated_waves == 3 then
        OBJECTIVES.state.Envasion[2] = 9
      end
    end
  end,
  
  _EnvasionLaunch = function(wave)
    local army = envasion_army[wave];
    DeployReserveHero(army.hero, RegionToPoint('EnemyHere'));
    sleep(5);
    army.troops();
    sleep(2);
    print("## Launch wave " .. wave .. ": " .. army.hero);
    CINEMATICS.showHero()
    ADD_ASSAULT_HERO(army.hero)
  end,
  
  Envasion = function()
    owned_towns = OBJECTIVES._CountOwnedTowns(lists.towns, 1);
    if GetObjectiveState('Envasion') == OBJECTIVE_UNKNOWN and owned_towns >= 2 then
      CINEMATICS.launchEnvasion();
      Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, 'OBJECTIVES._EnvasionDefeated');
      SetObjectiveState("Envasion", OBJECTIVE_ACTIVE);
      OBJECTIVES._EnvasionLaunch(1);
      OBJECTIVES.state.Envasion[2] = 2;
    end
  
    if OBJECTIVES.state.Envasion[2] == 2 and owned_towns >= 4 then
      OBJECTIVES._EnvasionLaunch(2);
      OBJECTIVES.state.Envasion[2] = 3;
    end
  
    if OBJECTIVES.state.Envasion[2] == 3 and owned_towns >= 6 then
      OBJECTIVES._EnvasionLaunch(3);
      OBJECTIVES.state.Envasion[2] = 4;
    end
  
    if OBJECTIVES.state.Envasion[2] == 9 then
      CINEMATICS.defeatEnvasion();
      SetObjectiveState("Envasion", OBJECTIVE_COMPLETED);
      sleep(5);
      LevelUpHero("Raelag");
      OBJECTIVES.state.Envasion[2] = 10;
    end
  end,
  
  Survival = function()
    -- start of this task is handled by C4M3.xdb
    if not IsHeroAlive('Raelag') or not IsHeroAlive('Kelodin') then
      SetObjectiveState( 'Survival', OBJECTIVE_FAILED );
    end
  end
}
------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( AI_main );

------------------ DEBUG ------------------------
-- changes ownership of num amount of towns to the human player
function gain(num)
  for i = 1, num do
    SetObjectOwner("Town"..i, PLAYER_1);
  end
end
