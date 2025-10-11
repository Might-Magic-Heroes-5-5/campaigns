H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_TAROT_DECK,
ARTIFACT_ENDLESS_BAG_OF_GOLD

};


OUR_HERO_GOTAI = "Gottai";
--OUR_HERO_KUJIN = "Kujin";
ENEMY_HERO_ALARIC = "Alaric";
ENEMY_WIZARD_HERO = "Tan";
PATH = "Maps/Scenario/A2C2M5/";
ACADEMY_TOWNS = {"academy_town_center", "academy_town_west", "academy_town_north"};
ALL_TOWNS = {"academy_town_center", "academy_town_west", "academy_town_north", "HeavenTown", "MainAcademyTown", "main_orcish_town", "secondary_orcish_town", "necropolis"};
ALL_TOWNS.n = table.length( ALL_TOWNS );
DAY_OF_NECROMANTS_OUTCOME = 28;

VOICEOVER_CAPTURE_HEAVEN_TOWN = "/Sounds/_(Sound)/SFX/Screams.xdb#xpointer(/Sound)";

ADVMAPSCENE_SECONDARY_ORCTOWN_CONQUERED = 0;

SCENE_ISABELL_TURN_INTO_BIARA = "/DialogScenes/A2C2/M5/S1/DialogScene.xdb#xpointer(/DialogScene)";
SCENE_GOTAI_CONQUERS_TOWN = "/DialogScenes/A2C2/M5/S2/DialogScene.xdb#xpointer(/DialogScene)";
SCENE_GOTAI_KILLS_ALARIC = "/DialogScenes/A2C2/M5/S3/DialogScene.xdb#xpointer(/DialogScene)";

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

AllowPlayerTavernRace( PLAYER_1, TOWN_INFERNO, 0 );
AllowPlayerTavernRace( PLAYER_1, TOWN_ACADEMY, 0 );
AllowPlayerTavernRace( PLAYER_1, TOWN_HEAVEN, 0 );
AllowPlayerTavernRace( PLAYER_1, TOWN_NECROMANCY, 0 );
AllowPlayerTavernRace( PLAYER_1, TOWN_PRESERVE, 0 );
AllowPlayerTavernRace( PLAYER_1, TOWN_FORTRESS, 0 );
AllowPlayerTavernRace( PLAYER_1, TOWN_DUNGEON, 0 );

AllowHeroHiringByRaceForAI( PLAYER_2, TOWN_INFERNO, 0);
AllowHeroHiringByRaceForAI( PLAYER_2, TOWN_NECROMANCY, 0 );
AllowHeroHiringByRaceForAI( PLAYER_2, TOWN_STRONGHOLD, 0 );
AllowHeroHiringByRaceForAI( PLAYER_2, TOWN_DUNGEON, 0 );
AllowHeroHiringByRaceForAI( PLAYER_3, TOWN_ACADEMY, 0 );
AllowHeroHiringByRaceForAI( PLAYER_3, TOWN_INFERNO, 0 );
AllowHeroHiringByRaceForAI( PLAYER_3, TOWN_FORTRESS, 0 );
AllowHeroHiringByRaceForAI( PLAYER_3, TOWN_STRONGHOLD, 0 );
AllowHeroHiringByRaceForAI( PLAYER_4, TOWN_DUNGEON, 0 );
AllowHeroHiringByRaceForAI( PLAYER_4, TOWN_INFERNO, 0 );
AllowHeroHiringByRaceForAI( PLAYER_4, TOWN_FORTRESS, 0 );
AllowHeroHiringByRaceForAI( PLAYER_4, TOWN_STRONGHOLD, 0 );

AddHeroCreatures( ENEMY_WIZARD_HERO, CREATURE_TITAN, 1+3*GetDifficulty());
AddHeroCreatures( ENEMY_WIZARD_HERO, CREATURE_RAKSHASA_RUKH, 1+7*GetDifficulty());
AddHeroCreatures( ENEMY_WIZARD_HERO, CREATURE_MASTER_GENIE, 1+15*GetDifficulty());
AddHeroCreatures( ENEMY_WIZARD_HERO, CREATURE_ARCH_MAGI, 1+25*GetDifficulty());
AddHeroCreatures( ENEMY_WIZARD_HERO, CREATURE_STEEL_GOLEM, 1+40*GetDifficulty());
AddHeroCreatures( ENEMY_WIZARD_HERO, CREATURE_OBSIDIAN_GARGOYLE, 1+70*GetDifficulty());
AddHeroCreatures( ENEMY_WIZARD_HERO, CREATURE_MASTER_GREMLIN, 1+100*GetDifficulty());

AddHeroCreatures( "Aberrar", CREATURE_SKELETON_ARCHER, 1+10*GetDifficulty());
AddHeroCreatures( "Aberrar", CREATURE_LICH, 1+1*GetDifficulty());
AddHeroCreatures( "Aberrar", CREATURE_WALKING_DEAD, 1+3*GetDifficulty());
AddHeroCreatures( "Aberrar", CREATURE_VAMPIRE, 1+2*GetDifficulty());

AddHeroCreatures( "Maahir", CREATURE_GREMLIN, 1+10*GetDifficulty());
AddHeroCreatures( "Maahir", CREATURE_IRON_GOLEM, 1+3*GetDifficulty());
AddHeroCreatures( "Maahir", CREATURE_MAGI, 1+1*GetDifficulty());
AddHeroCreatures( "Maahir", CREATURE_GENIE, 1+1*GetDifficulty());

AddHeroCreatures( "Sufi", CREATURE_MASTER_GREMLIN, 1+7*GetDifficulty());
AddHeroCreatures( "Sufi", CREATURE_STEEL_GOLEM, 1+3*GetDifficulty());
AddHeroCreatures( "Sufi", CREATURE_OBSIDIAN_GARGOYLE, 1+5*GetDifficulty());
AddHeroCreatures( "Sufi", CREATURE_MAGI, 1+1*GetDifficulty());

AddHeroCreatures( "Orrin", CREATURE_ARCHER, 1+5*GetDifficulty());
AddHeroCreatures( "Orrin", CREATURE_MILITIAMAN, 1+8*GetDifficulty());
AddHeroCreatures( "Orrin", CREATURE_FOOTMAN, 1+3*GetDifficulty());
AddHeroCreatures( "Orrin", CREATURE_GRIFFIN, 1+2*GetDifficulty());


EnableHeroAI( "Tan", nil );
SetHeroRoleMode( "Tan", HERO_ROLE_MODE_HERMIT );

MakeHeroReturnToTavernAfterDeath("Timerkhan", not nil, 0);
MakeHeroReturnToTavernAfterDeath("Sufi", not nil, 0);
MakeHeroReturnToTavernAfterDeath("Razzak", not nil, 0);
MakeHeroReturnToTavernAfterDeath("Nur", not nil, 0);
MakeHeroReturnToTavernAfterDeath("Maahir", not nil, 0);
MakeHeroReturnToTavernAfterDeath("Isher", not nil, 0);
MakeHeroReturnToTavernAfterDeath("Havez", not nil, 0);
MakeHeroReturnToTavernAfterDeath("Faiz", not nil, 0);
MakeHeroReturnToTavernAfterDeath("Astral", not nil, 0);

SetObjectEnabled( "broken_golem",  nil );
SetRegionBlocked( "gotai_region", not nil );
SetDisabledObjectMode( "broken_golem", DISABLED_ATTACK );
--SetObjectEnabled( "MainAcademyTown", nil );
PlayObjectAnimation( "broken_golem", "stir00", ONESHOT_STILL );
PlayObjectAnimation( "golem1", "death", ONESHOT_STILL );
PlayObjectAnimation( "golem2", "death", ONESHOT_STILL );
PlayObjectAnimation( "golem3", "death", ONESHOT_STILL );
PlayObjectAnimation( "golem4", "death", ONESHOT_STILL );

DenyAIHeroFlee( OUR_HERO_GOTAI, not nil );

heaven_first_visit = 0;
golem_first_visit = 0;
captureTowns_first_complete = 0;
BrokenGolemsVisit_heroName = "";
canContinue = 0;
gotai_x, gotai_y, gotai_floor = GetObjectPosition( "Gottai" );
gotaiMustBeReturned = 0;

StartDialogScene( SCENE_ISABELL_TURN_INTO_BIARA );

SetObjectiveState( "prim1_CaptureMainAcademyTown", OBJECTIVE_ACTIVE );

function GiveTransferrableArtifacts()
	InitAllSetArtifacts( "A2C2M5", OUR_HERO_GOTAI );
	--InitAllSetArtifacts( "A2C2M5", OUR_HERO_KUJIN );
    LoadHeroAllSetArtifacts( OUR_HERO_GOTAI, "A2C2M3" );
	--LoadHeroAllSetArtifacts( OUR_HERO_KUJIN, "A2C2M4" );
end;



function prim2_HeroMustSurvive()
	while IsHeroAlive( OUR_HERO_GOTAI ) == not nil do sleep(10); end;
	Loose(PLAYER_1);
end;

function prim1_CaptureMainAcademyTown_completed( oldOwner, newOwner, heroName )
	if newOwner == PLAYER_1 then
		Trigger( OBJECT_CAPTURE_TRIGGER, "MainAcademyTown", nil);
		SetObjectiveState("prim1_CaptureMainAcademyTown", OBJECTIVE_COMPLETED);
		StartDialogScene( SCENE_GOTAI_CONQUERS_TOWN, "ChahgeGotaiStats" );
	end;
end;

function ChahgeGotaiStats()
	MessageBox( PATH.."MsgBox_GotaiStatsBoosted.txt" );
	ChangeHeroStat( OUR_HERO_GOTAI, STAT_ATTACK, 15 );
	ChangeHeroStat( OUR_HERO_GOTAI, STAT_DEFENCE, 15 );
	ChangeHeroStat( OUR_HERO_GOTAI, STAT_SPELL_POWER, 15 );
	ChangeHeroStat( OUR_HERO_GOTAI, STAT_KNOWLEDGE, 15 );
	sleep(20);
	startThread( DeployAlaric );
end;

function DeployAlaric()
	hero_x, hero_y = GetObjectPosition( OUR_HERO_GOTAI );
	deploy_x = 62;
	deploy_y = 173;
	DeployReserveHero( ENEMY_HERO_ALARIC, deploy_x, deploy_y, GROUND );
	sleep(1);
	DenyAIHeroFlee( ENEMY_HERO_ALARIC, not nil );
	AddHeroCreatures( ENEMY_HERO_ALARIC, CREATURE_SERAPH, 1+6*GetDifficulty());
	AddHeroCreatures( ENEMY_HERO_ALARIC, CREATURE_CHAMPION, 1+10*GetDifficulty());
	AddHeroCreatures( ENEMY_HERO_ALARIC, CREATURE_ZEALOT, 1+25*GetDifficulty());
	AddHeroCreatures( ENEMY_HERO_ALARIC, CREATURE_BATTLE_GRIFFIN, 1+35*GetDifficulty());
	AddHeroCreatures( ENEMY_HERO_ALARIC, CREATURE_VINDICATOR, 1+60*GetDifficulty());
	AddHeroCreatures( ENEMY_HERO_ALARIC, CREATURE_LONGBOWMAN, 1+150*GetDifficulty());
	AddHeroCreatures( ENEMY_HERO_ALARIC, CREATURE_LANDLORD, 1+1000*GetDifficulty());
	OpenCircleFog( deploy_x, deploy_y, GROUND, 10, PLAYER_1 );
	sleep(1);
	MoveCamera( deploy_x, deploy_y, GROUND, 31, 1.2, 0, 0, 0, 1);
	sleep(1);
	MessageBox( PATH.."MessageBox05_AlaricArrive.txt" );
	sleep(1);
	MoveCamera( hero_x, hero_y, GROUND, 31, 1.2, 0, 0, 0, 1 );
	startThread( IsAlaricDead );
end;

function IsAlaricDead()
	SetObjectiveState( "prim2_KillAlaric", OBJECTIVE_ACTIVE );
	while IsHeroAlive( ENEMY_HERO_ALARIC ) == not nil do sleep(5); end;
	sleep(1);
	StartDialogScene( SCENE_GOTAI_KILLS_ALARIC );
	sleep(1);
	SetObjectiveState( "prim2_KillAlaric", OBJECTIVE_COMPLETED );
end;

function IsOkPressed()
	isOkPressed = 1;
end;

function PlayerWin()
	while GetObjectiveState("prim1_CaptureMainAcademyTown") ~= OBJECTIVE_COMPLETED 
		or GetObjectiveState("prim2_KillAlaric") ~= OBJECTIVE_COMPLETED 
	do sleep(10); end;
	SaveHeroAllSetArtifactsEquipped( OUR_HERO_GOTAI, "A2C2M5" );
	Win(PLAYER_1);
end;

function sec3_CaptureHeavenTown_completed( oldOwner, newOwner, heroName )
	if newOwner == PLAYER_1 then
		if oldOwner ~= PLAYER_1 then
			SetObjectiveState( "sec3_CaptureHeavenTown", OBJECTIVE_COMPLETED );
			Trigger( OBJECT_CAPTURE_TRIGGER, "HeavenTown", nil );
			if heaven_first_visit == 0 then
				heaven_first_visit = 1;
				GiveArtefact( heroName, ARTIFACT_ENDLESS_BAG_OF_GOLD );
			end;
		end;
	end;
end;

function IsHeroHasGremlins( heroName )
	if GetHeroCreatures( heroName, CREATURE_GREMLIN ) > 0 or
				GetHeroCreatures( heroName, CREATURE_MASTER_GREMLIN ) > 0 or 
				GetHeroCreatures( heroName, CREATURE_GREMLIN_SABOTEUR ) > 0 
		then
		return not nil;
	else
		return nil;
	end;	
end;

function BrokenGolemsVisit( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		BrokenGolemsVisit_heroName = heroName;
		if golem_first_visit == 0 then
			golem_first_visit = 1;
			sleep(1);
			MessageBox( PATH.."MessageBox04_GolemsFirstVisit.txt", "CanContinue" );
			while canContinue == 0 do sleep(1); end;
			SetObjectiveState( "sec1_RepareGolems", OBJECTIVE_ACTIVE );
			sleep(1);
			if IsHeroHasGremlins( heroName ) == not nil	then
				MessageBox( PATH.."MessageBox02_GolemsRepared.txt", "JoinGolems" );
			end;
		else
			if IsHeroHasGremlins( heroName ) == not nil	then
				MessageBox( PATH.."MessageBox02_GolemsRepared.txt", "JoinGolems" );
			else
				MessageBox(PATH.."MessageBox03_GolemsNeedHelp.txt");
			end;
		end;
	end;
end;

function CanContinue()
	canContinue = 1;
end;

function JoinGolems()
	Trigger( OBJECT_TOUCH_TRIGGER, "broken_golem", nil );
	heroName = BrokenGolemsVisit_heroName;
	SetObjectiveState( "sec1_RepareGolems", OBJECTIVE_COMPLETED );
	for i=1, 4 do
		x,y,floor = GetObjectPosition("golem"..i);
		RemoveObject("golem"..i);
		PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "", "tag1", x, y, 0, floor ); -- ѕыль
		sleep(1);
		CreateMonster( "repared_golem"..i, CREATURE_IRON_GOLEM, 400, x,y, floor, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 110 );
		sleep(1);
		PlayObjectAnimation( "repared_golem"..i, "happy", ONESHOT );
	end;
	PlayObjectAnimation( "broken_golem", "happy", ONESHOT );
	SetObjectEnabled( "broken_golem", not nil );
	SetMonsterCourageAndMood( "broken_golem", PLAYER_1, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN );
	x,y, floor = GetObjectPosition( "broken_golem" );
	sleep(1);
	MoveHeroRealTime( heroName, x, y, floor );
	print("JoinGolems: Golems want to join!");
end;

function sec2_CaptureAllAcademyTowns_completed()
	while GetCapturedTowns() < 1 do sleep(5); end;
	SetObjectiveState( "sec2_CaptureAllAcademyTowns", OBJECTIVE_ACTIVE );	
	while 1 do
		while GetCapturedTowns() ~= 3 do sleep(5); end;
		SetObjectiveState( "sec2_CaptureAllAcademyTowns", OBJECTIVE_COMPLETED );	
		if captureTowns_first_complete == 0 then
			captureTowns_first_complete = 1;
		end;
		while GetCapturedTowns() == 3 do sleep(5); end;
		SetObjectiveState( "sec2_CaptureAllAcademyTowns", OBJECTIVE_FAILED );		
		sleep(5);
	end;
end;

function GetCapturedTowns()
	capturedTowns = 0;
	for i=1, table.length( ACADEMY_TOWNS ) do 
		if GetObjectOwner( ACADEMY_TOWNS[i]) == PLAYER_1 then capturedTowns = capturedTowns + 1; end;
	end;
	return capturedTowns;
end;

function H55_TriggerDaily()
	if GetDate( DAY ) == DAY_OF_NECROMANTS_OUTCOME and GetPlayerState( PLAYER_3 ) == 1 then
		H55_NewDayTrigger = 0;
		--Trigger( NEW_DAY_TRIGGER, nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "outcome", "RemoveHero" );
		MessageBox( PATH.."NecromantsGoAway.txt" );
		startThread( NecromantsGoAway );
		print("Necropolis player has been defeated");	
	end;
end;

function NecromantsGoAway()
		NecropolisHeroes = GetPlayerHeroes( PLAYER_3 );
		NecropolisTowns = GetPlayerTownsQuantity( PLAYER_3 );
		for i=1, ALL_TOWNS.n do
			EnableAIHeroHiring( PLAYER_3, ALL_TOWNS[i], nil );
		end;
		while 1 do
			NecropolisHeroes = GetPlayerHeroes( PLAYER_3 );
			NecropolisTowns = GetPlayerTownsQuantity( PLAYER_3 );
			sleep(1);
			if NecropolisTowns == 0 and table.length( NecropolisHeroes ) == 0 then
				break;
			end;
			while GetCurrentPlayer() ~= PLAYER_3 do sleep(10); end;
				NecropolisHeroes = GetPlayerHeroes( PLAYER_3 );
				NecropolisHeroes.n = table.length( NecropolisHeroes );
			for i=0, (NecropolisHeroes.n-1) do
				EnableHeroAI( NecropolisHeroes[i], not nil );
				MoveHero( NecropolisHeroes[i], 174, 133, GROUND );
			end;
			while GetCurrentPlayer() == PLAYER_3 do sleep(10); end;
			sleep(5);
		end;
end;

function RemoveHero( heroName )
	if GetObjectOwner( heroName ) == PLAYER_3 then
		RemoveObject( heroName );
	end;
end;

function GetPlayerTownsQuantity( PlayerID )
	ownedTowns = 0;
	for i=1, ALL_TOWNS.n do
		if GetObjectOwner( ALL_TOWNS[i] ) == PlayerID then 
			ownedTowns = ownedTowns + 1;
		end;
	end;
	return ownedTowns;
end;

function IsSecondaryOrcishTownsCaptured( oldOwner, newOwner, heroName )
	if newOwner == PLAYER_1 then
		print("IsSecondaryOrcishTownsCaptured: Orcish town is captured!");
		Trigger( OBJECT_CAPTURE_TRIGGER, "secondary_orcish_town", nil );
		--Play2DSound( VOICEOVER_CAPTURE_HEAVEN_TOWN );
		if GetObjectOwner( "HeavenTown" ) ~= PLAYER_1 then
			SetObjectiveState( "sec3_CaptureHeavenTown", OBJECTIVE_ACTIVE );
			Trigger( OBJECT_CAPTURE_TRIGGER, "HeavenTown", "sec3_CaptureHeavenTown_completed" );
			CreateMonster( "scene_goblin", CREATURE_GOBLIN_TRAPPER, 1, 77, 161, GROUND, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN, 200 );
			sleep(1);
			if heroName ~= "Gottai" then
				gotai_x, gotai_y, gotai_floor = GetObjectPosition( "Gottai" );
				gotaiMustBeReturned = 1;
				SetObjectPosition( "Gottai", 72, 162 );
				SetObjectRotation( "Gottai", 100 );
				sleep(2);
			end;	
			StartAdvMapDialog( ADVMAPSCENE_SECONDARY_ORCTOWN_CONQUERED, "RemoveSceneObjects" );	
		end;
	end;
end;

function RemoveSceneObjects()
	RemoveObject("scene_goblin");
	SetRegionBlocked( "gotai_region", nil );
	if gotaiMustBeReturned == 1 then
		SetObjectPosition( "Gottai", gotai_x, gotai_y, gotai_floor );
	end;
end;

function EnableTown()
	SetObjectEnabled( "MainAcademyTown", not nil);
	SetRegionBlocked( "main_town", nil, PLAYER_2);
	SetRegionBlocked( "main_town", nil, PLAYER_3);
	SetRegionBlocked( "main_town", nil, PLAYER_4);
end;

H55_CamFixTooManySkills(PLAYER_1,"Gottai");
startThread( prim2_HeroMustSurvive );
startThread( PlayerWin );
startThread( GiveTransferrableArtifacts );
--startThread( sec2_CaptureAllAcademyTowns_completed );
Trigger( OBJECT_TOUCH_TRIGGER, "broken_golem", "BrokenGolemsVisit" );
Trigger( OBJECT_CAPTURE_TRIGGER, "MainAcademyTown", "prim1_CaptureMainAcademyTown_completed" );
--Trigger( OBJECT_CAPTURE_TRIGGER, "HeavenTown", "sec3_CaptureHeavenTown_completed" );
Trigger( OBJECT_CAPTURE_TRIGGER, "secondary_orcish_town", "IsSecondaryOrcishTownsCaptured" );
H55_NewDayTrigger = 1;
--Trigger( NEW_DAY_TRIGGER, "NecromantsOutcome" );