doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C3M1");
end

startThread(H55_InitSetArtifacts);
H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_STAFF_OF_VEXINGS,ARTIFACT_RING_OF_DEATH,ARTIFACT_CLOAK_OF_MOURNING,ARTIFACT_NECROMANCER_PENDANT};

-- CONSTS ------------
OUR_HERO = "Berein";
WIZARD_1_NAME = "Tan";
WIZARD_2_NAME = "Astral";
REBEL_HERO = "Mardigo"

DETECTING_RADIUS = 3;
ENEMY_STOPPING_RADIUS = 6;

H55c_AI_CONTROLLED = {
  player1 = {          -- player 1player/human so state should be 0 to skip control of the heroes
      state = 0,       -- 0 human, 1 unmanaged AI, 2 managed AI
	   heroes = {},
	  enemies = {},
  },
  player2 = {		   -- Orange Academy AI player
      state = 2,	   -- AI player with specific purpose so control set to 2
	   heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = 1.0, towns = 0.3, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
	    { priority = 0.8, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER4
    }
  },
  player3 = { 		   -- Purple Dungeon AI player
		state = 1,       -- AI player without specific purpose so control set to 1 (Unmanaged)
		heroes = {},
		heroes = {},
		enemies = {},
  },
  player4 = { 		   -- Blue Haven AI player
		state = 1,       -- AI player without specific purpose so control set to 1 (Unmanaged)
		heroes = {},
		heroes = {},
		enemies = {},
  }
}

C3M1_PATROL = {
	Tan 	= { name = 	  "Tan", objective = "avoid_wizard1", state = 0, coords = {{44,63}, {31,73}, {17,79}, {16,92}         }, coords_n = 4 },
	Astral 	= { name = "Astral", objective = "avoid_wizard2", state = 0, coords = {{22,34}, {18,45},  {8,57},  {7,78}, {16,88}}, coords_n = 5 },
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C3/M1/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

	reachVigil = function()
		StartDialogScene("/DialogScenes/C3/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

	loose = function()
		StartDialogScene("/DialogScenes/C3/M1/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/C3/M1/D2/DialogScene.xdb#xpointer(/DialogScene)", nil, "AgreementWithNecromant");
		sleep( 2 );
	end,
}

DIFFICULTY = {
	[0] = function()
		CreateMonster("skeleton_archer",CREATURE_SKELETON_ARCHER,100,32,67,0);
		CreateMonster("demilich",CREATURE_DEMILICH,12,57,33,0);
		CreateMonster("vampire_lord",CREATURE_VAMPIRE_LORD,16,45,61,1);
		AddHeroCreatures(OUR_HERO,CREATURE_LICH,4);
		AddHeroCreatures(OUR_HERO,CREATURE_SKELETON,40);
		INTERCEPT_RADIUS = 8;
		print("Difficulty level is normal.");
	end,
	
	[1] = function()
		CreateMonster("skeleton_archer",CREATURE_SKELETON_ARCHER,100,32,67,0);
		CreateMonster("demilich",CREATURE_DEMILICH,12,57,33,0);
		CreateMonster("vampire_lord",CREATURE_VAMPIRE_LORD,16,45,61,1);
		INTERCEPT_RADIUS = 10;
		print("Difficulty level is hard.");
	end,
	
	[2] = function()
		AddHeroCreatures(REBEL_HERO,CREATURE_GRIFFIN,6);
		AddHeroCreatures(REBEL_HERO,CREATURE_MARKSMAN,12);
		AddHeroCreatures(REBEL_HERO,CREATURE_PEASANT,80);
		AddHeroCreatures(REBEL_HERO,CREATURE_MILITIAMAN,50);
		INTERCEPT_RADIUS = 12;
		print("Difficulty level is heroic.");
	end,
	
	[3] = function()
		AddHeroCreatures(REBEL_HERO,CREATURE_PALADIN,3);
		AddHeroCreatures(REBEL_HERO,CREATURE_GRIFFIN,10);
		AddHeroCreatures(REBEL_HERO,CREATURE_MARKSMAN,15);
		AddHeroCreatures(REBEL_HERO,CREATURE_ARCHER,20);
		AddHeroCreatures(REBEL_HERO,CREATURE_PEASANT,80);
		AddHeroCreatures(REBEL_HERO,CREATURE_MILITIAMAN,100);
		INTERCEPT_RADIUS = 14;
		print("Difficulty level is impossible.");
	end,
}

function len( x, y )
local l = sqrt( x * x + y * y );
	return l;
end

function WaitDay()
	local Xday;
	Xday = GetDate(DAY) + 1;
	while Xday ~= GetDate(DAY) do
		sleep();
	end
end

function dungeon_town_captured()
	while 1 do
		sleep(100);
		if GetObjectOwner("dungeon_town") == PLAYER_1 or IsObjectExists("hidr") == nil then
			print("Almegir has got his overmind back and will strike now!");
			EnableHeroAI("Almegir",1);
			SetRegionBlocked("almegir",nil,3);
			SetAIHeroAttractor("dungeon_town","Almegir",2);
			break;
		end
	end
end

-- Patrol funcs
function Patrol(patrol)
	if IsHeroAlive(patrol.name) == nil then
		print(patrol.name.." is dead. Thread terminated");
		return
	end
	startThread(AroundHero, patrol);
	patrol.state = 0;
	EnableHeroAI(patrol.name, nil);
	SetObjectEnabled(patrol.name, nil);
	sleep();
	while patrol.state ~= 1 do
		if follow_path(patrol, 1, patrol.coords_n,  1) == "return" then	return end 	-- forward
		if follow_path(patrol, patrol.coords_n, 1, -1) == "return" then	return end 	-- backward
		sleep(10)
	end
end

function follow_path(patrol, start, finish, change)
	for i=start, finish, change do
		if patrol.state >= 1 or IsHeroAlive(patrol.name) == nil then
			print("Thread patrol has been terminated...");
			return "return"
		end
		local cx,cy,cl = GetObjectPos(patrol.name);
		MoveHeroRealTime(patrol.name,patrol.coords[i][1],patrol.coords[i][2], GROUND);
		print(patrol.name.." is moving to "..patrol.coords[i][1]..":"..patrol.coords[i][2] );
		WaitDay();
	end
end

function AroundHero(patrol)
	while 1 do
		sleep(10);
		if IsHeroAlive(patrol.name) == nil or patrol.state == 2 then
			print("Terminated AroundHero thread for "..patrol.name);
			return
		end
		local px,py,pz = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(patrol.name);
		if len(px - cx, py - cy) < INTERCEPT_RADIUS and IsObjectVisible(PLAYER_2,OUR_HERO) and pz == cl then
			print("Our hero is close to the enemy");
			if GetObjectiveState(patrol.objective) ~= OBJECTIVE_ACTIVE then
				SetObjectiveState(patrol.objective, OBJECTIVE_ACTIVE);
			end
		--print("MP to Our Hero = ",CalcHeroMoveCost(patrol_name,px,py));
			startThread(FollowHero_InitialDay, patrol);
			break;
		end
	end
end

function FollowHero_InitialDay(patrol)
	patrol.state = 1;
	print("Thread FollowHero_InitialDay for hero ",patrol.name, " has been started...");
	local INx, INy = GetObjectPos(patrol.name);
	local Xday = GetDate(DAY);
	local currentday = GetDate(DAY);
	while currentday <= Xday+1 do
		sleep(20);
		currentday = GetDate(DAY);
		if IsHeroAlive(patrol.name) == nil then
			print(patrol.name, " is dead. Thread FollowHero_InitialDay(",patrol.name,") has been terminated");
			return
		end
		local px,py,pz = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(patrol.name);
		if pz ~= cl or len(px - cx,py - cy) >= INTERCEPT_RADIUS then
			print("Berein is at safe distance from the foolish wizard "..patrol.name..".");	
			SetObjectiveState(patrol.objective, OBJECTIVE_COMPLETED);
			patrol.state = 0;
			startThread(Patrol, patrol);
			return
		end
		local Total = GetHeroStat(patrol.name,STAT_MOVE_POINTS);
		local MpToBerein = CalcHeroMoveCost(patrol.name,px,py);
		print("Total = ",Total," MpToBerein = ", MpToBerein,". ENEMY_STOPPING_RADIUS = ", ENEMY_STOPPING_RADIUS*75);
		if Total > MpToBerein+75*(DETECTING_RADIUS+1) then
			ChangeHeroStat(patrol.name,STAT_MOVE_POINTS,-Total);
			sleep(2);
			print("Current ", patrol.name,"  MP = ",GetHeroStat(patrol.name,STAT_MOVE_POINTS));
			ChangeHeroStat(patrol.name,STAT_MOVE_POINTS,(MpToBerein - ENEMY_STOPPING_RADIUS*75));
			sleep(2);
			print("Current ", patrol.name,"  MP = ",GetHeroStat(patrol.name,STAT_MOVE_POINTS));
		end
		print("initial len = ",len(px - cx,py - cy));
		if INx ~= cx or INy ~= cy then
			print("Current coords is not equal initial coords");
			break
		end
		MoveHeroRealTime(patrol.name,px,py,pz);
	end
	startThread(FollowHero_Continuous, patrol)
end

function FollowHero_Continuous(patrol)
	print("Thread FollowHero_Continuous for "..patrol.name.." has been started...");
	while 1 do
		sleep(10);
		if IsHeroAlive(patrol.name) == nil then
			print(patrol.name.." is dead. Thread FollowHero_InitialDay has been terminated");
			return
		end
		local px,py,pz = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(patrol.name);
		if pz ~= cl or len(px - cx,py - cy) >= INTERCEPT_RADIUS then
			print("Our Hero has avoid foolish wizard ",patrol.name,"!");
			SetObjectiveState(patrol.objective, OBJECTIVE_COMPLETED);
			patrol.state = 0;
			startThread(Patrol, patrol);
			break
		end
		print("continuous len = ",len(px - cx,py - cy));
		local px,py = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(patrol.name);
		MoveHeroRealTime(patrol.name,px,py,pz);
	end
end

function detecting(hero)
	print("Thread detection for "..hero.." has been started...")
	while 1 do
		sleep(20);
		if IsHeroAlive(hero) == nil then
			print(hero, " is dead. Thread has been terminated");
			return
		end
		local x1,y1,z1 = GetObjectPos(hero);
		local x2,y2,z2 = GetObjectPos("Berein");
		--print(hero..": "..len(x1-x2,y1-y2).." vs "..DETECTING_RADIUS);
		if (len(x1-x2,y1-y2) < DETECTING_RADIUS and z1 == z2) then
			OBJECTIVES.state.avoidPatrols[2] = 9;
			return
		end
	end
end

OBJECTIVES = {
	state = {
		reachVigil		= { "prim1", 1 }, -- Markal must reach town of Vigil
		avoidPatrols	= { "prim2", 1 }, -- Markal must avoid enemy patrol1
		destroyRebels	= { "prim3", 0 }, -- 
		isAlive			= { "prim4", 1 }, -- Markal must stay alive
	},

  start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

    prepare = function()
		CINEMATICS.intro()
		H55_CamFixTooManySkills( PLAYER_4, "Godric" );
		--Block Regions
		SetRegionBlocked("dungeon",1,3);
		SetRegionBlocked("dungeon",1,2);
		SetRegionBlocked("vampires",1,3);
		SetRegionBlocked("almegir",1,3);
		--Disable Hero AI
		EnableHeroAI('Godric', nil);
		EnableHeroAI(WIZARD_1_NAME,nil);
		EnableHeroAI(WIZARD_2_NAME,nil);
		SetObjectEnabled(WIZARD_1_NAME,nil);
		SetObjectEnabled(WIZARD_2_NAME,nil);
		EnableHeroAI(REBEL_HERO,nil);
		EnableHeroAI('Almegir',nil);
		EnableHeroAI('Dalom',nil);

		SetPlayerResource(PLAYER_1,WOOD,10);
		SetPlayerResource(PLAYER_1,ORE,10);
		SetPlayerResource(PLAYER_1,GEM,5);
		SetPlayerResource(PLAYER_1,CRYSTAL,5);
		SetPlayerResource(PLAYER_1,MERCURY,5);
		SetPlayerResource(PLAYER_1,SULFUR,5);
		SetPlayerResource(PLAYER_1,GOLD,500);
		SetPlayerResource(PLAYER_3,WOOD,0);
		SetPlayerResource(PLAYER_3,ORE,0);
		SetPlayerResource(PLAYER_3,GEM,0);
		SetPlayerResource(PLAYER_3,CRYSTAL,0);
		SetPlayerResource(PLAYER_3,MERCURY,0);
		SetPlayerResource(PLAYER_3,SULFUR,0);
		SetPlayerResource(PLAYER_3,GOLD,0);
		SetPlayerResource(PLAYER_2,WOOD,0);
		SetPlayerResource(PLAYER_2,ORE,0);
		SetPlayerResource(PLAYER_2,GEM,0);
		SetPlayerResource(PLAYER_2,CRYSTAL,0);
		SetPlayerResource(PLAYER_2,MERCURY,0);
		SetPlayerResource(PLAYER_2,SULFUR,0);
		SetPlayerResource(PLAYER_2,GOLD,0);
		startThread(DIFFICULTY[GetDifficulty()]);
		startThread(dungeon_town_captured);
		startThread(hydra);
		startThread(Patrol, C3M1_PATROL["Tan"]);
		startThread(Patrol, C3M1_PATROL["Astral"]);
		startThread(detecting, WIZARD_1_NAME);
		startThread(detecting, WIZARD_2_NAME);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"liches","found_liches");
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
			
			if GetObjectiveState("prim2") == OBJECTIVE_FAILED or GetObjectiveState("prim4") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("prim3") == OBJECTIVE_COMPLETED and GetObjectiveState("prim4") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Berein", "C3M1");
				sleep(50);
				CINEMATICS.outro();
				sleep(50);
				Win();
				return
			end
		end
	end,
	
	_reachVigil_location = function()
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"townexit",nil);
		OBJECTIVES.state.reachVigil[2] = 3;
	end,
	
	reachVigil = function()
		if OBJECTIVES.state.reachVigil[2] == 1 then
			Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"townexit","OBJECTIVES._reachVigil_location");
			OBJECTIVES.state.reachVigil[2] = 2;
		elseif OBJECTIVES.state.reachVigil[2] == 3 then
			SetObjectiveState("prim1",OBJECTIVE_COMPLETED);
			ObjectiveExp(OUR_HERO);
			sleep(10);
			CINEMATICS.reachVigil();
			OBJECTIVES.state.destroyRebels[2] = 1;
			OBJECTIVES.state.avoidPatrols[2] = 5;
			OBJECTIVES.state.reachVigil[2] = 10;
		end
	end,

	_avoidPatrols_exit = function()
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "intercept", nil);
		OBJECTIVES.state.avoidPatrols[2] = 3;
	end,
	
	avoidPatrols = function()
		if OBJECTIVES.state.avoidPatrols[2] == 1 then
			Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "intercept", "OBJECTIVES._avoidPatrols_exit");
			OBJECTIVES.state.avoidPatrols[2] = 2;
		elseif OBJECTIVES.state.avoidPatrols[2] == 3 then
			startThread(FollowMarkal);
			pcall(MessageBox, "/Maps/Scenario/C3M1/intercept.txt");
			OBJECTIVES.state.avoidPatrols[2] = 4;
		elseif OBJECTIVES.state.avoidPatrols[2] == 5 then
			SetObjectiveState("prim2", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.avoidPatrols[2] = 10;
		elseif OBJECTIVES.state.avoidPatrols[2] == 9 then
			CINEMATICS.loose();
			SetObjectiveState("prim2", OBJECTIVE_FAILED);
			OBJECTIVES.state.avoidPatrols[2] = 11;
		end
	end,
	
	destroyRebels = function()
		if OBJECTIVES.state.destroyRebels[2] == 1 then
			SetObjectiveState("prim3", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.destroyRebels[2] = 2;
		elseif OBJECTIVES.state.destroyRebels[2] == 2 and IsHeroAlive(REBEL_HERO) == nil then
			SetObjectiveState("prim3", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.destroyRebels[2] = 10;
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			if IsHeroAlive("Berein") == nil then
				SetObjectiveState("prim4", OBJECTIVE_FAILED);
				OBJECTIVES.state.isAlive[2] = 11;
			elseif OBJECTIVES.state.destroyRebels[2] == 10 then
				SetObjectiveState("prim4", OBJECTIVE_COMPLETED);
				OBJECTIVES.state.isAlive[2] = 10;
			end
		end
	end,
}


function FollowMarkal()
	local day = GetDate(ABSOLUTE_DAY) + 7 - __difficulty;
	while 1 do
		sleep(100);
		if day <= GetDate(ABSOLUTE_DAY) then
			C3M1_PATROL[WIZARD_1_NAME].state = 2;
			C3M1_PATROL[WIZARD_2_NAME].state = 2;
			H55c_AIAddHero(WIZARD_1_NAME);
			H55c_AIAddHero(WIZARD_2_NAME);
			EnableHeroAI("Dalom", not nil);
			return
		end
	end
end

function found_liches(hero)
	if hero == "Berein" then
		print("Player has found liches!!!");
		MessageBox("/Maps/Scenario/C3M1/LichesFinding.txt");
		AddHeroCreatures("Berein",CREATURE_LICH,4);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"liches",nil);
	end
end

function hydra()
	print("Thread Hydra has been started...");
	while 1 do
		sleep(10);
		if (Exists("hidraliska") == nil) then
			AddHeroCreatures("Berein",CREATURE_VAMPIRE,8);
			MessageBox("/Maps/Scenario/C3M1/VampitesFinding.txt");
			break;
		end
	end
end

------------------- MAIN ------------------------
startThread( OBJECTIVES.start )
startThread( H55c_AI_main )
