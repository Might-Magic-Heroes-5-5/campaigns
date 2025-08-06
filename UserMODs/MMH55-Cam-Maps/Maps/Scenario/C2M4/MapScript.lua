doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C2M4");
    LoadHeroAllSetArtifacts("Agrael", "C2M3" );
end;

startThread(H55_InitSetArtifacts);

DragonsDefeated = 0;
Priority = 0;

EnableHeroAI("Elleshar",nil);
EnableAIHeroHiring(PLAYER_2,"imarium",nil);
SetObjectEnabled("dragons",nil);

SetRegionBlocked("gate1",1,2);
SetRegionBlocked("gate2",1,2);
SetRegionBlocked("gate3",1,2);
SetRegionBlocked("gate4",1,2);
SetRegionBlocked("gate5",1,2);
SetRegionBlocked("tavern1",1,2);
SetRegionBlocked("tavern2",1,2);
SetRegionBlocked("devils",1,2);
SetRegionBlocked("border1",1,2);
SetRegionBlocked("border2",1,2);
SetRegionBlocked("border3",1,2);
SetRegionBlocked("border4",1,2);
SetRegionBlocked("border5",1,2);
SetRegionBlocked("gate_u1",1,3);
SetRegionBlocked("gate_u2",1,3);
SetRegionBlocked("gate_u3",1,3);
SetRegionBlocked("gate_u4",1,3);
SetRegionBlocked("gate_u5",1,3);
SetRegionBlocked("garrison",1,3);
SetRegionBlocked("garrison",1,2);
SetRegionBlocked("Dragons",1,2);
SetRegionBlocked("Dragons",1,3);


SetPlayerStartResource(PLAYER_1,WOOD,10);
SetPlayerStartResource(PLAYER_1,ORE,10);
SetPlayerStartResource(PLAYER_1,CRYSTAL,2);
SetPlayerStartResource(PLAYER_1,SULFUR,2);
SetPlayerStartResource(PLAYER_1,MERCURY,2);
SetPlayerStartResource(PLAYER_1,GEM,2);
SetPlayerStartResource(PLAYER_1,GOLD,20000);

SetPlayerResource(PLAYER_2,WOOD,10);
SetPlayerResource(PLAYER_2,ORE,10);
SetPlayerResource(PLAYER_2,CRYSTAL,2);
SetPlayerResource(PLAYER_2,SULFUR,2);
SetPlayerResource(PLAYER_2,MERCURY,2);
SetPlayerResource(PLAYER_2,GEM,2);
SetPlayerResource(PLAYER_2,GOLD,10000);

StartDialogScene("/DialogScenes/C2/M4/R1/DialogScene.xdb#xpointer(/DialogScene)");


function ErewelReinforcements()
	print("Thread ErewelReinforcements has been started");
	TimeFactor = GetDate(WEEK);
	while GetObjectOwner("imarium") == PLAYER_2 do
		sleep(10);
		if TimeFactor < GetDate(WEEK) then
			TimeFactor = GetDate(WEEK);
			if GetDifficulty() == DIFFICULTY_EASY then
				print("Difficulty level is NORMAL. Reinforcements did not add");
				AddObjectCreatures("imarium",CREATURE_PIXIE, 7);
				AddObjectCreatures("imarium",CREATURE_GRAND_ELF, 5);
				AddObjectCreatures("imarium",CREATURE_DRUID_ELDER, 4);
				AddObjectCreatures("imarium",CREATURE_WAR_DANCER, 5);
				AddObjectCreatures("imarium",CREATURE_WAR_UNICORN, 1);
			else
				if GetDifficulty() == DIFFICULTY_NORMAL then
					print("Difficulty level is NORMAL. Reinforcements did not add");
					AddObjectCreatures("imarium",CREATURE_PIXIE, 10);
					AddObjectCreatures("imarium",CREATURE_GRAND_ELF, 8);
					AddObjectCreatures("imarium",CREATURE_DRUID_ELDER, 4);
					AddObjectCreatures("imarium",CREATURE_WAR_DANCER, 7);	
					AddObjectCreatures("imarium",CREATURE_WAR_UNICORN, 3);
					AddObjectCreatures("imarium",CREATURE_TREANT_GUARDIAN, 1);
				else
					if GetDifficulty() == DIFFICULTY_HARD then
						print("Difficulty level is HARD. Reinforcements added...");
						AddObjectCreatures("imarium",CREATURE_PIXIE, 15);
						AddObjectCreatures("imarium",CREATURE_GRAND_ELF, 12);
						AddObjectCreatures("imarium",CREATURE_DRUID_ELDER, 6);
						AddObjectCreatures("imarium",CREATURE_WAR_DANCER, 10);	
						AddObjectCreatures("imarium",CREATURE_WAR_UNICORN, 4);
						AddObjectCreatures("imarium",CREATURE_TREANT_GUARDIAN, 2);
					else
						if GetDifficulty() == DIFFICULTY_HEROIC then
							print("Difficulty level is HEROIC. Reinforcements added...");
							AddObjectCreatures("imarium",CREATURE_PIXIE, 20);
							AddObjectCreatures("imarium",CREATURE_GRAND_ELF, 16);
							AddObjectCreatures("imarium",CREATURE_DRUID_ELDER, 8);
							AddObjectCreatures("imarium",CREATURE_WAR_DANCER, 14);	
							AddObjectCreatures("imarium",CREATURE_WAR_UNICORN, 6);
							AddObjectCreatures("imarium",CREATURE_TREANT_GUARDIAN, 3);
						end;
					end;
				end;
			end;
		end;
	end;
end;

function WaitDay()
	local Xday;
	Xday = GetDate(DAY) + 1;
	while Xday ~= GetDate(DAY) do
		sleep();
	end;
end;

function EnemyGate()
	print("Thread Enemy Gate has been started...");
	while 1 do
		sleep(10);
		if GetDate(WEEK) == 3 then
			SetRegionBlocked("border1",0,2);
			SetRegionBlocked("border2",0,2);
			SetRegionBlocked("border3",0,2);
			SetRegionBlocked("border4",0,2);
			print("Now is a third week. Gate to the enemy has been opened.");
			break;
		end;
	end;
end;

function AgraelSurvive()
	print("Thread AgraelSurvive has been started...");
	while 1 do
		sleep(10);
		if (IsHeroAlive("Agrael") == nil) then
			print("Our glorious hero is dead, but he'll live in our hearts forever...");
			SetObjectiveState("prim2",OBJECTIVE_FAILED);
			sleep(15);
			Loose(0);
			break;
		end;
	end;
end;

function ImariumCaptured()
	print("Thread ImariumCaptured has been started...");
	while 1 do
		sleep(10);
		if (GetObjectOwner("imarium") == 1) then
			print("Imarium captured!!!");
			print("You won!!!");
			SaveHeroAllSetArtifactsEquipped("Agrael", "C2M4");
			StartDialogScene("/DialogScenes/C2/M4/R8/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("prim1",OBJECTIVE_COMPLETED);
			sleep(5);
			SetObjectiveState("prim2",OBJECTIVE_COMPLETED);
			sleep(15);
			Win(0);
			break;
		end;
	end;
end;

function PlayerWin()
	print("Thread PlayerWin has been started...");
	while 1 do
		sleep(10);
		local heroes = GetObjectsInRegion("ship",OBJECT_HERO);
		if heroes[0] == "Agrael" then
			print("You won!!!");
			SaveHeroAllSetArtifactsEquipped("Agrael", "C2M4");
			StartDialogScene("/DialogScenes/C2/M4/R8/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("prim1",OBJECTIVE_COMPLETED);
			sleep(5);
			SetObjectiveState("prim2",OBJECTIVE_COMPLETED);
			sleep(15);
			Win(0);
			break;
		end;
	end;
end;

function Day2()
	print("Thread Day2 has been started...");
	while 1 do
		sleep(10);
		if (GetDate(DAY) == 2) then
			print("Objective CaptureNebercias has been given...");
			StartDialogScene("/DialogScenes/C2/M4/R2/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("sec_capture_town",OBJECTIVE_ACTIVE);
			sleep(10);
			startThread(NeberciasCaptured);
			break;
		end;
	end;
end;


function NeberciasCaptured()
	print("Thread NeberciasCaptured has been started...");
	while 1 do
		sleep(10);
		if (GetObjectOwner("nebircias") == 1) then
			print("Nebercias has been captured");
			StartDialogScene("/DialogScenes/C2/M4/R3/DialogScene.xdb#xpointer(/DialogScene)");
			sleep(10);
			SetObjectiveState("sec_capture_town",OBJECTIVE_COMPLETED);
			--ObjectiveExp("Agrael");
			sleep(10);
			SetRegionBlocked("gate1",nil,2);
			SetRegionBlocked("gate3",nil,2);
			SetRegionBlocked("gate_u1",nil,3);
			SetRegionBlocked("gate_u3",nil,3);
			SetRegionBlocked("gate_u4",nil,3);
			SetRegionBlocked("gate_u5",nil,3);
			break;
		end;
	end;
end;

function DragonsObjective()
	print("Thread DragonsObjective has been started...");
	StartDialogScene("/DialogScenes/C2/M4/D1/DialogScene.xdb#xpointer(/DialogScene)");
	sleep(10);
	SetObjectiveState("sec_dragons",OBJECTIVE_ACTIVE);
	local WoodElf = GetHeroCreatures ("Agrael",CREATURE_WOOD_ELF);
	local GrandElf = GetHeroCreatures ("Agrael",CREATURE_GRAND_ELF);
	local SharpShooter = GetHeroCreatures ("Agrael",CREATURE_SHARP_SHOOTER);
	sleep(4);
	if (WoodElf+GrandElf+SharpShooter > 99) then
		print("Count of Elves more than 99");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Dragons",nil);
		if (WoodElf+GrandElf+SharpShooter >= 500) then
			print("Agrael bring to Dragons more than 500 elves");
			GiveArtefact("Agrael",ARTIFACT_DRAGON_FLAME_TONGUE);
			StartDialogScene("/DialogScenes/C2/M4/R7/DialogScene.xdb#xpointer(/DialogScene)");
		else
			print("Agrael bring to Dragons more then 100 wood elves!");
			StartDialogScene("/DialogScenes/C2/M4/R4/DialogScene.xdb#xpointer(/DialogScene)");
		end;
		SetObjectiveState("sec_dragons",OBJECTIVE_COMPLETED);
		ObjectiveExp("Agrael");
		RemoveHeroCreatures("Agrael",CREATURE_WOOD_ELF,10000);
		RemoveHeroCreatures("Agrael",CREATURE_GRAND_ELF,10000);
		RemoveHeroCreatures("Agrael",CREATURE_SHARP_SHOOTER,10000);
		RemoveObject("dragons");
	else
		print("Now Agrael does not have enough elves.");
		startThread(AgraelLeaveDragons);
	end;
end;

function AgraelLeaveDragons()
	print("Thread AgraelLeaveDragons has been started...");
	while 1 do
		sleep(10);
		if (IsObjectInRegion("Agrael","Dragons") == nil) and (DragonsDefeated == 0) then
			print("Agrael has returned to dragons");
			Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Dragons","DragonsObjectiveCompleted");
			break;
		end;
	end;
end;


function DragonsObjectiveCompleted()
	print("Thread DragonsObjectiveCompleted has been started...");
	local WoodElf = GetHeroCreatures ("Agrael",CREATURE_WOOD_ELF);
	local GrandElf = GetHeroCreatures ("Agrael",CREATURE_GRAND_ELF);
	local SharpShooter = GetHeroCreatures ("Agrael",CREATURE_SHARP_SHOOTER);
	print("Number of Elves = ",GrandElf+WoodElf+SharpShooter);
	if (WoodElf+GrandElf+SharpShooter > 99) then
		print("Count of Elves more than 99");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Dragons",nil);
		if (WoodElf+GrandElf+SharpShooter >= 500) then
			print("Agrael bring to Dragons more than 500 elves");
			GiveArtefact("Agrael",ARTIFACT_DRAGON_FLAME_TONGUE);
			StartDialogScene("/DialogScenes/C2/M4/R7/DialogScene.xdb#xpointer(/DialogScene)");
		else
			print("Agrael bring to Dragons more then 100 wood elves!");
			StartDialogScene("/DialogScenes/C2/M4/R4/DialogScene.xdb#xpointer(/DialogScene)");
		end;
		SetObjectiveState("sec_dragons",OBJECTIVE_COMPLETED);
		ObjectiveExp("Agrael");
		RemoveHeroCreatures("Agrael",CREATURE_WOOD_ELF,10000);
		RemoveHeroCreatures("Agrael",CREATURE_GRAND_ELF,10000);
		RemoveHeroCreatures("Agrael",CREATURE_SHARP_SHOOTER,10000);
		RemoveObject("dragons");
	else
		print("Agrael bring to Dragons not enough elves. Need 100");
		StartDialogScene("/DialogScenes/C2/M4/R6/DialogScene.xdb#xpointer(/DialogScene)");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Dragons","DragonsObjectiveCompleted");
	end;
end;


--this function deletes some preserve creatures from Agrael's army every day:
function H55_TriggerDaily()
	print("Thread desentir has been started...");
	CreatureList = {CREATURE_PIXIE,
					CREATURE_SPRITE,
					CREATURE_DRYAD,
					CREATURE_BLADE_JUGGLER,
					CREATURE_WAR_DANCER,
					CREATURE_BLADE_SINGER,
					CREATURE_WOOD_ELF,
					CREATURE_GRAND_ELF,
					CREATURE_SHARP_SHOOTER,
					CREATURE_DRUID,
					CREATURE_DRUID_ELDER,
					CREATURE_HIGH_DRUID,
					CREATURE_UNICORN,
					CREATURE_WAR_UNICORN,
					CREATURE_WHITE_UNICORN,
					CREATURE_TREANT,
					CREATURE_TREANT_GUARDIAN,
					CREATURE_ANGER_TREANT,
					CREATURE_GREEN_DRAGON,
					CREATURE_GOLD_DRAGON,
					CREATURE_RAINBOW_DRAGON,
					};
	CreatureList.n = 21;
	for i=1,21 do
		if GetHeroCreatures("Agrael",CreatureList[i]) > 5 then
			if i <= 6 then
				quantity = 1+random(6);
			end;
			if i > 6 and i <=15 then
				quantity = 1+random(2);
			end;
			if i > 15 then
				quantity = 1;
			end;
			RemoveHeroCreatures("Agrael",CreatureList[i],quantity);
			--print("Agrael lost ",quantity," creatures. Creature ID = ",CreatureList[i]);
		else
			--print("Hero has less then 5 creatures this type. Creature ID = ",CreatureList[i]);
		end;
	end;
	sleep(10);
	--Trigger(NEW_DAY_TRIGGER,"desentir");
end;


function DialogBeforeCombatVSdragons(heroname)
	HeroName = heroname;
	print("Dialog 1 check has been started...");
	QuestionBox("/Maps/Scenario/C2M4/BeforeCombatVSDragons.txt", "combatVSdragons");
end;

function combatVSdragons(heroname)
	print("Thread combatVSdragons has been started...");
	StartDialogScene("/DialogScenes/C2/M4/R5/DialogScene.xdb#xpointer(/DialogScene)");
	StartCombat(HeroName, nil,3,CREATURE_SHADOW_DRAGON,11,CREATURE_SHADOW_DRAGON,11,CREATURE_SHADOW_DRAGON,11,nil,"FinishCombat");
end;

function FinishCombat(heroname,result)
	print("Thread FinishCombat has been started");
	if result == not nil then
		print("Our glorious ",heroname," has killed the dragons!!!");
		RemoveObject("dragons");
		SetRegionBlocked("Dragons",nil,2);
		SetRegionBlocked("Dragons",nil,3);
		DragonsDefeated = 1;
		Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Dragons",nil);
		SetObjectiveState("sec_dragons",OBJECTIVE_FAILED);
	else
		print(heroname, " has been killed by dragons! :(");
	end;
end;


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

function DisableHeroAI()
	InfernoHeroes = GetPlayerHeroes(PLAYER_3);
	PreserveHeroes = GetPlayerHeroes(PLAYER_2);
	for i=0,table.length(InfernoHeroes)-1 do
		EnableHeroAI(InfernoHeroes[i],nil);
		print("AI has been disabled for inferno hero ",InfernoHeroes[i]);
	end;
	for i=0,table.length(PreserveHeroes)-1 do
		EnableHeroAI(PreserveHeroes[i],nil);
		print("AI has been disabled for preserve hero ",PreserveHeroes[i]);
	end;
end;

function AIPressingTownHolin(heroname)
	print("Thread AIPressingTownHolin has been started...")
	repeat
		sleep(20);
	until GetObjectOwner("holin") == PLAYER_1;
	print("Town Holin has been captured by Player");
	local x,y = GetObjectPosition("holin");
	while 1 do
		sleep(20);
		if IsHeroAlive(heroname) == not nil then
			HeroMovePointsToHolin = CalcHeroMoveCost(heroname,x,y);
			AgraelMovePointsToHolin = CalcHeroMoveCost("Agrael",x,y);
			x1,y1,Floor = GetObjectPosition("Agrael");
			if IsObjectVisible(PLAYER_2, "Agrael") == nil or Floor ~= 0 then
				Priority = 2;
				SetAIHeroAttractor("holin", heroname, Priority);
			else
				if HeroMovePointsToHolin <= AgraelMovePointsToHolin then
					Priority = 2;
					SetAIHeroAttractor("holin", heroname, Priority);
				else
					Priority = -1;
					SetAIHeroAttractor("holin", heroname, Priority);
				end;
			end;
		else
			print("Hero ",heroname," is dead.");
			break;
		end;
	end;
end;

H55_CamFixTooManySkills(PLAYER_1,"Agrael");
startThread(Day2);
startThread(AgraelSurvive);
startThread(ImariumCaptured);
startThread(EnemyGate);
Trigger(REGION_ENTER_AND_STOP_TRIGGER,"Dragons","DragonsObjective");
H55_NewDayTrigger = 1;
--Trigger(NEW_DAY_TRIGGER,"desentir");
Trigger(OBJECT_TOUCH_TRIGGER, "dragons","DialogBeforeCombatVSdragons",nil);
startThread(AIPressingTownHolin,"Diraya");
startThread(ErewelReinforcements);