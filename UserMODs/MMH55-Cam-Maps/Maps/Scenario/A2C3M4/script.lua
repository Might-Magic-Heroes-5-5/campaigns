doFile("/scripts/A2_Zehir/A2_Zehir.lua");
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts( "A2C3M4", "Zehir" );
	LoadHeroAllSetArtifacts( "Zehir",  "A2C3M3" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Zehir" );
end

startThread(H55_InitSetArtifacts);
Inferno_count = 0;

A2C3M4_TOWN_ATTACKS = {
	["inf2"] = { heroes = {         "Wulfstan" }, vo = "CINEMATICS.VO_Wulfstan" },
	["inf4"] = { heroes = { "Freyda", "Duncan" }, vo =   "CINEMATICS.VO_Duncan" },
	["inf3"] = { heroes = { "Gottai",  "Kujin" }, vo =   "CINEMATICS.VO_Gottai" },
	["inf1"] = { heroes = {          "Shadwyn" }, vo =  "CINEMATICS.VO_Shadwyn" },
}

function x_enter()
	if GetObjectiveState("prim2") ~= OBJECTIVE_COMPLETED then
		MessageBox("/Maps/Scenario/a2c3m4/enter_message.txt");
		sleep( 2 );
	end
end

function Start_Wulfstan()
	BlockGame();
	OpenCircleFog( 138, 154, 1, 10, PLAYER_1 );
	MoveCamera(138, 154, 1, 50, 1);
	sleep( 20 )
	DeployReserveHero( "Wulfstan", 131, 155, 1 );
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO15_Wulfstan_01sound.xdb#xpointer(/Sound)" );
	sleep( 20 );
	LoadHeroAllSetArtifacts( "Wulfstan", "A2C3M3" );
	sleep( 100 );
	H55_CamFixTooManySkills( PLAYER_1, "Wulfstan" );
	ChangeHeroStat( "Wulfstan", STAT_MANA_POINTS,   500 );
	ChangeHeroStat( "Wulfstan", STAT_MOVE_POINTS, 30000 );
	table.inject(OBJECTIVES.isAlive_list, "Wulfstan" ); 
	MoveHeroRealTime( "Wulfstan", 143, 152, 1 );
	sleep( 20 );
	UnblockGame();
end

function Start_Freyda()
	BlockGame();
	OpenCircleFog( 32, 25, 1, 10, PLAYER_1 );
	MoveCamera(32, 25, 1, 50, 1);
	sleep( 20 );
	DeployReserveHero( "Freyda", 33, 18, 1 );
	DeployReserveHero( "Duncan", 33, 16, 1 );
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO18_Freyda_01sound.xdb#xpointer(/Sound)" );
	sleep( 40 );
	LoadHeroAllSetArtifacts( "Freyda", "A2C3M2" );
	LoadHeroAllSetArtifacts( "Duncan", "A2C3M2" );
	sleep( 100 );
	H55_CamFixTooManySkills( PLAYER_1, "Freyda" );
	H55_CamFixTooManySkills( PLAYER_1, "Duncan" );
	ChangeHeroStat( "Freyda", STAT_MANA_POINTS, 500 ); 
	ChangeHeroStat( "Freyda", STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( "Freyda", 34, 31, 1 );
	sleep( 10 );
	MoveHeroRealTime( "Duncan", 33, 28, 1 );
	table.inject(OBJECTIVES.isAlive_list, "Freyda" ); 
	table.inject(OBJECTIVES.isAlive_list, "Duncan" ); 
	sleep( 20 );
	UnblockGame();
end

function Start_Kujin()
	BlockGame();
	OpenCircleFog( 150, 56, 1, 10, PLAYER_1 );
	MoveCamera(150, 56, 1, 50, 1);
	sleep( 20 );
	DeployReserveHero( "Gottai", 155, 61, 1 );
	DeployReserveHero( "Kujin", 153, 61, 1 );
	Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO16_Kujin_01sound.xdb#xpointer(/Sound)" );
	sleep ( 40 );
	LoadHeroAllSetArtifacts( "Kujin",  "A2C2M4"  );
	LoadHeroAllSetArtifacts( "Gottai",  "A2C2M5"  );
	sleep( 100 );
	H55_CamFixTooManySkills(PLAYER_1,"Gottai");
	H55_CamFixTooManySkills(PLAYER_1,"Kujin");
	ChangeHeroStat( "Gottai", STAT_MANA_POINTS, 500 );
	ChangeHeroStat( "Gottai", STAT_MOVE_POINTS, 30000 );
	ChangeHeroStat( "Kujin", STAT_MOVE_POINTS, 30000 );
	table.inject(OBJECTIVES.isAlive_list, "Gottai" );
	MoveHeroRealTime( "Gottai", 146, 51, 1 );
	sleep( 10 );
	MoveHeroRealTime( "Kujin", 148, 49, 1 );
	UnblockGame();
end

function _reachPortal(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "enter_demons", nil );
		OBJECTIVES.state.reachPortal[2] = 3;
		OBJECTIVES.state.destroyBarrier[2] = 1;
	end
end

function _destroyDemons(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec2_start", nil);
		OBJECTIVES.state.destroyDemon[2] = 1;
	end
end

function _freeMatriarchs(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec3_start",nil );	
		OBJECTIVES.state.freeMatriarchs[2] = 1;
	end
end

function _learnTravelSpell(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sec4_start", nil );
		OBJECTIVES.state.learnSpell[2] = 1;
	end	
end

function Summon_town()
	ZehirAbilitiesInit("Zehir");
	ZehirTownInit("z_town");
	AddTownPoint(9, 90, GROUND, 90, "zehir", 35000, "zehir1");
end

function SetUpTownFights(koef)
	if GetDifficulty() == DIFFICULTY_EASY then
		RemoveObjectCreatures("inf4", CREATURE_ARCHDEVIL, 10); 
		RemoveObjectCreatures("inf2", CREATURE_ARCHDEVIL, 20);
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		TeachHeroSpell( "Efion", SPELL_BERSERK );
		TeachHeroSpell( "Efion", SPELL_SLOW );
		TeachHeroSpell( "Efion", SPELL_MASS_FORGETFULNESS  );
		TeachHeroSpell( "Efion", SPELL_HYPNOTIZE  );
		TeachHeroSpell( "Efion", SPELL_CURSE  );
	elseif GetDifficulty() == DIFFICULTY_HARD then
		AddHeroCreatures( "Calid", CREATURE_ARCHDEVIL, 12 );
		AddHeroCreatures( "Calid", CREATURE_HELL_HOUND, 150 );
		AddHeroCreatures( "Calid", CREATURE_CERBERI, 150 );
		TeachHeroSpell( "Calid", SPELL_BERSERK );
		AddHeroCreatures( "Oddrema", CREATURE_HORNED_DEMON , 200 );
		AddHeroCreatures( "Oddrema", CREATURE_INFERNAL_SUCCUBUS , 30 );
		AddHeroCreatures( "Oddrema", CREATURE_PIT_SPAWN , 10 );
		AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS , 50 );
		AddHeroCreatures( "Oddrema", CREATURE_ARCHDEVIL , 10 );
		AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS_SEDUCER , 50 );
		AddHeroCreatures( "Oddrema", CREATURE_HELLMARE , 30 );
		AddHeroCreatures( "Efion", CREATURE_ARCHDEVIL, 10 );
		AddHeroCreatures( "Efion", CREATURE_PIT_FIEND, 15 );
		AddHeroCreatures( "Efion", CREATURE_INFERNAL_SUCCUBUS, 50 );
		TeachHeroSpell( "Efion", SPELL_SLOW );
		TeachHeroSpell( "Efion", SPELL_MASS_FORGETFULNESS  );
		TeachHeroSpell( "Efion", SPELL_HYPNOTIZE  );
		TeachHeroSpell( "Efion", SPELL_CURSE  );
	elseif GetDifficulty()==DIFFICULTY_HEROIC then
		AddHeroCreatures( "Calid", CREATURE_ARCHDEVIL, 20 );
		AddHeroCreatures( "Calid", CREATURE_HELL_HOUND, 300 );
		AddHeroCreatures( "Calid", CREATURE_CERBERI, 300 );
		TeachHeroSpell( "Calid", SPELL_BERSERK );
		AddHeroCreatures( "Oddrema", CREATURE_HORNED_DEMON , 400 );
		AddHeroCreatures( "Oddrema", CREATURE_INFERNAL_SUCCUBUS , 50 );
		AddHeroCreatures( "Oddrema", CREATURE_PIT_SPAWN , 20 );
		AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS , 60 );
		AddHeroCreatures( "Oddrema", CREATURE_ARCHDEVIL , 15 );
		AddHeroCreatures( "Oddrema", CREATURE_SUCCUBUS_SEDUCER , 30 );
		AddHeroCreatures( "Oddrema", CREATURE_HELLMARE , 20 );
		AddHeroCreatures( "Efion", CREATURE_ARCHDEVIL, 20 );
		AddHeroCreatures( "Efion", CREATURE_PIT_SPAWN, 35 );
		AddHeroCreatures( "Efion", CREATURE_INFERNAL_SUCCUBUS, 65 );
		TeachHeroSpell( "Efion", SPELL_SLOW );
		TeachHeroSpell( "Efion", SPELL_MASS_FORGETFULNESS  );
		TeachHeroSpell( "Efion", SPELL_HYPNOTIZE  );
		TeachHeroSpell( "Efion", SPELL_CURSE  );
	end
end

function St_1 ( heroname )
	SetObjectPosition( heroname, 129, 163, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end

function St_2 ( heroname )
	SetObjectPosition( heroname, 33, 13, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end

function St_3 ( heroname )
	SetObjectPosition( heroname, 158, 68, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end

function St_4 ( heroname )
	SetObjectPosition( heroname, 28, 163, 0 );
	MessageBox("/Maps/Scenario/a2c3m4/zehir_stop.txt");
end

function A2C3M4_capture_town( town_name )
	local town = A2C3M4_TOWN_ATTACKS[town_name];
	startThread( loadstring(town.vo .. "()") );
	for i, hero in town.heroes do
		SetObjectOwner( hero, PLAYER_3 );
		sleep(20);
		EnableHeroAI( hero, nil );
	end
	sleep( 10 )
	RazeTown( town_name );
	Inferno_count = Inferno_count + 1;
end

function GarrisonSetUp(koef)
    for creatureID = 1, CREATURES_COUNT - 1 do 
        count = GetObjectCreatures( "inf1", creatureID );
        if GetObjectCreatures("inf1", creatureID ) > 2 then
		   RemoveObjectCreatures("inf1", creatureID, count );
           AddObjectCreatures("inf1", creatureID, count + ( count / 100 * 10) * koef );
        end
    end
end

DIFFICULTY = {
	[0] = function()
		diff = 1;
		ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 8, 10000);
		RemoveObjectCreatures("Talonguard", CREATURE_ARCHDEVIL, 15); 
		RemoveObjectCreatures("Talonguard", CREATURE_ARCH_DEMON, 15);
		SetUpTownFights(1);
		GarrisonSetUp(1);
		print("Difficulty level is easy.");
	end,
	
	[1] = function()
		diff = 2;
		ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 16, 16000);
		SetUpTownFights(2);
		GarrisonSetUp(2);
		print("Difficulty level is normal.");
	end,
	
	[2] = function()
		diff = 3;
		ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 18, 20000);
		AddObjectCreatures( "Talonguard", CREATURE_ARCHDEVIL, 25 );
		AddObjectCreatures( "Talonguard", CREATURE_ARCH_DEMON, 25 );
		SetUpTownFights(3);
		GarrisonSetUp(3);
		print("Difficulty level is hard.");
	end,
		
	[3] = function()
		diff = 4;
		ZehirCreaturesAdd(CREATURE_STORM_LORD, 4, GEM, 20, 24000);
		AddObjectCreatures( "Talonguard", CREATURE_ARCHDEVIL, 45 );
		AddObjectCreatures( "Talonguard", CREATURE_ARCH_DEMON, 45 );
		SetUpTownFights(4);
		GarrisonSetUp(4);
		print("Difficulty level is heroic.");
	end,
}

CINEMATICS = {
	showPortal = function()
		BlockGame();
		PlayVoiceoverAndBlockGame( "/Maps/Scenario/A2C3M4/C3M4_VO2_Zehir_01sound.xdb#xpointer(/Sound)" );
		OpenCircleFog( 159, 99, 0, 8, PLAYER_1 );  
		MoveCamera(159, 99, 0, 50, 1);
		sleep( 150 );
		UnblockGame();
	end,
	
	VO_Duncan = function()
		Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO11_Duncan_01sound.xdb#xpointer(/Sound)" );
	end,

	VO_Shadwyn = function()
		Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO12_Ylaya_01sound.xdb#xpointer(/Sound)" );
	end,

	VO_Gottai = function()
		Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO13_Orc1_01sound.xdb#xpointer(/Sound)" );
	end,

	VO_Wulfstan = function()
		Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO14_Thorod_01sound.xdb#xpointer(/Sound)" );
	end,
	
	VO_ZehirDefeatsElves = function()
		Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO9_Zehir_01sound.xdb#xpointer(/Sound)" );
	end
}

OBJECTIVES = {
	state = {
		isAlive  	      = { "prim1", 1 }, -- Ally heroes must survive
		getGoldMines      = { "prim2", 1 }, -- Capture the 3 gold mines
		reachPortal		  = { "prim3", 0 }, -- 
		destroyBarrier    = { "prim4", 0 }, -- Defeat 2 Inferno heroes to destroy the magic barrier
		defeatDarkElves	  = { "prim5", 0 }, -- Defeat Dark Elves
		captureTalonguard = { "prim6", 0 }, -- Capture Talonguard town
		plunderWarrens	  = {  "sec1", 1 }, -- Capture the 2 Dwarven Warrens
		destroyDemon	  = {  "sec2", 0 }, -- Destroy the Demon Leader
		freeMatriarchs	  = {  "sec3", 0 }, -- Free Matriarchs
		learnSpell		  = {  "sec4", 0 }, -- Learn Instant Travel spell
		_checkTowns		  = {     "_", 1 }, -- Events triggered on town capture
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

    prepare = function()
		OpenCircleFog( 91, 86, 0, 16, PLAYER_1 ); ---фог_cо_столицы
		SetObjectEnabled( "f_portal", nil )
		BlockTownGarrisonForAI( "Talonguard", not nil )
		BlockTownGarrisonForAI( "delf", not nil )
		BlockTownGarrisonForAI( "inf1", not nil )
		BlockTownGarrisonForAI( "inf2", not nil )
		BlockTownGarrisonForAI( "inf3", not nil )
		BlockTownGarrisonForAI( "inf4", not nil )
		SetPlayerStartResources( PLAYER_1, 0, 0, 0, 0, 0, 10 - 2 * GetDifficulty(), 10000 );
		GiveExp(  "Biara", 15100000 );
		GiveExp(  "Menel",   245000 );
		GiveExp(  "Dalom",   400000 );
		GiveExp( "Marder",   390000 );
		GiveExp(  "Nymus",   360000 );
		GiveExp(  "Deleb",   280000 );
		GiveExp( "Ferigl",   600000 );
		EnableHeroAI(   "Biara", nil );
		EnableHeroAI(  "Ferigl", nil );
		EnableHeroAI(   "Efion", nil );
		EnableHeroAI( "Oddrema", nil );
		EnableHeroAI(   "Calid", nil );
		EnableHeroAI(   "Jazaz", nil );
		SetRegionBlocked(         "biara", 1, PLAYER_2 ); 
		SetRegionBlocked( "border_demons", 1, PLAYER_1 ); 
		SetRegionBlocked(     "red_hero1", 1, PLAYER_2 ); 
		SetRegionBlocked(	  "red_hero2", 1, PLAYER_2 );
		SetRegionBlocked(     "red_hero3", 1, PLAYER_2 );  
		SetRegionBlocked(  	    "i_boss1", 1, PLAYER_2 ); -- Block the Demon leader from leaving the area
		SetRegionBlocked(  	    "i_boss2", 1, PLAYER_2 ); -- Block the Demon leader from leaving the area
		SetRegionBlocked(  	    "i_boss3", 1, PLAYER_2 ); -- Block the Demon leader from leaving the area
		SetRegionBlocked(  	      "drag1", 1, PLAYER_2 ); -- Block the Demon leader from collecting the artifact
		SetRegionBlocked(            "DD", 1, PLAYER_4 ); -- Block Dark Elves form defeating the dragons and learning the Instant Travel spell
		SetRegionBlocked(    "final_wey1", 1, PLAYER_4 ); -- Block Dark Elves from accessing the portal
		SetRegionBlocked(    "final_wey2", 1, PLAYER_4 ); -- Block Dark Elves from accessing the portal
		Trigger(OBJECT_TOUCH_TRIGGER, "f_portal", "x_enter" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "enter_demons",      "_reachPortal", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "sec2_start",    "_destroyDemons", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "sec3_start",   "_freeMatriarchs", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,   "sec4_start", "_learnTravelSpell", nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,         "zeh1",         "St_1" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,         "zeh2",         "St_2" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,         "zeh3",         "St_3" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER,          "elf",         "St_4" );
		startThread( DIFFICULTY[GetDifficulty()] );

		if GetGameVar("A2C3M3_Graal") == "1" then
			GiveArtefact("Zehir", ARTIFACT_GRAAL);
		elseif GetGameVar("A2C3M3_Graal") == "2" then
			UpgradeTownBuilding( "z_town", TOWN_BUILDING_GRAIL )	
		end
		startThread(Summon_town);
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

			if GetObjectiveState("prim1") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("prim6") == OBJECTIVE_COMPLETED then
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	isAlive_list = { "Zehir" },
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState('prim1',OBJECTIVE_ACTIVE);
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 then
			for i, hero in OBJECTIVES.isAlive_list do
				if IsHeroAlive(hero) == nil then
					SetObjectiveState( "prim1", OBJECTIVE_FAILED );
					OBJECTIVES.state.isAlive[2] = 11;
					break
				end
			end
		end
	end,
	
	getGoldMines = function()
		if OBJECTIVES.state.getGoldMines[2] == 1 then
			SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
			OBJECTIVES.state.getGoldMines[2] = 2;
		elseif OBJECTIVES.state.getGoldMines[2] == 2 and GetObjectOwner("mine1") == PLAYER_1 and GetObjectOwner("mine2") == PLAYER_1 and GetObjectOwner("mine3") == PLAYER_1 then
			SetObjectiveState('prim2',OBJECTIVE_COMPLETED);
			SetObjectEnabled( "f_portal", not nil );
			CINEMATICS.showPortal();
			OBJECTIVES.state.reachPortal[2] = 1;
			OBJECTIVES.state.getGoldMines[2] = 10;
		end
	end,
	
	reachPortal = function()
		if OBJECTIVES.state.reachPortal[2] == 1 then
			SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
			sleep(100);
			Start_Wulfstan();
			OBJECTIVES.state.reachPortal[2] = 2;
		elseif OBJECTIVES.state.reachPortal[2] == 3 then
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.reachPortal[2] = 10;
		end
	end,
	
	destroyBarrier = function()
		if OBJECTIVES.state.destroyBarrier[2] == 1 then
			SetObjectiveState('prim4',OBJECTIVE_ACTIVE);
			startThread( Start_Freyda );
			OpenCircleFog( 159, 77, 0, 4, PLAYER_1 );
			OpenCircleFog( 160, 49, 0, 4, PLAYER_1 );
			OBJECTIVES.state.destroyBarrier[2] = 2;			
		elseif OBJECTIVES.state.destroyBarrier[2] == 2 and IsHeroAlive("Marder") == nil and IsHeroAlive("Nymus") == nil then 
			RemoveObject("f1");
			RemoveObject("f2");
			SetRegionBlocked( "border_demons", nil, PLAYER_1 );
			SetObjectiveState( 'prim4', OBJECTIVE_COMPLETED );
			startThread( Start_Kujin );
			OBJECTIVES.state.defeatDarkElves[2] = 1;
			OBJECTIVES.state.destroyBarrier[2] = 10;
		end
	end,

	defeatDarkElves = function()
		if OBJECTIVES.state.defeatDarkElves[2] == 1 then
			SetObjectiveState( 'prim5', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.defeatDarkElves[2] = 2;
		elseif OBJECTIVES.state.defeatDarkElves[2] == 2 and GetPlayerState(PLAYER_4) == 3 then
			SetObjectiveState( "prim5", OBJECTIVE_COMPLETED );
			SetObjectiveState( "Pri7_FreeLand", OBJECTIVE_COMPLETED ); -- activated by A2C3M4 map.xdb
			RemoveObjectCreatures("x1", CREATURE_ARCH_DEMON, 900 - GetDifficulty() * 100 );
			RemoveObjectCreatures("x2", CREATURE_ARCH_DEMON, 900 - GetDifficulty() * 100 );
			RemoveObject("final_gate1");
			RemoveObject("final_gate2");
			CINEMATICS.VO_ZehirDefeatsElves();
			MessageBox("/Maps/Scenario/a2c3m4/Def_elf.txt");
			OBJECTIVES.state.captureTalonguard[2] = 1;
			OBJECTIVES.state.defeatDarkElves[2] = 10;
		end
	end,
	
	captureTalonguard = function()
		if OBJECTIVES.state.captureTalonguard[2] == 1 then
			SetObjectiveState('prim6', OBJECTIVE_ACTIVE);
			BlockGame();
			sleep(5);
			OpenCircleFog( 28, 150, 1, 10, PLAYER_1 );
			MoveCamera(28, 150, 1, 50, 1);
			sleep(15);
			DeployReserveHero( "Shadwyn", 28, 154, 1 );
			sleep(8);
			ChangeHeroStat( "Shadwyn", STAT_MANA_POINTS, 500 );
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO17_Ylaya_01sound.xdb#xpointer(/Sound)" );
			sleep( 20 ); 
			ChangeHeroStat( "Shadwyn", STAT_MOVE_POINTS, 30000 );
			MoveHeroRealTime( "Shadwyn", 28, 143, 1 );
			sleep(20);
			table.inject(OBJECTIVES.isAlive_list, "Shadwyn" ); 
			UnblockGame();
			OBJECTIVES.state.captureTalonguard[2] = 2;
		elseif OBJECTIVES.state.captureTalonguard[2] == 2 and GetObjectOwner("Talonguard") == PLAYER_1 then
			StartDialogScene("/DialogScenes/A2C3/M4/S1/DialogScene.xdb#xpointer(/DialogScene)");
			StartDialogScene("/DialogScenes/A2C3/M4/S2/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState('prim6', OBJECTIVE_COMPLETED);
			OBJECTIVES.state.captureTalonguard[2] = 10;
		end
	end,
	
	plunderWarrens = function()
		if OBJECTIVES.state.plunderWarrens[2] == 1 then
			SetObjectiveState( 'sec1', OBJECTIVE_ACTIVE );
			OBJECTIVES.state.plunderWarrens[2] = 2;
		elseif OBJECTIVES.state.plunderWarrens[2] == 2 and GetObjectOwner("DT1") == PLAYER_1 and GetObjectOwner("DT2") == PLAYER_1 then
			SetObjectiveState( 'sec1', OBJECTIVE_COMPLETED );
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO3_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Захват дварф шахт
			sleep( 10 );
			LevelUpHero( "Zehir" );
			OBJECTIVES.state.plunderWarrens[2] = 10;
		end
	end,
	
	destroyDemon = function()
		if OBJECTIVES.state.destroyDemon[2] == 1 then
			SetObjectiveState('sec2',OBJECTIVE_ACTIVE);
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO4_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Демон инферно
			OBJECTIVES.state.destroyDemon[2] = 2;
		elseif OBJECTIVES.state.destroyDemon[2] == 2 and IsHeroAlive("Deleb") == nil then
			SetObjectiveState("sec2", OBJECTIVE_COMPLETED);
			sleep(10);
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO5_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Убили демона
			OBJECTIVES.state.destroyDemon[2] = 10;
		end
	end,
	
	freeMatriarchs = function()
		if OBJECTIVES.state.freeMatriarchs[2] == 1 then
			SetObjectiveState( "sec3", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.freeMatriarchs[2] = 2;
		elseif OBJECTIVES.state.freeMatriarchs[2] == 2 and IsObjectExists ("gvard") == nil then
			SetObjectiveState( "sec3", OBJECTIVE_COMPLETED );
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO6_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO Убили охрану матриархов
			OBJECTIVES.state.freeMatriarchs[2] = 10;
		end
	end,
	
	learnSpell = function()
		if OBJECTIVES.state.learnSpell[2] == 1 then
			SetObjectiveState( "sec4", OBJECTIVE_ACTIVE );
			Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO8_Zehir_01sound.xdb#xpointer(/Sound)" ); ----------------VO
			OBJECTIVES.state.learnSpell[2] = 2;
		elseif OBJECTIVES.state.learnSpell[2] == 2 and KnowHeroSpell( "Zehir", 50 ) == not nil then
			SetObjectiveState( "sec4", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.learnSpell[2] = 10;
		end
	end,
	
	_checkTowns_list = { "inf2", "inf4", "inf3", "inf1" },
	_checkTowns_reinforcements = { nil, nil },
	_checkTowns = function()
		if OBJECTIVES.state._checkTowns[2] == 1 then
			if Inferno_count < 4 then
				for i, town in OBJECTIVES._checkTowns_list do
					if GetObjectOwner(town) == PLAYER_1 then
						A2C3M4_capture_town(town);
						RemoveObjectCreatures("x1", CREATURE_FAMILIAR, 100000);
						RemoveObjectCreatures("x2", CREATURE_FAMILIAR, 100000);
						OBJECTIVES._checkTowns_list[i] = nil;
					end
				end
				sleep(50);
			else
				BlockGame();
				MoveCamera(96, 85, GROUND, 25, 3.14/3, 0, 1, 1, 1);
				Play2DSound( "/Maps/Scenario/A2C3M4/C3M4_VO10_Zehir_01sound.xdb#xpointer(/Sound)" ); -----------VO прибытие кричей
				sleep( 32 );
				CreateMonster( "m1",   CREATURE_BLACK_DRAGON, 75, 96, 88, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
				CreateMonster( "m2",   CREATURE_MAGMA_DRAGON, 75, 96, 86, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
				CreateMonster( "m3", CREATURE_CYCLOP_UNTAMED, 75, 96, 84, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
				CreateMonster( "m4", 	  CREATURE_ARCHANGEL, 75, 96, 82, 0, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 270 );
				UnblockGame();
				OBJECTIVES.state._checkTowns[2] = 10;
			end
		end
		
		if GetDate(MONTH) == 4 - GetDifficulty() and GetDate(WEEK) == 1 and GetDate(DAY_OF_WEEK) == 1 and OBJECTIVES._checkTowns_reinforcements[1] == nil then 
			AddObjectCreatures("Talonguard",  CREATURE_ARCHDEVIL, 30); 
			AddObjectCreatures("Talonguard", CREATURE_ARCH_DEMON, 30);
			OBJECTIVES._checkTowns_reinforcements[1] = 1;
		end
		
		if GetDate(MONTH) == 5 - GetDifficulty() and GetDate(WEEK) == 1 and GetDate(DAY_OF_WEEK) == 1 and OBJECTIVES._checkTowns_reinforcements[2] == nil then 
			AddObjectCreatures("Talonguard",  CREATURE_ARCHDEVIL, 75); 
			AddObjectCreatures("Talonguard", CREATURE_ARCH_DEMON, 75); 
			OBJECTIVES._checkTowns_reinforcements[2] = 1;
		end
	end
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start )

function a2c3m4_dbg(var)
	if var == 1 then
		H55_Speedrun(1);
		SetObjectOwner("DT1", PLAYER_1);
		SetObjectOwner("DT2", PLAYER_1);
	elseif var == 2 then
		SetObjectOwner("mine1", PLAYER_1);
		SetObjectOwner("mine2", PLAYER_1);
		SetObjectOwner("mine3", PLAYER_1);
	elseif var == 3 then
		SetObjectPosition("Zehir", 158, 99, 0);
	elseif var == 33 then
		SetObjectPosition("Zehir",  69, 31, 0);
	elseif var == 333 then
		RemoveObject("Marder");
		RemoveObject("Nymus");
		--SetObjectPosition("Zehir", 161, 46, 0);
		--SetObjectPosition("Zehir", 157, 78, 0);		
	elseif var == 3333 then
		SetObjectPosition("Zehir", 156, 68, 0);
	elseif var == 33333 then
		SetObjectPosition("Zehir", 61, 120, 1);
	elseif var == 4 then
		SetObjectOwner("delf", PLAYER_1);
	end
end
