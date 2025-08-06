isMageTown1Converted = 0;
isMageTown2Converted = 0;
MageTownsCapturedByPlayer  = 0;

PlayerHero = "Hero4"

EnemyHero = "RedHeavenHero02"

StartDialogScene("/DialogScenes/A2Single/SM5/S1/DialogScene.xdb#xpointer(/DialogScene)");

played = 0;
diff = 0;
count = 0;
TownToConvert = "";
firstTimeMageTownsCaptured = 0;

function DiffSetup()
	if GetDifficulty() == DIFFICULTY_EASY then
		diff = 1;
		print ("easy");
		sleep( 2 );
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		diff = 2;
		print ("normal");
		sleep( 2 );
	elseif GetDifficulty() == DIFFICULTY_HARD then
		diff = 3;
		print ("Hard");
		sleep( 2 );
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		diff = 4;
		print ("Impossible");
		sleep( 2 );
	end;
	print("DiffSetup initialized");
end;

function MissionStartUp()
	AllTownsSetUp();
	HeroesSetUp();
	BlockTownGarrisonForAI( "MageTown1", not nil )
	BlockTownGarrisonForAI( "MageTown", not nil );
	BlockTownGarrisonForAI( "htown", not nil );
	SetPlayerStartResource(PLAYER_1, WOOD, 0);
	SetPlayerStartResource(PLAYER_1, ORE, 0);
	SetPlayerStartResource(PLAYER_1, MERCURY, 0);
	SetPlayerStartResource(PLAYER_1, SULFUR, 0);
	SetPlayerStartResource(PLAYER_1, CRYSTAL, 0);
	SetPlayerStartResource(PLAYER_1, GEM, 0);
	SetPlayerStartResource(PLAYER_1, GOLD, 0);
	SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
	SetObjectiveState("obj5", OBJECTIVE_ACTIVE);
	OpenCircleFog(21, 20, GROUND, 10, PLAYER_1);
	SetRegionBlocked("AiBlock", not nil, PLAYER_2);
	SetRegionBlocked("AiBlock1", not nil, PLAYER_2);
	SetRegionBlocked("AiBlock2", not nil, PLAYER_2);
	SetRegionBlocked("AiBlock3", not nil, PLAYER_3);
	--SetObjectEnabled("Hut", nil);
	--SetObjectEnabled("Hut1", nil);
	print("MissionStartUp initialized");
end;

heroes = { PlayerHero, EnemyHero }

function HeroesSetUp()
	for i,hero in heroes do
		print( hero );
		for creatureID = 1, CREATURES_COUNT - 1 do 
			CreatureSetUp = GetHeroCreatures( hero, creatureID );
			if GetHeroCreatures( hero, creatureID) > 2 then
				RemoveHeroCreatures( hero, creatureID, CreatureSetUp );
				AddHeroCreatures( hero, creatureID, CreatureSetUp + (CreatureSetUp / 100 * 40) * diff );
			end;
		end;
	end;
end;

---------- Army Setup ----------

towns = {"htown", "MageTown1", "MageTown"};

function AllTownsSetUp()
	for i,town in towns do
		print( town );
		for creatureID = 1, CREATURES_COUNT - 1 do 
			CreatureSetUp = GetObjectCreatures( town, creatureID );
			if GetObjectCreatures( town, creatureID ) > 2 then
				RemoveObjectCreatures( town, creatureID, CreatureSetUp );
				AddObjectCreatures( town, creatureID, CreatureSetUp + (CreatureSetUp / 100 * 40) * diff );
				print( creatureID );
			end;
		end;
	end;
end;

---------- Shipyard Setup ----------

function guide_message()
	local x
	local y
	local level
	x,y,level = GetObjectPosition( PlayerHero );
	OpenCircleFog(12, 120, GROUND, 5, PLAYER_1);
	sleep( 2 );
	MoveCamera(12, 120, GROUND, 25, 3.14/3, 0, 1, 1, 1);
	sleep( 5 );
	MessageBox("/Maps/SingleMissions/a2s5/message02.txt");
	sleep( 15 );
	MoveCamera(x, y, level, 25, 3.14/3, 0, 1, 1, 1);
	Trigger( OBJECT_TOUCH_TRIGGER, "shipyard", nil );
end;

Trigger( OBJECT_TOUCH_TRIGGER, "shipyard", "guide_message" );

---------- Objective 1 ----------

function FirstObjective( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		--MessageBox();
		Trigger( OBJECT_TOUCH_TRIGGER, "OrcishTown", nil );
		--SetObjectOwner( "OrcishTown", PLAYER_1 );
		SetObjectiveState( "obj1", OBJECTIVE_COMPLETED );
		startThread( VoiceOver1 );
		if GetObjectiveState( "Sec1_CaptureMageTowns" ) == OBJECTIVE_UNKNOWN then
			SetObjectiveState( "Sec1_CaptureMageTowns", OBJECTIVE_ACTIVE );
		end;
	end;
end;

function VoiceOver1()
	Play2DSound( "/Maps/SingleMissions/A2S5/SM5_VO2_Kunyak_01sound.xdb#xpointer(/Sound)" );
end;

---------- Objective 2 ----------

function Convert()
	TransformTown( TownToConvert, TOWN_STRONGHOLD );
end;

---------- Objective 3 ----------

function ThirdObjective( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		SetObjectiveState("obj3", OBJECTIVE_COMPLETED);
		Trigger(OBJECT_TOUCH_TRIGGER, "prison", nil);
		StartAdvMapDialog( 0 );
	end;
end;


function vo4( heroName )
	if heroName == PlayerHero then
		SetObjectiveState("obj3", OBJECTIVE_ACTIVE);
		Play2DSound( "/Maps/SingleMissions/A2S5/SM5_VO4_Kunyak_01sound.xdb#xpointer(/Sound)" );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "VoiceOverRegion4", nil );
	end;
end;

Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "VoiceOverRegion4", "vo4" );

---------- Objective 4 ----------

function WhirlpoolRemove()
	while 1 do
		if GetObjectOwner("MageTown1") == PLAYER_1 and GetObjectOwner("MageTown") == PLAYER_1 then	
			RemoveObject("Whirlpool");
			RemoveObject("WhirlpoolFx");
			SetRegionBlocked("AiBlock", nil, PLAYER_2);
			SetObjectiveState("obj4", OBJECTIVE_ACTIVE);
			break;
		end;
	sleep( 2 );
	end;
end;

function FourthObjective()
	if IsHeroAlive( EnemyHero ) == nil and GetObjectOwner( "htown" ) == PLAYER_1 then
		if played == 0 then
			played = 1;
			StartDialogScene( "/DialogScenes/A2Single/SM5/S2/DialogScene.xdb#xpointer(/DialogScene)", "WinCondition" );
		end;
	end;
end;

---------- Objective 5 ----------

function FifthObjective()
	while IsHeroAlive( PlayerHero ) == not nil do sleep(5); end;
	SetObjectiveState("obj5", OBJECTIVE_FAILED);
	Loose();
end;


---------- Objective 5 ----------

function WinCondition()
	SetObjectiveState("obj4", OBJECTIVE_COMPLETED);
	startThread( VoiceOver6 );
	--Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, nil);
	Trigger(OBJECT_CAPTURE_TRIGGER, "htown", nil);
	sleep( 3 );
	Win();
end;

function VoiceOver6()
	Play2DSound( "/Maps/SingleMissions/A2S5/SM5_VO6_Kunyak_01sound.xdb#xpointer(/Sound)" );
end;

-------------------------------

function BurnHut( ObjectName )
	if IsObjectExists( ObjectName ) == not nil then
		PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", ObjectName, 0, 0, 0, GROUND ); 
		PlayVisualEffect( "/Effects/_(Effect)/Characters/Heroes/DemonLord/Path/Level_2b.xdb#xpointer(/Effect)", ObjectName, 0, 0, 0, GROUND ); 
		RazeBuilding( ObjectName );
	end;
end;

function Sec1_IsMageTownsCaptured()
	print("Sec1_IsMageTownsCaptured: function started...");
	SetObjectiveState( "Sec1_CaptureMageTowns", OBJECTIVE_ACTIVE );
	sleep(1);
	while 1 do
		while GetObjectOwner("MageTown") ~= PLAYER_1 or GetObjectOwner("MageTown1") ~= PLAYER_1 do sleep(5); end;
		SetObjectiveState( "Sec1_CaptureMageTowns", OBJECTIVE_COMPLETED );
		if firstTimeMageTownsCaptured == 0 then
			hero_x, hero_y = GetObjectPosition( PlayerHero );
			firstTimeMageTownsCaptured = 1;
			OpenCircleFog(80, 82, GROUND, 8, PLAYER_1);
			MoveCamera(80, 82, GROUND, 25, 3.14/3, 0, 1, 1, 1, 0);
			sleep( 25 );
			MoveCamera(hero_x, hero_y, GROUND, 25, 3.14/3, 0, 1, 1, 1, 0);
		end;
		while GetObjectOwner("MageTown") == PLAYER_1 and GetObjectOwner("MageTown1") == PLAYER_1 do sleep(5); end;
		SetObjectiveState( "Sec1_CaptureMageTowns", OBJECTIVE_ACTIVE );
		sleep(5);
	end;
end;

MageTowns = 0;
InProcess = 0;
VoiceOverP3 = 0;
VoiceOverP9 = 0;

function ConvertTown1( oldOwner, newOwner, heroName, objectName )
	print("ConvertTown1: function started...");
	if newOwner == PLAYER_1 then
		if GetObjectiveState( "Sec1_CaptureMageTowns" ) == OBJECTIVE_UNKNOWN then
			SetObjectiveState( "Sec1_CaptureMageTowns", OBJECTIVE_ACTIVE );
			sleep(1);
		end;
		if GetObjectOwner("MageTown")==PLAYER_1 and GetObjectOwner("MageTown1")==PLAYER_1 and GetObjectiveState( "Sec1_CaptureMageTowns" ) ~= OBJECTIVE_COMPLETED then
			SetObjectiveState( "Sec1_CaptureMageTowns", OBJECTIVE_COMPLETED );
		--	Trigger( OBJECT_CAPTURE_TRIGGER, "MageTown", nil );
			if firstTimeMageTownsCaptured == 0 then
				ShowRocksDisappear( heroName );
			end;
		end;
		if isMageTown1Converted == 0 then
			if GetObjectOwner( heroName ) == PLAYER_1 then
				MageTowns = MageTowns + 1;
				isMageTown1Converted = 1;
				TownToConvert = objectName;
				Convert();
				VoiceOverPlayOp();
			end;
		end;
	end;
end;


function ShowRocksDisappear( heroName )
	firstTimeMageTownsCaptured = 1;
	hero_x, hero_y = GetObjectPosition( heroName );
	OpenCircleFog(80, 82, GROUND, 8, PLAYER_1);
	MoveCamera(80, 82, GROUND, 25, 3.14/3, 0, 1, 1, 1, 0);
	sleep( 25 );
	MoveCamera(hero_x, hero_y, GROUND, 25, 3.14/3, 0, 1, 1, 1, 0);
end;

function VoiceOverPlayOp()
	if MageTowns == 1 and VoiceOverP3 == 0 then
		VoiceOverP3 = 1;
		startThread( VoiceOver3 );
	elseif MageTowns == 2 and VoiceOverP9 == 0 then
		VoiceOverP9 = 1;
		startThread( VoiceOver9 );
	end;
end;	

function VoiceOver3()
	local snd = "/Maps/SingleMissions/A2S5/SM5_VO3_Kunyak_01sound.xdb#xpointer(/Sound)"
	local numSleeps = GetSoundTimeInSleeps(snd);
	while InProcess > 0 do sleep( 1 ); end		
	if 	InProcess == 0 then
		InProcess = 1;	
		Play2DSound( snd );
		sleep( numSleeps + 2 );
		InProcess = 0;
	end;		
end;

function VoiceOver9()
	local snd = "/Maps/SingleMissions/A2S5/SM5_VO9_Batu_01sound.xdb#xpointer(/Sound)"
	local numSleeps = GetSoundTimeInSleeps(snd);
	while InProcess > 0 do sleep( 1 ); end		
	if 	InProcess == 0 then
		InProcess = 1;	
		Play2DSound( snd );
		sleep( numSleeps + 2 );
		InProcess = 0;
	end;		
end;

--function VoiceOver9()
--	Play2DSound( "/Maps/SingleMissions/A2S5/SM5_VO9_Batu_01sound.xdb#xpointer(/Sound)" );
--end;

--function VoiceOver3()
--	Play2DSound( "/Maps/SingleMissions/A2S5/SM5_VO3_Kunyak_01sound.xdb#xpointer(/Sound)" );
--end;

function ConvertTown2( oldOwner, newOwner, heroName, objectName )
	print("ConvertTown2: function started...");
	if newOwner == PLAYER_1 then
		if GetObjectiveState( "Sec1_CaptureMageTowns" ) == OBJECTIVE_UNKNOWN then
			SetObjectiveState( "Sec1_CaptureMageTowns", OBJECTIVE_ACTIVE );
			sleep(1);
		end;
		if GetObjectOwner("MageTown")==PLAYER_1 and GetObjectOwner("MageTown1")==PLAYER_1 and GetObjectiveState( "Sec1_CaptureMageTowns" ) ~= OBJECTIVE_COMPLETED then
			SetObjectiveState( "Sec1_CaptureMageTowns", OBJECTIVE_COMPLETED );
		--	Trigger( OBJECT_CAPTURE_TRIGGER, "MageTown1", nil );
			if firstTimeMageTownsCaptured == 0 then
				ShowRocksDisappear( heroName );
			end;
		end;
		if isMageTown2Converted == 0 then
			if GetObjectOwner( heroName ) == PLAYER_1 then
				MageTowns = MageTowns + 1;
				isMageTown2Converted = 1;
				TownToConvert = objectName;
				Convert();
				VoiceOverPlayOp();
			end;
		end;
	end;
end;



function VoiceOver10( heroName )
	if heroName == PlayerHero then	
		Play2DSound( "/Maps/SingleMissions/A2S5/SM5_VO10_Batu_01sound.xdb#xpointer(/Sound)" );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "VoiceOverRegion10",  nil);
	end;
end;


Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "VoiceOverRegion10",  "VoiceOver10");

---------- exec line ----------
DiffSetup();
MissionStartUp();
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_2, "FourthObjective" );
Trigger( OBJECT_CAPTURE_TRIGGER, "htown", "FourthObjective" );
--Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, "obj4", "WinCondition" );
Trigger( OBJECT_CAPTURE_TRIGGER, "MageTown", "ConvertTown1" );
Trigger( OBJECT_CAPTURE_TRIGGER, "MageTown1", "ConvertTown2" );
Trigger( OBJECT_TOUCH_TRIGGER, "OrcishTown", "FirstObjective" );
--Trigger( OBJECT_TOUCH_TRIGGER, "Hut", "BurnHut" );
--Trigger( OBJECT_TOUCH_TRIGGER, "Hut1", "BurnHut" );
Trigger( OBJECT_TOUCH_TRIGGER, "prison", "ThirdObjective");
startThread( WhirlpoolRemove );
startThread( FifthObjective );