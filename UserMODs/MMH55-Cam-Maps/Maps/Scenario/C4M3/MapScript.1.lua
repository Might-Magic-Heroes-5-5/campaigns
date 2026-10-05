doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");
doFile("/Maps/Scenario/C4M3/RedPlayerTroops.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight or not C4M3_AddTroops3 do
    sleep()
end

H55_PlayerStatus = {0,1,1,2,2,2,2,2};

H55c_AI_CONTROLLED = {
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

DIFFICULTY = {
	[0] = function()
		print("normal");
		dif = 0;
		SetPlayerStartResources( PLAYER_2, 0, 0, 0, 0, 0, 0, 0 );
		SetPlayerStartResources( PLAYER_3, 0, 0, 0, 0, 0, 0, 0 );
		AddObjectCreatures("Raelag", CREATURE_ASSASSIN , 50);
		AddObjectCreatures("Raelag", CREATURE_BLOOD_WITCH , 30);
		AddObjectCreatures("Raelag", CREATURE_MATRIARCH , 5);
	end,

	[1] = function()
		print("hard");
		dif = 0;
		SetPlayerStartResources( PLAYER_2, 0, 0, 0, 0, 0, 0, 0 );
		SetPlayerStartResources( PLAYER_3, 0, 0, 0, 0, 0, 0, 0 );
	end,

	[2] = function()
		print("heroic");
		dif = 1;
		SetTownBuildingLimitLevel('Town3', 13, 1);
	end,

	[3] = function()
		print("impossible");
		dif = 2;
		SetTownBuildingLimitLevel('Town3', 13, 1);
		SetTownBuildingLimitLevel('Town4', 13, 1);
	end
}

function H55_InitSetArtifacts()
  InitAllSetArtifacts("C4M3");
  LoadHeroAllSetArtifacts(  "Raelag", "C4M2" );
  LoadHeroAllSetArtifacts( "Kelodin", "C4M2" );
  sleep(40); -- wait for artifacts to load
  H55_CamFixTooManySkills( PLAYER_1,  "Raelag" );
  H55_CamFixTooManySkills( PLAYER_1, "Kelodin" );
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

blue_player_heroes = {"Almegir", "Eruina", "Menel", "Inagost", "Urunir", "Segref"}; -- Yrbeth, Eruina, Kythra, Sinitar, Yrwanna, Segref
function C4M3_ApplyExtraDifficultyBonuses()
	local koef = GetDifficulty() + 1;
	if koef > 1 then
		for i, hero in blue_player_heroes do
		  ChangeHeroStat(hero, STAT_EXPERIENCE, 143000); -- from 25 to 28
		  ChangeHeroStat(hero, STAT_ATTACK, GetDifficulty() * 5);
		  ChangeHeroStat(hero, STAT_DEFENCE, GetDifficulty() * 5);
		  ChangeHeroStat(hero, STAT_SPELL_POWER, GetDifficulty() * 5);
		  ChangeHeroStat(hero, STAT_KNOWLEDGE, GetDifficulty() * 5);	  
		end
		-- Sorfail
		UpgradeTownBuilding("Town2", TOWN_BUILDING_GRAIL, 1);
		-- Garrison
		AddObjectCreatures("dark_garrison",	CREATURE_ASSASSIN, 250 * GetDifficulty());
		AddObjectCreatures("dark_garrison",	CREATURE_BLOOD_WITCH, 150 * GetDifficulty());
		AddObjectCreatures("dark_garrison",	CREATURE_MINOTAUR_KING, 100 * GetDifficulty());
		AddObjectCreatures("dark_garrison",	CREATURE_BLACK_RIDER, 60 * GetDifficulty());
		AddObjectCreatures("dark_garrison",	CREATURE_ACIDIC_HYDRA, 40 * GetDifficulty());
		AddObjectCreatures("dark_garrison",	CREATURE_MATRIARCH, 30 * GetDifficulty());
		AddObjectCreatures("dark_garrison",	CREATURE_BLACK_DRAGON, 10 * GetDifficulty());   
		-- Lethos
		GiveExp("Dalom", 354000); -- from 30 to 33 
		ChangeHeroStat("Dalom", STAT_ATTACK, GetDifficulty() * 5);
		ChangeHeroStat("Dalom", STAT_DEFENCE, GetDifficulty() * 5);
		ChangeHeroStat("Dalom", STAT_SPELL_POWER, GetDifficulty() * 5);
		ChangeHeroStat("Dalom", STAT_KNOWLEDGE, GetDifficulty() * 5);

		AddHeroCreatures("Dalom",	CREATURE_ASSASSIN, 400 * GetDifficulty());
		AddHeroCreatures("Dalom",	CREATURE_BLOOD_WITCH, 280 * GetDifficulty());
		AddHeroCreatures("Dalom",	CREATURE_MINOTAUR_KING, 200 * GetDifficulty());
		AddHeroCreatures("Dalom",	CREATURE_BLACK_RIDER, 120 * GetDifficulty());
		AddHeroCreatures("Dalom",	CREATURE_ACIDIC_HYDRA, 80 * GetDifficulty());
		AddHeroCreatures("Dalom",	CREATURE_MATRIARCH, 60 * GetDifficulty());
		AddHeroCreatures("Dalom",	CREATURE_BLACK_DRAGON, 25 * GetDifficulty());  	
		
		GiveHeroSkill("Dalom", PERK_EMPOWERED_SPELLS);
		GiveHeroSkill("Dalom", PERK_ELEMENTAL_VISION);
		GiveHeroSkill("Dalom", HERO_SKILL_SET_AFIRE); -- ignite
		GiveHeroSkill("Dalom", NECROMANCER_FEAT_DEADLY_COLD); 
		GiveHeroSkill("Dalom", PERK_INTELLIGENCE);
		GiveHeroSkill("Dalom", NECROMANCER_FEAT_DEAD_LUCK);	
		GiveArtifact("Dalom", 61); -- boots +15% earth damage
		GiveArtifact("Dalom", 20); -- ring +40% lightning protection
		-- Segref
		GiveHeroSkill("Segref", SKILL_NECROMANCY);
		GiveHeroSkill("Segref", PERK_DEATH_SCREAM);
		GiveHeroSkill("Segref", HERO_SKILL_SHATTER_LIGHT_MAGIC);
		GiveHeroSkill("Segref", DEMON_FEAT_FIRE_PROTECTION); 
		GiveHeroSkill("Segref", HERO_SKILL_SHATTER_SUMMONING_MAGIC);
		GiveHeroSkill("Segref", HERO_SKILL_DEATH_TO_NONEXISTENT);	
		-- Sinitar
		GiveHeroSkill("Inagost", SKILL_LEARNING);
		GiveHeroSkill("Inagost", PERK_INTELLIGENCE);
		GiveHeroSkill("Inagost", SKILL_OFFENCE);
		GiveHeroSkill("Inagost", PERK_FRENZY); 
		GiveHeroSkill("Inagost", HERO_SKILL_SHATTER_DARK_MAGIC);
		GiveHeroSkill("Inagost", WIZARD_FEAT_MAGIC_CUSHION); -- protection - shatter dark magic
		-- Eruina
		GiveHeroSkill("Eruina", SKILL_OFFENCE);
		GiveHeroSkill("Eruina", SKILL_LEARNING);
		GiveHeroSkill("Eruina", SKILL_LIGHT_MAGIC);
		GiveHeroSkill("Eruina", PERK_MASTER_OF_ABJURATION); 
		GiveHeroSkill("Eruina", PERK_FRENZY);
		GiveHeroSkill("Eruina", PERK_SCHOLAR);	
		-- Yrbeth
		GiveHeroSkill("Almegir", SKILL_SORCERY);
		GiveHeroSkill("Almegir", RANGER_FEAT_INSIGHTS);
		GiveHeroSkill("Almegir", SKILL_INVOCATION);
		GiveHeroSkill("Almegir", PERK_ARCANE_TRAINING); 
		GiveHeroSkill("Almegir", SKILL_DEFENCE);
		GiveHeroSkill("Almegir", PERK_PROTECTION);	
		-- Yrwanna
		GiveHeroSkill("Urunir", SKILL_DARK_MAGIC);
		GiveHeroSkill("Urunir", PERK_MASTER_OF_CURSES);
		GiveHeroSkill("Urunir", SKILL_LEARNING);
		GiveHeroSkill("Urunir", PERK_INTELLIGENCE); 
		GiveHeroSkill("Urunir", SKILL_WAR_MACHINES);
		GiveHeroSkill("Urunir", PERK_BALLISTA);
		-- Kythra
		GiveHeroSkill("Menel", HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC);
		GiveHeroSkill("Menel", HERO_SKILL_CORRUPT_DESTRUCTIVE);
		GiveHeroSkill("Menel", SKILL_DEFENCE);
		GiveHeroSkill("Menel", PERK_PROTECTION); 
		GiveHeroSkill("Menel", SKILL_LEARNING);
		GiveHeroSkill("Menel", WIZARD_FEAT_COUNTERSPELL);		
	end	
	if koef > 2 then
		-- Yrbeth, Eruina, Kythra, Sinitar, Yrwanna, Segref
		for i, hero in blue_player_heroes do
		  ChangeHeroStat(hero, STAT_EXPERIENCE , 247000); -- from 28 to 31 
		  AddObjectCreatures(hero, CREATURE_ASSASSIN , 40 * GetDifficulty());
		  AddObjectCreatures(hero, CREATURE_BLOOD_WITCH , 20 * GetDifficulty());
		  AddObjectCreatures(hero, CREATURE_MINOTAUR_KING , 15 * GetDifficulty());	  
		end;
		-- Lethos	
		GiveExp("Dalom", 604000); -- from 33 to 36 
		GiveHeroSkill("Dalom", NECROMANCER_FEAT_CHILLING_STEEL);
		GiveHeroSkill("Dalom", NECROMANCER_FEAT_CHILLING_BONES);
		GiveHeroSkill("Dalom", PERK_MASTER_OF_MIND);
		GiveHeroSkill("Dalom", PERK_MASTER_OF_CURSES);
		GiveHeroSkill("Dalom", PERK_PROTECTION);
		GiveHeroSkill("Dalom", WARLOCK_FEAT_CHAOTIC_SPELLS);
		GiveArtifact("Dalom", 18); -- Necklace  +15% cold damage
		GiveArtifact("Dalom", 9); -- Shield  +40% fire protection
		GiveArtifact("Dalom", 5); -- Weapon + 15% lightning damage	
		-- Segref
		GiveHeroSkill("Segref", NECROMANCER_FEAT_CHILLING_STEEL);
		GiveHeroSkill("Segref", NECROMANCER_FEAT_CHILLING_BONES);
		GiveHeroSkill("Segref", PERK_CONSUME_CORPSE);
		GiveHeroSkill("Segref", DEMON_FEAT_EXPLODING_CORPSES); -- cult master 
		GiveHeroSkill("Segref", HERO_SKILL_DETAIN_SUMMONING);
		GiveHeroSkill("Segref", HERO_SKILL_DETAIN_LIGHT);	
		-- Sinitar
		GiveHeroSkill("Inagost", PERK_EAGLE_EYE);
		GiveHeroSkill("Inagost", HERO_SKILL_QUICKNESS_OF_MIND);
		GiveHeroSkill("Inagost", HERO_SKILL_DETAIN_DARK);
		GiveHeroSkill("Inagost", HERO_SKILL_WEAKEN_DARK); 
		GiveHeroSkill("Inagost", PERK_TOUGHNESS);
		GiveHeroSkill("Inagost", HERO_SKILL_DWARVEN_LUCK);
		-- Eruina
		GiveHeroSkill("Eruina", RANGER_FEAT_SUN_FIRE);
		GiveHeroSkill("Eruina", KNIGHT_FEAT_ANCIENT_SMITHY);
		GiveHeroSkill("Eruina", RANGER_FEAT_LAST_STAND);
		GiveHeroSkill("Eruina", NECROMANCER_FEAT_TWILIGHT); 
		GiveHeroSkill("Eruina", KNIGHT_FEAT_RETRIBUTION);
		GiveHeroSkill("Eruina", PERK_ARCANE_TRAINING);	
		-- Yrbeth
		GiveHeroSkill("Almegir", NECROMANCER_FEAT_SPIRIT_LINK);
		GiveHeroSkill("Almegir", DEMON_FEAT_WEAKENING_STRIKE); -- blood ritual
		GiveHeroSkill("Almegir", PERK_EVASION);
		GiveHeroSkill("Almegir", DEMON_FEAT_EXPLODING_CORPSES); -- cult master
		GiveHeroSkill("Almegir", PERK_EMPOWERED_SPELLS);
		GiveHeroSkill("Almegir", PERK_TOUGHNESS);
		-- Yrwanna
		GiveHeroSkill("Urunir", PERK_MASTER_OF_SICKNESS);
		GiveHeroSkill("Urunir", PERK_MASTER_OF_MIND);
		GiveHeroSkill("Urunir", KNIGHT_FEAT_TRIPLE_BALLISTA);
		GiveHeroSkill("Urunir", WIZARD_FEAT_WILDFIRE); 
		GiveHeroSkill("Urunir", KNIGHT_FEAT_STUDENT_AWARD);
		GiveHeroSkill("Urunir", HERO_SKILL_QUICKNESS_OF_MIND);
		-- Kythra
		GiveHeroSkill("Menel", HERO_SKILL_DETAIN_DESTRUCTIVE);
		GiveHeroSkill("Menel", HERO_SKILL_WEAKEN_DESTRUCTIVE);
		GiveHeroSkill("Menel", PERK_MASTER_OF_BLESSING);
		GiveHeroSkill("Menel", RANGER_FEAT_LAST_STAND); 
		GiveHeroSkill("Menel", PERK_EVASION);
		GiveHeroSkill("Menel", PERK_TOUGHNESS);	
		end
	if koef > 3 then
		-- Yrbeth, Eruina, Kythra, Sinitar, Yrwanna, Segref
		for i, hero in blue_player_heroes do
		  ChangeHeroStat(hero, STAT_EXPERIENCE , 420000); -- from 31 to 34
		end;
		-- Lethos
		GiveExp("Dalom", 1550000); -- from 36 to 40 
		GiveHeroSkill("Dalom", HERO_SKILL_DISTRACT);
		GiveHeroSkill("Dalom", PERK_ARCANE_TRAINING);
		GiveHeroSkill("Dalom", HERO_SKILL_QUICKNESS_OF_MIND);
		GiveHeroSkill("Dalom", RANGER_FEAT_SOIL_BURN);
		GiveHeroSkill("Dalom", NECROMANCER_FEAT_SPELLPROOF_BONES); -- forge master
		GiveHeroSkill("Dalom", KNIGHT_FEAT_STUDENT_AWARD);	
		GiveArtifact("Dalom", 23); -- ring -2 morale
		GiveArtifact("Dalom", 11); -- helm +2 morale	
		GiveArtifact("Dalom", 62); -- cloak +40% earth protection
		GiveArtifact("Dalom", 25); -- pocket  +3 luck	
		-- Segref
		GiveHeroSkill("Segref", HERO_SKILL_DEFENSIVE_FORMATION);
		GiveHeroSkill("Segref", HERO_SKILL_OFFENSIVE_FORMATION);
		GiveHeroSkill("Segref", KNIGHT_FEAT_PARIAH);
		GiveHeroSkill("Segref", NECROMANCER_FEAT_SPIRIT_LINK);  
		GiveHeroSkill("Segref", WARLOCK_FEAT_POWER_OF_HASTE);
		GiveHeroSkill("Segref", HERO_SKILL_SHRUG_DARKNESS);
		-- Sinitar
		GiveHeroSkill("Inagost", NECROMANCER_FEAT_DEADLY_COLD);
		GiveHeroSkill("Inagost", NECROMANCER_FEAT_DEAD_LUCK);
		GiveHeroSkill("Inagost", WARLOCK_FEAT_ELITE_CASTERS);
		GiveHeroSkill("Inagost", RANGER_FEAT_ELVEN_LUCK); 
		GiveHeroSkill("Inagost", HERO_SKILL_DISTRACT);
		GiveHeroSkill("Inagost", WARLOCK_FEAT_POWER_OF_HASTE);	
		-- Eruina
		GiveHeroSkill("Eruina", HERO_SKILL_WEAKEN_DESTRUCTIVE);
		GiveHeroSkill("Eruina", HERO_SKILL_DETAIN_DESTRUCTIVE);
		GiveHeroSkill("Eruina", WIZARD_FEAT_COUNTERSPELL);
		GiveHeroSkill("Eruina", PERK_INTELLIGENCE); 
		GiveHeroSkill("Eruina", HERO_SKILL_DWARVEN_LUCK);
		GiveHeroSkill("Eruina", KNIGHT_FEAT_GUARDIAN_ANGEL);
		-- Yrbeth
		GiveHeroSkill("Almegir", HERO_SKILL_DISTRACT);
		GiveHeroSkill("Almegir", PERK_ELEMENTAL_VISION);
		GiveHeroSkill("Almegir", NECROMANCER_FEAT_SPELLPROOF_BONES); -- forge master 
		GiveHeroSkill("Almegir", RANGER_FEAT_ELVEN_LUCK); 
		GiveHeroSkill("Almegir", RANGER_FEAT_SOIL_BURN);
		GiveHeroSkill("Almegir", WARLOCK_FEAT_ELITE_CASTERS);
		-- Yrwanna
		GiveHeroSkill("Urunir", RANGER_FEAT_SOIL_BURN);
		GiveHeroSkill("Urunir", DEMON_FEAT_WEAKENING_STRIKE);
		GiveHeroSkill("Urunir", NECROMANCER_FEAT_SPELLPROOF_BONES);
		GiveHeroSkill("Urunir", NECROMANCER_FEAT_DEAD_LUCK); 
		GiveHeroSkill("Urunir", WARLOCK_FEAT_FAST_AND_FURIOUS);
		GiveHeroSkill("Urunir", HERO_SKILL_EMPATHY);
		-- Kythra
		GiveHeroSkill("Menel", KNIGHT_FEAT_RETRIBUTION);
		GiveHeroSkill("Menel", NECROMANCER_FEAT_SPELLPROOF_BONES);
		GiveHeroSkill("Menel", HERO_SKILL_QUICKNESS_OF_MIND);
		GiveHeroSkill("Menel", HERO_SKILL_EMPATHY); 
		GiveHeroSkill("Menel", PERK_INTELLIGENCE);
		GiveHeroSkill("Menel", HERO_SKILL_RUNIC_MACHINES);		
	end
end

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
	dif = 0;
    SetRegionBlocked("MainTownEntry", not nil, PLAYER_2);
	EnableHeroAI("Dalom",nil);
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
	DIFFICULTY[GetDifficulty()]();
	C4M3_ApplyExtraDifficultyBonuses();
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
      
			if GetObjectiveState( 'Survival') == OBJECTIVE_FAILED then
				Loose();
				return
			end
    
			if GetObjectiveState( 'prim1') == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped(  "Raelag", "C4M3" );
				--SaveHeroAllSetArtifactsEquipped( "Kelodin", "C4M3" );
				sleep(40);
				Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, nil);
				Save("quicksave");
				CINEMATICS.outro();
				sleep(30);
				Win();
				return
			end
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
    H55c_AIAddHero(army.hero)
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
startThread( H55c_AI_main );

------------------ DEBUG ------------------------
-- changes ownership of num amount of towns to the human player
function gain(num)
  for i = 1, num do
    SetObjectOwner("Town"..i, PLAYER_1);
  end
end
