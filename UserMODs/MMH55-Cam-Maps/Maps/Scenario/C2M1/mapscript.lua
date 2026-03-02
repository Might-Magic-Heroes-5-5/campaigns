doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C2M1");
end;

startThread(H55_InitSetArtifacts);
-----------------------------------------------------------

OUR_HERO_NAME = "Agrael"
ENEMY_HERO_NAME = "Godric";

function EngageHero( heroname )
	while IsHeroAlive( ENEMY_HERO_NAME ) do
		while GetCurrentPlayer() ~= PLAYER_2 or not ((GetDate(DAY_OF_WEEK) == 1) or (GetDate(DAY_OF_WEEK) == 3) or (GetDate(DAY_OF_WEEK) == 5) or (GetDate(DAY_OF_WEEK) == 7)) do
			sleep( 1 );
		end
		MoveHero( ENEMY_HERO_NAME, GetObjectPosition( heroname ) );
		EnableHeroAI("Godric", not nil)
		while GetCurrentPlayer() ~= PLAYER_1 do
			sleep( 1 );
		end
	end
end

function Warningmess()
	if IsPlayerHeroesInRegion(1, "Typit") == not nil then
		sleep( );
		MessageBox ("/Maps/Scenario/C2M1/warn1.txt");
	end
end

function GetHeroCoord()
	local cx,cy,cl;
	local heroes = {};
	local m = 0;
	local hero;
	heroes = GetObjectsInRegion( "ambush", OBJECT_HERO );
	for m, h in heroes do
		if GetObjectOwner( h ) == PLAYER_1 then
			cx,cy,cl = GetObjectPos(h);
			hero = h;
			return cx,cy,cl,hero;
		end;
	end;
end;

function witch_hut_first_visit(HeroName)
	if HeroName == OUR_HERO_NAME then
		print(HeroName, " has visited witch hut");
		MessageBox("/Maps/Scenario/C2M1/MessageBox_WitchHutFirstVisit.txt");
		MarkObjectAsVisited("witch_hut",HeroName);
		GiveHeroSkill(HeroName,SKILL_LOGISTICS);
		Trigger(OBJECT_TOUCH_TRIGGER,"witch_hut","witch_hut_already_visited");
	else
		print("Another hero touch witch hut. It is ", HeroName);
	end
end

function witch_hut_already_visited(HeroName)
	if HeroName == OUR_HERO_NAME then
		print(HeroName, " has visited witch hut one more time");
		MessageBox("/Maps/Scenario/C2M1/MessageBox_WitchHutAlreadyVisited.txt");
		Trigger(OBJECT_TOUCH_TRIGGER,"witch_hut","witch_hut_already_visited");
	else
		print("Another hero touch witch hut. It is ", HeroName);
	end
end

function SetMPFactorForGodric()
	if GetDifficulty() == NORMAL then
		MPFactor = 3;
		startThread(TriggerPlayer);
		print("Difficulty level is NORMAL. MPFactor = ", MPFactor);
	else
		if GetDifficulty() == HARD then
			MPFactor = 6;
			startThread(TriggerPlayer);
			print("Difficulty level is HARD. MPFactor = ", MPFactor);
		else
			print("Difficulty level is HEROIC or IMPOSSIBLE");
		end
	end
end

function SetGodricMovePoints()
	print("Thread SetGodricMovePoints has been started...");
	if IsHeroAlive("Godric") == not nil then
		print("Godric is moving");
		GodricMP = GetHeroStat("Godric",STAT_MOVE_POINTS);
		print("Godric has ",GodricMP ," Move Points");
		delta = (GodricMP - mod(GodricMP,MPFactor)) / MPFactor;
		print("delta = ",delta);
		ChangeHeroStat("Godric",STAT_MOVE_POINTS,-delta);
		sleep(5);
		print("Stats changed. Now Godric has ",GetHeroStat("Godric",STAT_MOVE_POINTS)," Move Points");
	else
		print("Hero Godric does not exist or dead.");
	end;
end;

function TriggerPlayer()
	print("Thread TriggerPlayer has been started...");
	while 1 do
		CurrentPlayer = GetCurrentPlayer();
		while CurrentPlayer == GetCurrentPlayer() do
			CurrentPlayer = GetCurrentPlayer();
			sleep(2);
		end;
		print("Player triggered");
		if CurrentPlayer == PLAYER_1 then
			print("PLAYER'S 1 turn");
			startThread(SetGodricMovePoints);
			else
			if CurrentPlayer == PLAYER_3 then
				print("PLAYER'S 3 turn");
			else
				print("PLAYER'S 2 turn");
			end
		end
		sleep(10);
	end
end

function _subPassage()
	while 1 do
        sleep(30);
		if IsObjectVisible(PLAYER_1, "SubPassage") then
			CINEMATICS.subPassage();
			break
		end
	end
end
	
CINEMATICS = {
  intro = function()
  	StartDialogScene("/DialogScenes/C2/M1/D1/DialogScene.xdb#xpointer(/DialogScene)");
  	sleep( 2 );
  end,
  
  subPassage = function()
	StartDialogScene("/DialogScenes/C2/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
    sleep( 2 );
  end,
  
  marderSpeech = function()
	StartDialogScene("/DialogScenes/C2/M1/R2/DialogScene.xdb#xpointer(/DialogScene)");
    sleep( 2 );
  end,
  
  outro = function()
	StartDialogScene("/DialogScenes/C2/M1/D2/DialogScene.xdb#xpointer(/DialogScene)");
	sleep( 2 );
  end,
}

OBJECTIVES = {
  state = { -- 0 quest is not active or managed by map.xdb, 1 quest is active, 2-9 custom states, 10 success, 11 fail
    routeToSheogath = { "prim1", 1 },   -- 2 Godric captures Dunmor and learns he has to free Isabel ASAP, 3 Isabel is freed, 10 Isabel is free and Dunmor is captured, 11 on 8th day mission will fail
    isAlive         = { "prim2", 1 },
  },

  start = function()
    OBJECTIVES.prepare();
    OBJECTIVES.run();
  end,

  prepare = function()
    -- Prepare Player 1
    SetPlayerResource(1, 0, 0);
    SetPlayerResource(1, 1, 0);
    SetPlayerResource(1, 2, 0);
    SetPlayerResource(1, 3, 0);
    SetPlayerResource(1, 4, 0);
    SetPlayerResource(1, 5, 0);
    SetPlayerResource(1, 6, 0);
	
    -- Prepare Player 2 heroes
	EnableHeroAI("Brem",nil);
	EnableHeroAI("Godric",nil);
    H55_CamFixTooManySkills(PLAYER_2,"Godric");
	SetRegionBlocked("keyreg", 1, PLAYER_2); -- Block Godric from accesing keyring tent checkpoint
    SetRegionBlocked("block",  1, PLAYER_2); -- Block Godric from passing through Garrison 
    SetRegionBlocked("block1", 1, PLAYER_2); -- Block Godric from underground staircase
    SetRegionBlocked("Art1",   1, PLAYER_2); -- Block Godric from being able to collect WayFarer boots artifact
    SetRegionBlocked("Art2",   1, PLAYER_2); -- Block Godric from being able to collect random artifact
	
	-- Prepare Player 3 heroes
    DeployReserveHero( "Marder", 27, 9, GROUND )
    sleep(10);
    EnableHeroAI( "Marder", nil );
    MoveHero( "Marder", 26, 9, GROUND );
	sleep(10);
	CINEMATICS.intro();
	
	SetObjectEnabled("witch_hut",nil);
	Trigger(OBJECT_TOUCH_TRIGGER,"witch_hut","witch_hut_first_visit");
    Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Typit", "Warningmess" ); -- Garnison Warning
	startThread( _subPassage );
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
      
			if GetObjectiveState( "prim1") == OBJECTIVE_FAILED or GetObjectiveState( 'prim2') == OBJECTIVE_FAILED then
				Loose();
				return
			end
	
			if GetObjectiveState( "prim1") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				Win();
				return
			end
		end
	end,
  
  routeToSheogath = function()
     -- start of this task is handled by C2M1.xdb
	 
	 if OBJECTIVES.state.routeToSheogath[2] == 1 and (GetDate(DAY_OF_WEEK) == 3 ) then
		SetObjectPosition("Godric", 6, 90, 0);
		MoveCamera(6, 90, 0, 50, 1);
		sleep(6);
		EnableHeroAI("Godric",not nil);
		EnableHeroAI("Brem",not nil);
		sleep(2);
		startThread( EngageHero, OUR_HERO_NAME );
		startThread(SetMPFactorForGodric);
		OBJECTIVES.state.routeToSheogath[2] = 2
	end
	
	if OBJECTIVES.state.routeToSheogath[2] < 9 and IsPlayerHeroesInRegion( PLAYER_1, "ambush" ) then
		cx,cy,cl,h = GetHeroCoord("Agrael");
		ChangeHeroStat( "Agrael", STAT_MOVE_POINTS, -30000 );
		BlockGame();
		ChangeHeroStat( "Marder", STAT_MOVE_POINTS, 30000 );
		MoveHeroRealTime( "Marder", 12, 9, GROUND );
		sleep(20);
		CINEMATICS.marderSpeech();
		sleep(20);
		MoveHeroRealTime( "Marder", cx, cy, GROUND );
		UnblockGame();
		EnableHeroAI("Marder", not nil);
		OBJECTIVES.state.routeToSheogath[2] = 9;
	end
	
    if IsHeroAlive("Marder") == nil then	
		SaveHeroAllSetArtifactsEquipped("Agrael", "C2M1");
		sleep(4);
		Save("Save");
		sleep(20);
		SetObjectiveState('prim1', OBJECTIVE_COMPLETED);
		OBJECTIVES.state.routeToSheogath[2] = 10;
	end
  end,
  
  isAlive = function()
    -- start of this task is handled by C2M1.xdb
	if IsHeroAlive("Agrael") == nil then
		SetObjectiveState('prim2',OBJECTIVE_FAILED);
		sleep(2);
		OBJECTIVES.state.routeToSheogath[2] = 10;
	end
  end
} 

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
