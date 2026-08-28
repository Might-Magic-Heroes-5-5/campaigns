doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C6M2");
    LoadHeroAllSetArtifacts( "Zehir", "C6M1" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Zehir" );
end

startThread(H55_InitSetArtifacts);

town_array = {"town1","town2","town3"};
town_array.n = 3;
	
function Town_count()
	local count = 0;
	for i=1, town_array.n do
		if ( GetObjectOwner(town_array[i]) == PLAYER_1 ) then
			count = count + 1;
		end
	end
	return count; 
end


DIFFICULTY = {
	[0] = function()
		print ("normal");
		GiveExp( "Aberrar", 15000 );
	end,
	[1] = function()
		print ("hard");
		GiveExp( "Aberrar", 20000 );
		AddObjectCreatures("nar_ankar", CREATURE_SKELETON_ARCHER, 100);
		AddObjectCreatures("nar_ankar",          CREATURE_ZOMBIE,  80);
		AddObjectCreatures("nar_ankar",           CREATURE_GHOST,  60);
		AddObjectCreatures("nar_ankar",    CREATURE_VAMPIRE_LORD,  40);
		AddObjectCreatures("nar_ankar",        CREATURE_DEMILICH,  25);
		AddObjectCreatures("nar_ankar",         CREATURE_BANSHEE,  10);
		AddObjectCreatures("nar_ankar",   CREATURE_HORROR_DRAGON,   5);
	end,
	[2] = function()
		print ("heroic");
		GiveExp( "Aberrar", 25000 );
		AddObjectCreatures("nar_ankar", CREATURE_SKELETON_ARCHER, 250);
		AddObjectCreatures("nar_ankar",          CREATURE_ZOMBIE, 200);
		AddObjectCreatures("nar_ankar",           CREATURE_GHOST, 120);
		AddObjectCreatures("nar_ankar",    CREATURE_VAMPIRE_LORD,  80);
		AddObjectCreatures("nar_ankar",        CREATURE_DEMILICH,  50);
		AddObjectCreatures("nar_ankar",         CREATURE_BANSHEE,  30);
		AddObjectCreatures("nar_ankar",   CREATURE_HORROR_DRAGON,  15);
	end,
	[3] = function()
		print ("impossible");
		GiveExp( "Aberrar", 30000 );
		AddObjectCreatures("nar_ankar", CREATURE_SKELETON_ARCHER, 500);
		AddObjectCreatures("nar_ankar",          CREATURE_ZOMBIE, 300);
		AddObjectCreatures("nar_ankar",           CREATURE_GHOST, 220);
		AddObjectCreatures("nar_ankar",    CREATURE_VAMPIRE_LORD, 150);
		AddObjectCreatures("nar_ankar",        CREATURE_DEMILICH,  80);
		AddObjectCreatures("nar_ankar",         CREATURE_BANSHEE,  45);
		AddObjectCreatures("nar_ankar",   CREATURE_HORROR_DRAGON,  25);
	end,
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C6/M2/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
		for i=1, town_array.n do
			local x,y,z = GetObjectPosition(town_array[i]);
			OpenCircleFog(x,y,z,6,PLAYER_1);
			sleep( 10 );
		end
	end,
	
	captureCities = function()
		StartDialogScene("/DialogScenes/C6/M2/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	spellsLearned = function()
		StartDialogScene("/DialogScenes/C6/M2/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

	outro = function()
		StartDialogScene("/DialogScenes/C6/M2/D1/DialogScene.xdb#xpointer(/DialogScene)");	
		sleep( 2 );
	end,
}

OBJECTIVES = {
	state = {
		captureCities 	= { "obj1", 1 }, 			-- Capture all 3 silver cities
		upgradeGuild	= { "obj2", 1 }, 			-- Upgrade Magic Guild to level 5 at town
		captureLorekeep	= { "obj3", 1 }, 			-- Capture Markal's town Lorekeep
		isAlive			= { "obj4", 1 }, 			-- Zehir should survive
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		CINEMATICS.intro();
		SetObjectiveVisible("obj3", nil);
		SetRegionBlocked("block_lorekeep", not nil, PLAYER_2);
		SetRegionBlocked("block_lorekeep", not nil, PLAYER_3);
		SetRegionBlocked("block", not nil, PLAYER_2);
		SetRegionBlocked("block", not nil, PLAYER_3);
		startThread(DIFFICULTY[GetDifficulty()]);
		DenyAIHeroFlee('Aberrar', not nil);
		DenyAIHeroFlee('Thant', not nil);
		EnableHeroAI('Thant', nil);
	
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
			
			if GetObjectiveState("obj4") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and GetObjectiveState("obj3") == OBJECTIVE_COMPLETED then
				Save("Scene_17");
				sleep(20);
				SaveHeroAllSetArtifactsEquipped("Zehir", "C6M2");
				CINEMATICS.outro();
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	captureCities = function()
		-- Objective is started by C6M2.xdb
		local owned_towns = Town_count();
		if OBJECTIVES.state.captureCities[2] == 1 and owned_towns == 3 then
			CINEMATICS.captureCities();
			ChangeHeroStat("Zehir", STAT_EXPERIENCE, 2448);
			OBJECTIVES.state.captureCities[2] = 2;
		elseif OBJECTIVES.state.captureCities[2] == 2 and owned_towns == 3 then
			SetObjectiveState("obj1", OBJECTIVE_COMPLETED); 
			OBJECTIVES.state.captureCities[2] = 3;
		elseif OBJECTIVES.state.captureCities[2] == 3 and owned_towns < 3 then
			SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.captureCities[2] = 2;
		end
	end,
	
	upgradeGuild = function()
		-- Objective is started by C6M2.xdb
		if OBJECTIVES.state.upgradeGuild[2] == 1 then
			SetTownBuildingLimitLevel("insar", TOWN_BUILDING_MAGIC_GUILD, 2);
			OBJECTIVES.state.upgradeGuild[2] = 2;
		elseif OBJECTIVES.state.upgradeGuild[2] == 2 and GetObjectOwner("town3") == PLAYER_1 then 
			SetTownBuildingLimitLevel("insar", TOWN_BUILDING_MAGIC_GUILD, 5) 
			SetRegionBlocked("block", nil, PLAYER_3);
			SetRegionBlocked("block", nil, PLAYER_2);
			OBJECTIVES.state.upgradeGuild[2] = 3;
		elseif OBJECTIVES.state.upgradeGuild[2] == 3 and GetObjectOwner("town3") == PLAYER_1 and GetTownBuildingLevel( "town3", TOWN_BUILDING_MAGIC_GUILD ) == 5 then
			CINEMATICS.spellsLearned();
			SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
			ChangeHeroStat("Zehir", STAT_EXPERIENCE, 2788);
			OBJECTIVES.state.upgradeGuild[2] = 10;
		end
	end,
	
	captureLorekeep = function()
		if OBJECTIVES.state.captureLorekeep[2] == 1 and (OBJECTIVES.state.upgradeGuild[2] == 10 and OBJECTIVES.state.captureCities[2] == 3 or GetObjectOwner("nar_ankar") == PLAYER_1) then
			SetObjectiveVisible("obj3", not nil);
			OBJECTIVES.state.captureLorekeep[2] = 2;
		elseif OBJECTIVES.state.captureLorekeep[2] == 2 and GetObjectOwner("nar_ankar") == PLAYER_1 then
			ChangeHeroStat("Zehir", STAT_EXPERIENCE, 2378);
			OBJECTIVES.state.captureLorekeep[2] = 3;
		elseif OBJECTIVES.state.captureLorekeep[2] == 3 and GetObjectOwner("nar_ankar") == PLAYER_1 then
			SetObjectiveState("obj3",OBJECTIVE_COMPLETED);
			OBJECTIVES.state.captureLorekeep[2] = 4;
		elseif OBJECTIVES.state.captureLorekeep[2] == 4 and GetObjectOwner("nar_ankar") ~= PLAYER_1 then
			SetObjectiveState("obj3",OBJECTIVE_ACTIVE);
			OBJECTIVES.state.captureLorekeep[2] = 3;
		end
	end,
	
	isAlive = function()
		-- Objective is started by C6M2.xdb
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Zehir") == nil then
			SetObjectiveState('obj4', OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)

------------------- DEBUG ------------------------
function C6M2_debug(eax, player)
	if eax == 1 then
		for i=1, town_array.n do
			SetObjectOwner(town_array[i], player );
			sleep(10);
		end
	elseif eax == 2 then
		SetObjectOwner("town3", player);
		sleep(5);
		UpgradeTownBuilding("town3", TOWN_BUILDING_MAGIC_GUILD, 5);
		UpgradeTownBuilding("town3", TOWN_BUILDING_MAGIC_GUILD, 5);
		UpgradeTownBuilding("town3", TOWN_BUILDING_MAGIC_GUILD, 5);
		UpgradeTownBuilding("town3", TOWN_BUILDING_MAGIC_GUILD, 5);
	elseif eax == 3 then
		SetObjectOwner("nar_ankar", player );
	end
end
