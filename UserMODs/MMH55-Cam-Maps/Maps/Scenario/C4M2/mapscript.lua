doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C4M2");
    LoadHeroAllSetArtifacts("Raelag", "C4M1" );
	sleep(30);
	H55_CamFixTooManySkills( PLAYER_1, "Raelag" );
end

startThread(H55_InitSetArtifacts);
H55_PlayerStatus = {0,1,1,2,2,2,2,2};

H55c_AI_CONTROLLED = {
  player1 = {
    state = 0,         -- 0 human player
    heroes = {},
    enemies = {},
  },
  player2 = {          -- Blue Dungeon AI player;
    state = 1,         -- AI player without specific purpose so control set to 1 (Unmanaged)
    heroes = {},
    enemies = {}
  },
  player3 = {          -- Soulscar Reinforcements
    state = 2,         -- AI player with specific purpose so control set to 2
    heroes = {},
    enemies = {
      { priority = 1.0, heroes = 1.0, towns = 0.7, is_enemy = 1 },  -- PLAYER1
      { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
      { priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 }   -- PLAYER3
    }
  }
}

function oracul(name)
	if name ~= 'Raelag' then
		MessageBox("/Maps/Scenario/C4M2/text/not_raelag.txt")	-- Another hero visits Malassa
		return
	end
	if OBJECTIVES.state.visitMalassa[2] == 1 then
		OBJECTIVES.state.visitMalassa[2] = 2;					-- Raelag visits Malassa first time
	else
		MessageBox("/Maps/Scenario/C4M2/text/visited.txt")		-- Raelag visits Malassa second time but nobody is home
	end
end

function town_capture( oldowner, newowner, heroname, objectname )
	if newowner == PLAYER_1 then
		Trigger(OBJECT_CAPTURE_TRIGGER, "town1", nil)
		Trigger(OBJECT_CAPTURE_TRIGGER, "town2", nil)
		Trigger(OBJECT_CAPTURE_TRIGGER, "town3", nil)
		OBJECTIVES.state.messengers[2] = 1;
		OBJECTIVES.state.captureTowns[2] = 3;
	end
end

ENEMY_HEROES = { "Eruina", "Almegir", "Dalom" };
function SendMessengers()
	while OBJECTIVES.state.messengers[2] < 10 do
		for i, hero in ENEMY_HEROES do
			if IsHeroAlive(hero) ~= nil then	
				pcall( MoveHero, hero, 59, 173, 0 )
			end
		end
		sleep(100);
	end
end

function remove_messanger(heroname)
	if GetObjectOwner(heroname) == PLAYER_2 then
		RemoveObject(heroname)
		SetAIPlayerAttractor('point1',PLAYER_2,0)
		SetAIPlayerAttractor('point2',PLAYER_2,0)
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'escape1', nil)
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'escape2', nil)
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'point1', nil)
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'point2', nil)
		OBJECTIVES.state.messengers[2] = 9;
	end
end

C4M2_INAGOST_ENTRY = {{ 59, 173, 0 }, { 2, 131, 0 }};
function C4M2_deployInaghost(rand)
	DeployReserveHero('Inagost', C4M2_INAGOST_ENTRY[rand][1], C4M2_INAGOST_ENTRY[rand][2], C4M2_INAGOST_ENTRY[rand][3])
	sleep(40);
	k = ( GetDate(MONTH) - 1 ) * 4 + GetDate(WEEK) + GetDifficulty();
	ChangeHeroStat( 'Inagost', STAT_EXPERIENCE, 12000 + k * 3000 )
	AddObjectCreatures('Inagost', 	  CREATURE_ASSASSIN, 200 + random(7) + k*7 )
	AddObjectCreatures('Inagost', 	   CREATURE_RAVAGER,  50 + random(4) + k*4 )
	AddObjectCreatures('Inagost', 	 CREATURE_MATRIARCH,  20 + random(2) + k*2 )
	AddObjectCreatures('Inagost', CREATURE_BLACK_DRAGON,   6 + k )
	H55c_AIAddHero('Inagost');
end

function C4M2_DefeatEnemyHeroes()
	local enemy = {};
	enemy = GetPlayerHeroes(PLAYER_2);
	for i, hero in enemy do
		RemoveObject(hero);
	end
end

CINEMATICS = {
	intro = function()
		StartDialogScene("/DialogScenes/C4/M2/D1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	captureGarrison = function()
		StartDialogScene("/DialogScenes/C4/M2/R1/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	captureAllTowns = function()
		StartDialogScene("/DialogScenes/C4/M2/R2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	messengersStart = function()
		StartDialogScene("/DialogScenes/C4/M2/R3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	messengersEscaped = function()
		StartDialogScene("/DialogScenes/C4/M2/R4/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	destroySoulscar = function()
		StartDialogScene("/DialogScenes/C4/M2/R5/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	townHasGrail = function()
		StartDialogScene("/DialogScenes/C4/M2/R6/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	C4M2R7 = function()
		StartDialogScene("/DialogScenes/C4/M2/R7/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	meetMalassa = function()
		StartDialogScene("/DialogScenes/C4/M2/D2/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
	
	meetShadya = function()
		StartDialogScene("/DialogScenes/C4/M2/D3/DialogScene.xdb#xpointer(/DialogScene)");
		sleep( 2 );
	end,
}

OBJECTIVES = {
	state = {
		   visitMalassa = { "prim1", 1 },		-- Visit daughter of Malassa
			 buildGrail = { "prim2", 0 },		-- Build the Grail in Argkath
		   captureTowns = { "prim3", 1 },		-- Capture all Dungeon towns
		  isShadyaAlive = { "prim5", 0 },		-- Raelag must survive
		  isRaelagAlive = { "prim6", 1 },		-- Shadya must survive
			 messengers = {  "sec1", 0 },		-- Stop Dungeon messengers from calling reinforcements
		destroySoulscar = {  "sec2", 1 },       -- Destroy Soulscar army
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		SetRegionBlocked("a1", 1, PLAYER_2);
		SetRegionBlocked("a2", 1, PLAYER_2);
		SetRegionBlocked("a3", 1, PLAYER_2);
		SetRegionBlocked("a4", 1, PLAYER_2);
		SetRegionBlocked("b1", 1, PLAYER_2);
		SetRegionBlocked("c1", 1, PLAYER_2);
		SetRegionBlocked("c2", 1, PLAYER_2);
		SetRegionBlocked("c3", 1, PLAYER_2);
		SetPlayerHeroesCountNotForHire( PLAYER_1, 4 )
		DestroyTownBuildingToLevel( "Angkar", TOWN_BUILDING_SPECIAL_4, 0, 0 );
		Trigger( OBJECT_CAPTURE_TRIGGER, "town1", "town_capture" )
		Trigger( OBJECT_CAPTURE_TRIGGER, "town2", "town_capture" )
		Trigger( OBJECT_CAPTURE_TRIGGER, "town3", "town_capture" )
		CINEMATICS.intro();
		OpenCircleFog( 46, 137, 1, 5, PLAYER_1 );
		SetAIPlayerAttractor( 'point1', PLAYER_2, -1 )
		SetAIPlayerAttractor( 'point2', PLAYER_2, -1 )
		SetObjectEnabled('oracul', nil)
		Trigger(OBJECT_TOUCH_TRIGGER, "oracul", "oracul");
		sleep(20);
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
			
			if GetObjectiveState("prim2") == OBJECTIVE_FAILED or GetObjectiveState("prim5") == OBJECTIVE_FAILED or GetObjectiveState("prim6") == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED and GetObjectiveState('prim3') == OBJECTIVE_COMPLETED then
				SaveHeroAllSetArtifactsEquipped("Raelag", "C4M2");
				sleep(50)
				Win();
			end
		end
	end,
	
	visitMalassa = function()
		-- start of this task is handled by C4M2.xdb
		if OBJECTIVES.state.visitMalassa[2] == 2 then
			CINEMATICS.meetMalassa() --Сцена посещения оракула
			OpenCircleFog( 28, 139, 1, 5, PLAYER_1 );
			sleep(1)
			SetObjectiveState('prim1', OBJECTIVE_COMPLETED)
			GiveExp( "Raelag", 500 );
			OBJECTIVES.state.buildGrail[2] = 1;
			OBJECTIVES.state.visitMalassa[2] = 10;
		end
	end,
	
	buildGrail = function()
		-- completion of this task is handled by C4M2.xdb
		if OBJECTIVES.state.buildGrail[2] == 1 then
			SetObjectiveState("prim2", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.buildGrail[2] = 2;
		elseif OBJECTIVES.state.buildGrail[2] == 2 and IsAnyHeroPlayerHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) ~= nil then
			OBJECTIVES.state.buildGrail[2] = 4;
		elseif OBJECTIVES.state.buildGrail[2] == 4 then
			if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
				ChangeHeroStat("Raelag", STAT_LUCK, 3);
				CINEMATICS.townHasGrail(); --Сцена после постройки грааля
				OBJECTIVES.state.buildGrail[2] = 10;
			elseif IsAnyHeroPlayerHasArtifact( PLAYER_1, ARTIFACT_GRAAL ) == nil then
				SetObjectiveState("prim2", OBJECTIVE_FAILED);
				OBJECTIVES.state.buildGrail[2] = 11;
			end
		end
	end,
	
	captureTowns_KhelodinArrive = 0,
	captureTowns = function()
		if OBJECTIVES.state.captureTowns[2] == 1 and ( GetObjectOwner("post1") == PLAYER_1 or GetObjectOwner("post2") == PLAYER_1 ) then
			CINEMATICS.captureGarrison(); --Сцена посещения гарнизона
			SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE )
			OBJECTIVES.state.captureTowns[2] = 2;
		elseif OBJECTIVES.state.captureTowns[2] == 3 then  
			OBJECTIVES.captureTowns_KhelodinArrive = OBJECTIVES.date + 1;
			OBJECTIVES.state.captureTowns[2] = 4;
		elseif OBJECTIVES.state.captureTowns[2] == 4 and OBJECTIVES.captureTowns_KhelodinArrive <= OBJECTIVES.date then
			DeployReserveHero('Kelodin', 14, 156, 1);
			CINEMATICS.meetShadya();
			sleep(20);
			OBJECTIVES.state.isShadyaAlive[2] = 1;
			OBJECTIVES.state.captureTowns[2] = 5;
		end
		
		if GetObjectiveState('prim3') == OBJECTIVE_COMPLETED then
			ChangeHeroStat("Raelag", STAT_LUCK, 3);  -------Oblico_Morale!
			startThread( C4M2_DefeatEnemyHeroes );
			CINEMATICS.captureAllTowns(); --Сцена на захват всех городов клана
			OBJECTIVES.state.captureTowns[2] = 10;
		end
	end,
	
	isShadyaAlive = function()
		if OBJECTIVES.state.isShadyaAlive[2] == 1 and IsHeroAlive("Kelodin") == nil then
			SetObjectiveState( 'prim5', OBJECTIVE_FAILED );
			OBJECTIVES.state.isShadyaAlive[2] = 11;
		end
	end,
	
	isRaelagAlive = function()
		if OBJECTIVES.state.isRaelagAlive[2] == 1 and IsHeroAlive("Raelag") == nil then
			SetObjectiveState( 'prim6', OBJECTIVE_FAILED );
			OBJECTIVES.state.isRaelagAlive[2] = 11;
		end
	end,
	
	messengers = function()
		if OBJECTIVES.state.messengers[2] == 1 then
			CINEMATICS.messengersStart(); -- Сцена на захват перврго города.
			SetObjectiveState('sec1', OBJECTIVE_ACTIVE)
			startThread( SendMessengers );
			Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'escape1', 'remove_messanger')
			Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, 'escape2', 'remove_messanger')
			OBJECTIVES.state.messengers[2] = 2;		
		elseif OBJECTIVES.state.messengers[2] == 9 then
			CINEMATICS.messengersEscaped(); --Сцена если пропустили гонцов
			SetObjectiveState( 'sec1', OBJECTIVE_FAILED );
			OBJECTIVES.destroySoulscar_arrivalDay = OBJECTIVES.date + 7 - GetDifficulty();
			OBJECTIVES.state.messengers[2] = 11;
		end
		
		if OBJECTIVES.state.captureTowns[2] == 10 then
			SetObjectiveState( 'sec1', OBJECTIVE_COMPLETED );
			OBJECTIVES.state.messengers[2] = 10;
		end
	end,
	
	destroySoulscar_arrivalDay = 99999,
	destroySoulscar = function()
		if OBJECTIVES.state.destroySoulscar[2] == 1 and OBJECTIVES.date >= OBJECTIVES.destroySoulscar_arrivalDay then
			SetObjectiveState( 'sec2', OBJECTIVE_ACTIVE ); ------Появляется герой противника!!!!
			C4M2_deployInaghost(math.random(2))
			OBJECTIVES.state.destroySoulscar[2] = 2;
		elseif OBJECTIVES.state.destroySoulscar[2] == 2 and IsHeroAlive("Inagost") == nil then
			CINEMATICS.destroySoulscar() --Сцена когда разгромим пришедшего героя
			SetObjectiveState( 'sec2', OBJECTIVE_COMPLETED );
			GiveExp( "Raelag", 3000 );
			OBJECTIVES.state.destroySoulscar[2] = 10;
		end
	end
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
startThread( H55c_AI_main );
