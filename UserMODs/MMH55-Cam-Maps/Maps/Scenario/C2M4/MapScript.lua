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
  player2 = {		   -- Green Sylvan AI player
      state = 2,	   -- AI player with specific purpose so control set to 2
	   heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = 0.8, towns = 1.0, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
    }
  },
  player3 = { 		   -- Orange Inferno AI player
      state = 2,       -- AI player with specific purpose so control set to 2
	   heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
    }
  }
}

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C2M4");
    LoadHeroAllSetArtifacts("Agrael", "C2M3" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1, "Agrael" );
end

startThread(H55_InitSetArtifacts);

CreatureList = {CREATURE_PIXIE,
				CREATURE_SPRITE,
				CREATURE_DRYAD,
				CREATURE_BLADE_JUGGLER,
				CREATURE_WAR_DANCER,
				CREATURE_BLADE_SINGER,
				CREATURE_WOOD_ELF,
				CREATURE_GRAND_ELF,
				CREATURE_SHARP_SHOOTER,
				CREATURE_DRUID,
				CREATURE_DRUID_ELDER,
				CREATURE_HIGH_DRUID,
				CREATURE_UNICORN,
				CREATURE_WAR_UNICORN,
				CREATURE_WHITE_UNICORN,
				CREATURE_TREANT,
				CREATURE_TREANT_GUARDIAN,
				CREATURE_ANGER_TREANT,
				CREATURE_GREEN_DRAGON,
				CREATURE_GOLD_DRAGON,
				CREATURE_RAINBOW_DRAGON,
				};
CreatureList.n = 21;

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C2/M4/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	captureInfernoTownStart = function()
		StartDialogScene("/DialogScenes/C2/M4/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	captureInfernoTownFinish = function()
		StartDialogScene("/DialogScenes/C2/M4/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	dragonsStarted = function()
		StartDialogScene("/DialogScenes/C2/M4/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	dragonsFight = function()
		StartDialogScene("/DialogScenes/C2/M4/R5/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	dragonsNoElves = function()
		StartDialogScene("/DialogScenes/C2/M4/R6/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	dragonsFinish500 = function()
		StartDialogScene("/DialogScenes/C2/M4/R7/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	dragonsFinish100 = function()
		StartDialogScene("/DialogScenes/C2/M4/R4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/C2/M4/R8/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

DIFFICULTY = {
	[0] = function()
		diff = 1;
		SetEnemyHeroesArmy(1);
        SetPlayerStartResources(PLAYER_2, 10, 10, 2, 2, 2, 2, 20000);	
        SetPlayerStartResources(PLAYER_3, 10, 10, 2, 2, 2, 2, 20000);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding("aglan", TOWN_BUILDING_FORT, 1);				
        UpgradeTownBuilding("aglan", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_3, 1);	
        UpgradeTownBuilding("aglan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);			
        UpgradeTownBuilding("aglan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);		
	end,
	
	[1] = function()
		diff = 2;
		SetEnemyHeroesArmy(2);
		SetPlayerStartResources(PLAYER_2, 15, 15, 5, 5, 5, 5, 30000);
		SetPlayerStartResources(PLAYER_3, 15, 15, 5, 5, 5, 5, 30000);		
        UpgradeTownBuilding("imarium", TOWN_BUILDING_GRAIL, 1);		
        UpgradeTownBuilding("holin", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding("holin", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding("holin", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("holin", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("holin", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);		
        UpgradeTownBuilding("giladan", TOWN_BUILDING_FORT, 1);				
        UpgradeTownBuilding("giladan", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding("giladan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("giladan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("giladan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);			
        UpgradeTownBuilding("aglan", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding("aglan", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding("aglan", TOWN_BUILDING_FORT, 1);		
        UpgradeTownBuilding("aglan", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_2, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_3, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_3, 1);	
        UpgradeTownBuilding("aglan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);		
        UpgradeTownBuilding("aglan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);		
        UpgradeTownBuilding("aglan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1); -- SPARKLING_FONTAINS
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_MARKETPLACE, 1);
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_TOWN_HALL, 1);
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_INFERNO_INFERNAL_LOOM, 1);			
	end,
	
	[2] = function()
		diff = 3;
		SetEnemyHeroesArmy(3);
		SetPlayerStartResources(PLAYER_2, 20, 20, 7, 7, 7, 7, 40000);
		SetPlayerStartResources(PLAYER_3, 20, 20, 7, 7, 7, 7, 40000);		
        UpgradeTownBuilding("imarium", TOWN_BUILDING_GRAIL, 1);		
        UpgradeTownBuilding("holin", TOWN_BUILDING_FORT, 1);	
        UpgradeTownBuilding("holin", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding("holin", TOWN_BUILDING_BLACKSMITH, 1);	
        UpgradeTownBuilding("holin", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("holin", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("holin", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding("holin", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding("holin", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);
        UpgradeTownBuilding("holin", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);	
        UpgradeTownBuilding("holin", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);		
        UpgradeTownBuilding("giladan", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding("giladan", TOWN_BUILDING_FORT, 1);		
        UpgradeTownBuilding("giladan", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding("giladan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("giladan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("giladan", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding("giladan", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding("giladan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);
        UpgradeTownBuilding("giladan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);	
        UpgradeTownBuilding("giladan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);			
        UpgradeTownBuilding("aglan", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding("aglan", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding("aglan", TOWN_BUILDING_FORT, 1);		
        UpgradeTownBuilding("aglan", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_2, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_3, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_DWELLING_3, 1);	
        UpgradeTownBuilding("aglan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);
        UpgradeTownBuilding("aglan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);	
        UpgradeTownBuilding("aglan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);		
        UpgradeTownBuilding("aglan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1); -- SPARKLING_FONTAINS
		UpgradeTownBuilding("nebircias", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_FORT, 1);		
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_MARKETPLACE, 1);
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_TOWN_HALL, 1);
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_INFERNO_INFERNAL_LOOM, 1);		
        UpgradeTownBuilding("nebircias", TOWN_BUILDING_INFERNO_SACRIFICIAL_PIT, 1);		
	end,
	
	[3] = function()
		diff = 4;
		SetEnemyHeroesArmy(4);
		SetPlayerStartResources(PLAYER_2, 25, 25, 10, 10, 10, 10, 50000);
		SetPlayerStartResources(PLAYER_3, 25, 25, 10, 10, 10, 10, 50000);		
        UpgradeTownBuilding( "imarium", TOWN_BUILDING_GRAIL, 1);		
        UpgradeTownBuilding( "holin", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding( "holin", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding( "holin", TOWN_BUILDING_FORT, 1);		
        UpgradeTownBuilding( "holin", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding( "holin", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding( "holin", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding( "holin", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding( "holin", TOWN_BUILDING_DWELLING_2, 1);
        UpgradeTownBuilding( "holin", TOWN_BUILDING_DWELLING_3, 1);
        UpgradeTownBuilding( "holin", TOWN_BUILDING_DWELLING_3, 1);
        UpgradeTownBuilding( "holin", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);
        UpgradeTownBuilding( "holin", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);		
        UpgradeTownBuilding( "holin", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);		
        UpgradeTownBuilding( "holin", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1); -- SPARKLING_FONTAINS		
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_FORT, 1);		
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_DWELLING_2, 1);
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_DWELLING_3, 1);
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_DWELLING_3, 1);	
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);	
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);		
        UpgradeTownBuilding( "giladan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);	 -- SPARKLING_FONTAINS			
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_FORT, 1);	
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_DWELLING_2, 1);
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_DWELLING_3, 1);
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_DWELLING_3, 1);
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_PRESERVE_AVENGERS_BROTHERHOOD, 1);		
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1);		
        UpgradeTownBuilding( "aglan", TOWN_BUILDING_PRESERVE_MYSTIC_POND, 1); -- SPARKLING_FONTAINS		
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_FORT, 1);			
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_FORT, 1);		
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_BLACKSMITH, 1);
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_MARKETPLACE, 1);
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_TOWN_HALL, 1);
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_DWELLING_1, 1);
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_DWELLING_2, 1);	
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_DWELLING_2, 1);
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_DWELLING_3, 1);
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_DWELLING_3, 1);	
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_INFERNO_INFERNAL_LOOM, 1);		
        UpgradeTownBuilding( "nebircias", TOWN_BUILDING_INFERNO_SACRIFICIAL_PIT, 1);		
	end,
} 

function SetEnemyHeroesArmy(koef)
	AddHeroCreatures("Grok", 		  CREATURE_IMP, 50 + koef * 50 );
	AddHeroCreatures("Grok", CREATURE_HORNED_DEMON, 20 + koef * 30 );
	AddHeroCreatures("Grok", 	  CREATURE_CERBERI, 10 + koef * 15 );
	ChangeHeroStat("Grok",      STAT_ATTACK, 2 * koef);
	ChangeHeroStat("Grok",     STAT_DEFENCE, 2 * koef);
	ChangeHeroStat("Grok", STAT_SPELL_POWER, 2 * koef);
	ChangeHeroStat("Grok",   STAT_KNOWLEDGE, 2 * koef);
	AddHeroCreatures("Itil", 	 CREATURE_SPRITE, 50 + koef * 20 );
	AddHeroCreatures("Itil", CREATURE_WAR_DANCER, 20 + koef * 10 );
	AddHeroCreatures("Itil",  CREATURE_GRAND_ELF,  10 + koef *  5 );
	ChangeHeroStat("Itil",      STAT_ATTACK, 2 * koef);
	ChangeHeroStat("Itil",     STAT_DEFENCE, 2 * koef);
	ChangeHeroStat("Itil", STAT_SPELL_POWER, 2 * koef);
	ChangeHeroStat("Itil",   STAT_KNOWLEDGE, 2 * koef);
	ChangeHeroStat("Linaas",      STAT_ATTACK, 2 * koef);
	ChangeHeroStat("Linaas",     STAT_DEFENCE, 2 * koef);
	ChangeHeroStat("Linaas", STAT_SPELL_POWER, 2 * koef);
	ChangeHeroStat("Linaas",   STAT_KNOWLEDGE, 2 * koef);
	ChangeHeroStat("Diraya",      STAT_ATTACK, 2 * koef);
	ChangeHeroStat("Diraya",     STAT_DEFENCE, 2 * koef);
	ChangeHeroStat("Diraya", STAT_SPELL_POWER, 2 * koef);
	ChangeHeroStat("Diraya",   STAT_KNOWLEDGE, 2 * koef);
	ChangeHeroStat("Elleshar",      STAT_ATTACK, 3 * koef);
	ChangeHeroStat("Elleshar",     STAT_DEFENCE, 3 * koef);
	ChangeHeroStat("Elleshar", STAT_SPELL_POWER, 3 * koef);
	ChangeHeroStat("Elleshar",   STAT_KNOWLEDGE, 3 * koef);
	AddObjectCreatures("Frontier1", CREATURE_TREANT, 32 * koef);
	AddObjectCreatures("Frontier1", CREATURE_GREEN_DRAGON, 25 * koef);
	AddObjectCreatures("Frontier1", CREATURE_DRUID_ELDER, 80 * koef);
	AddObjectCreatures("Frontier1", CREATURE_BLADE_JUGGLER, 350 * koef);
	AddObjectCreatures("Frontier1", CREATURE_GRAND_ELF, 200 * koef);
	AddObjectCreatures("Frontier2", CREATURE_SPRITE, 400 * koef);
	AddObjectCreatures("Frontier2", CREATURE_DRUID, 100 * koef);
	AddObjectCreatures("Frontier2", CREATURE_WOOD_ELF, 350 * koef);
	AddObjectCreatures("Frontier2", CREATURE_TREANT, 50 * koef);
	AddObjectCreatures("neutralg", CREATURE_GRAND_ELF, 18 * koef);
	AddObjectCreatures("neutralg", CREATURE_DRUID, 26 * koef);
	AddObjectCreatures("neutralg", CREATURE_WAR_UNICORN, 3 * koef);
	AddObjectCreatures("neutralg", CREATURE_GREEN_DRAGON, 1 * koef);
	AddObjectCreatures("neutral_g", CREATURE_WAR_DANCER, 32 * koef);
	AddObjectCreatures("neutral_g", CREATURE_BLADE_SINGER, 32 * koef);	
	AddObjectCreatures("neutral_g", CREATURE_GRAND_ELF, 16 * koef);
	AddObjectCreatures("neutral_g", CREATURE_SHARP_SHOOTER, 16 * koef);
	AddObjectCreatures("neutral_g", CREATURE_WAR_UNICORN, 4 * koef);
	AddObjectCreatures("neutral_g", CREATURE_WHITE_UNICORN, 4 * koef);	

    if koef > 1 then
	    AddObjectCreatures("cerbero", CREATURE_CERBERI, 30);
		AddObjectCreatures("infsuc", CREATURE_INFERNAL_SUCCUBUS, 20);
		GiveExp("Diraya", 41200); --> +4 levels = 20
		GiveHeroSkill("Diraya", SKILL_OFFENCE);
		GiveHeroSkill("Diraya", SKILL_LOGISTICS);
		GiveHeroSkill("Diraya", SKILL_WAR_MACHINES);	
		GiveHeroSkill("Diraya", PERK_ARCHERY);
		GiveHeroSkill("Diraya", PERK_ESTATES);
		GiveHeroSkill("Diraya", PERK_FIRST_AID);
        TeachHeroSpell("Diraya", SPELL_EARTHQUAKE);	
        TeachHeroSpell("Diraya", SPELL_ARCANE_CRYSTAL);		
		
		GiveExp("Itil", 41200);
		GiveHeroSkill("Itil", SKILL_OFFENCE);
		GiveHeroSkill("Itil", SKILL_TRAINING);
		GiveHeroSkill("Itil", SKILL_LUCK);		
		GiveHeroSkill("Itil", PERK_FRENZY);
		GiveHeroSkill("Itil", PERK_MASTER_OF_ICE);
		GiveHeroSkill("Itil", WARLOCK_FEAT_CHAOTIC_SPELLS);
        TeachHeroSpell("Itil", SPELL_STONE_SPIKES);	
        TeachHeroSpell("Itil", SPELL_DISPEL);	
        TeachHeroSpell("Itil", SPELL_BLOODLUST);	
        TeachHeroSpell("Itil", SPELL_MAGIC_ARROW);		

		GiveExp("Linaas", 41200);
		GiveHeroSkill("Linaas", SKILL_LEADERSHIP);
		GiveHeroSkill("Linaas", SKILL_LEARNING);
		GiveHeroSkill("Linaas", SKILL_WAR_MACHINES);	
		GiveHeroSkill("Linaas", PERK_PRAYER);
		GiveHeroSkill("Linaas", PERK_BALLISTA);
		GiveHeroSkill("Linaas", PERK_FIRST_AID);
        TeachHeroSpell("Linaas", SPELL_DISPEL);	
        TeachHeroSpell("Linaas", SPELL_BLOODLUST);	
        TeachHeroSpell("Linaas", SPELL_MAGIC_ARROW);	
		
		GiveExp("Elleshar", 292000);
		GiveHeroSkill("Elleshar", SKILL_AVENGER);
		GiveHeroSkill("Elleshar", HERO_SKILL_SHATTER_LIGHT_MAGIC);
		GiveHeroSkill("Elleshar", SKILL_WAR_MACHINES);	
		GiveHeroSkill("Elleshar", PERK_SNIPE_DEAD);
		GiveHeroSkill("Elleshar", DEMON_FEAT_FIRE_PROTECTION);
		GiveHeroSkill("Elleshar", PERK_BALLISTA);
        TeachHeroSpell("Elleshar", SPELL_RESURRECT);	
        TeachHeroSpell("Elleshar", SPELL_HOLY_WORD);	

		GiveExp("Grok", 41200);
		GiveHeroSkill("Grok", SKILL_LUCK);
		GiveHeroSkill("Grok", SKILL_LEADERSHIP);
		GiveHeroSkill("Grok", SKILL_LEARNING);	
		GiveHeroSkill("Grok", PERK_LUCKY_STRIKE);
		GiveHeroSkill("Grok", PERK_RESISTANCE);
		GiveHeroSkill("Grok", HERO_SKILL_PREPARATION);
        TeachHeroSpell("Grok", SPELL_WEAKNESS);	
        TeachHeroSpell("Grok", SPELL_DISRUPTING_RAY);		
	end
	if koef > 2 then 
	    AddObjectCreatures("cerbero", CREATURE_CERBERI, 35);
		AddObjectCreatures("infsuc", CREATURE_INFERNAL_SUCCUBUS, 25);
		GiveExp("Diraya", 85300); --> +4 levels = 24
		GiveHeroSkill("Diraya", SKILL_OFFENCE);
		GiveHeroSkill("Diraya", SKILL_LOGISTICS);
		GiveHeroSkill("Diraya", SKILL_WAR_MACHINES);	
		GiveHeroSkill("Diraya", PERK_FRENZY);
		GiveHeroSkill("Diraya", KNIGHT_FEAT_GRAIL_VISION);  -- mining 
		GiveHeroSkill("Diraya", PERK_BALLISTA);	
        TeachHeroSpell("Diraya", SPELL_BLADE_BARRIER);	
        TeachHeroSpell("Diraya", SPELL_ANTI_MAGIC);		

		GiveExp("Itil", 85300);
		GiveHeroSkill("Itil", SKILL_OFFENCE);
		GiveHeroSkill("Itil", SKILL_TRAINING);
		GiveHeroSkill("Itil", SKILL_LUCK);		
		GiveHeroSkill("Itil", PERK_EXPERT_TRAINER);
		GiveHeroSkill("Itil", PERK_ARCHERY);
		GiveHeroSkill("Itil", NECROMANCER_FEAT_DEAD_LUCK);
        TeachHeroSpell("Itil", SPELL_FROST_RING);	
        TeachHeroSpell("Itil", SPELL_CHAIN_LIGHTNING);	
        TeachHeroSpell("Itil", SPELL_DEFLECT_ARROWS);	
        TeachHeroSpell("Itil", SPELL_RESURRECT);
		

		GiveExp("Linaas", 85300);
		GiveHeroSkill("Linaas", SKILL_LEADERSHIP);
		GiveHeroSkill("Linaas", SKILL_LEARNING);
		GiveHeroSkill("Linaas", SKILL_WAR_MACHINES);	
		GiveHeroSkill("Linaas", KNIGHT_FEAT_GRAIL_VISION);
		GiveHeroSkill("Linaas", HERO_SKILL_EMPATHY);
		GiveHeroSkill("Linaas", PERK_INTELLIGENCE);
        TeachHeroSpell("Linaas", SPELL_DEFLECT_ARROWS);	
        TeachHeroSpell("Linaas", SPELL_RESURRECT);	

		GiveExp("Elleshar", 718000);
		GiveHeroSkill("Elleshar", KNIGHT_FEAT_TRIPLE_BALLISTA);
		GiveHeroSkill("Elleshar", PERK_FIRST_AID);
		GiveHeroSkill("Elleshar", WIZARD_FEAT_WILDFIRE);	
		GiveHeroSkill("Elleshar", RANGER_FEAT_FOREST_RAGE);
		GiveHeroSkill("Elleshar", SKILL_AVENGER);
		GiveHeroSkill("Elleshar", RANGER_FEAT_STORM_WIND);
        TeachHeroSpell("Elleshar", SPELL_BLIND);	
        TeachHeroSpell("Elleshar", SPELL_CELESTIAL_SHIELD);	

		GiveExp("Grok", 85300);
		GiveHeroSkill("Grok", SKILL_LUCK);
		GiveHeroSkill("Grok", SKILL_LEADERSHIP);
		GiveHeroSkill("Grok", SKILL_LEARNING);	
		GiveHeroSkill("Grok", RANGER_FEAT_ELVEN_LUCK);
		GiveHeroSkill("Grok", KNIGHT_FEAT_TRIPLE_BALLISTA);
		GiveHeroSkill("Grok", PERK_FIRST_AID);
        TeachHeroSpell("Grok", SPELL_ANIMATE_DEAD);	
        TeachHeroSpell("Grok", SPELL_SORROW);			
	end
	if koef > 3 then
	    AddObjectCreatures("cerbero", CREATURE_CERBERI, 40);
		AddObjectCreatures("infsuc", CREATURE_INFERNAL_SUCCUBUS, 30);
		GiveExp("Diraya", 176000); --> +4 levels = 28
		GiveHeroSkill("Diraya", SKILL_OFFENCE);
		GiveHeroSkill("Diraya", SKILL_LOGISTICS);
		GiveHeroSkill("Diraya", SKILL_WAR_MACHINES);	
		GiveHeroSkill("Diraya", PERK_INTELLIGENCE);
		GiveHeroSkill("Diraya", HERO_SKILL_DEATH_TO_NONEXISTENT);
		GiveHeroSkill("Diraya", KNIGHT_FEAT_TRIPLE_BALLISTA);
        TeachHeroSpell("Diraya", SPELL_SUMMON_HIVE);	
        TeachHeroSpell("Diraya", SPELL_FIREWALL);	

		GiveExp("Itil", 176000);
		GiveHeroSkill("Itil", SKILL_OFFENCE);
		GiveHeroSkill("Itil", SKILL_TRAINING);
		GiveHeroSkill("Itil", SKILL_LUCK);	
		GiveHeroSkill("Itil", RANGER_FEAT_FOREST_RAGE);
		GiveHeroSkill("Itil", DEMON_FEAT_CRITICAL_STRIKE);
		GiveHeroSkill("Itil", WARLOCK_FEAT_LUCKY_SPELLS);
        TeachHeroSpell("Itil", SPELL_DIVINE_VENGEANCE);	
        TeachHeroSpell("Itil", SPELL_BLIND);	
        TeachHeroSpell("Itil", SPELL_DEEP_FREEZE);	
        TeachHeroSpell("Itil", SPELL_METEOR_SHOWER);	

		GiveExp("Linaas", 176000);
		GiveHeroSkill("Linaas", SKILL_LEADERSHIP);
		GiveHeroSkill("Linaas", SKILL_LEARNING);
		GiveHeroSkill("Linaas", SKILL_WAR_MACHINES);	
		GiveHeroSkill("Linaas", KNIGHT_FEAT_TRIPLE_BALLISTA);
		GiveHeroSkill("Linaas", WARLOCK_FEAT_FAST_AND_FURIOUS);
		GiveHeroSkill("Linaas", WIZARD_FEAT_WILDFIRE);
        TeachHeroSpell("Linaas", SPELL_DIVINE_VENGEANCE);	
        TeachHeroSpell("Linaas", SPELL_BLIND);		

		GiveExp("Elleshar", 1790000);
		GiveHeroSkill("Elleshar", SKILL_AVENGER);
		GiveHeroSkill("Elleshar", PERK_CATAPULT);
		GiveHeroSkill("Elleshar", NECROMANCER_FEAT_DEAD_LUCK);	
		GiveHeroSkill("Elleshar", WARLOCK_FEAT_LUCKY_SPELLS);
		GiveHeroSkill("Elleshar", KNIGHT_FEAT_GUARDIAN_ANGEL);
		GiveHeroSkill("Elleshar", NECROMANCER_FEAT_TWILIGHT);
        TeachHeroSpell("Elleshar", SPELL_DIVINE_VENGEANCE	);	
        TeachHeroSpell("Elleshar", SPELL_DISPEL);

		GiveExp("Grok", 176000);
		GiveHeroSkill("Grok", SKILL_LUCK);
		GiveHeroSkill("Grok", SKILL_LEADERSHIP);
		GiveHeroSkill("Grok", SKILL_LEARNING);
		GiveHeroSkill("Grok", PERK_FRENZY);
		GiveHeroSkill("Grok", HERO_SKILL_EMPATHY);
		GiveHeroSkill("Grok", HERO_SKILL_STUNNING_BLOW);
        TeachHeroSpell("Grok", SPELL_VAMPIRISM);	
        TeachHeroSpell("Grok", SPELL_UNHOLY_WORD);		
	end		
end

function ErewelReinforcements(koef)
	print("Difficulty level is ",diff,". Reinforcements added...");
	AddObjectCreatures("imarium",        CREATURE_SPRITE, koef *  42);
	AddObjectCreatures("imarium",    CREATURE_WAR_DANCER, koef *  27);
	AddObjectCreatures("imarium",     CREATURE_GRAND_ELF, koef *  21);
	AddObjectCreatures("imarium",   CREATURE_DRUID_ELDER, koef *  12);
	AddObjectCreatures("imarium", CREATURE_WHITE_UNICORN, koef *   9);
	AddObjectCreatures("imarium",  CREATURE_ANGER_TREANT, koef * 7.5);
	AddObjectCreatures("imarium",   CREATURE_GOLD_DRAGON, koef *   3);
end

C2M4_ONSLAUGHT = {
	{ hero = "Diraya", diff_active = 2, home_town = "aglan", coords = { 23, 82, GROUND }, activation_date = 0, added = 0, spawned = 0, respawn_date = 0 },
	{ hero = "Linaas", diff_active = 3, home_town = "giladan", coords = { 152, 100, GROUND }, activation_date = 0, added = 0, spawned = 0, respawn_date = 0 },
}

OBJECTIVES = {
	state = {
		captureImarium   	= { "prim1",            1 }, -- Capture town of Imarium
		isAlive				= { "prim2",            1 }, -- Agrael must survive
		captureInfernoTown 	= { "sec_capture_town", 1 }, -- Capture Inferno town of nebircias
		dragons				= { "sec_dragons",	    0 }, -- Bring archers to Dragons
		eventManager		= { "_",			    1 }, -- Elven Desentir trigger; Elven hero press
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		EnableHeroAI("Elleshar", nil);
		SetObjectEnabled("dragons",nil);
		SetRegionBlocked("tavern1",1,2);
		SetRegionBlocked("tavern2",1,2);
		SetRegionBlocked("devils",1,2);
		SetRegionBlocked("garrison",1,3);
		SetRegionBlocked("garrison",1,2);
		SetRegionBlocked("Dragons",1,2);
		SetRegionBlocked("Dragons",1,3);
		for i=1,5 do
			SetRegionBlocked("gate"..i,1,2);
			SetRegionBlocked("gate_u"..i,1,3);
		end
		SetPlayerStartResources(PLAYER_1, 10, 10, 2, 2, 2, 2, 20000);
		DIFFICULTY[GetDifficulty()]();
		Trigger(OBJECT_TOUCH_TRIGGER, "dragons", "DialogBeforeCombatVSdragons", nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Dragons", "OBJECTIVES._dragons_active");
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

			if GetObjectiveState("prim2") == OBJECTIVE_FAILED then
				Loose();
			end
			
			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Agrael", "C2M4");
				sleep(5);
				CINEMATICS.outro();
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	captureImarium_reinforce_week = 1,
	captureImarium = function()
		if OBJECTIVES.state.captureImarium[2] == 1 then
			if GetObjectOwner("imarium") == PLAYER_1 then
				SetObjectiveState( "prim1", OBJECTIVE_COMPLETED );
				OBJECTIVES.state.captureImarium[2] = 10;
			elseif OBJECTIVES.captureImarium_reinforce_week < OBJECTIVES.date / 7 then
				ErewelReinforcements(diff);
				OBJECTIVES.captureImarium_reinforce_week = OBJECTIVES.captureImarium_reinforce_week + 1;
			end
		end
	end,
	
	isAlive = function()
		if IsHeroAlive("Agrael") == nil then
			SetObjectiveState( "prim2", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	captureInfernoTown = function()
		if OBJECTIVES.state.captureInfernoTown[2] == 1 and OBJECTIVES.date == 2 then
			CINEMATICS.captureInfernoTownStart();
			SetObjectiveState("sec_capture_town", OBJECTIVE_ACTIVE);
			OBJECTIVES._eventManager_desentirDay = OBJECTIVES.date + 1;
			OBJECTIVES.state.captureInfernoTown[2] = 2;
		elseif OBJECTIVES.state.captureInfernoTown[2] == 2 and GetObjectOwner("nebircias") == PLAYER_1 then
			CINEMATICS.captureInfernoTownFinish();
			SetObjectiveState("sec_capture_town",OBJECTIVE_COMPLETED);
			SetRegionBlocked("gate1",nil,2);
			SetRegionBlocked("gate3",nil,2);
			SetRegionBlocked("gate_u1",nil,3);
			SetRegionBlocked("gate_u3",nil,3);
			SetRegionBlocked("gate_u4",nil,3);
			SetRegionBlocked("gate_u5",nil,3);
			OBJECTIVES.state.captureInfernoTown[2] = 10;
		end
	end,
	
	_dragons_active = function(hero)
		if hero == "Agrael" then
			OBJECTIVES.state.dragons[2] = OBJECTIVES.state.dragons[2] + 1;
		end
	end,
	
	_dragons_countElves = function()
		return (GetHeroCreatures("Agrael",CREATURE_WOOD_ELF) + GetHeroCreatures("Agrael",CREATURE_GRAND_ELF) + GetHeroCreatures("Agrael", CREATURE_SHARP_SHOOTER))
	end,
	
	dragons = function()
		if OBJECTIVES.state.dragons[2] == 1 then
			CINEMATICS.dragonsStarted();
			SetObjectiveState( "sec_dragons", OBJECTIVE_ACTIVE );
			if OBJECTIVES._dragons_countElves() > 99 then
				OBJECTIVES.state.dragons[2] = 3;
			else
				OBJECTIVES.state.dragons[2] = 2;
			end
		elseif OBJECTIVES.state.dragons[2] == 3 then
			if OBJECTIVES._dragons_countElves() > 99 then
				Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Dragons", nil);
				if (OBJECTIVES._dragons_countElves() >= 500) then
					GiveArtefact("Agrael", ARTIFACT_DRAGON_FLAME_TONGUE);
					CINEMATICS.dragonsFinish500();
				else
					CINEMATICS.dragonsFinish100();
				end
				SetObjectiveState("sec_dragons", OBJECTIVE_COMPLETED);
				ObjectiveExp("Agrael");
				RemoveHeroCreatures("Agrael", CREATURE_WOOD_ELF, 500);
				RemoveHeroCreatures("Agrael", CREATURE_GRAND_ELF, 500);
				RemoveHeroCreatures("Agrael", CREATURE_SHARP_SHOOTER, 500);
				RemoveObject("dragons");
				SetRegionBlocked("Dragons",nil,2);
				SetRegionBlocked("Dragons",nil,3);
				OBJECTIVES.state.dragons[2] = 10;
			else
				CINEMATICS.dragonsNoElves();
				OBJECTIVES.state.dragons[2] = 2;
			end
		elseif OBJECTIVES.state.dragons[2] == 4 then
			Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Dragons", nil);
			RemoveObject("dragons");
			SetRegionBlocked("Dragons",nil,2);
			SetRegionBlocked("Dragons",nil,3);
			SetObjectiveState("sec_dragons", OBJECTIVE_FAILED);
			OBJECTIVES.state.dragons[2] = 11;
		end
	end,
	
	_eventManager_onslaughtActive = 0,
	_eventManager_desentirDay = 999,
	_eventManager_day = 0,
	eventManager = function()
		if OBJECTIVES.state.eventManager[2] == 1 and OBJECTIVES._eventManager_day <= OBJECTIVES.date then
			if OBJECTIVES._eventManager_desentirDay <= OBJECTIVES.date then
				for i=1,21 do
					local quantity = 0;
					if GetHeroCreatures("Agrael", CreatureList[i]) > 5 then
						if i <= 6 			then quantity = 1+random(6); end
						if i > 6 and i <=15 then quantity = 1+random(2); end
						if i > 15 			then quantity = 1; 			 end
						RemoveHeroCreatures("Agrael", CreatureList[i], quantity);
						--print("Agrael lost ",quantity," creatures. Creature ID = ",CreatureList[i]);
					else
						--print("Hero has less then 5 creatures this type. Creature ID = ",CreatureList[i]);
					end
				end
				OBJECTIVES._eventManager_desentirDay = OBJECTIVES.date + 1;
			end
			if GetObjectOwner("holin") == PLAYER_1 and OBJECTIVES._eventManager_onslaughtActive == 0 then
				OBJECTIVES._eventManager_onslaughtActive = 1;
			end

			if OBJECTIVES._eventManager_onslaughtActive == 1 then
				for i,v in C2M4_ONSLAUGHT do
					if diff >= v.diff_active and v.activation_date <= OBJECTIVES.date and v.added == 0 then
						if IsHeroAlive(v.hero) ~= nil then
							H55c_AIAddHero(v.hero);
							v.added = 1;
						end
					end
				end
			end
			for i,v in C2M4_ONSLAUGHT do
				if diff >= v.diff_active then
					if IsHeroAlive(v.hero) ~= nil then
						v.spawned = 1;
						v.respawn_date = 0;
					elseif v.spawned == 0 then
						-- Initial deployment: no 4-day delay
						if GetObjectOwner(v.home_town) == PLAYER_2 then
							DeployReserveHero(v.hero, v.coords[1], v.coords[2], v.coords[3]);
							sleep(20);
							v.spawned = 1;
							v.activation_date = OBJECTIVES.date + (20 - 2 * GetDifficulty()) * OBJECTIVES._eventManager_onslaughtActive;
							v.added = 0;
							AddHeroCreatures(v.hero, CREATURE_SPRITE, diff * 40);
							AddHeroCreatures(v.hero, CREATURE_WAR_DANCER, diff * 30);
							AddHeroCreatures(v.hero, CREATURE_GRAND_ELF, diff * 20);
						end
					elseif v.respawn_date == 0 then
						-- Hero was previously alive and is now dead.
						v.respawn_date = OBJECTIVES.date + 5 - diff;
						v.added = 0;
					elseif OBJECTIVES.date >= v.respawn_date then
						-- Four days have passed since death was detected.
						if GetObjectOwner(v.home_town) == PLAYER_2 then
							DeployReserveHero(v.hero, v.coords[1], v.coords[2], v.coords[3]);
							sleep(20);
							v.respawn_date = 0;
							v.activation_date = OBJECTIVES.date + (20 - 2 * GetDifficulty()) * OBJECTIVES._eventManager_onslaughtActive;
							v.added = 0;
							AddHeroCreatures(v.hero, CREATURE_SPRITE, diff * 40);
							AddHeroCreatures(v.hero, CREATURE_WAR_DANCER, diff * 30);
							AddHeroCreatures(v.hero, CREATURE_GRAND_ELF, diff * 20);
						end
					end

				end
			end
			OBJECTIVES._eventManager_day = OBJECTIVES.date + 1;
		end
	end,
}

function DialogBeforeCombatVSdragons(heroname)
	HeroName = heroname;
	print("Dialog 1 check has been started...");
	QuestionBox("/Maps/Scenario/C2M4/BeforeCombatVSDragons.txt", "combatVSdragons");
end

function combatVSdragons(heroname)
	print("Thread combatVSdragons has been started...");
	CINEMATICS.dragonsFight();
	StartCombat(HeroName, nil,3,CREATURE_SHADOW_DRAGON,20 * diff,CREATURE_SHADOW_DRAGON,25 * diff,CREATURE_SHADOW_DRAGON,20 * diff,nil,"FinishCombat");
end

function FinishCombat(heroname,result)
	print("Thread FinishCombat has been started");
	if result ~= nil then
		OBJECTIVES.state.dragons[2] = 4;
	end
end

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
startThread( H55c_AI_main )


function c2m4_dbg(var)
	if var == 1 then
		H55_NoFog(1);
		H55_Speedrun(1);
	elseif var == 2 then
		SetObjectOwner("holin", PLAYER_1);
	elseif var == 3 then
		RemoveObject("Diraya");
	elseif var == 4 then
		RemoveObject("Linaas");
	elseif var == 5 then
		MakeHeroInteractWithObject("Agrael", "imarium");
	end
end