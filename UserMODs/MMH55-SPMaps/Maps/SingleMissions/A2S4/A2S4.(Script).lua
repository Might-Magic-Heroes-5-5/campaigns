doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
end

H55_PlayerStatus = {0,1,1,2,2,2,2,2};

H55c_AI_CONTROLLED = {
	player1 = {				-- red Inferno human player, Agrael
		state = 0,			-- 0 human, 1 unmanaged AI, 2 managed AI
		heroes = {},
		enemies = {},
	},
	player2 = {				-- blue Inferno enemy player, demon lords
		state = 2,			-- Leads onslaught against the player.
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 0.8, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
			{ priority = 1.0, heroes = 0.8, towns = 1.0, is_enemy = 1 },  -- PLAYER3
		}
	},
	player3 = {				-- green Inferno player, Biara ally.
		state = 1,
		heroes = {},
		enemies = {},
	},
}

A2S4_WAVES = {
	["weekly1"] = { hero = 'Efion',  pos = {  13,  19, 1 } },
	["weekly2"] = { hero = 'Veyer',  pos = { 120, 121, 1 } },
	["weekly3"] = { hero = 'Efion',  pos = {  18, 118, 1 } },
	["weekly4"] = { hero = 'Veyer',  pos = { 125,  25, 1 } },
	["lord1"] 	= { hero = 'Nymus',  pos = {  13,  19, 1 } },
	["lord2"] 	= { hero = 'Marder', pos = {  18, 118, 1 } },
	["lord3"] 	= { hero = 'Grok',   pos = { 120, 121, 1 } },
	["lord4"] 	= { hero = 'Deleb',  pos = { 125,  25, 1 } },
}

function newsAboutThePrisoner( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "vo6_1", nil);
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "vo6_2", nil);
		OBJECTIVES.state.freeVeyer[2] = 1;
	end
end

function f_army_calculations()
	local ARMY_RATE = 1;
	if GetDate( DAY ) >= 28 then
		ARMY_RATE=3;
	elseif GetDate( DAY ) >= 21 then
		ARMY_RATE=2.5;
	elseif GetDate( DAY ) >= 14 then
		ARMY_RATE=2;
	elseif GetDate( DAY ) >= 7 then
		ARMY_RATE=1.5;
	end
	
	local FINAL_RATE = ARMY_RATE * ARMY_DIFF_RATE;
	if WITCH.curseIsActive == 1 then
		FINAL_RATE = FINAL_RATE * 0.5;
	end
	T1_NUM = 16 * FINAL_RATE + random(ARMY_RATE*10);
	T2_NUM = 15 * FINAL_RATE + random(ARMY_RATE*5);
	T3_NUM = 8 * FINAL_RATE + random(ARMY_RATE*2);
	T4_NUM = 5 * FINAL_RATE + random(ARMY_RATE+4);
	T5_NUM = 3 * FINAL_RATE + random(ARMY_RATE+3);
	T6_NUM = 2 * FINAL_RATE + random(ARMY_RATE+2);
	T7_NUM = 1 * FINAL_RATE + random(ARMY_RATE+1);
	
	local heroes = GetPlayerHeroes(PLAYER_2);
	for i, hero in heroes do
		if math.random(1, 100) < (10 + math.pow(2.65, DiffRate)) then -- chance ~= 12 / 17 / 28 / 59 %
			H55c_AIAddHero(hero);
		else
			H55c_AIRemoveHero(hero);
		end
	end
end

A2S4_WAVE_ARMY = {
	{ 28, CREATURE_IMP, 1, CREATURE_HORNED_DEMON, 2, 	CREATURE_CERBERI, 3, CREATURE_INFERNAL_SUCCUBUS, 4, CREATURE_FRIGHTFUL_NIGHTMARE, 5, 	 CREATURE_BALOR, 6, CREATURE_ARCHDEVIL, 7 },
	{ 21, CREATURE_IMP, 1, CREATURE_HORNED_DEMON, 2, 	CREATURE_CERBERI, 3, CREATURE_INFERNAL_SUCCUBUS, 4, CREATURE_FRIGHTFUL_NIGHTMARE, 5,  CREATURE_ASSASSIN, 1, CREATURE_MATRIARCH, 6 },
	{ 14, CREATURE_IMP, 1, CREATURE_HORNED_DEMON, 2, 	CREATURE_CERBERI, 3, 		  CREATURE_SUCCUBUS, 4, 		  CREATURE_NIGHTMARE, 5, CREATURE_PIT_FIEND, 6,  CREATURE_ASSASSIN, 1 },
	{  7, CREATURE_IMP, 1, CREATURE_HORNED_DEMON, 2, CREATURE_HELL_HOUND, 3, 		  CREATURE_SUCCUBUS, 4, 		  CREATURE_NIGHTMARE, 5 },
	{  1, CREATURE_FAMILIAR, 1,   CREATURE_DEMON, 2, CREATURE_HELL_HOUND, 3, 		  CREATURE_SUCCUBUS, 4 },
}

function f_army_set(hero)
	local amounts = { T1_NUM, T2_NUM, T3_NUM, T4_NUM, T5_NUM, T6_NUM, T7_NUM };
	for _, army in A2S4_WAVE_ARMY do
		if GetDate(DAY) >= army[1] then
			AddHeroCreatures(hero, army[2], amounts[army[3]]);
			sleep( 10 );
			RemoveHeroCreatures(hero, CREATURE_FAMILIAR, 1); --*-- Removes default 1 Imp to empty 1-st army slot --*--
			for i = 4, table.length(army), 2 do
				AddHeroCreatures(hero, army[i], amounts[army[i + 1]]);
			end
			break
		end
	end
end

function DeployDemonGeneral(wave)
	if IsObjectExists(wave.hero) ~= nil then
		return 0;
	end
	DeployReserveHero(wave.hero, wave.pos[1], wave.pos[2], wave.pos[3]);
	sleep(10);
	SetHeroRoleMode( wave.hero, HERO_ROLE_MODE_HERMIT );
	f_army_set(wave.hero);
	WITCH.applyCurseToHero(wave.hero);
	local EXP_LEVEL = GetDate( WEEK )*ARMY_DIFF_RATE*2000;
	ChangeHeroStat(wave.hero, STAT_EXPERIENCE, EXP_LEVEL);
	sleep(10);
	print('Hero ', wave.hero, ' is now level: ', GetHeroLevel(wave.hero),' and has: ', GetHeroStat(wave.hero, STAT_EXPERIENCE));
	return 1
end

-- Get to the Witch's house. Pay the price. Next wave of AI attackers will be "cursed" - will get lowered amount of creatures and low morale and luck. Can be repeated each time after you defeat "cursed armies".
WITCH = {
	weekCheck = 0,
	weekCount = 0,
	cost = 5000,
	curseIsActive = 0,
	
	visit = function( hero )
		if GetObjectOwner( hero ) == PLAYER_1 then
			if WITCH.weekCount == 0 then
				CINEMATICS.meetWitch();
			end
			WITCH.weekCount = GetDate( WEEK );
			print( "weekCheck", WITCH.weekCheck );
			print( "weekCount", WITCH.weekCount );
			if GetPlayerResource( PLAYER_1, GOLD ) > WITCH.cost and WITCH.weekCount > WITCH.weekCheck then
				if WITCH.curseIsActive == 0 then 
					QuestionBox( {"/Maps/SingleMissions/A2S4/questionbox_001.txt"; PRICE = WITCH.cost}, "WITCH.accept", "WITCH.decline");
				else
					MessageBox("/Maps/SingleMissions/A2S4/messagebox_005.txt");
				end
			elseif GetPlayerResource( PLAYER_1, GOLD ) < WITCH.cost and WITCH.weekCount > WITCH.weekCheck then
				MessageBox( {"/Maps/SingleMissions/A2S4/messagebox_10.txt"; cusrePriceAmount = WITCH.cost} );
			elseif WITCH.weekCount <= WITCH.weekCheck then
				MessageBox( "/Maps/SingleMissions/A2S4/messagebox_11.txt" );
			end
		end
	end,
	
	accept = function()
		WITCH.weekCheck = WITCH.weekCount;
		MessageBox( {"/Maps/SingleMissions/A2S4/messagebox_004.txt"; PRICE = WITCH.cost} );
		SetPlayerResource(PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) - WITCH.cost);
		WITCH.cost = WITCH.cost + 1000;
		if IsObjectExists('Witch') ~= nil then
			WITCH.curseIsActive = 1;
			for i, hero in GetPlayerHeroes( PLAYER_2 ) do
				WITCH.applyCurseToHero(hero);
				print("Morale and Luck were decreased for hero "..hero);
			end
		end
	end,

	decline = function()
		MessageBox("/Maps/SingleMissions/A2S4/messagebox_006.txt");
	end,
	
	applyCurseToHero = function( hero )
		local current_morale = - (0 + GetHeroStat( hero, STAT_MORALE ));
		local current_luck = - (0 + GetHeroStat( hero, STAT_LUCK ));
		if WITCH.curseIsActive == 1 then
			current_morale = current_morale - 5;
			current_luck = current_luck - 5;
		end
		ChangeHeroStat( hero, STAT_MORALE, current_morale );
		ChangeHeroStat( hero, STAT_LUCK, current_luck );
	end,
}

-- The ally hero will appear on the map on 21-th day of the game. IF the hero reaches player's town, he will go under player's control.
function f_ally_change_owner()
	while 1 do
		sleep( 20 );
		if IsHeroAlive("Biara") ~= nil then
			if IsObjectInRegion('Biara', 'REGION_CHANGE_OWNER') == 1 then
				repeat sleep(20) until GetCurrentPlayer() ~= PLAYER_1
				hx,hy,hlevel = GetObjectPosition( 'Agrael' );
				SetObjectOwner( 'Biara', PLAYER_1 );
				SetObjectPosition( 'Agrael', 75, 70, GROUND );
				sleep(5);
				SetObjectRotation( 'Agrael', 45 );
				H55c_Message.show("/Maps/SingleMissions/A2S4/messagebox_008.txt");
				CINEMATICS.allyHasArrived();
				SetObjectPosition( 'Agrael', hx, hy, hlevel );
				return
			elseif CanMoveHero( 'Biara', 75, 69, 0 ) then	
				MoveHero( 'Biara', 75, 69, 0 );
			end
		else
			startThread( Play2DSound, "/Maps/SingleMissions/A2S4/SM4_VO5_Agrael_01sound.xdb#xpointer(/Sound)" );
			return
		end
	end
end

function DeployDemonLord(wave)
	DeployReserveHero(wave.hero, wave.pos[1], wave.pos[2], wave.pos[3]);
	sleep(10);
	SetHeroRoleMode( wave.hero, HERO_ROLE_MODE_HERMIT );
	f_army_set(wave.hero);
end

function freeVeyerFromPrison( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( OBJECT_TOUCH_TRIGGER, 'PRISON_VEYER', nil );
		OBJECTIVES.freeVeyer_hero = hero;
		OBJECTIVES.state.freeVeyer[2] = 3;
	end
end

function AreDemonLordsDefeated()
	for i=1,4 do
		if IsHeroAlive(A2S4_WAVES['lord'..i].hero) ~= nil then
			return nil
		end
	end
	return not nil
end

function meetDevilGuard( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'guardRegion', nil );
		OBJECTIVES.artifactStash_visitor = hero;
		OBJECTIVES.state.artifactStash[2] = 3;
	end
end

function f_capture_gold_mine(oldowner, newowner, hero, object)
	if newowner == PLAYER_1 then
		SetAIPlayerAttractor(object, PLAYER_2, 2);
	else
		SetAIPlayerAttractor(object, PLAYER_2, 0);
	end
end

function OwnedGoldMines(player)
	local count = 0;
	for i=1,4 do
		if GetObjectOwner('GOLD_MINE_0'..i ) == player then
			count = count + 1;
		end
	end
	return count;
end

DIFFICULTY = {
	[0] = function()
		DiffRate = 1;
		ARMY_DIFF_RATE = 0.5;
		print ("normal");
	end,

	[1] = function()
		DiffRate = 2;
		ARMY_DIFF_RATE = 1.0;
		print ("hard");
	end,

	[2] = function()
		DiffRate = 3;
		ARMY_DIFF_RATE = 1.5;
		print ("heroic");
	end,

	[3] = function()
		DiffRate = 4;
		ARMY_DIFF_RATE = 2.0;
		print ("impossible");
	end,
}

CINEMATICS = {
	wait = 0,
	are_playing = nil,
	playAndWait = function( id )
		CINEMATICS.are_playing = not nil;
		StartAdvMapDialog( id, CINEMATICS.end_play() );
		repeat sleep(30); until CINEMATICS.are_playing == nil;
	end,
		
	end_play = function()
		CINEMATICS.are_playing = nil;
	end,
	
	intro = function()
		StartDialogScene("/DialogScenes/A2Single/SM4/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	allyHasArrived = function()
		CINEMATICS.playAndWait( 2 );
	end,
	
	findArtifactStash = function()
		CINEMATICS.playAndWait( 3 );
	end,
	
	meetWitch = function()
		CINEMATICS.playAndWait( 0 );
	end,
	
	freeVeyer = function()
		CINEMATICS.playAndWait( 1 );
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/A2Single/SM4/S3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

OBJECTIVES = {
	date = 0,
	state = {
		defeatInfernoLords = {					 "MAIN_OBJECTIVE", 1 },	-- Defeat all Inferno Lords
		isAlive            = { 		   "OBJECTIVE_AGRAEL_SURVIVE", 1 },	-- Agrael must survive
		captureGoldMines   = { "SEC_OBJECTIVE_CAPTURE_GOLD_MINES", 1 },	-- Control all Gold Mines
		freeVeyer          = { 		   "SEC_OBJECTIVE_FREE_VEYER", 0 },	-- Discover and rescue Veyer
		artifactStash      = { 	   "SEC_OBJECTIVE_ARTIFACT_STASH", 1 },	-- Find the hidden artifact cache
		eventManager       = { 								  "_", 1 },	-- Handles all scheduled and recurring map events
	},
		
	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		CINEMATICS.intro();
		SetRegionBlocked( "VoiceOver6Region", not nil, PLAYER_2 ); -- prevent player 2 from visiting the prison
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "vo6_1", "newsAboutThePrisoner");
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "vo6_2", "newsAboutThePrisoner");
		SetObjectEnabled( "DEVIL_GUARD", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'guardRegion', "meetDevilGuard");
		SetRegionBlocked( "spawnRegion", not nil, PLAYER_1 );
		SetRegionBlocked( "spawnRegion1", not nil, PLAYER_1 );
		SetRegionBlocked( "spawnRegion2", not nil, PLAYER_1 );
		SetRegionBlocked( "spawnRegion3", not nil, PLAYER_1 );
		SetObjectEnabled('Witch', nil); -- Witch creature is disabled from the start, so player is unable to attack and kill her
		DIFFICULTY[GetDifficulty()]();
		for i = 1,4 do
			ChangeHeroStat(A2S4_WAVES['lord'..i].hero, STAT_EXPERIENCE, 35000);
		end
		if GetObjectCreatures("bone_dragon", CREATURE_BONE_DRAGON) >= 1 then
			AddObjectCreatures("bone_dragon", CREATURE_BONE_DRAGON, 2 * DiffRate);
		end
		Trigger(OBJECT_TOUCH_TRIGGER, 'Witch', "WITCH.visit");
		for i=1,4 do
			Trigger(OBJECT_CAPTURE_TRIGGER, "GOLD_MINE_0"..i, "f_capture_gold_mine");
		end
		Trigger(OBJECT_TOUCH_TRIGGER, 'PRISON_VEYER', "freeVeyerFromPrison");
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

			if GetObjectiveState("OBJECTIVE_AGRAEL_SURVIVE") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("MAIN_OBJECTIVE") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep( 100 );
				Win();
				return
			end
		end
	end,
	
	defeatInfernoLords = function()
		-- the start of this task is handled by map.xdb
		if OBJECTIVES.state.defeatInfernoLords[2] == 1 and OBJECTIVES.date == 29 then
			WITCH.curseIsActive = 0;
			for i=1,4 do
				DeployDemonLord(A2S4_WAVES['lord'..i]);
			end
			MessageBox("/Maps/SingleMissions/A2S4/messagebox_001.txt");
			startThread( Play2DSound, "/Maps/SingleMissions/A2S4/SM4_VO8_Agrael_01sound.xdb#xpointer(/Sound)" );
			OBJECTIVES.state.defeatInfernoLords[2] = 2;
		elseif OBJECTIVES.state.defeatInfernoLords[2] == 2 and AreDemonLordsDefeated() ~= nil then
			MessageBox("/Maps/SingleMissions/A2S4/messagebox_002.txt");
			SetObjectiveState('MAIN_OBJECTIVE', OBJECTIVE_COMPLETED, PLAYER_1);
			OBJECTIVES.state.defeatInfernoLords[2] = 10;
		end
	end,
	
	isAlive = function()
	-- the start of this task is handled by map.xdb
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive('Agrael') == nil then
			SetObjectiveState('OBJECTIVE_AGRAEL_SURVIVE', OBJECTIVE_FAILED);	
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	captureGoldMines = function()
		if OBJECTIVES.state.captureGoldMines[2] == 1 then
			SetObjectiveState( "SEC_OBJECTIVE_CAPTURE_GOLD_MINES", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureGoldMines[2] = 2;
		elseif OBJECTIVES.state.captureGoldMines[2] == 2 and OwnedGoldMines(PLAYER_1) == 4 then
			SetObjectiveState( "SEC_OBJECTIVE_CAPTURE_GOLD_MINES", OBJECTIVE_COMPLETED, PLAYER_1 );
			startThread( Play2DSound, "/Maps/SingleMissions/A2S4/SM4_VO3_Agrael_01sound.xdb#xpointer(/Sound)" );
			OBJECTIVES.state.captureGoldMines[2] = 3;
		elseif OBJECTIVES.state.captureGoldMines[2] == 3 and OwnedGoldMines(PLAYER_1) < 4 then
			SetObjectiveState( "SEC_OBJECTIVE_CAPTURE_GOLD_MINES", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureGoldMines[2] = 2;
		end
	end,
	
	freeVeyer_hero = "Agrael",
	freeVeyer = function()
		if OBJECTIVES.state.freeVeyer[2] == 1 then
			OpenCircleFog( 131, 72, GROUND, 8, PLAYER_1 );
			Play2DSound( "/Maps/SingleMissions/A2S4/SM4_VO6_Agrael_01sound.xdb#xpointer(/Sound)" );
			SetObjectiveState( "SEC_OBJECTIVE_FREE_VEYER", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.freeVeyer[2] = 2;
		elseif OBJECTIVES.state.freeVeyer[2] == 3 then
			local pmx, pmy, pmlevel = GetObjectPosition( 'Agrael' );
			if OBJECTIVES.freeVeyer_hero ~= 'Agrael' then
				SetObjectPosition( 'Agrael', 128, 70, GROUND );
				sleep( 1 );
				SetObjectRotation( 'Agrael', 90 );
			end
			CINEMATICS.freeVeyer();
			if OBJECTIVES.freeVeyer_hero ~= 'Agrael' then
				SetObjectPosition( 'Agrael', pmx, pmy, pmlevel );
			end
			SetObjectiveState('SEC_OBJECTIVE_FREE_VEYER', OBJECTIVE_COMPLETED, PLAYER_1);
			ChangeHeroStat('Agrael', STAT_EXPERIENCE, 10000);
			ChangeHeroStat('Agrael', STAT_DEFENCE, 1);
			ChangeHeroStat('Agrael', STAT_MORALE, 1);	
			OBJECTIVES.state.freeVeyer[2] = 10;
		end
	end,
	
	artifactStash_visitor = "Agrael",
	artifactStash = function()
		if OBJECTIVES.state.artifactStash[2] == 1 then
			SetObjectiveState( "SEC_OBJECTIVE_ARTIFACT_STASH", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.artifactStash[2] = 2;
		elseif OBJECTIVES.state.artifactStash[2] == 3 then
			BlockGame();
			local mx,my,mlevel = GetObjectPosition( 'Agrael' );
			if OBJECTIVES.artifactStash_visitor ~= 'Agrael' then
				SetObjectPosition( 'Agrael', 92, 81, UNDERGROUND );
				sleep( 5 );
				SetObjectRotation( 'Agrael', 100 );
			end;
			sleep( 20 );
			CINEMATICS.findArtifactStash();
			RemoveObject( "DEVIL_GUARD" );
			AddHeroCreatures( 'Agrael', CREATURE_ARCHDEVIL, 1 );
			SetObjectiveState('SEC_OBJECTIVE_ARTIFACT_STASH', OBJECTIVE_COMPLETED, PLAYER_1);
			RemoveObject( "dsc" );
			RemoveObject( "dss" );
			RemoveObject( "dsa" );
			GiveArtefact( 'Agrael', ARTIFACT_DRAGON_TALON_CROWN );
			GiveArtefact( 'Agrael', ARTIFACT_DRAGON_SCALE_ARMOR );
			GiveArtefact( 'Agrael', ARTIFACT_DRAGON_SCALE_SHIELD );
			if OBJECTIVES.artifactStash_visitor ~= 'Agrael' then
				SetObjectPosition( 'Agrael', mx, my, mlevel );
			end
			UnblockGame();
			OBJECTIVES.state.artifactStash[2] = 10;
		end
	end,
	
	eventManager_allyDeployed = 0,
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date >= OBJECTIVES.eventManager_day then
			f_army_calculations();
			local deployed_heroes = 0;
			if GetDate( DAY_OF_WEEK ) == 4 and OBJECTIVES.date <= 22 and (IsHeroAlive(A2S4_WAVES['weekly1'].hero) == nil or IsHeroAlive(A2S4_WAVES['weekly1'].hero) == nil) then
			-- Deploy secondary AI heroes on the map every 4-th day of the week.
				deployed_heroes = deployed_heroes + DeployDemonGeneral(A2S4_WAVES['weekly1']) + DeployDemonGeneral(A2S4_WAVES['weekly2']);
			end
			
			if GetDate( DAY_OF_WEEK ) == 7 and OBJECTIVES.date <= 22 then
				-- Deploy secondary AI heroes on the map every 7-th day of the week.
				deployed_heroes = deployed_heroes + DeployDemonGeneral(A2S4_WAVES['weekly3']) + DeployDemonGeneral(A2S4_WAVES['weekly4']);
			end
			
			if GetDate( DAY_OF_WEEK ) == 7 or deployed_heroes > 0 then
				WITCH.curseIsActive = 0;
			end
			
			if OBJECTIVES.date >= 20 and OBJECTIVES.eventManager_allyDeployed == 0 then -- This function places ally AI hero on the map and orders him to go to player's town.
				startThread( Play2DSound, "/Maps/SingleMissions/A2S4/SM4_VO4_Agrael_01sound.xdb#xpointer(/Sound)" );		
				MessageBox("/Maps/SingleMissions/A2S4/messagebox_007.txt");
				DeployReserveHero('Biara', 90, 1, 0);
				sleep( 20 );
				EnableHeroAI('Biara', not nil);
				startThread( f_ally_change_owner );
				OBJECTIVES.eventManager_allyDeployed = 1;
			end
			if OBJECTIVES.state.captureGoldMines[2] == 3 then	-- Give player gold if he owns the goldmines
				SetPlayerResource(PLAYER_1, GOLD, (GetPlayerResource(PLAYER_1, GOLD) + 5000));
			end
			
			if OBJECTIVES.date == 14 then					-- SUCCUBUS CHAT DIALOGSCENE at day 14
				StartDialogScene("/DialogScenes/A2Single/SM4/S2/DialogScene.xdb#xpointer(/DialogScene)"); 
			end
			OBJECTIVES.eventManager_day = OBJECTIVES.date + 1;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( H55c_AI_main );

function a2s4_dbg(var)
	if var == 1 then 		-- visit Witch
		WITCH.visit("Agrael");
	elseif var == 2 then
		MakeHeroInteractWithObject("Agrael", "Efion");
	elseif var == 3 then
		MakeHeroInteractWithObject("Agrael", "Veyer");
	end
end
