doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C2M4");
	LoadHeroAllSetArtifacts( "Wulfstan" , "A1C2M3" );
end;

startThread(H55_InitSetArtifacts);

--CONSTANTS:
OUR_HERO_WULFSTAN = "Wulfstan";
OUR_HERO_DUNCAN = "Duncan";
ENEMY_HERO_ROLF = "Rolf";
ENEMY_GARRISON_HERO = "Brem";
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
IsPlayerWantFight = 0;
IsPlayerWantPay = 0;
firstMeeting = 0;
assembledDwarves = 0;
waitUntilAnswer = 1;
isPursuit = 0;

print("Variables and Constants defined");

	if GetDifficulty() == DIFFICULTY_EASY then
		SetPlayerStartResource(PLAYER_1,ORE,30);
		SetPlayerStartResource(PLAYER_1,WOOD,30);
		SetPlayerStartResource(PLAYER_1,MERCURY,10);
		SetPlayerStartResource(PLAYER_1,SULFUR,10);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,10);
		SetPlayerStartResource(PLAYER_1,GEM,10);
		SetPlayerStartResource(PLAYER_1,GOLD,10000);
		print("Difficulty level is EASY");
		else
		if GetDifficulty() == DIFFICULTY_NORMAL then
			SetPlayerStartResource(PLAYER_1,ORE,20);
			SetPlayerStartResource(PLAYER_1,WOOD,20);
			SetPlayerStartResource(PLAYER_1,MERCURY,5);
			SetPlayerStartResource(PLAYER_1,CRYSTAL,5);
			SetPlayerStartResource(PLAYER_1,SULFUR,5);
			SetPlayerStartResource(PLAYER_1,GEM,5);
			SetPlayerStartResource(PLAYER_1,GOLD,7000);
			print("Difficulty level is NORMAL");
			else
			if GetDifficulty() == DIFFICULTY_HARD then
				SetPlayerStartResource(PLAYER_1,ORE,0);
				SetPlayerStartResource(PLAYER_1,WOOD,0);
				SetPlayerStartResource(PLAYER_1,MERCURY,0);
				SetPlayerStartResource(PLAYER_1,SULFUR,0);
				SetPlayerStartResource(PLAYER_1,CRYSTAL,0);
				SetPlayerStartResource(PLAYER_1,GEM,0);
				SetPlayerStartResource(PLAYER_1,GOLD,3000);
				print("Difficulty level is HARD");
				else
				if GetDifficulty() == DIFFICULTY_HEROIC then
					SetPlayerStartResource(PLAYER_1,ORE,0);
					SetPlayerStartResource(PLAYER_1,WOOD,0);
					SetPlayerStartResource(PLAYER_1,MERCURY,0);
					SetPlayerStartResource(PLAYER_1,SULFUR,0);
					SetPlayerStartResource(PLAYER_1,CRYSTAL,0);
					SetPlayerStartResource(PLAYER_1,GEM,0);
					SetPlayerStartResource(PLAYER_1,GOLD,0);
					print("Difficulty level is HEROIC");
				end;
			end;
		end;
	end;
	
StartAdvMapDialog( 0 );
sleep( 3 );
	
DisableCameraFollowHeroes(0,1,0);
-- ========== FUNCTIONS ==================== --

function enableObjects()
	sleep(5);
	SetObjectEnabled(OUR_HERO_DUNCAN,nil);
	SetRegionBlocked( "dwarvenBlock1", not nil, PLAYER_2 );
	SetRegionBlocked( "dwarvenBlock2", not nil, PLAYER_2 );
	EnableHeroAI(OUR_HERO_DUNCAN,nil);
	EnableHeroAI(ENEMY_GARRISON_HERO,nil);
	EnableHeroAI(ENEMY_HERO_ROLF,nil);
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
end;

-- Функция вычисляющая расстояние от объекта Object1 до объекта Object2.
-- Если объекты находятся на разных уровнях функция возвращает -1.
function Distance(Object1,Object2)
	Obj1_x,Obj1_y,Obj1_z = GetObjectPosition(Object1);
	Obj2_x,Obj2_y,Obj2_z = GetObjectPosition(Object2);
	if Obj1_z == Obj2_z then
		SQRT = sqrt((Obj1_x - Obj2_x)*(Obj1_x - Obj2_x) + (Obj1_y - Obj2_y)*(Obj1_y - Obj2_y));
		return SQRT;
		else
		print("Error. Objects are not at same ground level.");
		return -1;
	end;
end;

function GetObjectCreatureType( objectName )
	for i=1, table.length( GNOMIGS ) do
		if GetObjectCreatures( objectName, GNOMIGS[i] ) > 0 then return GNOMIGS[i]; end;
	end;
end;

function IfWulfstanEnterRolfRegion(HeroName)
	print("wulfstan enters rolf region");
	if HeroName == OUR_HERO_WULFSTAN then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack2",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "RedBorderArea",nil);
		print(HeroName, "has entered in rolf_attack region");
		EnableHeroAI(ENEMY_HERO_ROLF,not nil);
		ChangeHeroStat(ENEMY_HERO_ROLF,STAT_MOVE_POINTS,2500);
		MoveHeroRealTime(ENEMY_HERO_ROLF,49,66);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "rolf_arrive","RolfMoveToWulfstan");
		print("Rolf is moving...");
	end;
end;
		
function IfWulfstanEnterRedBorderRegion( heroName )
	print("wulfstan enters red border region");
	if heroName == OUR_HERO_WULFSTAN then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack2",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "RedBorderArea",nil);
		ChangeHeroStat(ENEMY_HERO_ROLF,STAT_MOVE_POINTS,2500);
		startThread(pursuitWulfstan);
		SetObjectiveState("RepulseRolf",OBJECTIVE_ACTIVE);
		startThread(Objective_RepulseRolf);
	end;
end;


function IfWulfstanEnterRolfRegion2( heroName )
	print("wulfstan enters red border region");
	if heroName == OUR_HERO_WULFSTAN then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "rolf_attack2",nil);
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "RedBorderArea",nil);
		ChangeHeroStat(ENEMY_HERO_ROLF,STAT_MOVE_POINTS,2500);
		startThread(pursuitWulfstan);
		SetObjectiveState("RepulseRolf",OBJECTIVE_ACTIVE);
		startThread(Objective_RepulseRolf);
	end;
end;
		
function RolfMoveToWulfstan()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER, "rolf_arrive",nil);
	EnableHeroAI(ENEMY_HERO_ROLF,not nil);
	MoveHeroRealTime(ENEMY_HERO_ROLF,65,95);
	ChangeHeroStat(ENEMY_HERO_ROLF,STAT_MOVE_POINTS,-2500);
	startThread(pursuitWulfstan);
	SetObjectiveState("RepulseRolf",OBJECTIVE_ACTIVE);
	startThread(Objective_RepulseRolf);
end;
	
function MeetingWithDuncan(HeroName)
	if HeroName == OUR_HERO_WULFSTAN then
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "duncan_meeting",nil);
		ChangeHeroStat(OUR_HERO_DUNCAN,STAT_MOVE_POINTS,2500);
		print("Duncan is moving to the meeting");
		while Distance(OUR_HERO_DUNCAN, OUR_HERO_WULFSTAN) > 3.0 do
			EnableHeroAI(OUR_HERO_DUNCAN,not nil);
			MoveHeroRealTime(OUR_HERO_DUNCAN,GetObjectPosition(OUR_HERO_WULFSTAN));
			sleep(2);
		end;
		print(HeroName, " has entered in region 'duncan meeting'");
		StartDialogScene("/DialogScenes/A1C2/M4/S2/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectOwner(OUR_HERO_DUNCAN,PLAYER_1);
		SetObjectEnabled(OUR_HERO_DUNCAN,not nil);
		SetObjectiveState("find_duncan",OBJECTIVE_COMPLETED);
		sleep(10);
		SetObjectiveState("duncan_must_survive",OBJECTIVE_ACTIVE);
		startThread(DuncanMustSurvive);
	end;
end;


function wantToPay()
	print("yes");
	waitUntilAnswer = 2;
end;

function dontWantToPay()
	print("no");
	QuestionBox("Maps/Scenario/A1C2M4/MessageBox_WantToFight.txt", "wantToFight", "dontWantToFight");
end;

function wantToFight()
	waitUntilAnswer = 3;
end;

function dontWantToFight()
	waitUntilAnswer = 4;
end;


function GnomigRequest( heroName, objectName )
	if firstMeeting == 0 then 
		firstMeeting = 1;
		SetObjectiveState("ReinforceDwarves", OBJECTIVE_ACTIVE);
		startThread(sec_objectiveReinforceDwarves);
	end;
	paymentType = 1 + random(6);
	waitUntilAnswer = 1;
	QuestionBox(POSSIBLE_PRICES[paymentType][1], "wantToPay","dontWantToPay");
	startThread( fightGnom, objectName );
	startThread( wantToPayGnomigs, objectName, paymentType);
end;

function wantToPayGnomigs( objectName, paymentType )
	while waitUntilAnswer == 1 do sleep(3); end;
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
			AddHeroCreatures(OUR_HERO_WULFSTAN, creatureType, crtsQuantity);
			RemoveObject( objectName );
			print("Unit ", objectName, " has joined to your glorious army");
			assembledDwarves = assembledDwarves  + 1;
			SetObjectiveProgress("ReinforceDwarves",assembledDwarves);
		else
			MessageBox("Maps/Scenario/A1C2M4/MsgBox_NotEnoughResources.txt");
		end;
	end;
end;

function fightGnom( objectName )
	while waitUntilAnswer == 1 do sleep(3); end;
	if waitUntilAnswer == 3 then
		creatureType = GetObjectCreatureType( objectName );
		crtsQuantity = GetObjectCreatures( objectName, creatureType )
		print( "Wulfstan want to fight vs ", objectName  );
		Trigger(OBJECT_TOUCH_TRIGGER, objectName , nil)
		intPart = (crtsQuantity - mod(crtsQuantity,4)) / 4;
		modPart = mod(crtsQuantity,4);
		if modPart == 0 then modPart = intPart; end;
		StartCombat( OUR_HERO_WULFSTAN, nil, 4, creatureType,intPart, creatureType,intPart, creatureType,intPart, creatureType,modPart, nil, "CombatResult");
		RemoveObject( objectName );
	else
		print( "Wulfstan leave ", objectName," without combat" );
	end;
end;

function CombatResult( heroName, result)
	if result ~= nil then 
		print("Our glorious hero win!");
	end;
end;
	
function pursuitWulfstan()
	print("pursuit wulfstan by rolf is starting");
	while 1 do
		while GetCurrentPlayer() ~= PLAYER_2 do sleep(3); end;
			if IsHeroAlive(ENEMY_HERO_ROLF) == not nil and IsHeroAlive(OUR_HERO_WULFSTAN) == not nil then
				EnableHeroAI(ENEMY_HERO_ROLF,not nil);
				if CanMoveHero( ENEMY_HERO_ROLF, GetObjectPosition(OUR_HERO_WULFSTAN)) == not nil then
					MoveHero(ENEMY_HERO_ROLF,GetObjectPosition(OUR_HERO_WULFSTAN));
				else
					print("Can't find path to destination point");
				end;
			else
				print("Rolf is dead");
				break;
			end;
			sleep(3);
		while GetCurrentPlayer() == PLAYER_2 do sleep(3); end;
	end;
end;

function debug()
	SetPlayerResource(PLAYER_1,ORE,2000);
	SetPlayerResource(PLAYER_1,WOOD,2000);
	SetPlayerResource(PLAYER_1,MERCURY,500);
	SetPlayerResource(PLAYER_1,CRYSTAL,500);
	SetPlayerResource(PLAYER_1,SULFUR,500);
	SetPlayerResource(PLAYER_1,GEM,500);
	SetPlayerResource(PLAYER_1,GOLD,170000);
end;

-- ========== OBJECTIVES =================== --
function WulfstanMustSurvive(HeroName)
	if HeroName == OUR_HERO_WULFSTAN then 
		SetObjectiveState("wulfstan_must_survive",OBJECTIVE_FAILED);
		sleep(10);
		Loose();
	end;
end;

function DuncanMustSurvive()
	print("Thread DuncanMustSurvive has been started...");
	while IsHeroAlive(OUR_HERO_DUNCAN) == not nil do
		sleep(5);
	end;
	print("Our hero Duncan is dead");
	SetObjectiveState("duncan_must_survive",OBJECTIVE_FAILED);
	sleep(10);
	Loose();
end;

function CaptureTorHallr(OldOwner,NewOwner,HeroName)
	if NewOwner == PLAYER_1 then 
		Trigger(OBJECT_CAPTURE_TRIGGER, ENEMY_TOWN_TOR_HALLR, nil);
		SaveHeroAllSetArtifactsEquipped("Wulfstan", "A1C2M4");
		SetObjectiveState("capture_tor_hallr",OBJECTIVE_COMPLETED);
		sleep(10);
		SetObjectiveState("wulfstan_must_survive",OBJECTIVE_COMPLETED);
		sleep(10);
		SetObjectiveState("duncan_must_survive",OBJECTIVE_COMPLETED);
		sleep(10);
		startThread(PlayerWin);
	end;
end;

function Objective_RepulseRolf()
	while IsHeroAlive(ENEMY_HERO_ROLF) == not nil do sleep(3); end;
		--StartDialogScene("/DialogScenes/A1C2/M4/S2/DialogScene.xdb#xpointer(/DialogScene)");
		StartDialogScene("/DialogScenes/A1C2/M4/S1/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState("RepulseRolf",OBJECTIVE_COMPLETED);
end;

function sec_objectiveReinforceDwarves()
	while assembledDwarves < REINFORCE_DWARVES do sleep(2); end;
	print("All dwarves have assembled!!!");
	SetObjectiveState("ReinforceDwarves", OBJECTIVE_COMPLETED);
	LevelUpHero(OUR_HERO_WULFSTAN);
end;

function PlayerWin()
	while GetObjectiveState("capture_tor_hallr") ~= OBJECTIVE_COMPLETED or
		  GetObjectiveState("find_duncan") ~= OBJECTIVE_COMPLETED or
		  GetObjectiveState("RepulseRolf") ~= OBJECTIVE_COMPLETED do
		sleep(10);
	end;
	--SaveHeroAllSetArtifactsEquipped("Wulfstan", "A1C2M4"); --didn't work
	sleep(5);
	Win(PLAYER_1);
end;
-- MAIN
H55_CamFixTooManySkills(PLAYER_1,"Wulfstan");
-- StartDialogScene("/DialogScenes/A1C2/M4/S1/DialogScene.xdb#xpointer(/DialogScene)");
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