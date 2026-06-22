doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C2M4");
	LoadHeroAllSetArtifacts( "Wulfstan", "A1C2M3" );
	LoadHeroAllSetArtifacts(   "Duncan", "A1C1M5" );
	sleep(40);
	H55_CamFixTooManySkills( PLAYER_1, "Wulfstan" );
	H55_CamFixTooManySkills( PLAYER_2,   "Duncan" );
end

startThread(H55_InitSetArtifacts);

REINFORCE_DWARVES = 10;
ENEMY_TOWN_TOR_HALLR = "Tor_Hallr";
POSSIBLE_PRICES = {{"Maps/Scenario/A1C2M4/MessageBox_WantToPayGold.txt", GOLD, 3000},
				   {"Maps/Scenario/A1C2M4/MessageBox_WantToPayOre.txt", ORE, 25},
				   {"Maps/Scenario/A1C2M4/MessageBox_WantToPayWood.txt", WOOD, 25},
				   {"Maps/Scenario/A1C2M4/MessageBox_WantToPayCrystal.txt", CRYSTAL, 15},
				   {"Maps/Scenario/A1C2M4/MessageBox_WantToPayGem.txt", GEM, 15},
				   {"Maps/Scenario/A1C2M4/MessageBox_WantToPaySulfur.txt", SULFUR, 15},
				   {"Maps/Scenario/A1C2M4/MessageBox_WantToPayMercury.txt", MERCURY, 15},
				};

GNOMIGS =  {CREATURE_DEFENDER,
			CREATURE_STOUT_DEFENDER,
			CREATURE_AXE_FIGHTER,
			CREATURE_AXE_THROWER,
			CREATURE_BEAR_RIDER,
			CREATURE_BLACKBEAR_RIDER,
			CREATURE_BROWLER,
			CREATURE_BERSERKER,
			CREATURE_RUNE_MAGE,
			CREATURE_FLAME_MAGE,
			CREATURE_THANE,
			CREATURE_WARLORD,
			CREATURE_FIRE_DRAGON,
			CREATURE_MAGMA_DRAGON,
			CREATURE_STONE_DEFENDER,
			CREATURE_HARPOONER,
			CREATURE_WHITE_BEAR_RIDER,
			CREATURE_BATTLE_RAGER,
			CREATURE_FLAME_KEEPER,
			CREATURE_THUNDER_THANE,
			CREATURE_LAVA_DRAGON}

-- Variables:
firstMeeting = 0;
assembledDwarves = 0;
waitUntilAnswer = 1;

function A1C2M4_SetEenmyHeroesArmy(koef)
	AddObjectCreatures( ENEMY_TOWN_TOR_HALLR, CREATURE_LONGBOWMAN, 125 * koef );
	AddObjectCreatures( ENEMY_TOWN_TOR_HALLR, CREATURE_VINDICATOR, 100 * koef );
	AddObjectCreatures( ENEMY_TOWN_TOR_HALLR,     CREATURE_ZEALOT,  35 * koef );
	AddObjectCreatures( ENEMY_TOWN_TOR_HALLR,   CREATURE_CHAMPION,  20 * koef );
	AddObjectCreatures( ENEMY_TOWN_TOR_HALLR,     CREATURE_SERAPH,   6 * koef );
	GiveExp( "Brem", 1 + 80000 * math.pow(2,koef));
	ChangeHeroStat("Brem",      STAT_ATTACK, 4 * koef);
	ChangeHeroStat("Brem",     STAT_DEFENCE, 4 * koef);
	ChangeHeroStat("Brem", STAT_SPELL_POWER, 2 * koef);
	ChangeHeroStat("Brem",   STAT_KNOWLEDGE, 2 * koef);
	AddHeroCreatures("Rolf", 	CREATURE_DEFENDER, 30 * koef);
	AddHeroCreatures("Rolf", CREATURE_AXE_THROWER, 20 * koef);
	AddHeroCreatures("Rolf",   CREATURE_RUNE_MAGE,  4 * koef);
	AddHeroCreatures("Rolf",   CREATURE_BERSERKER,  7 * koef);
	AddHeroCreatures("Rolf", 	 CREATURE_WARLORD,  2 * koef);
	AddHeroCreatures("Rolf", CREATURE_FIRE_DRAGON,  1 * koef);
	AddHeroCreatures("Rolf",  CREATURE_BEAR_RIDER, 10 * koef);
	ChangeHeroStat("Rolf",      STAT_ATTACK, 4 * koef);
	ChangeHeroStat("Rolf",     STAT_DEFENCE, 4 * koef);
	ChangeHeroStat("Rolf", STAT_SPELL_POWER, 2 * koef);
	ChangeHeroStat("Rolf",   STAT_KNOWLEDGE, 2 * koef);
	GiveExp("Rolf", 1 + 20000 * math.pow(2,koef));
end

	if GetDifficulty() == DIFFICULTY_EASY then
		SetPlayerStartResources(PLAYER_1, 30, 30, 10, 10, 10, 10, 10000);
		A1C2M4_SetEenmyHeroesArmy(1);
		print("Difficulty level is EASY");
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		SetPlayerStartResources(PLAYER_1, 20, 20, 5, 5, 5, 5, 7000);
		A1C2M4_SetEenmyHeroesArmy(2);
		print("Difficulty level is NORMAL");
	elseif GetDifficulty() == DIFFICULTY_HARD then
		SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 3000);
		A1C2M4_SetEenmyHeroesArmy(3);
		print("Difficulty level is HARD");
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		SetPlayerStartResources(PLAYER_1, 0, 0, 0, 0, 0, 0, 0);
		A1C2M4_SetEenmyHeroesArmy(4);
		print("Difficulty level is HEROIC");
	end
	
StartAdvMapDialog( 0 );
sleep( 3 );
DisableCameraFollowHeroes(0,1,0);

function enableObjects()
	sleep(5);
	SetObjectEnabled("Duncan",nil);
	SetRegionBlocked( "dwarvenBlock1", not nil, PLAYER_2 );
	SetRegionBlocked( "dwarvenBlock2", not nil, PLAYER_2 );
	EnableHeroAI("Duncan",nil);
	EnableHeroAI("Brem",nil);
	EnableHeroAI("Rolf",nil);
	EnableAIHeroHiring(PLAYER_2,ENEMY_TOWN_TOR_HALLR,nil);
	SetObjectEnabled("gnomig02",nil);
	SetObjectEnabled("axe_thrower01",nil);
	SetObjectEnabled("axe_thrower02",nil);
	SetObjectEnabled("medved01",nil);
	SetObjectEnabled("medved02",nil);
	SetObjectEnabled("brawler01",nil);
	SetObjectEnabled("brawler02",nil);
	SetObjectEnabled("defender01",nil);
	SetObjectEnabled("defender02",nil);
	SetObjectEnabled("axe_fighter01",nil);
	SetObjectEnabled("axe_fighter02",nil);
	SetObjectEnabled("gnom_thane",nil);
	SetObjectEnabled("gnom_defender01",nil);
	SetObjectEnabled("gnom_defender02",nil);
	SetObjectEnabled("gnom_defender03",nil);
	SetObjectEnabled("gnom_medved01",nil);
	SetObjectEnabled("gnom_medved02",nil);
	SetObjectEnabled("gnom_axe_thrower01",nil);
	SetObjectEnabled("magma_dragon",nil);
end

function GetObjectCreatureType( objectName )
	for i=1, table.length( GNOMIGS ) do
		if GetObjectCreatures( objectName, GNOMIGS[i] ) > 0 then return GNOMIGS[i]; end
	end
end

function IfWulfstanEnterRolfRegion(HeroName)
	print("wulfstan enters rolf region");
	if HeroName == "Wulfstan" then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack2",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "RedBorderArea",nil);
		print(HeroName, "has entered in rolf_attack region");
		EnableHeroAI("Rolf",not nil);
		ChangeHeroStat("Rolf",STAT_MOVE_POINTS,2500);
		MoveHeroRealTime("Rolf",49,66);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "rolf_arrive","RolfMoveToWulfstan");
		print("Rolf is moving...");
	end
end
		
function IfWulfstanEnterRedBorderRegion( heroName )
	print("wulfstan enters red border region");
	if heroName == "Wulfstan" then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack2",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "RedBorderArea",nil);
		ChangeHeroStat("Rolf",STAT_MOVE_POINTS,2500);
		startThread(pursuitWulfstan);
		SetObjectiveState("RepulseRolf",OBJECTIVE_ACTIVE);
		startThread(Objective_RepulseRolf);
	end
end


function IfWulfstanEnterRolfRegion2( heroName )
	print("wulfstan enters red border region");
	if heroName == "Wulfstan" then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack2",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "RedBorderArea",nil);
		ChangeHeroStat("Rolf",STAT_MOVE_POINTS,2500);
		startThread(pursuitWulfstan);
		SetObjectiveState("RepulseRolf",OBJECTIVE_ACTIVE);
		startThread(Objective_RepulseRolf);
	end
end
		
function RolfMoveToWulfstan()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "rolf_arrive",nil);
	EnableHeroAI("Rolf",not nil);
	MoveHeroRealTime("Rolf",65,95);
	ChangeHeroStat("Rolf",STAT_MOVE_POINTS,-2500);
	startThread(pursuitWulfstan);
	SetObjectiveState("RepulseRolf",OBJECTIVE_ACTIVE);
	startThread(Objective_RepulseRolf);
end
	
function MeetingWithDuncan(HeroName)
	if HeroName == "Wulfstan" then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "duncan_meeting",nil);
		ChangeHeroStat("Duncan",STAT_MOVE_POINTS,2500);
		print("Duncan is moving to the meeting");
		while H55_GetDistance("Duncan", "Wulfstan") > 3.0 and H55_GetDistance("Duncan", "Wulfstan") < 1000 do
			EnableHeroAI("Duncan",not nil);
			MoveHeroRealTime("Duncan",GetObjectPosition("Wulfstan"));
			sleep(2);
		end
		print(HeroName, " has entered in region 'duncan meeting'");
		StartDialogScene("/DialogScenes/A1C2/M4/S2/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectOwner("Duncan",PLAYER_1);
		SetObjectEnabled("Duncan",not nil);
		SetObjectiveState("find_duncan",OBJECTIVE_COMPLETED);
		sleep(10);
		SetObjectiveState("duncan_must_survive",OBJECTIVE_ACTIVE);
		startThread(DuncanMustSurvive);
	end
end


function wantToPay()
	print("yes");
	waitUntilAnswer = 2;
end

function dontWantToPay()
	print("no");
	QuestionBox("Maps/Scenario/A1C2M4/MessageBox_WantToFight.txt", "wantToFight", "dontWantToFight");
end

function wantToFight()
	waitUntilAnswer = 3;
end

function dontWantToFight()
	waitUntilAnswer = 4;
end

function GnomigRequest( heroName, objectName )
	if GetObjectOwner(heroName) ~= PLAYER_1 then
		RemoveObject(objectName);
		return
	end
	if firstMeeting == 0 then 
		firstMeeting = 1;
		SetObjectiveState("ReinforceDwarves", OBJECTIVE_ACTIVE);
		startThread(sec_objectiveReinforceDwarves);
	end
	paymentType = 1 + random(6);
	waitUntilAnswer = 1;
	QuestionBox(POSSIBLE_PRICES[paymentType][1], "wantToPay","dontWantToPay");
	startThread( fightGnom, objectName );
	startThread( wantToPayGnomigs, objectName, paymentType);
end

function wantToPayGnomigs( objectName, paymentType )
	while waitUntilAnswer == 1 do sleep(3); end
	if waitUntilAnswer == 2 then
		print("Type of resource is ", POSSIBLE_PRICES[paymentType][2]);	
		print("Required quantity of this resource is ", POSSIBLE_PRICES[paymentType][3]);	
		RequiredResource = POSSIBLE_PRICES[paymentType][2];
		PriceOfJoin = POSSIBLE_PRICES[paymentType][3];
		print("Player has ",GetPlayerResource(PLAYER_1, RequiredResource)," of this resource");
		if GetPlayerResource(PLAYER_1, RequiredResource) >= PriceOfJoin then
			Trigger( OBJECT_TOUCH_TRIGGER, objectName, nil );
			creatureType = GetObjectCreatureType( objectName );
			crtsQuantity = GetObjectCreatures( objectName, creatureType )
			Trigger(OBJECT_TOUCH_TRIGGER, objectName , nil)
			SetPlayerResource(PLAYER_1, RequiredResource, GetPlayerResource(PLAYER_1, RequiredResource) - PriceOfJoin );
			AddHeroCreatures("Wulfstan", creatureType, crtsQuantity);
			RemoveObject( objectName );
			print("Unit ", objectName, " has joined to your glorious army");
			assembledDwarves = assembledDwarves  + 1;
			SetObjectiveProgress("ReinforceDwarves",assembledDwarves);
		else
			MessageBox("Maps/Scenario/A1C2M4/MsgBox_NotEnoughResources.txt");
		end
	end
end

function fightGnom( objectName )
	while waitUntilAnswer == 1 do sleep(3); end
	if waitUntilAnswer == 3 then
		creatureType = GetObjectCreatureType( objectName );
		crtsQuantity = GetObjectCreatures( objectName, creatureType )
		print( "Wulfstan want to fight vs ", objectName  );
		Trigger(OBJECT_TOUCH_TRIGGER, objectName , nil)
		intPart = (crtsQuantity - mod(crtsQuantity,4)) / 4;
		modPart = mod(crtsQuantity,4);
		if modPart == 0 then modPart = intPart; end
		StartCombat( "Wulfstan", nil, 4, creatureType,intPart, creatureType,intPart, creatureType,intPart, creatureType,modPart, nil, "CombatResult");
		RemoveObject( objectName );
	else
		print( "Wulfstan leave ", objectName," without combat" );
	end
end

function CombatResult( heroName, result)
	if result ~= nil then 
		print("Our glorious hero win!");
	end
end
	
function pursuitWulfstan()
	print("pursuit wulfstan by rolf is starting");
	while 1 do
		while GetCurrentPlayer() ~= PLAYER_2 do sleep(3); end
			if IsHeroAlive("Rolf") == not nil and IsHeroAlive("Wulfstan") == not nil then
				EnableHeroAI("Rolf",not nil);
				if CanMoveHero( "Rolf", GetObjectPosition("Wulfstan")) == not nil then
					MoveHero("Rolf",GetObjectPosition("Wulfstan"));
				else
					print("Can't find path to destination point");
				end
			else
				print("Rolf is dead");
				break;
			end
			sleep(3);
		while GetCurrentPlayer() == PLAYER_2 do sleep(3); end
	end
end

-- ========== OBJECTIVES =================== --
function WulfstanMustSurvive(HeroName)
	if HeroName == "Wulfstan" then 
		SetObjectiveState("wulfstan_must_survive",OBJECTIVE_FAILED);
		sleep(10);
		Loose();
	end
end

function DuncanMustSurvive()
	print("Thread DuncanMustSurvive has been started...");
	while IsHeroAlive("Duncan") == not nil do
		sleep(5);
	end
	print("Our hero Duncan is dead");
	SetObjectiveState("duncan_must_survive",OBJECTIVE_FAILED);
	sleep(10);
	Loose();
end

function CaptureTorHallr(OldOwner,NewOwner,HeroName)
	if NewOwner == PLAYER_1 then 
		Trigger(OBJECT_CAPTURE_TRIGGER, ENEMY_TOWN_TOR_HALLR, nil);
		SaveHeroAllSetArtifactsEquipped( "Wulfstan", "A1C2M4" );
		sleep(10);
		SaveHeroAllSetArtifactsEquipped( "Duncan", "A1C2M4" );
		SetObjectiveState("capture_tor_hallr",OBJECTIVE_COMPLETED);
		sleep(10);
		SetObjectiveState("wulfstan_must_survive",OBJECTIVE_COMPLETED);
		sleep(10);
		SetObjectiveState("duncan_must_survive",OBJECTIVE_COMPLETED);
		sleep(10);
		startThread(PlayerWin);
	end
end

function Objective_RepulseRolf()
	while IsHeroAlive("Rolf") == not nil do sleep(3); end
	StartDialogScene("/DialogScenes/A1C2/M4/S1/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState("RepulseRolf",OBJECTIVE_COMPLETED);
end

function sec_objectiveReinforceDwarves()
	while assembledDwarves < REINFORCE_DWARVES do sleep(2); end
	print("All dwarves have assembled!!!");
	SetObjectiveState("ReinforceDwarves", OBJECTIVE_COMPLETED);
	LevelUpHero("Wulfstan");
end

function PlayerWin()
	while GetObjectiveState("capture_tor_hallr") ~= OBJECTIVE_COMPLETED or
		  GetObjectiveState("find_duncan") ~= OBJECTIVE_COMPLETED or
		  GetObjectiveState("RepulseRolf") ~= OBJECTIVE_COMPLETED do
		sleep( 50 );
	end
	Win(PLAYER_1);
end

enableObjects();
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack","IfWulfstanEnterRolfRegion");
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "RedBorderArea","IfWulfstanEnterRedBorderRegion");
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack2", "IfWulfstanEnterRolfRegion2");
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "duncan_meeting","MeetingWithDuncan");
Trigger(OBJECT_TOUCH_TRIGGER,"gnomig02","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"axe_thrower01","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"axe_thrower02","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"medved01","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"medved02","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"brawler01","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"brawler02","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"defender01","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"defender02","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"axe_fighter01","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"axe_fighter02","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"gnom_thane","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"gnom_defender01","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"gnom_defender02","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"gnom_defender03","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"gnom_medved01","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"gnom_medved02","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"gnom_axe_thrower01","GnomigRequest");
Trigger(OBJECT_TOUCH_TRIGGER,"magma_dragon","GnomigRequest");

-- OBJECTIVES
Trigger(PLAYER_REMOVE_HERO_TRIGGER , PLAYER_1, "WulfstanMustSurvive");
Trigger(OBJECT_CAPTURE_TRIGGER, ENEMY_TOWN_TOR_HALLR, "CaptureTorHallr");
print("All triggers and functions run");

reinforce_day = 8;
function reinforceRutger() 
	local diff = GetDifficulty() + 1;
	while 1 do
		if reinforce_day <= GetDate(ABSOLUTE_DAY) then
			AddHeroCreatures( "Brem", 	  CREATURE_SERAPH,  1 * diff );
			AddHeroCreatures( "Brem", 	CREATURE_CHAMPION,  2 * diff );
			AddHeroCreatures( "Brem", 	  CREATURE_ZEALOT,  4 * diff );
			AddHeroCreatures( "Brem", CREATURE_VINDICATOR, 10 * diff );
			AddHeroCreatures( "Brem", CREATURE_LONGBOWMAN, 15 * diff );
			reinforce_day = reinforce_day + 7;
			print("Rutger reinforcements arrived!");
		end
		sleep(100);
	end
end

startThread(reinforceRutger);
