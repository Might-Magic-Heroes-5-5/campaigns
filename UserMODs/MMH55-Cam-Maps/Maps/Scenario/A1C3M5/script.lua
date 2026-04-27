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

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C3M5");
	LoadHeroAllSetArtifacts( "Shadwyn" , "A1C3M4" );
	LoadHeroAllSetArtifacts( "Duncan" , "A1C2M5" );
	H55_CamFixTooManySkills(PLAYER_1,"Shadwyn");
	H55_CamFixTooManySkills(PLAYER_2,"Duncan");
end

startThread(H55_InitSetArtifacts);

--========================== RED HAVEN HEROES RESPAWN SCRIPT ===========================================
--###################################### BEGIN #########################################################
--CONSTANTS
--Must be filled for each map

RH_RespawnPoints_XYZ_Town = { {121, 22, GROUND, "rtown"} };
-- {X, Y, FLOOR, RESPAWN TOWN Script name (if needed, if not must be a nil)}
	

RH_heroes = { "RedHeavenHero01" }; -- Pool of Red Haven heroes
	
AI_PLAYER = PLAYER_3; -- AI player side
RH_heroes_must_alive_count = 1; -- Minimum of AI Red Haven heroes who might be at same time on the map

--=======================================================================

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
IsAlaricTouchTeleport = 0;
siege_hero_defeated = 0;
ALARIC = 'RedHeavenHero03';
KINGTOLGHAR = 'KingTolghar';
DUNCAN = 'Duncan';
SIEGEHERO = 'RedHeavenHero02';
FREYDA = 'Freyda';
WULFSTAN = 'Wulfstan';
SHADWYN = 'Shadwyn';
ISABELL = 'Isabell_A1'; 

-- установка настроек по уровню сложности
DIFFICULTY = {
	[0] = function()
		redhaven_coeff = 1.0;
		SetKingTolgharArmy(1);
	end,
	[1] = function()
		redhaven_coeff = 1.25;
		SetKingTolgharArmy(2);
	end,
	[2] = function()
		redhaven_coeff = 1.5;
		SetKingTolgharArmy(3);
	end,
	[3] = function()
		redhaven_coeff = 1.5;
		SetKingTolgharArmy(4);
	end,
}

function SetKingTolgharArmy(koef)
	AddHeroCreatures(KINGTOLGHAR,  CREATURE_STOUT_DEFENDER, koef * 350 );
	AddHeroCreatures(KINGTOLGHAR, 	  CREATURE_AXE_THROWER, koef * 230 );
	AddHeroCreatures(KINGTOLGHAR, CREATURE_BLACKBEAR_RIDER, koef * 130 );
	AddHeroCreatures(KINGTOLGHAR,		CREATURE_BERSERKER, koef * 85 );
	AddHeroCreatures(KINGTOLGHAR,	   CREATURE_FLAME_MAGE, koef * 50 );
	AddHeroCreatures(KINGTOLGHAR,		  CREATURE_WARLORD, koef * 30 );
	AddHeroCreatures(KINGTOLGHAR,	 CREATURE_MAGMA_DRAGON, koef * 20 );
	sleep(10);
	ChangeHeroStat( KINGTOLGHAR,      STAT_ATTACK, koef * 3 );
	ChangeHeroStat( KINGTOLGHAR,     STAT_DEFENCE, koef * 3 );
	ChangeHeroStat( KINGTOLGHAR, STAT_SPELL_POWER, koef * 3 );
	ChangeHeroStat( KINGTOLGHAR,   STAT_KNOWLEDGE, koef * 3 );
	GiveExp(       KINGTOLGHAR, 100000 + 40000 * math.pow(2, koef));
	GiveExp(          'Marder', 100000 + 30000 * math.pow(2, koef));
	GiveExp( 'RedHeavenHero01', 100000 + 30000 * math.pow(2, koef));
	GiveExp(            ALARIC, 100000 + 40000 * math.pow(2, koef));
	GiveExp(         SIEGEHERO, 100000 + 40000 * math.pow(2, koef));
end

-- управление эффектами и анимациями катапульты
function Catapult()
	while IsHeroAlive( SIEGEHERO ) do
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

-- анимации существ для осады
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
	if ( heroname == SIEGEHERO ) and ( siege_hero_defeated == 0 ) then
		siege_hero_defeated = 1;
		RazeBuilding( 'kotopult' );
		sleep( 10 );
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

-- сребатывает после захвата второго гномского гарнизона
function AlaricEscape( oldowner, newowner, heroname )
	if newowner == PLAYER_1 then
		Trigger( OBJECT_TOUCH_TRIGGER, 'portal', 'RemoveOrrin' );
		DisableCameraFollowHeroes( 0, 0, 1 ); -- не двигать камеру за Андреем
		OpenCircleFog( 82, 101, 0, 10, PLAYER_1 );
		sleep(1);
		MoveCamera( 82, 101, GROUND, 40, 1.3, 0, 1, 1 ,1); -- переместить камеру
		sleep(20);
		while IsAlaricTouchTeleport == 0 do
			EnableHeroAI( ALARIC, not nil );			
			MoveHeroRealTime( ALARIC, 75, 97, 0 );
			sleep(2);
			ChangeHeroStat( ALARIC, STAT_MOVE_POINTS, 2500 );
		end
		print("AlaricEscape: Alaric is in teleport");
	end
end

-- удаление Аларика после телепорта
function RemoveOrrin( heroname )
	if heroname == ALARIC then
		IsAlaricTouchTeleport = 1;
		sleep( 7 );
		RemoveObject( ALARIC );
		sleep( 1 );
		SetRegionBlocked( 'block_end', 1, PLAYER_1 );
		DisableCameraFollowHeroes( 0, 0, 0 );
		sleep( 1 );
		CINEMATICS.alaricEscape();
	end
end

function RedHavenUpgrade() ---- Кричи хавена (апгрейды) скриптом заменяются на Красный апгрейд
	object = "rtown";
	heroes = GetPlayerHeroes( PLAYER_3 );
	for j, hero in heroes do
		for i = 1, 7 do
			num = GetHeroCreatures( hero, 2 * i );
			if num > 0 then
				AddHeroCreatures( hero, 105 + i, num );
				RemoveHeroCreatures( hero, 2 * i, num );
			end
		end
	end
	if GetObjectOwner( object ) == PLAYER_3 then
		for i = 1, 7 do
			num = GetObjectCreatures( object, 2 * i );
			if num > 0 then
				AddObjectCreatures( object, 105 + i, num );
				RemoveObjectCreatures( object, 2 * i, num );
			end
		end
		if GetDate( DAY_OF_WEEK ) == 1 then
			AddObjectCreatures( object, CREATURE_ZEALOT, 6 * redhaven_coeff );
			AddObjectCreatures( object, CREATURE_CHAMPION, 4 * redhaven_coeff );
			AddObjectCreatures( object, CREATURE_SERAPH, 2 * redhaven_coeff );
		end
	end
end

-- PLAYER_1 = HUMAN
-- PLAYER_2 = ALLY (SD CAPITAL)
-- PLAYER_3 = RED HAVEN
-- PLAYER_4 = INFERNO
-- PLAYER_5 = DWARF

function H55_TriggerDaily()
	RedHavenUpgrade();
end

OBJECTIVES = {
	state = {
		reachHorncrest	= { "prim1", 1 }, 	-- Reach Horncrest town
		liftSiege		= { "prim2", 0 }, 	-- Lift the siege over Horncrest
		captureTorHrall	= { "prim3", 0 }, 	-- Capture TorHrall town
		isAlive			= { "prim4", 1 }, 	-- Capture TorHrall town
		demonRaids		= {  "sec1", 0 }, 	-- Stop the demon raids
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		SetObjectEnabled('treasury', nil );
		SetObjectEnabled(  'prison', nil );
		Trigger( OBJECT_TOUCH_TRIGGER, "treasury", "TouchTreasury" ); -- сокровищница
		Trigger( OBJECT_TOUCH_TRIGGER,   "prison",   "TouchPrison" ); -- тюрьма
		H55_NewDayTrigger = 1;
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_3, "RedHavenHeroLost" ); -- потеря героя red haven
		Trigger( OBJECT_CAPTURE_TRIGGER, "garrison1", "AlaricEscape" ); -- потеря героя гномов-врагов
		startThread( Catapult ); -- катапульта и эффекты осады
		for i = 1, 12 do
			startThread( Siege, i ); -- анимации осаждающих кричей
		end
		CINEMATICS.intro();
		startThread(DIFFICULTY[GetDifficulty()]);
		SetRegionBlocked("gate", 1, PLAYER_3); 
		SetRegionBlocked( 'deploy1', 1, PLAYER_1 );
		SetRegionBlocked( 'deploy2', 1, PLAYER_1 );
		EnableHeroAI( SIEGEHERO, nil ); -- перец у котопульты
		EnableHeroAI( DUNCAN, nil ); -- сидит в замке
		EnableHeroAI( KINGTOLGHAR, nil ); -- сидит в Tor Hrall
		EnableHeroAI( ALARIC, nil ); -- Аларик, сидит около Tor Hrall
		EnableAIHeroHiring( PLAYER_2, 'SD', nil );
		FireWorks();
		for i = PLAYER_3, PLAYER_5 do -- уменьшить приоритет нейтрального города и заблокировать гномскую сокровищницу для всех врагов
			SetAIPlayerAttractor( 'dungeon_town', i, -1 );
			SetRegionBlocked( 'treasury', 1, i );
		end
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
			
			if GetObjectiveState('prim1') == OBJECTIVE_FAILED or GetObjectiveState("prim3") == OBJECTIVE_FAILED or GetObjectiveState("prim4") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("prim3") == OBJECTIVE_COMPLETED then
				sleep( 20 );
				Save("autosave");
				CINEMATICS.outro();
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
	
	liftSiege_break = function()
		while siege_size() > 0 do
			if GetCurrentPlayer() ~= PLAYER_1 and siege_hero_defeated == 1 and siege_size() <= 6 then
				EnableHeroAI( DUNCAN, not nil );
				for i = 1, 12 do
					if IsObjectExists( 'siege' .. i ) then
						MoveHero( DUNCAN, GetObjectPosition('siege' .. i));
						break;
					end
				end
			end
			sleep(10);
		end
		EnableHeroAI( DUNCAN, nil );
	end,

	liftSiege = function()
		if OBJECTIVES.state.liftSiege[2] == 1 then
			SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
			startThread( OBJECTIVES.liftSiege_break );
			OBJECTIVES.state.liftSiege[2] = 2;
		elseif OBJECTIVES.state.liftSiege[2] == 2 and siege_size() == 0 and siege_hero_defeated == 1 and GetCurrentPlayer() == PLAYER_1 then
			H55_NewDayTrigger = 0;
			CINEMATICS.liftSiege();
			SetObjectOwner( DUNCAN, PLAYER_1 );
			SetObjectOwner( 'SD', 0 );
			SetObjectOwner( 'SD', 1 );
			DeployReserveHero( FREYDA, 13, 8, 0 );
			DeployReserveHero( WULFSTAN, 17, 8, 0 );
			sleep(10);
			LoadHeroAllSetArtifacts(   "Freyda", "A1C1M5" );
			LoadHeroAllSetArtifacts( "Wulfstan", "A1C2M5" );
			sleep(10);
			H55_CamFixTooManySkills(PLAYER_1,   "Freyda");
			H55_CamFixTooManySkills(PLAYER_1, "Wulfstan");
			SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED );
			SetRegionBlocked( 'deploy1', nil, PLAYER_1 );
			SetRegionBlocked( 'deploy2', nil, PLAYER_1 );
			SetRegionBlocked("gate", nil, PLAYER_3);
			sleep(5);
			SetAIPlayerAttractor( 'SD', PLAYER_3, 1 );
			SetAIPlayerAttractor( 'SD', PLAYER_4, 1 );
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
			if IsHeroAlive(ISABELL) == nil or IsHeroAlive(SHADWYN) == nil or IsHeroAlive(DUNCAN) == nil or 
			( OBJECTIVES.state.liftSiege[2] == 10 and ( IsHeroAlive(FREYDA) == nil or IsHeroAlive(WULFSTAN) == nil )) then
				SetObjectiveState( 'prim4', OBJECTIVE_FAILED );
				OBJECTIVES.state.isAlive[2] = 11;
			end
		end
	end,
	
	demonRaids = function()
		if OBJECTIVES.state.demonRaids[2] == 1 then
			SetObjectiveState('sec1', OBJECTIVE_ACTIVE);
			OBJECTIVES.state.demonRaids[2] = 2;
		elseif OBJECTIVES.state.demonRaids[2] == 2 and owned_demon_towns() == 3 then
			SetObjectiveState('sec1', OBJECTIVE_COMPLETED);
			OBJECTIVES.state.demonRaids[2] = 10;
		end
	end,
}

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
startThread(OBJECTIVES.start)

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
