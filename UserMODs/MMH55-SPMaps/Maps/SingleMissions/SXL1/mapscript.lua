doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep();
end

H55_PlayerStatus = {0,1,1,1,1,2,2,2};

function watchThroughObservatory()
	Trigger(OBJECT_TOUCH_TRIGGER, "observer", nil);
	if OBJECTIVES.state.findNecklace[2] == 1 then
		StartDialogScene("/DialogScenes/Single/SXL1/R5/DialogScene.xdb#xpointer(/DialogScene)");
	elseif OBJECTIVES.state.captureThief[2] == 1 then
		StartDialogScene("/DialogScenes/Single/SXL1/R4/DialogScene.xdb#xpointer(/DialogScene)");
	end
	OpenCircleFog(142, 139, GROUND, 14, PLAYER_1);
	MoveCamera(142, 139, GROUND, 40, 3.14/3, 0, 1, 1, 1);
end

function visitOracle(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", nil);
		OBJECTIVES.state.visitOracle[2] = 3;
	end
end

function bringGoldToOracle(hero)
	if GetObjectOwner(hero) == PLAYER_1 and GetPlayerResource(PLAYER_1, GOLD) >= 50000 then
		Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", nil);
		OBJECTIVES.state.collectGold[2] = 3;
	end
end

function returnToOracleWithNecklace(hero)
	if GetObjectOwner(hero) == PLAYER_1 and HasArtefact(hero, ARTIFACT_DRAGON_TEETH_NECKLACE) then
		Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", nil);
		OBJECTIVES.state.findNecklace[2] = 3;
	end
end

function returnToOracleWithGems(hero)
	if GetObjectOwner(hero) == PLAYER_1 and GetPlayerResource(PLAYER_1, GEM) >= 100 then
		Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", nil);
		OBJECTIVES.state.get100Gems[2] = 3;
	end
end

function meetKeyMaster(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger(OBJECT_TOUCH_TRIGGER, "key_tent", nil);
		OBJECTIVES.state.getSwordsman[2] = 1;
	end
end

function get100SwordsmanToKeymaster(hero)	
	if GetObjectOwner(hero) == PLAYER_1 and GetHeroCreatures(hero, CREATURE_FOOTMAN) >= 100 then
		Trigger(OBJECT_TOUCH_TRIGGER, "key_tent", nil);
		RemoveHeroCreatures(hero, CREATURE_FOOTMAN, 100);
		OBJECTIVES.state.getSwordsman[2] = 3;
	end
end

function enterThiefUnderground()
	local he = GetPlayerHeroes(PLAYER_1)
	for i, hero in he do
		if IsObjectInRegion( hero, "underground" ) then
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "underground", nil);
			OBJECTIVES.state.learnFlySpell[2] = 1;
			return
		end
	end
end

function meetDragons(hero)
	if GetObjectOwner(hero) ~= PLAYER_1 then
		return
	end
	if OBJECTIVES.state.necklaceToDragons[2] > 1 and HasArtefact(hero, ARTIFACT_DRAGON_TEETH_NECKLACE) ~= nil then
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "dragon_guardian", nil);
		OBJECTIVES.state.necklaceToDragons[2] = 3;
	else
		MessageBox("/Maps/SingleMissions/SXL1/dragon_answer.txt");
	end
end

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	meetOracle = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	meetKeyMaster = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R6/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	bringSwordsmanToKeyMaster = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R7/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	getNecklaceInfo = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	beginThiefChase = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R8/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	enterThiefUnderground = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R9/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	naadirLearnsFly = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R10/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	captureThief = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R11/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	oracleAskFor100Gems = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R12/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	oracleSendYouToDragons = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R13/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	meetDragons = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R14/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	dragonsDefeated = function()
		StartDialogScene("/DialogScenes/Single/SXL1/R15/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
}

OBJECTIVES = {
	state = {
		winDragonsFavour  = {   "obj1", 1 },	-- find a way to win the favour of the dragons
		visitOracle		  = { "st_obj", 1 },	-- talk to the oracle
		collectGold		  = {   "obj2", 1 },	-- bring oracle 50000 gold
		findNecklace	  = {	"obj3", 1 },	-- bring oracle Dragonteeth Necklace
		getSwordsman	  = {	"obj4", 0 },	-- deliver 100 swordsman to the Key Master
		captureThief	  = {	"obj5", 1 },	-- Catch the Thief that stole the necklace
		learnFlySpell	  = {	"obj6", 0 },	-- Learn Instant Travel spell
		get100Gems		  = {	"obj7", 1 },	-- bring oracle 100 gems
		necklaceToDragons = {	"obj8", 1 },	-- take the Dragonteeth Necklace to the dragons
		beatDragons		  = {	"obj9", 1 },	-- take the Dragonteeth Necklace to the dragons
		isAlive			  = {  "n_obj", 1 },	-- Naadir must survive
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		CINEMATICS.intro();
		SetObjectEnabled("portal", nil);
		SetObjectEnabled("observer", nil);
		SetObjectEnabled("seer_hut", nil);
		SetObjectEnabled("key_tent", nil);
		SetObjectEnabled("dragon_guardian", nil);
		SetRegionBlocked("special_for_akimovs_cheat", not nil, PLAYER_1);
		Trigger( OBJECT_TOUCH_TRIGGER, "observer", "watchThroughObservatory" );
		Trigger( OBJECT_TOUCH_TRIGGER, "seer_hut", "visitOracle" );
		Trigger( OBJECT_TOUCH_TRIGGER, "key_tent", "meetKeyMaster" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "underground", "enterThiefUnderground" );
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "dragon_guardian", "meetDragons");
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
			
			if GetObjectiveState('n_obj') == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState('obj9', PLAYER_1) == OBJECTIVE_COMPLETED then 
				sleep(100);
				Win(PLAYER_1);
				return
			end
		end
	end,
	
	winDragonsFavour = function()
		if OBJECTIVES.state.winDragonsFavour[2] == 1 then
			SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.winDragonsFavour[2] = 2;
		elseif OBJECTIVES.state.winDragonsFavour[2] == 2 and OBJECTIVES.state.necklaceToDragons[2] == 10 then
			SetObjectiveState("obj1", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.winDragonsFavour[2] = 10;
		end
	end,
	
	visitOracle = function()
		if OBJECTIVES.state.visitOracle[2] == 1 then
			SetObjectiveState("st_obj", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.visitOracle[2] = 2;
		elseif OBJECTIVES.state.visitOracle[2] == 3 then
			CINEMATICS.meetOracle();
			Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", "bringGoldToOracle");
			SetPlayerResource(PLAYER_1, ORE, GetPlayerResource(PLAYER_1, ORE) + 5)
			SetObjectiveState("st_obj", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.visitOracle[2] = 10;
		end
	end,
	
	collectGold = function()
		if OBJECTIVES.state.collectGold[2] == 1 and OBJECTIVES.state.visitOracle[2] == 10 then
			SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.collectGold[2] = 2;
		elseif OBJECTIVES.state.collectGold[2] == 3 then
			SetPlayerResource(PLAYER_1, GOLD,  GetPlayerResource(PLAYER_1, GOLD) - 50000);
			SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
			LevelUpHero("Muscip");
			sleep(20);
			CINEMATICS.getNecklaceInfo();
			OBJECTIVES.state.collectGold[2] = 10;
		end
	end,
	
	findNecklace = function()
		if OBJECTIVES.state.findNecklace[2] == 1 and OBJECTIVES.state.collectGold[2] == 10 then
			SetObjectiveState("obj3", OBJECTIVE_ACTIVE);
			Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", "returnToOracleWithNecklace");
			OBJECTIVES.state.findNecklace[2] = 2;
		elseif OBJECTIVES.state.findNecklace[2] == 3 then
			SetObjectiveState("obj3", OBJECTIVE_COMPLETED);
			SetPlayerResource(PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) + 10000)
			CINEMATICS.oracleAskFor100Gems();
			OBJECTIVES.state.findNecklace[2] = 10;
		end
	end,
	
	getSwordsman = function()
		if OBJECTIVES.state.getSwordsman[2] == 1 then
			CINEMATICS.meetKeyMaster();
			SetObjectiveState("obj4", OBJECTIVE_ACTIVE);
			Trigger(OBJECT_TOUCH_TRIGGER, "key_tent", "get100SwordsmanToKeymaster");
			OBJECTIVES.state.getSwordsman[2] = 2;
		elseif OBJECTIVES.state.getSwordsman[2] == 3 then
			CINEMATICS.bringSwordsmanToKeyMaster();
			SetObjectiveState("obj4", OBJECTIVE_COMPLETED);
			SetPlayerResource(PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) + 3000)
			GiveBorderguardKey(PLAYER_1, RED_KEY);
			OBJECTIVES.state.getSwordsman[2] = 10;
		end
	end,
	
	captureThief = function()
		if OBJECTIVES.state.captureThief[2] == 1 and IsObjectExists("bg") == nil then
			BlockGame();
			OpenCircleFog(142, 139, GROUND, 14, PLAYER_1);
			EnableHeroAI("Almegir", not nil);
			SetObjectPos("Almegir", 145, 146, GROUND);
			ChangeHeroStat("Almegir", STAT_MOVE_POINTS, 5000);
			sleep(20);
			MoveCamera(142, 139, GROUND,50, 3.14/3, 0);
			sleep(100);
			MoveHeroRealTime("Almegir", 142, 139, GROUND);
			local len = 100; 
			while len > 1 do
				local x, y = GetObjectPos( "Almegir" );
				len = math.sqrt( (x - 142) * (x - 142) + (y - 139) * (y - 139) );
				print( "len = ", len);
				sleep( 1 );
			end
			ChangeHeroStat("Almegir", STAT_MOVE_POINTS, 5000);
			RemoveObject("necklace");
			MoveHeroRealTime("Almegir", 145, 146, GROUND);
			len = 100;
			while len > 1 do
				local x, y = GetObjectPos( "Almegir" );
				len = math.sqrt( (x - 145) * (x - 145) + (y - 146) * (y - 146) );
				print( "len = ", len);
				sleep( 1 );
			end
			EnableHeroAI("Almegir", nil);
			SetObjectPos("Almegir", 65, 51, UNDERGROUND);
			UnblockGame();
			CINEMATICS.beginThiefChase();
			SetObjectiveState("obj5", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.captureThief[2] = 2;
		elseif OBJECTIVES.state.captureThief[2] == 2 and IsHeroAlive("Almegir") == nil then
			SetObjectiveState("obj5", OBJECTIVE_COMPLETED);
			GiveArtefact("Muscip", ARTIFACT_DRAGON_TEETH_NECKLACE, 1);
			CINEMATICS.captureThief();
			OBJECTIVES.state.captureThief[2] = 10;
		end
	end,
	
	learnFlySpell = function()
		if OBJECTIVES.state.learnFlySpell[2] == 1 then
			CINEMATICS.enterThiefUnderground();
			SetObjectiveState("obj6", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.learnFlySpell[2] = 2
		elseif OBJECTIVES.state.learnFlySpell[2] == 2 and KnowHeroSpell("Muscip", SPELL_DIMENSION_DOOR) ~= nil then
			CINEMATICS.naadirLearnsFly();
			SetObjectiveState("obj6", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.learnFlySpell[2] = 10;
		end
	end,
	
	get100Gems = function()
		if OBJECTIVES.state.get100Gems[2] == 1 and OBJECTIVES.state.findNecklace[2] == 10 then
			SetObjectiveState("obj7", OBJECTIVE_ACTIVE);
			Trigger(OBJECT_TOUCH_TRIGGER, "seer_hut", "returnToOracleWithGems");
			OBJECTIVES.state.get100Gems[2] = 2;
		elseif OBJECTIVES.state.get100Gems[2] == 3 then
			SetObjectiveState("obj7", OBJECTIVE_COMPLETED);
			SetPlayerResource(PLAYER_1, GEM, GetPlayerResource(PLAYER_1, GEM) - 100)
			LevelUpHero("Muscip");
			OBJECTIVES.state.get100Gems[2] = 10;
		end
	end,
	
	necklaceToDragons = function()
		if OBJECTIVES.state.necklaceToDragons[2] == 1 and OBJECTIVES.state.get100Gems[2] == 10 then
			CINEMATICS.oracleSendYouToDragons();
			SetObjectiveState("obj8", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.necklaceToDragons[2] = 2;
		elseif OBJECTIVES.state.necklaceToDragons[2] == 3 then
			SetRegionBlocked("special_for_akimovs_cheat", nil, PLAYER_1);
			CINEMATICS.meetDragons();
			RemoveObject("dragon_guardian");
			SetObjectiveState("obj8", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.necklaceToDragons[2] = 10;
		end
	end,
	
	beatDragons = function()
		if OBJECTIVES.state.beatDragons[2] == 1 and OBJECTIVES.state.necklaceToDragons[2] == 10 then
			SetObjectiveState("obj9", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.beatDragons[2] = 2;
		elseif OBJECTIVES.state.beatDragons[2] == 2 and IsObjectExists("guards") == nil then
			CINEMATICS.dragonsDefeated();
			SetObjectiveState("obj9", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.beatDragons[2] = 10;
		end
	end,

	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Muscip") == nil then
			SetObjectiveState("n_obj", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start);
