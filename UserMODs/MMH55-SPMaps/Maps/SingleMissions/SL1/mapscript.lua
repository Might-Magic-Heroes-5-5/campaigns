doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
end

function diffsetup()
	for i, object in {"o1", "o2", "o3", "o4", "o5", "o6", "o7", "o8", "o9"} do
		for creatureID = 1, 91 do 
			CreatureSetUp = GetObjectCreatures(object, creatureID);
			if GetObjectCreatures(object, creatureID) > 2 then
				RemoveObjectCreatures(object, creatureID, CreatureSetUp);
				AddObjectCreatures(object, creatureID, CreatureSetUp * diff);
			end
		end
	end
end

function MaahirHasSarIsusSet()
	for i, artifact in { ARTIFACT_RING_OF_MAGI, ARTIFACT_CROWN_OF_MAGI, ARTIFACT_ROBE_OF_MAGI, ARTIFACT_STAFF_OF_MAGI } do
		if HasArtefact( "Maahir", artifact ) == nil then
			return nil
		end
	end
	return 1
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
		StartDialogScene("/DialogScenes/Single/SL1/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	findRing = function()
		StartDialogScene("/DialogScenes/Single/SL1/R5/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	findRobe = function()
		StartDialogScene("/DialogScenes/Single/SL1/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	findCrown = function()
		StartDialogScene("/DialogScenes/Single/SL1/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	findStaff = function()
		StartDialogScene("/DialogScenes/Single/SL1/R4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
	
	outro = function()
		StartDialogScene("/DialogScenes/Single/SL1/R8/DialogScene.xdb#xpointer(/DialogScene)");
		sleep(2);
	end,
}

DIFFICULTY = {
	[0] = function()
		diff = 0.5;
	    print ("normal");
	end,
	
	[1] = function()
		diff = 1;
	    print ("hard");
	end,
	
	[2] = function()
		diff = 2;
	    print ("heroic");
	end,
		
	[3] = function()
		diff = 3;
	    print ("Impossible");
	end,
}

OBJECTIVES = {
	date = 0,
	state = {
		hasArtifacts = { "obj1", 1 },  -- Maahir should collect full SarIssus set
		defeatAberar = { "obj2", 1 },  -- defeat Necromancer Aberar
		isAlive		 = { "obj3", 1 },  -- Maahir must survive
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		SetRegionBlocked("at1", not nil, PLAYER_2);
		SetRegionBlocked("at2", not nil, PLAYER_2);
		SetRegionBlocked("at3", not nil, PLAYER_2);
		SetRegionBlocked("at4", not nil, PLAYER_2);
		Trigger(OBJECT_TOUCH_TRIGGER, "a1",  "CINEMATICS.findRobe" );
		Trigger(OBJECT_TOUCH_TRIGGER, "a2", "CINEMATICS.findCrown" );
		Trigger(OBJECT_TOUCH_TRIGGER, "a3", "CINEMATICS.findStaff" );
		Trigger(OBJECT_TOUCH_TRIGGER, "a4",  "CINEMATICS.findRing" );
		DIFFICULTY[GetDifficulty()]();
		startThread(diffsetup);
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

			if GetObjectiveState("obj3") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("obj1") == OBJECTIVE_COMPLETED and GetObjectiveState("obj2") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep(100);
				Win( PLAYER_1 );
				return
			end
		end
	end,
	
	defeatAberar = function()
		if OBJECTIVES.state.defeatAberar[2] == 1 and IsHeroAlive("Aberrar") == nil then
			SetObjectiveState( 'obj2', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.defeatAberar[2] = 10;
		end
	end,
	
	hasArtifacts = function()
		if OBJECTIVES.state.hasArtifacts[2] == 1 and MaahirHasSarIsusSet() ~= nil then
			SetObjectiveState( 'obj1', OBJECTIVE_COMPLETED );
			local res = GetPlayerResource(PLAYER_1, GOLD) + 10000
			SetPlayerResource(PLAYER_1, GOLD, res);
			LevelUpHero("Maahir");
			OBJECTIVES.state.hasArtifacts[2] = 10;
		end
	end,
		
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Maahir") == nil then
			SetObjectiveState( 'obj3', OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
}

------------------- MAIN ------------------------
startThread(OBJECTIVES.start)

function sl1_dbg(var)
	if var == 1 then
		MakeHeroInteractWithObject("Maahir", "a1" );
	elseif var == 11 then
		MakeHeroInteractWithObject("Maahir", "a2" );
	elseif var == 111 then
		MakeHeroInteractWithObject("Maahir", "a3" );
	elseif var == 1111 then
		MakeHeroInteractWithObject("Maahir", "a4" );
	elseif var == 2 then
		RemoveObject("Aberrar");
	end
end
