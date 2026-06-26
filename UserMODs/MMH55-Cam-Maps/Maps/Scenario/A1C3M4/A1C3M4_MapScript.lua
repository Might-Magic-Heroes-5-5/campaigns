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
  player2 = {
      state = 2,
	  heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = 0.05, towns = 1.0, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes =  1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
	    { priority = 1.0, heroes =  1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
    }
  },
  player3 = {
      state = 1,
	  heroes = {},
  	  enemies = {},
  }
}

H55_PlayerStatus = {0,1,1,2,2,2,2,2};
H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_DRAGON_SCALE_ARMOR,
	ARTIFACT_DRAGON_SCALE_SHIELD,
	ARTIFACT_DRAGON_BONE_GRAVES,
	ARTIFACT_DRAGON_WING_MANTLE,
	ARTIFACT_DRAGON_TEETH_NECKLACE,
	ARTIFACT_DRAGON_TALON_CROWN,
	ARTIFACT_DRAGON_EYE_RING,
	ARTIFACT_DRAGON_FLAME_TONGUE
};

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C3M4");
	LoadHeroAllSetArtifacts( "Shadwyn", "A1C3M3" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Shadwyn" );
end

startThread(H55_InitSetArtifacts);

ENEMY = {{"Eruina",0},
		 {"Menel",0},
		 {"Dalom",0},
		 {"Ohtar",0},
		 {"Segref",0},
		 {"Inagost",0},
		 {"Almegir",0},
		 {"Urunir",0}
		};
LEFT_DEPLOY_POINTS = {{5,105},{17,128},{48,126}};
RIGHT_DEPLOY_POINTS = {{97,126},{120,125},{129,96}};
print("Constants defined");

function setBlackDragonsQuantity( quantity )
	RemoveObjectCreatures( "Dragons", CREATURE_BLACK_DRAGON, GetObjectCreatures("Dragons", CREATURE_BLACK_DRAGON)-1 );
	sleep(20);
	AddObjectCreatures( "Dragons", CREATURE_BLACK_DRAGON, quantity );
end

function startInitial()
	sleep(10);
	MoveHeroRealTime("Shadwyn",83,15);
end

function showDragons()
	BlockGame();
	Trigger(OBJECT_TOUCH_TRIGGER,"HutOfMagi",nil);
	OBJECTIVES.state.findDragon[2] = 1;
end

function AreEnemyHeroesDefeated()
	for i=1,8 do
		if ENEMY[i][2] == 0 then return nil; end
	end
	return 1;
end

function A1C3M4_markHeroDefeated( looser, winner )
	for i=1,table.length(ENEMY) do
		if ENEMY[i][1] == looser then
			 print(looser.." is defeated!");
			 ENEMY[i][2] = 1;
			 break
		end
	end
end

function deployReservedHero( hero, deployX, deployY, factor )
	DeployReserveHero( hero, deployX, deployY, UNDERGROUND );
	sleep(10);
	H55c_AIAddHero( hero );
	SetHeroRoleMode( hero, HERO_ROLE_MODE_HERMIT );
	addCreatures( hero, factor, math.random(0, 1));
	print("hero ",hero," deployed on the map");
end

function addCreatures( hero, factor, set )
	if set == 0 then
		AddHeroCreatures( hero,         CREATURE_ASSASSIN, 20*factor);
		AddHeroCreatures( hero,      CREATURE_BLOOD_WITCH, 15*factor);
		AddHeroCreatures( hero,    CREATURE_MINOTAUR_KING,  10*factor);
		AddHeroCreatures( hero,          CREATURE_RAVAGER,  7*factor);
		AddHeroCreatures( hero,  CREATURE_SHADOW_MISTRESS,  4*factor);
	else
		AddHeroCreatures( hero,          CREATURE_STALKER, 20*factor);
		AddHeroCreatures( hero,    CREATURE_BLOOD_WITCH_2,  15*factor);
		AddHeroCreatures( hero, CREATURE_MINOTAUR_CAPTAIN,  10*factor);
		AddHeroCreatures( hero,      CREATURE_BLACK_RIDER,  7*factor);
		AddHeroCreatures( hero,        CREATURE_MATRIARCH,  4*factor);
	end
end

function dwarvenTownReward( oldOwner, newOwner, heroName )
	if newOwner == PLAYER_1 then
		Trigger( OBJECT_CAPTURE_TRIGGER, "dwarven_town", nil );
		GiveArtefact( heroName, ARTIFACT_DWARVEN_MITHRAL_CUIRASS );
		GiveArtefact( heroName, ARTIFACT_DWARVEN_MITHRAL_GREAVES );
		GiveArtefact( heroName, ARTIFACT_DWARVEN_MITHRAL_HELMET );
		GiveArtefact( heroName, ARTIFACT_DWARVEN_MITHRAL_SHIELD );
		print( "Dwarven town has been captured by player's hero ", heroName );
	end
end

function BTAreward( heroName )
	if HasHeroSkill( heroName, PERK_SCOUTING ) == not nil then
		Trigger( OBJECT_TOUCH_TRIGGER, "BTA", nil );
		ChangeHeroStat( heroName, STAT_KNOWLEDGE, 4);
		ChangeHeroStat( heroName, STAT_SPELL_POWER, 4);
		ShowFlyingSign("Maps/Scenario/A1C3M4/FlyingMessage_PlusStats.txt", heroName, -1, 5);
	else
		Trigger( OBJECT_TOUCH_TRIGGER, "BTA", "BTAreward" );
	end
end

function dragonTeleportMessageBox()
	if OBJECTIVES.state.findDragon[2] < 10 then
		QuestionBox("Maps/Scenario/A1C3M4/ShureEnterTeleport_MsgBox.txt","teleportRequest");
	end
end

function teleportRequest()
	SetObjectEnabled("dragon_teleport",not nil);
	Trigger(OBJECT_TOUCH_TRIGGER,"dragon_teleport",nil);
end

function dragonsFound( hero )
	Trigger( OBJECT_TOUCH_TRIGGER, "Dragons", nil);
	LevelUpHero( hero );
	OBJECTIVES.state.findDragon[2] = 3;
end

function AfterDialogScene0()
	startThread(startInitial);
end

function deploySoulscarHeroes()
	local factor = OBJECTIVES.date/7 + GetDifficulty();
	local j = 0;
	for i=1,table.length(ENEMY) do
		if IsHeroAlive( ENEMY[i][1] ) == nil and ENEMY[i][2] == 0 then 
			j = j+1;
			if mod(j,2) == 0 then
				local coordsL = math.random(table.length(LEFT_DEPLOY_POINTS));
				deployReservedHero( ENEMY[i][1], LEFT_DEPLOY_POINTS[coordsL][1], LEFT_DEPLOY_POINTS[coordsL][2], factor );
			else
				local coordsR = math.random(table.length(RIGHT_DEPLOY_POINTS));
				deployReservedHero( ENEMY[i][1], RIGHT_DEPLOY_POINTS[coordsR][1], RIGHT_DEPLOY_POINTS[coordsR][2], factor );
			end
		end
		if j == 2 then break; end
	end
	sleep(10);
end

CINEMATICS = {
	intro = function()
		StartAdvMapDialog( 0, "AfterDialogScene0" );
		sleep( 2 );
    end,
	
	findDragonStart = function()
		MoveCamera(124,13,UNDERGROUND,30,0.6,3.14,0,0);
		sleep(60);
		OpenCircleFog(123,16,UNDERGROUND,12,PLAYER_1);
		sleep(120);
		MoveCamera(83,15,UNDERGROUND,50,1.4,0,0,0);
		UnblockGame();
    end,
	
	findDragonFinish = function()
		StartDialogScene("/DialogScenes/A1C3/M4/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	outro = function()
		StartDialogScene("/DialogScenes/A1C3/M4/S2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end
}

DIFFICULTY = {
	[0] = function()
	    SetPlayerStartResources(PLAYER_1, 30, 30, 10, 10, 10, 10, 20000);
		setBlackDragonsQuantity(120);
	end,
	[1] = function()
		SetPlayerStartResources(PLAYER_1, 25, 25, 7, 7, 7, 7, 15000);
		setBlackDragonsQuantity(100);
	end,
	[2] = function()
		SetPlayerStartResources(PLAYER_1, 15, 15, 5, 5, 5, 5, 10000);
		setBlackDragonsQuantity(80);
	end,
	[3] = function()
		SetPlayerStartResources(PLAYER_1, 10, 10, 3, 3, 3, 3, 8000);
		setBlackDragonsQuantity(30);
	end,
}

OBJECTIVES = {
	state = {
		defeatThralsai = { 	  "DefeatThralsai", 1 }, -- Defeat Thralsai when he arrives
		isAlive    	   = { "HeroesMustSurvive", 1 }, -- Isabell, Raelag and Shadya must survive
		defendTown 	   = {        "DefendTown", 1 }, -- Do not allow the Dungeon town to fall
		findDragon 	   = {       "Find_Dragon", 0 }, -- Find the Dragons
	},
	
    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		startThread(DIFFICULTY[GetDifficulty()]);
		SetObjectEnabled("HutOfMagi", nil);
		SetObjectEnabled("dragon_teleport", nil);
		EnableAIHeroHiring(PLAYER_3, "dwarven_town", nil);
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "A1C3M4_markHeroDefeated" );
		Trigger(OBJECT_CAPTURE_TRIGGER, "dwarven_town", "dwarvenTownReward");
		Trigger(OBJECT_TOUCH_TRIGGER, "BTA", "BTAreward");
		Trigger(OBJECT_TOUCH_TRIGGER, "dragon_teleport", "dragonTeleportMessageBox");
		Trigger(OBJECT_TOUCH_TRIGGER, "HutOfMagi", "showDragons");
		CINEMATICS.intro();
		Trigger( OBJECT_TOUCH_TRIGGER, "Dragons", "dragonsFound");
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

			if GetObjectiveState("DefendTown") == OBJECTIVE_FAILED or GetObjectiveState("HeroesMustSurvive") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("DefeatThralsai") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Shadwyn", "A1C3M4");
				sleep(100);
				Win();
				return
			end
		end
	end,

	defeatThralsai = function()
		-- start of this task is handled by A1C3M4.xdb
		if OBJECTIVES.state.defeatThralsai[2] == 1 and ( AreEnemyHeroesDefeated() ~= nil or OBJECTIVES.state.findDragon[2] == 10 ) then
			MessageBox("Maps/Scenario/A1C3M4/MsgBox_ThralsaiApproaching.txt");
			DeployReserveHero( "Thralsai", 5, 105, UNDERGROUND);
			sleep(50);
			local coef = GetDifficulty() + 1;
			AddHeroCreatures( "Thralsai",      CREATURE_ASSASSIN, 600 + coef*300 );
			AddHeroCreatures( "Thralsai",   CREATURE_BLOOD_WITCH, 350 + coef*250 );
			AddHeroCreatures( "Thralsai", CREATURE_MINOTAUR_KING, 200 + coef*200 );
			AddHeroCreatures( "Thralsai",       CREATURE_RAVAGER, 100 + coef*100 );
			AddHeroCreatures( "Thralsai",   CREATURE_CHAOS_HYDRA,  80 + coef* 60 );
			AddHeroCreatures( "Thralsai",     CREATURE_MATRIARCH,  70 + coef* 45 );
			ChangeHeroStat( "Thralsai",      STAT_ATTACK, coef*5 );
			ChangeHeroStat( "Thralsai",     STAT_DEFENCE, coef*5 );
			ChangeHeroStat( "Thralsai", STAT_SPELL_POWER, coef*5 );
			ChangeHeroStat( "Thralsai",   STAT_KNOWLEDGE, coef*5 );
			GiveArtefact( "Thralsai", ARTIFACT_ICEBERG_SHIELD );
			GiveArtefact( "Thralsai", ARTIFACT_CROWN_OF_COURAGE );
			H55c_AIAddHero("Thralsai");
			OBJECTIVES.state.defeatThralsai[2] = 2;
		elseif OBJECTIVES.state.defeatThralsai[2] == 2 and IsHeroAlive( "Thralsai" ) == nil then
			CINEMATICS.outro();
			SetObjectiveState( "DefeatThralsai", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.defeatThralsai[2] = 10;
		end
	end,
		
	isAlive = function()
		-- start of this task is handled by A1C3M4.xdb
		if IsHeroAlive("Raelag_A1") == nil or IsHeroAlive("Isabell_A1") == nil or IsHeroAlive("Shadwyn") == nil then
			SetObjectiveState( "HeroesMustSurvive", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	defendTown_day = 7,
	defendTown = function()
		-- start of this task is handled by A1C3M4.xdb
		if OBJECTIVES.state.defendTown[2] == 1 and OBJECTIVES.defendTown_day < OBJECTIVES.date and AreEnemyHeroesDefeated() == nil then
			MessageBox("Maps/Scenario/A1C3M4/MsgBox_EnemyApproach.txt");
			deploySoulscarHeroes();
			OBJECTIVES.defendTown_day = OBJECTIVES.date + (12 - GetDifficulty());
		end

		if GetObjectOwner("iarvain") ~= PLAYER_1 then
			SetObjectiveState( "DefendTown", OBJECTIVE_FAILED );
			OBJECTIVES.state.defendTown[2] = 11;
		end
	end,
	
	findDragon = function()
		if OBJECTIVES.state.findDragon[2] == 1 then
			CINEMATICS.findDragonStart();
			SetObjectiveState("Find_Dragon", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.findDragon[2] = 2;
		elseif OBJECTIVES.state.findDragon[2] == 3 then
			print("You have found dragons!");
			SetObjectiveState("Find_Dragon", OBJECTIVE_COMPLETED);
			SetObjectEnabled("dragon_teleport", not nil);
			Trigger(OBJECT_TOUCH_TRIGGER,"dragon_teleport", nil);
			sleep(15);
			CINEMATICS.findDragonFinish();
			OBJECTIVES.state.findDragon[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start);
startThread( H55c_AI_main );
