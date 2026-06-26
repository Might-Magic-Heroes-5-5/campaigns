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
	InitAllSetArtifacts("A1C3M1");
end
startThread(H55_InitSetArtifacts);

h_cameras = {
	["h1"] = {80, 54, 0, 25, 3.14/3, 	0, 1, 1, 1 },
	["h2"] = {70, 66, 0, 25,    0.8,  2.4, 1, 0, 1 },
	["h3"] = {54, 55, 0, 25, 3.14/3, 	0, 1, 1, 1 },
	["h4"] = {42, 79, 1, 25, 3.14/3, -450, 1, 0, 1 },
	["h5"] = {11, 20, 1, 25, 3.14/3, 	0, 1, 0, 1 },
	["h6"] = {32,  5, 1, 25, 3.14/3, -520, 1, 0, 1 },
}

function showUnit(hero, object)
	local camera = h_cameras[object];
	BlockGame();
	MoveCamera(camera[1], camera[2], camera[3], camera[4], camera[5], camera[6], camera[7], camera[8], camera[9]);
	sleep( 10 );
	OpenCircleFog(camera[1], camera[2], camera[3], 3, PLAYER_1);
	MarkObjectAsVisited(object, hero);
	sleep( 100 );
	local x,y,level = GetObjectPosition("Shadwyn");
	MoveCamera(x, y, level, 25, 3.14/2, 0, 1, 0, 1);
	UnblockGame();
end

function AreMarkedUnitsDefeated()
	for i = 1,6 do
		if IsObjectExists("m"..i) ~= nil then
			return 0;
		end
	end
	return 1;
end

function waitForRite()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "camp", nil);
	OBJECTIVES.state.findRiteSite[2] = 3;
end

function speakWithOracle()
	Trigger( OBJECT_TOUCH_TRIGGER, "seer_hut", nil );
	OBJECTIVES.state.visitOracle[2] = 3;
end

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/A1C3/M1/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	rite = function()
		BlockGame();
		DeployReserveHero("Thralsai", 4, 22, GROUND);
		OpenCircleFog(4, 22, GROUND, 4, PLAYER_1);
		MoveCamera(32, 30, GROUND, 50, 3.14/3, 0);
		repeat sleep(10) until IsObjectExists("Thralsai") ~= nil;
		EnableHeroAI("Thralsai", not nil)
		ChangeHeroStat("Thralsai", STAT_MOVE_POINTS, 3000);
		OpenCircleFog(33, 30, GROUND, 8, PLAYER_1);
		MoveHeroRealTime("Thralsai", 31,30, GROUND);
		repeat a, b = GetObjectPosition("Thralsai"); sleep(10); until (a == 31 and b == 30);
		DeployReserveHero("Kelodin", 3, 5, GROUND);
		while IsHeroAlive("Kelodin") == nil do sleep(10); end
		SetObjectPosition("Kelodin", 33, 30, GROUND);
		sleep( 80 );
		SetObjectPosition("Kelodin", 3, 5, GROUND);
		SetObjectPosition("Thralsai", 3, 4, GROUND);
		sleep( 30 );
		UnblockGame();
	end,

	outro = function()
		StartDialogScene("/DialogScenes/A1C3/M1/S2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

DIFFICULTY = {
	[0] = function()
		diff = 1;
	    QuestStatBonus = { 1, 1, 1, 1 };
	end,
	[1] = function()
		diff = 2;
		QuestStatBonus = { 1, 1, 2, 2 };
	end,
	[2] = function()
		diff = 3;
		QuestStatBonus = { 2, 2, 2, 2 };
	end,
	[3] = function()
		diff = 4;
		QuestStatBonus = { 2, 2, 3, 3 };
	end,
}

OBJECTIVES = {
	state = {
		findRiteSite = {  "obj1", 1 }, -- Find the Rite location
		isAlive 	 = {  "obj2", 1 }, -- Shadwyn must survive
		visitOracle  = { "sobj1", 1 }, -- Visit Oracle units shown by Oracle; 1-2 Active, 3-10 Completed
		killUnits    = { "sobj1", 1 }, -- Defeat units shown by Oracle; 1 Inactive, 2 Active, 10 Completed
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

    prepare = function()
		DIFFICULTY[GetDifficulty()]();
		SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 0);
		SetHeroesExpCoef( 0.5 );
		CINEMATICS.intro();
		SetRegionBlocked("graal", 1, PLAYER_1)
		for i = 1,6 do
			SetObjectEnabled("h"..i, nil);
			Trigger( OBJECT_TOUCH_TRIGGER, "h"..i, "showUnit" );
			Trigger( OBJECT_TOUCH_TRIGGER, "m"..i, "OpenPuzzleMap(PLAYER_1, 1)" );
		end
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "d1", "MessageBox('/Maps/Scenario/A1C3M1/messagebox_q.txt')" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "d2", "MessageBox('/Maps/Scenario/A1C3M1/messagebox_q.txt')" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "d3", "MessageBox('/Maps/Scenario/A1C3M1/messagebox_q.txt')" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "d4", "MessageBox('/Maps/Scenario/A1C3M1/messagebox_q.txt')" );
		SetObjectEnabled("seer_hut", nil);
		Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", "speakWithOracle");
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "camp", "waitForRite" );
		AddObjectCreatures("m1", 	   CREATURE_WITCH, diff * 25 );
		AddObjectCreatures("m2", 	CREATURE_ASSASSIN, diff * 30 );
		AddObjectCreatures("m3", 	CREATURE_MINOTAUR, diff * 20 );
		AddObjectCreatures("m4", 	CREATURE_ASSASSIN, diff * 35 );
		AddObjectCreatures("m5",	   CREATURE_HYDRA, diff * 10 );
		AddObjectCreatures("m6",	   CREATURE_RIDER, diff * 15 );
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

			if GetObjectiveState("obj1") == OBJECTIVE_FAILED or GetObjectiveState("obj2") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED then
				Save("autosave");
				sleep(30);
				SaveHeroAllSetArtifactsEquipped("Shadwyn", "A1C3M1");
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	findRiteSite = function()
		if OBJECTIVES.state.findRiteSite[2] == 1 then
			SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.findRiteSite[2] = 2;
		elseif OBJECTIVES.state.findRiteSite[2] == 3 then
			CINEMATICS.rite();
			CINEMATICS.outro();
			SetObjectiveState( "obj1", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.findRiteSite[2] = 10;
		end
		
		if IsObjectExists( "dc" ) == nil then
			SetObjectiveState( "obj1", OBJECTIVE_FAILED );
			OBJECTIVES.state.findRiteSite[2] = 11;
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 and IsHeroAlive("Shadwyn") == nil then
			SetObjectiveState( "obj2", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	visitOracle = function()
		if OBJECTIVES.state.visitOracle[2] == 1 then
			SetObjectiveState("sobj1", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.visitOracle[2] = 2;
		elseif OBJECTIVES.state.visitOracle[2] == 3 then
			SetObjectiveState("sobj1", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.visitOracle[2] = 10;
		end
	end,
	
	killUnits = function()
		if OBJECTIVES.state.killUnits[2] == 1 and OBJECTIVES.state.visitOracle[2] == 10 then
			SetObjectiveState( "sobj2", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.killUnits[2] = 2;
		elseif OBJECTIVES.state.killUnits[2] == 2 and AreMarkedUnitsDefeated() == 1 then
			SetObjectiveState( "sobj2", OBJECTIVE_COMPLETED );
			local ToLevel = GetExpToLevel( GetHeroLevel("Shadwyn") + 1 );
			local delta = ( ToLevel - GetHeroStat( "Shadwyn", STAT_EXPERIENCE ) );
			ChangeHeroStat( "Shadwyn", STAT_EXPERIENCE,       delta );
			ChangeHeroStat( "Shadwyn",		STAT_ATTACK, QuestStatBonus[1] );
			ChangeHeroStat( "Shadwyn",	   STAT_DEFENCE, QuestStatBonus[2] );
			ChangeHeroStat( "Shadwyn", STAT_SPELL_POWER, QuestStatBonus[3] );
			ChangeHeroStat( "Shadwyn",	 STAT_KNOWLEDGE, QuestStatBonus[4] );
			OBJECTIVES.state.killUnits[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start);
