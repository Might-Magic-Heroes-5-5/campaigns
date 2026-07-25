doFile("/scripts/campaign_common.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT do
    sleep()
end

H55_PlayerStatus = {0,1,1,1,2,2,2,2};

function A1S3_captured_towns( player )
	local towns = 0;
	for i, town in { "HavenTown", "SylvanTown", "AcademyTown" } do
		if GetObjectOwner(town) == player then
			towns = towns + 1;
		end
	end
	return towns;
end

function A1S3_visitPortal( heroName )
	if heroName == "Veyer" then
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sovereign", nil );
		OBJECTIVES.state.reachPortal[2] = 4;
		OBJECTIVES.state.isAlive[2] = 2;
	end
end

function A1S3_conquerTown( oldOwner, newOwner, hero, object )
	if newOwner == PLAYER_1 then
		Trigger( OBJECT_CAPTURE_TRIGGER, object, nil );
		OBJECTIVES.SeizeArtifacts_conqueror = hero;
	end
end

function A1S3_visitGate( hero )
	if hero ~= "Veyer" then
		MessageBox( "/Maps/SingleMissions/A1S3/NotHero.txt" );
	else
		MessageBox( "/Maps/SingleMissions/A1S3/Gate.txt" );
	end
end

OBJECTIVES = {
	date = 0,
	state = {
		masterGating 	= { 	 "GainGating", 1 },
		reachPortal 	= { 	"ReachPortal", 1 },
		isAlive 		= { "HeroMustSurvive", 1 },
		SeizeArtifacts  = {  "SeizeArtifacts", 1 },
	},

	start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,

	prepare = function()
		StartAdvMapDialog( 0 );
		SetObjectEnabled( "gate", nil );
		Trigger( OBJECT_TOUCH_TRIGGER, "gate", "A1S3_visitGate" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sovereign", "A1S3_visitPortal");
		Trigger( OBJECT_CAPTURE_TRIGGER, "HavenTown", "A1S3_conquerTown");
		Trigger( OBJECT_CAPTURE_TRIGGER, "SylvanTown", "A1S3_conquerTown");
		Trigger( OBJECT_CAPTURE_TRIGGER, "AcademyTown", "A1S3_conquerTown");
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

			if GetObjectiveState("HeroMustSurvive") == OBJECTIVE_FAILED then
				Loose();
				return
			end

			if GetObjectiveState("HeroMustSurvive") == OBJECTIVE_COMPLETED and GetObjectiveState("ReachPortal") == OBJECTIVE_COMPLETED then
				sleep(100);
				Win( PLAYER_1 );
				return
			end
		end
	end,

	masterGating = function()
	-- objectve start is controlled by the map.xdb file
		if OBJECTIVES.state.masterGating[2] == 1 and GetHeroSkillMastery( "Veyer", SKILL_GATING ) == 3 then
			SetObjectiveState( "GainGating", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.masterGating[2] = 10;
		end
	end,

	reachPortal = function()
		if OBJECTIVES.state.reachPortal[2] == 1 and OBJECTIVES.state.masterGating[2] == 10 then
			SetObjectiveState( "ReachPortal", OBJECTIVE_ACTIVE );
			OpenCircleFog(168,160,GROUND,10,PLAYER_1);
			MoveCamera(168,160,GROUND,30,0.6,0,0,0);
			sleep(100);
			OBJECTIVES.state.reachPortal[2] = 2;
		elseif OBJECTIVES.state.reachPortal[2] == 2 and OBJECTIVES.state.SeizeArtifacts[2] == 10 then
			Trigger( OBJECT_TOUCH_TRIGGER, "gate", nil );
			SetObjectEnabled( "gate", not nil );
			OBJECTIVES.state.reachPortal[2] = 3;
		elseif OBJECTIVES.state.reachPortal[2] == 4 then
			SetObjectiveState( "ReachPortal", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.reachPortal[2] = 10;
		end
	end,
	
	isAlive = function()
	-- objectve start is controlled by the map.xdb file
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive("Veyer") == nil then
			SetObjectiveState( "HeroMustSurvive", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		elseif OBJECTIVES.state.isAlive[2] == 2 then
			SetObjectiveState( "HeroMustSurvive", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.isAlive[2] = 10;
		end
	end,
	
	SeizeArtifacts_conqueror = "Veyer",
	SeizeArtifacts = function()
	-- objectve start is controlled by the map.xdb file
		if OBJECTIVES.state.SeizeArtifacts[2] == 1 and A1S3_captured_towns( PLAYER_1 ) >= 1 then
			GiveArtefact( "Veyer", ARTIFACT_NIGHTMARISH_RING, 1 );
			ShowFlyingSign( "Maps/SingleMissions/A1S3/FlyingMessage_haveNightmrshRing.txt", OBJECTIVES.SeizeArtifacts_conqueror, PLAYER_1, 10 );
			OBJECTIVES.state.SeizeArtifacts[2] = 2;
		elseif OBJECTIVES.state.SeizeArtifacts[2] == 2 and A1S3_captured_towns( PLAYER_1 ) >= 2 then
			GiveArtefact( "Veyer", ARTIFACT_URGASH_01, 1 );
			ShowFlyingSign( "Maps/SingleMissions/A1S3/FlyingMessage_haveShklsOfWar.txt", OBJECTIVES.SeizeArtifacts_conqueror, PLAYER_1, 10 );
			OBJECTIVES.state.SeizeArtifacts[2] = 3;
		elseif OBJECTIVES.state.SeizeArtifacts[2] == 3 and A1S3_captured_towns( PLAYER_1 ) >= 3 then
			GiveArtefact( "Veyer", ARTIFACT_PEDANT_OF_MASTERY, 1 );
			ShowFlyingSign( "Maps/SingleMissions/A1S3/FlyingMessage_havePedantOfMastery.txt", OBJECTIVES.SeizeArtifacts_conqueror, PLAYER_1, 10 );
			SetObjectiveState( "SeizeArtifacts", OBJECTIVE_COMPLETED );
			OBJECTIVES.state.SeizeArtifacts[2] = 10;
		end
	end,
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start );
