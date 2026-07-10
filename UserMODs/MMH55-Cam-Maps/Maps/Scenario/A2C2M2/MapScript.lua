doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_TAROT_DECK,
	ARTIFACT_ENDLESS_BAG_OF_GOLD
};

function startSetArtifactsInit()
	InitAllSetArtifacts( "A2C2M2", "Kujin" );
end
startThread( startSetArtifactsInit );

H55c_AI_CONTROLLED = {
  player1 = {          -- Yellow HUMAN player
      state = 0,
	   heroes = {},
	   enemies = {},
  },
  player2 = { 		   -- Orange Tribe
		state = 1,
		heroes = {},
		enemies = {},
  },
  player3 = { 		   -- Brown Tribe
		state = 1,
		heroes = {},
		enemies = {},
  },
  player4 = { 		   -- Green Tribe
		state = 1,
		heroes = {},
		enemies = {},
  },
  player5 = { 		   -- Light Blue Tribe
		state = 2,
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 0.7, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER5
			{ priority = 0.2, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER6
		}
  },
  player6 = { 		   -- Purple Dungeon Pirates
		state = 2,
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
			{ priority = 0.3, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER5
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER6
		}
  }
}

PIRATE_HEROES = { "Dalom", "Ferigl", "Metlirn" }; -- two dungeon heroes and one sylvan 
ORC_HARASS_HEROES = { "Hero2", "Hero3", "Hero7" };
A2C2M2_TRIBE_PHONEBOOK = {
	[PLAYER_2] = { place = {  32,  24 }, town =  'FirstTown', chief = "Hero8", reserved =     "Efion" },
	[PLAYER_3] = { place = {  80,  93 }, town = 'SecondTown', chief = "Hero1", reserved = "Christian" },
	[PLAYER_4] = { place = { 151, 128 }, town =  'ThirdTown', chief = "Hero4", reserved = 	  "Nemor" },
	[PLAYER_5] = { place = {  99,  43 }, town = 'FourthTown', chief = "Hero9", reserved =      "Egil" },
}

DIFFICULTY = {
	[0] = function()
		diff = 2;
		print("Difficulty level is normal.");
	end,
	
	[1] = function()
		diff = 2;
		GiveExp("Hero6", 58600);
		print("Difficulty level is hard.");
	end,
	
	[2] = function()
		diff = 3;
		GiveExp("Hero6", 181400);
		GiveHeroSkill("Hero6", HERO_SKILL_BARBARIAN_LEARNING);				
		print("Difficulty level is heroic.");
	end,
	
	[3] = function()
		diff = 4;
		GiveExp("Hero6", 434400);
		GiveHeroSkill("Hero6", HERO_SKILL_BARBARIAN_LEARNING);
		GiveHeroSkill("Hero6", HERO_SKILL_BODYBUILDING);
		print("Difficulty level is impossible.");
	end,
}

function EnemyHeroSetup(hero, bonus_percent)
	for creatureID = 1, CREATURES_COUNT - 1 do 
		CreatureSetUp = GetHeroCreatures( hero, creatureID );
		if GetHeroCreatures( hero, creatureID ) > 1 then
			RemoveHeroCreatures( hero, creatureID, CreatureSetUp );
			AddHeroCreatures( hero, creatureID, CreatureSetUp + ( CreatureSetUp / 100 ) * ( (bonus_percent + 9) * diff ) ); -- adds ( 9 + bonus_percent )*diff % to stack size
		end
	end
end

function GarrisonSetUp()
	for creatureID = 1, CREATURES_COUNT - 1 do 
		CreatureSetUp = GetObjectCreatures( "Garrison", creatureID );
		if GetObjectCreatures( "Garrison", creatureID ) > 1 then
			RemoveObjectCreatures( "Garrison", creatureID, CreatureSetUp );
			AddObjectCreatures( "Garrison", creatureID, CreatureSetUp + ( CreatureSetUp / 100 * 40) * diff );
		end
	end
end

function ObjectiveInit( hero )
	if hero == "Kujin" then
		for i, region in { "FirstChief", "SecondChief", "ThirdChief", "FourthChief" } do
			if IsObjectInRegion( hero, region ) then
				Trigger( REGION_ENTER_AND_STOP_TRIGGER, region, nil );
				OBJECTIVES.state[region][2] = 3;
				return
			end
		end
		-- if IsObjectInRegion( hero, "FirstChief" ) then
			-- Trigger( REGION_ENTER_AND_STOP_TRIGGER, "FirstChief", nil );
			-- OBJECTIVES.state.FirstChief[2] = 3;
		-- elseif IsObjectInRegion( hero, "SecondChief" ) then
			-- Trigger( REGION_ENTER_AND_STOP_TRIGGER, "SecondChief", nil );
			-- OBJECTIVES.state.SecondChief[2] = 3;
		-- elseif IsObjectInRegion( hero, "ThirdChief" ) then
			-- Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ThirdChief", nil );
			-- OBJECTIVES.state.ThirdChief[2] = 3;
		-- elseif IsObjectInRegion( hero, "FourthChief" ) then
			-- Trigger( REGION_ENTER_AND_STOP_TRIGGER, "FourthChief", nil );
			-- OBJECTIVES.state.FourthChief[2] = 3;
		-- end
	elseif hero ~= "Kujin" and GetObjectOwner( hero ) == PLAYER_1 then	
		MessageBox( "/Maps/Scenario/a2c2m2/message03.txt" );
	end
end

TemporaryHero = "Kujin";
function SpeakWithCyclopGuard( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		TemporaryHero = hero;
		if GetObjectiveState( "obj3" ) ~= OBJECTIVE_COMPLETED then
			MessageBox( "/Maps/Scenario/a2c2m2/message05.txt" );
		elseif GetObjectiveState( "obj3" ) == OBJECTIVE_COMPLETED then
			QuestionBox( "/Maps/Scenario/a2c2m2/message06.txt", "QuestionBoxYes", "QuestionBoxNo" );
			Trigger( OBJECT_TOUCH_TRIGGER, "Guard", nil );
		end
	end
end

function QuestionBoxYes()
	RemoveObject( "Guard" );
	AddHeroCreatures( TemporaryHero, CREATURE_CYCLOP_UNTAMED, 14 - 2 * diff );
end

function QuestionBoxNo()
	RemoveObject( "Guard" );
end

function defeatWave2( hero )
	if hero == "Hero6" then	
		PlayVoiceoverAndBlockGame( "/Maps/Scenario/A2C2M2/C2M2_VO6_Kujin_01sound.xdb#xpointer(/Sound)" );
	end
end;

function meetExecutioners( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "AdvMapDialog4", nil );
		CINEMATICS.meetExecutioners(hero);
	end
end

function EnablePirates()
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "PiratesActivation", nil );
	OBJECTIVES.state.pirates[2] = 1;
end

function EnterAmbushInBayArea( hero )
	if hero == "Kujin" then	
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "AdvMapDialog1", nil );
		StartAdvMapDialog( 5, "MessageBox( '/Maps/Scenario/a2c2m2/message01.txt' )" );
	elseif hero ~= "Kujin" and GetObjectOwner( hero ) == PLAYER_1 then
		MessageBox( "/Maps/Scenario/a2c2m2/message08.txt" );
	end
end

function JoinTribe(player_id)
	local tribe = A2C2M2_TRIBE_PHONEBOOK[player_id];
	SetObjectOwner( tribe.chief, PLAYER_1 );
	SetObjectEnabled( tribe.chief, not nil );
	SetObjectOwner( tribe.town, PLAYER_1 );
	sleep(20);
	local heroes = GetPlayerHeroes( player_id );
	for i,hero in heroes do
		if hero ~= tribe.reserved and IsHeroAlive( hero ) then
			RemoveObject( hero );
		end
	end
	DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes( player_id, 1 );
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

		sleep(2);
	end,
	
	findNextTribe = function(player_id)
		BlockGame();
		local place = A2C2M2_TRIBE_PHONEBOOK[player_id].place;
		OpenCircleFog( place[1], place[2], GROUND, 10, PLAYER_1 );
		MoveCamera( place[1], place[2], GROUND, 100, 3.14/3, 0, 1, 1, 1 );
		sleep( 100 );
		local x,y,level = GetObjectPosition( "Kujin" );
		MoveCamera( x, y, level, 50, 3.14/3, 0, 1, 1, 1 );
		UnblockGame();
	end,
	
	talkChief = function(chief_id)
		CINEMATICS.playAndWait( chief_id );
	end,
	
	meetExecutioners = function(hero)
		local x,y,level = GetObjectPosition( "Kujin" );
		SetObjectRotation( "OrcishMate", 225 );
		SetObjectPosition( "OrcishMate", 118, 36, GROUND );
		if hero ~= "Kujin" then
			SetObjectRotation( "Kujin", 180 );
			SetObjectPosition( "Kujin", 123, 37, GROUND );
		end
		CINEMATICS.playAndWait( 4 );
		MessageBox( "/Maps/Scenario/a2c2m2/message02.txt" );
		RemoveObject( "OrcishMate" );
		if hero ~= "Kujin" then
			SetObjectPosition( "Kujin", x, y, level );
		end
	end,
}

OBJECTIVES = {
	state = {
		  gatherClans = { "obj1", 1 }, 	-- Gather all northern clаns
		  FirstChief  = { "obj2", 1 }, 	-- Speak with Osol-Aih clan
		  SecondChief = { "obj3", 1 }, 	-- Speak with Baishin-Gal clan
		  ThirdChief  = { "obj4", 1 }, 	-- Speak with Harakh clan
		  FourthChief = { "obj5", 1 }, 	-- Speak with Ull-Dash clan
		  isAlive 	  = { "obj6", 1 }, 	-- Kujin must survive
		  pirates 	  = {    "_", 0 }, 	-- Pirates are enabled when the first hero leaves for the sea
		orcHarass 	  = {    "_", 1 }, 	-- AI Player 5 harassment against the human player
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		Trigger(  REGION_ENTER_AND_STOP_TRIGGER,  "FirstChief",  "ObjectiveInit" );
		Trigger(  REGION_ENTER_AND_STOP_TRIGGER, "SecondChief",  "ObjectiveInit" );
		Trigger(  REGION_ENTER_AND_STOP_TRIGGER,  "ThirdChief",  "ObjectiveInit" );
		Trigger(  REGION_ENTER_AND_STOP_TRIGGER, "FourthChief",  "ObjectiveInit" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "AdvMapDialog4", "meetExecutioners" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "AdvMapDialog1", "EnterAmbushInBayArea" );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "PiratesActivation", "EnablePirates" );
		Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_5, "defeatWave2" );
		DIFFICULTY[GetDifficulty()]();
		SetHeroesExpCoef( 0.75 );
		for player = 2,5 do  											-- setup tribe chiefs and reserved heroes
			local tribe = A2C2M2_TRIBE_PHONEBOOK[player];
			EnableHeroAI( tribe.chief, nil );
			SetObjectEnabled( tribe.chief, nil );
			EnableHeroAI( tribe.reserved, nil );
		end
		SetRegionBlocked( "FirstChiefBlock", not nil, PLAYER_2 );
		SetRegionBlocked(		"SeaBlock1", not nil, PLAYER_3 ); 					-- Block bay entry
		SetRegionBlocked(		"SeaBlock2", not nil, PLAYER_5 ); 					-- block Orc shipyard
		SetRegionBlocked(		"SeaBlock3", not nil, PLAYER_6 ); 					-- Block pirates from attacking the last tribe
		SetRegionBlocked(	  "PortalBlock", not nil, PLAYER_5 ); 					-- Block teleport entry
		for i = 1,8 do -- Block player 1 entries to clans until the questline progress
			SetRegionBlocked( "PRB"..i, not nil, PLAYER_1 );
		end
		Trigger( OBJECT_TOUCH_TRIGGER, "Guard", "SpeakWithCyclopGuard" ); 			-- setup Cyclop guard
		SetObjectEnabled( "Guard", nil );
		SetDisabledObjectMode( "Guard", DISABLED_INTERACT );
		for i, victim in { "Victim", "Victim1", "Victim2" } do 						-- setup victims around the Cyclop guard
			SetObjectEnabled( victim, nil );
			sleep(20);
			SetDisabledObjectMode(victim, DISABLED_BLOCKED );
			SetMonsterSelectionType( victim, 0 );
			PlayObjectAnimation( victim, "death", ONESHOT_STILL );
			OverrideObjectTooltipNameAndDescription( victim, "-disabled-","" ); 	-- does not work in QAI
		end
		EnableHeroAI( "Hero6", nil );												-- setup Gork the guardian of the final tribe garrison
		DenyAIHeroFlee( "Hero6", not nil );
		EnemyHeroSetup("Hero6", 1);
		DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes (PLAYER_6, not nil);
		ChangeHeroStat( "Dalom", STAT_EXPERIENCE, 35000 );
		ChangeHeroStat( "Ferigl", STAT_EXPERIENCE, 20000 );
		ChangeHeroStat( "Metlirn", STAT_EXPERIENCE, 18000 );
		for i,hero in PIRATE_HEROES do --setup pirates
			DenyAIHeroFlee( hero, not nil );
			EnableHeroAI( hero, nil );
			SetHeroRoleMode( hero, HERO_ROLE_MODE_HERMIT );
			EnemyHeroSetup(hero, 1);
		end
		GarrisonSetUp();
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
			
			if GetObjectiveState('obj6') == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED then
				startThread( Play2DSound, "/Maps/Scenario/A2C2M2/C2M2_VO4_Kujin_01sound.xdb#xpointer(/Sound)" );
				SaveHeroAllSetArtifactsEquipped( "Kujin", "A2C2M2" );
				sleep( 100 );
				Win();
				return
			end
		end
	end,
	
	gatherClans = function()
		if OBJECTIVES.state.gatherClans[2] == 1 then
			SetObjectiveState( "obj1", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.gatherClans[2] = 2;
		elseif OBJECTIVES.state.gatherClans[2] == 2 and OBJECTIVES.state.FirstChief[2] == 10 and OBJECTIVES.state.SecondChief[2] == 10 and OBJECTIVES.state.ThirdChief[2] == 10 and OBJECTIVES.state.FourthChief[2] == 10 then
			SetObjectiveState( "obj1", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.gatherClans[2] = 10;
		end
	end,
	
	FirstChief = function()
		if OBJECTIVES.state.FirstChief[2] == 1 then
			SetObjectiveState( "obj2", OBJECTIVE_ACTIVE );		
			OBJECTIVES.state.FirstChief[2] = 2;
		elseif OBJECTIVES.state.FirstChief[2] == 3 then
			CINEMATICS.talkChief(0);
			SetRegionBlocked( "PRB1", nil, PLAYER_1 );
			SetRegionBlocked( "PRB2", nil, PLAYER_1 );
			SetObjectiveState( "obj2", OBJECTIVE_COMPLETED );
			JoinTribe(PLAYER_2);
			OBJECTIVES.state.FirstChief[2] = 10;
			GiveExp("Hero8", 1000);
		end
	end,
	
	SecondChief = function()
		if OBJECTIVES.state.SecondChief[2] == 1 and OBJECTIVES.state.FirstChief[2] == 10 then
			SetObjectiveState( "obj3", OBJECTIVE_ACTIVE );
			CINEMATICS.findNextTribe(PLAYER_3);
			OBJECTIVES.state.SecondChief[2] = 2;
		elseif OBJECTIVES.state.SecondChief[2] == 3 then
			CINEMATICS.talkChief(2);
			JoinTribe(PLAYER_3);
			SetRegionBlocked( "PRB3", nil, PLAYER_1 );
			SetRegionBlocked( "PRB4", nil, PLAYER_1 );
			SetObjectiveState( "obj3", OBJECTIVE_COMPLETED );
			MessageBox( "/Maps/Scenario/a2c2m2/message07.txt" ); -- Cyclops will recognize you as friend
			OpenCircleFog( 25, 77, GROUND, 6, PLAYER_1 );
			OpenCircleFog( 27, 84, GROUND, 6, PLAYER_1 );
			OBJECTIVES.state.SecondChief[2] = 10;
			GiveExp("Hero1", 8000);
		end
	end,
	
	ThirdChief = function()
		if OBJECTIVES.state.ThirdChief[2] == 1 and OBJECTIVES.state.SecondChief[2] == 10 then
			SetObjectiveState( "obj4", OBJECTIVE_ACTIVE );
			CINEMATICS.findNextTribe(PLAYER_4);
			OBJECTIVES.state.ThirdChief[2] = 2;
		elseif OBJECTIVES.state.ThirdChief[2] == 3 then
			CINEMATICS.talkChief(1);
			JoinTribe(PLAYER_4);
			SetObjectiveState( "obj4", OBJECTIVE_COMPLETED );
			SetRegionBlocked( "PRB5", nil, PLAYER_1 );
			SetRegionBlocked( "PRB6", nil, PLAYER_1 );
			OBJECTIVES.state.ThirdChief[2] = 10;
			GiveExp("Hero4", 18000);
		end
	end,

	FourthChief = function()
		if OBJECTIVES.state.FourthChief[2] == 1 and OBJECTIVES.state.ThirdChief[2] == 10 then
			SetObjectiveState( "obj5", OBJECTIVE_ACTIVE );
			CINEMATICS.findNextTribe(PLAYER_5);
			OBJECTIVES.state.FourthChief[2] = 2;
		elseif OBJECTIVES.state.FourthChief[2] == 3 then
			CINEMATICS.talkChief(3);
			JoinTribe(PLAYER_5);
			SetObjectiveState( "obj5", OBJECTIVE_COMPLETED );
			SetRegionBlocked( "PRB7", nil, PLAYER_1 );
			SetRegionBlocked( "PRB8", nil, PLAYER_1 );
			OBJECTIVES.state.FourthChief[2] = 10;
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive( "Kujin" ) == nil then
			SetObjectiveState( "obj6", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		elseif OBJECTIVES.state.gatherClans[2] == 10 then
			SetObjectiveState( "obj6", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.isAlive[2] = 10;
		end
	end,
	
	pirates_start = 0,
	pirates = function()
		if OBJECTIVES.state.pirates[2] == 1 then
			OBJECTIVES.pirates_start = random( 3 ) + OBJECTIVES.date;
			OBJECTIVES.state.pirates[2] = 2;
		elseif OBJECTIVES.state.pirates[2] == 2 and OBJECTIVES.pirates_start <= OBJECTIVES.date then
			DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes( PLAYER_6, 0 );
			H55c_AIAddHero("Ferigl");
			H55c_AIAddHero("Metlirn");
			OBJECTIVES.state.pirates[2] = 10;
		end
	end,

	orcHarass_wave = 0,
	orcHarass_assaultDay = 9999,
	orcHarass_hero = "Hero2",
	orcHarass = function()
		if OBJECTIVES.state.orcHarass[2] == 1 and OBJECTIVES.date >= 40 - GetDifficulty() then
			SetRegionBlocked( "PortalBlock", nil, PLAYER_5 );
			OBJECTIVES.orcHarass_assaultDay = OBJECTIVES.date;
			OBJECTIVES.state.orcHarass[2] = 2;
		elseif OBJECTIVES.state.orcHarass[2] == 2 and OBJECTIVES.orcHarass_assaultDay < OBJECTIVES.date and IsHeroAlive(OBJECTIVES.orcHarass_hero) == nil then
			OBJECTIVES.orcHarass_hero = ORC_HARASS_HEROES[math.mod(OBJECTIVES.orcHarass_wave, 3) + 1];
			print( "Active hero is "..OBJECTIVES.orcHarass_hero );
			DeployReserveHero( OBJECTIVES.orcHarass_hero, 107, 45, GROUND );
			sleep(10);
			SetObjectPosition(OBJECTIVES.orcHarass_hero, 81, 47, 0);
			EnemyHeroSetup( OBJECTIVES.orcHarass_hero, OBJECTIVES.orcHarass_wave + 1 );
			ChangeHeroStat( OBJECTIVES.orcHarass_hero, STAT_EXPERIENCE, 10000 + 500 * ( diff + OBJECTIVES.orcHarass_wave + 1 ) );
			H55c_AIAddHero( OBJECTIVES.orcHarass_hero );
			OBJECTIVES.orcHarass_wave = OBJECTIVES.orcHarass_wave + 1;
			OBJECTIVES.orcHarass_assaultDay = OBJECTIVES.date + 5 + math.random(5);
		end
	end
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start )
startThread( H55c_AI_main )

function a2c2m2_dbg(var)
	if var == 1 then
		pcall(H55_NoFog, 1);
		H55_Speedrun(1);
		SetObjectPosition("Kujin", 32, 30);
	elseif var == 2 then
		SetObjectPosition("Kujin", 79, 83);
	elseif var == 22 then
		SetObjectPosition("Kujin", 24, 73);
	end
end
