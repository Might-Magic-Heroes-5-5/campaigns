H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_TAROT_DECK,
ARTIFACT_ENDLESS_BAG_OF_GOLD

};

H55_NewDayTrigger = 1;
PlayerHero = "Kujin"

AIHero = "Hero8"
AIHero1 = "Hero1"
AIHero2 = "Hero4"
AIHero3 = "Hero9"

AIHero4 = "Dalom"
AIHero5 = "Hero6"
AIHero6 = "Ferigl"
AIHero7 = "Metlirn"

AIHero8 = "Christian"
AIHero9 = "Efion"
AIHero10 = "Nemor"
AIHero11 = "Egil"

AIHero12 = "Menel"

DAT = 0;
DAT1 = 0;
DAT2 = 0;
start = 0;
eheroes = { AIHero4, AIHero5, AIHero6, AIHero7 };
pirates = { AIHero6, AIHero7 };

function DiffSetup()
	if GetDifficulty() == DIFFICULTY_EASY then
		diff = 2;
		print ( "easy" );
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		diff = 2;
		print ( "normal" );
	elseif GetDifficulty() == DIFFICULTY_HARD then
		diff = 3;
		print ( "Hard" );
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		diff = 4;
		print ( "Impossible" );
	end;
	MissionStart();
end;

function MissionStart()
	SetHeroesExpCoef( 0.5 );
	
	DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes (PLAYER_6, not nil);
	
	SetObjectiveState( "obj1", OBJECTIVE_ACTIVE );
	SetObjectiveState( "obj2", OBJECTIVE_ACTIVE );
	SetObjectiveState( "obj6", OBJECTIVE_ACTIVE );
	
	DenyAIHeroFlee(  AIHero4, not nil );
	DenyAIHeroFlee(  AIHero5, not nil );
	
	EnableHeroAI( AIHero, nil );
	EnableHeroAI( AIHero1, nil );
	EnableHeroAI( AIHero2, nil );
	EnableHeroAI( AIHero3, nil );
	
	SetObjectEnabled( AIHero, nil );
	SetObjectEnabled( AIHero4, nil );
	
	EnableHeroAI( AIHero4, nil );
	EnableHeroAI( AIHero5, nil );
	EnableHeroAI( AIHero6, nil );
	EnableHeroAI( AIHero7, nil );
	
	SetHeroRoleMode( AIHero6, HERO_ROLE_MODE_HERMIT );
	SetHeroRoleMode( AIHero7, HERO_ROLE_MODE_HERMIT );
	
	EnableHeroAI( AIHero8, nil );
	EnableHeroAI( AIHero9, nil );
	EnableHeroAI( AIHero10, nil );
	EnableHeroAI( AIHero11, nil );
	
	SetHeroRoleMode( "Hero3", HERO_ROLE_MODE_HERMIT );
	SetHeroRoleMode( "Hero2", HERO_ROLE_MODE_HERMIT );
	
	SetRegionBlocked( "FirstChiefBlock", not nil, PLAYER_2 );
	SetRegionBlocked( "SeaBlock1", not nil, PLAYER_3 );
	SetRegionBlocked( "SeaBlock2", not nil, PLAYER_5 );
	SetRegionBlocked( "SeaBlock3", not nil, PLAYER_6 );
	
	SetRegionBlocked( "PortalBlock", not nil, PLAYER_5 );
	
	SetRegionBlocked( "PRB1", not nil, PLAYER_1 );
	SetRegionBlocked( "PRB2", not nil, PLAYER_1 );
	
	SetRegionBlocked( "PRB3", not nil, PLAYER_1 );
	SetRegionBlocked( "PRB4", not nil, PLAYER_1 );
	
	SetRegionBlocked( "PRB5", not nil, PLAYER_1 );
	SetRegionBlocked( "PRB6", not nil, PLAYER_1 );

	SetRegionBlocked( "PRB7", not nil, PLAYER_1 );
	SetRegionBlocked( "PRB8", not nil, PLAYER_1 );	

	SetObjectEnabled( "Guard", nil );
	SetObjectEnabled( "Victim", nil );
	SetObjectEnabled( "Victim1", nil );
	SetObjectEnabled( "Victim2", nil );
	sleep( 1 );
	
	SetDisabledObjectMode( "Guard", DISABLED_INTERACT );
	SetDisabledObjectMode( "Victim", DISABLED_BLOCKED  );
	SetDisabledObjectMode( "Victim1", DISABLED_BLOCKED  );
	SetDisabledObjectMode( "Victim2", DISABLED_BLOCKED  );
	
	SetMonsterSelectionType( "Victim", 0 );
	SetMonsterSelectionType( "Victim1", 0 );
	SetMonsterSelectionType( "Victim2", 0 );
	
	PlayObjectAnimation( "Victim", "death", ONESHOT_STILL );
	PlayObjectAnimation( "Victim1", "death", ONESHOT_STILL );
	PlayObjectAnimation( "Victim2", "death", ONESHOT_STILL );
	
	ChangeHeroStat( AIHero4, STAT_EXPERIENCE, 35000 );
	ChangeHeroStat( AIHero6, STAT_EXPERIENCE, 20000 );
	ChangeHeroStat( AIHero7, STAT_EXPERIENCE, 18000 );
	
	OverrideObjectTooltipNameAndDescription( "Victim", "-disabled-","" );
	OverrideObjectTooltipNameAndDescription( "Victim1", "-disabled-","" );
	OverrideObjectTooltipNameAndDescription( "Victim2", "-disabled-","" );
	
	
	EnemyHeroesSetUp();
	GarrisonSetUp();
	
end;

function EnemyHeroesSetUp()
	for i,hero in eheroes do	
		for creatureID = 1, CREATURES_COUNT - 1 do 
			CreatureSetUp = GetHeroCreatures( hero, creatureID );
			if GetHeroCreatures( hero, creatureID ) > 2 then
				RemoveHeroCreatures( hero, creatureID, CreatureSetUp );
				AddHeroCreatures( hero, creatureID, CreatureSetUp + ( CreatureSetUp / 100 * 40) * diff );
			end;
		end;
	end;
end;

function GarrisonSetUp()
	for creatureID = 1, CREATURES_COUNT - 1 do 
		CreatureSetUp = GetObjectCreatures( "Garrison", creatureID );
		if GetObjectCreatures( "Garrison", creatureID ) > 2 then
			RemoveObjectCreatures( "Garrison", creatureID, CreatureSetUp );
			AddObjectCreatures( "Garrison", creatureID, CreatureSetUp + ( CreatureSetUp / 100 * 40) * diff );
		end;
	end;
end;

---------- GLOBAL BONUSES ----------

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function startSetArtifactsInit()
	InitAllSetArtifacts( "A2C2M2", PlayerHero );
end;

startThread( startSetArtifactsInit );

---------- FIRST OBJECTIVE ----------

function FirstObjective()
	local o_count = 0;
	if GetObjectiveState( "obj2" ) == OBJECTIVE_COMPLETED then
		o_count = o_count + 1;
	end;
	if GetObjectiveState( "obj3" ) == OBJECTIVE_COMPLETED then
		o_count = o_count + 1;
	end;
	if GetObjectiveState( "obj4" ) == OBJECTIVE_COMPLETED then
		o_count = o_count + 1;
	end;
	if GetObjectiveState( "obj5" ) == OBJECTIVE_COMPLETED then
		o_count = o_count + 1;
	end;
	if o_count == 4 then
		startThread( VoiceOver4 );
		SaveHeroAllSetArtifactsEquipped( PlayerHero, "A2C2M2" );
		SetObjectiveState( "obj1", OBJECTIVE_COMPLETED );
		SetObjectiveState( "obj6", OBJECTIVE_COMPLETED );
		sleep( 15 );
		Win();
	end;	
end;

function VoiceOver4()
	Play2DSound( "/Maps/Scenario/A2C2M2/C2M2_VO4_Kujin_01sound.xdb#xpointer(/Sound)" );
end;

Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, "obj2", "FirstObjective" );
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, "obj3", "FirstObjective" );
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, "obj4", "FirstObjective" );
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER, "obj5", "FirstObjective" );

---------- OBJECTIVE INIT ----------

SetObjectEnabled( AIHero, nil );
SetObjectEnabled( AIHero1, nil );
SetObjectEnabled( AIHero2, nil );
SetObjectEnabled( AIHero3, nil );

function ObjectiveInit( heroName )
	if heroName == PlayerHero then
		if IsObjectInRegion( heroName, "FirstChief" ) then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "FirstChief", nil );
			sleep( 8 );
			StartAdvMapDialog( 0, "SecondObjectiveState" );
		end;
		if IsObjectInRegion( heroName, "SecondChief" ) then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "SecondChief", nil );
			sleep( 8 );
			StartAdvMapDialog( 2, "ThirdObjectiveState" );
		end;
		if IsObjectInRegion( heroName, "ThirdChief" ) then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ThirdChief", nil );
			sleep( 8 );
			StartAdvMapDialog( 1, "FourthObjectiveState" );
		end;
		if IsObjectInRegion( heroName, "FourthChief" ) then
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "FourthChief", nil );
			sleep( 8 );
			StartAdvMapDialog( 3, "FifthObjectiveState" );
		end;
	elseif heroName ~= PlayerHero and GetObjectOwner( heroName ) == PLAYER_1 then	
		MessageBox( "/Maps/Scenario/a2c2m2/message03.txt" );
	end;
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "FirstChief", "ObjectiveInit" );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "SecondChief", "ObjectiveInit" );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ThirdChief", "ObjectiveInit" );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "FourthChief", "ObjectiveInit" );

---------- SECOND OBJECTIVE ----------

function SecondObjectiveState()
	local x,y,level = GetObjectPosition( PlayerHero );
	SetRegionBlocked( "PRB1", nil, PLAYER_1 );
	SetRegionBlocked( "PRB2", nil, PLAYER_1 );
	SetObjectiveState( "obj2", OBJECTIVE_COMPLETED );
	SetObjectiveState( "obj3", OBJECTIVE_ACTIVE );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "FirstChief", nil );
	SetObjectOwner( AIHero, PLAYER_1 );
	SetObjectEnabled( AIHero, not nil );
	SetObjectOwner( "FirstTown", PLAYER_1 );
	OpenCircleFog( 80, 93, GROUND, 10, PLAYER_1 );
	sleep( 5 );
	MoveCamera( 80, 93, GROUND, 100, 3.14/3, 0, 1, 1, 1 );
	sleep( 15 );
	MoveCamera( x, y, level, 50, 3.14/3, 0, 1, 1, 1 );
	DisableAITurn();
end;	

---------- THIRD OBJECTIVE ----------

function ThirdObjectiveState()
	local x,y,level = GetObjectPosition( PlayerHero );
	local heroes = GetPlayerHeroes( PLAYER_3 );
	for i,hero in heroes do
		if hero ~= AIHero1 and hero ~= AIHero8 then
			if IsHeroAlive( hero ) then
				RemoveObject( hero );
			end;
		end;
	end;
	sleep( 3 );
	SetRegionBlocked( "PRB3", nil, PLAYER_1 );
	SetRegionBlocked( "PRB4", nil, PLAYER_1 );
	SetObjectiveState( "obj3", OBJECTIVE_COMPLETED );
	SetObjectiveState( "obj4", OBJECTIVE_ACTIVE );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "SecondChief", nil );
	SetObjectOwner( AIHero1, PLAYER_1 );
	SetObjectEnabled( AIHero1, not nil );
	SetObjectOwner( "SecondTown", PLAYER_1 );
	OpenCircleFog( 151, 128, GROUND, 10, PLAYER_1 );
	sleep( 5 );
	MoveCamera( 151, 128, GROUND, 100, 3.14/3, 0, 1, 1, 1 );
	sleep( 15 );
	MoveCamera( x, y, level, 50, 3.14/3, 0, 1, 1, 1 );
	MessageBox( "/Maps/Scenario/a2c2m2/message07.txt" );
	OpenCircleFog( 25, 77, GROUND, 6, PLAYER_1 );
	OpenCircleFog( 27, 84, GROUND, 6, PLAYER_1 );
	DisableAITurn();
end;

TemporaryHero = PlayerHero;

function GuardMessage( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		TemporaryHero = heroName;
		if GetObjectiveState( "obj3" ) == OBJECTIVE_ACTIVE or GetObjectiveState( "obj3" ) == OBJECTIVE_UNKNOWN then
			MessageBox( "/Maps/Scenario/a2c2m2/message05.txt" );
		elseif GetObjectiveState( "obj3" ) == OBJECTIVE_COMPLETED then
			QuestionBox( "/Maps/Scenario/a2c2m2/message06.txt", "QuestionBoxYes", "QuestionBoxNo" );
			Trigger( OBJECT_TOUCH_TRIGGER, "Guard", nil );
		end;
	end;
end;

function QuestionBoxYes()
	RemoveObject( "Guard" );
	AddHeroCreatures( TemporaryHero, CREATURE_CYCLOP_UNTAMED, 3 );
end;

function QuestionBoxNo()
	RemoveObject( "Guard" );
end;

Trigger( OBJECT_TOUCH_TRIGGER, "Guard", "GuardMessage" );	

---------- FOURTH OBJECTIVE ----------

function FourthObjectiveState()
	local x,y,level = GetObjectPosition( PlayerHero );
	local heroes = GetPlayerHeroes( PLAYER_4 );
	for i,hero in heroes do
		if hero ~= AIHero2 and hero ~= AIHero10 then
			if IsHeroAlive( hero ) then
				RemoveObject( hero );
			end;
		end;
	end;
	sleep( 3 );
	SetRegionBlocked( "PRB5", nil, PLAYER_1 );
	SetRegionBlocked( "PRB6", nil, PLAYER_1 );
	SetObjectiveState( "obj4", OBJECTIVE_COMPLETED );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ThirdChief", nil );
	SetObjectOwner( AIHero2, PLAYER_1 );
	SetObjectEnabled( AIHero2, not nil );
	SetObjectOwner( "ThirdTown", PLAYER_1 );
	if GetObjectiveState( "obj5" ) == OBJECTIVE_UNKNOWN then
		SetObjectiveState( "obj5", OBJECTIVE_ACTIVE );	
		OpenCircleFog( 99, 43, GROUND, 10, PLAYER_1 );
		sleep( 5 );
		MoveCamera( 99, 43, GROUND, 100, 3.14/3, 0, 1, 1, 1 );
		sleep( 15 );
		MoveCamera( x, y, level, 50, 3.14/3, 0, 1, 1, 1 );
	end;
	DisableAITurn();
end;

---------- FIFTH OBJECTIVE ----------

function FifthObjectiveState()	
	local heroes = GetPlayerHeroes( PLAYER_5 );
	for i,hero in heroes do
		if hero ~= AIHero3 and hero ~= AIHero11 then
			if IsHeroAlive( hero ) then
				RemoveObject( hero );
			end;
		end;
	end;
	sleep( 3 );
	SetRegionBlocked( "PRB7", nil, PLAYER_1 );
	SetRegionBlocked( "PRB8", nil, PLAYER_1 );
	SetObjectiveState( "obj5", OBJECTIVE_COMPLETED );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "FourthChief", nil );
	SetObjectOwner( AIHero3, PLAYER_1 );
	SetObjectEnabled( AIHero3, not nil );
	SetObjectOwner( "FourthTown", PLAYER_1 );
end;	

function Objective5Activation( heroName )
	if GetObjectOwner( heroName ) == PLAYER_1 then	
		if GetObjectiveState( "obj5" ) == OBJECTIVE_UNKNOWN then
			SetObjectiveState( "obj5", OBJECTIVE_ACTIVE );
			OpenCircleFog( 99, 43, GROUND, 10, PLAYER_1 );
			sleep( 5 );
			MoveCamera( 99, 43, GROUND, 100, 3.14/3, 0, 1, 1, 1 );
			sleep( 15 );
			MoveCamera( x, y, level, 50, 3.14/3, 0, 1, 1, 1 );
		end;
	end;
end;
	
Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "SeaBlock3", "Objective5Activation" )

function VoiceOver6( heroName )
	if heroName == AIHero5 then	
		Play2DSound( "/Maps/Scenario/A2C2M2/C2M2_VO6_Kujin_01sound.xdb#xpointer(/Sound)" );
	end;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_5, "VoiceOver6" );

---------- SIXTH OBJECTIVE ----------

function SixthObjective()
	if IsHeroAlive( PlayerHero ) == nil then
		SetObjectiveState( "obj6", OBJECTIVE_FAILED );
		Loose();
	end;
end;
	
Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "SixthObjective" );	

x = 0;
y = 0;
level = 0;
NotKujin = 0;

function StartAdvMapDialog4( heroName )
	x,y,level = GetObjectPosition( PlayerHero );
	if GetObjectOwner( heroName ) == PLAYER_1 and heroName == PlayerHero then
		SetObjectRotation( "OrcishMate", 225 );
		SetObjectPosition( "OrcishMate", 118, 36, GROUND );
		StartAdvMapDialog( 4, "RemoveTrigger" );
	elseif GetObjectOwner( heroName ) == PLAYER_1 and heroName ~= PlayerHero then
		NotKujin = 1;
		SetObjectRotation( "OrcishMate", 225 );
		SetObjectPosition( "OrcishMate", 118, 36, GROUND );
		SetObjectRotation( PlayerHero, 180 );
		SetObjectPosition( PlayerHero, 123, 37, GROUND );
		StartAdvMapDialog( 4, "RemoveTrigger" );
		print( heroName );
	end;
end;

function RemoveTrigger()
	MessageBox( "/Maps/Scenario/a2c2m2/message02.txt" );
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "AdvMapDialog4", nil );
	RemoveObject( "OrcishMate" );
	if NotKujin == 1 then
		sleep( 4 );
		SetObjectPosition( PlayerHero, x, y, level );
	end;
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "AdvMapDialog4", "StartAdvMapDialog4" );

---------- AI TURN CONTROL ----------

function DisableAITurn()
	if GetObjectiveState( "obj2" ) == OBJECTIVE_COMPLETED and DAT == 0 then
		DAT = 1;
		DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes ( PLAYER_2, 1 );
	end;
	if GetObjectiveState( "obj3" ) == OBJECTIVE_COMPLETED and DAT1 == 0 then
		DAT1 = 1;
		DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes ( PLAYER_3, 1 );
	end; 
	if GetObjectiveState( "obj4" ) == OBJECTIVE_COMPLETED and DAT2 == 0 then
		DAT2 = 1;
		DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes ( PLAYER_4, 1 );
	end; 
end;

---------- ORC AI CONTROL ----------

HarassHero = "Hero2"
DeployCount = 0;
HeroLevel = 0;
deployDay = 1;

function PortalCapture()
	if GetDate( DAY ) == ( 35 - diff ) then	
		if IsHeroAlive( HarassHero ) and DeployCount < 1 then
			SetRegionBlocked( "PortalBlock", nil, PLAYER_5 );
			sleep( 1 );
			if CanMoveHero( HarassHero, 110, 93, GROUND ) then	
				MoveHero( HarassHero, 110, 90, GROUND );
			end;
			SetAIHeroAttractor( "TealPortal", HarassHero, 1 );
			print( "Orcs Orcs Orcs ! Coming to pwn Player" );
		end;
	end;
end;

function HeroOperator()
	if IsHeroAlive( HarassHero ) == nil then
		if GetDate( DAY_OF_WEEK ) == deployDay then
			deployDay = ( 1 + random( 6 ) );
			print( "deployDay = ", deployDay );
			if HarassHero == "Hero2" then
				HarassHero = "Hero3"
			elseif HarassHero == "Hero3" then
				HarassHero = "Hero7"
			elseif HarassHero == "Hero7" then
				HarassHero = "Hero2"
			end;
			print( "Active hero is ", HarassHero );
			sleep( 1 );
			DeployReserveHero( HarassHero, 107, 45, GROUND );
			DeployCount = DeployCount + 1;
			sleep( 1 );
			SetHeroRoleMode( HarassHero, HERO_ROLE_MODE_HERMIT );
			AIHeroSetUp();
			startThread( HeroMovement );
		end;
	end;
end;

function HeroMovement()
	while IsHeroAlive( HarassHero ) do
		x,y = GetObjectPosition( HarassHero );
		if CanMoveHero( HarassHero, 110, 93, GROUND ) then	
			MoveHero( HarassHero, 110, 93, GROUND );
		end;
		if x == 110 and y == 93 then
			target = random( 2 ) + 1;
			if target == 1 then
				if GetObjectOwner( "SecondTown" ) == PLAYER_1 then
					SetAIHeroAttractor( "SecondTown", HarassHero, 2 );
				end;
			elseif target == 2 then
				if GetObjectOwner( "FirstTown" ) == PLAYER_1 then
					SetAIHeroAttractor( "FirstTown", HarassHero, 2 );
				end;
			end;
			print( "target ", target );
			break;
		end;
		sleep( 3 );
	end;
end;

function AIHeroSetUp()
	for creatureID = 1, CREATURES_COUNT - 1 do 
		CreatureSetUp = GetHeroCreatures( HarassHero, creatureID );
		if GetHeroCreatures( HarassHero, creatureID ) > 2 then
			RemoveHeroCreatures( HarassHero, creatureID, CreatureSetUp );
			AddHeroCreatures( HarassHero, creatureID, CreatureSetUp + ( ( CreatureSetUp + DeployCount ) * diff / 100 * 40) * diff );
		end;
	end;
	ChangeHeroStat( HarassHero, STAT_EXPERIENCE, 10000 + 500 * ( diff + DeployCount ) );
end;

---------- PIRATES ----------

PiratesActive = 0;

function EnableAI()
	start = random( 3 ) + GetDate( DAY )
	DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes ( PLAYER_6, 0 );
	EnableHeroAI( AIHero6, not nil );
	EnableHeroAI( AIHero7, not nil );
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "PiratesActivation", nil );
	PiratesActive = 1;
end;

function H55_TriggerDaily()
	if 	PiratesActive == 1 then
		if GetDate( DAY ) == start then
			x,y,level = GetObjectPosition( PlayerHero );
			for i,pirat in pirates do	
				if CanMoveHero( pirat, x, y, level ) then
					MoveHero( pirat, x, y, level );
				else	
					SetAIHeroAttractor( PlayerHero, pirat, 2 );
				end;
			end;
		end;
	end;
	sleep( 1 );
	PortalCapture();
	HeroOperator();
	print("AI Attractor finished");
end;

function ShowMessage( heroName )
	if heroName == PlayerHero then	
		SetObjectEnabled( AIHero4, not nil );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "AdvMapDialog1", nil );
		StartAdvMapDialog( 5, "ShowMessageToPlayer" );
	elseif heroName ~= PlayerHero and GetObjectOwner( heroName ) == PLAYER_1 then
		MessageBox( "/Maps/Scenario/a2c2m2/message08.txt" );
	end;
end;

function ShowMessageToPlayer()
	MessageBox( "/Maps/Scenario/a2c2m2/message01.txt" );
end;

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "AdvMapDialog1", "ShowMessage" );

Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "PiratesActivation", "EnableAI" );

DiffSetup();