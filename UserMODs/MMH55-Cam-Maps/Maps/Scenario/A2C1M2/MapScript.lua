doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_STAFF_OF_VEXINGS,
	ARTIFACT_CLOAK_OF_MOURNING,
	ARTIFACT_RING_OF_DEATH,
	ARTIFACT_SKULL_HELMET
};

function H55_InitSetArtifacts()
	InitAllSetArtifacts( "A2C1M2", "Arantir" );
end

startThread(H55_InitSetArtifacts);

function MessageGateLockedByKey( hero )
	if OBJECTIVES.state.defeatLocalLeader[2] < 10 then 
		Play2DSound( "/Maps/Scenario/A2C1M2/C1M2_VO3_Arantir_01sound.xdb#xpointer(/Sound)" );
		SetObjectPosition( hero, 125, 14, 0 );
		MessageBox ("Maps/Scenario/A2C1M2/key.txt");
	else
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "key_zone", nil );
		Play2DSound( "/Maps/Scenario/A2C1M2/C1M2_VO4_Arantir_01sound.xdb#xpointer(/Sound)" );
	end
end

function SpawnSuccubus()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dd2", nil );
	RemoveObject("i2");
	sleep( 10 );
	CreateMonster( "m2", CREATURE_INFERNAL_SUCCUBUS, 100 + diff * 75, 92, 79, 1, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, 270 );
	Play2DSound( "/Maps/Scenario/A2C1M2/C1M2_VO7_Arantir_01sound.xdb#xpointer(/Sound)" );
end

function SpawnPitLords()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dd3", nil );
	RemoveObject("i3");
	sleep( 10 );
	CreateMonster( "m3", CREATURE_BALOR, 40 + diff * 15, 107, 77, 1, MONSTER_MOOD_AGGRESSIVE, MONSTER_COURAGE_ALWAYS_FIGHT, 270 );
	Play2DSound( "/Maps/Scenario/A2C1M2/C1M2_VO8_Arantir_01sound.xdb#xpointer(/Sound)" );	
end

function meetZombies( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "n_sec", nil );
		OBJECTIVES.state.findVampireCrypts[2] = 1;
	end
end

function enterSecretPath( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "dang", nil );
		OBJECTIVES.state.findSecretPath[2] = 3;
	end
end

function WarningMagicFirewall( hero )
	MessageBox ( "Maps/Scenario/A2C1M2/mummy.txt" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "magic1", nil);
end

function EnterMagicFireWall( hero )
	if IsObjectInRegion (hero, "magic2") ~= nil then
		BlockGame();
		PlayVisualEffect( "/Effects/_(Effect)/Spells/AnimateDead.xdb#xpointer(/Effect)", hero, "hn1", 0, 0, 0, 0, 0 );
		sleep(50);
		UnblockGame();
		StartCombat(hero,nil,4,CREATURE_MUMMY,50,CREATURE_MUMMY,50,CREATURE_MUMMY,50,CREATURE_MUMMY,50,nil);
	end
end

function VisitDeathKnightHut()
	if GetObjectiveState("Neck") == OBJECTIVE_ACTIVE and GetHeroLevel( "Arantir" ) < 5 then
		CINEMATICS.notWorthyForDeathKnights();
	end
end

CINEMATICS = {
	are_playing = nil,
	playAndWait = function( id )
		CINEMATICS.are_playing = not nil;
		StartAdvMapDialog( id, CINEMATICS.end_play() );
		repeat sleep(30); until CINEMATICS.are_playing == nil;
	end,
		
	end_play = function()
		CINEMATICS.are_playing = nil;
	end,
	
	meetMage = function()
		BlockGame();
		CINEMATICS.playAndWait(5);
		sleep(30);
		ChangeHeroStat( "Nur", STAT_MOVE_POINTS, 30000 );
		MoveHeroRealTime( "Nur", GetObjectPosition( "Arantir" ) );
		UnblockGame();	
	end,
	
	interogateMage = function()
		BlockGame();
		SetObjectRotation( "Astral", 270 );
		SetObjectPosition( "Astral", 117, 118, GROUND );
		sleep(60);
		CINEMATICS.playAndWait(1);
		SetObjectPosition( "Astral", 92, 49, GROUND );
		Play2DSound( "/Maps/Scenario/A2C1M2/C1M2_VO5_Arantir_01sound.xdb#xpointer(/Sound)" );
		sleep(2);
		UnblockGame();
	end,
	
	meetSeer = function()
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "mage2", nil );
		BlockGame();
		hero_x, hero_y, hero_z = GetObjectPosition( "Arantir" );
		SetObjectPosition( "Arantir", 129, 90, 0 );
		SetObjectRotation( "Arantir", 90 );
		sleep(25);
		CINEMATICS.playAndWait( 3 );
		sleep(20);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/LuckGood.xdb#xpointer(/Effect)", "Arantir", "ara1", 0, 0, 0, 0, 0 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/LuckBad.xdb#xpointer(/Effect)", "mg", "mag1", 0, 0, 0, 0, 0 );
		sleep(15);
		pcall(RemoveObject, "mg" );
		SetObjectPosition( "Arantir", hero_x, hero_y, hero_z );
		UnblockGame();
	end,
	
	meetDeathKnights = function()
		SetObjectPosition( "Arantir", 119, 122, GROUND );
		SetObjectRotation( "Arantir", 90 );
		sleep(60);
		CINEMATICS.playAndWait(0);
	end,
	
	joinDeathKnights = function()
		SetObjectPosition( "Arantir", 119, 122, GROUND );
		SetObjectRotation( "Arantir", 90 );
		sleep(60);
		CINEMATICS.playAndWait(7);
	end,
	
	notWorthyForDeathKnights = function()
		SetObjectPosition( "Arantir", 119, 122, GROUND );
		SetObjectRotation( "Arantir", 90 );
		sleep(60);
		CINEMATICS.playAndWait(8);
	end,
	
	meetZombies = function()
		BlockGame();
		hero_x, hero_y, hero_z = GetObjectPosition( "Arantir" );
		SetObjectPosition( "Arantir", 29, 112, 0 );
		SetObjectRotation( "Arantir", 360 );
		sleep(60);
		CINEMATICS.playAndWait(6);
		SetObjectPosition( "Arantir", hero_x, hero_y, hero_z );
		OpenCircleFog( 27, 100, 0, 4, PLAYER_1 );
		sleep(50);
		UnblockGame();
	end,
	
	meetVampires = function()
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "vamp1", nil );
		BlockGame();
		hero_x, hero_y, hero_z = GetObjectPosition( "Arantir" );
		SetObjectPosition( "Arantir", 15, 65, 1 );
		SetObjectRotation( "Arantir", 90 );
		sleep(60);
		CINEMATICS.playAndWait(2);
		SetObjectPosition( "Arantir", hero_x, hero_y, hero_z );
		SetRegionBlocked( "vamp1", nil, PLAYER_2 ); 
		SetRegionBlocked( "vamp1", nil, PLAYER_3 ); 
		UnblockGame();
	end,
	
	outro = function()
		StartDialogScene( "/DialogScenes/A2C1/M2/S2/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep(2);
	end,
}


DIFFICULTY = {
	[0] = function()
		diff = 1;
		SetRegionBlocked("z1", not nil, PLAYER_2); 
		SetRegionBlocked("z1", not nil, PLAYER_3);
		SetRegionBlocked("z2", not nil, PLAYER_2); 
		SetRegionBlocked("z2", not nil, PLAYER_3);
		SetRegionBlocked("z3", not nil, PLAYER_2); 
		SetRegionBlocked("z3", not nil, PLAYER_3);
		SetRegionBlocked("z4", not nil, PLAYER_2); 
		SetRegionBlocked("z4", not nil, PLAYER_3);
		AddObjectCreatures( "winner",  CREATURE_ARCHDEVIL,  15 );
		AddHeroCreatures( "Gamor", CREATURE_FRIGHTFUL_NIGHTMARE,  35 );
		AddHeroCreatures( "Gamor", CREATURE_INFERNAL_SUCCUBUS, 100 );
		print("Difficulty Level is NORMAL");
	end,
	
	[1] = function()
		diff = 2;
		SetRegionBlocked("z1", not nil, PLAYER_2); 
		SetRegionBlocked("z1", not nil, PLAYER_3);
		SetRegionBlocked("z2", not nil, PLAYER_2); 
		SetRegionBlocked("z2", not nil, PLAYER_3);
		AddHeroCreatures( "Gamor", CREATURE_INFERNAL_SUCCUBUS, 160 );
		AddHeroCreatures( "Gamor", CREATURE_ARCHDEVIL, 5 );
		AddHeroCreatures( "Gamor", CREATURE_FRIGHTFUL_NIGHTMARE,  50 );
		AddObjectCreatures( "winner",   CREATURE_FIRE_ELEMENTAL,  45 );
		AddObjectCreatures( "winner", CREATURE_SUCCUBUS_SEDUCER,  35 );
		AddObjectCreatures( "winner", 		   CREATURE_CERBERI,  67 );
		AddObjectCreatures( "winner", 	     CREATURE_PIT_SPAWN,  15 );
		AddObjectCreatures( "winner",     CREATURE_ARCHDEVIL,  25 );
		print("Difficulty Level is HARD");
	end,
	
	[2] = function()
		diff = 3;
		RemoveHeroCreatures("Arantir", CREATURE_SKELETON, 10);
		AddHeroCreatures( "Astral", CREATURE_IRON_GOLEM, 50);
		AddHeroCreatures( "Gamor", CREATURE_FRIGHTFUL_NIGHTMARE,  70 );
		AddHeroCreatures( "Gamor",   CREATURE_INFERNAL_SUCCUBUS, 220 );
		AddObjectCreatures( "winner",   CREATURE_FIRE_ELEMENTAL,  75 );
		AddObjectCreatures( "winner", CREATURE_SUCCUBUS_SEDUCER,  85 );
		AddObjectCreatures( "winner", 		   CREATURE_CERBERI,  135 );
		AddObjectCreatures( "winner", 	     CREATURE_PIT_SPAWN,  30 );
		AddObjectCreatures( "winner",     CREATURE_ARCHDEVIL,  33 );
		print("Difficulty Level is HEROIC");
	end,
	
	[3] = function()
		diff = 4;
		RemoveHeroCreatures("Arantir", CREATURE_SKELETON, 20);
		AddHeroCreatures( "Astral", CREATURE_IRON_GOLEM, 100);
		AddHeroCreatures( "Gamor", CREATURE_FRIGHTFUL_NIGHTMARE,  100 );
		AddHeroCreatures( "Gamor",   CREATURE_INFERNAL_SUCCUBUS, 300 );
		AddHeroCreatures( "Gamor",           CREATURE_ARCHDEVIL,  40 );
		AddObjectCreatures( "winner",        CREATURE_ARCHDEVIL,  40 );
		AddObjectCreatures( "winner",   CREATURE_FIRE_ELEMENTAL, 125 );
		AddObjectCreatures( "winner", CREATURE_SUCCUBUS_SEDUCER,  135 );
		AddObjectCreatures( "winner", 		   CREATURE_CERBERI, 270 );
		AddObjectCreatures( "winner", 	     CREATURE_PIT_SPAWN,  45 );
		print("Difficulty Level is IMPOSSIBLE");
	end,
}

OBJECTIVES = {
	state = {
		eliminateSorcerer  = { "prim1", 1 }, -- find the demon sorcerer
		defeatLocalLeader  = { "prim2", 1 }, -- defeat the local demon leader
		findCultistsLeader = { "prim3", 1 }, -- find the cultists leader
		isAlive 		   = { "prim4", 1 }, -- Arantir must survive
		findSecretPath	   = { "Prim5", 1 }, -- find secret underground path
		joinDeathKnights   = {  "Neck", 1 }, -- Death nights will join when hero gains level 5
		findVampireCrypts  = {  "sec2", 0 }, -- Find all vampire crypts in the underground
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		ChangeHeroStat("Arantir", STAT_MANA_POINTS, 20);
		SetHeroesExpCoef( 0.6 );
		BlockTownGarrisonForAI( "winner", not nil )
		GiveExp(   "Faiz", 200000);
		GiveExp(  "Gamor", 200000);
		GiveExp( "Astral",  1000 );
		EnableHeroAI( "Gamor", nil );
		EnableHeroAI(  "Faiz", nil );
		SetTownBuildingLimitLevel( "t2", TOWN_BUILDING_DWELLING_4, 0 );
		SetTownBuildingLimitLevel( "t1", TOWN_BUILDING_DWELLING_4, 0 );
		SetRegionBlocked( 		"vamp1", not nil, PLAYER_2 );	-- Block player 2 from access vampire dwelling area
		SetRegionBlocked( 		"vamp1", not nil, PLAYER_3 );	-- Block player 3 from access vampire dwelling area
		SetRegionBlocked( "demon_block", not nil, PLAYER_4 );   -- Block player 4 hero from getting out of Mutazz town
		SetRegionBlocked( 		"mage1", not nil, PLAYER_1 );	-- Block mage seer NPC from being attacked by player 1
		SetRegionBlocked( 		"mage1", not nil, PLAYER_2 );	-- Block mage seer NPC from being attacked by player 2
		SetRegionBlocked( 		"mage1", not nil, PLAYER_3 );	-- Block mage seer NPC from being attacked by player 3
		SetRegionBlocked( 		   "b1", not nil, PLAYER_2 ); 	-- Block player 2 from magic fire zone
		SetRegionBlocked( 		   "b1", not nil, PLAYER_3 ); 	-- Block player 3 from magic fire zone
		SetRegionBlocked( 		   "b2", not nil, PLAYER_2 );	-- Block player 2 from key_zone
		SetRegionBlocked( 		   "b2", not nil, PLAYER_3 ); 	-- Block player 3 from key_zone
		SetRegionBlocked( 		   "b3", not nil, PLAYER_2 );	-- Block player 2 from interracting with player 3
		SetRegionBlocked( 		   "b3", not nil, PLAYER_3 );  	-- Block player 3 from interracting with player 2
		SetRegionBlocked( 		   "b4", not nil, PLAYER_2 ); 	-- Block player 2 from Cloak of Mourning
		SetRegionBlocked( 		   "b4", not nil, PLAYER_3 ); 	-- Block player 3 from Cloak of Mourning
		SetRegionBlocked(		 "key2", not nil, PLAYER_2 );	-- Block player 2 from accessing Vampire underground
		SetRegionBlocked(		 "key2", not nil, PLAYER_3 ); 	-- Block player 3 from accessing Vampire underground
		SetRegionBlocked(		 "key3", not nil, PLAYER_2 );	-- Block player 2 from accessing local cult leader underground
		SetRegionBlocked(		 "key3", not nil, PLAYER_3 ); 	-- Block player 3 from accessing local cult leader underground 
		SetRegionBlocked(		 "ent2", not nil, PLAYER_2 ); 	-- Block player 2 from accessing player 1 zone
		SetRegionBlocked(		 "ent2", not nil, PLAYER_3 ); 	-- Block player 3 from accessing player 1 zone
		SetRegionBlocked(		 "back", not nil, PLAYER_1 );	-- Magic wall blocking player 1 from reaching the Cultists leader
		SetRegionBlocked( 		  "nb1", not nil, PLAYER_2 ); 	-- Block player 2 from accessing red key tent and boots of speed
		SetRegionBlocked(		  "nb1", not nil, PLAYER_3 );	-- Block player 3 from accessing red key tent and boots of speed
		SetRegionBlocked( 		"n_sec", not nil, PLAYER_2 ); 	-- Block player 2 from interracting with the zombies
		SetRegionBlocked( 		"n_sec", not nil, PLAYER_3 );	-- Block player 3 from interracting with the zombies
		DIFFICULTY[GetDifficulty()]();
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,	   "n_sec",	 			"meetZombies" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 	"dang",			"enterSecretPath" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "key_zone",	 "MessageGateLockedByKey" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,	  "magic1",	   "WarningMagicFirewall" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,	  "magic2",		 "EnterMagicFireWall" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 	 "dd2",			  "SpawnSuccubus" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 	 "dd3",			  "SpawnPitLords" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,	   "mage2",		"CINEMATICS.meetSeer" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,	   "vamp1", "CINEMATICS.meetVampires" );
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
			
			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED and GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped( "Arantir",  "A2C1M2" );
				sleep(100);
				CINEMATICS.outro();
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	eliminateSorcerer = function()
		if OBJECTIVES.state.eliminateSorcerer[2] == 1 then
			SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.eliminateSorcerer[2] = 2;
		elseif OBJECTIVES.state.eliminateSorcerer[2] == 2 and GetPlayerState(PLAYER_2) == PLAYER_LOST then
			SetObjectiveState( "prim1", OBJECTIVE_COMPLETED );
			SetRegionBlocked( "b3", nil, PLAYER_3 ); -- Allow player 3 to access player 2 area
			OBJECTIVES.state.eliminateSorcerer[2] = 10;
		end
	end,
	
	defeatLocalLeader_armyDay = 8,
	defeatLocalLeader = function()
		if OBJECTIVES.state.defeatLocalLeader[2] == 1 then  
			CINEMATICS.meetMage();
			OBJECTIVES.state.defeatLocalLeader[2] = 2;
		elseif OBJECTIVES.state.defeatLocalLeader[2] == 2 and IsHeroAlive("Nur") == nil then
			SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
			CINEMATICS.interogateMage();
			OBJECTIVES.state.defeatLocalLeader[2] = 3;
		elseif OBJECTIVES.state.defeatLocalLeader[2] == 3 and IsHeroAlive("Gamor") == nil then
			SetObjectiveState( "prim2", OBJECTIVE_COMPLETED );
			Play2DSound( "/Maps/Scenario/A2C1M2/C1M2_VO6_Arantir_01sound.xdb#xpointer(/Sound)" );
			sleep(30); 
			MessageBox ("Maps/Scenario/A2C1M2/key3.txt");
			OBJECTIVES.state.defeatLocalLeader[2] = 10;
		end
		
		if OBJECTIVES.date >= OBJECTIVES.defeatLocalLeader_armyDay then
			AddHeroCreatures( "Gamor", CREATURE_INFERNAL_SUCCUBUS, 20 );
			AddHeroCreatures( "Gamor", 		  CREATURE_ARCHDEVIL,  5 );
			OBJECTIVES.defeatLocalLeader_armyDay = OBJECTIVES.defeatLocalLeader_armyDay + 7;
		end		
	end,
	
	findCultistsLeader_armyDay = 8,
	findCultistsLeader = function()
		if OBJECTIVES.state.findCultistsLeader[2] == 1 and OBJECTIVES.state.defeatLocalLeader[2] == 10 then  
			SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.findCultistsLeader[2] = 2;
		elseif OBJECTIVES.state.findCultistsLeader[2] == 2 and GetObjectOwner("winner") == PLAYER_1 then
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
			SetRegionBlocked( "back", nil, PLAYER_1 );
			RemoveObject("e1");
			RemoveObject("e2");
			RemoveObject("e3");
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "magic2", nil ); -- remove the magic firewall threat
			OBJECTIVES.state.findCultistsLeader[2] = 10;
		end
		
		if OBJECTIVES.date >= OBJECTIVES.findCultistsLeader_armyDay then
			AddObjectCreatures( "winner", 		CREATURE_TITAN,  3 );
			AddObjectCreatures( "winner", 		CREATURE_ARCHDEVIL,  3 );
			OBJECTIVES.findCultistsLeader_armyDay = OBJECTIVES.findCultistsLeader_armyDay + 7;
		end			
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState( 'prim4', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 and IsHeroAlive("Arantir") == nil then
			SetObjectiveState( 'prim4', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	findSecretPath = function()
		if OBJECTIVES.state.findSecretPath[2] == 1 and OBJECTIVES.state.defeatLocalLeader[2] == 10 then  
			SetObjectiveState( 'Prim5', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.findSecretPath[2] = 2;
		elseif OBJECTIVES.state.findSecretPath[2] == 3 then
			SetObjectiveState( "Prim5", OBJECTIVE_COMPLETED );
			MessageBox ("Maps/Scenario/A2C1M2/mess4.txt");
			OBJECTIVES.state.findSecretPath[2] = 10;
		end
	end,
	
	joinDeathKnights = function()
	-- Lifecycle of this task is handled by map.xdb
		if OBJECTIVES.state.joinDeathKnights[2] == 1 and GetObjectiveState("Neck") == OBJECTIVE_ACTIVE then
			CINEMATICS.meetDeathKnights();
			Trigger(OBJECT_TOUCH_TRIGGER, "Neck_", "VisitDeathKnightHut");
			OBJECTIVES.state.joinDeathKnights[2] = 2;
		elseif OBJECTIVES.state.joinDeathKnights[2] == 2 and GetObjectiveState("Neck") == OBJECTIVE_COMPLETED then
			CINEMATICS.joinDeathKnights();
			OBJECTIVES.state.joinDeathKnights[2] = 10;
		end
	end,
	
	findVampireCrypts = function()
		if OBJECTIVES.state.findVampireCrypts[2] == 1 then  
			SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE );
			CINEMATICS.meetZombies();
			OBJECTIVES.state.findVampireCrypts[2] = 2;
		elseif OBJECTIVES.state.findVampireCrypts[2] == 2 and GetObjectOwner("vamp1") == PLAYER_1 and GetObjectOwner("vamp2") == PLAYER_1 and GetObjectOwner("vamp3") == PLAYER_1 then
			SetObjectiveState( 'sec2', OBJECTIVE_COMPLETED );
			SetTownBuildingLimitLevel( "t1", TOWN_BUILDING_DWELLING_4, 2 );
			SetTownBuildingLimitLevel( "t2", TOWN_BUILDING_DWELLING_4, 2 );
			OBJECTIVES.state.findVampireCrypts[2] = 10;
		end
	end
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
