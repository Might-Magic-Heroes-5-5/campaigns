doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C3M2");
	LoadHeroAllSetArtifacts("Berein", "C3M1" );
end

startThread(H55_InitSetArtifacts);

H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_STAFF_OF_VEXINGS,ARTIFACT_RING_OF_DEATH,ARTIFACT_CLOAK_OF_MOURNING,ARTIFACT_NECROMANCER_PENDANT};

C3M2_PATROLS = {
	Nur  = { state = 0, coords = {{55,45}, {39,47},  {22,46},  {11,59}, {5,81}} },
	Faiz = { state = 0, coords = {{60,60}, {79,69},  {89,54}, {117,59}        } },
	Sufi = { state = 0, coords = {{66,43}, {94,35}, {116,30}, {129,40}        } },
}

DIFFICULTY = {
	[0] = function()
		CreateMonster("liches2",CREATURE_LICH,16,80,12,0); --peasant hut
		CreateMonster("skeleton_archers",CREATURE_SKELETON_ARCHER,120,94,21,0); --magic well
		CreateMonster("liches",CREATURE_LICH,20,99,111,0); --Lorekeep
		CreateMonster("vampires",CREATURE_VAMPIRE,22,18,16,0); --Arena
		CreateMonster("ewe_liches",CREATURE_LICH,25,50,27,0); --
		CreateMonster("wights",CREATURE_GHOST,52,81,116,0); --Ruined Tower
		CreateMonster("shadow_dragons",CREATURE_SHADOW_DRAGON,10,108,99,0); --Near lorekeep
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_MAGIC_GUILD,2);
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_DWELLING_7,0);
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_DWELLING_6,0);
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_FORT,1);
		AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,60);
		AddHeroCreatures("Berein",CREATURE_LICH,8);
		AddHeroCreatures("Godric",CREATURE_GRIFFIN,10);
		SetPlayerStartResource(1,WOOD,30);
		SetPlayerStartResource(1,ORE,30);
		SetPlayerStartResource(1,SULFUR,10);
		SetPlayerStartResource(1,CRYSTAL,10);
		SetPlayerStartResource(1,MERCURY,10);
		SetPlayerStartResource(1,GEM,10);
		SetPlayerStartResource(1,GOLD,12000);
		DifficultyFactor = 3;
		print("Difficulty level is easy.");
	end,
	
	[1] = function()
		CreateMonster("skeleton_archers",CREATURE_SKELETON_ARCHER,120,94,21,0); --magic well
		CreateMonster("liches",CREATURE_LICH,20,99,111,0); --Lorekeep
		CreateMonster("vampires",CREATURE_VAMPIRE,22,18,16,0); --Arena
		CreateMonster("ewe_liches",CREATURE_LICH,25,50,27,0); --
		CreateMonster("wights",CREATURE_GHOST,52,81,116,0); --Ruined Tower
		CreateMonster("shadow_dragons",CREATURE_SHADOW_DRAGON,10,108,99,0); --Near lorekeep
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_MAGIC_GUILD,3);
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_DWELLING_7,0);
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_FORT,2);
		AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,40);
		AddHeroCreatures("Godric",CREATURE_GRIFFIN,6);
		SetPlayerStartResource(1,WOOD,20);
		SetPlayerStartResource(1,ORE,20);
		SetPlayerStartResource(1,SULFUR,5);
		SetPlayerStartResource(1,CRYSTAL,5);
		SetPlayerStartResource(1,MERCURY,5);
		SetPlayerStartResource(1,GEM,4);
		SetPlayerStartResource(1,GOLD,6000);
		DifficultyFactor = 3;
		print("Difficulty level is normal.");
	end,
	
	[2] = function()
		CreateMonster("skeleton_archers",CREATURE_SKELETON_ARCHER,120,94,21,0); --magic well
		CreateMonster("vampires",CREATURE_VAMPIRE,22,18,16,0); --Arena
		CreateMonster("wights",CREATURE_GHOST,52,81,116,0); --Ruined Tower
		TeachHeroSpell("Nur",SPELL_PHANTOM);
		SetPlayerStartResource(1,WOOD,12);
		SetPlayerStartResource(1,ORE,12);
		SetPlayerStartResource(1,SULFUR,3);
		SetPlayerStartResource(1,CRYSTAL,3);
		SetPlayerStartResource(1,MERCURY,3);
		SetPlayerStartResource(1,GEM,2);
		SetPlayerStartResource(1,GOLD,2500);
		DifficultyFactor = 2;
		print("Difficulty level is hard.");
	end,
	
	[3] = function()
		TeachHeroSpell("Nur",SPELL_RESURRECT);
		TeachHeroSpell("Nur",SPELL_PHANTOM );
		SetPlayerStartResource(1,WOOD,10);
		SetPlayerStartResource(1,ORE,10);
		SetPlayerStartResource(1,SULFUR,3);
		SetPlayerStartResource(1,CRYSTAL,3);
		SetPlayerStartResource(1,MERCURY,3);
		SetPlayerStartResource(1,GEM,2);
		SetPlayerStartResource(1,GOLD,2000);
		DifficultyFactor = 2;
		print("Difficulty level is heroic.");
	end,
}

BATTLES = {
	titans = {
		start = function(hero)
			print("Thread CombatVSTitans has been started...");
			StartCombat(hero,nil,4,CREATURE_TITAN,20,CREATURE_TITAN,20,CREATURE_TITAN,20,CREATURE_TITAN,20,nil,"BATTLES.titans.finish");
		end,

		finish = function(hero, result)
			if result == not nil then
				print("Victory!");
				Trigger(REGION_ENTER_AND_STOP_TRIGGER, "titans",nil);
				RemoveObject("Titans");
			else
				print(hero, " was defeated by titans");
			end
		end,
	}
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C3/M2/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
    
	nearLorekeep = function()
		StartDialogScene("/DialogScenes/C3/M2/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	captureHikm = function()
		StartDialogScene("/DialogScenes/C3/M2/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	titansRunAway = function()
		MessageBox("/Maps/Scenario/C3M2/TitansRunAway_MsgBox.txt");
		sleep( 2 );
	end,
	
	titansMessage = function()
		MessageBox("/Maps/Scenario/C3M2/TitansGuardTeleport_MsgBox.txt");
		sleep( 2 );
    end,
	 
    outro = function()
		StartDialogScene("/DialogScenes/C3/M2/D2/DialogScene.xdb#xpointer(/DialogScene)", nil, "FirstDifficulties");
		sleep( 2 );
    end,
}

OBJECTIVES = {
	state = {
		findLorekeep  = { "prim1", 1 }, -- find Lorekeep
		captureHikm   = { "prim2", 1 }, -- capture town Hikm
		isAlive       = { "prim3", 1 }, -- Markal and Godric must survive
		enableIsherAI = { "misc1", 1 }, -- Enable Isher hero if titans are defeated
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

    prepare = function()
		H55_CamFixTooManySkills(PLAYER_1,"Berein");
		H55_CamFixTooManySkills(PLAYER_1,"Godric");
		
		EnableHeroAI("Isher",nil);
		EnableHeroAI("Astral",nil);
		EnableHeroAI("Faiz",nil);
		EnableHeroAI("Nur",nil);
		EnableHeroAI("Sufi",nil);
		SetRegionBlocked("block1",1,PLAYER_2);
		SetRegionBlocked("block2",1,PLAYER_2);
		SetRegionBlocked("block3",1,PLAYER_2);
		SetRegionBlocked("antislonik",1,PLAYER_2);
		SetRegionBlocked("approach",1,PLAYER_2);
		SetRegionBlocked("titans",1,PLAYER_2);

		EnableAIHeroHiring(PLAYER_2,"Hikm",nil);
		SetObjectEnabled("Titans",nil);
		startThread(DIFFICULTY[GetDifficulty()]);
		PatrolTerminated = 0;
		DETECT_RADIUS = 18;
		startThread(Patrol2, "Nur");
		startThread(Patrol2, "Faiz");
		startThread(Patrol2, "Sufi");
		startThread(Intercept, "Nur");
		startThread(Intercept, "Faiz");
		startThread(Intercept, "Sufi");

		Trigger(OBJECT_TOUCH_TRIGGER, "Titans","FightVsTitansQuestion");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "titans","CINEMATICS.titansMessage");
		CINEMATICS.intro()
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

			-- Loss is handled by C3M2.xdb
			
			if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep(50);
				Win();
				return
			end
		end
	end,
	
	findLorekeep = function()
	-- start and completion of this task is handled by C3M2.xdb
	    if OBJECTIVES.state.findLorekeep[2] == 1 then
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "necropolis","OBJECTIVES._reachLorekeep",nil);
			OBJECTIVES.state.findLorekeep[2] = 2;
		elseif OBJECTIVES.state.findLorekeep[2] == 3 then
			PatrolTerminated = 1;	
			SetRegionBlocked("block1",nil,PLAYER_2);
			SetRegionBlocked("block2",nil,PLAYER_2);
			SetRegionBlocked("block3",nil,PLAYER_2);
			SetRegionBlocked("antislonik",nil,PLAYER_2);
			AcademyHeroes = GetPlayerHeroes(PLAYER_2);
			AcademyHeroes.n = table.length(AcademyHeroes);
			if AcademyHeroes.n ~= 0 then
				print("AI has some heroes");
				for i = 0, AcademyHeroes.n - 1 do
					if AcademyHeroes[i] ~= "Astral" then
						EnableHeroAI(AcademyHeroes[i],not nil);
					else
						print("Enabling AI for hero", AcademyHeroes[i]," was ignored...");
					end
				end
				print("AI for all heroes has been enabled");
			end
			OBJECTIVES.state.findLorekeep[2] = 4;
		end
		
		if (GetObjectiveState("prim1") == OBJECTIVE_COMPLETED) then
			ObjectiveExp("Berein");
			if IsObjectExists("Titans") == not nil then
				RemoveObject("Titans");
				CINEMATICS.titansRunAway();
				Trigger(REGION_ENTER_AND_STOP_TRIGGER, "titans",nil);
			end
			OBJECTIVES.state.findLorekeep[2] = 10;
		end
	end,
	
	_reachLorekeep = function()
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "necropolis", nil);
		CINEMATICS.nearLorekeep();
		OBJECTIVES.state.findLorekeep[2] = 3;
	end,

	captureHikm = function()
		if OBJECTIVES.state.captureHikm[2] == 1 and OBJECTIVES.state.findLorekeep[2] == 10 then
			CINEMATICS.captureHikm();
			SetObjectiveState("prim2", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.captureHikm[2] = 2;
		end
	  
		if (GetObjectOwner("Hikm") == PLAYER_1) then
			SaveHeroAllSetArtifactsEquipped("Berein", "C3M2");
			sleep(10);
			if GetObjectiveState("prim2") == OBJECTIVE_UNKNOWN then
				SetObjectiveState("prim2",OBJECTIVE_ACTIVE);
				sleep(10)
			end
			SetObjectiveState("prim2",OBJECTIVE_COMPLETED);
			sleep(10);
			
			GiveArtefact("Godric", 71); -- 71 - PEDANT OF NECROMANCY
			OBJECTIVES.state.captureHikm[2] = 10;
		end
	end,
	
	isAlive = function()
	-- start of this task is handled by C3M2.xdb
		if not IsHeroAlive("Berein") or not IsHeroAlive("Godric") then
			SetObjectiveState( 'prim3', OBJECTIVE_FAILED );
			sleep(2);
			OBJECTIVES.state.isAlive[2] = 11;
		end
		if OBJECTIVES.state.captureHikm[2] == 10 then
			SetObjectiveState("prim3", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.isAlive[2] = 10;
		end
	end,
	
	enableIsherAI = function()
		if GetDate(WEEK) > DifficultyFactor or Exists("giants")==nil then
			print("Isher AI has been enabled");
			EnableHeroAI("Isher",not nil);
			OBJECTIVES.state.enableIsherAI[2] = 10;
		end
    end,
}

function FightVsTitansQuestion(heroname)
	if (H55c_LUA.guard() ~= nil) then return end
	QuestionBox("/Maps/Scenario/C3M2/MsgBox_BeforeFightVSTitans.txt", "BATTLES.titans.start('"..heroname.."')");
end

function GetPlayerHeroNearPatrol(PatrolName, Radius)
	if IsHeroAlive(PatrolName) == not nil then
		local PlayerHeroes = GetPlayerHeroes(PLAYER_1);
		for i = 0,table.length(PlayerHeroes) - 1 do
			if H55_GetDistance(PatrolName, PlayerHeroes[i]) <= Radius then
				return PlayerHeroes[i];
			end
		end
	end
end

function Intercept(PatrolName)
	print("Thread Intercept for hero ",PatrolName," has been started...");
	while PatrolTerminated == 0 do
		sleep(20);
		if IsHeroAlive(PatrolName) == not nil then
			if GetPlayerHeroNearPatrol(PatrolName,DETECT_RADIUS) ~= nil then
				PlayerHeroName = GetPlayerHeroNearPatrol(PatrolName,DETECT_RADIUS);
				local x, y, z = GetObjectPosition(PlayerHeroName);
				if IsObjectVisible(PLAYER_2, PlayerHeroName) == not nil and CalcHeroMoveCost(PatrolName, x, y, z) > 0 then
					C3M2_PATROLS[PatrolName].state = 1;
					MoveHeroRealTime(PatrolName, x, y, z);
					sleep(20);
				end
			else
				 C3M2_PATROLS[PatrolName].state = 0;
			end
		else
			print("Hero ",PatrolName," is dead. Thread Intercept for this hero has been terminated...");
			return
		end
	end
	print("Player reach Lorekeep. Thread Intercept for ",PatrolName," terminated.");
end

function Patrol2(heroname)
	print("Thread Patrol for hero", heroname," has been started...");
	local patrol = C3M2_PATROLS[heroname];
	local ArrayLength = table.length(patrol.coords);
	print("ArrayLength.n = ", ArrayLength);
	while PatrolTerminated == 0 do	
		for i=1,ArrayLength do	
			if IsHeroAlive(heroname) == not nil then
				pcall(MoveHeroRealTime, heroname, patrol.coords[i][1], patrol.coords[i][2]);
				local CurrentDay = GetDate(DAY);
				while CurrentDay == GetDate(DAY) or patrol.state == 1 do
					sleep(30);
				end
			else
				print("Thread Patrol for hero ",heroname," has been terminated");
				return
			end
		end
	end
end

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)

------------------ DEBUG ------------------------
function printvar(delay)
	while 1 do
		sleep(delay);
		local hz = GetPlayerHeroNearPatrol("Sufi",DETECT_RADIUS);
		print("Hero near patrol is ", hz);
		print("Continue intercept = ", IsConditionTrue[3]);
	end
end
