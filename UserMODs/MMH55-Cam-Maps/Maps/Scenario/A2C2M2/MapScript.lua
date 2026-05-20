doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");
doFile("/scripts/campaign_common.lua");
doFile("/scripts/campaign_ai.lua");

-- loop gatekeeps code execution until vars and funcs are loaded
while not COMBAT or not InitAllSetArtifacts or not H55c_AI_UpdateTargetWeight do
    sleep()
end

H55_RemoveTheseArtifactsFromBanks = {
	ARTIFACT_TAROT_DECK,
	ARTIFACT_ENDLESS_BAG_OF_GOLD
};

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

function startSetArtifactsInit()
	InitAllSetArtifacts( "A2C2M2", PlayerHero );
end
startThread( startSetArtifactsInit );

H55c_AI_CONTROLLED = {
  player1 = {          -- Yellow HUMAN player
      state = 0,
	   heroes = {},
	  enemies = {},
  },
  player2 = { 		   -- Orange Tribe
		state = 1,
		heroes = {},
		heroes = {},
		enemies = {},
  },
  player3 = { 		   -- Brown Tribe
		state = 1,
		heroes = {},
		heroes = {},
		enemies = {},
  },
  player4 = { 		   -- Green Tribe
		state = 1,
		heroes = {},
		heroes = {},
		enemies = {},
  },
  player5 = { 		   -- Light Blue Tribe
		state = 1,
		heroes = {},
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER5
			{ priority = 0.3, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER6
		}
  },
  player6 = { 		   -- Purple Dungeon Pirates
		state = 2,
		heroes = {},
		heroes = {},
		enemies = {
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER1
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER2
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER3
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER4
			{ priority = 0.3, heroes = 1.0, towns = 1.0, is_enemy = 1 },  -- PLAYER5
			{ priority = 1.0, heroes = 1.0, towns = 1.0, is_enemy = 0 },  -- PLAYER6
		}
  }
}

eheroes = { AIHero4, AIHero5, AIHero6, AIHero7 };
ORC_HARASS_HEROES = { "Hero2", "Hero3", "Hero7" };

DIFFICULTY = {
	[0] = function()
		diff = 2;
		print("Difficulty level is normal.");
	end,
	
	[1] = function()
		diff = 2;
		print("Difficulty level is hard.");
	end,
	
	[2] = function()
		diff = 3;
		print("Difficulty level is heroic.");
	end,
	
	[3] = function()
		diff = 4;
		print("Difficulty level is impossible.");
	end,
}

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

---------- FIRST OBJECTIVE ----------

function VoiceOver4()
	Play2DSound( "/Maps/Scenario/A2C2M2/C2M2_VO4_Kujin_01sound.xdb#xpointer(/Sound)" );
end;

---------- OBJECTIVE INIT ----------

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
	DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes ( PLAYER_2, 1 );
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
	DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes ( PLAYER_3, 1 );
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
	DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes ( PLAYER_4, 1 );
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

function AIHeroSetUp(wave, hero)
	for creatureID = 1, CREATURES_COUNT - 1 do 
		CreatureSetUp = GetHeroCreatures( hero, creatureID );
		if GetHeroCreatures( hero, creatureID ) > 2 then
			RemoveHeroCreatures( hero, creatureID, CreatureSetUp );
			AddHeroCreatures( hero, creatureID, CreatureSetUp + ( ( CreatureSetUp + wave ) * diff / 100 * 40) * diff );
		end;
	end;
	ChangeHeroStat( hero, STAT_EXPERIENCE, 10000 + 500 * ( diff + wave ) );
end;

---------- PIRATES ----------

function EnablePirates()
	Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "PiratesActivation", nil );
	OBJECTIVES.state.pirates[2] = 1;
end

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

OBJECTIVES = {
	state = {
		  isAlive = { "obj6", 1 }, 	-- Kujin must survive
		  pirates = {    "_", 0 }, 	-- Pirates are enabled when the first hero leaves for the sea
		orcHarass = {    "_", 1 }, 	-- AI Player 5 harassment against the human player
	},

    start = function()
		OBJECTIVES.prepare();
		OBJECTIVES.run();
    end,
	
	prepare = function()
		Trigger(  REGION_ENTER_AND_STOP_TRIGGER,  "FirstChief",  "ObjectiveInit" );
		Trigger(  REGION_ENTER_AND_STOP_TRIGGER, "SecondChief",  "ObjectiveInit" );
		Trigger(  REGION_ENTER_AND_STOP_TRIGGER,  "ThirdChief",  "ObjectiveInit" );
		Trigger(  REGION_ENTER_AND_STOP_TRIGGER, "FourthChief",  "ObjectiveInit" );
		SetObjectEnabled(  AIHero, nil );
		SetObjectEnabled( AIHero1, nil );
		SetObjectEnabled( AIHero2, nil );
		SetObjectEnabled( AIHero3, nil );
		Trigger( OBJECT_TOUCH_TRIGGER, "Guard", "GuardMessage" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "AdvMapDialog4", "StartAdvMapDialog4" );
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "AdvMapDialog1",        "ShowMessage" );
		Trigger( REGION_ENTER_WITHOUT_STOP_TRIGGER, "PiratesActivation", "EnablePirates" );
		DIFFICULTY[GetDifficulty()]();
		SetHeroesExpCoef( 0.4 );
		DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes (PLAYER_6, not nil);
		SetObjectiveState( "obj1", OBJECTIVE_ACTIVE );
		SetObjectiveState( "obj2", OBJECTIVE_ACTIVE );
		SetObjectiveState( "obj6", OBJECTIVE_ACTIVE );
		DenyAIHeroFlee(  AIHero4, not nil );
		DenyAIHeroFlee(  AIHero5, not nil );
		EnableHeroAI(  AIHero, nil );
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
		EnableHeroAI(  AIHero8, nil );
		EnableHeroAI(  AIHero9, nil );
		EnableHeroAI( AIHero10, nil );
		EnableHeroAI( AIHero11, nil );
		SetHeroRoleMode( "Hero3", HERO_ROLE_MODE_HERMIT );
		SetHeroRoleMode( "Hero2", HERO_ROLE_MODE_HERMIT );
		SetRegionBlocked( "FirstChiefBlock", not nil, PLAYER_2 );
		SetRegionBlocked(		"SeaBlock1", not nil, PLAYER_3 );
		SetRegionBlocked(		"SeaBlock2", not nil, PLAYER_5 );
		SetRegionBlocked(		"SeaBlock3", not nil, PLAYER_6 );
		SetRegionBlocked(	  "PortalBlock", not nil, PLAYER_5 );
		SetRegionBlocked(			 "PRB1", not nil, PLAYER_1 );
		SetRegionBlocked(			 "PRB2", not nil, PLAYER_1 );
		SetRegionBlocked( 			"PRB3", not nil, PLAYER_1 );
		SetRegionBlocked( 			"PRB4", not nil, PLAYER_1 );
		SetRegionBlocked( 			"PRB5", not nil, PLAYER_1 );
		SetRegionBlocked( 			"PRB6", not nil, PLAYER_1 );
		SetRegionBlocked( 			"PRB7", not nil, PLAYER_1 );
		SetRegionBlocked( 			"PRB8", not nil, PLAYER_1 );	
		SetObjectEnabled(   "Guard", nil );
		SetObjectEnabled(  "Victim", nil );
		SetObjectEnabled( "Victim1", nil );
		SetObjectEnabled( "Victim2", nil );
		sleep( 1 );
		SetDisabledObjectMode(   "Guard", DISABLED_INTERACT );
		SetDisabledObjectMode(  "Victim",  DISABLED_BLOCKED );
		SetDisabledObjectMode( "Victim1",  DISABLED_BLOCKED );
		SetDisabledObjectMode( "Victim2",  DISABLED_BLOCKED );
		
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
			
			if GetObjectiveState('obj6') == OBJECTIVE_FAILED then
				Loose();
				return
			end
			
			if GetObjectiveState("obj2") == OBJECTIVE_COMPLETED and GetObjectiveState("obj3") == OBJECTIVE_COMPLETED and GetObjectiveState("obj4") == OBJECTIVE_COMPLETED and GetObjectiveState("obj5") == OBJECTIVE_COMPLETED then
				startThread( VoiceOver4 );
				SaveHeroAllSetArtifactsEquipped( PlayerHero, "A2C2M2" );
				SetObjectiveState( "obj1", OBJECTIVE_COMPLETED );
				SetObjectiveState( "obj6", OBJECTIVE_COMPLETED );
				sleep( 15 );
				Win();
				return
			end
		end
	end,
	
	isAlive = function()
		if OBJECTIVES.state.isAlive[2] == 1 and IsHeroAlive( PlayerHero ) == nil then
			SetObjectiveState( "obj6", OBJECTIVE_FAILED );
			OBJECTIVES.state.isAlive[2] = 11;
		end
	end,
	
	pirates_start = 0,
	pirates = function()
		if OBJECTIVES.state.pirates[2] == 1 then
			OBJECTIVES.pirates_start = random( 3 ) + OBJECTIVES.date;
			OBJECTIVES.state.pirates[2] = 2;
		elseif OBJECTIVES.state.pirates[2] == 2 and OBJECTIVES.pirates_start <= OBJECTIVES.date then
			DoNotGiveTurnToPlayerAIIfNoTownsAndActiveHeroes( PLAYER_6, 0 );
			H55c_AIAddHero(AIHero6);
			H55c_AIAddHero(AIHero7);
			OBJECTIVES.state.pirates[2] = 10;
		end
	end,

	orcHarass_wave = 0,
	orcHarass_assaultDay = 9999,
	orcHarass_hero = "Hero2",
	orcHarass = function()
		if OBJECTIVES.state.orcHarass[2] == 1 and OBJECTIVES.date >= 40 - GetDifficulty() then
			SetRegionBlocked( "PortalBlock", nil, PLAYER_5 );
			OBJECTIVES.orcHarass_assaultDay = OBJECTIVES.date;
			OBJECTIVES.state.orcHarass[2] = 2;
		elseif OBJECTIVES.state.orcHarass[2] == 2 and OBJECTIVES.orcHarass_assaultDay < OBJECTIVES.date and IsHeroAlive(OBJECTIVES.orcHarass_hero) == nil then
			OBJECTIVES.orcHarass_hero = ORC_HARASS_HEROES[math.mod(OBJECTIVES.orcHarass_wave, 3) + 1];
			print( "Active hero is "..OBJECTIVES.orcHarass_hero );
			DeployReserveHero( OBJECTIVES.orcHarass_hero, 107, 45, GROUND );
			sleep(10);
			SetObjectPosition(OBJECTIVES.orcHarass_hero, 81, 47, 0);
			AIHeroSetUp( OBJECTIVES.orcHarass_wave + 1, OBJECTIVES.orcHarass_hero );
			--H55c_AIAddHero( OBJECTIVES.orcHarass_hero );
			OBJECTIVES.orcHarass_wave = OBJECTIVES.orcHarass_wave + 1;
			OBJECTIVES.orcHarass_assaultDay = 7 + math.random(7);
		end
	end
}

------------------- MAIN ------------------------
startThread( OBJECTIVES.start )
startThread( H55c_AI_main )

-- sleep(50);
-- pcall(H55_NoFog, 1);
-- H55_Speedrun(1);
-- SetObjectPosition("Kujin", 32, 30);

-- function t2()
	-- SetObjectPosition("Kujin", 79, 83);
-- end

-- function t3()
	-- SetObjectPosition("Kujin", 24, 73);
-- end