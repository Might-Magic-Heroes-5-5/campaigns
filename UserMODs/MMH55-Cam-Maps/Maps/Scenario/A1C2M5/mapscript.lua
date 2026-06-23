doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end
H55_PlayerStatus = {0,1,2,1,1,2,2,2};
H55c_AI_CONTROLLED = {
  player1 = {          -- player 1player/human so state should be 0 to skip control of the heroes
      state = 0,       -- 0 human, 1 unmanaged AI, 2 managed AI
	   heroes = {},
	  enemies = {},
  },
  player2 = { 		     -- Red Haven player
      state = 2,         -- Make Lazlo charge the player
	   heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = 0.1, towns = 1.0, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
    }
  },
  player3 = { 		     --
      state = 1,         -- 
	   heroes = {},
	  enemies = {},
  },
  player4 = { 		     --
      state = 1,         -- 
	   heroes = {},
	  enemies = {},
  }
}

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C2M5");
	LoadHeroAllSetArtifacts( "Wulfstan", "A1C2M4" );
	LoadHeroAllSetArtifacts(   "Duncan", "A1C2M4" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Wulfstan" );
	H55_CamFixTooManySkills( PLAYER_1,   "Duncan" );	
end;

startThread(H55_InitSetArtifacts);

--========================== RED HAVEN HEROES RESPAWN SCRIPT ===========================================
--###################################### BEGIN #########################################################
--CONSTANTS
--Must be filled for each map

RH_RespawnPoints_XYZ_Town = { {121, 22, GROUND, "rtown"} };
-- {X, Y, FLOOR, RESPAWN TOWN Script name (if needed, if not must be a nil)}
	

RH_heroes = { "RedHeavenHero01", "RedHeavenHero02"}; -- Pool of Red Haven heroes
	
AI_PLAYER = PLAYER_2; -- AI player side
RH_heroes_must_alive_count = 2; -- Minimum of AI Red Haven heroes who might be at same time on the map
 
--=======================================================================

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
		sleep(5);
		while GetCurrentPlayer() ~= AI_PLAYER do
			sleep(10);
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
								startThread( transformTroops, RH_heroes[i] );
								break;
							else
								lostRespawmTowns = lostRespawmTowns + 1;
							end;
						else
							print("Respawn point without town. Trying to deploy hero ", RH_heroes[i]);
							DeployReserveHero( RH_heroes[i], RH_RespawnPoints_XYZ_Town[j][1], RH_RespawnPoints_XYZ_Town[j][2], RH_RespawnPoints_XYZ_Town[j][3] );
							startThread( transformTroops, RH_heroes[i] );
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
			sleep(10);
		end;
		print("RH_Respawn: AI player's turn has ended");
	end;
end;

function transformTroops( heroName )
	sleep(3);
	print("function transformTroops for hero ", heroName ," has started...");
	while IsHeroAlive ( heroName ) == not nil do
		for i=1,14 do
			creaturesCount = GetHeroCreatures( heroName, i );
			if creaturesCount  > 0 then
				RemoveHeroCreatures( heroName, i, 10000);
				n = i;
				if mod(i,2) ~= 0 then n = i+1; end;
				AddHeroCreatures( heroName, 105 + (n/2), creaturesCount );
			end;
		end;
		sleep(2);
	end;
	print("Hero ", heroName, " is dead. Function transformTroops terminated");
end;

startThread(RH_Respawn);

--###################################### END #########################################################
--===================================== MAIN SCRIPT BODY =============================================
PlayerHero1 = "Wulfstan"
PlayerHero2 = "Duncan"
EnemyHero = "Laszlo"

StartAdvMapDialog( 0 );

SetRegionBlocked("laszlo_block", not nil, PLAYER_2);
EnableHeroAI(EnemyHero, nil);

function diffsetup()
	for creatureID = 1, CREATURES_COUNT-1 do 
		CreatureSetUp = GetHeroCreatures(EnemyHero, creatureID);
		if GetHeroCreatures(EnemyHero, creatureID) > 2 then
			RemoveHeroCreatures(EnemyHero, creatureID, CreatureSetUp);
			AddHeroCreatures(EnemyHero, creatureID, CreatureSetUp * diff);
			ChangeHeroStat(EnemyHero, 	   STAT_ATTACK, 4 * diff);
			ChangeHeroStat(EnemyHero, 	  STAT_DEFENCE, 4 * diff);
			ChangeHeroStat(EnemyHero, STAT_SPELL_POWER, 2 * diff);
			ChangeHeroStat(EnemyHero, 	STAT_KNOWLEDGE, 2 * diff);
			ChangeHeroStat(EnemyHero,  STAT_EXPERIENCE, 260000 * diff);
		end
	end;
end;

SetObjectEnabled("portal", nil);

function portal()
	ShowFlyingSign("/Maps/Scenario/A1C2M5/portal.txt", "portal", 1, 5);
end;

SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
SetObjectiveState("obj4", OBJECTIVE_ACTIVE);

---------Main Objective 1----------

Trigger (OBJECT_CAPTURE_TRIGGER, "stug_dutchy", "objective1");

function objective1()
	if GetObjectiveState("obj1") == OBJECTIVE_ACTIVE then
		if GetObjectOwner("stug_dutchy") == PLAYER_1 then
			SetObjectiveState("obj1", OBJECTIVE_COMPLETED);
			SetAIPlayerAttractor("stug_dutchy", PLAYER_2, 2);
		end;
	end;
end;

---------Main Objective 2----------

Trigger (PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "objective2");

function objective2()
	if IsHeroAlive(EnemyHero) == nil and GetObjectiveState("obj2") == OBJECTIVE_ACTIVE then
		StartDialogScene("/DialogScenes/A1C2/M5/S1/DialogScene.xdb#xpointer(/DialogScene)", "d_scene", "autosave");
	end;
end;

function d_scene()
	SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
	print ("objective 2 completed");
	objective1();
end;

---------Main Objective 4----------

function objective4()
	while 1 do
		if IsHeroAlive(PlayerHero1) == nil or IsHeroAlive(PlayerHero2) == nil then
			SetObjectiveState("obj4", OBJECTIVE_FAILED);
			sleep(10);
			Loose();
			break;
		end;
	sleep( 20 );
	end;	
end;

-----------------Win------------------

function win_check()
	while 1 do
		if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and GetObjectiveState("obj2") == OBJECTIVE_COMPLETED then
			SetObjectiveState("obj4", OBJECTIVE_COMPLETED);
			sleep(20);
			SaveHeroAllSetArtifactsEquipped( "Wulfstan", "A1C2M5" );
			SaveHeroAllSetArtifactsEquipped(   "Duncan", "A1C2M5" );
			sleep(100);
			Win();
			break;
		end;
	sleep( 20 );
	end;
end;

------Laszlo Activation------

Trigger (OBJECT_TOUCH_TRIGGER, "library", "laszlo_ai_enabled");
Trigger (OBJECT_TOUCH_TRIGGER, "garrison", "laszlo_ai_enabled");
Trigger (OBJECT_TOUCH_TRIGGER, "laszlo_trigger", "laszlo_ai_enabled");

function laszlo_ai_enabled(hero)
	print("######### enable Laszlo");
	H55c_AIAddHero( EnemyHero );
	local gain = 1 + GetDifficulty() + 0.25 * GetDate(MONTH);
	H55c_updateArmy( EnemyHero, gain, H55c_CREATURES.HAVEN );
	if IsObjectExists("dummy") then
		RemoveObject("dummy");
	end
	if IsObjectExists("laszlo_trigger") then
		Trigger(OBJECT_TOUCH_TRIGGER, "laszlo_trigger", nil);
	end
	Trigger(OBJECT_TOUCH_TRIGGER,  "library", nil);
	Trigger(OBJECT_TOUCH_TRIGGER, "garrison", nil);
end

H55_NewDayTrigger = 1;

function H55_TriggerDaily()
	if GetDate(MONTH) == 6 then
		laszlo_ai_enabled();
		H55_NewDayTrigger = 0;
	end;
end;

startThread (objective4);
startThread (win_check);
Trigger (OBJECT_TOUCH_TRIGGER, "portal", "portal");

startThread( H55c_AI_main )
