doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
end

H55_PlayerStatus = {0,1,1,2,2,2,2,2};

outpost_heroes = { "RedHeavenHero02" }
function HeroesSetUp()
	for i,hero in outpost_heroes do
		print( hero );
		for creatureID = 1, CREATURES_COUNT - 1 do 
			local CreatureSetUp = GetHeroCreatures( hero, creatureID );
			if GetHeroCreatures( hero, creatureID) > 1 then
				RemoveHeroCreatures( hero, creatureID, CreatureSetUp );
				AddHeroCreatures( hero, creatureID, CreatureSetUp + (CreatureSetUp / 100 * 40) * diff );
			end
		end
	end
end

outpost_towns = {"htown", "MageTown1", "MageTown"};
function AllTownsSetUp()
	for i,town in outpost_towns do
		print( town );
		for creatureID = 1, CREATURES_COUNT - 1 do 
			local CreatureSetUp = GetObjectCreatures( town, creatureID );
			if GetObjectCreatures( town, creatureID ) > 2 then
				RemoveObjectCreatures( town, creatureID, CreatureSetUp );
				AddObjectCreatures( town, creatureID, CreatureSetUp + (CreatureSetUp / 100 * 40) * diff );
				print( creatureID );
			end
		end
	end
end

function guide_message()
	Trigger( OBJECT_TOUCH_TRIGGER, "shipyard", nil );
	local x, y, z = GetObjectPosition( "Hero4" );
	OpenCircleFog(12, 120, GROUND, 5, PLAYER_1);
	MoveCamera(12, 120, GROUND, 25, 3.14/3, 0, 1, 1, 1);
	sleep( 60 );
	MessageBox("/Maps/SingleMissions/a2s5/message02.txt");
	sleep( 20 );
	MoveCamera(x, y, z, 25, 3.14/3, 0, 1, 1, 1);
end

function openPrison( hero )
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger(OBJECT_TOUCH_TRIGGER, "prison", nil);
		OBJECTIVES.state.releaseHero[2] = 3;
	end
end

function findPrison( hero )
	if GetObjectOwner(hero) == PLAYER_1 then
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "VoiceOverRegion4", nil );
		OBJECTIVES.state.releaseHero[2] = 1;
	end
end

function BurnHut( hero, object )
	if GetObjectOwner(hero) == PLAYER_1 and IsObjectExists( object ) == not nil then
		PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", object, 0, 0, 0, GROUND ); 
		PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)", object, 0, 0, 0, GROUND ); 
		RazeBuilding( object );
	end
end

A2S5_MAGE_TOWNS = {
	["MageTown"]  = { coverted = nil },
	["MageTown1"] = { coverted = nil },
}

function ConvertTown( oldOwner, newOwner, heroName, object )
	if newOwner == PLAYER_1 and A2S5_MAGE_TOWNS[object].coverted == nil then
		A2S5_MAGE_TOWNS[object].coverted = 1;
		TransformTown( object, TOWN_STRONGHOLD );
	end
end

function VoiceOver10( hero )
	if hero == "Hero4" then	
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "VoiceOverRegion10", nil);
		Play2DSound( "/Maps/SingleMissions/A2S5/SM5_VO10_Batu_01sound.xdb#xpointer(/Sound)" );
	end
end

function GetMageTownsCaptured()
	local count = 0;
	for i, town in { "MageTown", "MageTown1" } do
		if GetObjectOwner(town) == PLAYER_1 then
			count = count + 1;
		end
	end
	return count
end

DIFFICULTY = {
	[0] = function()
		diff = 1;
		print ("normal");
	end,

	[1] = function()
		diff = 2;
		print ("hard");
	end,

	[2] = function()
		diff = 3;
		print ("heroic");
	end,

	[3] = function()
		diff = 4;
		print ("impossible");
	end,
}

CINEMATICS = {
	intro = function()
		StartDialogScene( "/DialogScenes/A2Single/SM5/S1/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep( 2 );
	end,

	releaseHero = function()
		StartAdvMapDialog( 0 );
	end,

	showRocksDisappear = function()
		local hero_x, hero_y = GetObjectPosition( "Hero4" );
		OpenCircleFog( 80, 82, GROUND, 8, PLAYER_1 );
		MoveCamera( 80, 82, GROUND, 25, 3.14/3, 0, 1, 1, 1, 0 );
		sleep( 20 );
		pcall(RemoveObject, "Whirlpool");
		pcall(RemoveObject, "WhirlpoolFx");
		sleep( 60 );
		MoveCamera( hero_x, hero_y, GROUND, 25, 3.14/3, 0, 1, 1, 1, 0 );
	end,

	outro = function()
		StartDialogScene( "/DialogScenes/A2Single/SM5/S2/DialogScene.xdb#xpointer(/DialogScene)" );
		sleep( 2 );
	end,
}

OBJECTIVES = {
	date = 0,
	state = {
		escapeToIslands = { 					'obj1', 1 },
		releaseHero 	   = { 					'obj3', 0 },
		defeatFalconArmy   = { 					'obj4', 1 },
		isAlive 		   = { 					'obj5', 1 },
		captureTowns	   = { 'Sec1_CaptureMageTowns', 1 },
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		CINEMATICS.intro();
		DIFFICULTY[GetDifficulty()]();
		AllTownsSetUp();
		HeroesSetUp();
		EnableAIHeroHiring(PLAYER_2, "htown", nil);
		SetHeroRoleMode( 'RedHeavenHero02', HERO_ROLE_MODE_HERMIT );
		SetPlayerStartResources( PLAYER_1, 0, 0, 0, 0, 0, 0, 0 );
		OpenCircleFog( 21, 20, GROUND, 10, PLAYER_1 ); -- show Orc town
		SetRegionBlocked(  "AiBlock", not nil, PLAYER_2 );
		SetRegionBlocked( "AiBlock1", not nil, PLAYER_2 );
		SetRegionBlocked( "AiBlock2", not nil, PLAYER_2 );
		SetRegionBlocked( "AiBlock3", not nil, PLAYER_3 );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "VoiceOverRegion10",  "VoiceOver10" );
		Trigger( OBJECT_TOUCH_TRIGGER, "shipyard", "guide_message" );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "VoiceOverRegion4", "findPrison" );
		Trigger( OBJECT_TOUCH_TRIGGER, "prison", "openPrison" );
		Trigger( OBJECT_CAPTURE_TRIGGER, "MageTown", "ConvertTown" );
		Trigger( OBJECT_CAPTURE_TRIGGER, "MageTown1", "ConvertTown" );
		Trigger( OBJECT_TOUCH_TRIGGER, "Hut", "BurnHut" );
		Trigger( OBJECT_TOUCH_TRIGGER, "Hut1", "BurnHut" );
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

			if GetObjectiveState("obj5") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("obj4") == OBJECTIVE_COMPLETED then
				CINEMATICS.outro();
				sleep( 100 );
				Win();
				return
			end
		end
	end,

	escapeToIslands = function()
		if OBJECTIVES.state.escapeToIslands[2] == 1 then
			SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.escapeToIslands[2] = 2;
		elseif OBJECTIVES.state.escapeToIslands[2] == 2 and GetObjectOwner( "OrcishTown" ) == PLAYER_1 then
			SetObjectiveState( "obj1", OBJECTIVE_COMPLETED );
			startThread( Play2DSound, "/Maps/SingleMissions/A2S5/SM5_VO2_Kunyak_01sound.xdb#xpointer(/Sound)" );
			OBJECTIVES.state.escapeToIslands[2] = 10;
		end
	end,

	releaseHero = function()
		if OBJECTIVES.state.releaseHero[2] == 1 then
			SetObjectiveState("obj3", OBJECTIVE_ACTIVE);
			startThread( Play2DSound, "/Maps/SingleMissions/A2S5/SM5_VO4_Kunyak_01sound.xdb#xpointer(/Sound)" );
			OBJECTIVES.state.releaseHero[2] = 2;
		elseif OBJECTIVES.state.releaseHero[2] == 3 then
			SetObjectiveState("obj3", OBJECTIVE_COMPLETED);
			CINEMATICS.releaseHero();
			OBJECTIVES.state.releaseHero[2] = 10;
		end
	end,

	defeatFalconArmy = function()
		if OBJECTIVES.state.defeatFalconArmy[2] == 1 and OBJECTIVES.state.captureTowns[2] == 10 then
			SetObjectiveState("obj4", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.defeatFalconArmy[2] = 2;
		elseif OBJECTIVES.state.defeatFalconArmy[2] == 2 and IsHeroAlive( "RedHeavenHero02" ) == nil and GetObjectOwner( "htown" ) == PLAYER_1 then
			SetObjectiveState("obj4", OBJECTIVE_COMPLETED);
			PlayVoiceoverAndBlockGame( "/Maps/SingleMissions/A2S5/SM5_VO6_Kunyak_01sound.xdb#xpointer(/Sound)" );
			OBJECTIVES.state.defeatFalconArmy[2] = 10;
		end
	end,

	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 then
			SetObjectiveState("obj5", OBJECTIVE_ACTIVE);
			OBJECTIVES.state.isAlive[2] = 2;
		elseif OBJECTIVES.state.isAlive[2] == 2 and IsHeroAlive( "Hero4" ) == nil then
			SetObjectiveState("obj5", OBJECTIVE_FAILED);
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,

	captureTowns_plays = { 0, 0 },
	captureTowns = function()
		if OBJECTIVES.state.captureTowns[2] == 1 and (GetObjectOwner( "OrcishTown" ) == PLAYER_1 or GetMageTownsCaptured() > 0) then
			SetObjectiveState( "Sec1_CaptureMageTowns", OBJECTIVE_ACTIVE );
			OBJECTIVES.state.captureTowns[2] = 2;
		elseif OBJECTIVES.state.captureTowns[2] == 2 and GetMageTownsCaptured() == 2 then
			SetObjectiveState( "Sec1_CaptureMageTowns", OBJECTIVE_COMPLETED );
			SetRegionBlocked("AiBlock", nil, PLAYER_2);
			CINEMATICS.showRocksDisappear();
			OBJECTIVES.state.captureTowns[2] = 10;
		end
		
		if GetMageTownsCaptured() == 1 and OBJECTIVES.captureTowns_plays[1] == 0 then
			OBJECTIVES.captureTowns_plays[1] = 1; 
			startThread (Play2DSound, "/Maps/SingleMissions/A2S5/SM5_VO3_Kunyak_01sound.xdb#xpointer(/Sound)" );
		elseif GetMageTownsCaptured() == 2 and OBJECTIVES.captureTowns_plays[2] == 0 then
			OBJECTIVES.captureTowns_plays[2] = 1;
			startThread (Play2DSound, "/Maps/SingleMissions/A2S5/SM5_VO9_Batu_01sound.xdb#xpointer(/Sound)" );
		end
	end
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );

function a2s5_dbg(var)
	if var == 1 then
		SetObjectOwner("OrcishTown", PLAYER_1);
	elseif var == 11 then
		SetObjectOwner("MageTown", PLAYER_1);
	elseif var == 111 then
		SetObjectOwner("MageTown1", PLAYER_1);
	elseif var == 2 then
		SetObjectPosition("Hero4", 21, 10, GROUND);
	elseif var == 22 then
		SetObjectPosition("Hero4", 80, 40, GROUND);
	end
end