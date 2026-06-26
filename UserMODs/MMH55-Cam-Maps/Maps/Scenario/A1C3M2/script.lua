doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_PlayerStatus = {0,1,2,2,2,2,2,2};
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
	InitAllSetArtifacts("A1C3M2");
	LoadHeroAllSetArtifacts( "Shadwyn", "A1C3M1" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Shadwyn" );
end

startThread(H55_InitSetArtifacts);

function checkBushes()
	if ( random( 2 ) == 1 ) then
		MessageBox ("Maps/Scenario/A1C3M2/d2.txt");
		SetPlayerResource(PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) + 500);
	else
		MessageBox ("Maps/Scenario/A1C3M2/d3.txt");
	end
end

function Ambush( hero )
	if hero == "Shadwyn" then
		SetObjectPosition( hero, 9, 67, 0 );
		QuestionBox("Maps/Scenario/A1C3M2/sp_mess1.txt", "EngageAmbush");
	end
end

function EngageAmbush() 
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "zone",nil);
	StartCombat("Shadwyn",nil,4,CREATURE_MUMMY,3,CREATURE_MUMMY,2,CREATURE_MUMMY,3,CREATURE_MUMMY,2,nil);
end

CINEMATICS = {
	intro = function()
		StartAdvMapDialog( 0 );
		sleep( 2 );
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/A1C3/M2/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

DIFFICULTY = {
	[0] = function()
		AddHeroCreatures("Shadwyn", CREATURE_BLACK_DRAGON, 1);
		AddObjectCreatures("R_01", CREATURE_SCOUT, 20);
		AddObjectCreatures("R_01", CREATURE_WITCH, 10);
		AddObjectCreatures("R_01", CREATURE_MINOTAUR, 5);		
		
		AddObjectCreatures("R_02", CREATURE_ASSASSIN, 40);
		AddObjectCreatures("R_02", CREATURE_BLOOD_WITCH, 20);
		AddObjectCreatures("R_02", CREATURE_RIDER, 10);
		AddObjectCreatures("R_02", CREATURE_HYDRA, 5);
		AddObjectCreatures("R_02", CREATURE_MINOTAUR, 15);
		
		AddObjectCreatures("R_03", CREATURE_ASSASSIN, 120);
		AddObjectCreatures("R_03", CREATURE_MINOTAUR_KING, 40);
		AddObjectCreatures("R_03", CREATURE_BLOOD_WITCH, 80);
		AddObjectCreatures("R_03", CREATURE_RAVAGER, 30);
		AddObjectCreatures("R_03", CREATURE_MATRIARCH, 6);
		AddObjectCreatures("R_03", CREATURE_CHAOS_HYDRA, 18);
		RemoveObject("Skelet");
		sleep(10);
		CreateArtifact("Sword", ARTIFACT_SWORD_OF_RUINS, 129, 14, 0);
	    print ("normal");
	end,
	
	[1] = function()
		AddObjectCreatures("R_01", CREATURE_SCOUT, 40);
		AddObjectCreatures("R_01", CREATURE_WITCH, 20);
		AddObjectCreatures("R_01", CREATURE_MINOTAUR, 10);		
		
		AddObjectCreatures("R_02", CREATURE_ASSASSIN, 80);
		AddObjectCreatures("R_02", CREATURE_BLOOD_WITCH, 40);
		AddObjectCreatures("R_02", CREATURE_RIDER, 20);
		AddObjectCreatures("R_02", CREATURE_HYDRA, 10);
		AddObjectCreatures("R_02", CREATURE_MINOTAUR, 30);
		
		AddObjectCreatures("R_03", CREATURE_ASSASSIN, 240);
		AddObjectCreatures("R_03", CREATURE_MINOTAUR_KING, 80);
		AddObjectCreatures("R_03", CREATURE_BLOOD_WITCH, 130);
		AddObjectCreatures("R_03", CREATURE_RAVAGER, 50);
		AddObjectCreatures("R_03", CREATURE_MATRIARCH, 16);
		AddObjectCreatures("R_03", CREATURE_CHAOS_HYDRA, 28);
		RemoveObject("k1");
		RemoveObject("k2");
		RemoveObject("k3");
	    print ("hard");
	end,
	
	[2] = function()
		AddObjectCreatures("R_01", CREATURE_SCOUT, 60);
		AddObjectCreatures("R_01", CREATURE_WITCH, 30);
		AddObjectCreatures("R_01", CREATURE_MINOTAUR, 15);		
		
		AddObjectCreatures("R_02", CREATURE_ASSASSIN, 120);
		AddObjectCreatures("R_02", CREATURE_BLOOD_WITCH, 60);
		AddObjectCreatures("R_02", CREATURE_RIDER, 30);
		AddObjectCreatures("R_02", CREATURE_HYDRA, 15);
		AddObjectCreatures("R_02", CREATURE_MINOTAUR, 45);
		
		AddObjectCreatures("R_03", CREATURE_ASSASSIN, 320);
		AddObjectCreatures("R_03", CREATURE_MINOTAUR_KING, 110);
		AddObjectCreatures("R_03", CREATURE_BLOOD_WITCH, 180);
		AddObjectCreatures("R_03", CREATURE_RAVAGER, 80);
		AddObjectCreatures("R_03", CREATURE_MATRIARCH, 26);
		AddObjectCreatures("R_03", CREATURE_CHAOS_HYDRA, 48);
		
		RemoveObject("k1");
		RemoveObject("k2");
		RemoveObject("k3");
	    print ("heroic");
	end,
		
	[3] = function()
		AddObjectCreatures("R_01", CREATURE_SCOUT, 80);
		AddObjectCreatures("R_01", CREATURE_WITCH, 40);
		AddObjectCreatures("R_01", CREATURE_MINOTAUR, 20);		
		
		AddObjectCreatures("R_02", CREATURE_ASSASSIN, 160);
		AddObjectCreatures("R_02", CREATURE_BLOOD_WITCH, 80);
		AddObjectCreatures("R_02", CREATURE_RIDER, 40);
		AddObjectCreatures("R_02", CREATURE_HYDRA, 20);
		AddObjectCreatures("R_02", CREATURE_MINOTAUR, 60);
		
		AddObjectCreatures("R_03", CREATURE_ASSASSIN, 420);
		AddObjectCreatures("R_03", CREATURE_MINOTAUR_KING, 160);
		AddObjectCreatures("R_03", CREATURE_BLOOD_WITCH, 280);
		AddObjectCreatures("R_03", CREATURE_RAVAGER, 110);
		AddObjectCreatures("R_03", CREATURE_MATRIARCH, 36);
		AddObjectCreatures("R_03", CREATURE_CHAOS_HYDRA, 68);
		RemoveObject("k1");
		RemoveObject("k2");
		RemoveObject("k3");	
	    print ("Impossible");
	end,
}

OBJECTIVES = {
	state = {
		isAlive 	   = { "prim1", 1 }, -- Shadwyn must survive
		firstGarrison  = { "prim2", 1 }, -- Pass first garrison in 2 weeks
		secondGarrison = { "prim3", 1 }, -- Pass second garrison in 3 weeks
		thirdGarrison  = { "prim4", 1 }, -- Pass third garrison in 4 weeks
		eventManager   = {	   "_", 1 }, -- Manages enemy hero deployment over time
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

    prepare = function()
		SetPlayerStartResources( PLAYER_1, 0, 0, 0, 0, 0, 0, 500 );
		CINEMATICS.intro();
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "zone","Ambush" );
		startThread(DIFFICULTY[GetDifficulty()]);
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

			if GetObjectiveState("prim1") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3") == OBJECTIVE_COMPLETED and GetObjectiveState("prim4") == OBJECTIVE_COMPLETED then
				SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED );
				SaveHeroAllSetArtifactsEquipped("Shadwyn", "A1C3M2");
				sleep(100);
				CINEMATICS.outro();
				sleep(80);
				Win();
			end
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 and IsHeroAlive("Shadwyn") == nil then
			SetObjectiveState( 'prim1', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	firstGarrison = function()
		if OBJECTIVES.state.firstGarrison[2] == 1 then
			SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.firstGarrison[2] = 2;
		elseif OBJECTIVES.state.firstGarrison[2] == 2 and GetObjectOwner("R_01") == PLAYER_1 then
			SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
			SetRegionBlocked(   "R1", 1, PLAYER_2 );
			SetRegionBlocked( "R1_1", 1, PLAYER_1 );
			OBJECTIVES.state.firstGarrison[2] = 10;
		end
	end,
	
	secondGarrison = function()
		if OBJECTIVES.state.secondGarrison[2] == 1 and OBJECTIVES.state.firstGarrison[2] == 10 then
			SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.secondGarrison[2] = 2;
		elseif OBJECTIVES.state.secondGarrison[2] == 2 and GetObjectOwner("R_02") == PLAYER_1 then
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
			SetRegionBlocked(   "R2", 1, PLAYER_2 );
			SetRegionBlocked( "R2_2", 1, PLAYER_1 );
			OBJECTIVES.state.secondGarrison[2] = 10;
		end
	end,
	
	thirdGarrison = function()
		if OBJECTIVES.state.thirdGarrison[2] == 1 and OBJECTIVES.state.secondGarrison[2] == 10 then
			SetObjectiveState( 'prim4', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.thirdGarrison[2] = 2;
		elseif OBJECTIVES.state.thirdGarrison[2] == 2 and GetObjectOwner("R_03") == PLAYER_1 then
			SetObjectiveState( 'prim4', OBJECTIVE_COMPLETED );
			SetRegionBlocked(   "R3", 1, PLAYER_2 );
			SetRegionBlocked( "R3_3", 1, PLAYER_1 );
			OBJECTIVES.state.thirdGarrison[2] = 10;			
		end
	end,
	
	eventManager = function()
		if OBJECTIVES.state.eventManager[2] == 1 and OBJECTIVES.date >= 3 then			-- month 1, week 1, day 3
			QuestionBox("Maps/Scenario/A1C3M2/d1.txt", "checkBushes");					-- Check bush event
			OBJECTIVES.state.eventManager[2] = 2;
		elseif OBJECTIVES.date >= 14 and OBJECTIVES.state.eventManager[2] == 2 then		-- month 1, week 2 day 7
			MessageBox ("Maps/Scenario/A1C3M2/mes1.txt");								-- Warning: 1 hero arrives
			OBJECTIVES.state.eventManager[2] = 3;
		elseif OBJECTIVES.date >= 15 and OBJECTIVES.state.eventManager[2] == 3 then		-- month 1, week 3 day 1
			DeployReserveHero( "Eruina", 121, 6, GROUND );
			GiveExp( "Eruina", 10000 );
			OBJECTIVES.state.eventManager[2] = 4; 
		elseif OBJECTIVES.date >= 21 and OBJECTIVES.state.eventManager[2] == 4 then		-- month 1, week 3 day 7
			if IsHeroAlive ("Eruina") ~= nil then
				pcall( MoveHero, "Eruina", 105, 59, 0 );
			end
			OBJECTIVES.state.eventManager[2] = 5; 
		elseif OBJECTIVES.date >= 35 and OBJECTIVES.state.eventManager[2] == 5 then		-- month 2, week 1 day 7
			MessageBox ("Maps/Scenario/A1C3M2/mes1.txt");								-- Warning: 2 hero arrives
			OpenCircleFog( 122, 128, 0, 6, PLAYER_1 );
			OBJECTIVES.state.eventManager[2] = 6;
		elseif OBJECTIVES.date >= 36 and OBJECTIVES.state.eventManager[2] == 6 then 	-- month 2, week 2 day 1
			DeployReserveHero( "Ohtar", 123, 130, GROUND );
			OpenCircleFog( 123, 130, 0, 6, PLAYER_1 ); 
			GiveExp( "Ohtar", 15000 );
			OBJECTIVES.state.eventManager[2] = 7;
		elseif OBJECTIVES.date >= 42 and OBJECTIVES.state.eventManager[2] == 7 then		-- month 2, week 2, day 7
			if IsHeroAlive("Ohtar") ~= nil then
				pcall(MoveHero, "Ohtar", 61, 76, 0 );
			end
			OBJECTIVES.state.eventManager[2] = 8;
		elseif OBJECTIVES.date >= 63 and OBJECTIVES.state.eventManager[2] == 8 then		-- month 3, week 1, day 7
			MessageBox ("Maps/Scenario/A1C3M2/mes1.txt");								-- Warning: 3 hero arrives
			OpenCircleFog( 13, 8, 0, 6, PLAYER_1 );
			OBJECTIVES.state.eventManager[2] = 9;
		elseif OBJECTIVES.date >= 64 and OBJECTIVES.state.eventManager[2] == 9 then		-- month 3, week 2, day 1
			DeployReserveHero( "Ferigl", 13, 6, GROUND );
			OpenCircleFog( 13, 6, 0, 6, PLAYER_1 );
			GiveExp( "Ferigl", 20000 );
		end
	end,
}	

------------------- MAIN ------------------------
startThread(OBJECTIVES.start);

-- ### Unused working messages
-- ShowFlyingSign("Maps/Scenario/A1C3M2/sp1.txt", "Shadwyn", -1, 3.0); --!!!