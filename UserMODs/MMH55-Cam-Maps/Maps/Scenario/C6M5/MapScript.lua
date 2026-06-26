H55_PlayerStatus = {0,1,2,2,2,2,2,2};
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C6M5");
	LoadHeroAllSetArtifacts( "Godric", "C6M4" );
	LoadHeroAllSetArtifacts( "Raelag", "C6M4" );
	LoadHeroAllSetArtifacts(   "Heam", "C6M4" );
    LoadHeroAllSetArtifacts(  "Zehir", "C6M4" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1,  "Zehir" );
	H55_CamFixTooManySkills( PLAYER_1, "Godric" );
	H55_CamFixTooManySkills( PLAYER_1,   "Heam" );
	H55_CamFixTooManySkills( PLAYER_1, "Raelag" );
end;

startThread(H55_InitSetArtifacts);

DIFFICULTY = {
	[0] = function()
		d = 1;
		print ("normal");
		AddHeroCreatures("Godric", CREATURE_MILITIAMAN, 100);
		AddHeroCreatures("Godric", CREATURE_MARKSMAN, 100);
		AddHeroCreatures("Godric", CREATURE_SWORDSMAN, 80);
		AddHeroCreatures("Godric", CREATURE_ROYAL_GRIFFIN, 40);
		AddHeroCreatures("Godric", CREATURE_CLERIC, 20);
		AddHeroCreatures("Godric", CREATURE_PALADIN, 20);
		AddHeroCreatures("Godric", CREATURE_ARCHANGEL, 10);
		AddHeroCreatures("Heam", CREATURE_SPRITE, 80);
		AddHeroCreatures("Heam", CREATURE_WAR_DANCER, 80);
		AddHeroCreatures("Heam", CREATURE_GRAND_ELF, 60);
		AddHeroCreatures("Heam", CREATURE_DRUID_ELDER, 40);
		AddHeroCreatures("Heam", CREATURE_WAR_UNICORN, 20);
	    AddHeroCreatures("Heam", CREATURE_TREANT_GUARDIAN, 16);
		AddHeroCreatures("Heam", CREATURE_GOLD_DRAGON, 8);
		AddHeroCreatures("Raelag", CREATURE_ASSASSIN, 80);
		AddHeroCreatures("Raelag", CREATURE_BLOOD_WITCH, 80);
		AddHeroCreatures("Raelag", CREATURE_MINOTAUR_KING, 60);
		AddHeroCreatures("Raelag", CREATURE_RAVAGER, 40);
		AddHeroCreatures("Raelag", CREATURE_CHAOS_HYDRA, 20);
		AddHeroCreatures("Raelag", CREATURE_MATRIARCH, 16);
		AddHeroCreatures("Raelag", CREATURE_BLACK_DRAGON, 8);
		AddHeroCreatures("Zehir", CREATURE_MASTER_GREMLIN, 100);
		AddHeroCreatures("Zehir", CREATURE_OBSIDIAN_GARGOYLE, 100);
		AddHeroCreatures("Zehir", CREATURE_STEEL_GOLEM, 80);
		AddHeroCreatures("Zehir", CREATURE_ARCH_MAGI, 40);
		AddHeroCreatures("Zehir", CREATURE_MASTER_GENIE, 20);
		AddHeroCreatures("Zehir", CREATURE_RAKSHASA_RUKH, 20);
		AddHeroCreatures("Zehir", CREATURE_TITAN, 10);
	end,

	[1] = function()
		d = 2;
		print ("hard");
		AddHeroCreatures("Godric", CREATURE_MILITIAMAN, 50);
		AddHeroCreatures("Godric", CREATURE_MARKSMAN, 50);
		AddHeroCreatures("Godric", CREATURE_SWORDSMAN, 40);
		AddHeroCreatures("Godric", CREATURE_ROYAL_GRIFFIN, 20);
		AddHeroCreatures("Godric", CREATURE_CLERIC, 15);
		AddHeroCreatures("Godric", CREATURE_PALADIN, 10);
		AddHeroCreatures("Godric", CREATURE_ARCHANGEL, 9);
		AddHeroCreatures("Heam", CREATURE_SPRITE, 40);
		AddHeroCreatures("Heam", CREATURE_WAR_DANCER, 40);
		AddHeroCreatures("Heam", CREATURE_GRAND_ELF, 30);
		AddHeroCreatures("Heam", CREATURE_DRUID_ELDER, 20);
		AddHeroCreatures("Heam", CREATURE_WAR_UNICORN, 15);
	    AddHeroCreatures("Heam", CREATURE_TREANT_GUARDIAN, 20);
		AddHeroCreatures("Heam", CREATURE_GOLD_DRAGON, 5);
		AddHeroCreatures("Raelag", CREATURE_ASSASSIN, 50);
		AddHeroCreatures("Raelag", CREATURE_BLOOD_WITCH, 50);
		AddHeroCreatures("Raelag", CREATURE_MINOTAUR_KING, 40);
		AddHeroCreatures("Raelag", CREATURE_RAVAGER, 20);
		AddHeroCreatures("Raelag", CREATURE_CHAOS_HYDRA, 15);
		AddHeroCreatures("Raelag", CREATURE_MATRIARCH, 10);
		AddHeroCreatures("Raelag", CREATURE_BLACK_DRAGON, 4);
		AddHeroCreatures("Zehir", CREATURE_MASTER_GREMLIN, 50);
		AddHeroCreatures("Zehir", CREATURE_OBSIDIAN_GARGOYLE, 50);
		AddHeroCreatures("Zehir", CREATURE_STEEL_GOLEM, 40);
		AddHeroCreatures("Zehir", CREATURE_ARCH_MAGI, 20);
		AddHeroCreatures("Zehir", CREATURE_MASTER_GENIE, 15);
		AddHeroCreatures("Zehir", CREATURE_RAKSHASA_RUKH, 15);
		AddHeroCreatures("Zehir", CREATURE_TITAN, 9);
	end,

	[2] = function()
		d = 3;
		print ("heroic");
		AddHeroCreatures("Godric", CREATURE_MILITIAMAN, 25);
		AddHeroCreatures("Godric", CREATURE_MARKSMAN, 25);
		AddHeroCreatures("Godric", CREATURE_SWORDSMAN, 20);
		AddHeroCreatures("Godric", CREATURE_ROYAL_GRIFFIN, 10);
		AddHeroCreatures("Godric", CREATURE_CLERIC, 15);
		AddHeroCreatures("Godric", CREATURE_PALADIN, 10);
		AddHeroCreatures("Godric", CREATURE_ARCHANGEL, 7);
		AddHeroCreatures("Heam", CREATURE_SPRITE, 20);
		AddHeroCreatures("Heam", CREATURE_WAR_DANCER, 20);
		AddHeroCreatures("Heam", CREATURE_GRAND_ELF, 15);
		AddHeroCreatures("Heam", CREATURE_DRUID_ELDER, 10);
		AddHeroCreatures("Heam", CREATURE_WAR_UNICORN, 10);
	    AddHeroCreatures("Heam", CREATURE_TREANT_GUARDIAN, 10);
		AddHeroCreatures("Heam", CREATURE_GOLD_DRAGON, 3);
		AddHeroCreatures("Raelag", CREATURE_ASSASSIN, 25);
		AddHeroCreatures("Raelag", CREATURE_BLOOD_WITCH, 25);
		AddHeroCreatures("Raelag", CREATURE_MINOTAUR_KING, 20);
		AddHeroCreatures("Raelag", CREATURE_RAVAGER, 10);
		AddHeroCreatures("Raelag", CREATURE_CHAOS_HYDRA, 10);
		AddHeroCreatures("Raelag", CREATURE_MATRIARCH, 10);
		AddHeroCreatures("Raelag", CREATURE_BLACK_DRAGON, 3);
		AddHeroCreatures("Zehir", CREATURE_MASTER_GREMLIN, 25);
		AddHeroCreatures("Zehir", CREATURE_OBSIDIAN_GARGOYLE, 25);
		AddHeroCreatures("Zehir", CREATURE_STEEL_GOLEM, 20);
		AddHeroCreatures("Zehir", CREATURE_ARCH_MAGI, 10);
		AddHeroCreatures("Zehir", CREATURE_MASTER_GENIE, 10);
		AddHeroCreatures("Zehir", CREATURE_RAKSHASA_RUKH, 10);
		AddHeroCreatures("Zehir", CREATURE_TITAN, 7);
	end,

	[3] = function()
		d = 4;
		print ("impossible");
		AddHeroCreatures("Godric", CREATURE_CLERIC, 15);
		AddHeroCreatures("Godric", CREATURE_PALADIN, 10);
		AddHeroCreatures("Godric", CREATURE_ARCHANGEL, 5);
		AddHeroCreatures("Zehir", CREATURE_MASTER_GENIE, 10);
		AddHeroCreatures("Zehir", CREATURE_RAKSHASA_RUKH, 10);
		AddHeroCreatures("Zehir", CREATURE_TITAN, 5);
	end,
}

town_array = {"town1","town2","town3","town4"};
town_array.n = 4;

function TownCounter()
	print( "Town_count() = ",Town_count() );
	if Town_count() == 4 then
		SetObjectEnabled("bcitadel", not nil);
		Trigger(OBJECT_TOUCH_TRIGGER, "bcitadel", "bfight")
	end;
end;
		
function Town_count()
	local count = 0;

	for i=1, town_array.n do
		if ( GetObjectOwner(town_array[i]) == PLAYER_1 ) then
			count = count + 1;
		end;
	end;
	return count; 
end;

function barmy()
	MessageBox('/Maps/Scenario/C6M5/message-5.txt');
end

function bfight()
	QuestionBox('/Maps/Scenario/C6M5/message-6.txt', "fight_biara");
end

-- biara combat sequence --

C6M5_BATTLES = {
	heroes = { "Godric", "Heam", "Zehir", "Raelag" }
}

biara_fights = 0;
function fight_biara()
	Trigger(OBJECT_TOUCH_TRIGGER, "bcitadel", nil)
	biara_fights = biara_fights + 1;
	if biara_fights <= table.length(C6M5_BATTLES.heroes) then
		SiegeTown(C6M5_BATTLES.heroes[biara_fights], "/Maps/Scenario/C6M5/Ur-Hekal.xdb#xpointer(/AdvMapTown)", '/Scenes/CombatArenas/Boss_c6m5_Biara.xdb#xpointer(/AdventureFlybyScene)');
	else
		OBJECTIVES.state.captureBiara[2] = 2;
	end
end

function Question()
	QuestionBox('/Maps/Scenario/C6M5/message-8.txt', "Info");
end

function Info()
	MessageBox('/Maps/Scenario/C6M5/message-9.txt',"fight_sovereign_shield");
end

sovereign_shield_fights = 0;
function fight_sovereign_shield()
	sovereign_shield_fights = sovereign_shield_fights + 1;
	if sovereign_shield_fights <= table.length(C6M5_BATTLES.heroes) then
		StartCombat(C6M5_BATTLES.heroes[sovereign_shield_fights], "Kha-Beleth", 1, CREATURE_IMP, 80 + d * 20,
				'/Maps/Scenario/C6M5/sovereign_shield.xdb#xpointer(/Script)', "fight_sovereign_shield", '/Arenas/CombatArena/FinalCombat/FinalCombat.(AdvMapTownCombat).xdb#xpointer(/AdvMapTownCombat)');
	else
		OBJECTIVES.state.captureSovereign[2] = 3;
	end
end
	
sovereign_town_fights = 0;
function fight_sovereign_town()
	sovereign_town_fights = sovereign_town_fights + 1;
	if sovereign_town_fights <= table.length(C6M5_BATTLES.heroes) then
		StartCombat(C6M5_BATTLES.heroes[sovereign_town_fights], "Kha-Beleth", 2, 
		16, 56 + d * 5, 18, 32 + d * 5,
		'/Maps/Scenario/C6M5/sovereign_town.xdb#xpointer(/Script)', 
		"fight_sovereign_town", 
		'/Scenes/CombatArenas/Boss_c6m5_Sovereign1_2.xdb#xpointer(/AdventureFlybyScene)');
	else
		OBJECTIVES.state.captureSovereign[2] = 5;
	end
end

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C6/M5/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

	captureBiara = function()
		StartDialogScene("/DialogScenes/C6/M5/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

	captureSovereign = function()
		StartDialogScene("/DialogScenes/C6/M5/D3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

	outro = function()
		consoleCmd("video_outro");
	end,
}

OBJECTIVES = {
	date = 0,
	state = {
		captureBiara     = {     "capture_biara", 1 },	-- capture Biara Citadel
		captureSovereign = { "reach_deamon_lord", 0 },	-- capture Sovereign Citadel
		isAlive          = {             "prim4", 1 },	-- Godric, Findan, Zehir and Raelag must survive
		saveIsabell      = {      "save_isabell", 0 },	-- Start of this quest is handled by C6M5.xdb
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		SetPlayerStartResource( PLAYER_1, GOLD, 500000 );
		SetObjectEnabled("bcitadel", nil);
		Trigger(OBJECT_CAPTURE_TRIGGER,    "town1", "TownCounter");
		Trigger(OBJECT_CAPTURE_TRIGGER,    "town2", "TownCounter");
		Trigger(OBJECT_CAPTURE_TRIGGER,    "town3", "TownCounter");
		Trigger(OBJECT_CAPTURE_TRIGGER,    "town4", "TownCounter");
		Trigger(  OBJECT_TOUCH_TRIGGER, "bcitadel",       "barmy");
		Trigger(  OBJECT_TOUCH_TRIGGER, "scitadel",    "Question");
		OpenCircleFog(58, 51, 0, 10, PLAYER_1);
		startThread(DIFFICULTY[GetDifficulty()]);
		CINEMATICS.intro();
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
			
			if GetObjectiveState("prim4") == OBJECTIVE_FAILED then
				sleep(40);
				Loose();
				return
			end
			
			if GetObjectiveState("reach_deamon_lord") == OBJECTIVE_COMPLETED and GetObjectiveState("capture_biara") == OBJECTIVE_COMPLETED then
				SetObjectiveState("save_isabell", OBJECTIVE_COMPLETED);
				sleep(100);
				CINEMATICS.outro();
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	captureBiara = function()
		if OBJECTIVES.state.captureBiara[2] == 2 then
			SetObjectiveState("capture_biara", OBJECTIVE_COMPLETED);
			BlockGame();
			Save("Scene_21")
			sleep(20);
			CINEMATICS.captureBiara();
			BlockGame();
			SetObjectPosition( "Zehir", 69, 67);	
			SetObjectPosition("Godric", 68, 66);	
			SetObjectPosition(  "Heam", 67, 65);	
			SetObjectPosition("Raelag", 66, 64);	
			sleep(10);
			LevelUpHero(  "Zehir");
			LevelUpHero(   "Heam");
			LevelUpHero( "Godric");
			LevelUpHero( "Raelag");
			UnblockGame();
			ChangeHeroStat( "Zehir", STAT_MOVE_POINTS, 3000)
			ChangeHeroStat("Godric", STAT_MOVE_POINTS, 3000)
			ChangeHeroStat(  "Heam", STAT_MOVE_POINTS, 3000)
			ChangeHeroStat("Raelag", STAT_MOVE_POINTS, 3000)
			sleep(20);
			UnblockGame();
			OBJECTIVES.state.captureSovereign[2] = 1;
			OBJECTIVES.state.captureBiara[2] = 10;
		end
	end,
	
	captureSovereign = function()
		if OBJECTIVES.state.captureSovereign[2] == 1 then
			SetObjectiveState("reach_deamon_lord", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.captureSovereign[2] = 2;
		elseif OBJECTIVES.state.captureSovereign[2] == 3 then
			OBJECTIVES.state.captureSovereign[2] = 4;
			StartDialogScene("/DialogScenes/C6/M5/D2/DialogScene.xdb#xpointer(/DialogScene)", "fight_sovereign_town");
		elseif OBJECTIVES.state.captureSovereign[2] == 5 then
			Save("Scene_22");
			sleep(40);
			CINEMATICS.captureSovereign();
			sleep(10);
			SetObjectiveState("reach_deamon_lord", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.captureSovereign[2] = 10;
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 and ( IsHeroAlive("Zehir") == nil or IsHeroAlive("Godric") == nil or IsHeroAlive("Raelag") == nil or IsHeroAlive("Heam") == nil ) then
			SetObjectiveState("prim4", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
}

startThread( OBJECTIVES.start );
