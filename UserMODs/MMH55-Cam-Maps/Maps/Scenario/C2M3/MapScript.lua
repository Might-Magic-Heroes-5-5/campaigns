doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C2M3");
    LoadHeroAllSetArtifacts("Agrael", "C2M2" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1, "Agrael" );
end

startThread(H55_InitSetArtifacts);
H55_PlayerStatus = {0,1,2,2,2,2,2,2};
DIFFICULTY = {
	[0] = function()
		print("Difficulty Level is EASY");
		OBJECTIVES.DaysToGillionActivation = 42;
		AddHeroCreatures('Agrael', CREATURE_SUCCUBUS, 20);
		AddHeroCreatures('Agrael', CREATURE_FAMILIAR, 60);
		AddHeroCreatures('Agrael', CREATURE_HELL_HOUND, 20);
		SetTownBuildingLimitLevel("InfernoTown", TOWN_BUILDING_FORT,3);
		SetTownBuildingLimitLevel("Town2", TOWN_BUILDING_FORT,1);
		SetPlayerStartResource(PLAYER_1,WOOD,30);
		SetPlayerStartResource(PLAYER_1,ORE,30);
		SetPlayerStartResource(PLAYER_1,GEM,15);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,15);
		SetPlayerStartResource(PLAYER_1,MERCURY,15);
		SetPlayerStartResource(PLAYER_1,SULFUR,15);
		SetPlayerStartResource(PLAYER_1,GOLD,20000);
	end,
	
	[1] = function()
		print("Difficulty Level is NORMAL");
		OBJECTIVES.DaysToGillionActivation = 35;
		AddHeroCreatures('Agrael', CREATURE_SUCCUBUS, 15);
		AddHeroCreatures('Agrael', CREATURE_FAMILIAR, 30);
		SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_FORT,2);
		SetTownBuildingLimitLevel("InfernoTown",TOWN_BUILDING_FORT,2);
		SetPlayerStartResource(PLAYER_1,WOOD,30);
		SetPlayerStartResource(PLAYER_1,ORE,30);
		SetPlayerStartResource(PLAYER_1,GEM,15);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,15);
		SetPlayerStartResource(PLAYER_1,MERCURY,15);
		SetPlayerStartResource(PLAYER_1,SULFUR,15);
		SetPlayerStartResource(PLAYER_1,GOLD,20000);
	end,
	
	[2] = function()
		print("Difficulty Level is HARD");
		OBJECTIVES.DaysToGillionActivation = 28;
		AddHeroCreatures('Agrael', CREATURE_SUCCUBUS, 4);
		SetPlayerStartResource(PLAYER_1,WOOD,15);
		SetPlayerStartResource(PLAYER_1,ORE,15);
		SetPlayerStartResource(PLAYER_1,GEM,10);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,10);
		SetPlayerStartResource(PLAYER_1,MERCURY,10);
		SetPlayerStartResource(PLAYER_1,SULFUR,10);
		SetPlayerStartResource(PLAYER_1,GOLD,8000);
	end,
	
	[3] = function()
		print("Difficulty Level is HEROIC");
		OBJECTIVES.DaysToGillionActivation = 21;
		SetPlayerStartResource(PLAYER_1,WOOD,10);
		SetPlayerStartResource(PLAYER_1,ORE,10);
		SetPlayerStartResource(PLAYER_1,GEM,5);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,5);
		SetPlayerStartResource(PLAYER_1,MERCURY,5);
		SetPlayerStartResource(PLAYER_1,SULFUR,5);
		SetPlayerStartResource(PLAYER_1,GOLD,5000);
	end,
}

CINEMATICS = {
	attackGilleon = function()
		StartDialogScene("/DialogScenes/C2/M3/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	defeatGillionStart = function()
		StartDialogScene("/DialogScenes/C2/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	defeatGillionFinish = function()
		StartDialogScene("/DialogScenes/C2/M3/D2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	destroySourceStart = function()
		StartDialogScene("/DialogScenes/C2/M3/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	destroySourceDruids = function()
		StartDialogScene("/DialogScenes/C2/M3/R4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

	destroySourceFinish = function()
		StartDialogScene("/DialogScenes/C2/M3/R5/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	captureSylvanTown = function()
		StartDialogScene("/DialogScenes/C2/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

BATTLES = {
	destroySource = {
		start = function(hero)
			local n = 4*GetDate(MONTH)+GetDate(WEEK)+GetDifficulty()*2;
			StartCombat(hero,nil,5,CREATURE_DRUID_ELDER,n,CREATURE_DRUID_ELDER,n,CREATURE_TREANT_GUARDIAN,n,CREATURE_DRUID_ELDER,n,CREATURE_DRUID_ELDER,n,"/Maps/Scenario/C2M3/BattleVSDruids.xdb#xpointer(/Script)",'BATTLES.destroySource.finish')
		end, 

		finish = function(name, result)
			if result == not nil then OBJECTIVES.state.destroySource[2] = 3; end
		end,
	}
}

OBJECTIVES = {
	state = { -- 0 quest is not active or managed by map.xdb, 1 quest is active, 2-9 custom states, 10 success, 11 fail
		attackBorder 		= { "prim0", 1 },   -- Capture Nearby Garrision protected by Gillion
		captureSylvanTowns 	= { "prim1", 0 },   -- capture all 3 Sylvan towns
		defeatGillion 		= { "prim2", 0 },   -- Defeat GiLean once and for all
		destroySource		= { "prim3", 0 },   -- Destroy the source of Sylvan Magic
		isAlive    			= { "prim4", 1 },   -- Agrael must survive
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
	end,

	prepare = function()
		DeployReserveHero("Gillion", 34, 28, GROUND);
		EnableHeroAI("Gillion", nil);
		EnableAIHeroHiring(PLAYER_2, "Town1", nil);
		SetRegionBlocked("blockAI", not nil, PLAYER_2);
		SetRegionBlocked("BorderBlockAI",not nil,PLAYER_2);
		startThread(DIFFICULTY[GetDifficulty()]);
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "druids", "OBJECTIVES._destroySource_activator" );
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

			if GetObjectiveState("prim4") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
				SetObjectiveState('prim4', OBJECTIVE_COMPLETED )
				SaveHeroAllSetArtifactsEquipped("Agrael", "C2M3");
				sleep( 100 );
				Win();
				return
			end
		end
	end,
	
	_attackBorder_activator = function(name)
		if name == 'Agrael' then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "border", nil );
			OBJECTIVES.state.attackBorder[2] = 3;
		end
	end,
	
	attackBorder = function()
	-- Start of this task is handled by C2M3.xdb
		if OBJECTIVES.state.attackBorder[2] == 1 then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "border", "OBJECTIVES._attackBorder_activator" )
			OBJECTIVES.state.attackBorder[2] = 2;
		elseif OBJECTIVES.state.attackBorder[2] == 3 then
			CINEMATICS.attackGilleon();
			x,y = GetObjectPosition("Gillion");
			ChangeHeroStat("Agrael", STAT_MOVE_POINTS, 500);
			MoveHeroRealTime('Agrael', x, y, GROUND);
			EnableHeroAI("Gillion",not nil);
			OBJECTIVES.state.attackBorder[2] = 4;
		elseif OBJECTIVES.state.attackBorder[2] == 4 and IsHeroAlive("Gillion") == nil then
			CINEMATICS.defeatGillionStart();
			sleep(2);
			MessageBox("/Maps/Scenario/C2M3/Message_GilraenDefeated.txt");
			SetObjectiveState( 'prim0', OBJECTIVE_COMPLETED );
			ObjectiveExp("Agrael");
			OBJECTIVES.state.defeatGillion[2] = 1;
			OBJECTIVES.state.captureSylvanTowns[2] = 1;
			OBJECTIVES.state.attackBorder[2] = 10;
		end
	end,
	
	captureSylvanTowns = function()
	-- end of this task is handled by C2M3.xdb
		if OBJECTIVES.state.captureSylvanTowns[2] == 1 then
			SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureSylvanTowns[2] = 2;
		elseif OBJECTIVES.state.captureSylvanTowns[2] == 2 and (GetObjectOwner("Town1") == PLAYER_1 or GetObjectOwner("Town2") == PLAYER_1 or GetObjectOwner("Town3") == PLAYER_1 ) then
			CINEMATICS.captureSylvanTown();
			OBJECTIVES.state.destroySource[2] = 1;
			OBJECTIVES.state.captureSylvanTowns[2] = 3;
		end
	end,
	
	_defeatGillion_activator = function(hero)
		if hero == "Agrael" then
			Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "Gilraen", nil);
			OBJECTIVES.gilraenAcitve = 1;
		end
	end,
	
	gilraenAcitve = 0,
	DaysToGillionActivation = 999,
	defeatGillion = function()
	-- end of this task is handled by C2M3.xdb
		if OBJECTIVES.state.defeatGillion[2] == 1 then
			Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "Gilraen", "OBJECTIVES._defeatGillion_activator" );
			DeployReserveHero("Gillion", 115, 95, GROUND);
			EnableHeroAI("Gillion", nil);
			SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
			local army_diff = GetDifficulty() + 1;
			AddHeroCreatures("Gillion",   CREATURE_BLADE_JUGGLER, army_diff * 30 ); 
			AddHeroCreatures("Gillion",       CREATURE_GRAND_ELF, army_diff * 20 ); 
			AddHeroCreatures("Gillion",           CREATURE_DRUID, army_diff * 20 );  
			AddHeroCreatures("Gillion",       CREATURE_GRAND_ELF, army_diff * 20 ); 
			AddHeroCreatures("Gillion",   CREATURE_BLADE_JUGGLER, army_diff * 30 ); 
			AddHeroCreatures("Gillion", CREATURE_TREANT_GUARDIAN, army_diff * 10 ); 
			AddHeroCreatures("Gillion",     CREATURE_GOLD_DRAGON, army_diff *  5 );
			OBJECTIVES.DaysToGillionActivation = GetDate(ABSOLUTE_DAY) + OBJECTIVES.DaysToGillionActivation
			OBJECTIVES.state.defeatGillion[2] = 2;
		elseif OBJECTIVES.state.defeatGillion[2] == 2 and (OBJECTIVES.DaysToGillionActivation <= GetDate(ABSOLUTE_DAY) or OBJECTIVES.gilraenAcitve == 1) then
			EnableHeroAI("Gillion", not nil); 
			print("Gillion enabled");
			OBJECTIVES.state.defeatGillion[2] = 3;
		end
		
		if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
			CINEMATICS.defeatGillionFinish();
			ObjectiveExp("Agrael");
			OBJECTIVES.state.defeatGillion[2] = 10;
		end
	end,

	_destroySource_activator = function(name)
		if GetObjectOwner(name) == PLAYER_1 then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "druids", nil );
			CINEMATICS.destroySourceDruids();
			BATTLES.destroySource.start(name);
		end
	end,

	destroySource_day = 0,
	destroySource_power = 0,
	destroySource = function()
		if OBJECTIVES.state.destroySource[2] == 1 and GetDate( DAY_OF_WEEK ) == 1 then
			CINEMATICS.destroySourceStart();
			SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.destroySource[2] = 2;
		elseif OBJECTIVES.state.destroySource[2] == 2 and GetDate( DAY_OF_WEEK ) == 1 and OBJECTIVES.destroySource_day <= GetDate(ABSOLUTE_DAY) then
			OBJECTIVES.destroySource_power = OBJECTIVES.destroySource_power + 1;
			MessageBox("/Maps/Scenario/C2M3/messages/C2M3_C4.txt", 'CreaturesSpawn' );
			OBJECTIVES.destroySource_day = GetDate(ABSOLUTE_DAY) + 1;
		elseif OBJECTIVES.state.destroySource[2] == 3 then
			CINEMATICS.destroySourceFinish();
			if GetObjectiveState("prim3") ~= OBJECTIVE_ACTIVE then
				SetObjectiveState( "prim3", OBJECTIVE_ACTIVE );
				sleep(10);
			end
			SetObjectiveState( "prim3", OBJECTIVE_COMPLETED );
			RemoveObject('drood01');
			RemoveObject('drood02');
			RemoveObject('drood03');
			RemoveObject('drood04');
			RemoveObject('drood05');
			ObjectiveExp("Agrael");
			OBJECTIVES.state.destroySource[2] = 10;
		end
	end,
	
	isAlive = function()
	-- start of this task is handled by C2M3.xdb
		if IsHeroAlive('Agrael') == nil then
			SetObjectiveState( 'prim4', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
}

function CreaturesSpawn(num) 
	--GenerateMonsters(monsterTypeID, countGroupsMin, countGroupsMax, countInGroupMin, countInGroupMax)
	local num = OBJECTIVES.destroySource_power;
	if GetDifficulty() == DIFFICULTY_HEROIC then 
		GenerateMonsters(		CREATURE_SPRITE,  6, 10, 15*num, 30*num);
		GenerateMonsters(	CREATURE_WAR_DANCER,  4,  8,  9*num, 15*num);
		GenerateMonsters(	 CREATURE_GRAND_ELF,  2,  4,  5*num, 8*num);
		print("Druids have spawned monsters. Difficulty is HEROIC");
	elseif GetDifficulty() == DIFFICULTY_HARD then 
		GenerateMonsters(		CREATURE_SPRITE,  6,  9, 10*num, 20*num);
		GenerateMonsters(	CREATURE_WAR_DANCER,  4,  7,  9*num, 15*num);
		GenerateMonsters(	  CREATURE_WOOD_ELF,  2,  3,  5*num, 8*num);
		print("Druids have spawned monsters. Difficulty is HARD");
	elseif GetDifficulty() == DIFFICULTY_NORMAL then 
		GenerateMonsters(		 CREATURE_PIXIE,  5,  8, 22, 30);
		GenerateMonsters(CREATURE_BLADE_JUGGLER,  2,  6, 12, 20);
		GenerateMonsters(	  CREATURE_WOOD_ELF,  1,  2,  5, 8);
		print("Druids have spawned monsters. Difficulty is NORMAL");
	elseif GetDifficulty() == DIFFICULTY_EASY then 
		GenerateMonsters(		 CREATURE_PIXIE,  4,  7, 12, 18);
		GenerateMonsters(CREATURE_BLADE_JUGGLER,  2,  3,  8, 10);
		print("Druids have spawned monsters. Difficulty is EASY");
	end
end

--------------------------SCRIPT MAIN PART-------------------------------------------------------
OBJECTIVES.start();
