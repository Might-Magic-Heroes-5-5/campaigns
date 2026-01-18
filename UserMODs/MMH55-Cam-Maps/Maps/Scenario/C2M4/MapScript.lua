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
end

startThread(H55_InitSetArtifacts);

Priority = 0;

EnableHeroAI("Elleshar",nil);
EnableAIHeroHiring(PLAYER_2,"imarium",nil);
SetObjectEnabled("dragons",nil);

SetRegionBlocked("gate1",1,2);
SetRegionBlocked("gate2",1,2);
SetRegionBlocked("gate3",1,2);
SetRegionBlocked("gate4",1,2);
SetRegionBlocked("gate5",1,2);
SetRegionBlocked("tavern1",1,2);
SetRegionBlocked("tavern2",1,2);
SetRegionBlocked("devils",1,2);
SetRegionBlocked("border1",1,2);
SetRegionBlocked("border2",1,2);
SetRegionBlocked("border3",1,2);
SetRegionBlocked("border4",1,2);
SetRegionBlocked("border5",1,2);
SetRegionBlocked("gate_u1",1,3);
SetRegionBlocked("gate_u2",1,3);
SetRegionBlocked("gate_u3",1,3);
SetRegionBlocked("gate_u4",1,3);
SetRegionBlocked("gate_u5",1,3);
SetRegionBlocked("garrison",1,3);
SetRegionBlocked("garrison",1,2);
SetRegionBlocked("Dragons",1,2);
SetRegionBlocked("Dragons",1,3);


SetPlayerStartResource(PLAYER_1,WOOD,10);
SetPlayerStartResource(PLAYER_1,ORE,10);
SetPlayerStartResource(PLAYER_1,CRYSTAL,2);
SetPlayerStartResource(PLAYER_1,SULFUR,2);
SetPlayerStartResource(PLAYER_1,MERCURY,2);
SetPlayerStartResource(PLAYER_1,GEM,2);
SetPlayerStartResource(PLAYER_1,GOLD,20000);

SetPlayerResource(PLAYER_2,WOOD,10);
SetPlayerResource(PLAYER_2,ORE,10);
SetPlayerResource(PLAYER_2,CRYSTAL,2);
SetPlayerResource(PLAYER_2,SULFUR,2);
SetPlayerResource(PLAYER_2,MERCURY,2);
SetPlayerResource(PLAYER_2,GEM,2);
SetPlayerResource(PLAYER_2,GOLD,10000);

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

function ErewelReinforcements()
	if GetDifficulty() == DIFFICULTY_EASY then
		print("Difficulty level is NORMAL. Reinforcements did not add");
		AddObjectCreatures("imarium",CREATURE_PIXIE, 7);
		AddObjectCreatures("imarium",CREATURE_GRAND_ELF, 5);
		AddObjectCreatures("imarium",CREATURE_DRUID_ELDER, 4);
		AddObjectCreatures("imarium",CREATURE_WAR_DANCER, 5);
		AddObjectCreatures("imarium",CREATURE_WAR_UNICORN, 1);
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		print("Difficulty level is NORMAL. Reinforcements did not add");
		AddObjectCreatures("imarium",CREATURE_PIXIE, 10);
		AddObjectCreatures("imarium",CREATURE_GRAND_ELF, 8);
		AddObjectCreatures("imarium",CREATURE_DRUID_ELDER, 4);
		AddObjectCreatures("imarium",CREATURE_WAR_DANCER, 7);	
		AddObjectCreatures("imarium",CREATURE_WAR_UNICORN, 3);
		AddObjectCreatures("imarium",CREATURE_TREANT_GUARDIAN, 1);
	elseif GetDifficulty() == DIFFICULTY_HARD then
		print("Difficulty level is HARD. Reinforcements added...");
		AddObjectCreatures("imarium",CREATURE_PIXIE, 15);
		AddObjectCreatures("imarium",CREATURE_GRAND_ELF, 12);
		AddObjectCreatures("imarium",CREATURE_DRUID_ELDER, 6);
		AddObjectCreatures("imarium",CREATURE_WAR_DANCER, 10);	
		AddObjectCreatures("imarium",CREATURE_WAR_UNICORN, 4);
		AddObjectCreatures("imarium",CREATURE_TREANT_GUARDIAN, 2);
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		print("Difficulty level is HEROIC. Reinforcements added...");
		AddObjectCreatures("imarium",CREATURE_PIXIE, 20);
		AddObjectCreatures("imarium",CREATURE_GRAND_ELF, 16);
		AddObjectCreatures("imarium",CREATURE_DRUID_ELDER, 8);
		AddObjectCreatures("imarium",CREATURE_WAR_DANCER, 14);	
		AddObjectCreatures("imarium",CREATURE_WAR_UNICORN, 6);
		AddObjectCreatures("imarium",CREATURE_TREANT_GUARDIAN, 3);
	end
end

function EnemyGate()
	print("Thread Enemy Gate has been started...");
	while 1 do
		sleep(10);
		if GetDate(WEEK) == 3 then
			SetRegionBlocked("border1",0,2);
			SetRegionBlocked("border2",0,2);
			SetRegionBlocked("border3",0,2);
			SetRegionBlocked("border4",0,2);
			print("Now is a third week. Gate to the enemy has been opened.");
			break;
		end
	end
end

OBJECTIVES = {
	state = {
		captureImarium   	= { "prim1",            1 }, -- Capture town of Imarium
		isAlive				= { "prim2",            1 }, -- Agrael must survive
		captureInfernoTown 	= { "sec_capture_town", 1 }, -- Capture Inferno town of 
		dragons				= { "sec_dragons",	    0 }, -- Bring archers to Dragons
		desentir			= { "_",			    1 }, -- Elven Desentir trigger
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		H55_CamFixTooManySkills(PLAYER_1,"Agrael");
		startThread(EnemyGate);
		Trigger(OBJECT_TOUCH_TRIGGER, "dragons", "DialogBeforeCombatVSdragons", nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Dragons", "OBJECTIVES._dragons_active");
		startThread(AIPressingTownHolin,"Diraya");
		CINEMATICS.intro();
	end,
	
	run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					OBJECTIVES[key]();
				end
			end

			if GetObjectiveState("prim2") == OBJECTIVE_FAILED then
				Loose();
			end
			
			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Agrael", "C2M4");
				sleep(5);
				CINEMATICS.outro();
				sleep(10);
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
				ErewelReinforcements();
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
			OBJECTIVES.state.desentir[2] = 1;
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
				RemoveHeroCreatures("Agrael", CREATURE_WOOD_ELF, 10000);
				RemoveHeroCreatures("Agrael", CREATURE_GRAND_ELF, 10000);
				RemoveHeroCreatures("Agrael", CREATURE_SHARP_SHOOTER, 10000);
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
	
	_desentir_day = 999,
	desentir = function()
		if OBJECTIVES.state.desentir[2] == 1 then
			OBJECTIVES._desentir_day = OBJECTIVES.date + 1;
			OBJECTIVES.state.desentir[2] = 2;
		elseif OBJECTIVES.state.desentir[2] == 2 and OBJECTIVES._desentir_day <= OBJECTIVES.date then
			for i=1,21 do
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
			OBJECTIVES._desentir_day = OBJECTIVES.date + 1;
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
	StartCombat(HeroName, nil,3,CREATURE_SHADOW_DRAGON,11,CREATURE_SHADOW_DRAGON,11,CREATURE_SHADOW_DRAGON,11,nil,"FinishCombat");
end

function FinishCombat(heroname,result)
	print("Thread FinishCombat has been started");
	if result == not nil then
		OBJECTIVES.state.dragons[2] = 4;
	end
end

function AIPressingTownHolin(heroname)
	print("Thread AIPressingTownHolin has been started...")
	repeat
		sleep(20);
	until GetObjectOwner("holin") == PLAYER_1;
	print("Town Holin has been captured by Player");
	if IsHeroAlive(heroname) == not nil then
		H55c_AIAddHero(heroname);
	end
end

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
startThread( H55c_AI_main )
