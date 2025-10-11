doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C3M2");
    LoadHeroAllSetArtifacts("Berein", "C3M1" );
end;

startThread(H55_InitSetArtifacts);

H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_STAFF_OF_VEXINGS,ARTIFACT_RING_OF_DEATH,ARTIFACT_CLOAK_OF_MOURNING,ARTIFACT_NECROMANCER_PENDANT};

StartDialogScene("/DialogScenes/C3/M2/D1/DialogScene.xdb#xpointer(/DialogScene)");

EnableHeroAI("Isher",nil);
EnableHeroAI("Astral",nil);
EnableHeroAI("Faiz",nil);
EnableHeroAI("Nur",nil);
EnableHeroAI("Sufi",nil);

SetRegionBlocked("block1",1,PLAYER_2);
SetRegionBlocked("block2",1,PLAYER_2);
SetRegionBlocked("block3",1,PLAYER_2);
SetRegionBlocked("antislonik",1,PLAYER_2);
SetRegionBlocked("approach",1,PLAYER_2);
SetRegionBlocked("titans",1,PLAYER_2);

EnableAIHeroHiring(PLAYER_2,"Hikm",nil);

SetObjectEnabled("Titans",nil);

IsConditionTrue = {0,0,0};
Patrol_NurCoords = {{55,45},{39,47},{22,46},{11,59},{5,81}};
Patrol_FaizCoords = {{60,60},{79,69},{89,54},{117,59}};
Patrol_SufiCoords = {{66,43},{94,35},{116,30},{129,40}};
PatrolTerminated = 0;
Flag = 0;
DETECT_RADIUS = 18;
--SetRegionBlocked("block4",1,2);


function DifficultyDependency()
	if GetDifficulty() == DIFFICULTY_EASY then
		-- RemoveHeroCreatures("Isher",CREATURE_IRON_GOLEM,10);
		-- RemoveHeroCreatures("Isher",CREATURE_STONE_GARGOYLE,10);
		-- RemoveHeroCreatures("Isher",CREATURE_GREMLIN,50);
		-- RemoveHeroCreatures("Isher",CREATURE_MAGI,6);
		-- RemoveHeroCreatures("Isher",CREATURE_RAKSHASA,2);
		-- RemoveHeroCreatures("Isher",CREATURE_TITAN,1);
		-- RemoveHeroCreatures("Nur",CREATURE_MASTER_GENIE,5);
		-- RemoveHeroCreatures("Nur",CREATURE_OBSIDIAN_GARGOYLE,26);
		-- RemoveHeroCreatures("Nur",CREATURE_GREMLIN,40);
		-- RemoveHeroCreatures("Nur",CREATURE_MAGI,7);
		-- RemoveHeroCreatures("Faiz",CREATURE_ARCH_MAGI,9);
		-- RemoveHeroCreatures("Faiz",CREATURE_RAKSHASA,4);
		-- RemoveHeroCreatures("Faiz",CREATURE_TITAN,1);
		-- RemoveHeroCreatures("Faiz",CREATURE_IRON_GOLEM,40);
		-- RemoveHeroCreatures("Faiz",CREATURE_STONE_GARGOYLE,21);
		-- RemoveHeroCreatures("Sufi",CREATURE_GREMLIN,50);
		-- RemoveHeroCreatures("Sufi",CREATURE_RAKSHASA,5);
		-- RemoveHeroCreatures("Sufi",CREATURE_GENIE,8);
		-- RemoveHeroCreatures("Sufi",CREATURE_STEEL_GOLEM,25);
		CreateMonster("liches2",CREATURE_LICH,16,80,12,0); --peasant hut
		CreateMonster("skeleton_archers",CREATURE_SKELETON_ARCHER,120,94,21,0); --magic well
		CreateMonster("liches",CREATURE_LICH,20,99,111,0); --Lorekeep
		CreateMonster("vampires",CREATURE_VAMPIRE,22,18,16,0); --Arena
		CreateMonster("ewe_liches",CREATURE_LICH,25,50,27,0); --
		CreateMonster("wights",CREATURE_GHOST,52,81,116,0); --Ruined Tower
		CreateMonster("shadow_dragons",CREATURE_SHADOW_DRAGON,10,108,99,0); --Near lorekeep
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_MAGIC_GUILD,2);
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_DWELLING_7,0);
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_DWELLING_6,0);
		SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_FORT,1);
		--AddHeroCreatures("Berein",CREATURE_SKELETON,68);
		AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,60);
		AddHeroCreatures("Berein",CREATURE_LICH,8);
		AddHeroCreatures("Godric",CREATURE_GRIFFIN,10);
		--AddHeroCreatures("Godric",CREATURE_MARKSMAN,12);
		--AddHeroCreatures("Godric",CREATURE_FOOTMAN,22);
		SetPlayerStartResource(1,WOOD,30);
		SetPlayerStartResource(1,ORE,30);
		SetPlayerStartResource(1,SULFUR,10);
		SetPlayerStartResource(1,CRYSTAL,10);
		SetPlayerStartResource(1,MERCURY,10);
		SetPlayerStartResource(1,GEM,10);
		SetPlayerStartResource(1,GOLD,12000);
		DifficultyFactor = 3;
		print("Difficulty level is easy.");
	else
		if GetDifficulty() == DIFFICULTY_NORMAL then
			CreateMonster("skeleton_archers",CREATURE_SKELETON_ARCHER,120,94,21,0); --magic well
			CreateMonster("liches",CREATURE_LICH,20,99,111,0); --Lorekeep
			CreateMonster("vampires",CREATURE_VAMPIRE,22,18,16,0); --Arena
			CreateMonster("ewe_liches",CREATURE_LICH,25,50,27,0); --
			CreateMonster("wights",CREATURE_GHOST,52,81,116,0); --Ruined Tower
			CreateMonster("shadow_dragons",CREATURE_SHADOW_DRAGON,10,108,99,0); --Near lorekeep
			SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_MAGIC_GUILD,3);
			SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_DWELLING_7,0);
			SetTownBuildingLimitLevel("Hikm",TOWN_BUILDING_FORT,2);
			AddHeroCreatures("Berein",CREATURE_SKELETON_ARCHER,40);
			AddHeroCreatures("Godric",CREATURE_GRIFFIN,6);
			SetPlayerStartResource(1,WOOD,20);
			SetPlayerStartResource(1,ORE,20);
			SetPlayerStartResource(1,SULFUR,5);
			SetPlayerStartResource(1,CRYSTAL,5);
			SetPlayerStartResource(1,MERCURY,5);
			SetPlayerStartResource(1,GEM,4);
			SetPlayerStartResource(1,GOLD,6000);
			DifficultyFactor = 3;
			print("Difficulty level is normal.");
		else
			if GetDifficulty() == DIFFICULTY_HARD then
					CreateMonster("skeleton_archers",CREATURE_SKELETON_ARCHER,120,94,21,0); --magic well
					CreateMonster("vampires",CREATURE_VAMPIRE,22,18,16,0); --Arena
					CreateMonster("wights",CREATURE_GHOST,52,81,116,0); --Ruined Tower
					TeachHeroSpell("Nur",SPELL_PHANTOM);
					SetPlayerStartResource(1,WOOD,12);
					SetPlayerStartResource(1,ORE,12);
					SetPlayerStartResource(1,SULFUR,3);
					SetPlayerStartResource(1,CRYSTAL,3);
					SetPlayerStartResource(1,MERCURY,3);
					SetPlayerStartResource(1,GEM,2);
					SetPlayerStartResource(1,GOLD,2500);
					DifficultyFactor = 2;
					print("Difficulty level is hard.");
				else
				if GetDifficulty() == DIFFICULTY_HEROIC then
					TeachHeroSpell("Nur",SPELL_RESURRECT);
					TeachHeroSpell("Nur",SPELL_PHANTOM );
					SetPlayerStartResource(1,WOOD,10);
					SetPlayerStartResource(1,ORE,10);
					SetPlayerStartResource(1,SULFUR,3);
					SetPlayerStartResource(1,CRYSTAL,3);
					SetPlayerStartResource(1,MERCURY,3);
					SetPlayerStartResource(1,GEM,2);
					SetPlayerStartResource(1,GOLD,2000);
					DifficultyFactor = 2;
					print("Difficulty level is heroic.");
				end;
			end;
		end;
	end;
end;



function len( x, y )
local l = sqrt( x * x + y * y );
	return l;
end;

function GetPlayerHeroNearPatrol(PatrolName, Radius)
	if IsHeroAlive(PatrolName) == not nil then
		local Patrol_x,Patrol_y = GetObjectPosition(PatrolName);
		local PlayerHeroes = GetPlayerHeroes(PLAYER_1);
		for i = 0,table.length(PlayerHeroes) - 1 do
			Hero_x,Hero_y = GetObjectPosition(PlayerHeroes[i]);
			if len((Patrol_x - Hero_x),(Patrol_y - Hero_y)) <= Radius then
				return PlayerHeroes[i];
			end;
		end;
	else
		print("Hero ",PatrolName," is dead. Function GetPlayerHeroNearPatrol return nil.");
		return nil;
	end;
end;

function Intercept(PatrolName,n)
	print("Thread Intercept for hero ",PatrolName," has been started...");
	while PatrolTerminated == 0 do
		sleep(1);
		if IsHeroAlive(PatrolName) == not nil then
			if GetPlayerHeroNearPatrol(PatrolName,DETECT_RADIUS) ~= nil then
				PlayerHeroName = GetPlayerHeroNearPatrol(PatrolName,DETECT_RADIUS);
				if IsObjectVisible(PLAYER_2, PlayerHeroName) == not nil then
					IsConditionTrue[n] = 1;
					MoveHeroRealTime(PatrolName,GetObjectPosition(PlayerHeroName));
				end;
			else
				IsConditionTrue[n] = 0;
			end;
		else
			print("Hero ",PatrolName," is dead. Thread Intercept for this hero has been terminated...");
			return
		end;
	end;
	print("Player reach Lorekeep. Thread Intercept for ",PatrolName," terminated.");
end;

function printvar(delay)
	while 1 do
		sleep(delay);
		local hz = GetPlayerHeroNearPatrol("Sufi",DETECT_RADIUS);
		print("Hero near patrol is ", hz);
		print("Continue intercept = ", IsConditionTrue[3]);
	end;
end;

function Patrol2(heroname,CoordsArray,n)
	print("Thread Patrol for hero", heroname," has been started...");
	local ArrayLength = table.length(CoordsArray);
	print("ArrayLength.n = ", ArrayLength);
	while IsHeroAlive(heroname) == not nil do	
		for i=1,ArrayLength do	
			if PatrolTerminated == 0 then
				if IsHeroAlive(heroname) == not nil then
					MoveHeroRealTime(heroname, CoordsArray[i][1],CoordsArray[i][2]);
					local CurrentDay = GetDate(DAY);
					while CurrentDay == GetDate(DAY) or IsConditionTrue[n] == 1 do
						sleep(10);
					end;
				else
					print("Unfortunately ",heroname, " is dead :(. Thread Patrol for hero ",heroname," has been terminated");
					return
				end;
			else
				print("Thread Patrol for hero ",heroname," has been terminated...");
				return
			end;
		end;
		for i=ArrayLength,1,-1 do
			print("Back Patrol...");
			if PatrolTerminated == 0 then
				if IsHeroAlive(heroname) == not nil then
					MoveHeroRealTime(heroname, CoordsArray[i][1],CoordsArray[i][2]);
					local CurrentDay = GetDate(DAY);
					while CurrentDay == GetDate(DAY) or IsConditionTrue[n] == 1 do
						sleep(10);
					end;
				else
					print("Unfortunately ",heroname, " is dead :(. Thread Patrol for hero ",heroname," has been terminated");
					return
				end;
			else
				print("Necropolice captured. Thread Patrol for hero ",heroname," has been terminated...");
				return
			end;
		end;
	end;
end;

function intercept(heroname,n)
	print("Thread intercept has been started...");
	while 1 do
		sleep(1);
		local PlayerHeroes = GetPlayerHeroes(PLAYER_1);
		PlayerHeroes.n = table.length(PlayerHeroes);
		for j = 0, PlayerHeroes.n-1 do
			local PlayerHeroX,PlayerHeroY = GetObjectPosition(PlayerHeroes[j]);
			local PatrolHeroX,PatrolHeroY = GetObjectPosition(heroname);
			local DestinationToPlayerHero = len(PlayerHeroX - PatrolHeroX,PlayerHeroY - PatrolHeroY);
			if  DestinationToPlayerHero < 12 then
				if CanMoveHero(heroname, PlayerHeroX,PlayerHeroY) == not nil then
					print("Patrol hero near enemy");
					IsConditionTrue[n] = 1;
					MoveHeroRealTime(heroname,PlayerHeroX,PlayerHeroY);
					local CurrentDay = GetDate(DAY);
					while CurrentDay == GetDate(DAY) do
						sleep(10);
					end;
					if IsHeroAlive(heroname) == not nil then
						print("Hero can continue patrol");
						IsConditionTrue[n] = 0;
					else
						print(heroname," is dead :(");
						return
					end;
					break;
				else
					print(heroname, " can not reach this point. May be player hero is not on the ship");
				end;
			end;
		end;
	end;
end;

function Objective_BuildCastleInNecropolis_Completed()
	while 1 do
		sleep(10);
		if (GetObjectiveState("prim1") == OBJECTIVE_COMPLETED) then
			ObjectiveExp("Berein");
			if IsObjectExists("Titans") == not nil then
				RemoveObject("Titans");
				MessageBox("/Maps/Scenario/C3M2/TitansRunAway_MsgBox.txt");
			end;
			print("Objective 1 completed. Now we must capture Hikm.");
			StartDialogScene("/DialogScenes/C3/M2/R2/DialogScene.xdb#xpointer(/DialogScene)");
			SetObjectiveState("prim2",OBJECTIVE_ACTIVE);
			Trigger(REGION_ENTER_AND_STOP_TRIGGER, "titans",nil);
			break;
		end
	end
end;

function HeroesMustSurvive()
	while 1 do
		sleep(10);
		if (IsHeroAlive("Berein") == nil) then
			print("Berein is dead. But he must live in our hearts forever...");
			SetObjectiveState("prim3",OBJECTIVE_FAILED);
			sleep(15);
			Loose(0);
			break;
		end;
		if (IsHeroAlive("Godric") == nil) then
			print("Godric is dead. ash to ash, dust to dust...");
			SetObjectiveState("prim3",OBJECTIVE_FAILED);
			sleep(15);
			Loose(0);
			break;
		end;
	end;
end

function PlayerWin()
	while 1 do
		sleep();
		if (GetObjectOwner("Hikm") == PLAYER_1) then
			print("Congratulations! You won!");
			SaveHeroAllSetArtifactsEquipped("Berein", "C3M2");
			sleep(10);
			if GetObjectiveState("prim2") == OBJECTIVE_ACTIVE then
				SetObjectiveState("prim2",OBJECTIVE_COMPLETED);
				else
				SetObjectiveState("prim2",OBJECTIVE_ACTIVE);
				sleep(5);
				SetObjectiveState("prim2",OBJECTIVE_COMPLETED);
			end;
			sleep(10);
			StartDialogScene("/DialogScenes/C3/M2/D2/DialogScene.xdb#xpointer(/DialogScene)", nil, "FirstDifficulties");
			GiveArtefact("Godric", 71); -- 71 - PEDANT OF NECROMANCY
			sleep(15);
			SetObjectiveState("prim3",OBJECTIVE_COMPLETED);
			sleep(15);
			Win(0);
			break;
		end;
	end;
end;

function HeroReachNecropolis()
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "necropolis",nil);
	if ( Flag == 0 ) then
		Flag = 1;
		PatrolTerminated = 1;
		print("Thread HeroReachNecropolis has been started...");
		sleep(2);
		StartDialogScene("/DialogScenes/C3/M2/R1/DialogScene.xdb#xpointer(/DialogScene)");
			SetRegionBlocked("block1",nil,PLAYER_2);
			SetRegionBlocked("block2",nil,PLAYER_2);
			SetRegionBlocked("block3",nil,PLAYER_2);
			SetRegionBlocked("antislonik",nil,PLAYER_2);
		AcademyHeroes = GetPlayerHeroes(PLAYER_2);
		AcademyHeroes.n = table.length(AcademyHeroes);
		if AcademyHeroes.n ~= 0 then
			print("AI has some heroes");
			for i = 0, AcademyHeroes.n - 1 do
				if AcademyHeroes[i] ~= "Astral" then
					EnableHeroAI(AcademyHeroes[i],not nil);
				else
					print("Enabling AI for hero", AcademyHeroes[i]," was ignored...");
				end;
			end;
			print("AI for all heroes has been enabled");
		else
			print("AI does not have any heroes");
		end;
	end;
end;


function EnableIsherAI()
	print("Thread EnableIsherAI has been started...");
	while 1 do
		sleep(10);
		if GetDate(WEEK) > DifficultyFactor or Exists("giants")==nil then
			print("Isher AI has been enabled");
			EnableHeroAI("Isher",not nil);
			break;
		end;
	end;
end;


function TitansMessage()
	print("Hero enters in Titans region");
	MessageBox("/Maps/Scenario/C3M2/TitansGuardTeleport_MsgBox.txt");
end;

function FightVsTitansQuestion(heroname)
	print("Thread FightVsTitansQuestion has been started...");
	GlobalHeroName = heroname;
	QuestionBox("/Maps/Scenario/C3M2/MsgBox_BeforeFightVSTitans.txt","CombatVSTitans");
end;

function CombatVSTitans()
	print("Thread CombatVSTitans has been started...");
	StartCombat(GlobalHeroName,nil,4,CREATURE_TITAN,20,CREATURE_TITAN,20,CREATURE_TITAN,20,CREATURE_TITAN,20,nil,"CombatVSTitansFinished");
end;

function CombatVSTitansFinished(heroname,result)
	print("Thread CombatVSTitansFinished has been started...");
	if result == not nil then
		print("Victory!");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER, "titans",nil);
		RemoveObject("Titans");
	else
		print(heroname, " was defeated by titans");
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

function GiveMeMoney()
	SetPlayerResource(1,WOOD,1000);
	SetPlayerResource(1,ORE,1000);
	SetPlayerResource(1,SULFUR,3000);
	SetPlayerResource(1,CRYSTAL,3000);
	SetPlayerResource(1,MERCURY,3000);
	SetPlayerResource(1,GEM,2000);
	SetPlayerResource(1,GOLD,200000);
end;

H55_CamFixTooManySkills(PLAYER_1,"Berein");
H55_CamFixTooManySkills(PLAYER_1,"Godric");
startThread(HeroesMustSurvive);
startThread(DifficultyDependency);
startThread(Objective_BuildCastleInNecropolis_Completed);
startThread(PlayerWin);
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "necropolis","HeroReachNecropolis",nil);
Trigger(OBJECT_TOUCH_TRIGGER, "Titans","FightVsTitansQuestion");
startThread(EnableIsherAI);
startThread(Patrol2,"Nur",Patrol_NurCoords,1);
startThread(Patrol2,"Faiz",Patrol_FaizCoords,2);
startThread(Patrol2,"Sufi",Patrol_SufiCoords,3);
startThread(Intercept,"Nur",1);
startThread(Intercept,"Faiz",2);
startThread(Intercept,"Sufi",3);
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "titans","TitansMessage");