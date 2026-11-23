doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not H55c_AI_UpdateTargetWeight do
    sleep();
end

H55_PlayerStatus = {0,1,2,2,2,2,2,2};

H55c_AI_CONTROLLED = {
	player1 = {
		state = 0,      	 -- 0 human
		heroes = {},
		enemies = {},
	},

	player2 = { 		     -- Inferno player
		state = 2,
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
		}
	},
}

function SetupTownsAndGarrisons()
	if diff > 1 then
		AddObjectCreatures("InfernoCastle",					CREATURE_IMP,  25);
		AddObjectCreatures("InfernoCastle",		   CREATURE_HORNED_DEMON,  20);

		AddObjectCreatures("WestGarnison",		   CREATURE_HORNED_DEMON, 177 * (diff - 1));
		AddObjectCreatures("WestGarnison",			  CREATURE_ARCHDEVIL,   9 * (diff - 1));
		AddObjectCreatures("WestGarnison",				  CREATURE_BALOR,  18 * (diff - 1));

		AddObjectCreatures("EastGarrison", 	  CREATURE_INFERNAL_SUCCUBUS,  39 * (diff - 1));
		AddObjectCreatures("EastGarrison",		   CREATURE_HORNED_DEMON, 230 * (diff - 1));
		AddObjectCreatures("EastGarrison",				 CREATURE_QUASIT, 160 * (diff - 1));
		AddObjectCreatures("EastGarrison",				CREATURE_CERBERI,  99 * (diff - 1));
	end
	if diff > 2 then
		AddObjectCreatures("InfernoCastle",				CREATURE_CERBERI,  15);
		AddObjectCreatures("InfernoCastle",   CREATURE_INFERNAL_SUCCUBUS,  10);

		AddObjectCreatures("SylvanBorder",			  CREATURE_ARCHDEVIL,   3);
		AddObjectCreatures("SylvanBorder", 	  CREATURE_INFERNAL_SUCCUBUS,  15);
		AddObjectCreatures("SylvanBorder",					CREATURE_IMP,  22);
		AddObjectCreatures("SylvanBorder",				  CREATURE_DEMON,  75);
		AddObjectCreatures("SylvanBorder",			 CREATURE_HELL_HOUND,  20);
	end
	if diff > 3 then
		AddObjectCreatures("InfernoCastle", CREATURE_FRIGHTFUL_NIGHTMARE,   5);
		AddObjectCreatures("InfernoCastle", 			  CREATURE_BALOR,   2);

		AddObjectCreatures("SylvanBorder", 			  CREATURE_ARCHDEVIL,   3);
		AddObjectCreatures("SylvanBorder", 	  CREATURE_INFERNAL_SUCCUBUS,  15);
		AddObjectCreatures("SylvanBorder", 					CREATURE_IMP,  22);
		AddObjectCreatures("SylvanBorder", 				  CREATURE_DEMON,  75);
		AddObjectCreatures("SylvanBorder", 			 CREATURE_HELL_HOUND,  20);
	end
end

DIFFICULTY = {
	[0] = function()
		diff = 1;
		ArmyMult = 0;
		DayOfInvasion = 16;
		if IsObjectExists('Manes') then
			RemoveObject('Manes');
		end
		print("Difficulty level is normal.");
	end,

	[1] = function()
		diff = 2;
		ArmyMult = 0;
		DayOfInvasion = 16;
		if IsObjectExists('Manes') then
			RemoveObject('Manes');
		end
		print("Difficulty level is hard.");
	end,

	[2] = function()
		diff = 3;
		ArmyMult = 1;
		DayOfInvasion = 14;
		print("Difficulty level is heroic.");
	end,

	[3] = function()
		diff = 4;
		ArmyMult = 2;
		DayOfInvasion = 12;
		print("Difficulty level is impossible.");
	end,
}

function ZydarOnTheRescue()
	DeployReserveHero("Zydar", 104, 30, 0);
	sleep(10);
	H55c_AIAddHero("Zydar");
	if diff > 1 then
		GiveHeroSkill("Zydar", SKILL_LEARNING);
		GiveHeroSkill("Zydar", PERK_INTELLIGENCE);
		GiveHeroSkill("Zydar", SKILL_DEFENCE);
		GiveHeroSkill("Zydar", PERK_TOUGHNESS);
		GiveHeroSkill("Zydar", SKILL_OFFENCE);
		GiveHeroSkill("Zydar", PERK_FRENZY);
		GiveExp("Zydar", 85300); --> 20 to 24
		ChangeHeroStat("Zydar", STAT_ATTACK, 3 * (diff-1));
		ChangeHeroStat("Zydar", STAT_DEFENCE, 3 * (diff-1));
		ChangeHeroStat("Zydar", STAT_SPELL_POWER, 3 *(diff-1));
		ChangeHeroStat("Zydar", STAT_KNOWLEDGE, 3 * (diff-1));
		sleep(5); -- required for higher difficulty to recover his mana from additional stats added
		ChangeHeroStat("Zydar", STAT_MANA_POINTS, 200 * (diff-1));
	end
	if diff > 2 then
		GiveExp("Zydar", 176000); --> 24 to 28
	end
	if diff > 3 then
		GiveExp("Zydar", 363000); --> 28 to 32
	end

	local multiplier = (OBJECTIVES.date / 7 + 1) + ArmyMult;
	AddHeroCreatures("Zydar", 			 	  CREATURE_IMP, 17 * multiplier );
	AddHeroCreatures("Zydar", 		 CREATURE_HORNED_DEMON, 15 * multiplier );
	AddHeroCreatures("Zydar",			  CREATURE_CERBERI,  8 * multiplier );
	AddHeroCreatures("Zydar", 	CREATURE_INFERNAL_SUCCUBUS,  5 * multiplier );
	AddHeroCreatures("Zydar", CREATURE_FRIGHTFUL_NIGHTMARE,  3 * multiplier );
	AddHeroCreatures("Zydar", 				CREATURE_BALOR,  2 * multiplier );
	AddHeroCreatures("Zydar", 			CREATURE_ARCHDEVIL,  1 * multiplier );
end

function DemonTakeBow(heroname)
	if heroname == 'Grok' then
		Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'BowPlace', nil);
		sleep(30);
		StartDialogScene("/DialogScenes/Single/SM6/R2/DialogScene.xdb#xpointer(/DialogScene)")
		sleep(10);
		GiveArtefact('Grok', ARTIFACT_UNICORN_HORN_BOW, 1);
		if IsObjectExists('Bow') then
			RemoveObject('Bow');
		end
		MoveHero('Grok', RegionToPoint ('InfernoNearHome'));
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'InfernoNearHome','RoadToInfernoPartTwo');
		local x, y, z = RegionToPoint('InfernoHome');
		OpenCircleFog(x, y, z, 5, PLAYER_1);
		ChangeHeroStat ('Orrin', STAT_EXPERIENCE, 2500);
		if Diff == DIFFICULTY_EASY or Diff == DIFFICULTY_NORMAL then
			startThread(TriggerPlayer);	-- zapusk threada pro zamedlenie
		end
	end
end

function ElvenCity(oldplayer, newplayer, hero)
	if oldplayer == PLAYER_2 and newplayer == PLAYER_1 then
		Trigger(OBJECT_CAPTURE_TRIGGER, 'SylvanBorder', nil);
		MessageBox("/Maps/SingleMissions/SM6/ElvenCitySiegeOver.txt");
		SetObjectOwner('SylvanCastle', PLAYER_1);
		RemoveObject("DemonSiege");
		RemoveObject("DemonSiege1");
		RemoveObject("DemonSiege2");
	end
end

function RoadToInfernoPartTwo(heroname)
	if heroname == 'Grok' then
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'InfernoNearHome', nil)
		SetRegionBlocked('DemonBorder2', nil, PLAYER_2);
		sleep(10);
		MoveHero('Grok', RegionToPoint ('InfernoHome'));
	end
end

function BringBowToInferno(hero)
	if hero == 'Grok' and HasArtefact('Grok', ARTIFACT_UNICORN_HORN_BOW) then
		OBJECTIVES.state.captureDemon[2] = 9;
	end
end

function DefeatAllDemons()
	StartDialogScene("/DialogScenes/Single/SM6/R5/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState('fake_objective', OBJECTIVE_COMPLETED); -- Fake obj needet to show final movie
end

function TriggerPlayer()
	while IsObjectExists('Grok') do
		local CurrentPlayer = GetCurrentPlayer();
		while CurrentPlayer == GetCurrentPlayer() do
			CurrentPlayer = GetCurrentPlayer();
			sleep(1);
		end
		print("Player triggered");
		if CurrentPlayer == PLAYER_1 then
			startThread(HeroSlow);
		end
		sleep(10);
	end
end

function HeroSlow()
	if IsObjectExists('Grok') then
		local MovePoints = GetHeroStat('Grok', STAT_MOVE_POINTS);
		print ('old ', MovePoints);
		local Delta = (MovePoints/4)*(-1);
		print ('delta ', Delta);
		ChangeHeroStat('Grok', STAT_MOVE_POINTS, Delta);
		sleep (10);
		MovePoints = GetHeroStat('Grok', STAT_MOVE_POINTS);
		print ('new ', MovePoints);
	end
end

function DemonHalfArmy(heroname)
	for index, creature in H55c_CREATURES.INFERNO do
		local count = GetHeroCreatures(heroname, creature) / 2;
		if count > 0 then
			RemoveHeroCreatures(heroname, creature, count);
		end
	end
 end

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/Single/SM6/R1/DialogScene.xdb#xpointer(/DialogScene)")
		sleep(2);
	end,

	demonReachBow = function()
		BlockGame();
		local x, y, z = RegionToPoint('BowPlace');
		OpenCircleFog(x, y, z, 9, PLAYER_1);
		MoveCamera(x, y, z, 50, 3.14/4, 0);
		x, y, z = RegionToPoint('PortalCenter');
		OpenCircleFog(x, y, z, 3, PLAYER_1);
		sleep(60);
		MoveHeroRealTime ('Grok', RegionToPoint('BowPlace'));
		sleep(80);
		UnblockGame();
	end,

	defeatDemon = function()
		StartDialogScene("/DialogScenes/Single/SM6/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,

	demonEscape = function()
		StartDialogScene("/DialogScenes/Single/SM6/R4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
}

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "IsGrokDead" );

whydie = nil;
function IsGrokDead(looser, winner)
	if looser == "Grok" and OBJECTIVES.state.captureDemon[2] == 2 then
		whydie = winner;
		OBJECTIVES.state.captureDemon[2] = 3;
	end
end

respawn_counter = 0
function wakeup(hero)
	respawn_counter = respawn_counter + 1;
	GiveExp(hero, (( 5000 * respawn_counter) * diff));
	if diff > 1 then
		AddHeroCreatures(hero,				  CREATURE_IMP,  25);
		AddHeroCreatures(hero,		 CREATURE_HORNED_DEMON,  20);
	end
	if diff > 2 then
		AddHeroCreatures(hero,			   CREATURE_CERBERI, 15);
		AddHeroCreatures(hero,   CREATURE_INFERNAL_SUCCUBUS, 10);
	end
	if diff > 3 then
		AddHeroCreatures(hero, CREATURE_FRIGHTFUL_NIGHTMARE,  5);
		AddHeroCreatures(hero,				 CREATURE_BALOR,  2);
	end
end

OBJECTIVES = {
	state = {
		  seizeBrigands 	= { "prim1", 0 }, 	-- Capture brigands town
		  captureDemon 		= { "prim2", 1 }, 	-- Intercept the demon who stole the bow
		  captureUlJubaal	= { "prim3", 1 },   -- monitor garnison defeat
		  isAlive			= { "prim4", 0 },
		  eventManager 		= { 	"_", 1 }, 	-- Gather all northern clàns
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		H55c_SetCampaignResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 10000);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'InfernoHome', 'BringBowToInferno');
		Trigger(OBJECT_CAPTURE_TRIGGER, 'SylvanBorder', 'ElvenCity');
		DIFFICULTY[GetDifficulty()]();
		CINEMATICS.intro();
		SetupTownsAndGarrisons();
		DeployReserveHero("Calh", 111, 20, 0);
		SetPlayerHeroesCountNotForHire(PLAYER_2, 5);
		SetRegionBlocked('DemonBorder1', not nil, PLAYER_2);
		SetRegionBlocked('DemonBorder2', not nil, PLAYER_2);
		SetRegionBlocked('ElfDwelling', not nil, PLAYER_2); -- ne dadim demonu nanimat elfov
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'BowPlace', 'DemonTakeBow');
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

			if GetObjectiveState('prim2') == OBJECTIVE_FAILED then
				Loose();
				return
			end

			-- Win() is handled by map.xdb
		end
	end,

	seizeBrigands = function()
	-- task lifecycle is handled by map.xdb
	end,

	captureDemon = function()
		if OBJECTIVES.state.captureDemon[2] == 1 and GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
			SetObjectiveState('prim2', OBJECTIVE_ACTIVE);
			DeployReserveHero('Grok', RegionToPoint('Portal'));
			if IsObjectExists('SukBarrier') then RemoveObject('SukBarrier'); end
			if IsObjectExists('DemonBarrier') then RemoveObject('DemonBarrier'); end
			if IsObjectExists('Druids') then RemoveObject('Druids'); end
			sleep(10);
			EnableHeroAI('Grok', not nil);
			if ArmyMult > 0 then
				AddHeroCreatures('Grok', CREATURE_PIT_FIEND, 1*ArmyMult); --- PIT FIENDS
				AddHeroCreatures('Grok', CREATURE_CERBERI, 4*ArmyMult); --- CERBERI
				AddHeroCreatures('Grok', CREATURE_NIGHTMARE, 2*ArmyMult); --- HELL CHARGERS
				AddHeroCreatures('Grok', CREATURE_HORNED_DEMON, 16*ArmyMult); --- HORNED DEMONS
			end
			if Diff == DIFFICULTY_EASY then -- na urovne slojnosti EASY ubiraem polovinu voysk Groka
				DemonHalfArmy ('Grok');
			end
			CINEMATICS.demonReachBow();
			OBJECTIVES.state.captureDemon[2] = 2;
		elseif OBJECTIVES.state.captureDemon[2] == 3 then
			print ('Grok was killed by ', whydie);
			if whydie == nil then
				MessageBox ("/Maps/SingleMissions/SM6/GrockIsDead.txt");
				GiveArtefact('Orrin', ARTIFACT_UNICORN_HORN_BOW, not nil);
			else
				ChangeHeroStat('Orrin', STAT_EXPERIENCE, 3500);
			end

			CINEMATICS.defeatDemon();
			SetObjectiveState('prim2', OBJECTIVE_COMPLETED);
			SetObjectiveState('prim3', OBJECTIVE_ACTIVE);
			SetObjectiveState('fake_objective', OBJECTIVE_ACTIVE); -- Fake obj needet to show final movie
			Trigger (OBJECTIVE_STATE_CHANGE_TRIGGER, 'prim3', 'DefeatAllDemons');
			OBJECTIVES.state.captureDemon[2] = 10;
		elseif OBJECTIVES.state.captureDemon[2] == 9 then
			CINEMATICS.demonEscape();
			SetObjectiveState("prim2", OBJECTIVE_FAILED);
			OBJECTIVES.state.captureDemon[2] = 11;
		end
	end,

	isAlive = function()
	-- task lifecycle is handled by map.xdb
	end,

	captureUlJubaal = function()
	-- task is started by captureDemon and finish is handled by map.xdb
		if OBJECTIVES.state.captureUlJubaal[2] == 1 and (GetObjectOwner("WestGarnison") == PLAYER_1 or GetObjectOwner("EastGarrison") == PLAYER_1) then
			ZydarOnTheRescue(diff);
			OBJECTIVES.state.captureUlJubaal[2] = 10;
		end
	end,

	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date > OBJECTIVES.eventManager_day then
			if OBJECTIVES.date >= DayOfInvasion then
				MessageBox ("/Maps/SingleMissions/SM6/ElvenCitySiege.txt");
				local x, y, z = RegionToPoint('ElvenCityCenter');
				OpenCircleFog(x, y, z, 7, PLAYER_1);
				SetRegionBlocked('DemonBorder1', nil, PLAYER_2);
				SetRegionBlocked('DemonBorder2', nil, PLAYER_2);
				DayOfInvasion = 9999999;
			end

			if GetObjectOwner("InfernoCastle") == PLAYER_2 and IsHeroAlive("Calh") == nil then
				DeployReserveHero("Calh", 111, 20, 0);
				sleep(10);
				wakeup("Calh");
			end

			if OBJECTIVES.date > 28 and GetDate(DAY_OF_WEEK) == 1 and IsHeroAlive("Calh") then
				GiveExp("Calh", 1000 * diff);
			end

			OBJECTIVES.eventManager_day = OBJECTIVES.date;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start )
startThread( H55c_AI_main );

function sm6_dbg(var)
	if var == 1 then
		H55_Speedrun(1);
		SetObjectPosition("Orrin", 42, 42);
	elseif var == 2 then
		MakeHeroInteractWithObject("Orrin", "Grok");
	elseif var == 3  then
		MakeHeroInteractWithObject("Orrin", "SylvanBorder");
	end
end