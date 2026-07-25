doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep();
end

H55_PlayerStatus = {0,1,2,2,2,2,2,2};

DIFFICULTY = {
	[0] = function()
		ArmyMult = 0;
		DayOfInvasion = 16;
		if IsObjectExists('Manes') then RemoveObject('Manes'); end
		print("Difficulty level is normal.");
	end,
	
	[1] = function()
		ArmyMult = 0;
		DayOfInvasion = 16;
		if IsObjectExists('Manes') then RemoveObject('Manes'); end
		print("Difficulty level is hard.");
	end,
	
	[2] = function()
		ArmyMult = 1;
		DayOfInvasion = 14;
		print("Difficulty level is heroic.");
	end,
	
	[3] = function()
		ArmyMult = 2;
		DayOfInvasion = 12;
		print("Difficulty level is impossible.");
	end,
}

Diff = GetDifficulty ();

function DemonTakeBow(heroname)
	if heroname == 'Grok' then
		Trigger (REGION_ENTER_AND_STOP_TRIGGER, 'BowPlace', nil);
		sleep(30);	
		StartDialogScene("/DialogScenes/Single/SM6/R2/DialogScene.xdb#xpointer(/DialogScene)")
		sleep(10);
		GiveArtefact('Grok', ARTIFACT_UNICORN_HORN_BOW, not nil);
		if IsObjectExists('Bow') then RemoveObject('Bow'); end
		MoveHero('Grok', RegionToPoint ('InfernoNearHome'));
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'InfernoNearHome','RoadToInfernoPartTwo');
		local x, y, z = RegionToPoint('InfernoHome');
		OpenCircleFog(x, y, z, 5, PLAYER_1);
		ChangeHeroStat ('Orrin', STAT_EXPERIENCE, 2500);	
		if Diff == DIFFICULTY_EASY or Diff == DIFFICULTY_NORMAL then startThread(TriggerPlayer); end; -- zapusk threada pro zamedlenie
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

OBJECTIVES = {
	state = {
		  seizeBrigands 	= { "prim1", 0 }, 	-- Capture brigands town
		  captureDemon 		= { "prim2", 1 }, 	-- Intercept the demon who stole the bow
		  captureUlJubaal	= { "prim3", 0 },
		  isAlive			= { "prim4", 0 },
		  eventManager 		= { 	"_", 1 }, 	-- Gather all northern clàns
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 10000);
		Trigger (REGION_ENTER_WITHOUT_STOP_TRIGGER, 'InfernoHome', 'BringBowToInferno');
		Trigger (OBJECT_CAPTURE_TRIGGER, 'SylvanBorder', 'ElvenCity');
		DIFFICULTY[GetDifficulty()]();
		CINEMATICS.intro();
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
					if pcall(OBJECTIVES[key]) == nil then print(key) end;
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
			if IsObjectExists('SukBarrier') then RemoveObject('SukBarrier'); end;
			if IsObjectExists('DemonBarrier') then RemoveObject('DemonBarrier'); end;
			if IsObjectExists('Druids') then RemoveObject('Druids'); end;
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
		elseif OBJECTIVES.state.captureDemon[2] == 2 and IsHeroAlive('Grok') == nil then
			if IsObjectExists ('Bow') == not nil then
				MessageBox ("/Maps/SingleMissions/SM6/GrockIsDead.txt");
				print ('GRok died without bow');
				RemoveObject('Bow');
				GiveArtefact('Orrin', ARTIFACT_UNICORN_HORN_BOW, not nil );		
			elseif whydie == nil then
				print ('Grok was killed by mobs');
				MessageBox ("/Maps/SingleMissions/SM6/GrockIsDead.txt");
				GiveArtefact('Orrin', ARTIFACT_UNICORN_HORN_BOW,not nil);	
			elseif whydie == 'Orrin' then
				print ('Grok was killed by Orrin');
				ChangeHeroStat ('Orrin', STAT_EXPERIENCE, 3500);
			else 
				print ('Grok was killed by other hero ', whydie);
				RemoveArtefact(whydie, ARTIFACT_UNICORN_HORN_BOW,not nil);	
				GiveArtefact('Orrin', ARTIFACT_UNICORN_HORN_BOW,not nil);	
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
	end,
	
	eventManager_day = 1,
	eventManager = function()
		if OBJECTIVES.date >= OBJECTIVES.eventManager_day and OBJECTIVES.date >= DayOfInvasion then
			MessageBox ("/Maps/SingleMissions/SM6/ElvenCitySiege.txt");
			local x, y, z = RegionToPoint('ElvenCityCenter');
			OpenCircleFog(x, y, z, 7, PLAYER_1);
			SetRegionBlocked('DemonBorder1', nil, PLAYER_2);
			SetRegionBlocked('DemonBorder2', nil, PLAYER_2);
			OBJECTIVES.state.eventManager[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start )

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