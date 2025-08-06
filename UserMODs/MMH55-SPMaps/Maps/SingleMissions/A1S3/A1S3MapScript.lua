MAIN_HERO = "Veyer";
TownsCaptured = 0;
capturedtowns = {};
capturedtowns["HavenTown"] = 0;
capturedtowns["SylvanTown"] = 0;
capturedtowns["AcademyTown"] = 0;
H55_PlayerStatus = {0,1,1,1,2,2,2,2};

StartAdvMapDialog( 0 );
SetObjectEnabled("gate",nil);

-- проверяется уровень скилла Gating у главного героя
function CheckSkill()
	--while not HasHeroSkill( MAIN_HERO, DEMON_FEAT_ABSOLUTE_GATING ) do
	while GetHeroSkillMastery( MAIN_HERO, SKILL_GATING ) < 3 do
		sleep( 3 );
	end;
	--SetObjectEnabled( "gate", 1 );
	SetObjectiveState( "GainGating", OBJECTIVE_COMPLETED );
	sleep(10);
	SetObjectiveState( "ReachPortal", OBJECTIVE_ACTIVE );
	sleep(10);
	OpenCircleFog(168,160,GROUND,10,PLAYER_1);
	sleep(2);
	MoveCamera(168,160,GROUND,30,0.6,0,0,0);
end;

-- вызывается при захвате нового замка - выдача очередного артефакта главному (!) герою
function gainArtifact( oldOwner, newOwner, heroName, objectName )
	if newOwner == PLAYER_1 and capturedtowns[ objectName ] == 0 then
		capturedtowns[ objectName ] = 1;
		TownsCaptured = TownsCaptured + 1;
		local x,y = GetObjectPosition(MAIN_HERO);
		if heroName ~= MAIN_HERO and GetHeroTown( MAIN_HERO ) == nil then
			MoveCamera( x,y, GROUND, 50,1.2,0);
		end;
		if TownsCaptured == 1 then
			GiveArtefact( MAIN_HERO, ARTIFACT_NIGHTMARISH_RING, 1 );
			if GetHeroTown( MAIN_HERO ) == nil then
				ShowFlyingSign( "Maps/SingleMissions/A1S3/FlyingMessage_haveNightmrshRing.txt", MAIN_HERO, PLAYER_1, 5 );
			else
				ShowFlyingSign( "Maps/SingleMissions/A1S3/FlyingMessage_haveNightmrshRing.txt", heroName, PLAYER_1, 5 );
			end;
		elseif TownsCaptured == 2 then
			GiveArtefact( MAIN_HERO, ARTIFACT_URGASH_01, 1 );
			if GetHeroTown( MAIN_HERO ) == nil then			
				ShowFlyingSign( "Maps/SingleMissions/A1S3/FlyingMessage_haveShklsOfWar.txt", MAIN_HERO, PLAYER_1, 5 );
			else
				ShowFlyingSign( "Maps/SingleMissions/A1S3/FlyingMessage_haveShklsOfWar.txt", heroName, PLAYER_1, 5 );
			end;
		elseif TownsCaptured == 3 then
			GiveArtefact( MAIN_HERO, ARTIFACT_PEDANT_OF_MASTERY, 1 );
			if GetHeroTown( MAIN_HERO ) == nil then
				ShowFlyingSign( "Maps/SingleMissions/A1S3/FlyingMessage_havePedantOfMastery.txt", MAIN_HERO,PLAYER_1, 5 );
			else
				ShowFlyingSign( "Maps/SingleMissions/A1S3/FlyingMessage_havePedantOfMastery.txt", heroName, PLAYER_1, 5 );
			end;
			SetObjectiveState( "SeizeArtifacts", OBJECTIVE_COMPLETED );
		end;
	end;
end;

function HeroMustSurvive( heroName )
	if heroName == MAIN_HERO then
		SetObjectiveState("HeroMustSurvive",OBJECTIVE_FAILED);
		sleep(10);
		Loose(PLAYER_1);
	end;
end;

function winMission( heroName )
	if heroName == MAIN_HERO then
		SetObjectiveState( "ReachPortal", OBJECTIVE_COMPLETED );
		sleep(10);
		SetObjectiveState("HeroMustSurvive", OBJECTIVE_COMPLETED);
		sleep(10);
		Win(PLAYER_1);
	end;
end;

-- при трогании гарнизона проверяется кто трогает
function Gate( heroname )
	if heroname == MAIN_HERO then
		if ( GetObjectiveState( "GainGating" ) == OBJECTIVE_COMPLETED ) and
			( GetObjectiveState( "SeizeArtifacts" ) == OBJECTIVE_COMPLETED ) then
			SetObjectEnabled( "gate", not nil );
		else
			MessageBox( "/Maps/SingleMissions/A1S3/Gate.txt" );
			--SetObjectEnabled( "gate", nil );
		end;
	else
		MessageBox( "/Maps/SingleMissions/A1S3/NotHero.txt" );
		--SetObjectEnabled( "gate", nil );
	end;
end;
	
----------------
startThread( CheckSkill );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "sovereign", "winMission")
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "HeroMustSurvive" );
--Trigger( OBJECT_TOUCH_TRIGGER, "WitchHut01", "giveHeroGating" );
Trigger( OBJECT_TOUCH_TRIGGER, "gate", "Gate" );
Trigger( OBJECT_CAPTURE_TRIGGER, "HavenTown", "gainArtifact");
Trigger( OBJECT_CAPTURE_TRIGGER, "SylvanTown", "gainArtifact");
Trigger( OBJECT_CAPTURE_TRIGGER, "AcademyTown", "gainArtifact");