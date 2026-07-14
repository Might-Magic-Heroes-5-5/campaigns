doFile("/scripts/A2_Zehir/A2_Zehir.lua");
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function f_artifacts_sets()
	InitAllSetArtifacts( "A2C3M1" );
end

startThread( f_artifacts_sets );
ElvenHeroes = { 'Almegir', 'Dalom', 'Eruina', 'Ferigl', 'Inagost', 'Menel', 'Ohtarig', 'Urunir' }

DIFFICULTY = {
	[0] = function()
		diff = 2;
		UnblockZoneForAIonDate = {  36,  56, nil, nil };
		SetPlayerStartResources(PLAYER_2, 80, 80, 40, 40, 60, 40, 30000);
		ChangeHeroStat('Eruina', STAT_EXPERIENCE, 1300);
		ChangeHeroStat('Ferigl', STAT_EXPERIENCE, 2000);
		ChangeHeroStat('Inagost', STAT_EXPERIENCE, 2400);	
		AddHeroCreatures('Zehir', CREATURE_MAGI, 10);
		AddHeroCreatures('Zehir', CREATURE_GENIE, 10);
		AddHeroCreatures('Zehir', CREATURE_RAKSHASA, 5);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'ZONE_BLOCK_AI2_8', "f_ZONE_BLOCK_AI2_8_deactivate_easy");
		print("Difficulty level is easy.");
	end,
	
	[1] = function()
		diff = 2;
		UnblockZoneForAIonDate = {  29,  49,  42, nil };
		SetPlayerStartResources(PLAYER_2, 120, 120, 60, 60, 90, 60, 60000);
		ChangeHeroStat('Eruina', STAT_EXPERIENCE, 2600);
		ChangeHeroStat('Ferigl', STAT_EXPERIENCE, 4000);
		ChangeHeroStat('Inagost', STAT_EXPERIENCE, 5400);
		AddHeroCreatures('Zehir', CREATURE_IRON_GOLEM, 21);
		AddHeroCreatures('Zehir', CREATURE_MAGI, 9);
		AddHeroCreatures('Zehir', CREATURE_GENIE, 5);	
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'Deactivator_for_ZONE_BLOCK_AI2_8', "f_ZONE_BLOCK_AI2_8_deactivate_normal");
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'ZONE_BLOCK_AI2_3', "f_ZONE_BLOCK_AI2_8_deactivate_normal");
		Trigger(OBJECT_CAPTURE_TRIGGER, 'Garrison2', "f_ZONE_BLOCK_AI2_8_deactivate_normal");	
		print("Difficulty level is normal.");
	end,
	
	[2] = function()
		diff = 3;
		UnblockZoneForAIonDate = {  22,  49,  35, nil };
		SetPlayerStartResources(PLAYER_2, 160, 160, 80, 80, 120, 80, 100000);
		AddObjectCreatures('Sorfail', CREATURE_MINOTAUR , 18);	
		AddObjectCreatures('Colris', CREATURE_MINOTAUR, 18);
		AddObjectCreatures('Colris', CREATURE_RIDER, 10);	
		AddObjectCreatures('Thilgathal', CREATURE_MINOTAUR, 18);
		AddObjectCreatures('Thilgathal', CREATURE_RIDER, 10);
		AddObjectCreatures('Thilgathal', CREATURE_HYDRA, 6);
		ChangeHeroStat('Eruina', STAT_EXPERIENCE, 12400);
		ChangeHeroStat('Ferigl', STAT_EXPERIENCE, 24320);
		ChangeHeroStat('Inagost', STAT_EXPERIENCE, 17600);
		AddHeroCreatures('Zehir', CREATURE_GREMLIN, 38);
		AddHeroCreatures('Zehir', CREATURE_STONE_GARGOYLE, 19);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'ZONE_BLOCK_AI2_5', "f_ZONE_BLOCK_AI2_8_deactivate_hard");
		print("Difficulty level is hard.");
	end,
		
	[3] = function()
		diff = 4;
		UnblockZoneForAIonDate = {   8,  42,  28,  15 };
		SetPlayerStartResources(PLAYER_2, 300, 300, 140, 140, 200, 140, 500000);
		AddObjectCreatures('Sorfail', CREATURE_MINOTAUR , 36);	
		AddObjectCreatures('Colris', CREATURE_HYDRA, 12);
		AddObjectCreatures('Colris', CREATURE_MATRON, 4);	
		AddObjectCreatures('Thilgathal', CREATURE_HYDRA, 12);
		AddObjectCreatures('Thilgathal', CREATURE_MATRON, 4);
		AddObjectCreatures('Thilgathal', CREATURE_DEEP_DRAGON, 2);
		ChangeHeroStat('Eruina', STAT_EXPERIENCE, 40570);
		ChangeHeroStat('Ferigl', STAT_EXPERIENCE, 28785);
		ChangeHeroStat('Inagost', STAT_EXPERIENCE, 24320);	
		AddHeroCreatures('Zehir', CREATURE_MASTER_GENIE, 2);
		print("Difficulty level is heroic.");
	end,
}

function f_meetNarxes( hero )
	if hero == "Zehir" then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Nraxes", nil );
		CINEMATICS.meetNarxes();
	end
end

function f_meetYlaya( heroName )
	if heroName == 'Zehir' then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'ZONE_MEET_WITH_YLAYA', nil );
		OBJECTIVES.state.findInfo[2] = 1;
	end
end
	
function AreElvesDefeated()
	if GetObjectOwner('Sorfail') ~= PLAYER_1 or GetObjectOwner('Colris') ~= PLAYER_1 or GetObjectOwner('Thilgathal') ~= PLAYER_1 then
		return nil
	end
	
	for i, hero in ElvenHeroes do
		if IsHeroAlive( hero ) ~= nil then
			return nil
		end
	end
	return 1
end

function f_meetCannonFodder( hero )
	if hero == 'Zehir' then
		QuestionBox( "/Maps/Scenario/A2C3M1/messagebox_002.txt", "f_report_yes", "f_report_no" );
	else
		startThread( MessageBox, "/Maps/Scenario/A2C3M1/messagebox_003.txt" );
	end
end

function f_report_yes()
	Trigger( OBJECT_TOUCH_TRIGGER, 'Assasin', nil );
	if OBJECTIVES.state.cannonFodder[2] == 0 then OBJECTIVES.state.cannonFodder[2] = 1; end
end

function f_report_no( hero )
	Trigger( OBJECT_TOUCH_TRIGGER, 'Assasin', nil );
	SetObjectEnabled( 'Assasin', not nil );
	SetDisabledObjectMode( 'Assasin', DISABLED_DEFAULT );
	sleep( 10 );
	MakeHeroInteractWithObject( 'Zehir', 'Assasin' );
end

function combat_results( c )
	print("CombatResultsFunc");
	local we = -1
	if GetSavedCombatArmyPlayer(c,1) == PLAYER_1 then we = 1 end
	if GetSavedCombatArmyPlayer(c,0) == PLAYER_1 then we = 0 end
	if we ~= -1 and GetSavedCombatArmyHero(c,we) == 'Zehir' then
		print("CombatResultsFunc: hero found");
		local stackscount = GetSavedCombatArmyCreaturesCount(c,we);
		for i = 0,stackscount-1,1 do
			local creature,creaturescount,died = GetSavedCombatArmyCreatureInfo(c,we,i);
			if creature == CREATURE_ASSASSIN and died > 0 then
				print("CombatResultsFunc: assassins died = ",died);
				OBJECTIVES.cannonFodder_diedCount = OBJECTIVES.cannonFodder_diedCount + died;
				OBJECTIVES.cannonFodder_liveCount = OBJECTIVES.cannonFodder_liveCount - died;
				OBJECTIVES.state.cannonFodder[2] = 5;
			end
		end
	end
	OBJECTIVES.cannonFodder_combatID = c;
end

function assassin_combat_results( hero, isWinner )
	if isWinner == not nil then
		MessageBox("/Maps/Scenario/A2C3M1/messagebox_011.txt");
	else
		MessageBox("/Maps/Scenario/A2C3M1/messagebox_012.txt");
	end
	--sleep(100);
	local heroes = GetPlayerHeroes( PLAYER_1 );
	for i,hero in heroes do
		pcall( RemoveHeroCreatures, hero, CREATURE_ASSASSIN, 10000 );
		pcall( RemoveHeroCreatures, hero, CREATURE_STALKER, 10000 );
	end
	pcall( RemoveObjectCreatures, 'Mutazz', CREATURE_ASSASSIN, 10000 );
	pcall( RemoveObjectCreatures, 'Mutazz',  CREATURE_STALKER, 10000 );
end

function f_attackGarrison1( hero )
	local assassins = GetHeroCreatures( 'Zehir', CREATURE_ASSASSIN );
	if assassins > 0 then
		if hero ~= 'Zehir' then
			startThread( MessageBox, "/Maps/Scenario/A2C3M1/messagebox_005.txt" );
			return
		end
		OBJECTIVES.state.cannonFodder[2] = 6;
		local TraitorsCount = GetHeroCreatures( 'Zehir', CREATURE_ASSASSIN );
		RemoveHeroCreatures( 'Zehir', CREATURE_ASSASSIN, TraitorsCount );
		AddObjectCreatures( 'Garrison1', CREATURE_ASSASSIN, TraitorsCount );
		BlockGame();
		startThread( Play2DSound, "/Maps/Scenario/A2C3M1/C3M1_VO3_Zehir_01sound.xdb#xpointer(/Sound)" );
		sleep(50);		
		UnblockGame();
		MessageBox("/Maps/Scenario/A2C3M1/messagebox_006.txt");	
	end
	SetObjectEnabled( 'Garrison1', not nil );
	Trigger( OBJECT_TOUCH_TRIGGER, 'Garrison1', nil );
	SetRegionBlocked( 'ZONE_BLOCK_AI2_5', nil, PLAYER_2 );		
	sleep(10);
	MakeHeroInteractWithObject( hero, 'Garrison1' );
end

function f_meetDwarfOttar( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		OBJECTIVES.findArtifact_visitor = hero;
		if OBJECTIVES.state.findArtifact[2] == 0 then OBJECTIVES.state.findArtifact[2] = 1 end
		if OBJECTIVES.state.findArtifact[2] == 2 then OBJECTIVES.state.findArtifact[2] = 3 end
	end
end
	
function f_starter_for_random_message_007_and_008()
	repeat
		sleep(140);
		startThread( f_dwarf_random_message_007_or_008 );
	until OBJECTIVES.state.findArtifact[2] == 10 or OBJECTIVES.state.findArtifact[2] == 11;		
end

function f_dwarf_random_message_007_or_008()
	x = random(2);
	print( 'random message #', x );
	if (x == 0) then ShowFlyingSign("/Maps/Scenario/A2C3M1/messagebox_007.txt", 'Ottar', PLAYER_1, 7.0); end
	if (x == 1) then ShowFlyingSign("/Maps/Scenario/A2C3M1/messagebox_008.txt", 'Ottar', PLAYER_1, 7.0); end
end

function f_ZONE_BLOCK_AI2_3_deactivate() 
	SetRegionBlocked('ZONE_BLOCK_AI2_3', nil, PLAYER_2);
	SetRegionBlocked('Block_upper_temp', nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_3_deactivate");
end

function f_ZONE_BLOCK_AI2_8_deactivate_easy()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'ZONE_BLOCK_AI2_8', nil);
	SetRegionBlocked('ZONE_BLOCK_AI2_8', nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_8_deactivate");
end

function f_ZONE_BLOCK_AI2_8_deactivate_normal()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'Deactivator_for_ZONE_BLOCK_AI2_8', nil);
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'ZONE_BLOCK_AI2_3', nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, 'Garrison2', nil);
	SetRegionBlocked('ZONE_BLOCK_AI2_8', nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_8_deactivate");
end

function f_ZONE_BLOCK_AI2_8_deactivate_hard()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'ZONE_BLOCK_AI2_5', nil);
	SetRegionBlocked('ZONE_BLOCK_AI2_8', nil, PLAYER_2);
	print("f_ZONE_BLOCK_AI2_8_deactivate");
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
	
	intro = function()
		StartDialogScene("/DialogScenes/A2C3/M1/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	outro = function()
		StartDialogScene( "/DialogScenes/A2C3/M1/S2/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep(2);
	end,
	
	meetDjinn = function()
		Trigger(OBJECT_TOUCH_TRIGGER, 'Djinn', nil);
		CINEMATICS.playAndWait( 0 );
		MakeTownMovable( "Mutazz" );
		OpenCircleFog( 13, 11, GROUND, 10, PLAYER_1 );
		sleep( 1 );
		Play2DSound( "/Maps/Scenario/A2C3M1/SummonEarthsound.xdb#xpointer(/Sound)" );
		sleep( 2 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/DivineVengeance/FX_DivineVengeance.(Effect).xdb#xpointer(/Effect)", "FX_object", 0, 0, 0, 0, 0 );
		sleep( 4 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/DivineVengeance/FX_DivineVengeance.(Effect).xdb#xpointer(/Effect)", "FX_object1", 0, 0, 0, 0, 0 );
		sleep( 3 );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/DivineVengeance/FX_DivineVengeance.(Effect).xdb#xpointer(/Effect)", "FX_object2", 0, 0, 0, 0, 0 );
		sleep( 3 );
		SetObjectPosition( "Mutazz",13, 11, GROUND );
		SetObjectOwner( "Mutazz", PLAYER_1 );
		print ("before");
		local xp = GetHeroStat( "Zehir",  STAT_EXPERIENCE );
		TakeAwayHeroExpFlying ( "Zehir", xp  - 14701 ); -- Scale hero to level 10
		sleep(20);
		local a =  3 - GetHeroStat( "Zehir", 	   STAT_ATTACK );
		local d =  3 - GetHeroStat( "Zehir", 	  STAT_DEFENCE );
		local s = 12 - GetHeroStat( "Zehir",  STAT_SPELL_POWER );
		local k = 10 - GetHeroStat( "Zehir",    STAT_KNOWLEDGE );
		if HasArtefact( "Zehir", 56, 1 ) then
			d = d + 1;
		end
		ChangeHeroStat( "Zehir", 	  STAT_ATTACK, a );
		ChangeHeroStat( "Zehir", 	 STAT_DEFENCE, d );
		ChangeHeroStat( "Zehir", STAT_SPELL_POWER, s );
		ChangeHeroStat( "Zehir",   STAT_KNOWLEDGE, k );
		sleep(10);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", 'Djinn', 0, 0, 0, 0, 0 );
		sleep(10);
		RemoveObject( 'Djinn' );
	end,
	
	meetNarxes = function()
		BlockGame();
		EnableHeroAI( "Razzak", nil );
		SetObjectRotation( "Razzak", 180 );
		SetObjectPosition(  "Razzak", 12, 19, GROUND );
		sleep( 20 );
		CINEMATICS.playAndWait( 2 );
		SetObjectPosition( "Razzak", 132, 129, GROUND );
		DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes ( PLAYER_8, 1 );
		ZehirAbilitiesInit("Zehir");
		ZehirCreaturesAdd( CREATURE_OBSIDIAN_GOLEM, 70 - 10 * diff, SULFUR, 5, 1500);
		UnblockGame();
	end,
	
	meetAssassins = function()
		CINEMATICS.playAndWait( 5 );
	end,
	
	meetYlaya = function()
		BlockGame();
		DeployReserveHero( 'Shadwyn', 4, 40, 1 );
		sleep( 10 );
		SetObjectEnabled( 'Shadwyn', nil );
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", 'Near_Ylaya', 0, -1, 1, 0, 0 );
		SetObjectPosition( 'Shadwyn', 25, 22, 1 );
		sleep(30);
		CINEMATICS.playAndWait( 4 );
		sleep(5);
		PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", 'Near_Ylaya', 0, -1, 1, 0, 0 );
		sleep(10);
		RemoveObject( 'Shadwyn' );
		SetRegionBlocked( "YlayaSpot", nil, PLAYER_1 );
		UnblockGame();
	end,
	
	meetDwarf = function( hero )
		local x_to_return, y_to_return, floor_to_return = GetObjectPosition ( 'Zehir' );
		if hero ~= 'Zehir' then
			local x, y = RegionToPoint( 'ZONE_TO_ZEHIR_TELEPORT' );
			SetRegionBlocked( 'ZONE_TO_ZEHIR_TELEPORT', nil );
			SetObjectRotation( 'Zehir', 200 );
			SetObjectPosition( 'Zehir', x, y, UNDERGROUND );
			sleep( 20 );
		end
		CINEMATICS.playAndWait( 6 );
		if table.length(GetObjectsInRegion( 'ZONE_TO_ZEHIR_TELEPORT', OBJECT_HERO )) > 0 then
			SetObjectPosition( 'Zehir', x_to_return, y_to_return, floor_to_return );
		end
		if HasArtefact( OBJECTIVES.findArtifact_visitor, ARTIFACT_RUNE_OF_FLAME) == nil then
			OpenCircleFog(84, 115, 1, 5, 1);		
			MoveCamera(84, 115, 1, 30, 1, 0, 0, 0, 1);
			sleep(60);
			startThread( f_starter_for_random_message_007_and_008 );
		end
	end,
}

OBJECTIVES = {
	state = {
		 isAlive 	 	= { "pri1", 1 }, 	-- Capture the mage city
		 defeatElves 	= { "pri2", 1 }, 	-- eliminate dark Elves
		 findInfo  	 	= { "pri3", 0 }, 	-- find Info on Isabell
		 cannonFodder	= { "sec1", 0 }, 	-- use assassins as cannon fodder to prevent revolt
		 findArtifact	= { "sec2", 0 }, 	-- help the Dwarf to find Artifact
		 eventManager 	= {    "_", 1 }, 	--
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		DIFFICULTY[GetDifficulty()]();
		SetObjectEnabled( 'Djinn', nil );
		SetObjectEnabled( 'Assasin', nil );
		SetObjectEnabled( 'Garrison1', nil );
		SetRegionBlocked( "ZONE_TO_ZEHIR_TELEPORT", not nil );
		CINEMATICS.intro();
		EnableHeroAI( 'Ottar', nil );
		SetObjectEnabled( 'Ottar', nil );
		SetRegionBlocked( "YlayaSpot", not nil, PLAYER_1 );
		SetObjectEnabled( "Razzak", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'Dwarf', "f_meetDwarfOttar" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Nraxes", "f_meetNarxes" );
		SetRegionBlocked('ZONE_BLOCK_AI2_1', 1, PLAYER_2);
		SetRegionBlocked('ZONE_BLOCK_AI2_2', 1, PLAYER_2);
		SetRegionBlocked('ZONE_BLOCK_AI2_3', 1, PLAYER_2);
		SetRegionBlocked('ZONE_BLOCK_AI2_4', 1, PLAYER_2);
		SetRegionBlocked('ZONE_BLOCK_AI2_5', 1, PLAYER_2);
		SetRegionBlocked('ZONE_BLOCK_AI2_6', 1, PLAYER_2);
		SetRegionBlocked('ZONE_BLOCK_AI2_7', 1, PLAYER_2);
		SetRegionBlocked('ZONE_BLOCK_AI2_8', 1, PLAYER_2);
		SetRegionBlocked('Block_upper_temp', 1, PLAYER_2);
		SetRegionBlocked('Zone_Block_One_Way_Teleport', 1, PLAYER_2);
		DenyAIHeroFlee('Zehir', not nil);
		AllowPlayerTavernHero( PLAYER_1, 'Zehir', 1 );
		MakeHeroReturnToTavernAfterDeath('Zehir', 1, 1 );
		for i, hero in {'Astral', 'Faiz', 'Havez', 'Isher', 'Nur', 'Sufi' } do
			MakeHeroReturnToTavernAfterDeath( hero, 1 );
		end
		SetDisabledObjectMode( 	 'Djinn', DISABLED_INTERACT );
		SetDisabledObjectMode( 'Assasin', DISABLED_INTERACT );
		for i, hero in ElvenHeroes do
			MakeHeroReturnToTavernAfterDeath(hero, 1);
		end
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'ZONE_MEET_WITH_YLAYA', "f_meetYlaya");
		Trigger(OBJECT_TOUCH_TRIGGER, 'Djinn', "CINEMATICS.meetDjinn");
		Trigger(OBJECT_TOUCH_TRIGGER, 'Assasin', "f_meetCannonFodder");
		Trigger(OBJECT_CAPTURE_TRIGGER, 'Garrison1', "f_ZONE_BLOCK_AI2_3_deactivate");
		Trigger(OBJECT_TOUCH_TRIGGER, 'Garrison1', "f_attackGarrison1");
	end,
	
	run = function()
		while true do
			sleep(10);
			OBJECTIVES.date = GetDate(ABSOLUTE_DAY);
			for key, value in OBJECTIVES.state do
				if value[2] > 0 and value[2] < 10 then
					if pcall(OBJECTIVES[key]) == nil then print(key) end
				end
			end
			
			if GetObjectiveState('pri1') == OBJECTIVE_FAILED then
				Loose();
				return
			end
	
			if GetObjectiveState("pri2") == OBJECTIVE_COMPLETED and GetObjectiveState("sec2") ~= OBJECTIVE_ACTIVE then
				SaveHeroAllSetArtifactsEquipped( "Zehir", "A2C3M1" );
				CINEMATICS.outro();
				sleep( 100 );
				Win();
				return
			end
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive( "Zehir" ) == nil and GetObjectOwner( 'Mutazz' ) ~= PLAYER_1 then
			SetObjectiveState( "pri1", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	defeatElves = function()
		if OBJECTIVES.state.defeatElves[2] == 1 and OBJECTIVES.state.findInfo[2] == 11 then
			SetObjectiveState( 'pri2', OBJECTIVE_ACTIVE, PLAYER_1 );
			OBJECTIVES.state.defeatElves[2] = 2;
		elseif OBJECTIVES.state.defeatElves[2] == 2 and AreElvesDefeated() ~= nil then	
			SetObjectiveState( "pri2", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.defeatElves[2] = 10;
		end
	end,
	
	findInfo = function()
	-- start of this task is handled by the map.xdb file
		if OBJECTIVES.state.findInfo[2] == 1 then
			CINEMATICS.meetYlaya();
			SetObjectiveState( "pri3", OBJECTIVE_FAILED );
			OBJECTIVES.state.findInfo[2] = 11;
		end
	end,
	
	cannonFodder_combatID = -1,
	cannonFodder_diedCount = 0,
	cannonFodder_liveCount = 0,
	cannonFodder = function()
		if OBJECTIVES.state.cannonFodder[2] == 1 then
			CINEMATICS.meetAssassins();
			SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE, PLAYER_1 );
			local assassins_count = GetObjectCreatures( 'Assasin', CREATURE_ASSASSIN );
			AddHeroCreatures( 'Zehir', CREATURE_ASSASSIN, assassins_count );
			RemoveObject( 'Assasin' );
			OBJECTIVES.cannonFodder_liveCount = assassins_count;
			Trigger( COMBAT_RESULTS_TRIGGER, "combat_results" );
			OBJECTIVES.state.cannonFodder[2] = 2;
		elseif OBJECTIVES.state.cannonFodder[2] == 2 and GetHeroCreatures( 'Zehir', CREATURE_ASSASSIN ) < OBJECTIVES.cannonFodder_liveCount then
			if OBJECTIVES.cannonFodder_combatID >= GetLastSavedCombatIndex() then
				local count = GetHeroCreatures( 'Zehir', CREATURE_ASSASSIN );
				if count < OBJECTIVES.cannonFodder_liveCount then
					Trigger( COMBAT_RESULTS_TRIGGER, nil );
					RemoveHeroCreatures( 'Zehir', CREATURE_ASSASSIN, OBJECTIVES.cannonFodder_liveCount );
					print("CombatResultsFunc: Zehir still has ", GetHeroCreatures( 'Zehir', CREATURE_ASSASSIN ), " assassins", "Died ", OBJECTIVES.cannonFodder_diedCount );
					StartCombat( 'Zehir', nil, 1, CREATURE_ASSASSIN, OBJECTIVES.cannonFodder_liveCount, nil, "assassin_combat_results" );
					OBJECTIVES.state.cannonFodder[2] = 6;
				else
					OBJECTIVES.cannonFodder_liveCount = count;
				end
			end
		elseif OBJECTIVES.state.cannonFodder[2] == 5 then
			if OBJECTIVES.cannonFodder_diedCount >= 100 then
				SetObjectiveState( "sec1", OBJECTIVE_COMPLETED );
				Trigger( COMBAT_RESULTS_TRIGGER, nil );
				startThread( Play2DSound, "/Maps/Scenario/A2C3M1/C3M1_VO2_Zehir_01sound.xdb#xpointer(/Sound)" );
				OBJECTIVES.state.cannonFodder[2] = 10;
			else
				OBJECTIVES.state.cannonFodder[2] = 2;
			end
		elseif OBJECTIVES.state.cannonFodder[2] == 6 then
			SetObjectiveState( "sec1", OBJECTIVE_FAILED );
			OBJECTIVES.state.cannonFodder[2] = 11;
		end

	end,
	
	findArtifact_visitor = "Zehir",
	findArtifact = function()
		if OBJECTIVES.state.findArtifact[2] == 1 then
			CINEMATICS.meetDwarf(OBJECTIVES.findArtifact_visitor);
			SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE, PLAYER_1 );
			OBJECTIVES.state.findArtifact[2] = 2;
		elseif OBJECTIVES.state.findArtifact[2] == 3 then
			if HasArtefact( OBJECTIVES.findArtifact_visitor, ARTIFACT_RUNE_OF_FLAME ) then
				SetObjectiveState('sec2', OBJECTIVE_COMPLETED );
				RemoveArtefact( OBJECTIVES.findArtifact_visitor, ARTIFACT_RUNE_OF_FLAME );			
				MessageBox("/Maps/Scenario/A2C3M1/messagebox_010.txt");
				GiveArtefact( OBJECTIVES.findArtifact_visitor, 40 );
				sleep( 10 );
				PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", 'Ottar', 0, 0, 0, 0, 0 );
				sleep( 30 );
				RemoveObject( 'Ottar' );			
				SetGameVar( "BONUS_A2C3M1", "1" );
				Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'Dwarf', nil );
				OBJECTIVES.state.findArtifact[2] = 10;
			else
				MessageBox("/Maps/Scenario/A2C3M1/messagebox_001.txt");
				OBJECTIVES.state.findArtifact[2] = 2;
			end
		end
		
		if OBJECTIVES.state.defeatElves[2] == 10 then
			OpenCircleFog(80, 26, 1, 5, 1);		
			MoveCamera(80, 26, 1, 30, 1, 1.57, 0, 0, 1);		
			sleep(20);
			if IsObjectExists( "Ottar" ) then
				startThread(ShowFlyingSign, "/Maps/Scenario/A2C3M1/messagebox_009.txt", 'Ottar', PLAYER_1, 9.0);
				PlayVisualEffect( "/Effects/_(Effect)/Spells/Teleport_Start.xdb#xpointer(/Effect)", 'Ottar', 0, 0, 0, 0, 0 );
				sleep(20);
				RemoveObject( 'Ottar' );
			end
			SetObjectiveState("sec2", OBJECTIVE_FAILED, PLAYER_1);
			OBJECTIVES.state.findArtifact[2] = 11;
		end
	end,
	
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date > OBJECTIVES.eventManager_day then
			if UnblockZoneForAIonDate[1] ~= nil and OBJECTIVES.date >= UnblockZoneForAIonDate[1] then
				SetRegionBlocked('ZONE_BLOCK_AI2_3', nil, PLAYER_2);
				SetRegionBlocked('Zone_Block_One_Way_Teleport', nil, PLAYER_2);
				UnblockZoneForAIonDate[1] = nil;
				print("Teleport is now open");
			end
			if UnblockZoneForAIonDate[2] ~= nil and OBJECTIVES.date >= UnblockZoneForAIonDate[2] then
				SetRegionBlocked('ZONE_BLOCK_AI2_4', nil, PLAYER_2);
				UnblockZoneForAIonDate[2] = nil;
				print("f_ZONE_BLOCK_AI2_4_deactivate");
			end
			if UnblockZoneForAIonDate[3] ~= nil and OBJECTIVES.date >= UnblockZoneForAIonDate[3] then
				SetRegionBlocked('ZONE_BLOCK_AI2_6', nil, PLAYER_2);
				UnblockZoneForAIonDate[3] = nil;
				print("f_ZONE_BLOCK_AI2_6_deactivate");
			end
			if UnblockZoneForAIonDate[4] ~= nil and OBJECTIVES.date >= UnblockZoneForAIonDate[4] then
				SetRegionBlocked('ZONE_BLOCK_AI2_8', nil, PLAYER_2);
				UnblockZoneForAIonDate[4] = nil;
				print("f_ZONE_BLOCK_AI2_8_deactivate");
			end			
			OBJECTIVES.eventManager_day = OBJECTIVES.date;
		end
	end,
}
------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
