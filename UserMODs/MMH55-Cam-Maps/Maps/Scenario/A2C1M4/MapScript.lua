doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_PlayerStatus = {0,1,1,1,2,2,2,2};
H55c_AI_CONTROLLED = {
  player1 = {          -- player 1player/human so state should be 0 to skip control of the heroes
      state = 0,       -- 0 human, 1 unmanaged AI, 2 managed AI
	   heroes = {},
	  enemies = {},
  },
  player2 = { 		     -- Blue Haven Bookshire town conquered by Orc Chieftain player
      state = 1,         -- Enemy to the player but not targeting him directly
	   heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = -1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
    }
  },
  player3 = { 		     -- Yellow Stronghold player town Zogsokh
      state = 2,         -- Leads onslaught against the human player main town until fortifications are built
	   heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = -1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
    }
  },
  player4 = { 		     -- Red Inferno AI player
      state = 2,         -- Leads onslaught against the human player main town
	   heroes = {},
  	enemies = {
	    { priority = 1.0, heroes = -1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
	    { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
    }
  }
}

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_STAFF_OF_VEXINGS,
	ARTIFACT_CLOAK_OF_MOURNING,
	ARTIFACT_RING_OF_DEATH,
	ARTIFACT_SKULL_HELMET
};

function f_artifacts_sets()
	InitAllSetArtifacts( "A2C1M4", "Arantir", "OrnellaNecro" );
	LoadHeroAllSetArtifacts(      "Arantir", "A2C1M3");
	LoadHeroAllSetArtifacts( "OrnellaNecro", "A2C1M3");
	sleep(40);
	H55_CamFixTooManySkills(PLAYER_1,      "Arantir");
	H55_CamFixTooManySkills(PLAYER_1, "OrnellaNecro");
end

-----------------------------------------------------------------------------------------------------
--------------------------------- TITLE ----------------------------------------------------------
-----------------------------------------------------------------------------------------------------
--	Creation Date: 27.12.06
--	Author: zomg mega script by Vladimir Degen
-- 	Author e-mail: vladimir.degen@nival.com
--	Project Name: H5A2
--	Map Name: A2C1M4
--	Script Description: MapScript

---------------------------------------------------------------------------------------------------
----------------------------- CONSTANTS --------------------------------------------------
--------------------------------------------------------------------------------------------------- 
HERO_PLAYER_MAIN = 'Arantir';
HERO_PLAYER_SEC = 'OrnellaNecro';
HERO_AI_ORC_TRAP = 'Hero9';
HERO_AI_ORC_KUJIN = 'Hero7';
HERO_AI_ORC_GUARD = 'Hero3';

---------------------------------------------------------------------------------------------------
----------------------------- FUNCTIONS ---------------------------------------------------
---------------------------------------------------------------------------------------------------
function f_autosave()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_AUTOSAVE", nil);
	Save("Autosave");
end

function player_2_hero_check()
	heroes = GetPlayerHeroes( PLAYER_2 );
	print( "Player 2 active heroes are ", heroes );
	for i,hero in heroes do 
		if hero ~= HERO_AI_ORC_KUJIN then
			MakeHeroReturnToTavernAfterDeath( hero, not nil );
		end
	end
end

function FinalTownSetUp()
	for creatureID = 1, CREATURES_COUNT - 1 do 
		CreatureSetUp = GetObjectCreatures( 'FINAL_ORC_TOWN', creatureID );
		if GetObjectCreatures( 'FINAL_ORC_TOWN', creatureID ) > 2 then
			RemoveObjectCreatures( 'FINAL_ORC_TOWN', creatureID, CreatureSetUp );
			AddObjectCreatures( 'FINAL_ORC_TOWN', creatureID, CreatureSetUp + CreatureSetUp * diff );
		end
	end
end

DIFFICULTY = {
	[0] = function()
		diff = 2;
		ChieftainTownTavernActivationDay = 18; -- the coefficient for Chieftain AI army deployment depending on the chosen difficulty level.
		print("Difficulty Level is NORMAL");
	end,
	[1] = function()
		diff = 2;
		ChieftainTownTavernActivationDay = 18;
		print("Difficulty Level is HARD");
	end,
	[2] = function()
		diff = 3;
		ChieftainTownTavernActivationDay = 12;
		print("Difficulty Level is HEROIC");
	end,
	[3] = function()
		diff = 4;
		ChieftainTownTavernActivationDay = 6;
		print("Difficulty Level is IMPOSSIBLE");
	end,
}

A2C1M4_ORC_RAIDERS = { "Hero8", "Hero4", "Hero1", "Hero6" };	-- list of raider heroes
A2C1M4_ORC_RAIDERS.n = 4;
function deployOrcRaider(wave, day)
	local hero = A2C1M4_ORC_RAIDERS[math.mod(wave, A2C1M4_ORC_RAIDERS.n) + 1];
	DeployReserveHero( hero, 21, 37, GROUND );
	sleep(10);
	SetHeroRoleMode( hero, HERO_ROLE_MODE_FREEMAN  );
	H55c_updateArmy( hero, diff + wave * 0.2, H55c_CREATURES.STRONGHOLD );
	ChangeHeroStat( hero, STAT_EXPERIENCE, ( 1000 + day * 100 ) * diff );
	H55c_AIAddHero( hero );
	return hero;
end

function f_road_block_check()
	while 1 do
		if IsObjectExists('CREATURE_BANDIT_ARMY') == nil then
			RemoveObject('ITEM_LOG');
			MessageBox("/Maps/Scenario/A2C1M4/messagebox_007.txt"); -- MESSAGEBOX - Arantir kills brigands and cleard the road from the fallen tree.
			return
		end
		sleep(20);
	end
end
		
function A2C1M4_meetKujin( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then	
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "DIALOG_SCENE_KUJIN", nil );
		CINEMATICS.meetKujin( hero );
		local setExpStat = GetHeroStat( HERO_PLAYER_MAIN, STAT_EXPERIENCE );
		print( "setExpStat = ",( setExpStat / 100 ) * ( 10 * diff ) )
		ChangeHeroStat( HERO_AI_ORC_GUARD, STAT_EXPERIENCE, ( setExpStat / 100 ) * ( 10 * diff ) );
	end
end

function change_owner()
	local enemyBuildings = GetObjectNamesByType( "BUILDING" );
	print( table.length( enemyBuildings ) )
	sleep( 1 );
	for i,eBuilding in enemyBuildings do
		if GetObjectOwner( eBuilding ) == PLAYER_4 then
			SetObjectOwner( eBuilding, PLAYER_NONE );
		end
	end
end

---------------------------------------------------------------------------------------------------
--*-- OBJECT TOUCH trigger - functions related to destroy Inferno Portal objective --*--
-- Function Name: f_destroy_portal_guard_0X()
-- Description: This function destroys crystals when guardian are deafeated.

-- Function Name: f_activate_objective_to_destroy_portal
-- Description: This function activates the quest for to destroy the Infernal portal if the player bumps into the portal dungeon before he conquers the Inferal lair
---------------------------------------------------------------------------------------------------
function f_destroy_portal_guard_01()
	PlayVisualEffect("/Effects/_(Effect)/Spells/LandMineHit.xdb#xpointer(/Effect)", 'PORTAL_GATING_01');-- Animation Effect - Small Explosion
	RemoveObject('PORTAL_GATING_01'); -- Remove Portal Key 01 fire
	RemoveObject('PORTAL_CRYSTAL_01'); -- Remove Portal Key 01 fire
end

function f_destroy_portal_guard_02()
	PlayVisualEffect("/Effects/_(Effect)/Spells/LandMineHit.xdb#xpointer(/Effect)", 'PORTAL_GATING_02');-- Animation Effect - Small Explosion
	RemoveObject('PORTAL_GATING_02'); -- Remove Portal Key 02 fire
	RemoveObject('PORTAL_CRYSTAL_02'); -- Remove Portal Key 02 fire
end

function f_portal_message_01()
	MessageBox("/Maps/Scenario/A2C1M4/messagebox_02.txt"); -- MESSAGEBOX
end

function f_activate_objective_to_destroy_portal(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_OBJECTIVE_DESTROY_PORTAL", nil);
		if OBJECTIVES.state.destroyPortal[2] < 2 then
			OBJECTIVES.state.destroyPortal[2] = 2;
		end
	end
end

---------------------------------------------------------------------------------------------------
--*-- OBJECT TOUCH trigger - starts coversation with Ornella friend Eric the Cavalier about the dungeon passage under the Inferno Garrison. --*--
---------------------------------------------------------------------------------------------------
function f_speak_with_erik_about_the_dungeon_route( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_WIZARD_CHAT", nil);
		SetObjectEnabled("WIZARD_TRAP_STARTER", not nil)
		CINEMATICS.dungeonEntrance( hero );
	end
end

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - Launch Trap deployment of enemy inferno hero in subterrain passage, behind the player's hero. --*--
---------------------------------------------------------------------------------------------------
function f_deploy_enemy_hero_trap(hero)
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_TRAP_SUBTERRAIN", nil);-- Disable Region Enter Trigger - so trap cannot be launched several times
		MoveCamera(97, 51, 1, 30, 1, 5.5, 0, 0, 0); -- MoveCamera there
		sleep(20);
		DeployReserveHero('Nymus', 97, 51, 1); -- DeployReserveHero - location - underground passage not far from Trap Region, so player's hero cannot evade the combat.
		sleep(10);
		PlayVisualEffect("/Effects/_(Effect)/Spells/DimesionDoorEnd.xdb#xpointer(/Effect)", 'Nymus', 0, 0.5); -- PlayVisualEffect on Hero's location - Dimensional Gate Exit
		SetAIHeroAttractor(hero, 'Nymus', 2); -- Set attractor on hero, that entered Trap Region - HIGH.
		H55c_updateArmy('Nymus', diff, H55c_CREATURES.INFERNO );
		H55c_AIAddHero('Nymus');
		startThread( Play2DSound, "/Maps/Scenario/A2C1M4/C1M4_VO9_Arantir_01sound.xdb#xpointer(/Sound)" );
	end
end

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - starts Priest Chat about Flammschrein --*--
---------------------------------------------------------------------------------------------------
function f_speak_with_priest( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_PRIEST_CHAT", nil);
		OBJECTIVES.state.findFlammschrein[2] = 2;
		CINEMATICS.speakWithPriest(hero);
	end
end

---------------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - Warning messagebox appeares when player comes near the first Stronghold town
---------------------------------------------------------------------------------------------------
function f_warning( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		MessageBox("/Maps/Scenario/A2C1M4/messagebox_009.txt");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "REGION_MIGHTY_TOWN_WARNING", nil);
	end
end

------------------------------------------------------------------------------------------
--*-- OBJECT CAPTURE triggers - Notifies the game that the Inferno Lair is captured --*--
------------------------------------------------------------------------------------------
function lairCaptured( oldowner, newowner, heroname, objectname )
	if newowner == PLAYER_1 then
		Trigger(OBJECT_CAPTURE_TRIGGER, "TOWN_INFERNO", nil);
		OBJECTIVES.state.destroyLair[2] = 3;
	end
end

------------------------------------------------------------------------------------------
--*-- REGION ENTER trigger - Start of findOrcLeader and buildFortifications quests --*--
------------------------------------------------------------------------------------------
function f_orc_trap_start( hero )
	if GetObjectOwner( hero ) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "REGION_ORC_TRAP_START", nil );
		BlockGame();
		OBJECTIVES._findOrcLeader_lead = hero;
		OBJECTIVES.state.findOrcLeader[2] = 1;
		OBJECTIVES.state.buildFortifications[2] = 1;
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
	
	intro = function()
		CINEMATICS.playAndWait( 1 );
		startThread(Play2DSound, "/Maps/Scenario/A2C1M4/C1M4_VO2_Arantir_01sound.xdb#xpointer(/Sound)" );
		sleep(2);
	end,
	
	speakWithPriest = function(lead)
		local speaker1 = { name = HERO_PLAYER_MAIN };
		local speaker2 = { name = HERO_PLAYER_SEC };
		if lead == HERO_PLAYER_SEC then
			speaker1.name = HERO_PLAYER_SEC;
			speaker2.name = HERO_PLAYER_MAIN;
		end;
		speaker1.x, speaker1.y, speaker1.z = GetObjectPosition(speaker1.name);
		speaker2.x, speaker2.y, speaker2.z = GetObjectPosition(speaker2.name);
		if lead == speaker1.name or lead == speaker2.name then
			SetObjectPosition( speaker2.name, 22, 113, GROUND );
			sleep( 10 );
			SetObjectRotation( speaker2.name, 0 );	
		else
			SetObjectPosition( speaker1.name, 22, 113, GROUND );
			SetObjectPosition( speaker2.name, 22, 111, GROUND );
			sleep( 10 );
			SetObjectRotation( speaker1.name,  80 );
			SetObjectRotation( speaker2.name, 100 );
		end
		
		CINEMATICS.playAndWait( 0 );
		startThread(CINEMATICS._returnSpeakers, lead, speaker1, speaker2);
	end,
	
	findOrcLeaderIntro = function(lead)
		EnableHeroAI(HERO_AI_ORC_TRAP, not nil);
		MoveHeroRealTime( HERO_AI_ORC_TRAP, 68, 42, GROUND );
		sleep( 35 );
		MessageBox( "/Maps/Scenario/A2C1M4/messagebox_003.txt" ); -- DIALOG SCENE - Orc Hero jumps from the forest and attacks player hero, shouting a battlecry
		EnableHeroAI(HERO_AI_ORC_TRAP, not nil);
		ChangeHeroStat(HERO_AI_ORC_TRAP, STAT_MOVE_POINTS, 3000);
		local lead_x, lead_y, lead_z = GetObjectPosition(lead);
		MoveHeroRealTime(HERO_AI_ORC_TRAP, lead_x, lead_y, lead_z );	
	end,
	
	findOrcLeaderStart = function( lead )
		-- find scene participants and get their current locations
		local speaker1 = { name = HERO_PLAYER_MAIN };
		local speaker2 = { name = HERO_PLAYER_SEC };
		if lead == HERO_PLAYER_SEC then
			speaker1 = { name = HERO_PLAYER_SEC };
			speaker2 = { name = HERO_PLAYER_MAIN };
		end
		local lead_x, lead_y, lead_z = GetObjectPosition(lead);
		speaker1.x, speaker1.y, speaker1.z = GetObjectPosition(speaker1.name);
		speaker2.x, speaker2.y, speaker2.z = GetObjectPosition(speaker2.name);
		-- Move scene participants in dialog view and run the dialog
		if lead == speaker1.name or lead == speaker2.name then
			SetObjectPosition( speaker2.name, lead_x, lead_y + 3, lead_z);
			sleep(10);
			SetObjectRotation( speaker2.name , 0);
		else
			SetObjectPosition( speaker1.name, lead_x - 2, lead_y + 1, lead_z);
			SetObjectPosition( speaker2.name,     lead_x, lead_y + 3, lead_z);
			sleep(10);
			SetObjectRotation(HERO_PLAYER_SEC, 0);
		end
		CINEMATICS.playAndWait( 3 );		
		startThread(CINEMATICS._returnSpeakers, lead, speaker1, speaker2)
	end,
	
	findOrcLeaderFinish = function()
		StartDialogScene("/DialogScenes/A2C1/M4/S1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	dungeonEntrance = function(lead)
		-- find scene participants and get their current locations
		BlockGame();
		local speaker1, speaker2 = {}, {};
		speaker1.name = HERO_PLAYER_MAIN;
		speaker2.name = HERO_PLAYER_SEC;
		if lead == HERO_PLAYER_SEC then
			speaker1.name = HERO_PLAYER_SEC;
			speaker2.name = HERO_PLAYER_MAIN;
		end
		speaker1.x, speaker1.y, speaker1.z = GetObjectPosition(speaker1.name);
		speaker2.x, speaker2.y, speaker2.z = GetObjectPosition(speaker2.name);
		-- Move scene participants in dialog view and run the dialog
		if lead == speaker1.name or lead == speaker2.name then
			SetObjectRotation( speaker2.name, 180 );
			SetObjectPosition( speaker2.name, 68, 66, GROUND );
		else
			SetObjectRotation( speaker1.name, 90 );
			SetObjectPosition( speaker1.name, 67, 68, GROUND );
			SetObjectRotation( speaker2.name, 180 );
			SetObjectPosition( speaker2.name, 68, 66, GROUND );
		end
		sleep(30);
		-- MessageBox("/Maps/Scenario/A2C1M4/messagebox_01.txt"); -- Obsolete message same as the dialog below but told from peasant
		CINEMATICS.playAndWait( 2 );  -- Learn about the Underground passag
		startThread( Play2DSound, "/Maps/Scenario/A2C1M4/C1M4_VO8_Arantir_01sound.xdb#xpointer(/Sound)" );
		OpenCircleFog(8, 10, 0, 5, 1); -- OpenCircleFog
		MoveCamera( 9, 12, GROUND, 60, 3.14/3, 0, 0, 1, 1);
		sleep(100);
		MoveCamera(68, 68, GROUND, 40, 3.14/3, 0, 0, 1, 1);
		UnblockGame();
		startThread(CINEMATICS._returnSpeakers, lead, speaker1, speaker2);
		
	end,
	
	meetKujin = function(lead)
		local speaker = { name='Arantir' }
		speaker.x, speaker.y, speaker.z = GetObjectPosition( speaker.name );
		if lead ~= speaker.name then
			BlockGame();
			local x, y = RegionToPoint( 'REGION_FOR_ARANTIR_TELEPORTING' );
			SetRegionBlocked( 'REGION_FOR_ARANTIR_TELEPORTING', nil );
			SetObjectRotation( speaker.name, 270 );
			SetObjectPosition( speaker.name, x, y, GROUND );
			sleep(10);
			UnblockGame();
		end
		CINEMATICS.playAndWait( 4 );
		startThread(CINEMATICS._returnSpeakers, lead, speaker);
	end,
	
	_returnSpeakers = function(lead, ...)
		for i = 1, arg.n do
			if lead ~= arg[i].name then SetObjectPosition(arg[i].name, arg[i].x, arg[i].y, arg[i].z ); end
		end
	end
}

OBJECTIVES = {
	state = {
		   findFlammschrein = { "OBJECTIVE_PRI_01", 1 },       -- Find route to Flammschrein
					isAlive = { "OBJECTIVE_PRI_02", 1 },       -- Arantir and Ornella Must Survive
			  findOrcLeader = { "OBJECTIVE_PRI_03", 0 },       -- Find Orc Leader and make a deal
				destroyLair = { "OBJECTIVE_PRI_04", 1 },       -- Find a way to destroy the Infernal Lair
		buildFortifications = { "OBJECTIVE_SEC_01", 0 },       -- Build Citadel and Castle defense structures in town
		   captureGoldMines = { "OBJECTIVE_SEC_02", 1 },       -- Capture all 6 gold mines to get additional 10000 gold bonus next mission. If any mine lost - bonus is cancelled until all mines are captured again.
			  destroyPortal = { "OBJECTIVE_SEC_04", 1 },       -- Find and destroy the Demons Portal
				  orcTavern = { "_", 1 }                       -- control hero hiring on/off based on current day and player affiliation with Orcs
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		CINEMATICS.intro();
		SetGameVar("BONUS_A2C1M4", "0");
		startThread( f_artifacts_sets );
		DIFFICULTY[GetDifficulty()]();
		SetObjectEnabled('WIZARD_TRAP_STARTER', nil);
		SetObjectEnabled('CREATURE_HAVEN_PRIEST', nil);
		SetRegionBlocked('REGION_KEEP_AI_AWAY', not nil, PLAYER_2);
		SetRegionBlocked('REGION_KEEP_AI_AWAY', not nil, PLAYER_3);
		SetRegionBlocked('REGION_KEEP_AI_AWAY', not nil, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_ORCS_TO_INF', 1, PLAYER_2);
		SetRegionBlocked('REGION_BLOCK_ORCS_01', 1, PLAYER_2);
		SetRegionBlocked('REGION_BLOCK_ORCS_02', 1, PLAYER_2);
		SetRegionBlocked('REGION_BLOCK_ORCS_03', 1, PLAYER_2);
		SetRegionBlocked('REGION_BLOCK_INF_TO_SUBTER', 1, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_INF_TO_ORCS', 1, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_INF_TO_HAVEN', 1, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_INF_CREATURE', 1, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_INF_TO_STASH', 1, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_INF_TO_SWAMP', 1, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_WIZARD', 1, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_HILL_FORT', 1, PLAYER_4);
		SetRegionBlocked('REGION_AI_BLOCKED_01', 1, PLAYER_4);
		SetRegionBlocked('REGION_AI_BLOCKED_02', 1, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_INF_01', 1, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_INF_02', 1, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_INF_03', 1, PLAYER_4);
		SetRegionBlocked('REGION_FOR_ARANTIR_TELEPORTING', not nil, PLAYER_1);
		SetRegionBlocked('REGION_FOR_ARANTIR_TELEPORTING', not nil, PLAYER_2);
		SetRegionBlocked('REGION_FOR_ARANTIR_TELEPORTING', not nil, PLAYER_3);
		SetRegionBlocked('REGION_FOR_ARANTIR_TELEPORTING', not nil, PLAYER_4);
		SetRegionBlocked('REGION_BLOCK_HAVEN_TO_INF', 1, PLAYER_3);
		SetRegionBlocked('REGION_BLOCK_HAVEN_TO_SUBTER', 1, PLAYER_3);
		--SetRegionBlocked('REGION_BLOCK_HAVEN_TO_NECRO', 1, PLAYER_3);
		SetRegionBlocked('REGION_BLOCK_HAVEN_01', 1, PLAYER_3);
		SetRegionBlocked('REGION_BLOCK_HAVEN_02', 1, PLAYER_3);
		SetRegionBlocked('REGION_BLOCK_HAVEN_03', 1, PLAYER_3);
		SetRegionBlocked('REGION_BLOCK_HAVEN_04', 1, PLAYER_3);
		FinalTownSetUp();
		EnableHeroAI(HERO_AI_ORC_TRAP, nil);
		EnableHeroAI(HERO_AI_ORC_KUJIN, nil);
		EnableHeroAI(HERO_AI_ORC_GUARD, nil);
		EnableAIHeroHiring(PLAYER_2, 'FINAL_ORC_TOWN', nil);
		DenyAIHeroFlee(HERO_PLAYER_MAIN, 1);
		DenyAIHeroFlee(HERO_PLAYER_SEC, 1);
		SetHeroesExpCoef( 0.5 );
		BlockTownGarrisonForAI('TOWN_INFERNO', not nil); -- does not work for QAI
		Trigger( PLAYER_ADD_HERO_TRIGGER, PLAYER_2, "player_2_hero_check" );
		startThread( f_road_block_check );
		Trigger( 	 REGION_ENTER_AND_STOP_TRIGGER, 			 "DIALOG_SCENE_KUJIN", 							'A2C1M4_meetKujin' );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "REGION_OBJECTIVE_DESTROY_PORTAL", 	  'f_activate_objective_to_destroy_portal' );
		Trigger( 			  OBJECT_TOUCH_TRIGGER,					'PORTAL_GUARD_01', 				   'f_destroy_portal_guard_01' );
		Trigger( 			  OBJECT_TOUCH_TRIGGER,					'PORTAL_GUARD_02', 				   'f_destroy_portal_guard_02' );
		Trigger( 	 REGION_ENTER_AND_STOP_TRIGGER,				 "REGION_WIZARD_CHAT", 'f_speak_with_erik_about_the_dungeon_route' );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER,			 "REGION_TRAP_SUBTERRAIN",					'f_deploy_enemy_hero_trap' );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER,					"REGION_AUTOSAVE",								  'f_autosave' );
		Trigger( 	 REGION_ENTER_AND_STOP_TRIGGER,				 "REGION_PRIEST_CHAT",						 'f_speak_with_priest' );
		Trigger( 	 REGION_ENTER_AND_STOP_TRIGGER,		 "REGION_MIGHTY_TOWN_WARNING",								   'f_warning' );
		Trigger( 			OBJECT_CAPTURE_TRIGGER,					   "TOWN_INFERNO",								'lairCaptured' );
		Trigger( 	 REGION_ENTER_AND_STOP_TRIGGER,			  "REGION_ORC_TRAP_START",							'f_orc_trap_start' );
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
			
			if GetObjectiveState("OBJECTIVE_PRI_02") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("OBJECTIVE_PRI_01") == OBJECTIVE_COMPLETED and GetObjectiveState("OBJECTIVE_PRI_03") == OBJECTIVE_COMPLETED and GetObjectiveState("OBJECTIVE_PRI_04") == OBJECTIVE_COMPLETED and GetObjectiveState("OBJECTIVE_SEC_04") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped(      "Arantir", "A2C1M4" );
				SaveHeroAllSetArtifactsEquipped( "OrnellaNecro", "A2C1M4" );
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	findFlammschrein = function()
		-- start of this task is handled by A2C1M4.xdb
		if OBJECTIVES.state.findFlammschrein[2] == 2 then
			SetObjectiveState("OBJECTIVE_PRI_01", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.findFlammschrein[2] = 10;
		end
	end,
	
	isAlive = function()
		-- start of this task is handled by A2C1M4.xdb
		if OBJECTIVES.state.isAlive[2] == 1 and ( IsHeroAlive("OrnellaNecro") == nil or IsHeroAlive("Arantir") == nil ) then
			SetObjectiveState("OBJECTIVE_PRI_02", OBJECTIVE_FAILED, PLAYER_1);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	_findOrcLeader_lead = nil,           									-- the hero that triggered the quest (required to adjust scene participants)
	_findOrcLeader_deployDay = 0,        									-- when will the next hero be deployed
	_findOrcLeader_raider = nil,    										-- current active Stronghold hero
	_findOrcLeader_wave = 0,         										-- current wave of attacking heroes
	findOrcLeader = function()
		if OBJECTIVES.state.findOrcLeader[2] == 1 then
			CINEMATICS.findOrcLeaderIntro(OBJECTIVES._findOrcLeader_lead);
			CINEMATICS.findOrcLeaderStart(OBJECTIVES._findOrcLeader_lead);
			UnblockGame();
			SetObjectiveState("OBJECTIVE_PRI_03", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.findOrcLeader[2] = 2;
		elseif OBJECTIVES.state.findOrcLeader[2] == 2 then
			if GetObjectOwner('FINAL_ORC_TOWN') == PLAYER_1 then
				CINEMATICS.findOrcLeaderFinish();
				SetObjectiveState("OBJECTIVE_PRI_03", OBJECTIVE_COMPLETED);
				OBJECTIVES.state.orcTavern[2] = 3;
				OBJECTIVES.state.findOrcLeader[2] = 10;
			elseif (OBJECTIVES._findOrcLeader_raider == nil or IsHeroAlive( OBJECTIVES._findOrcLeader_raider ) == nil) and OBJECTIVES._findOrcLeader_deployDay < OBJECTIVES.date and OBJECTIVES.state.buildFortifications[2] < 10 then
				--SetAIHeroAttractor( 'PLAYER_TOWN_01', OBJECTIVES._findOrcLeader_raider, 2 ); - this is replaced by H55c pseudo AI
				OBJECTIVES._findOrcLeader_raider = deployOrcRaider( OBJECTIVES._findOrcLeader_wave, OBJECTIVES.date );
				OBJECTIVES._findOrcLeader_wave = OBJECTIVES._findOrcLeader_wave + 1;
				OBJECTIVES._findOrcLeader_deployDay = OBJECTIVES.date + 7;
			end
		end
	end,
	
	orcTavern = function()
		if OBJECTIVES.state.orcTavern[2] == 1 and ChieftainTownTavernActivationDay <= OBJECTIVES.date then	
			EnableAIHeroHiring(PLAYER_2, 'FINAL_ORC_TOWN', not nil);
			OBJECTIVES.state.orcTavern[2] = 2;
		elseif OBJECTIVES.state.orcTavern[2] == 3 then 
			EnableAIHeroHiring(PLAYER_2, 'FINAL_ORC_TOWN', nil);
			OBJECTIVES.state.orcTavern[2] = 10;
		end
	end,
	
	destroyLair = function()
		if OBJECTIVES.state.destroyLair[2] == 1 then
			SetObjectiveState( "OBJECTIVE_PRI_04", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.destroyLair[2] = 2;
		elseif OBJECTIVES.state.destroyLair[2] == 3 then
			RazeTown("TOWN_INFERNO");
			MessageBox("/Maps/Scenario/A2C1M4/messagebox_004.txt"); -- Arantir tortures some Infernals and learns, that Mochab went to Flammschreine.
			startThread( Play2DSound, "/Maps/Scenario/A2C1M4/C1M4_VO5_Arantir_01sound.xdb#xpointer(/Sound)" );
			SetObjectiveState( "OBJECTIVE_PRI_04", OBJECTIVE_COMPLETED );
			if OBJECTIVES.state.destroyPortal[2] < 2 then
				OBJECTIVES.state.destroyPortal[2] = 2;
			elseif OBJECTIVES.state.destroyPortal[2] == 10 then
				change_owner();
			end
			OBJECTIVES.state.destroyLair[2] = 10;
		end
	end,
	
	buildFortifications = function()
		if OBJECTIVES.state.buildFortifications[2] == 1 then
			SetObjectiveState("OBJECTIVE_SEC_01", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.buildFortifications[2] = 2;
		elseif OBJECTIVES.state.buildFortifications[2] == 2 and GetTownBuildingLevel('PLAYER_TOWN_01', TOWN_BUILDING_FORT) >= 3 and GetObjectOwner('PLAYER_TOWN_01') == PLAYER_1 then
			SetObjectiveState("OBJECTIVE_SEC_01", OBJECTIVE_COMPLETED);
			ChangeHeroStat(HERO_PLAYER_MAIN, STAT_EXPERIENCE, 3000);
			MessageBox("/Maps/Scenario/A2C1M4/messagebox_006.txt");
			SetRegionBlocked( "REGION_BLOCK_AI", not nil, PLAYER_2);
			SetRegionBlocked( "REGION_BLOCK_AI", not nil, PLAYER_3);
			if OBJECTIVES._findOrcLeader_raider ~= nil then
				SetAIHeroAttractor( "Arantir", OBJECTIVES._findOrcLeader_raider, 0 );
				H55c_AIRemoveHero( OBJECTIVES._findOrcLeader_raider );
			end
			startThread( Play2DSound, "/Maps/Scenario/A2C1M4/C1M4_VO6_Arantir_01sound.xdb#xpointer(/Sound)" );
			OBJECTIVES.state.buildFortifications[2] = 10;
		end
	end,
	
	_goldMines = { ["GOLD_MINE_01"] = nil, ["GOLD_MINE_02"] = nil, ["GOLD_MINE_03"] = nil, ["GOLD_MINE_04"] = nil, ["GOLD_MINE_05"] = nil, ["GOLD_MINE_06"] = nil },
	captureGoldMines = function()
		-- start of this task is handled by A2C1M1.xdb
		if OBJECTIVES.state.captureGoldMines[2] == 1 then
			OBJECTIVES.state.captureGoldMines[2] = 2;
			SetGameVar("BONUS_A2C1M4", "0");
			for i = 1,6 do
				local owner = GetObjectOwner('GOLD_MINE_0'..i);
				if owner ~= OBJECTIVES._goldMines['GOLD_MINE_0'..i] then
					OBJECTIVES._goldMines['GOLD_MINE_0'..i] = owner;
					if owner == PLAYER_1 then
						SetAIPlayerAttractor('GOLD_MINE_0'..i, PLAYER_2, 2);
					else
						SetAIPlayerAttractor('GOLD_MINE_0'..i, PLAYER_2, 0);
					end
				end
				if owner ~= PLAYER_1 then
					OBJECTIVES.state.captureGoldMines[2] = 1;
				end
			end
		elseif OBJECTIVES.state.captureGoldMines[2] == 2 then
			SetObjectiveState( "OBJECTIVE_SEC_02", OBJECTIVE_COMPLETED );
			SetGameVar("BONUS_A2C1M4", "1");
			MessageBox("/Maps/Scenario/A2C1M4/messagebox_008.txt"); -- MESSAGEBOX - You have captured all gold mines!
			startThread( Play2DSound, "/Maps/Scenario/A2C1M4/C1M4_VO7_Arantir_01sound.xdb#xpointer(/Sound)" );
			OBJECTIVES.state.captureGoldMines[2] = 3;
		elseif OBJECTIVES.state.captureGoldMines[2] == 3 then
			for i = 1,6 do
				if GetObjectOwner('GOLD_MINE_0'..i) ~= PLAYER_1 then
					SetObjectiveState( "OBJECTIVE_SEC_02", OBJECTIVE_ACTIVE );
					OBJECTIVES.state.captureGoldMines[2] = 1;
				end
			end
		end
	end,
	
	_destroyPortal_waveSpawnDay = 4,
	destroyPortal = function()
		if OBJECTIVES.state.destroyPortal[2] == 2 then
			MessageBox("/Maps/Scenario/A2C1M4/messagebox_005.txt"); -- DIALOG SCENE - Arantir learns about the small Portal to Inferno.
			SetObjectiveState("OBJECTIVE_SEC_04", OBJECTIVE_ACTIVE); -- Objective Active - Find Inferno Portal
			OBJECTIVES.state.destroyPortal[2] = 3;
		elseif OBJECTIVES.state.destroyPortal[2] == 3 and IsObjectExists('PORTAL_GUARD_01') == nil and IsObjectExists('PORTAL_GUARD_02') == nil then
			SetObjectiveState("OBJECTIVE_SEC_04", OBJECTIVE_COMPLETED);
			Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
			PlayVisualEffect("/Effects/_(Effect)/Spells/FireBallHit.xdb#xpointer(/Effect)", 'PORTAL_INFERNO', 0, 0.5);-- Animation Effect - Big Explosion
			PlayVisualEffect("/Effects/_(Effect)/Characters/Creatures/Academy/Titan/idle00.xdb#xpointer(/Effect)", 'PORTAL_INFERNO', 0, 0.5);-- Animation Effect - Small Explosion
			sleep(10);
			RemoveObject('PORTAL_FIRE_01'); -- Remove Inferno Fire 01
			RemoveObject('PORTAL_FIRE_02'); -- Remove Inferno Fire 02
			sleep(20);
			Trigger(OBJECT_TOUCH_TRIGGER, 'PORTAL_INFERNO', 'f_portal_message_01'); -- Object Touch Trigger on Inferno Portal - Messagebox function
			startThread( Play2DSound, "/Maps/Scenario/A2C1M4/C1M4_VO4_Arantir_01sound.xdb#xpointer(/Sound)" );
			if OBJECTIVES.state.destroyLair[2] == 10 then
				change_owner();
			end
			OBJECTIVES.state.destroyPortal[2] = 10;
		end
		
		if IsObjectExists('Deleb') == nil and OBJECTIVES._destroyPortal_waveSpawnDay <= OBJECTIVES.date then
			DeployReserveHero('Deleb', 111, 114, 1);
			sleep( 20 );
			H55c_updateArmy('Deleb', 1 + 0.01 * diff * OBJECTIVES.date, H55c_CREATURES.INFERNO );
			startThread( Play2DSound, "/Sounds/_(Sound)/Heroes/Biara/Happy.xdb#xpointer(/Sound)" );
			ChangeHeroStat( 'Deleb', STAT_EXPERIENCE, ( 1000 + OBJECTIVES.date * 100 ) * diff );
			H55c_AIAddHero( 'Deleb' );
			OBJECTIVES._destroyPortal_waveSpawnDay = OBJECTIVES._destroyPortal_waveSpawnDay + 15 - diff;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start )
startThread( H55c_AI_main )
