doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C3M5");
    LoadHeroAllSetArtifacts("Berein", "C3M4" );
	GiveArtefact("Berein",ARTIFACT_RING_OF_DEATH);
end;

startThread(H55_InitSetArtifacts);

H55_PlayerStatus = {0,1,1,2,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_STAFF_OF_VEXINGS,ARTIFACT_RING_OF_DEATH,ARTIFACT_CLOAK_OF_MOURNING,ARTIFACT_NECROMANCER_PENDANT};

START_TIME_PRESSING_MONTH = 2;
factor = 3;
EnableHeroAI('Godric', nil );
SetObjectEnabled("prison",nil);
--Initialisation of Game variables:
for i = 1,14 do
	SetGameVar("C3M5_creatures"..i,0);
end;

CreaturesNameForMessage = {"Peasants","Militiaman",
						   "Footman","Swordsman",
							"Archers","Marksman",
							"Griffins","Royal griffins",
							"Clerics","Priests",
							"Paladins","Paladins",
							"Angels","Archangels"};	


----------------------------------
Save("GodricsChoice");
StartDialogScene("/DialogScenes/C3/M5/D1/DialogScene.xdb#xpointer(/DialogScene)");
MoveHeroRealTime("Godric", 47,30,GROUND);

function WaitDay()
	local Xday;
	Xday = GetDate(DAY) + 1;
	while Xday ~= GetDate(DAY) do
		sleep();
	end;
end;

------ DETERMINES DIFFICULTY LEVEL TO SET INITIAL CONDITIONS FOR COMBAT SCRIPT FOR BATTLE VS GODRIC------
function DifficultyLevel()
	if GetDifficulty() == DIFFICULTY_EASY then
		SetGameVar("C3M5_Difficulty","normal");
		AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,30);
		AddHeroCreatures("Berein",CREATURE_MANES,8);
		SetPlayerStartResource(1,WOOD,20);
		SetPlayerStartResource(1,ORE,20);
		SetPlayerStartResource(1,SULFUR,5);
		SetPlayerStartResource(1,MERCURY,5);
		SetPlayerStartResource(1,CRYSTAL,5);
		SetPlayerStartResource(1,GEM,5);
		SetPlayerStartResource(1,GOLD,30000);
		print("Difficulty level is easy");
	else
	if GetDifficulty() == DIFFICULTY_NORMAL then
			SetPlayerStartResource(1,WOOD,16);
			SetPlayerStartResource(1,ORE,15);
			SetPlayerStartResource(1,SULFUR,3);
			SetPlayerStartResource(1,MERCURY,3);
			SetPlayerStartResource(1,CRYSTAL,3);
			SetPlayerStartResource(1,GEM,3);
			SetPlayerStartResource(1,GOLD,25000);
			SetGameVar("C3M5_Difficulty","normal");
			AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,15);
			AddHeroCreatures("Berein",CREATURE_MANES,5);
			print("Difficulty level is normal");
			else
			if GetDifficulty() == DIFFICULTY_HARD then
				SetPlayerStartResource(1,WOOD,12);
				SetPlayerStartResource(1,ORE,10);
				SetPlayerStartResource(1,SULFUR,1);
				SetPlayerStartResource(1,MERCURY,1);
				SetPlayerStartResource(1,CRYSTAL,1);
				SetPlayerStartResource(1,GEM,1);
				SetPlayerStartResource(1,GOLD,20000);
				SetGameVar("C3M5_Difficulty","hard");
				print("Difficulty level is hard");
				else
				if GetDifficulty() == DIFFICULTY_HEROIC then
					SetPlayerStartResource(1,WOOD,10);
					SetPlayerStartResource(1,ORE,8);
					SetPlayerStartResource(1,SULFUR,1);
					SetPlayerStartResource(1,MERCURY,1);
					SetPlayerStartResource(1,CRYSTAL,1);
					SetPlayerStartResource(1,GEM,1);
					SetPlayerStartResource(1,GOLD,15000);
					SetGameVar("C3M5_Difficulty","heroic");
					print("Difficulty level is heroic");
					START_TIME_PRESSING_MONTH = 4;
				end;
			end;
		end;
	end;
end;

------- HEROES MUST SURVIVE ----------------------------------------
function IsabellAndBerein_Survive()
	print("Thread IsabellAndBerein_Survive has been started...");
	while 1 do
		sleep(10);
		if (IsHeroAlive("Isabell") == nil or IsHeroAlive("Berein") == nil) then
			print("Our glorious hero has been fallen...");
			SetObjectiveState("prim5",OBJECTIVE_FAILED);
			sleep(40);
			Loose(0);
			break;
		end;
	end;
end;

function PrimaryObjective2()
	print("Thread PrimaryObjective2 has been started...");
	SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
	hidenobjective2=nil;
	sleep (10);
end;


function StartTrigger_AngelsBefore(heroname)
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"BeforeAngels", nil);
	if heroname == "Berein" then
		print("Markal has entered in area before battle versus angels");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Angels","BeforeBattleVS_Angels");
	else
		print(heroname, " has entered in area. It is not Markal.");
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"BeforeAngels","StartTrigger_AngelsBefore");
	end;
end;

function BeforeBattleVS_Angels (heroname)
	print("Thread BeforeBattleVS_Angels has been started...");
	if heroname == 'Berein' then
		print("Berein has come to battle versus angels");
		StartDialogScene("/DialogScenes/C3/M5/R2/DialogScene.xdb#xpointer(/DialogScene)");
		StartCombat("Berein",nil,4,CREATURE_ARCHANGEL,4,CREATURE_ANGEL,5,CREATURE_ANGEL,5,CREATURE_ARCHANGEL,4,nil,"AfterCombat");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Angels",nil);
	else
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Angels","BeforeBattleVS_Angels");
	end;
end

function AfterCombat(name,res)
	if res ~= nil then
		print("Berein won!");
	StartDialogScene("/DialogScenes/C3/M5/R3/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState('prim3',OBJECTIVE_COMPLETED);
	--AddHeroCreatures('Berein', CREATURE_GHOST, 1);
	GiveArtefact ('Berein', ARTIFACT_ANGEL_WINGS,1);
	sleep(10);
	SetObjectiveState('prim4',OBJECTIVE_ACTIVE);
	startThread(PlayerWin);
	RemoveArtefact("Berein",72); --Artifact Freida
	else
		print("Berein has been defeated");
	end;
end

-----DEPLOY RESERVED ACADEMY HERO ------------------
function DeployAcademyHeroes()
	print("Thread DeployAcademyHeroes has been started...");
	repeat
		sleep(10);
	until GetDate(WEEK) == 2;
	DeployReserveHero("Razzak",24,90,0);
	print("Hero Razzak has been deployed");
	sleep(2);
	SetAIPlayerAttractor("Newpost",PLAYER_3,2);
	startThread(RazzakIsDead);
	repeat
		sleep(15);
	until GetObjectiveState("prim2") == OBJECTIVE_COMPLETED;
	DeployReserveHero("Maahir",88,20,0);
	print("Hero Maahir has been deployed");
	sleep(2);
	SetAIPlayerAttractor("Necorrum",PLAYER_3,2); -- Necorrum is Lorekeep
end;

function RazzakIsDead()
	print("Thread RazzakIsDead has been started...");
	repeat
		sleep(10);
	until IsHeroAlive("Razzak") == nil;
	print("Razzak is dead");	
	factor = 2;
	CurrentWeek = GetDate(WEEK);
	repeat
		sleep(10);
	until GetDate(WEEK) == CurrentWeek + 2;
	factor = 1;
	print("factor = 1");
end;

function PlayerWin()
	print("Thread PlayerWin has been started...");
	while 1 do
		sleep(20);
		if GetObjectOwner("Hikm") == PLAYER_1 and IsHeroAlive("Godric") == nil then
			StartDialogScene("/DialogScenes/C3/M5/D3/DialogScene.xdb#xpointer(/DialogScene)");
			print("You won!");
			sleep(10);
			SetObjectiveState("prim1",OBJECTIVE_COMPLETED);
			sleep(1);
			SetObjectiveState("prim5",OBJECTIVE_COMPLETED);
			sleep(10);
			SetObjectiveState("TimePressing",OBJECTIVE_COMPLETED);
			Win(0);
			break;
		end;
	end;
end;


function IsabellLostArmy()
	while 1 do
		sleep(5);
		if GetDate(DAY) == 2 and GetDate(WEEK) == 1 then
			print("Isabell has lost angels");
			StartDialogScene("/DialogScenes/C3/M5/R4/DialogScene.xdb#xpointer(/DialogScene)");
			if GetHeroCreatures("Isabell",CREATURE_ANGEL) > 0 then
				SetGameVar("C3M5_creatures13", GetHeroCreatures("Isabell",CREATURE_ANGEL));
				print("Isabell has angels");
				sleep(2);
				RemoveHeroCreatures("Isabell",CREATURE_ANGEL,10000);
				MessageBox("/Maps/Scenario/C3M5/AngelsLeftIsabell.txt");
			else
				print("Isasbell does not have any angels");
			end;
			H55_NewDayTrigger = 1;
			--Trigger(NEW_DAY_TRIGGER,"desentir");
			break;
		end;
	end;
end;


--this function removes some heaven creatures from Isabell's army every day:
function H55_TriggerDaily()
local	CreatureList = {CREATURE_PEASANT,
						CREATURE_MILITIAMAN,
						CREATURE_FOOTMAN,
						CREATURE_SWORDSMAN,
						CREATURE_ARCHER,
						CREATURE_MARKSMAN,
						CREATURE_GRIFFIN,
						CREATURE_ROYAL_GRIFFIN,
						CREATURE_PRIEST,
						CREATURE_CLERIC,
						CREATURE_CAVALIER,
						CREATURE_PALADIN,
						CREATURE_ANGEL,
						CREATURE_ARCHANGEL};
						CreatureList.n = 14;
local   CreaturesNameForMessage = {  "Peasants","Militiaman",
								   "Footman","Swordsman",
								   "Archers","Marksman",
								   "Griffins","Royal griffins",
								   "Clerics","Priests",
								   "Paladins","Paladins",
								   "Angels","Archangels"};							
	if IsHeroAlive("Godric") ~= nil or IsHeroAlive("Isabell") ~= nil then
		allCreaturesQuantity = 0;							
		for i=1,14 do
			if GetHeroCreatures("Isabell",CreatureList[i]) > 0 then
				allCreaturesQuantity = allCreaturesQuantity + 1;
			end;
		end;
		if allCreaturesQuantity > 1 then
			print("Thread desentir has been started...");
			rnd = 1 + random(13);
			quantity = GetHeroCreatures("Isabell",CreatureList[rnd]);
			if  mod(GetDate(DAY),factor) == 0 then
				if quantity > 1 then
					RemoveHeroCreatures("Isabell",CreatureList[rnd],quantity);
					VarName = "C3M5_creatures"..rnd;
					SetGameVar(VarName, GetGameVar(VarName) + quantity);
					print("Creature is ",CreaturesNameForMessage[rnd], ". rnd = ",rnd);
					print("Now Godric has ",GetGameVar(VarName)," ", CreaturesNameForMessage[rnd]);
					MessageBox("Maps/Scenario/C3M5/"..CreaturesNameForMessage[rnd - 1 + (mod(rnd,2))].."LeftIsabell.txt");
					print("Isabell lost ",quantity," ", CreaturesNameForMessage[rnd]);
				else
					print("Quantity of "..CreaturesNameForMessage[rnd].." = ",GetHeroCreatures("Isabell",CreatureList[rnd]),". Less than 2.");
				end;
			else
				print("Not for deserting day. mod(GetDate(DAY),",factor,") = ",mod(GetDate(DAY),factor));
			end;
		else
			print("Isabell has only 1 brave creature.");	
		end;
	else
		print("NEW_DAY_TRIGGER has been terminated...");
		H55_NewDayTrigger = 0;
		--Trigger(NEW_DAY_TRIGGER,"desentir",nil);
	end;
end;



function CaptureCavern()
	print("Thread CaptureCavern has been started...");
	while 1 do
		sleep(10);
	if mod(GetDate(DAY),5) == 0 then
		Caverns = {"ore","wood","sulfur","cristall","gems","mercury"};
		Caverns.n = 6;
		CreatureList = {CREATURE_PEASANT,200,
						CREATURE_MILITIAMAN,150,
						CREATURE_FOOTMAN,60,
						CREATURE_SWORDSMAN,45,
						CREATURE_ARCHER,70,
						CREATURE_MARKSMAN,55,
						CREATURE_GRIFFIN,32,
						CREATURE_ROYAL_GRIFFIN,26,
						CREATURE_PRIEST,12,
						CREATURE_CLERIC,10,
						CREATURE_CAVALIER,8,
						CREATURE_PALADIN,7,
						CREATURE_ANGEL,5,
						CREATURE_ARCHANGEL,4};
		CreatureList.n = 28;
		IsCreatureExist = 0;
		CavName = Caverns[1+random(6)];
		print("Cavern name is ",CavName," and its owner is ",GetObjectOwner(CavName));
		for i=1,CREATURES_COUNT-1 do
			if GetObjectCreatures(CavName,i) ~= 0 then
				print("Building is guarded!");
				IsCreatureExist = 1;
				break;
			end;
		end;
		if GetObjectOwner(CavName) ~= PLAYER_2 and IsCreatureExist == 0 then
			print("Cavern has been captured by Godric's forces");
			n = 1 + random(14);
			AddObjectCreatures(CavName,CreatureList[2*n-1],CreatureList[2*n]);
			SetObjectOwner(CavName,PLAYER_2);
			MessageBox("/Maps/Scenario/C3M5/CaptureCavernMessage.txt");
			else
			print("Object is already Godric's or guarded.");
		end;
		WaitDay();
	end;
	end;
end;

function TeleportUse()
	print("Player try to use teleport");
	MessageBox("/Maps/Scenario/C3M5/TeleportUnusable_MsgBox.txt");
end;

function GiveMeMines()
	SetObjectOwner("ore",1);
	SetObjectOwner("wood",1);
	SetObjectOwner("sulfur",1);
	SetObjectOwner("mercury",1);
	SetObjectOwner("cristall",1);
	SetObjectOwner("gems",1);
end;


function PlayerTouchPrison(heroname)
	print("Player hero ",heroname," has entered prison");
	if heroname == "Berein" then
		Trigger(OBJECT_TOUCH_TRIGGER, "prison",nil);
		StartDialogScene("/DialogScenes/C3/M5/R1/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectiveState("prim2",OBJECTIVE_COMPLETED);
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"BeforeAngels","StartTrigger_AngelsBefore");
		SetObjectiveState("prim3",OBJECTIVE_ACTIVE);
		GiveArtefact(heroname,72,1); -- Artifact Freida
	else
		MessageBox("/Maps/Scenario/C3M5/MsgBox_EnterPrison.txt");	
		Trigger(OBJECT_TOUCH_TRIGGER, "prison","PlayerTouchPrison");
		print("Hero is not Berein. Trigger TOUCH_PRISON started again.");
	end;
end;

function StartTimePressing()
	print("Thread StartTimePressing has been started...");
	while GetDate(MONTH) ~= START_TIME_PRESSING_MONTH do
		sleep(20);
	end;
	SetObjectiveState("TimePressing",OBJECTIVE_ACTIVE);
	print("Time pressing started!");
	MessageBox("/Maps/Scenario/C3M5/4WeekBeforeLoose.txt");
	for i=3,2,-1 do
		SkipTimeInterval(WEEK);
		MessageBox("Maps/Scenario/C3M5/"..i.."WeeksBeforeLoose.txt");
	end;
		SkipTimeInterval(WEEK);
	MessageBox("/Maps/Scenario/C3M5/7DaysBeforeLoose.txt");
	for i=6,1,-1 do
		SkipTimeInterval(DAY_OF_WEEK);
		MessageBox("Maps/Scenario/C3M5/"..i.."DaysBeforeLoose.txt");
	end;
	SkipTimeInterval(DAY_OF_WEEK);
	Loose(PLAYER_1);
end;

function SkipTimeInterval(Interval)
	repeat
		CurrentDate = GetDate(Interval);
		sleep(10);
	until CurrentDate ~= GetDate(Interval);
end;

----- FUNCTIONS TO SET HERO BONUS EXPIRIENCE FOR COMPLETED OBJECTIVES-------------
function ObjectiveExp(HeroName)
	local ToLevel = GetExpToLevel(GetHeroLevel(HeroName)+1);
	local delta = (ToLevel - GetHeroStat(HeroName, STAT_EXPERIENCE)) / 2;
	ChangeHeroStat(HeroName, STAT_EXPERIENCE,delta);
	print("Now ",HeroName, " has ", GetHeroStat(HeroName, STAT_EXPERIENCE)," exp");
end;

function GetExpToLevel( j )
	local a = 1;
	if j >= 30 then a = 30 else a = j end;
	local sum;      --LEVEL 1 2    3    4    5    6    7    8     9     10    11    12
	ExpArrayLess12 = {0,1000,2000,3200,4600,6200,8000,10000,12200,14700,17500,20600};
	ExpArrayLess12.n = 12;
					--LEVEL 13    14    15    16    17    18    19    20    21    22     23     24
	ExpArrayMore12 = {24320,28784,34141,40569,48283,57539,68647,81977,97972,117166,140200,167839};
	ExpArrayMore12.n = 12;
					--LEVEL 25     26     27     28     29     30     31      32      33      34
	ExpArrayMore25 = {201007,244126,304491,395040,539917,786208,1229533,2071000,3756484,7294215};
	ExpArrayMore25.n = 10;
	if a <= 12 then
		sum = ExpArrayLess12[a];
	else
		if a < 25 then
			sum = ExpArrayMore12[a-12];
		else
			if a < 35 then
				sum = ExpArrayMore25[a-24];
			else
				print("Das ist fantastisch!!!");
				sum = 0;
			end;
		end;
	end;
	print("Hero need ", sum, " experience to gain level ",a);
	return sum;
end;

-----DEBUG FUNCTION---------------------------------
function PrintGodricsReinforcements()
	for i = 1, 14 do
		print("Godric has ",GetGameVar("C3M5_creatures"..i)," ",CreaturesNameForMessage[i]);
	end;
end;

H55_CamFixTooManySkills(PLAYER_1,"Berein");
H55_CamFixTooManySkills(PLAYER_1,"Isabell");
H55_CamFixTooManySkills(PLAYER_2,"Godric");
startThread(IsabellAndBerein_Survive);
startThread(PrimaryObjective2);
startThread(IsabellLostArmy);
startThread(CaptureCavern);
startThread(DeployAcademyHeroes);
startThread(DifficultyLevel);
startThread(StartTimePressing);
Trigger(OBJECT_TOUCH_TRIGGER, "teleport","TeleportUse");
Trigger(OBJECT_TOUCH_TRIGGER, "prison","PlayerTouchPrison");