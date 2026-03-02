H55_PlayerStatus = {0,1,1,2,2,2,2,2};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C6M3");
    LoadHeroAllSetArtifacts("Zehir", "C6M2" );
end

startThread(H55_InitSetArtifacts);

town_array = {"town1","town2","town3","town4"};
town_array.n = 4;

function theend()
	OBJECTIVES.state.defeatMarkal[2] = 6;
end

function Town_count()
	local count = 0;
	for i=1, town_array.n do
		if ( GetObjectOwner(town_array[i]) == PLAYER_1 ) then
			count = count + 1;
		end
	end
	return count;
end

function MeetingGodric()
	Trigger(OBJECT_TOUCH_TRIGGER, "prison", nil);
	SetObjectEnabled("prison", nil);
	OBJECTIVES.state.meetGodric[2] = 2;
end	

function GodricMeetsAllies()
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "guardian", nil)
	if GetObjectOwner("firstborder") ~= PLAYER_1 then 
		SetObjectOwner("firstborder", PLAYER_1)
		sleep(5);
		CINEMATICS.firstBorder();
	end
end

function GodricFight(hero)
	if GetObjectOwner(hero) == PLAYER_1 then
		CINEMATICS.firstTown();
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"town",nil);
	end
end

d = GetDifficulty() - 1;

-- Messages
function AreYouReady()
	QuestionBox('/Maps/Scenario/C6M3/message-8.txt', "WeAreReady" );
end

function WeAreReady()
	BATTLES.zehir.start();
end

function YouAreNotReady()
	MessageBox('/Maps/Scenario/C6M3/message-9.txt');
end

function MarkalGateMessage()
	MessageBox('/Maps/Scenario/C6M3/message-7.txt');
end

BATTLES = {
    zehir = {
      start = function(nameHero)
        StartCombat("Zehir", "Berein", 6,
		         CREATURE_WRAITH,  40 + d *  40,
	   CREATURE_SKELETON_WARRIOR, 250 + d * 250,
		         CREATURE_ZOMBIE, 150 + d * 150,
		          CREATURE_GHOST, 100 + d * 100,		
		   CREATURE_VAMPIRE_LORD,  75 + d *  75,
		       CREATURE_DEMILICH,  50 + d *  50,
		'/Maps/Scenario/C6M3/CombatScript_zehir.xdb#xpointer(/Script)',
		"BATTLES.zehir.finish",
		'/Scenes/CombatArenas/Boss_c6m3_Dirt.xdb#xpointer(/AdventureFlybyScene)');
		OBJECTIVES.state.defeatMarkal[2] = 4;
      end,

      finish = function()
		if IsHeroAlive("Zehir") then
			BATTLES.godric.start();
		end
      end
    },
	
	godric = {
		start = function()
			StartCombat("Godric", "Berein", 4,
			       CREATURE_DEMILICH,  50 + d *  50,
			   CREATURE_VAMPIRE_LORD,  75 + d *  75,			
			          CREATURE_GHOST, 300 + d * 200,		
				  CREATURE_NOSFERATU, 300 + d * 200,
			CREATURE_SKELETON_ARCHER, 250 + d * 250,
			'/Maps/Scenario/C6M3/CombatScript_godric.xdb#xpointer(/Script)',
			"BATTLES.godric.finish",
			'/Scenes/CombatArenas/Boss_c6m3_Dirt2.xdb#xpointer(/AdventureFlybyScene)')
		end,
		
		finish = function()
			if IsHeroAlive("Godric") then
				BATTLES.findan.start();
			end
		end
	},
	
	findan = {
		start = function()
			SiegeTown("Heam", "/Maps/Scenario/C6M3/Spes.xdb#xpointer(/AdvMapTown)", '/Scenes/CombatArenas/Boss_c6m3_Siege.xdb#xpointer(/AdventureFlybyScene)');
		end
	}
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C6/M3/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	meetGodric = function()
		StartDialogScene("/DialogScenes/C6/M3/D2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	firstBorder = function()
		StartDialogScene("/DialogScenes/C6/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	firstTown = function()
		StartDialogScene("/DialogScenes/C6/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	meetFindan = function()
		StartDialogScene("/DialogScenes/C6/M3/D3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,

	outro = function()
		StartCutScene("/Maps/Cutscenes/C6M3/_.(AnimScene).xdb#xpointer(/AnimScene)");
		sleep( 2 );
	end,
}

OBJECTIVES = {
	state = {
		meetFindan	 	= { "obj1", 1 }, 		-- Find Findan
		meetGodric		= { "obj2", 1 },		-- Find Godric
		captureTowns	= { "obj3", 1 },		-- Capture Griffin empire towns
		defeatMarkal	= { "obj4", 0 },		-- Defeat Markal
		isZehirAlive	= { "obj5", 1 },		-- Zehir must stay alive
		isFindanAlive	= { "obj6", 0 },		-- Findan must stay alive
		isGodricAlive	= { "obj7", 0 },		-- Godric must stay alive
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		SetPlayerHeroesCountNotForHire(PLAYER_1, 6);
		CINEMATICS.intro();
		H55_CamFixTooManySkills(PLAYER_1,"Zehir");
		GiveExp( "Nathaniel", 80000 );
		GiveExp( "Brem", 80000 );
		Trigger(OBJECT_TOUCH_TRIGGER, "spes", "YouAreNotReady");
		Trigger(OBJECT_TOUCH_TRIGGER, "post", "YouAreNotReady");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "gathering", "YouAreNotReady");
		SetObjectEnabled("markalgate", nil);
		Trigger(OBJECT_TOUCH_TRIGGER, "markalgate", "MarkalGateMessage");
		SetObjectEnabled("spes", nil);
		SetObjectEnabled("post", nil);
		EnableHeroAI("Godric", nil);
		SetRegionBlocked("heam", not nil, PLAYER_2);
		SetRegionBlocked("block", not nil, PLAYER_2);	
		Trigger(OBJECT_TOUCH_TRIGGER, "prison", "MeetingGodric");
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
			
			if GetObjectiveState("obj5") == OBJECTIVE_FAILED or GetObjectiveState("obj6") == OBJECTIVE_FAILED or GetObjectiveState("obj7") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("obj4") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Zehir", "C6M3");
				Save("Scene_18");
				sleep(10);
				CINEMATICS.outro();
				sleep(20);
				Win();
				return
			end
		end
	end,
	
	meetFindan = function()
		if OBJECTIVES.state.meetFindan[2] == 2 then
			DeployReserveHero("Heam", 84, 41, 0);
			sleep(10);
			H55_CamFixTooManySkills(PLAYER_1, "Heam");
			sleep(10);
			MoveHero("Heam", 86, 42, 0);
			EnableHeroAI("Heam", nil);
			OBJECTIVES.state.isFindanAlive[2] = 1;
			OBJECTIVES.state.meetFindan[2] = 3;
		elseif OBJECTIVES.state.meetFindan[2] == 3 and IsObjectVisible(PLAYER_1, "Heam")==not nil then
			CINEMATICS.meetFindan();
			SetObjectiveState("obj1", OBJECTIVE_COMPLETED);
			SetObjectOwner("Heam", PLAYER_1);
			ChangeHeroStat("Zehir", STAT_EXPERIENCE, 1473);
			OBJECTIVES.state.defeatMarkal[2] = 1;
			OBJECTIVES.state.meetFindan[2] = 10;
		end
	end,
	
	meetGodric = function()
		if OBJECTIVES.state.meetGodric[2] == 2 then
			CINEMATICS.meetGodric();
			SetObjectiveState("obj2",OBJECTIVE_COMPLETED);
			SetObjectOwner("Godric", PLAYER_1);
			sleep(10);
			H55_CamFixTooManySkills(PLAYER_1, "Godric");
			ChangeHeroStat("Zehir", STAT_EXPERIENCE, 1532);
			Trigger(REGION_ENTER_AND_STOP_TRIGGER,"guardian", "GodricMeetsAllies");
			Trigger(REGION_ENTER_AND_STOP_TRIGGER,"town", "GodricFight");
			OBJECTIVES.state.captureTowns[2] = 2;
			OBJECTIVES.state.meetFindan[2] = 2;
			OBJECTIVES.state.isGodricAlive[2] = 1;
			OBJECTIVES.state.meetGodric[2] = 10;
		end
	end,
	
	captureTowns = function()
		local owned_towns = Town_count();
		if OBJECTIVES.state.captureTowns[2] == 2 then
			SetObjectiveVisible("obj3", not nil);
			OBJECTIVES.state.captureTowns[2] = 3;
		elseif OBJECTIVES.state.captureTowns[2] == 3 and owned_towns == 4 then
			ChangeHeroStat("Zehir", STAT_EXPERIENCE, 2162);
			SetObjectEnabled("markalgate", not nil);
			Trigger(OBJECT_TOUCH_TRIGGER, "markalgate", nil);
			SetObjectiveState("obj3", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.captureTowns[2] = 10;
		end
	end,
	
	defeatMarkal = function()
		if OBJECTIVES.state.defeatMarkal[2] == 1 then
			SetObjectiveState("obj4", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.defeatMarkal[2] = 2;
		elseif OBJECTIVES.state.defeatMarkal[2] == 2 and IsHeroAlive("Heam") == not nil and IsHeroAlive("Godric") == not nil then
			Trigger(OBJECT_TOUCH_TRIGGER, "spes", "AreYouReady");
			Trigger(OBJECT_TOUCH_TRIGGER, "post", "AreYouReady");
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "gathering", "AreYouReady");
			OBJECTIVES.state.defeatMarkal[2] = 3;
		elseif OBJECTIVES.state.defeatMarkal[2] == 4 then
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "gathering", nil)
			Trigger(OBJECT_TOUCH_TRIGGER, "spes", nil);
			Trigger(OBJECT_TOUCH_TRIGGER, "post", nil);
			OBJECTIVES.state.defeatMarkal[2] = 5;
		elseif OBJECTIVES.state.defeatMarkal[2] == 6 then
			SetObjectOwner("spes", PLAYER_1);
			sleep(5);
			SetObjectiveState("obj4", OBJECTIVE_COMPLETED);
			OBJECTIVES.state.defeatMarkal[2] = 10;
		end
	end,
	
	isZehirAlive = function()
		if OBJECTIVES.state.isZehirAlive[2] == 1 and IsHeroAlive("Zehir") == nil then
			SetObjectiveState("obj5", OBJECTIVE_FAILED);
			OBJECTIVES.state.isZehirAlive[2] = 11;
		end
	end,
	
	isFindanAlive = function()
		if OBJECTIVES.state.isFindanAlive[2] == 1 then
			SetObjectiveVisible("obj6", not nil);
			OBJECTIVES.state.isFindanAlive[2] = 2;
		elseif OBJECTIVES.state.isFindanAlive[2] == 2 and IsHeroAlive("Heam") == nil then
			SetObjectiveState("obj6", OBJECTIVE_FAILED);
			OBJECTIVES.state.isFindanAlive[2] = 11;
		end
	end,
	
	isGodricAlive = function()
		if OBJECTIVES.state.isGodricAlive[2] == 1 then
			SetObjectiveVisible("obj7", not nil);
			OBJECTIVES.state.isGodricAlive[2] = 2;
		elseif OBJECTIVES.state.isGodricAlive[2] == 2 and IsHeroAlive("Godric") == nil then
			SetObjectiveState("obj7", OBJECTIVE_FAILED);
			OBJECTIVES.state.isGodricAlive[2] = 11;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)

------------------- DEBUG ------------------------
function C6M3_debug(eax, player)
	if eax == 0 then
		H55_Speedrun(1);
	elseif eax == 1 then
		MakeHeroInteractWithObject("Zehir", "prison")
	elseif eax == 2 then
		SetObjectPosition("Zehir", 29, 145, 0);
	elseif eax == 3 then
		SetObjectPosition("Zehir", 30, 110, 0);
	elseif eax == 4 then
		SetObjectPosition("Zehir", 84, 49, 0);
	elseif eax == 5 then
		for i=1, town_array.n do
			SetObjectOwner(town_array[i], player);
			sleep(5);
		end
	elseif eax == 6 then
		SetObjectPosition("Zehir", 38, 15, 0);
	end
end
