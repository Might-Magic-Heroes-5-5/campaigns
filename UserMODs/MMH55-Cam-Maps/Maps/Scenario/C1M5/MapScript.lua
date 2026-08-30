doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end
H55_PlayerStatus = {0,1,1,2,2,2,2,2};
H55c_AI_CONTROLLED = {
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
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3 King Nicolai
		}
	}
}

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C1M5");
end

startThread(H55_InitSetArtifacts);

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C1/M5/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 10 );
		OpenCircleFog( 26, 109, 0, 7, PLAYER_1 );
	end,
  
	searchForGrail = function()
		StartDialogScene("/DialogScenes/C1/M5/D4A/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 10 );
	end,
	
	rescueIsabell = function()
		StartDialogScene("/DialogScenes/C1/M5/D3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 10 );
	end,

	defeatAgrael = function()
		StartDialogScene("/DialogScenes/C1/M5/D4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 10 );
	end,
	
	grailConstructed = function()
		StartDialogScene("/DialogScenes/C1/M5/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 10 );
	end,
	
	sendGodricOnMission = function()
		StartDialogScene("/DialogScenes/C1/M5/D5/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 10 );
		OpenCircleFog( 129, 15, 0, 6, PLAYER_1 );
	end,
	
	godricLeaves = function()
		StartDialogScene("/DialogScenes/C1/M5/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 10 );
	end,
	
	isabellJoinNikolai = function()
		StartDialogScene("/DialogScenes/C1/M5/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 10 );
	end,

	outro = function()
		StartCutScene("/Maps/Cutscenes/C1M5/_.(AnimScene).xdb#xpointer(/AnimScene)");
		sleep( 10 );
	end,

	GodrickLearnsIsabellPrisonLocation = function()
		startThread( MessageBox, "/Maps/Scenario/C1M5/Tutorial/C1M5_C11.txt", "CINEMATICS.GodrickLearnsIsabellPrisonLocation2" );
	end,
	
	GodrickLearnsIsabellPrisonLocation2 = function()
		MessageBox("/Maps/Scenario/C1M5/Tutorial/C1M5_C11_2.txt");
	end,
}

C1M5_ASSAULT_ARMY = {
	deploy = function(hero_id)
		local pos = random( 2 ) + 1;
		local name = assault_hero_names[hero_id];
		DeployReserveHero( name, portals[pos][1], portals[pos][2], GROUND );
		sleep(20);
		print(name,"(",hero_id,") deployed");
		H55c_AIAddHero(name);
		sleep(10);
		local time = (GetDate(MONTH)*4  - 4) + GetDate(WEEK);
		C1M5_ASSAULT_ARMY[name](time);
	end,
	
	addUnit = function(hero, unit, count)
		if count < 1 then return end
		pcall(AddHeroCreatures(hero, unit, count ));
		sleep(10);
	end,

	Nymus = function(num)
		C1M5_ASSAULT_ARMY.addUnit("Nymus", CREATURE_IMP, (100 + num * 15 + random( 5 )) * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Nymus", CREATURE_HORNED_DEMON, (36 + num * 12 + random( 5 )) * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Nymus", CREATURE_CERBERI, (20 + num * 8 + random( 3 ))  * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Nymus", CREATURE_INFERNAL_SUCCUBUS, (9 + num * 4) * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Nymus", CREATURE_DEVIL, (2 + num) * easyfactor );
	end,
	
	Jazaz = function(num)
		C1M5_ASSAULT_ARMY.addUnit("Jazaz", 			  CREATURE_FAMILIAR, (90 + num * 16 + random( 5 )) * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Jazaz", 				 CREATURE_DEMON, (42 + num * 10 + random( 5 )) * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Jazaz", 			   CREATURE_CERBERI, (36 + num * 6 + random( 3 ))  * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Jazaz", CREATURE_FRIGHTFUL_NIGHTMARE, (2 + num * 4) * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Jazaz", 			 CREATURE_ARCHDEVIL, (1 + num) * easyfactor );
	end,
	
	Efion = function(num)
		C1M5_ASSAULT_ARMY.addUnit("Efion", CREATURE_HORNED_DEMON, (40 + num * 9 + random( 4 )) * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Efion", 	 CREATURE_HELL_HOUND, (30 + num * 7 + random( 3 )) * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Efion", 	   CREATURE_SUCCUBUS, (12 + num * 4 )  * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Efion", 	  CREATURE_NIGHTMARE, (6 + num * 3) * easyfactor );
		C1M5_ASSAULT_ARMY.addUnit("Efion", 		  CREATURE_BALOR, (4 + num* 2) * easyfactor );
	end,
	
	Agrael = function(num)
		C1M5_ASSAULT_ARMY.addUnit("Agrael",		   CREATURE_HELL_HOUND, 1600 );
		C1M5_ASSAULT_ARMY.addUnit("Agrael",		 CREATURE_HORNED_DEMON, 3000 );
		C1M5_ASSAULT_ARMY.addUnit("Agrael",			CREATURE_ARCHDEVIL, 250 );
		C1M5_ASSAULT_ARMY.addUnit("Agrael",				CREATURE_BALOR, 420 );
		C1M5_ASSAULT_ARMY.addUnit("Agrael",	CREATURE_INFERNAL_SUCCUBUS, 1000 );
	end,
}

TUTORIALS = {
	list = {
		{ "c1_m5_t2", REGION_ENTER_AND_STOP_TRIGGER,   "t2", "TUTORIALS.obelisks", 0 },
		{ "c1_m5_t2", REGION_ENTER_AND_STOP_TRIGGER, "t2_1", "TUTORIALS.obelisks", 0 },
		{ "c1_m5_t2", REGION_ENTER_AND_STOP_TRIGGER, "t2_2", "TUTORIALS.obelisks", 0 },
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
		if GetObjectOwner(nameHero) == PLAYER_1 then
			WaitForTutorialMessageBox();
			TutorialMessageBox( "c1_m5_t2" );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "t2", nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "t2", nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2_1", nil );
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "t2_2", nil );
			TUTORIALS.markComplete("TUTORIALS.obelisks");
		end
	end,
}

OBJECTIVES = {
	state = { -- 0 quest is not active or managed by map.xdb, 1 quest is active, 2-9 custom states, 10 success, 11 fail
		rescueIsabell = { "prim1", 1 },   -- 2 Godric captures Dunmor and learns he has to free Isabel ASAP, 3 Isabel is freed, 10 Isabel is free and Dunmor is captured, 11 on 8th day mission will fail
		protectDunmor = { "prim2", 1 },   -- 1 waiting, 2 Dunmor captured & Agrael attacks, 3 Agrael is defeated, 4 Infero heroes onslaught begins, 5-6 Agrael second attack.
		buildGrail    = { "prim3", 1 },   -- 1 waiting, 2 found the grail, 10 build the grail
		sendGodric    = { "prim4", 1 },   -- 1 missions active, 2,10 mission success
		joinNikolai   = { "prim5", 0 },
		isAlive       = { "prim6", 1 },
		garrisonReinforcements = { "_", 0 },
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
	end,

	prepare = function()
	-- set difficulty
		factor_by_diffculty = { 0.5, 1.0, 1.5, 2.0 }
		easyfactor = factor_by_diffculty[__difficulty + 1]

		crap = __difficulty - 1;
		if crap < 0 then
			crap = 0;
		end

		ASSAULT_DELAY = 8 - crap;
		assault_hero_names = { "Nymus", "Jazaz", "Efion" };
		enemy_defeats = {
			Jazaz  = 0,
			Efion  = 0,
			Nymus  = 0,
		}
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "OBJECTIVES._CountEnemyDefeats" );
		Trigger( OBJECT_TOUCH_TRIGGER, "Prison", "OBJECTIVES._RescueIsabell" );

	-- set player resource
	    SetPlayerStartResources(PLAYER_1, 10, 10,  5,  5,  5,  5, 7000);
		GiveExp("Godric", 32100);

	-- set ai army stats
		ChangeHeroStat("Efion", STAT_ATTACK, 6);
		ChangeHeroStat("Efion", STAT_DEFENCE, 4);
		ChangeHeroStat("Efion", STAT_SPELL_POWER, 11);
		ChangeHeroStat("Efion", STAT_KNOWLEDGE, 1);
		ChangeHeroStat("Nymus", STAT_ATTACK, 9);
		ChangeHeroStat("Nymus", STAT_DEFENCE, 4);
		ChangeHeroStat("Nymus", STAT_SPELL_POWER, 7);
		ChangeHeroStat("Nymus", STAT_KNOWLEDGE, 2);
		ChangeHeroStat("Jazaz", STAT_ATTACK, 10);
		ChangeHeroStat("Jazaz", STAT_DEFENCE, 6);
		ChangeHeroStat("Jazaz", STAT_SPELL_POWER, 4);
		ChangeHeroStat("Jazaz", STAT_KNOWLEDGE, 2);
		
		local koef = GetDifficulty() + 1;
		ChangeHeroStat("Agrael", STAT_SPELL_POWER, 2 * koef);
		ChangeHeroStat("Agrael", STAT_DEFENCE, 2 * koef);
		ChangeHeroStat("Agrael", STAT_KNOWLEDGE, 2 * koef);
		ChangeHeroStat("Agrael", STAT_ATTACK, 2 * koef);
		AddObjectCreatures("Dummar", CREATURE_FRIGHTFUL_NIGHTMARE, 1 * koef);
		AddObjectCreatures("Dummar", CREATURE_SUCCUBUS, 5 * koef);	
		AddObjectCreatures("Dummar", CREATURE_IMP, 15 * koef);	
		AddObjectCreatures("PrisonGuardian", CREATURE_BALOR, 4 * koef);		 		
		if koef > 1 then
		    GiveHeroSkill("Efion", SKILL_GATING);
		    GiveHeroSkill("Efion", PERK_DEMONIC_FIRE);
		    GiveHeroSkill("Efion", SKILL_LEARNING);
			GiveHeroSkill("Efion", PERK_MASTER_OF_CURSES);
			GiveHeroSkill("Efion", SKILL_SORCERY);
			GiveHeroSkill("Efion", PERK_MYSTICISM);
			TeachHeroSpell("Efion", SPELL_FORGETFULNESS);
			TeachHeroSpell("Efion", SPELL_PLAGUE);
			TeachHeroSpell("Efion", SPELL_WEAKNESS);
			TeachHeroSpell("Efion", SPELL_DISRUPTING_RAY);
			TeachHeroSpell("Efion", SPELL_DISPEL);
			TeachHeroSpell("Efion", SPELL_STONESKIN);
			TeachHeroSpell("Efion", SPELL_BLOODLUST);
			TeachHeroSpell("Efion", SPELL_EARTHQUAKE);
		    ChangeHeroStat("Efion", STAT_ATTACK, 2);
		    ChangeHeroStat("Efion", STAT_DEFENCE, 1);
		    ChangeHeroStat("Efion", STAT_KNOWLEDGE, 1);			
		    GiveHeroSkill("Nymus", SKILL_GATING);
		    GiveHeroSkill("Nymus", DEMON_FEAT_QUICK_GATING);
		    GiveHeroSkill("Nymus", SKILL_LEARNING);
			GiveHeroSkill("Nymus", PERK_MASTER_OF_MIND);
			GiveHeroSkill("Nymus", SKILL_LUCK);
			GiveHeroSkill("Nymus", PERK_LUCKY_STRIKE);
			TeachHeroSpell("Nymus", SPELL_FORGETFULNESS);
			TeachHeroSpell("Nymus", SPELL_PLAGUE);
			TeachHeroSpell("Nymus", SPELL_WEAKNESS);
			TeachHeroSpell("Nymus", SPELL_DISRUPTING_RAY);
			TeachHeroSpell("Nymus", SPELL_DISPEL);
			TeachHeroSpell("Nymus", SPELL_STONESKIN);
			TeachHeroSpell("Nymus", SPELL_BLOODLUST);
			TeachHeroSpell("Nymus", SPELL_EARTHQUAKE);
			TeachHeroSpell("Nymus", SPELL_WASP_SWARM);			
		    ChangeHeroStat("Nymus", STAT_SPELL_POWER, 2);
		    ChangeHeroStat("Nymus", STAT_DEFENCE, 1);
		    ChangeHeroStat("Nymus", STAT_KNOWLEDGE, 1);	
		    GiveHeroSkill("Jazaz", SKILL_GATING);
		    GiveHeroSkill("Jazaz", PERK_DEMONIC_FIRE);
		    GiveHeroSkill("Jazaz", SKILL_LEARNING);
			GiveHeroSkill("Jazaz", PERK_MASTER_OF_MIND);
			GiveHeroSkill("Jazaz", SKILL_WAR_MACHINES);
			GiveHeroSkill("Jazaz", WIZARD_FEAT_WILDFIRE);
			TeachHeroSpell("Jazaz", SPELL_FORGETFULNESS);
			TeachHeroSpell("Jazaz", SPELL_PLAGUE);
			TeachHeroSpell("Jazaz", SPELL_WEAKNESS);
			TeachHeroSpell("Jazaz", SPELL_DISRUPTING_RAY);
			TeachHeroSpell("Jazaz", SPELL_DISPEL);
			TeachHeroSpell("Jazaz", SPELL_STONESKIN);
			TeachHeroSpell("Jazaz", SPELL_BLOODLUST);
			TeachHeroSpell("Jazaz", SPELL_EARTHQUAKE);
		    ChangeHeroStat("Jazaz", STAT_SPELL_POWER, 2);
		    ChangeHeroStat("Jazaz", STAT_DEFENCE, 1);
		    ChangeHeroStat("Jazaz", STAT_KNOWLEDGE, 1);
		    GiveHeroSkill("Agrael", SKILL_LEARNING);
		    GiveHeroSkill("Agrael", SKILL_OFFENCE);	
			AddObjectCreatures("garrison", CREATURE_INFERNAL_SUCCUBUS, 100); 
            AddObjectCreatures("garrison", CREATURE_FRIGHTFUL_NIGHTMARE, 60); 			
            AddObjectCreatures("garrison", CREATURE_BALOR, 40);  
            AddObjectCreatures("garrison", CREATURE_ARCHDEVIL, 20); 			
		end
		if koef > 2 then
		    GiveHeroSkill("Efion", SKILL_GATING);
		    GiveHeroSkill("Efion", DEMON_FEAT_DEMONIC_RETALIATION);
		    GiveHeroSkill("Efion", SKILL_LEARNING);
			GiveHeroSkill("Efion", SKILL_DARK_MAGIC);
			GiveHeroSkill("Efion", SKILL_NECROMANCY);
			GiveHeroSkill("Efion", NECROMANCER_FEAT_CHILLING_BONES);			
			GiveHeroSkill("Efion", HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC);	
			GiveHeroSkill("Efion", KNIGHT_FEAT_ANCIENT_SMITHY);
			TeachHeroSpell("Efion", SPELL_CHAIN_LIGHTNING);
			TeachHeroSpell("Efion", SPELL_FROST_RING);
			TeachHeroSpell("Efion", SPELL_TELEPORT);
			TeachHeroSpell("Efion", SPELL_ANIMATE_DEAD);			
		    ChangeHeroStat("Efion", STAT_ATTACK, 3);
		    ChangeHeroStat("Efion", STAT_DEFENCE, 2);
		    ChangeHeroStat("Efion", STAT_KNOWLEDGE, 1);	
		    GiveHeroSkill("Nymus", SKILL_GATING);
		    GiveHeroSkill("Nymus", DEMON_FEAT_CRITICAL_GATING);
		    GiveHeroSkill("Nymus", SKILL_LEARNING);
			GiveHeroSkill("Nymus", SKILL_DARK_MAGIC);
			GiveHeroSkill("Nymus", SKILL_SUMMONING_MAGIC);
			GiveHeroSkill("Nymus", RANGER_FEAT_FOG_VEIL);
			GiveHeroSkill("Nymus", HERO_SKILL_SHATTER_SUMMONING_MAGIC	);	
			GiveHeroSkill("Nymus", PERK_MASTER_OF_ANIMATION);			
			TeachHeroSpell("Nymus", SPELL_SUMMON_ELEMENTALS);
			TeachHeroSpell("Nymus", SPELL_ANTI_MAGIC);
			TeachHeroSpell("Nymus", SPELL_TELEPORT);
			TeachHeroSpell("Nymus", SPELL_ANIMATE_DEAD);
		    ChangeHeroStat("Nymus", STAT_ATTACK, 3);
		    ChangeHeroStat("Nymus", STAT_DEFENCE, 2);
		    ChangeHeroStat("Nymus", STAT_KNOWLEDGE, 1);		
		    GiveHeroSkill("Jazaz", SKILL_GATING);
		    GiveHeroSkill("Jazaz", DEMON_FEAT_DEMONIC_RETALIATION);
		    GiveHeroSkill("Jazaz", SKILL_LEARNING);
			GiveHeroSkill("Jazaz", SKILL_DARK_MAGIC);
			GiveHeroSkill("Jazaz", NECROMANCER_FEAT_LAST_AID);
			GiveHeroSkill("Jazaz", PERK_EXPERT_TRAINER);			
			GiveHeroSkill("Jazaz", HERO_SKILL_SHATTER_LIGHT_MAGIC);	
			GiveHeroSkill("Jazaz", RANGER_FEAT_STORM_WIND);
			TeachHeroSpell("Jazaz", SPELL_REGENERATION);
			TeachHeroSpell("Jazaz", SPELL_DEFLECT_ARROWS);
			TeachHeroSpell("Jazaz", SPELL_TELEPORT);
			TeachHeroSpell("Jazaz", SPELL_ANIMATE_DEAD);			
		    ChangeHeroStat("Jazaz", STAT_SPELL_POWER, 3);
		    ChangeHeroStat("Jazaz", STAT_DEFENCE, 2);
		    ChangeHeroStat("Jazaz", STAT_KNOWLEDGE, 1);				
		    GiveHeroSkill("Agrael", SKILL_LEARNING);
		    GiveHeroSkill("Agrael", SKILL_SUMMONING_MAGIC);	
			AddObjectCreatures("garrison", CREATURE_INFERNAL_SUCCUBUS, 100); 
            AddObjectCreatures("garrison", CREATURE_FRIGHTFUL_NIGHTMARE, 60); 			
            AddObjectCreatures("garrison", CREATURE_BALOR, 40);  
            AddObjectCreatures("garrison", CREATURE_ARCHDEVIL, 20);			
		end
		if koef > 3 then
			GiveHeroSkill("Efion", SKILL_GATING);
		    GiveHeroSkill("Efion", DEMON_FEAT_GATING_MASTERY);
		    GiveHeroSkill("Efion", SKILL_LEARNING);
			GiveHeroSkill("Efion", SKILL_DARK_MAGIC);
			GiveHeroSkill("Efion", SKILL_DESTRUCTIVE_MAGIC);			
			GiveHeroSkill("Efion", PERK_DEATH_SCREAM);
			GiveHeroSkill("Efion", HERO_SKILL_SHATTER_DESTRUCTIVE_MAGIC);	
			GiveHeroSkill("Efion", RANGER_FEAT_SUN_FIRE);
			GiveHeroSkill("Efion", SKILL_DEFENCE);		
			TeachHeroSpell("Efion", SPELL_UNHOLY_WORD);
			TeachHeroSpell("Efion", SPELL_VAMPIRISM);
			TeachHeroSpell("Efion", SPELL_METEOR_SHOWER);
			TeachHeroSpell("Efion", SPELL_DEEP_FREEZE);		
		    ChangeHeroStat("Efion", STAT_ATTACK, 4);
		    ChangeHeroStat("Efion", STAT_DEFENCE, 3);
		    ChangeHeroStat("Efion", STAT_KNOWLEDGE, 2);		
		    GiveHeroSkill("Nymus", SKILL_LUCK);
		    GiveHeroSkill("Nymus", RANGER_FEAT_ELVEN_LUCK);
		    GiveHeroSkill("Nymus", SKILL_LEARNING);
			GiveHeroSkill("Nymus", SKILL_OFFENCE);
			GiveHeroSkill("Nymus", SKILL_DEFENCE);
			GiveHeroSkill("Nymus", PERK_MASTER_OF_ANIMATION);
			GiveHeroSkill("Nymus", PERK_ARCHERY);
			GiveHeroSkill("Nymus", PERK_EVASION);
			GiveHeroSkill("Nymus", HERO_SKILL_DEATH_TO_NONEXISTENT);			
			TeachHeroSpell("Nymus", SPELL_UNHOLY_WORD);
			TeachHeroSpell("Nymus", SPELL_VAMPIRISM);
			TeachHeroSpell("Nymus", SPELL_FIREWALL);
			TeachHeroSpell("Nymus", SPELL_SUMMON_HIVE);
		    ChangeHeroStat("Nymus", STAT_SPELL_POWER, 4);
		    ChangeHeroStat("Nymus", STAT_DEFENCE, 3);
		    ChangeHeroStat("Nymus", STAT_KNOWLEDGE, 2);	
			GiveHeroSkill("Jazaz", SKILL_GATING);
		    GiveHeroSkill("Jazaz", DEMON_FEAT_GATING_MASTERY);
		    GiveHeroSkill("Jazaz", SKILL_LEARNING);
			GiveHeroSkill("Jazaz", SKILL_LIGHT_MAGIC);
			GiveHeroSkill("Jazaz", SKILL_OFFENCE);			
			GiveHeroSkill("Jazaz", NECROMANCER_FEAT_DEATH_TREAD);
			GiveHeroSkill("Jazaz", HERO_SKILL_SHATTER_LIGHT_MAGIC);	
			GiveHeroSkill("Jazaz", DEMON_FEAT_FIRE_PROTECTION);
			GiveHeroSkill("Jazaz", SKILL_DEFENCE);		
			TeachHeroSpell("Jazaz", SPELL_UNHOLY_WORD);
			TeachHeroSpell("Jazaz", SPELL_VAMPIRISM);
			TeachHeroSpell("Jazaz", SPELL_RESURRECT);
			TeachHeroSpell("Jazaz", SPELL_BLIND);		
		    ChangeHeroStat("Jazaz", STAT_ATTACK, 4);
		    ChangeHeroStat("Jazaz", STAT_SPELL_POWER, 3);
		    ChangeHeroStat("Jazaz", STAT_KNOWLEDGE, 2);				
		    GiveHeroSkill("Agrael", SKILL_LEARNING);
		    GiveHeroSkill("Agrael", SKILL_DEFENCE);	
			AddObjectCreatures("garrison", CREATURE_INFERNAL_SUCCUBUS, 100); 
            AddObjectCreatures("garrison", CREATURE_FRIGHTFUL_NIGHTMARE, 60); 			
            AddObjectCreatures("garrison", CREATURE_BALOR, 40);  
            AddObjectCreatures("garrison", CREATURE_ARCHDEVIL, 20);			
		end

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
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					if pcall(OBJECTIVES[key]) == nil then print(key) end;
				end
			end

			if GetObjectiveState( 'prim1') == OBJECTIVE_FAILED or GetObjectiveState('prim2') == OBJECTIVE_FAILED or GetObjectiveState('prim3') == OBJECTIVE_FAILED or GetObjectiveState( 'prim6') == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState( "prim5") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Isabell", "C1M5");
				sleep(40);
				Save("scene3" );
				CINEMATICS.outro();
				sleep(100);
				Win();
				return
			end
		end
	end,
  
	_RescueIsabell = function()
		Trigger( OBJECT_TOUCH_TRIGGER, "Prison", nil );
		OBJECTIVES.state.rescueIsabell[2] = 4;
	end,
  
	rescueIsabell = function()
		if OBJECTIVES.state.rescueIsabell[2] == 1 then
			SetObjectiveState('prim1', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.rescueIsabell[2] = 2;
		elseif OBJECTIVES.state.rescueIsabell[2] == 2 and GetObjectOwner("Dummar") == PLAYER_1 then
			CINEMATICS.GodrickLearnsIsabellPrisonLocation();
			OBJECTIVES.state.rescueIsabell[2] = 3;
		elseif OBJECTIVES.state.rescueIsabell[2] == 4 then
			CINEMATICS.rescueIsabell();
			sleep(10);
			GiveExp( 'Godric', 5000 );
			SetRegionBlocked( 'AIblock', nil, PLAYER_2 );
			LoadHeroAllSetArtifacts( "Isabell", "C1M4" );
			sleep(40); -- wait artifacts to get loaded
			H55_CamFixTooManySkills( PLAYER_1, "Isabell" );
			OBJECTIVES.state.rescueIsabell[2] = 5;		
		elseif OBJECTIVES.state.rescueIsabell[2] == 5 and GetObjectOwner("Dummar") == PLAYER_1 then
			SetObjectiveState( "prim1", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.rescueIsabell[2] = 10;
		end
	end,

	_CountEnemyDefeats = function( looser, winner )
		if (looser == "Efion" or looser == "Jazaz" or looser == "Nymus") then
			enemy_defeats[looser] = enemy_defeats[looser] + 1;
		end
	end,

	assaultCount = 0,
	assaultDay = 999,
	protectDunmor = function()
		if OBJECTIVES.state.protectDunmor[2] == 1 and GetObjectOwner("Dummar") == PLAYER_1 then
			SetObjectiveState('prim2', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.protectDunmor[2] = 2;
		elseif OBJECTIVES.state.protectDunmor[2] == 2 and IsHeroAlive("Isabell") ~= nil then
			DeployReserveHero( 'Agrael', 120, 55, 0 );
			sleep(20);
			H55c_AIAddHero('Agrael');
			SetHeroLootable( 'Agrael', nil );
			SetHeroRoleMode( 'Agrael', HERO_ROLE_MODE_HERMIT );
			sleep(10);
			local GD = GetDifficulty() + 1; 
            if GD > 1 then
			    AddHeroCreatures("Agrael", CREATURE_FRIGHTFUL_NIGHTMARE, 10);
			end
			if GD > 2 then
			    AddHeroCreatures("Agrael", CREATURE_INFERNAL_SUCCUBUS, 20);
                AddHeroCreatures("Agrael", CREATURE_CERBERI, 40);
			end	
			if GD > 3 then
            AddHeroCreatures("Agrael", CREATURE_IMP, 80);
            AddHeroCreatures("Agrael", CREATURE_HORNED_DEMON, 60);
			end				
			OBJECTIVES.state.protectDunmor[2] = 3;
		elseif OBJECTIVES.state.protectDunmor[2] == 3 and IsHeroAlive("Agrael") == nil then
			CINEMATICS.defeatAgrael();
			OBJECTIVES.assaultDay = GetDate(ABSOLUTE_DAY) + ASSAULT_DELAY;
			OBJECTIVES.state.garrisonReinforcements[2] = 1;
			OBJECTIVES.state.protectDunmor[2] = 4;
		elseif OBJECTIVES.state.protectDunmor[2] == 4 then
			if GetDate(ABSOLUTE_DAY) == OBJECTIVES.assaultDay then
				OBJECTIVES.assaultCount = OBJECTIVES.assaultCount + 1;
				OBJECTIVES.assaultDay = OBJECTIVES.assaultDay + ASSAULT_DELAY + (4 - crap);
				local hero_id = mod( OBJECTIVES.assaultCount, 3 ) + 1;
				C1M5_ASSAULT_ARMY.deploy( hero_id );
				print("AssaultCount = ".. OBJECTIVES.assaultCount .. " | NextAssaultDay = ".. OBJECTIVES.assaultDay);
			elseif OBJECTIVES.state.buildGrail[2] == 10 and __difficulty < DIFFICULTY_HEROIC or OBJECTIVES.state.sendGodric[2] == 10 then
				OBJECTIVES.state.protectDunmor[2] = 5;
			end
		elseif OBJECTIVES.state.protectDunmor[2] == 5 and IsHeroAlive("Nicolai") == not nil then
			SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.protectDunmor[2] = 10;
		end
		
		if OBJECTIVES.state.protectDunmor[2] > 2 and GetObjectOwner( "Dummar" ) == PLAYER_2 then
			SetObjectiveState( "prim2", OBJECTIVE_FAILED );
			OBJECTIVES.state.protectDunmor[2] = 11;
		end
	end,
  
	buildGrail = function()
		if OBJECTIVES.state.buildGrail[2] == 1 and (enemy_defeats["Nymus"] > 0 or enemy_defeats["Jazaz"] > 0 or enemy_defeats["Efion"] > 0 ) then
			CINEMATICS.searchForGrail();
			SetObjectiveState('prim3', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.buildGrail[2] = 2;
		elseif OBJECTIVES.state.buildGrail[2] == 2 then
			if GetTownBuildingLevel( "Dummar", TOWN_BUILDING_GRAIL ) == 1 then
				CINEMATICS.grailConstructed();
				GiveExp( 'Isabell', 20000 );
				if IsObjectExists( 'Godric') then
					sleep( 10 );
					GiveExp( 'Godric', 10000 );
				end
				SetObjectiveState( "prim3", OBJECTIVE_COMPLETED );
				OBJECTIVES.state.buildGrail[2] = 10;
			elseif IsAnyHeroPlayerHasArtifact( PLAYER_2, ARTIFACT_GRAAL ) == not nil then
				MessageBox( "/Maps/Scenario/C1M5/GrailLost.txt" );
				SetObjectiveState( "prim3", OBJECTIVE_FAILED );
				OBJECTIVES.state.buildGrail[2] = 11;
			end
		end    
	end,

	_IsGodricAtExit = function( hero )
		if hero == 'Godric' then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "exit", nil );
			OBJECTIVES.state.sendGodric[2] = 3;
		end
	end,

	sendGodric = function()
		if OBJECTIVES.state.sendGodric[2] == 1 and OBJECTIVES.state.buildGrail[2] == 10 then
			CINEMATICS.sendGodricOnMission();
			SetObjectiveState('prim4', OBJECTIVE_ACTIVE);
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "exit", "OBJECTIVES._IsGodricAtExit" );
			local balors     = (2 - crap) * 15;
			local nightmares = (2 - crap) * 25;
			local succubus   = (2 - crap) * 40;
			if balors > 0 then		RemoveObjectCreatures( 'garrison', CREATURE_BALOR, balors ); end
			if nightmares > 0 then 	RemoveObjectCreatures( 'garrison', CREATURE_NIGHTMARE, nightmares ); end
			if succubus > 0 then	RemoveObjectCreatures( 'garrison', CREATURE_INFERNAL_SUCCUBUS, succubus ); end
			OBJECTIVES.state.sendGodric[2] = 2;
		elseif OBJECTIVES.state.sendGodric[2] == 3 then
			SaveHeroAllSetArtifactsEquipped("Godric", "C1M5");
			sleep(40);
			MoveHeroRealTime( "Godric", 134, 11, 0 );
			local n = 0;
			while GetObjectPos( "Godric" ) ~= 134 do
				n = n + 1;
				sleep( 5 );
				if (n > 30 ) then
					break
				end
			end
			RemoveObject("Godric");
			sleep( 2 );
			CINEMATICS.godricLeaves();
			SetObjectiveState( "prim4", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.joinNikolai[2] = 1;
			OBJECTIVES.state.sendGodric[2] = 10;
		end
	end,

	isAlive = function()
	-- start of this task is handled by C1M5.xdb
		if ( IsHeroAlive('Godric') == nil and OBJECTIVES.state.sendGodric[2] < 3 ) or (IsHeroAlive('Isabell') == nil and ( OBJECTIVES.state.rescueIsabell[2] >= 5 or GetDate(ABSOLUTE_DAY) > 14 )) then
			SetObjectiveState( 'prim6', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,

	moveNikolay = 999,
	joinNikolai = function()
		if OBJECTIVES.state.joinNikolai[2] == 1 then
			OBJECTIVES.moveNikolay = GetDate(ABSOLUTE_DAY) + 1;
			DeployReserveHero( 'Agrael', 117, 46, GROUND );
			EnableHeroAI( 'Agrael', nil );
			C1M5_ASSAULT_ARMY.Agrael(1);
			OBJECTIVES.state.joinNikolai[2] = 2;
		elseif OBJECTIVES.state.joinNikolai[2] == 2 and OBJECTIVES.moveNikolay <= GetDate(ABSOLUTE_DAY) then
			DeployReserveHero( 'Nicolai', 133, 12, 0 );
			sleep(5);
			EnableHeroAI( 'Nicolai', not nil );
			MoveHero('Nicolai', 121, 32, 0 );
			OBJECTIVES.moveNikolay = GetDate(ABSOLUTE_DAY) + 1;
			OBJECTIVES.state.joinNikolai[2] = 3;
		elseif OBJECTIVES.state.joinNikolai[2] == 3 and OBJECTIVES.moveNikolay <= GetDate(ABSOLUTE_DAY) then
			CINEMATICS.isabellJoinNikolai();
			SetObjectiveState( 'prim5', OBJECTIVE_ACTIVE );
			EnableHeroAI( 'Nicolai', nil );
			OBJECTIVES.moveNikolay = GetDate(ABSOLUTE_DAY) + 1;
			OBJECTIVES.state.joinNikolai[2] = 4;
		elseif OBJECTIVES.state.joinNikolai[2] == 4 and OBJECTIVES.moveNikolay <= GetDate(ABSOLUTE_DAY) then
			if IsObjectExists('Agrael') then
				EnableHeroAI( 'Agrael', not nil );
				sleep(5);
				if IsHeroAlive("Nicolai") ~= nil then
					local x, y, z = GetObjectPosition("Nicolai");
					MoveHeroRealTime("Agrael", x, y, z );
				end
			end
			sleep( 10 );
			if IsHeroAlive("Nicolai") == nil or GetDate(ABSOLUTE_DAY) > OBJECTIVES.moveNikolay + 3 then
				SetObjectiveState( "prim5", OBJECTIVE_COMPLETED );
				OBJECTIVES.state.joinNikolai[2] = 10;
			elseif IsHeroAlive("Agrael") == nil then
			  -- think of something
			end
		end
	end,
	
	garrisonReinforcements_day = 0,
	garrisonReinforcements = function()
		if OBJECTIVES.state.garrisonReinforcements[2] == 1 and OBJECTIVES.garrisonReinforcements_day <= OBJECTIVES.date then
			AddObjectCreatures("Garnison", CREATURE_ARCHDEVIL , 5);
			AddObjectCreatures("Garnison", CREATURE_BALOR , 10);
			AddObjectCreatures("Garnison", CREATURE_FRIGHTFUL_NIGHTMARE , 15);
			AddObjectCreatures("Garnison", CREATURE_INFERNAL_SUCCUBUS , 20);
			print("Garnison reinforced!");
			OBJECTIVES.garrisonReinforcements_day = OBJECTIVES.date + 1;
		end
	end
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( TUTORIALS.run );
startThread( H55c_AI_main );

------------------ DEBUG ------------------------
function c1m5_debug(state)

	H55c_fog();
	if state == 1 then
		AddHeroCreatures( "Godric", CREATURE_INFERNAL_SUCCUBUS, 400 );
		SetObjectPosition("Godric", 26, 103, 0)
	end

	if state == 2 then
		SetObjectPosition("Agrael", 35, 100, 0)
	end
	
	if state == 3 then
		OBJECTIVES.assaultDay = GetDate(ABSOLUTE_DAY) + 1;
	end
	
	if state == 4 then
		MakeHeroInteractWithObject("Godric", "t3_1");
		sleep(20);
		MakeHeroInteractWithObject("Godric", "t3_2");
		sleep(20);
		MakeHeroInteractWithObject("Godric", "t3_4");
	end
end
