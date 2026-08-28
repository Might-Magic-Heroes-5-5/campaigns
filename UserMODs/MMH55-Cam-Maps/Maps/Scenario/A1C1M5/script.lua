doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_PlayerStatus = {0,1,1,2,2,2,2,2};
H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
	ARTIFACT_DWARVEN_MITHRAL_GREAVES,
	ARTIFACT_DWARVEN_MITHRAL_HELMET,
	ARTIFACT_DWARVEN_MITHRAL_SHIELD
};

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C1M5");
	LoadHeroAllSetArtifacts( "Freyda" , "A1C1M4" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Freyda" );
end

startThread(H55_InitSetArtifacts);
slozhnost = GetDifficulty(); 
--========================== RED HAVEN HEROES RESPAWN SCRIPT ===========================================
--RH_RespawnPoints_XYZ_Town = { {62, 10, GROUND, "Castlegate"}, {128, 45, GROUND, "Chillbury"} };
RH_RespawnPoints_XYZ_Town = { {128, 45, GROUND, "Chillbury"} };
RH_RespawnPoints_XYZ_Town.n = table.length( RH_RespawnPoints_XYZ_Town );
RH_heroes = { "RedHeavenHero01", "RedHeavenHero02"}; -- Pool of Red Haven heroes
RH_heroes.n = table.length( RH_heroes );
RH_heroes_must_alive_count = 2; -- Minimum of AI Red Haven heroes who might be at same time on the map
RH_TownsTotal = 0;
DeployReserveHero( "RedHeavenHero01", 128, 45, GROUND );
DeployReserveHero( "RedHeavenHero02", 62, 9, GROUND );

for i=1, RH_RespawnPoints_XYZ_Town.n do
	if RH_RespawnPoints_XYZ_Town[i][4] ~= nil then
		EnableAIHeroHiring(PLAYER_3, RH_RespawnPoints_XYZ_Town[i][4], nil);
		RH_TownsTotal = RH_TownsTotal + 1;
		print("AI hero hiring was disabled at town ", RH_RespawnPoints_XYZ_Town[i][4]);
	end
end
print("AI has ",RH_TownsTotal," towns for respawn");

function RH_Respawn()
	print( "Function RH_respawn has started...");
	while 1 do
		sleep(5);
		while GetCurrentPlayer() ~= PLAYER_3 do
			sleep(10);
		end
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
							if GetObjectOwner( RH_RespawnPoints_XYZ_Town[j][4] )==PLAYER_3 then
								print("AI has Respawn point ", j," and town ", RH_RespawnPoints_XYZ_Town[j][4]);
								DeployReserveHero( RH_heroes[i], RH_RespawnPoints_XYZ_Town[j][1], RH_RespawnPoints_XYZ_Town[j][2], RH_RespawnPoints_XYZ_Town[j][3] );
								startThread( transformTroops, RH_heroes[i] );
								break;
							else
								lostRespawmTowns = lostRespawmTowns + 1;
							end
						else
							print("Respawn point without town. Trying to deploy hero ", RH_heroes[i]);
							DeployReserveHero( RH_heroes[i], RH_RespawnPoints_XYZ_Town[j][1], RH_RespawnPoints_XYZ_Town[j][2], RH_RespawnPoints_XYZ_Town[j][3] );
							startThread( transformTroops, RH_heroes[i] );
						end
					end
					if lostRespawmTowns == RH_RespawnPoints_XYZ_Town.n then print("RH_Respawn: AI doen't have any towns for respawn"); end
				else
					print("Hero can't be deployed");
				end		
			end
			if RH_dead_heroes == 0 then print("All AI heroes are alive."); end
		end
		while GetCurrentPlayer() == PLAYER_3 do
			sleep(10);
		end
		print("RH_Respawn: AI player's turn has ended");
	end
end

function transformTroops( heroName )
	sleep(3);
	print("function transformTroops for hero ", heroName ," has started...");
	while IsHeroAlive ( heroName ) == not nil do
		for i=1,14 do
			creaturesCount = GetHeroCreatures( heroName, i );
			if creaturesCount  > 0 then
				RemoveHeroCreatures( heroName, i, 10000);
				n = i;
				if mod(i,2) ~= 0 then n = i + 1; end
				AddHeroCreatures( heroName, 105 + (n/2), creaturesCount );
			end
		end
		sleep(2);
	end
	print("Hero ", heroName, " is dead. Function transformTroops terminated");
end
startThread(RH_Respawn);

function FortressUndergroundSubterraneanGate ( heroname )
	if IsObjectInRegion ("Freyda", "Enter_1") == not nil and GetObjectOwner("Cradl") ~= PLAYER_1 then
		PlayVisualEffect( "/Effects/_(Effect)/Spells/FrostRing.xdb#xpointer(/Effect)", "enter", "enter1", 0, 0, 0, 0, 0 );
		SetObjectPosition( heroname, 49, 165, 0 );
		sleep( 20 );
		MessageBox ("Maps/Scenario/A1C1M5/mess1.txt");
	end
end

function ChangeAllOwners()
    for t, object_type in { "BUILDING", "DWELLING", "TOWN", "HERO" } do
        for i, object in GetObjectNamesByType(object_type) do
            if GetObjectOwner(object) == PLAYER_2 then
                SetObjectOwner(object, PLAYER_1);
            end
        end
    end
end

function SetSail( heroname )
	if heroname == "Freyda" then
		OBJECTIVES.state.seizeTownPort[2] = 4;
	end
end

function Ambush( heroname )
	SetObjectPosition( heroname, 9, 151, 0 );
	sleep(2);
	QuestionBox("Maps/Scenario/A1C1M5/sp_mess1.txt", "BATTLES.ambush('"..heroname.."')");	
end

BATTLES = {
	ambush = function(hero)
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "s1", nil);
		print(hero);
		StartCombat(hero,nil,4,CREATURE_AIR_ELEMENTAL,1 + 9 * slozhnost,CREATURE_AIR_ELEMENTAL,1 + 9* slozhnost,CREATURE_AIR_ELEMENTAL,1 + 9* slozhnost,CREATURE_AIR_ELEMENTAL,1 + 9 * slozhnost,nil);
	end,
	
	sarge = function(hero)
		if hero == 'Freyda' then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Exit_1", nil);
			BlockGame();
			sleep(15);
			EnableHeroAI("Sarge", not nil);
			ChangeHeroStat( "Sarge", STAT_MOVE_POINTS, 30000 );
			MoveHeroRealTime( "Sarge", 43, 118, 0 );
			sleep(40);
			OpenCircleFog( 34, 26, 0, 4, PLAYER_1 );
			MoveCamera(34, 26, 0, 50, 1);
			sleep(120);
			MoveCamera(43, 114, 0, 50, 1);
			UnblockGame();
		end
	end,
	
	ving = function()
		BlockGame();
		DeployReserveHero( "Ving", 75, 4, GROUND );
		sleep(30);
		EnableHeroAI("Ving", not nil);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/SummonBoat_end.xdb#xpointer(/Effect)", "Ving", "Ving1", 0, 0, 0, 0, 0 );
		sleep(15);	
		ChangeHeroStat( "Ving", STAT_MOVE_POINTS, 30000 );
		local army_ratio = slozhnost + 1;
		AddObjectCreatures("Ving",     CREATURE_SERAPH, army_ratio *  20);
		AddObjectCreatures("Ving",   CREATURE_CHAMPION, army_ratio *  40);
		AddObjectCreatures("Ving",     CREATURE_ZEALOT, army_ratio *  60);
		AddObjectCreatures("Ving", CREATURE_VINDICATOR, army_ratio * 200);
		AddObjectCreatures("Ving", CREATURE_LONGBOWMAN, army_ratio * 250);
		AddObjectCreatures("Ving",   CREATURE_LANDLORD, army_ratio * 300);
		sleep(50);
		MoveHeroRealTime( "Ving", GetObjectPosition( "Freyda" )  );
		UnblockGame();
	end
}

CINEMATICS = {
	intro = function()
		StartAdvMapDialog( 0 );
		sleep( 2 );
	end,
	
	releaseDuncan = function()
		StartDialogScene("/DialogScenes/A1C1/M5/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

	outro = function()
		StartDialogScene("/DialogScenes/A1C1/M5/S2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

DIFFICULTY = {
	[0] = function()
		AddObjectCreatures("Castlegate", CREATURE_SERAPH, 8);
		AddObjectCreatures("Castlegate", CREATURE_CHAMPION, 15);
		AddObjectCreatures("Castlegate", CREATURE_ZEALOT, 30);
		AddObjectCreatures("Castlegate", CREATURE_BATTLE_GRIFFIN, 60);
		AddObjectCreatures("Castlegate", CREATURE_VINDICATOR, 120);
		AddObjectCreatures("Castlegate", CREATURE_LONGBOWMAN, 240);
		AddHeroCreatures("RedHeavenHero01", CREATURE_SERAPH, 3);
		AddHeroCreatures("RedHeavenHero01", CREATURE_CHAMPION, 5);	
		AddHeroCreatures("RedHeavenHero01", CREATURE_ZEALOT, 10);
		AddHeroCreatures("RedHeavenHero01", CREATURE_BATTLE_GRIFFIN, 20);
		AddHeroCreatures("RedHeavenHero01", CREATURE_VINDICATOR, 40);
		AddHeroCreatures("RedHeavenHero01", CREATURE_LONGBOWMAN, 80);
		AddHeroCreatures("RedHeavenHero01", CREATURE_LANDLORD, 180);
		GiveExp(  "Sarge", 200000 ); ---addexp
		GiveExp(   "Brem", 200000 ); ---addexp
		GiveExp( "RedHeavenHero01", 200000 ); ---addexp
		GiveExp( "RedHeavenHero02", 200000 ); ---addexp
		print ("normal");
	end,
	
	[1] = function()
		AddObjectCreatures("Castlegate", CREATURE_SERAPH, 15);
		AddObjectCreatures("Castlegate", CREATURE_CHAMPION, 30);
		AddObjectCreatures("Castlegate", CREATURE_ZEALOT, 60);
		AddObjectCreatures("Castlegate", CREATURE_BATTLE_GRIFFIN, 120);
		AddObjectCreatures("Castlegate", CREATURE_VINDICATOR, 240);
		AddObjectCreatures("Castlegate", CREATURE_LONGBOWMAN, 480);
		AddObjectCreatures("Dgar", CREATURE_SERAPH, 5);
		AddObjectCreatures("Dgar", CREATURE_LONGBOWMAN, 60);
		AddObjectCreatures("Dgar", CREATURE_VINDICATOR, 40);
		AddObjectCreatures("Dgar", CREATURE_ZEALOT, 20);
		AddHeroCreatures("RedHeavenHero01", CREATURE_SERAPH, 5);
		AddHeroCreatures("RedHeavenHero01", CREATURE_CHAMPION, 10);	
		AddHeroCreatures("RedHeavenHero01", CREATURE_ZEALOT, 20);
		AddHeroCreatures("RedHeavenHero01", CREATURE_BATTLE_GRIFFIN, 40);
		AddHeroCreatures("RedHeavenHero01", CREATURE_VINDICATOR, 80);
		AddHeroCreatures("RedHeavenHero01", CREATURE_LONGBOWMAN, 160);
		AddHeroCreatures("RedHeavenHero01", CREATURE_LANDLORD, 250);
		GiveExp(  "Sarge", 239000 ); ---addexp
		GiveExp(   "Brem", 239000 ); ---addexp
		GiveExp( "RedHeavenHero01", 343000 ); ---addexp
		GiveExp( "RedHeavenHero02", 239000 ); ---addexp
		print ("hard");
	end,
	
	[2] = function()
		AddObjectCreatures("Castlegate", CREATURE_SERAPH, 30);
		AddObjectCreatures("Castlegate", CREATURE_CHAMPION, 60);
		AddObjectCreatures("Castlegate", CREATURE_ZEALOT, 90);
		AddObjectCreatures("Castlegate", CREATURE_BATTLE_GRIFFIN, 180);
		AddObjectCreatures("Castlegate", CREATURE_VINDICATOR, 360);
		AddObjectCreatures("Castlegate", CREATURE_LONGBOWMAN, 720);
		AddObjectCreatures("Dgar", CREATURE_SERAPH, 10);
		AddObjectCreatures("Dgar", CREATURE_LONGBOWMAN, 120);
		AddObjectCreatures("Dgar", CREATURE_VINDICATOR, 135);
		AddObjectCreatures("Dgar", CREATURE_ZEALOT, 70);
		AddHeroCreatures("RedHeavenHero01", CREATURE_SERAPH, 10);
		AddHeroCreatures("RedHeavenHero01", CREATURE_CHAMPION, 20);	
		AddHeroCreatures("RedHeavenHero01", CREATURE_ZEALOT, 30);
		AddHeroCreatures("RedHeavenHero01", CREATURE_BATTLE_GRIFFIN, 60);
		AddHeroCreatures("RedHeavenHero01", CREATURE_VINDICATOR, 120);
		AddHeroCreatures("RedHeavenHero01", CREATURE_LONGBOWMAN, 240);
		AddHeroCreatures("RedHeavenHero01", CREATURE_LANDLORD, 330);
		GiveExp(  "Sarge", 343000 ); ---addexp
		GiveExp(   "Brem", 343000); ---addexp
		GiveExp( "RedHeavenHero01", 590000); ---addexp
		GiveExp( "RedHeavenHero02", 343000 ); ---addexp
		print ("heroic");
	end,
	
	[3] = function()
		AddObjectCreatures("Castlegate", CREATURE_SERAPH, 45);
		AddObjectCreatures("Castlegate", CREATURE_CHAMPION, 90);
		AddObjectCreatures("Castlegate", CREATURE_ZEALOT, 120);
		AddObjectCreatures("Castlegate", CREATURE_BATTLE_GRIFFIN, 240);
		AddObjectCreatures("Castlegate", CREATURE_VINDICATOR, 480);
		AddObjectCreatures("Castlegate", CREATURE_LONGBOWMAN, 960);
		AddObjectCreatures("Dgar", CREATURE_SERAPH, 16);
		AddObjectCreatures("Dgar", CREATURE_LONGBOWMAN, 180);
		AddObjectCreatures("Dgar", CREATURE_VINDICATOR, 150);
		AddObjectCreatures("Dgar", CREATURE_ZEALOT, 130);
		AddHeroCreatures("RedHeavenHero01", CREATURE_SERAPH, 15);
		AddHeroCreatures("RedHeavenHero01", CREATURE_CHAMPION,30);	
		AddHeroCreatures("RedHeavenHero01", CREATURE_ZEALOT, 40);
		AddHeroCreatures("RedHeavenHero01", CREATURE_BATTLE_GRIFFIN, 80);
		AddHeroCreatures("RedHeavenHero01", CREATURE_VINDICATOR, 160);
		AddHeroCreatures("RedHeavenHero01", CREATURE_LONGBOWMAN, 330);
		AddHeroCreatures("RedHeavenHero01", CREATURE_LANDLORD, 500);
		GiveExp(  "Sarge", 492000 ); ---addexp
		GiveExp(   "Brem", 492000); ---addexp
		GiveExp( "RedHeavenHero01", 1010000); ---addexp
		GiveExp( "RedHeavenHero02", 492000); ---addexp
		print ("impossible");
	end,
}

OBJECTIVES = {
	date = 0,
	state = {
		releaseDuncan = { "prim2", 1 },	-- free Duncan from inprisonment
		seizeTownPort = { "prim3", 0 },	-- capture port at Castlegate and set sail
		FreydaIsAlive = { "prim4", 1 },	-- Freyda must survive
		DuncanIsAlive = { "prim5", 0 },	-- Duncan must survive
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		EnableHeroAI("Sarge", nil);
		EnableHeroAI("Duncan", nil);
		SetRegionBlocked("deads", 1, PLAYER_2);   -- Keep AI Haven players away from undergronud tomb
		SetRegionBlocked("deads", 1, PLAYER_3);   -- Keep AI Haven players away from undergronud tomb
		SetRegionBlocked("Ally1", 1, PLAYER_3);   -- make AI Haven players not attack each other towns
		SetRegionBlocked("Ally2", 1, PLAYER_3);   -- make AI Haven players not attack each other towns
		SetRegionBlocked("Ally3", 1, PLAYER_3);   -- make AI Haven players not attack each other towns
		SetRegionBlocked("Ally4", 1, PLAYER_2);   -- make AI Haven players not attack each other towns
		SetRegionBlocked("Border1", 1, PLAYER_2); -- Make AI Haven players not go in/out of Castlegate
		SetRegionBlocked("Border2", 1, PLAYER_2); -- Make AI Haven players not go in/out of Castlegate
		SetRegionBlocked("Border1", 1, PLAYER_3); -- Make AI Haven players not go in/out of Castlegate
		SetRegionBlocked("Border2", 1, PLAYER_3); -- Make AI Haven players not go in/out of Castlegate
		SetRegionBlocked("Prison", 1, PLAYER_2);  -- Keep AI Haven players away from Duncan
		SetRegionBlocked("Prison", 1, PLAYER_3);  -- Keep AI Haven players away from Duncan
		SetRegionBlocked("Tr1", 1, PLAYER_2);     -- Keep AI Haven players away from artifact
		SetRegionBlocked("Tr2", 1, PLAYER_2); 	  -- Keep AI Haven players away from artifact
		SetRegionBlocked("Tr1", 1, PLAYER_3);     -- Keep AI Haven players away from artifact
		SetRegionBlocked("Tr2", 1, PLAYER_3);     -- Keep AI Haven players away from artifact
		SetRegionBlocked("spec", 1, PLAYER_3);    -- Keep AI Haven players away from interracting with Sarge
		SetRegionBlocked("stop1", 1, PLAYER_2);   -- Keep AI Haven players away from ambush
		SetRegionBlocked("stop1", 1, PLAYER_3);   -- Keep AI Haven players away from ambush
		SetRegionBlocked("AI_stop", 1, PLAYER_2); -- Keep AI Haven players away from Fortress underground
		SetRegionBlocked("AI_stop", 1, PLAYER_3); -- Keep AI Haven players away from Fortress underground
		startThread(DIFFICULTY[GetDifficulty()]);
		CINEMATICS.intro();
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Enter_1", "FortressUndergroundSubterraneanGate" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,  "Exit_1", "BATTLES.sarge" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "Final", "SetSail" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 	 "s1", "Ambush" );
		startThread( transformTroops, "RedHeavenHero01");
		startThread( transformTroops, "RedHeavenHero02");
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
			
			if GetObjectiveState("prim4") == OBJECTIVE_FAILED or GetObjectiveState("prim5") == OBJECTIVE_FAILED then
				sleep(40);
				Loose();
				return
			end
			
			if GetObjectiveState("prim3") == OBJECTIVE_COMPLETED and IsHeroAlive("Ving") == nil then
				CINEMATICS.outro();
				SaveHeroAllSetArtifactsEquipped("Freyda", "A1C1M5");
				SaveHeroAllSetArtifactsEquipped("Duncan", "A1C1M5");
				SetObjectiveState('prim4', OBJECTIVE_COMPLETED);
				SetObjectiveState('prim5', OBJECTIVE_COMPLETED);
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	releaseDuncan = function()
		if OBJECTIVES.state.releaseDuncan[2] == 1 then
			SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.releaseDuncan[2] = 2;
		elseif OBJECTIVES.state.releaseDuncan[2] == 2 and GetObjectOwner("Dgar") == PLAYER_1 then
			SetObjectOwner( "Duncan", PLAYER_1 );
			PlayVisualEffect( "/Effects/_(Effect)/Spells/Heal.xdb#xpointer(/Effect)", "Duncan", "Duncan1", 0, 0, 0, 0, 0 );	
			SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.seizeTownPort[2] = 1;
			OBJECTIVES.state.DuncanIsAlive[2] = 1;
			sleep(10);
			CINEMATICS.releaseDuncan();
			startThread(ChangeAllOwners);
			SetRegionBlocked(	"Ally1", nil, PLAYER_3 );
			SetRegionBlocked(	"Ally2", nil, PLAYER_3 );
			SetRegionBlocked(	"Ally3", nil, PLAYER_3 );
			GiveExp( "Duncan", 492000); --- This makes him level 30
			OBJECTIVES.state.releaseDuncan[2] = 10;
		end
	end,
	
	seizeTownPort = function()
		if OBJECTIVES.state.seizeTownPort[2] == 1 then
			SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.seizeTownPort[2] = 2;
		elseif OBJECTIVES.state.seizeTownPort[2] == 2 and GetObjectOwner("Castlegate") == PLAYER_1 then
			SetTownBuildingLimitLevel( "Castlegate", TOWN_BUILDING_SHIPYARD, 1 );
			OBJECTIVES.state.seizeTownPort[2] = 3;
		elseif OBJECTIVES.state.seizeTownPort[2] == 4 then
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
			BATTLES.ving();
			OBJECTIVES.state.seizeTownPort[2] = 10;
		end
	end,
	
	FreydaIsAlive = function()
		if OBJECTIVES.state.FreydaIsAlive[2] == 1 then
			SetObjectiveState( 'prim4', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.FreydaIsAlive[2] = 2;
		elseif OBJECTIVES.state.FreydaIsAlive[2] == 2 and IsHeroAlive("Freyda") == nil then
			SetObjectiveState( 'prim4', OBJECTIVE_FAILED );
			OBJECTIVES.state.FreydaIsAlive[2] = 11;
		end
	end,
	
	DuncanIsAlive = function()
		if OBJECTIVES.state.DuncanIsAlive[2] == 1 then
			SetObjectiveState( 'prim5', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.DuncanIsAlive[2] = 2;
		elseif OBJECTIVES.state.DuncanIsAlive[2] == 2 and IsHeroAlive("Duncan") == nil then
			SetObjectiveState( 'prim5', OBJECTIVE_FAILED );
			OBJECTIVES.state.DuncanIsAlive[2] = 11;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
