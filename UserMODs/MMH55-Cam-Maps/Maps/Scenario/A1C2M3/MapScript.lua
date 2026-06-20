doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_PlayerStatus = {0,1,1,1,2,2,2,2};
function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C2M3");
	LoadHeroAllSetArtifacts( "Wulfstan" , "A1C2M2" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Wulfstan" );
end

--                     right bottom     left bottom       right top       right treasury   left orepit       left top
patrol_under_array = {"patrol_u_l_1" , "patrol_u_r_1" , "patrol_u_l_2" , "patrol_u_l_3" , "patrol_u_r_2" , "patrol_u_r_3" }
freidaappears = 7 + random (5);
----------------------- Забег Фрейды-------------------------
function freydaMove1()
	while GetDate(ABSOLUTE_DAY) < freidaappears do sleep(50); end;
	x, y, floor = RegionToPoint( "freydahere");
	DeployReserveHero("Freyda", x, y, floor);
	Trigger(OBJECT_TOUCH_TRIGGER , "Mine2", "freydaMove2");
	sleep(20);
	MoveHero("Freyda", GetObjectPosition( "Mine2" ));
end

function freydaMove2()
	Trigger(OBJECT_TOUCH_TRIGGER , "Mine2", nil);
	Trigger(OBJECT_TOUCH_TRIGGER , "dwarftown", "freydaMove3");
	MoveHero("Freyda", GetObjectPosition( "dwarftown" ));
end

function freydaMove3()
	Trigger(OBJECT_TOUCH_TRIGGER , "dwarftown", nil);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'freidagoout', "freydaMove4");
	MoveHero("Freyda", RegionToPoint('freidagoout'));
end

function freydaMove4()
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'freidagoout', nil);
	RemoveObject( "Freyda" );
end

----------------------- Патруль подземлей ---------------------------
target_located = 0;
patrol_destination = 0;
function startPatrol(hero)
	patrol_destination = math.random(1, 6);
	MoveHero("RedHeavenHero01", RegionToPoint(patrol_under_array[patrol_destination]));
	startThread(setPatrolDestination, hero);
end

function setPatrolDestination(hero)
	while target_located == 0 do
		if H55c_GetDistanceToRegion(hero, patrol_under_array[patrol_destination]) < 4 then
			local new_target = patrol_destination;
			while new_target == patrol_destination do
				new_target = math.random(1, 6);
			end
			MoveHero("RedHeavenHero01", RegionToPoint(patrol_under_array[new_target]));
			patrol_destination = new_target;
		end
		sleep(5);
	end
end

function huntMode(hero, target)
	while IsObjectExists(hero) ~= nil do
		sleep ( 10 );
		if H55_GetDistance( target, hero ) < 15 then
			MoveHero(hero, GetObjectPosition(target));
			target_located = 1;
			print ("here");
		elseif target_located == 1 then
			target_located = 0;
			startThread(setPatrolDestination, hero);
		end
	end
end

function removeDwarvesFromEnemyHero(hero)
	while IsHeroAlive( hero ) ~= nil do
		if GetHeroCreatures( hero, CREATURE_DEFENDER ) > 0 then
			RemoveHeroCreatures( hero, CREATURE_DEFENDER, 10000);
		end
		sleep(50);
	end
end

---------------------- Гномик --------------------------
DWARVES = {
	choice = 0,
	['sacriface1'] = 1,
	['sacriface2'] = 2,
	['sacriface3'] = 3,
	
	speak = function(hero, object)
		DWARVES.choice = DWARVES[object];
		StopVisualEffects( "stop"..DWARVES.choice );
		QuestionBox("/Maps/Scenario/A1C2M3/messagebox1.txt" , "DWARVES.ambush" , "DWARVES.join");
		Trigger(OBJECT_TOUCH_TRIGGER , "sacriface"..DWARVES.choice , nil);
	end,
	
	join = function()
		RemoveObject( "sacriface"..DWARVES.choice );
		AddHeroCreatures( "Wulfstan", 92 , 20 - diff * 3 );
	end,
	
	ambush = function()
		BlockGame();
		x, y, f = GetObjectPosition( "underway"..DWARVES.choice.."2" );
		OpenCircleFog(x, y, f, 7 , PLAYER_1);
		MoveCamera( x, y - 5, f, 25, 0, 0, 0, 1, 1 );
		sleep ( 5 );
		RemoveObject( "sacriface"..DWARVES.choice );
		x,y,z = RegionToPoint('taunt'..DWARVES.choice);
		CreateMob("sacriface"..DWARVES.choice.."2", 92 , 20, x, y, z,MONSTER_MOOD_FRIENDLY,MONSTER_COURAGE_ALWAYS_JOIN); --генерим стек юнитов
		sleep ( 20 );
		while not Exists( "sacriface"..DWARVES.choice.."2" ) do
			sleep( 1 );
		end
		PlayObjectAnimation("sacriface"..DWARVES.choice.."2" , "attack00", IDLE);
		Play2DSound( "/Sounds/_(Sound)/Creatures/Haven/Peasant/happy.xdb#xpointer(/Sound)", x, y, z );
		sleep ( 100 );
		x, y, f = GetObjectPosition( "Wulfstan" );
		MoveCamera( x, y, f, 25, 0, 0, 0, 1, 1 );
		MoveHero("RedHeavenHero01", RegionToPoint('taunt'..DWARVES.choice..'hero'));
		UnblockGame();
	end,
}

function openPrisonCell()
	Trigger(OBJECT_TOUCH_TRIGGER , "Prion_under" , nil );
	OBJECTIVES.state.freeHero[2] = 3;
end

function HellmarExits( hero_escape )
	if hero_escape == "Ottar"  then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'escapeAH1_right', nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,  'escapeAH1_left', nil);
		OBJECTIVES.state.allyEscape[2] = 3;
	end
end

function HellmarSendsHelp( delivery_time )
	while GetDate(ABSOLUTE_DAY) < delivery_time do sleep( 50 ); end
	AddObjectCreatures("Wulfstan", 99, 50);
	MessageBox ("/Maps/Scenario/A1C2M3/messagebox3.txt" );
end

function setupEnemyHeroes( diff )
	-- Setup underground patrol hero
	AddHeroCreatures( "RedHeavenHero01",	   CREATURE_LANDLORD, 1 + diff * 15 );
	AddHeroCreatures( "RedHeavenHero01",	 CREATURE_LONGBOWMAN, 1 + diff * 12 );
	AddHeroCreatures( "RedHeavenHero01",	 CREATURE_VINDICATOR, 1 + diff *  9 );
	AddHeroCreatures( "RedHeavenHero01", CREATURE_BATTLE_GRIFFIN, 1 + diff *  6 );
	startThread(startPatrol, "RedHeavenHero01");
	startThread( huntMode, "RedHeavenHero01", "Wulfstan" );
	startThread( removeDwarvesFromEnemyHero, "RedHeavenHero01" );
	-- Setup town defender hero
	GiveHeroSkill("RedHeavenHero03", 		 SKILL_WAR_MACHINES );
	GiveHeroSkill("RedHeavenHero03", 		 SKILL_WAR_MACHINES );
	GiveHeroSkill("RedHeavenHero03", 		 SKILL_WAR_MACHINES );
	GiveHeroSkill("RedHeavenHero03", 			 SKILL_TRAINING );
	GiveHeroSkill("RedHeavenHero03", DEMON_FEAT_CRITICAL_STRIKE );
	--Setup Caravan
	GiveHeroSkill(		  "Caravan", 			SKILL_LOGISTICS );
	GiveHeroSkill(		  "Caravan", 		   PERK_PATHFINDING );
	if diff > 1 then
		GiveHeroSkill( 		   "Caravan",		  SKILL_LOGISTICS );
		GiveHeroSkill( "RedHeavenHero03", 		 SKILL_LEADERSHIP );
		GiveHeroSkill( "RedHeavenHero03", 			PERK_BALLISTA );
		GiveHeroSkill( "RedHeavenHero03", 		   PERK_FIRST_AID );
		GiveHeroSkill( "RedHeavenHero03", KNIGHT_FEAT_RETRIBUTION );
	end
	if diff > 2 then
		GiveHeroSkill( 		   "Caravan",			  SKILL_LOGISTICS );
		GiveHeroSkill( "RedHeavenHero03", 		  PERK_EXPERT_TRAINER );
		GiveHeroSkill( "RedHeavenHero03", KNIGHT_FEAT_TRIPLE_BALLISTA );
		GiveHeroSkill( "RedHeavenHero03", 				SKILL_DEFENCE );
		GiveHeroSkill( "RedHeavenHero03", 		 WIZARD_FEAT_WILDFIRE );
		GiveHeroSkill( "RedHeavenHero03", 	   HERO_SKILL_PREPARATION );
	end
	if diff > 3 then
		GiveHeroSkill( "RedHeavenHero03", NECROMANCER_FEAT_LAST_AID );
		GiveHeroSkill( "RedHeavenHero03", HERO_SKILL_RUNIC_MACHINES );
		GiveHeroSkill( "RedHeavenHero03",  HERO_SKILL_STUNNING_BLOW );
	end
	AddHeroCreatures( "RedHeavenHero03",	   CREATURE_LANDLORD, 400 + diff * 100 );
	AddHeroCreatures( "RedHeavenHero03",	 CREATURE_LONGBOWMAN, 300 + diff *  50 );
	AddHeroCreatures( "RedHeavenHero03",	   CREATURE_CHAMPION,  20 + diff *  10 );
	AddHeroCreatures( "RedHeavenHero03",		 CREATURE_ZEALOT,  50 + diff *  20 );
	AddHeroCreatures( "RedHeavenHero03", CREATURE_BATTLE_GRIFFIN, 100 + diff *  30 );
	AddHeroCreatures( "RedHeavenHero03",	 CREATURE_VINDICATOR, 200 + diff *  40 );
	ChangeHeroStat( "RedHeavenHero03", 	STAT_ATTACK, diff * 3 );
	ChangeHeroStat( "RedHeavenHero03", STAT_DEFENCE, diff * 4 );
end

function caravanEscape( hero )
	if hero == "Caravan" then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "Caravan_Out", nil );
		OBJECTIVES.state.captureCaravan[2] = 9;
	end
end

DIFFICULTY = {
	[0] = function()
		diff = 1;
		print ("normal");
	end,

	[1] = function()
		diff = 2;
		print ("hard");
	end,

	[2] = function()
		diff = 3;
		print ("heroic");
	end,

	[3] = function()
		diff = 4;
		print ("impossible");
	end,
}

CINEMATICS = {
	intro = function()
		for i = 1, 6 do
			local x, y, f = RegionToPoint( "vieuzone"..i );
			OpenCircleFog(x, y, f, 12 , PLAYER_1);
			sleep( 10 );
		end
	end,
	
	showTown = function()
		BlockGame();
		local x, y, f = GetObjectPosition( "Town" );
		OpenCircleFog(x, y, f, 12 , PLAYER_1);
		MoveCamera( x, y, f, 35, 1.4, 0, 0, 0, 1 );
		sleep( 100 );
		local Pl_x, Pl_y, Pl_floor = GetObjectPosition( "Wulfstan" );
		MoveCamera( Pl_x, Pl_y, Pl_floor, 35, 1.4, 0, 0, 0, 1 );
		UnblockGame();
	end,
	
	showDwarves = function()
		BlockGame();
		x, y, f = RegionToPoint( "openfog" );
		OpenCircleFog(x, y, f, 12 , PLAYER_1);
		for i = 1, 3 do
			x, y, f = GetObjectPosition( "sacriface" .. i );
			MoveCamera( x, y, f, 15, 0, 0, 0, 1, 1 );
			sleep( 1 );
			PlayObjectAnimation("sacriface" .. i, "attack00", ONESHOT);
			sleep( 40 );
		end
		x, y, f = GetObjectPosition( "Wulfstan" );
		MoveCamera( x, y, f, 20, 0, 0, 0, 1, 1 );
		PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/_BuildingFree_S.xdb#xpointer(/Effect)", "sacriface1", "stop1");
		PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/_BuildingFree_S.xdb#xpointer(/Effect)", "sacriface2", "stop2");
		PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/_BuildingFree_S.xdb#xpointer(/Effect)", "sacriface3", "stop3");
		UnblockGame();
	end,
	
	showCaravan = function()
		local first = 0;
		while IsObjectExists( "Caravan" ) do
			while GetCurrentPlayer() ~= PLAYER_1 do sleep(20); end
			BlockGame();
			x,y,fl = GetObjectPosition( "Caravan" );
			OpenCircleFog( x, y, fl, 5, PLAYER_1 );
			MoveCamera( x, y, fl, 45, 1.3, 0, 0, 0, 1);
			if first == 0 then
				sleep( 100 );
				x, y, floor = RegionToPoint( "Caravan_Out");
				OpenCircleFog(x, y, floor, 12, PLAYER_1);
				MoveCamera( x, y, floor, 45, 1, 0.3, 0, 0, 0);
				first = 1;
			end
			sleep(40);
			UnblockGame();
			while GetCurrentPlayer() == PLAYER_1 do sleep( 50 ); end
		end
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/A1C2/M3/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

OBJECTIVES = {
	date = 0,
	state = {
		freeHero 	   = { 					 "prim1", 1 },	-- Free Ottar, 1-2 active, 3-10 complete, 11 fail
		captureTown	   = { 					 "prim2", 1 },	-- Capture Merasgar; 1 waiting for quest requirements, 2 active, 10 compete
		captureCaravan = { "prim3_intercept_caravan", 1 },	-- Capture the enemy caravan; 1-2 Waiting for quest requirements, 3 active, 10 compete, 11 fail
		isAlive		   = { 					 "Prim4", 1 },	-- Wulfstan must survive
		allyEscape	   = { 					  "sec1", 0 },	-- Hellmar must escape the map
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		startThread(H55_InitSetArtifacts);
		SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 0);
		EnableHeroAI("RedHeavenHero03", nil);
		EnableHeroAI("RedHeavenHero02", nil); --специальный герой в горе(хозяин Медной горы), надобный токмо ради того, чтобы player2 не мог быть уничтожен игроком и корован мог ходить
		DIFFICULTY[GetDifficulty()]();
		CINEMATICS.intro();
		startThread(setupEnemyHeroes, diff);
		SetObjectEnabled( "sacriface1", nil );
		SetObjectEnabled( "sacriface2", nil );
		SetObjectEnabled( "sacriface3", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'dwarfs_cave', "CINEMATICS.showDwarves" );
		Trigger( OBJECT_TOUCH_TRIGGER,  "sacriface1",   "DWARVES.speak" );
		Trigger( OBJECT_TOUCH_TRIGGER,  "sacriface2",   "DWARVES.speak" );
		Trigger( OBJECT_TOUCH_TRIGGER,  "sacriface3",   "DWARVES.speak" );
		Trigger( OBJECT_TOUCH_TRIGGER, "Prion_under",  "openPrisonCell" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'escapeAH1_right', "HellmarExits" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,  'escapeAH1_left', "HellmarExits" );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "CaravanExit", "caravanEscape" );
		startThread( freydaMove1 );
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

			if GetObjectiveState("prim1") == OBJECTIVE_FAILED or GetObjectiveState("prim3_intercept_caravan") == OBJECTIVE_FAILED or GetObjectiveState("Prim4") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3_intercept_caravan") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Wulfstan", "A1C2M3");
				CINEMATICS.outro();
				sleep ( 100 );
				Win();
				return
			end
		end
	end,
	
	freeHero = function()
		if OBJECTIVES.state.freeHero[2] == 1 then
			SetObjectiveState( "prim1", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.freeHero[2] = 2;
		elseif OBJECTIVES.state.freeHero[2] == 3 then
			SetObjectOwner("Ottar", PLAYER_3);
			SetObjectiveState( "prim1", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.allyEscape[2] = 1;
			OBJECTIVES.state.freeHero[2] = 10;
		end
		
		if GetDate(WEEK) == 4 then
			SetObjectiveState( "prim1", OBJECTIVE_FAILED );
		end
	end,
	
	captureTown = function()
		if OBJECTIVES.state.captureTown[2] == 1 and (GetObjectOwner("Town") == PLAYER_1 or OBJECTIVES.state.freeHero[2] == 10) then
			SetObjectiveState("prim2", OBJECTIVE_ACTIVE);
			CINEMATICS.showTown();
			OBJECTIVES.state.captureTown[2] = 2;
		elseif OBJECTIVES.state.captureTown[2] == 2 and GetObjectOwner("Town") == PLAYER_1 then
			SetObjectiveState( "prim2", OBJECTIVE_COMPLETED );
			SetTownBuildingLimitLevel( 'Town', 13, 2 );
			SetTownBuildingLimitLevel( 'Town', 12, 2 );
			SetTownBuildingLimitLevel( 'Town', 11, 2 );
			SetTownBuildingLimitLevel( 'Town', 10, 2 );
			SetTownBuildingLimitLevel( 'Town', 9, 2 );
			SetTownBuildingLimitLevel( 'Town', 8, 2 );
			SetTownBuildingLimitLevel( 'Town', 7, 2 );
			SetTownBuildingLimitLevel( 'Town', 4, 1 );
			OBJECTIVES.state.captureTown[2] = 10;
		end
	end,
	
	captureCaravan_time = 0,
	captureCaravan = function()
		if OBJECTIVES.state.captureCaravan[2] == 1 and OBJECTIVES.state.freeHero[2] == 10 and OBJECTIVES.state.captureTown[2] == 10 then
			SetObjectiveState( "prim3_intercept_caravan", OBJECTIVE_ACTIVE );
			OBJECTIVES.captureCaravan_time = GetDate(DAY) + 10 - diff*2
			OBJECTIVES.state.captureCaravan[2] = 2;
		elseif OBJECTIVES.state.captureCaravan[2] == 2 and OBJECTIVES.date >= OBJECTIVES.captureCaravan_time then
			x, y, floor = RegionToPoint( "caravan_here" );
			DeployReserveHero( "Caravan", 133, 114, 0 );
			sleep( 50 );
			SetHeroRoleMode( "Caravan", HERO_ROLE_MODE_HERMIT );
			AddHeroCreatures( "Caravan",   CREATURE_CHAMPION,  30 + diff * 10 );
			AddHeroCreatures( "Caravan", CREATURE_VINDICATOR, 200 + diff * 40 );
			AddHeroCreatures( "Caravan",	 CREATURE_ZEALOT,  40 + diff * 15 );
			AddHeroCreatures( "Caravan", CREATURE_LONGBOWMAN, 249 + diff * 50 );
			if diff == 4 then
				GiveArtefact( "Caravan", ARTIFACT_BOOTS_OF_SPEED, 1 );
			end
			startThread( CINEMATICS.showCaravan );
			OBJECTIVES.state.captureCaravan[2] = 3;
		elseif OBJECTIVES.state.captureCaravan[2] == 3 then
			if IsHeroAlive( "Caravan" ) then
				pcall( MoveHero, "Caravan", 2, 40, 0 );
			else
				SetObjectiveState( "prim3_intercept_caravan", OBJECTIVE_COMPLETED );
				SetPlayerResource( PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) + 55000 - diff * 10000 );
				OBJECTIVES.state.captureCaravan[2] = 10;
			end
		elseif OBJECTIVES.state.captureCaravan[2] == 9 then
			RemoveObject( "Caravan" );
			SetObjectiveState( "prim3_intercept_caravan", OBJECTIVE_FAILED );
			OBJECTIVES.state.captureCaravan[2] = 11;
		end
	end,
	
	isAlive = function()
	-- start of this task is handled by map.xdb
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Wulfstan") == nil then
			SetObjectiveState( "Prim4", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	allyEscape = function()
		if OBJECTIVES.state.allyEscape[2] == 1 then
			SetObjectiveState( "sec1", OBJECTIVE_ACTIVE );
			local xe = 0
			if IsObjectExists("RedHeavenHero01") == not nil then
				xe, ye, fe = GetObjectPosition( "RedHeavenHero01" );
			end
			if xe > 73 then
				MoveHero( "Ottar", RegionToPoint( 'escapeAH1_left' ) );
			else
				MoveHero( "Ottar", RegionToPoint( 'escapeAH1_right' ) );
			end
			OBJECTIVES.state.allyEscape[2] = 2;
		elseif OBJECTIVES.state.allyEscape[2] == 3 then
			SetObjectiveState( "sec1", OBJECTIVE_COMPLETED );
			RemoveObject( "Ottar" );
			startThread( HellmarSendsHelp, OBJECTIVES.date );
			OBJECTIVES.state.allyEscape[2] = 10;
		end
		
		if IsHeroAlive("Ottar") == nil then
			SetObjectiveState( "sec1", OBJECTIVE_FAILED );
			OBJECTIVES.state.allyEscape[2] = 11;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );

function A1C2M3_dbg(var)
	if var == 1 then
		H55_NoFog(1);
		H55_Speedrun(1);
		MakeHeroInteractWithObject("Wulfstan", "Prion_under");
	elseif var == 2 then
		SetObjectOwner("Town", PLAYER_1);
	elseif var == 3 then
		OBJECTIVES.state.captureCaravan[2] = 2;
		OBJECTIVES.captureCaravan_time = 0;
	end
end
