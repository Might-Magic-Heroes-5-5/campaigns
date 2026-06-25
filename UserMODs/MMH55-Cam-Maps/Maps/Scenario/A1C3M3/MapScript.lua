doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_PlayerStatus = {0,1,1,1,1,2,2,2};
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
	InitAllSetArtifacts("A1C3M3");
	LoadHeroAllSetArtifacts( "Shadwyn" , "A1C3M2" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Shadwyn" );
end

startThread(H55_InitSetArtifacts);

--========================== RED HAVEN HEROES RESPAWN SCRIPT ===========================================
--CONSTANTS: Must be filled for each map
RH_RespawnPoints_XYZ_Town = { {15, 66, UNDERGROUND, "Haven"} };
-- {X, Y, FLOOR, RESPAWN TOWN Script name (if needed, if not must be a nil)}
RH_heroes = { "RedHeavenHero01", "RedHeavenHero02"}; -- Pool of Red Haven heroes
AI_PLAYER = PLAYER_5; -- AI player side
RH_heroes_must_alive_count = 2; -- Minimum of AI Red Haven heroes who might be at same time on the map
RH_RespawnPoints_XYZ_Town.n = table.length( RH_RespawnPoints_XYZ_Town );
RH_heroes.n = table.length( RH_heroes );
RH_TownsTotal = 0;

for i=1, RH_RespawnPoints_XYZ_Town.n do
	if RH_RespawnPoints_XYZ_Town[i][4] ~= nil then
		EnableAIHeroHiring(AI_PLAYER, RH_RespawnPoints_XYZ_Town[i][4], nil);
		RH_TownsTotal = RH_TownsTotal + 1;
		print("AI hero hiring was disabled at town ", RH_RespawnPoints_XYZ_Town[i][4]);
	end;
end;
print("AI has ",RH_TownsTotal," towns for respawn");

function RH_Respawn()
	print( "Function RH_respawn has started...");
	while 1 do
		while GetCurrentPlayer() ~= AI_PLAYER do
			sleep(50);
		end;
		print("RH_Respawn: AI player's turn");
		RH_dead_heroes = 0;
		for i=1, RH_heroes.n do
			if IsHeroAlive( RH_heroes[i] ) == nil then
				print("RH_Respawn: AI hero ", RH_heroes[i]," is dead.");
				RH_dead_heroes = RH_dead_heroes + 1;	
				if RH_heroes.n - RH_dead_heroes < RH_heroes_must_alive_count then
					print("Count of AI RH heroes less than needed (",RH_heroes_must_alive_count,"). Hero ",RH_heroes[i]," must be placed.");
					lostRespawmTowns = 0;
					for j=1, RH_RespawnPoints_XYZ_Town.n do
						if IsObjectExists ( RH_RespawnPoints_XYZ_Town[j][4] )==not nil then
							if GetObjectOwner( RH_RespawnPoints_XYZ_Town[j][4] )==AI_PLAYER then
								print("AI has Respawn point ", j," and town ", RH_RespawnPoints_XYZ_Town[j][4]);
								DeployReserveHero( RH_heroes[i], RH_RespawnPoints_XYZ_Town[j][1], RH_RespawnPoints_XYZ_Town[j][2], RH_RespawnPoints_XYZ_Town[j][3] );
								break;
							else
								lostRespawmTowns = lostRespawmTowns + 1;
							end;
						else
							print("Respawn point without town. Trying to deploy hero ", RH_heroes[i]);
							DeployReserveHero( RH_heroes[i], RH_RespawnPoints_XYZ_Town[j][1], RH_RespawnPoints_XYZ_Town[j][2], RH_RespawnPoints_XYZ_Town[j][3] );
						end;
					end;
					if lostRespawmTowns == RH_RespawnPoints_XYZ_Town.n then print("RH_Respawn: AI doen't have any towns for respawn"); end;
				else
					print("Hero can't be deployed");
				end;		
			end;
			if RH_dead_heroes == 0 then print("All AI heroes are alive."); end;
		end;
		while GetCurrentPlayer() == AI_PLAYER do
			sleep(50);
		end;
		print("RH_Respawn: AI player's turn has ended");
	end;
end;

startThread(RH_Respawn);
-- ###################################### END #########################################################

function SetupEnemyHeroes( diff )
	DeployReserveHero( "Efion", RegionToPoint('INF'));
	ChangeHeroStat(	  "Efion", STAT_EXPERIENCE, 10000 * (4 - diff) );
	AddHeroCreatures( "Efion", 			CREATURE_IMP, (diff + 5) * 10 );
	AddHeroCreatures( "Efion", CREATURE_HORNED_DEMON, (diff + 5) *  5 );
	AddHeroCreatures( "Efion", 		CREATURE_CERBERI, (diff + 5) *  2 );
	DeployReserveHero( "RedHeavenHero03", RegionToPoint('RHH'));
	ChangeHeroStat(	  "RedHeavenHero03", 	 STAT_EXPERIENCE, 10000 * ( 4 - diff) );
	AddHeroCreatures( "RedHeavenHero03",   CREATURE_LANDLORD, (diff + 5) * 10);
	AddHeroCreatures( "RedHeavenHero03", CREATURE_LONGBOWMAN, (diff + 5) *  5);
	AddHeroCreatures( "RedHeavenHero03", CREATURE_VINDICATOR, (diff + 5) *  2);
	DeployReserveHero( "Almegir", RegionToPoint('DUNG') );
	ChangeHeroStat(   "Almegir", 	  STAT_EXPERIENCE, 10000 * (4 - diff) );
	AddHeroCreatures( "Almegir", 	CREATURE_ASSASSIN, (diff + 5) * 6 );
	AddHeroCreatures( "Almegir", CREATURE_BLOOD_WITCH, (diff + 5) * 4 );
	AddHeroCreatures( "Almegir", 	CREATURE_MINOTAUR, (diff + 5) * 2 );
	DeployReserveHero( "Una", RegionToPoint('DWF') );
	ChangeHeroStat(   "Una", 		  STAT_EXPERIENCE, 10000 * (4 - diff) );
	AddHeroCreatures( "Una",  CREATURE_STOUT_DEFENDER, (diff + 5) * 10 );
	AddHeroCreatures( "Una", 	 CREATURE_AXE_THROWER, (diff + 5) *  5 );
	AddHeroCreatures( "Una", CREATURE_BLACKBEAR_RIDER, (diff + 5) *  2 );
end

DIFFICULTY = {
	[0] = function()
		SetupEnemyHeroes(1);
	    print ("normal");
	end,
	
	[1] = function()
		SetupEnemyHeroes(1);
	    print ("hard");
	end,
	
	[2] = function()
		SetupEnemyHeroes(2);
	    print ("heroic");
	end,
		
	[3] = function()
		SetupEnemyHeroes(3);
	    print ("Impossible");
	end,
}

H55_HAVEN_RED_UPGRADE_MAP = {
	{  2, 106 }, -- Militia -> red upgrade
	{  4, 107 },
	{  6, 108 },
	{  8, 109 },
	{ 10, 110 },
	{ 12, 111 },
};

function A1C3M3_ConvertTownUnitsToRenegade( object )
	for i, data in H55_HAVEN_RED_UPGRADE_MAP do
		local oldCreature = data[1];
		local newCreature = data[2];
		local count = GetObjectCreatures(object, oldCreature);

		if count > 0 then
			RemoveObjectCreatures(object, oldCreature, count);
			AddObjectCreatures(object, newCreature, count);
		end
	end
end

function A1C3M3_ConvertHeroUnitsToRenegade( hero )
	for i, data in H55_HAVEN_RED_UPGRADE_MAP do
		local oldCreature = data[1];
		local newCreature = data[2];
		local count = GetHeroCreatures(hero, oldCreature);

		if count > 0 then
			RemoveHeroCreatures(hero, oldCreature, count);
			AddHeroCreatures(hero, newCreature, count);
		end
	end
end

function A1C3M3_SetHavenPlayerUnitUpgrades()
	local day = 1;
	while 1 do
		if day <= GetDate(ABSOLUTE_DAY) then
			pcall( A1C3M3_ConvertTownUnitsToRenegade, "Haven" );
			local heroes = GetPlayerHeroes(PLAYER_5);
			for i, hero in heroes do
				sleep(10);
				pcall( A1C3M3_ConvertHeroUnitsToRenegade, hero );
			end
			day = day + 1;
		end
		sleep(20);
	end
end


function engage_units(unit1, unit2)
	startThread( play_animation, unit1, unit2 );
	startThread( check_pairs, unit1, unit2 );
end

function check_pairs(unit1, unit2)
	while 1 do
		sleep(10);
		if IsObjectExists(unit1) == nil then
			if IsObjectExists(unit2) ~= nil then RemoveObject(unit2); end;
			return
		elseif IsObjectExists(unit2) == nil then
			if IsObjectExists(unit1) ~= nil then RemoveObject(unit1); end;
			return
		end
	end
end

function play_animation(unit1, unit2)
	while 1 do
		sleep(100);
		local mover1 = nil;
		local mover2 = nil;
		if random(2) == 0 then
			mover1, mover2 = unit1, unit2;
		else
			mover1, mover2 = unit2, unit1;
		end
		
		if IsObjectExists(mover1) ~= nil then
			PlayObjectAnimation(mover1, "attack00", ONESHOT);
		end
		sleep(12);
		if IsObjectExists(mover2) ~= nil then
			PlayObjectAnimation(mover2, "hit", ONESHOT);
		end
		sleep(random(150));
	end
end

function portalLocation( hero )
	if hero == "Shadwyn" then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "finish",  nil );
		OBJECTIVES.state.reachPortal[2] = 3;
	end
end;

function StartSeerQuest( hero )
	if hero == "Shadwyn" then
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", nil);
		OBJECTIVES.state.getArtifacts[2] = 1;
	else
		ShowFlyingSign("/Maps/Scenario/A1C3M3/flytext.txt", "hut", -1, 3.0);
	end
end

function HasCollectedDragonArtifacts( hero )
	for a = 36,43 do
		if HasArtefact( hero, a) == nil then
			return 0;
		end
	end
	return 1;
end

function ReturnArtifactsToSeer( hero )
	if hero == "Shadwyn" then
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", nil);
		OBJECTIVES.state.returnArtifacts[2] = 3;
	end
end

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/A1C3/M3/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/A1C3/M3/S2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}	

OBJECTIVES = {
	state = {
		reachPortal		 = { "obj1", 1 }, -- Reach the sacred Asylum portal
		keepMalassaAlive = { "obj2", 1 }, -- Malassa must survive
		isAlive			 = { "obj3", 1 }, -- Shadwyn must survive
		getArtifacts     = { "sec1", 0 }, -- Find Dragon set artifacts
		returnArtifacts	 = { "sec2", 1 }, -- Return Dragon set artifacts to Seer
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

    prepare = function()
		for a = 1,7 do
			for b = 2,5 do
				SetRegionBlocked( "fighting"..a, 1, b );
			end
		end
		CINEMATICS.intro();
		startThread(DIFFICULTY[GetDifficulty()]);
		Trigger(OBJECT_TOUCH_TRIGGER, "hut", "StartSeerQuest");
		SetObjectEnabled('hut', nil);
		startThread( engage_units,  "training1",  "training2" );
		startThread( engage_units,  "training3",  "training4" );
		startThread( engage_units,  "training5",  "training6" );
		startThread( engage_units,  "training7",  "training8" );
		startThread( engage_units,  "training9", "training10" );
		startThread( engage_units, "training11", "training12" );
		startThread( engage_units, "training13", "training14" );
		startThread( A1C3M3_SetHavenPlayerUnitUpgrades );
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

			if GetObjectiveState("obj2") == OBJECTIVE_FAILED or GetObjectiveState("obj3") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Shadwyn", "A1C3M3");
				SetObjectPosition("Shadwyn", 50, 50, 0);
				sleep( 60 );
				Save("autosave");
				CINEMATICS.outro();
				sleep( 40 );
				Win();
				return
			end
		end
	end,
	
	reachPortal = function()
		if OBJECTIVES.state.reachPortal[2] == 1 then
			SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "finish", "portalLocation" );
			OBJECTIVES.state.reachPortal[2] = 2;
		elseif OBJECTIVES.state.reachPortal[2] == 3 then
			SetObjectiveState( "obj1", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.reachPortal[2] = 10;
		end
	end,
	
	keepMalassaAlive = function()
		if OBJECTIVES.state.keepMalassaAlive[2] == 1 then
			SetObjectiveState( "obj2", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.keepMalassaAlive[2] = 2;
		elseif OBJECTIVES.state.keepMalassaAlive[2] == 2 and GetHeroCreatures("Shadwyn", CREATURE_BLACK_DRAGON) == 0 then
			SetObjectiveState( "obj2", OBJECTIVE_FAILED );
			OBJECTIVES.state.keepMalassaAlive[2] = 11;
		end
	end,
	
	isAlive = function()
	-- start of this task is handled by map.xdb
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Shadwyn") == nil then
			SetObjectiveState( 'obj3', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	getArtifacts = function()
		if OBJECTIVES.state.getArtifacts[2] == 1 then
			SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.getArtifacts[2] = 2;
		elseif OBJECTIVES.state.getArtifacts[2] == 2 and HasCollectedDragonArtifacts("Shadwyn") == 1 then
			SetObjectiveState( 'sec1', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.getArtifacts[2] = 10;
		end
	end,
	
	returnArtifacts = function()
		if OBJECTIVES.state.returnArtifacts[2] == 1 and OBJECTIVES.state.getArtifacts[2] == 10 then
			SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE );
			Trigger( OBJECT_TOUCH_TRIGGER, "hut", "ReturnArtifactsToSeer" );
			OBJECTIVES.state.returnArtifacts[2] = 2;
		elseif OBJECTIVES.state.returnArtifacts[2] == 3 then
			SetObjectiveState( 'sec2', OBJECTIVE_COMPLETED );
			for a = 36,43 do
				RemoveArtefact("Shadwyn", a);
			end
			SetObjectPosition("Shadwyn", RegionToPoint('tele'));
			OBJECTIVES.state.returnArtifacts[2] = 10;
		end
	end,
}
		
------------------- MAIN ------------------------
startThread(OBJECTIVES.start);
