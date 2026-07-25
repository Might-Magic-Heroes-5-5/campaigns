doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55c_AI_CONTROLLED = {
	player1 = {          -- player 1player/human so state should be 0 to skip control of the heroes
		state = 0,       -- 0 human, 1 unmanaged AI, 2 managed AI
		heroes = {},
		enemies = {},
	},
	player2 = { 		   -- Duncan allied army
		state = 1,
		heroes = {},
		enemies = {},
	},
	player3 = { 		   -- Red Haven player.
		state = 1,
		heroes = {},
		enemies = {},
	},
	player4 = { 		   -- Inferno AI player
		state = 2,         -- Leads onslaught against player town.
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
			{ priority = 0.5, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER3
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER5
		},
	},
	player5 = { 		   -- King Tolghar dwarven army
		state = 1,
		heroes = {},
		enemies = {},
	},
}

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C3M5");
	LoadHeroAllSetArtifacts( "Shadwyn",  "A1C3M4" );
	sleep(40);
	H55_CamFixTooManySkills(  PLAYER_1, "Shadwyn" );
	H55_CamFixTooManySkills(  PLAYER_2, "Duncan" );
	H55_CamFixTooManySkills(  PLAYER_1, "Isabell_A1");
end

startThread(H55_InitSetArtifacts);

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

--========================== RED HAVEN HEROES RESPAWN SCRIPT ===========================================
RH_RespawnPoints_XYZ_Town = { {121, 22, GROUND, "rtown"} };
-- {X, Y, FLOOR, RESPAWN TOWN Script name (if needed, if not must be a nil)}
RH_heroes = { "RedHeavenHero01" }; -- Pool of Red Haven heroes
AI_PLAYER = PLAYER_3; -- AI player side
RH_heroes_must_alive_count = 1; -- Minimum of AI Red Haven heroes who might be at same time on the map
RH_RespawnPoints_XYZ_Town.n = table.length( RH_RespawnPoints_XYZ_Town );
RH_heroes.n = table.length( RH_heroes );

RH_TownsTotal = 0;
for i=1, RH_RespawnPoints_XYZ_Town.n do
	if RH_RespawnPoints_XYZ_Town[i][4] ~= nil then
		EnableAIHeroHiring(AI_PLAYER, RH_RespawnPoints_XYZ_Town[i][4], nil);
		RH_TownsTotal = RH_TownsTotal + 1;
		print("AI hero hiring was disabled at town ", RH_RespawnPoints_XYZ_Town[i][4]);
	end
end
print("AI has ",RH_TownsTotal," towns for respawn");

function RH_Respawn()
	print( "Function RH_respawn has started...");
	while 1 do
		sleep(20);
		while GetCurrentPlayer() ~= AI_PLAYER do
			sleep(20);
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
							if GetObjectOwner( RH_RespawnPoints_XYZ_Town[j][4] )==AI_PLAYER then
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
		while GetCurrentPlayer() == AI_PLAYER do
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
		sleep(30);
	end
	print("Hero ", heroName, " is dead. Function transformTroops terminated");
end

startThread(RH_Respawn);
--===================================== MAIN SCRIPT BODY =============================================
ALARIC = 'RedHeavenHero03';

DIFFICULTY = {
	[0] = function()
		diff = 1;
		redhaven_coeff = 1.0;
        infernotown_coef = 1.25;
	end,
	[1] = function()
		diff = 2;
		redhaven_coeff = 1.75;
        infernotown_coef = 2.50;
	end,
	[2] = function()
		diff = 3;
		redhaven_coeff = 2.50;
        infernotown_coef = 3.75;
	end,
	[3] = function()
		diff = 4;
		redhaven_coeff = 3.25;
        infernotown_coef = 5;
	end,
}

function SetupEnemyArmies()
	AddHeroCreatures('KingTolghar',  CREATURE_STOUT_DEFENDER, diff * 350 );
	AddHeroCreatures('KingTolghar',		CREATURE_AXE_THROWER, diff * 230 );
	AddHeroCreatures('KingTolghar', CREATURE_BLACKBEAR_RIDER, diff * 130 );
	AddHeroCreatures('KingTolghar',		  CREATURE_BERSERKER, diff * 85 );
	AddHeroCreatures('KingTolghar',		 CREATURE_FLAME_MAGE, diff * 50 );
	AddHeroCreatures('KingTolghar',			CREATURE_WARLORD, diff * 30 );
	AddHeroCreatures('KingTolghar',	   CREATURE_MAGMA_DRAGON, diff * 20 );
	AddObjectCreatures( "rtown",			 CREATURE_ZEALOT, 24 * redhaven_coeff );
	AddObjectCreatures( "rtown",		   CREATURE_CHAMPION, 16 * redhaven_coeff );
	AddObjectCreatures( "rtown",			 CREATURE_SERAPH, 8 * redhaven_coeff );
	AddHeroCreatures("RedHeavenHero02",		 CREATURE_SERAPH, 1 * diff);
	AddHeroCreatures("RedHeavenHero02",	   CREATURE_CHAMPION, 2 * diff);
	AddHeroCreatures("RedHeavenHero02",		 CREATURE_ZEALOT, 3 * diff);
	AddHeroCreatures("RedHeavenHero02",	 CREATURE_VINDICATOR, 10 * diff);
	AddHeroCreatures("RedHeavenHero02",	 CREATURE_LONGBOWMAN, 15 * diff);
	AddObjectCreatures( "inferno3",	CREATURE_QUASIT, 40 * infernotown_coef );
	AddObjectCreatures( "inferno3",	CREATURE_FIRE_ELEMENTAL, 13 * infernotown_coef );
	AddObjectCreatures( "inferno3",	CREATURE_FIREBREATHER_HOUND, 17 * infernotown_coef );
	AddObjectCreatures( "inferno3",	CREATURE_SUCCUBUS_SEDUCER, 13 * infernotown_coef );
	AddObjectCreatures( "inferno3",	CREATURE_HELLMARE, 10 * infernotown_coef );
	AddObjectCreatures( "inferno3",	CREATURE_PIT_SPAWN, 5 * infernotown_coef );
	AddObjectCreatures( "inferno3",	CREATURE_ARCH_DEMON, 3 * infernotown_coef );
	AddObjectCreatures( "inferno2",	CREATURE_FAMILIAR, 60 * infernotown_coef );
	AddObjectCreatures( "inferno2",	CREATURE_FIRE_ELEMENTAL, 16 * infernotown_coef );
	AddObjectCreatures( "inferno2",	CREATURE_HELL_HOUND, 20 * infernotown_coef );
	AddObjectCreatures( "inferno2",	CREATURE_SUCCUBUS, 16 * infernotown_coef );
	AddObjectCreatures( "inferno2",	CREATURE_NIGHTMARE, 12 * infernotown_coef );
	AddObjectCreatures( "inferno2",	CREATURE_PIT_FIEND, 6 * infernotown_coef );
	AddObjectCreatures( "inferno2",	CREATURE_DEVIL, 4 * infernotown_coef );
	AddObjectCreatures( "inferno1",	CREATURE_IMP, 60 * infernotown_coef );
	AddObjectCreatures( "inferno1",	CREATURE_FIRE_ELEMENTAL, 16 * infernotown_coef );
	AddObjectCreatures( "inferno1",	CREATURE_CERBERI, 20 * infernotown_coef );
	AddObjectCreatures( "inferno1",	CREATURE_INFERNAL_SUCCUBUS, 16 * infernotown_coef );
	AddObjectCreatures( "inferno1",	CREATURE_FRIGHTFUL_NIGHTMARE, 12 * infernotown_coef );
	AddObjectCreatures( "inferno1",	CREATURE_BALOR, 6 * infernotown_coef );
	AddObjectCreatures( "inferno1",	CREATURE_ARCHDEVIL, 4 * infernotown_coef );
	sleep(10);
	ChangeHeroStat( 'KingTolghar',      STAT_ATTACK, diff * 3 );
	ChangeHeroStat( 'KingTolghar',     STAT_DEFENCE, diff * 3 );
	ChangeHeroStat( 'KingTolghar', STAT_SPELL_POWER, diff * 3 );
	ChangeHeroStat( 'KingTolghar',   STAT_KNOWLEDGE, diff * 3 );
	ChangeHeroStat( 'Efion',      STAT_ATTACK, diff * 2 );
	ChangeHeroStat( 'Efion',     STAT_DEFENCE, diff * 2 );
	ChangeHeroStat( 'Efion', STAT_SPELL_POWER, diff * 2 );
	ChangeHeroStat( 'Efion',   STAT_KNOWLEDGE, diff * 2 );	
	ChangeHeroStat( 'Jazaz',      STAT_ATTACK, diff * 2 );
	ChangeHeroStat( 'Jazaz',     STAT_DEFENCE, diff * 2 );
	ChangeHeroStat( 'Jazaz', STAT_SPELL_POWER, diff * 2 );
	ChangeHeroStat( 'Jazaz',   STAT_KNOWLEDGE, diff * 2 );	
	ChangeHeroStat( 'Nymus', STAT_SPELL_POWER, diff * 2 );
	ChangeHeroStat( 'Nymus',   STAT_KNOWLEDGE, diff * 2 );	
	GiveExp(     'KingTolghar', 100000 + 40000 * math.pow(2, diff));
	GiveExp( 'RedHeavenHero01', 100000 + 40000 * math.pow(2, diff));
	GiveExp(            ALARIC, 100000 + 40000 * math.pow(2, diff));
	GiveExp( 'RedHeavenHero02', 100000 + 40000 * math.pow(2, diff));
	
	diff = GetDifficulty() + 1;
	if diff > 1 then
	    GiveHeroSkill("Efion", NECROMANCER_FEAT_CHILLING_STEEL);
		GiveHeroSkill("Jazaz", PERK_BALLISTA);
		GiveHeroSkill("Nymus", PERK_INTELLIGENCE);		
	end
	if diff > 2 then   
	    GiveHeroSkill("Efion", KNIGHT_FEAT_RETRIBUTION);
	    GiveHeroSkill("Efion", WARLOCK_FEAT_ELITE_CASTERS);
	    GiveHeroSkill("Jazaz", KNIGHT_FEAT_RETRIBUTION);
	    GiveHeroSkill("Jazaz", NECROMANCER_FEAT_LAST_AID);	
	    GiveHeroSkill("Nymus", RANGER_FEAT_ELVEN_LUCK);
	    GiveHeroSkill("Nymus", PERK_RESISTANCE);		
	end
    if diff > 3 then
	    GiveHeroSkill("Efion", HERO_SKILL_SHRUG_DARKNESS);
	    GiveHeroSkill("Efion", RANGER_FEAT_ELVEN_LUCK);
		GiveHeroSkill("Efion", PERK_LUCKY_STRIKE);
	    GiveHeroSkill("Jazaz", HERO_SKILL_EMPATHY);
	    GiveHeroSkill("Jazaz", PERK_PRAYER);
		GiveHeroSkill("Jazaz", HERO_SKILL_STUNNING_BLOW);
	    GiveHeroSkill("Nymus", DEMON_FEAT_CRITICAL_GATING);
	    GiveHeroSkill("Nymus", DEMON_FEAT_QUICK_GATING);
		GiveHeroSkill("Nymus", HERO_SKILL_QUICKNESS_OF_MIND);		
	end
end

-- управление эффектами и анимациями катапульты
function Catapult()
	while IsHeroAlive( 'RedHeavenHero02' ) do
		if ( IsObjectVisible( PLAYER_1, 'kotopult' ) ) then
			PlayObjectAnimation( 'kotopult', 'rangeattack', ONESHOT );
			sleep( 15 );
			local x, y = GetObjectPosition( 'SD' );
			local dx = random( 7 ) - 3;
			local dy = random( 7 ) - 3;
			local dz = 1;
			if ( dx == 0 ) and ( dy >= 1 ) and ( dy <= 2 ) then
				dz = 9;
			elseif ( math.abs( dx ) <= 1 ) and ( dy >= 1 ) and ( dy <= 2 ) then
				dz = 8;
                        elseif ( math.abs( dx ) <= 1 ) and ( dy >= -2 ) and ( dy <= 0 ) then
				dz = 7;
			end
			dx = dx + 1;
			dy = dy - 1;
			x = x + dx;
			y = y + dy;
			if dz == 1 then
				PlayVisualEffect( "/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", 'SD', 'boom', dx, dy, dz, 0, 0 );
			else
				PlayVisualEffect( "/Effects/_(Effect)/Characters/CatapultChargeExplosion.xdb#xpointer(/Effect)", 'SD', 'boom', dx, dy, dz, 0, 0 );
			end
			Play3DSound( "/Sounds/_(Sound)/SFX/FireballHitMono.xdb#xpointer(/Sound)", x, y, 0 );
		end
		sleep( 400 + random(100) );
	end
end

function Siege( counter )
	sleep( 10 );
	while IsObjectExists( 'siege' .. counter ) do
		if ( IsObjectVisible( PLAYER_1, 'siege' .. counter ) ) then
			if counter <= 4 then
				PlayObjectAnimation( 'siege' .. counter, 'happy', ONESHOT );
			elseif counter <= 8 then
				PlayObjectAnimation( 'siege' .. counter, 'stir00', ONESHOT );
			elseif counter <= 12 then
				PlayObjectAnimation( 'siege' .. counter, 'rangeattack', ONESHOT );
			end
		end
		sleep( 200 + random( 100 ) );
	end
end

function RedHavenHeroLost( heroname )
	if  heroname == 'RedHeavenHero02' then
		RazeBuilding( 'kotopult' );
		sleep( 10 );
		PlayObjectAnimation( 'kotopult', 'death', ONESHOT_STILL );
		StopVisualEffects( "townfire" );
	end
end

CINEMATICS = {
	intro = function()
		StartAdvMapDialog( 0 );
		sleep( 2 );
    end,
	
	liftSiege = function()
		StartDialogScene( "/DialogScenes/A1C3/M5/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep( 2 );
    end,
	
	alaricEscape = function()
		StartDialogScene( "/DialogScenes/A1C3/M5/S2/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep( 2 );
    end,
	
	outro = function()
		StartDialogScene( "/DialogScenes/A1C3/OUTRO/O1/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep( 2 );
    end,
}

function AlaricEscape( oldowner, newowner, heroname )
	if newowner == PLAYER_1 then
		Trigger( OBJECT_TOUCH_TRIGGER, 'portal', 'RemoveAlaric' );
		DisableCameraFollowHeroes( 0, 0, 1 ); -- не двигать камеру за Андреем
		OpenCircleFog( 82, 101, 0, 10, PLAYER_1 );
		sleep(1);
		MoveCamera( 82, 101, GROUND, 40, 1.3, 0, 1, 1 ,1); -- переместить камеру
		sleep(20);
		while IsHeroAlive( ALARIC ) ~= nil do
			EnableHeroAI( ALARIC, not nil );			
			MoveHeroRealTime( ALARIC, 75, 97, 0 );
			sleep(2);
			ChangeHeroStat( ALARIC, STAT_MOVE_POINTS, 2500 );
		end
		print("AlaricEscape: Alaric is in teleport");
	end
end

-- удаление Аларика после телепорта
function RemoveAlaric( heroname )
	if heroname == ALARIC then
		sleep( 7 );
		RemoveObject( ALARIC );
		sleep( 1 );
		SetRegionBlocked( 'block_end', 1, PLAYER_1 );
		DisableCameraFollowHeroes( 0, 0, 0 );
		sleep( 1 );
		CINEMATICS.alaricEscape();
	end
end

-- PLAYER_1 = HUMAN
-- PLAYER_2 = ALLY (SD CAPITAL)
-- PLAYER_3 = RED HAVEN
-- PLAYER_4 = INFERNO
-- PLAYER_5 = DWARF

OBJECTIVES = {
	state = {
		reachHorncrest	= { "prim1", 1 }, 	-- Reach Horncrest town
		liftSiege		= { "prim2", 0 }, 	-- Lift the siege over Horncrest
		captureTorHrall	= { "prim3", 0 }, 	-- Capture TorHrall town
		isAlive			= { "prim4", 1 }, 	-- Capture TorHrall town
		demonRaids		= {  "sec1", 0 }, 	-- Stop the demon raids
		eventManager	= {  "_", 1 }, 	-- Heaven enemy reinforcements
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		SetRegionBlocked("gate", 1, PLAYER_3); 
		SetRegionBlocked( 'deploy1', 1, PLAYER_1 );
		SetRegionBlocked( 'deploy2', 1, PLAYER_1 );
		SetObjectEnabled('treasury', nil );
		SetObjectEnabled(  'prison', nil );
		Trigger(   OBJECT_TOUCH_TRIGGER,  "treasury", "TouchTreasury" ); -- сокровищница
		Trigger(   OBJECT_TOUCH_TRIGGER,    "prison",   "TouchPrison" ); -- тюрьма
		Trigger( OBJECT_CAPTURE_TRIGGER, "garrison1",  "AlaricEscape" ); -- потеря героя гномов-врагов
		startThread( Catapult ); -- катапульта и эффекты осады
		for i = 1, 12 do
			startThread( Siege, i ); -- анимации осаждающих кричей
		end
		for i = PLAYER_3, PLAYER_5 do -- уменьшить приоритет нейтрального города и заблокировать гномскую сокровищницу для всех врагов
			SetAIPlayerAttractor( 'dungeon_town', i, -1 );
			SetRegionBlocked( 'treasury', 1, i );
		end
		CINEMATICS.intro();
		DIFFICULTY[GetDifficulty()]();
		SetupEnemyArmies();
		EnableAIHeroHiring( PLAYER_2, 'SD', nil );
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, "RedHavenHeroLost" );
		FireWorks();
		EnableHeroAI( 'RedHeavenHero02', nil ); -- so hero stays at Horncrest siege
		EnableHeroAI(		   'Duncan', nil ); -- сидит в замке
		EnableHeroAI(	  'KingTolghar', nil ); -- сидит в Tor Hrall
		EnableHeroAI(			 ALARIC, nil ); -- Аларик, сидит около Tor Hrall
		EnableHeroAI(			"Jazaz", nil ); -- make inferno town guardian sit still
		EnableHeroAI(			"Nymus", nil ); -- make inferno town guardian sit still
		EnableHeroAI(			"Efion", nil ); -- make inferno town guardian sit still
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
			
			if GetObjectiveState('prim1') == OBJECTIVE_FAILED or GetObjectiveState("prim3") == OBJECTIVE_FAILED or GetObjectiveState("prim4") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
				Save("autosave");
				sleep(40);
				CINEMATICS.outro();
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	_reachHorcrest_location = function(hero)
		if GetObjectOwner(hero) == PLAYER_1 then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'nearSD', nil );
			OBJECTIVES.state.reachHorncrest[2] = 3;
		end
	end,
	
	reachHorncrest = function()
		if OBJECTIVES.state.reachHorncrest[2] == 1 then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'nearSD', "OBJECTIVES._reachHorcrest_location" );
			SetObjectiveState( 'prim1', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.reachHorncrest[2] = 2;
		elseif OBJECTIVES.state.reachHorncrest[2] == 2 and OBJECTIVES.date > 7 then
			SetObjectiveState( 'prim1', OBJECTIVE_FAILED );
		elseif OBJECTIVES.state.reachHorncrest[2] == 3 then
			SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.liftSiege[2] = 1;
			OBJECTIVES.state.reachHorncrest[2] = 10;
		end
	end,

	liftSiege = function()
		if OBJECTIVES.state.liftSiege[2] == 1 then
			SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.liftSiege[2] = 2;
		elseif OBJECTIVES.state.liftSiege[2] == 2 and siege_size() == 0 and IsHeroAlive("RedHeavenHero02") == nil and GetCurrentPlayer() == PLAYER_1 then
			CINEMATICS.liftSiege();
			SetObjectOwner( 'Duncan', PLAYER_1 );
			SetObjectOwner( 'SD', 0 );
			SetObjectOwner( 'SD', 1 );
			DeployReserveHero( 'Freyda', 13, 8, 0 );
			DeployReserveHero( 'Wulfstan', 17, 8, 0 );
			sleep(30);
			LoadHeroAllSetArtifacts(   "Freyda", "A1C1M5" );
			LoadHeroAllSetArtifacts( "Wulfstan", "A1C2M5" );
			LoadHeroAllSetArtifacts(   "Duncan", "A1C2M5" );
			sleep(20);
			H55_CamFixTooManySkills( PLAYER_1,   "Freyda" );
			H55_CamFixTooManySkills( PLAYER_1, "Wulfstan" );
			H55_CamFixTooManySkills( PLAYER_1, "Duncan" );
			SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
			SetRegionBlocked( 'deploy1', nil, PLAYER_1 );
			SetRegionBlocked( 'deploy2', nil, PLAYER_1 );
			SetRegionBlocked("gate", nil, PLAYER_3);
			sleep(5);
			SetAIPlayerAttractor( 'SD', PLAYER_3, 1 );
			OBJECTIVES.state.captureTorHrall[2] = 1;
			OBJECTIVES.state.demonRaids[2] = 1;
			OBJECTIVES.state.liftSiege[2] = 10;
		end
	end,
		
	captureTorHrall_doomDay = 0,
	captureTorHrall = function()
		if OBJECTIVES.state.captureTorHrall[2] == 1 then
			OBJECTIVES.captureTorHrall_doomDay = OBJECTIVES.date + 56;
			SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureTorHrall[2] = 2;
		elseif OBJECTIVES.state.captureTorHrall[2] == 2 and GetObjectOwner("TorHrall") == PLAYER_1 then
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.captureTorHrall[2] = 10;
		end
		
		if OBJECTIVES.captureTorHrall_doomDay <= OBJECTIVES.date then
			SetObjectiveState( "prim3", OBJECTIVE_FAILED );
			OBJECTIVES.state.captureTorHrall[2] = 11;
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			if IsHeroAlive('Isabell_A1') == nil or IsHeroAlive('Shadwyn') == nil or IsHeroAlive('Duncan') == nil or 
			( OBJECTIVES.state.liftSiege[2] == 10 and ( IsHeroAlive('Freyda') == nil or IsHeroAlive('Wulfstan') == nil )) then
				SetObjectiveState( 'prim4', OBJECTIVE_FAILED );
				OBJECTIVES.state.isAlive[2] = 11;
			end
		end
	end,
	
	demonRaids_TownReinforcementDay = 8, 
	demonRaids = function()
		if OBJECTIVES.state.demonRaids[2] == 1 then
			SetObjectiveState('sec1', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.demonRaids[2] = 2;
		elseif OBJECTIVES.state.demonRaids[2] == 2 then
			if IsHeroAlive("Marder") == nil and GetDate( DAY_OF_WEEK ) == 1 and owned_demon_towns() < 3 then
				DeployReserveHero( "Marder", 78, 26, 1 );
				sleep(20);
				H55c_AIAddHero( "Marder" );
				local gain = 1 + GetDifficulty() + 0.25 * GetDate( MONTH );
				H55c_updateArmy( "Marder", gain, H55c_CREATURES.INFERNO );
				if diff > 1 then
					GiveHeroSkill("Marder", SKILL_GATING);		
				end
				if diff > 2 then   
					GiveHeroSkill("Marder", SKILL_GATING);
					GiveHeroSkill("Marder", PERK_DEMONIC_FIRE);
				end
				if diff > 3 then
					GiveHeroSkill("Marder", SKILL_GATING);
					GiveHeroSkill("Marder", DEMON_FEAT_DEMONIC_RETALIATION);
					GiveHeroSkill("Marder", DEMON_FEAT_GATING_MASTERY);		
				end
			elseif owned_demon_towns() == 3 then
				SetObjectiveState('sec1', OBJECTIVE_COMPLETED);
				OBJECTIVES.state.demonRaids[2] = 10;
			end
		end
		
		if OBJECTIVES.date > OBJECTIVES.demonRaids_TownReinforcementDay then
			for i, town in { "inferno1", "inferno2", "inferno3" } do
				if GetObjectOwner( town ) == PLAYER_4 then
					A1C3M5_reinforce_inferno_town( town );
				end
			end
			 OBJECTIVES.demonRaids_TownReinforcementDay = OBJECTIVES.demonRaids_TownReinforcementDay + 7;
		end
	end,
	
	eventManager_day = 1,
	eventManager = function() ---- Кричи хавена (апгрейды) скриптом заменяются на Красный апгрейд
		if OBJECTIVES.date > OBJECTIVES.eventManager_day then
			local heroes = GetPlayerHeroes( PLAYER_3 );
			for j, hero in heroes do
				for i = 1, 7 do
					num = GetHeroCreatures( hero, 2 * i );
					if num > 0 then
						AddHeroCreatures( hero, 105 + i, num );
						RemoveHeroCreatures( hero, 2 * i, num );
					end
				end
			end
			if GetObjectOwner( "rtown" ) == PLAYER_3 then
				for i = 1, 7 do
					num = GetObjectCreatures( "rtown", 2 * i );
					if num > 0 then
						AddObjectCreatures( "rtown", 105 + i, num );
						RemoveObjectCreatures( "rtown", 2 * i, num );
					end
				end
				if GetDate( DAY_OF_WEEK ) == 1 then
					AddObjectCreatures( "rtown", CREATURE_ZEALOT, 24 * redhaven_coeff );
					AddObjectCreatures( "rtown", CREATURE_CHAMPION, 16 * redhaven_coeff );
					AddObjectCreatures( "rtown", CREATURE_SERAPH, 8 * redhaven_coeff );
				end
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.date;
		end
	end
}

A1C3M5_INFERNO_TOWN_REINFORCEMENTS = {
	["inferno1"] = { 	  CREATURE_IMP,	CREATURE_FIRE_ELEMENTAL,		    CREATURE_CERBERI, CREATURE_INFERNAL_SUCCUBUS, CREATURE_FRIGHTFUL_NIGHTMARE,	    CREATURE_BALOR,	 CREATURE_ARCHDEVIL },
	["inferno2"] = { CREATURE_FAMILIAR,	CREATURE_FIRE_ELEMENTAL, 		 CREATURE_HELL_HOUND,		   CREATURE_SUCCUBUS,		    CREATURE_NIGHTMARE, CREATURE_PIT_FIEND,	   	 CREATURE_DEVIL },
	["inferno3"] = {   CREATURE_QUASIT, CREATURE_FIRE_ELEMENTAL, CREATURE_FIREBREATHER_HOUND,  CREATURE_SUCCUBUS_SEDUCER, 			 CREATURE_HELLMARE, CREATURE_PIT_SPAWN, CREATURE_ARCH_DEMON },
	["size"]	 = {               48,                       15,                          24,                         15,                           10,                  5,                   3 },
}

function A1C3M5_reinforce_inferno_town(town)
	for i, unit in A1C3M5_INFERNO_TOWN_REINFORCEMENTS[town] do
		AddObjectCreatures(town, unit, A1C3M5_INFERNO_TOWN_REINFORCEMENTS.size[i] * infernotown_coef );
	end
end

function siege_size()
	local cnt = 0;
	for i = 1, 12 do
		if IsObjectExists( 'siege' .. i ) then
			cnt = cnt + 1;
		end
	end
	return cnt;
end

function owned_demon_towns()
	local town_cnt = 0;
	for i = 1, 3 do
		if GetObjectOwner( 'inferno' ..i ) == PLAYER_1 then
			town_cnt = town_cnt + 1;
		end
	end
	return town_cnt;
end

function TouchTreasury(heroname)
	if GetObjectOwner(heroname) == PLAYER_1 then
		MessageBox( "/Maps/Scenario/A1C3M5/treasury.txt" );
		MarkObjectAsVisited( "treasury", heroname );
	end
end

function TouchPrison(heroname)
	if GetObjectOwner(heroname) == PLAYER_1 then
		MessageBox( "/Maps/Scenario/A1C3M5/prison.txt" );
	end
end

function FireWorks()
	places = { { 12.5, 14.5 }, { 17, 12 }, { 13.5, 12.5 }, { 16, 17 }, { 13.5, 16 }, { 17, 15.5 } };
	effectname = "/Effects/_(Effect)/Buildings/Campfire.xdb#xpointer(/Effect)"
	for i = 1, 6 do
		PlayVisualEffect( effectname, "", "townfire", places[i][1], places[i][2], 0, random( 360 ), 0 );
	end
end

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( H55c_AI_main );

function a1c3m5_dbg(s)
	if s == 1 then
		SetObjectPosition("Shadwyn", 38, 24, 0 );
	elseif s == 2 then
		for i = 1, 12 do
			if IsObjectExists("siege"..i) then
				RemoveObject("siege"..i);
			end
		end
	end
end
