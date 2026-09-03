doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts do
    sleep()
end

H55_PlayerStatus = {0,1,2,2,2,2,2,2};

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C2M2");
    LoadHeroAllSetArtifacts( "Agrael", "C2M1" );
	sleep(40); -- wait for artifacts to load
	H55_CamFixTooManySkills( PLAYER_1, "Agrael" );
end

startThread(H55_InitSetArtifacts);

DIFFICULTY = {
	[0] = function()
		print("Difficulty level is normal");
		SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 10, 0, 10000);
		SetPlayerStartResource( PLAYER_1, GOLD, 10000 );
		AddHeroCreatures("Agrael",CREATURE_FAMILIAR,30);
		AddHeroCreatures("Agrael",CREATURE_HORNED_DEMON,20);
		AddHeroCreatures("Agrael",CREATURE_HELL_HOUND,15);
		AddHeroCreatures("Agrael",CREATURE_NIGHTMARE,8);
		startThread(RemoveVeyerMP(2));
	end,
	
	[1] = function()
		print("Difficulty level is hard");
		SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 5, 0, 8000);
		startThread(RemoveVeyerMP(3));
		AddHeroCreatures("Agrael",CREATURE_FAMILIAR,20);
		AddHeroCreatures("Agrael",CREATURE_HORNED_DEMON,15);
		AddHeroCreatures("Agrael",CREATURE_HELL_HOUND,10);
		AddHeroCreatures("Agrael",CREATURE_NIGHTMARE,6);
		AddHeroCreatures("Mardigo", CREATURE_ARCHANGEL, 1);
		AddHeroCreatures("Mardigo", CREATURE_PALADIN, 2);
		AddHeroCreatures("Mardigo", CREATURE_ROYAL_GRIFFIN, 5);
		AddHeroCreatures("Mardigo", CREATURE_MARKSMAN, 12);			
	end,
	
	[2] = function()
		print("Difficulty level is heroic");
		SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 6000);
		AddHeroCreatures("Mardigo", CREATURE_ARCHANGEL, 2);
		AddHeroCreatures("Mardigo", CREATURE_PALADIN, 4);
		AddHeroCreatures("Mardigo", CREATURE_ROYAL_GRIFFIN, 10);
		AddHeroCreatures("Mardigo", CREATURE_MARKSMAN, 24);
	end,
	
	[3] = function()
		print("Difficulty level is impossible");
		SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 4000);
		AddHeroCreatures("Mardigo", CREATURE_ARCHANGEL, 3);
		AddHeroCreatures("Mardigo", CREATURE_PALADIN, 6);
		AddHeroCreatures("Mardigo", CREATURE_ROYAL_GRIFFIN, 15);
		AddHeroCreatures("Mardigo", CREATURE_MARKSMAN, 36);
	end,
}

function RemoveVeyerMP(part)
	while 1 do
		repeat sleep(10) until GetCurrentPlayer() == PLAYER_2
		print("Player's 2 turn");
		delta_MP = (GetHeroStat("Veyer",STAT_MOVE_POINTS) - mod (GetHeroStat("Veyer",STAT_MOVE_POINTS),part))/part;
		print("Hero has ",GetHeroStat("Veyer",STAT_MOVE_POINTS)," move points; delta = ",delta_MP );
		ChangeHeroStat("Veyer",STAT_MOVE_POINTS,-delta_MP);
		sleep(10);
		print("Now hero has ",GetHeroStat("Veyer",STAT_MOVE_POINTS));
		repeat sleep(10) until GetCurrentPlayer() ~= PLAYER_2;
		print("End of player's 2 turn");	
	end
end

function meetAssassins(hero, object)
	assasins_ambush = assasins_ambush + 1;
	Trigger(OBJECT_TOUCH_TRIGGER, object, nil);
	SetObjectEnabled( object, not nil );
	if assasins_ambush == 2 then
		MessageBox( "/Maps/Scenario/C2M2/messages/C2M2_assasin1.txt", "AddHeroCreatures('Agrael', CREATURE_ASSASSIN, random(20) + 20)" );
	else
		MessageBox( "/Maps/Scenario/C2M2/messages/C2M2_assasin.txt", "Ambush" );
	end
end

function Ambush()
	local rnd_slots = random( 2 ) + 1;
	if rnd_slots == 1 then
		StartCombat( "Agrael", nil, 1, CREATURE_ASSASSIN, random(20) + 30, nil, nil);
	elseif rnd_slots == 2 then
		StartCombat( "Agrael", nil, 2, CREATURE_ASSASSIN, random(10) + 20, CREATURE_ASSASSIN, random(10) + 20, nil, nil);
	elseif rnd_slots == 3 then
		StartCombat( "Agrael", nil, 3, CREATURE_ASSASSIN, random(10) + 20, CREATURE_SCOUT, random(10) + 20, CREATURE_SCOUT, random(10) + 20, nil, nil);
	end
end

function ReachMausoleum(hero)
	if hero == 'Agrael' then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,  'crypt', nil );
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, 'crypt2', nil );
		OBJECTIVES.state.getGriffinHeart[2] = 2;
	end
end

function LooseIfVeyerFaster()
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "crypt2", nil);
	SetObjectiveState("prim1", OBJECTIVE_FAILED);
end

function disableDwelling(hero, object)
	SetObjectEnabled(object, nil);
	print("Military post has been disabled...");
	Trigger(OBJECT_TOUCH_TRIGGER, object, nil);
end

function VeyerHasNoWay()
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "VeyerStop", nil );
	SetRegionBlocked("VeyerStop2", not nil);
	print("Veyer can not return back.");
end

BATTLES = {
	stephanAttack = function()
		local Agrael_x, Agrael_y = GetObjectPosition( 'Agrael' );
		MoveHeroRealTime('Mardigo', Agrael_x, Agrael_y , 0 );
		repeat sleep(20) until IsHeroAlive('Mardigo') == nil
	end,
	
	veyerAttack = function()
		local Agrael_x, Agrael_y = GetObjectPosition( 'Agrael' );
		ChangeHeroStat( "Veyer", STAT_MOVE_POINTS, 4000 );
		MoveHeroRealTime( "Veyer", Agrael_x, Agrael_y , 0 );
	end,
}

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C2/M2/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	stephanAttack = function()
		StartDialogScene("/DialogScenes/C2/M2/D2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	veyerAttack = function()
		StartDialogScene("/DialogScenes/C2/M2/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	outro = function()
		StartCutScene("/Maps/Cutscenes/C2M2/_.(AnimScene).xdb#xpointer(/AnimScene)");
		sleep(2);
	end,
}

OBJECTIVES = {
	state = {
		getGriffinHeart	= { "prim1", 1 },	-- Capture the Heart of the Griffin
		isAlive			= { "prim2", 1 },	-- Agrael must survive
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		assasins_ambush = 0;
		OpenCircleFog(  64, 125, 0, 15, PLAYER_1 );
		OpenCircleFog( 104,   3, 0, 15, PLAYER_1 );
		SetObjectEnabled("loot2", nil);
		SetObjectEnabled("loot4", nil);
		EnableHeroAI("Mardigo", nil);
		DIFFICULTY[GetDifficulty()]();
		Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'crypt', "ReachMausoleum" );
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "crypt2", "LooseIfVeyerFaster");
		Trigger(OBJECT_TOUCH_TRIGGER, "loot2", "meetAssassins");
		Trigger(OBJECT_TOUCH_TRIGGER, "loot4", "meetAssassins");
		SetAIHeroAttractor( "mausoleum","Veyer", 2 );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "VeyerStop", "VeyerHasNoWay" ); -- cut Veyer path back so he moves forward
		for i, dwelling in { "military", "sotona", "konura", "besovstvo" } do
			Trigger(OBJECT_TOUCH_TRIGGER, dwelling, "disableDwelling");				-- disable dwellings Veyer visits so he does not need to visit them again
		end
		CINEMATICS.intro();
		print("All triggers and functions run");
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

			if GetObjectiveState("prim1") == OBJECTIVE_FAILED or GetObjectiveState("prim2") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("prim1") == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Agrael", "C2M2");
				Save("SaveName");
				CINEMATICS.outro();
				sleep(100);
				Win();
				return
			end
		end
	end,
	
	getGriffinHeart = function()
	-- task started is handled by C2M2.xdb
		if OBJECTIVES.state.getGriffinHeart[2] == 2 then
			BlockGame();
			SetObjectPosition( "Veyer", 72, 118, 0 );
			CINEMATICS.stephanAttack();
			BATTLES.stephanAttack();
			UnblockGame();
			repeat sleep(20) until IsHeroAlive("Mardigo") == nil
			BlockGame();
			CINEMATICS.veyerAttack();
			BATTLES.veyerAttack();
			repeat sleep(20) until IsHeroAlive("Veyer") == nil
			UnblockGame();
			SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED);
			OBJECTIVES.state.getGriffinHeart[2] = 10;
		end
	end,

	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState("prim2", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 and IsHeroAlive('Agrael') == nil then
			SetObjectiveState("prim2", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)

function c2m2_dbg(var)
	if var == 1 then
		H55_Speedrun(1);
		SetObjectPosition("Agrael", 51, 114, 0);
	end
end
