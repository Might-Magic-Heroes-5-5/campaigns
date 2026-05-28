H55_PlayerStatus = {0,1,1,1,1,2,2,2};
doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C6M4");
	LoadHeroAllSetArtifacts(  "Zehir", "C6M3" );
	LoadHeroAllSetArtifacts( "Godric", "C6M3" );
	LoadHeroAllSetArtifacts(   "Heam", "C6M3" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Zehir" );
	H55_CamFixTooManySkills( PLAYER_1, "Godric");
	H55_CamFixTooManySkills( PLAYER_1,  "Heam" );

end;

startThread(H55_InitSetArtifacts);

function DeployDungeonArmy()
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "deploy", nil);
	OBJECTIVES.state.meetDungeon[2] = 1;
	
end
	
function RaelagTalks(nameHero)
	if GetObjectOwner(nameHero) == PLAYER_1 then
		OBJECTIVES.state.meetDungeon[2] = 3;
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "region1", nil);
	end
end

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C6/M4/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
    end,
	
	meetDungeonStart = function()
		StartDialogScene("/DialogScenes/C6/M4/D2/DialogScene.xdb#xpointer(/DialogScene)")
		sleep( 2 );
	end,
	
	meetDungeonFinish = function()
		StartDialogScene("/DialogScenes/C6/M4/D4/DialogScene.xdb#xpointer(/DialogScene)")
		sleep( 2 );
	end,
	
	defeatIsabel = function()
		StartDialogScene("/DialogScenes/C6/M4/D5/DialogScene.xdb#xpointer(/DialogScene)")
		sleep( 2 );
	end,
	
	outro = function()
		StartCutScene("/Maps/Cutscenes/C6M4/_.(AnimScene).xdb#xpointer(/AnimScene)");
		sleep( 2 );
    end,
}

OBJECTIVES = {
	state = {
		riteIsabel		= { "prim1", 1 }, -- Do the rite on Isabel
		arePrimAlive	= { "prim2", 1 }, -- Are Godric, Zehir and Findan alive?
		meetDungeon		= { "prim3", 0 }, -- meet with 
		areSecAlive		= { "prim4", 0 }, -- Are Kelodin and Raelag alive?
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		SetPlayerHeroesCountNotForHire(PLAYER_1, 6);
		CINEMATICS.intro();
		GiveExp(    "Sarge", 10000 );
		GiveExp(     "Gles", 20000 );
		GiveExp("Nathaniel", 10000 );
		GiveExp(  "Straker", 18000 );
		GiveExp("Christian", 10000 );
		GiveExp(   "Tamika", 15000 );
		GiveExp(    "Effig", 20000 );
		d = GetDifficulty();
		AddHeroCreatures("Isabell",    CREATURE_MILITIAMAN, 1000 + d * 1000);
		AddHeroCreatures("Isabell",      CREATURE_MARKSMAN, 500  + d *  750);
		AddHeroCreatures("Isabell",     CREATURE_SWORDSMAN, 300  + d *  400);
		AddHeroCreatures("Isabell", CREATURE_ROYAL_GRIFFIN, 200  + d *  300);
		AddHeroCreatures("Isabell",        CREATURE_CLERIC, 150  + d *  200);
		AddHeroCreatures("Isabell",       CREATURE_PALADIN, 100  + d *  100);
		AddHeroCreatures("Isabell",     CREATURE_ARCHANGEL, 50   + d *   75);
		EnableHeroAI("Isabell", nil);
		SetRegionBlocked("forbid", not nil, PLAYER_4);
		SetRegionBlocked("forbid", not nil, PLAYER_5);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "region1", "RaelagTalks");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "deploy", "DeployDungeonArmy");
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

			if GetObjectiveState("prim2") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	riteIsabel = function()
		if OBJECTIVES.state.riteIsabel[2] == 1 and GetObjectOwner("talonguard") == PLAYER_1 then
			SaveHeroAllSetArtifactsEquipped(  "Zehir", "C6M4" );
			SaveHeroAllSetArtifactsEquipped(   "Heam", "C6M4" );
			SaveHeroAllSetArtifactsEquipped( "Godric", "C6M4" );
			SaveHeroAllSetArtifactsEquipped( "Raelag", "C6M4" );
			sleep(20);
			Save("Scene_19");
			SetObjectiveState('prim1', OBJECTIVE_COMPLETED);
			CINEMATICS.defeatIsabel();
			CINEMATICS.outro();
			OBJECTIVES.state.riteIsabel[2] = 10;
		end
	end,
	
	arePrimAlive = function()
		if OBJECTIVES.state.arePrimAlive[2] == 1 and (IsHeroAlive("Zehir") == nil or IsHeroAlive("Godric") == nil or IsHeroAlive("Heam") == nil) then
			SetObjectiveState("prim2", OBJECTIVE_FAILED);
			OBJECTIVES.state.arePrimAlive[2] = 11;
		end
	end,
	
	meetDungeon = function()
		if OBJECTIVES.state.meetDungeon[2] == 1 then
			DeployReserveHero("Raelag", 36, 128, 0);
			DeployReserveHero("Kelodin", 33, 129, 0);
			EnableHeroAI("Raelag", nil);
			EnableHeroAI("Kelodin", nil);
			CINEMATICS.meetDungeonStart();
			SetObjectiveState("prim3", OBJECTIVE_ACTIVE);
			sleep(10)
			MoveHeroRealTime("Raelag", 37, 128, 0);
			MoveHeroRealTime("Kelodin", 34, 129, 0);
			OpenCircleFog(36, 128, 0, 6, PLAYER_1);
			OBJECTIVES.state.meetDungeon[2] = 2;
		elseif OBJECTIVES.state.meetDungeon[2] == 3 then
			CINEMATICS.meetDungeonFinish();
			sleep(1)
			UnreserveHero("Raelag");
			sleep(1)	
			SetObjectOwner("Raelag", PLAYER_1);
			sleep(5)	
			LoadHeroAllSetArtifacts( "Raelag", "C4M5" );
			sleep(40);
			H55_CamFixTooManySkills( PLAYER_1, "Raelag" );
			UnreserveHero("Kelodin");
			sleep(1);		
			SetObjectOwner("Kelodin", PLAYER_1);
			sleep(5);
			LoadHeroAllSetArtifacts("Kelodin", "C4M5");
			sleep(40);
			H55_CamFixTooManySkills(PLAYER_1,"Kelodin");
			ChangeHeroStat("Zehir", STAT_EXPERIENCE, 1366);
			SetObjectiveState("prim3", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.areSecAlive[2] = 1;
			OBJECTIVES.state.meetDungeon[2] = 10;
		end
	end,
	
	areSecAlive = function()
		if OBJECTIVES.state.areSecAlive[2] == 1 then
			SetObjectiveState("prim4", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.areSecAlive[2] = 2;
		elseif OBJECTIVES.state.areSecAlive[2] == 2 and (IsHeroAlive("Raelag")==nil or IsHeroAlive("Kelodin")==nil) then
			SetObjectiveState("prim4", OBJECTIVE_FAILED);
			OBJECTIVES.state.areSecAlive[2] = 11;
		end
	end
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)
