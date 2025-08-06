H55_PlayerStatus = {0,2,2,2,2,2,2,2};
HERO_NAME = "Christian"
SetPlayerStartResource(PLAYER_1,ORE,0);
SetPlayerStartResource(PLAYER_1,WOOD,0);
SetPlayerStartResource(PLAYER_1,CRYSTAL,0);
SetPlayerStartResource(PLAYER_1,GEM,0);
SetPlayerStartResource(PLAYER_1,SULFUR,0);
SetPlayerStartResource(PLAYER_1,MERCURY,0);

function DifficultyDependency()
	if GetDifficulty() == DIFFICULTY_EASY then 
		SetPlayerStartResource(PLAYER_1,GOLD,15000);
		print("Difficulty level is easy.");
	else
		if GetDifficulty() == DIFFICULTY_NORMAL then 
			SetPlayerStartResource(PLAYER_1,GOLD,10000);
			print("Difficulty level is normal.");
		else
			if GetDifficulty() == DIFFICULTY_HARD then 
				SetPlayerStartResource(PLAYER_1,GOLD,5000);
				print("Difficulty level is hard.");
			else
			if GetDifficulty() == DIFFICULTY_HEROIC then 
					SetPlayerStartResource(PLAYER_1,GOLD,1000);
					print("Difficulty level is heroic.");
				end;
			end;
		end;
	end;
end;


function PlayerWin()
	while 1 do
		sleep(10);
		if (IsObjectInRegion(HERO_NAME,"end") == not nil) then
			SetObjectiveState("HeroSurvive", OBJECTIVE_COMPLETED);
			sleep(5);
			SetObjectiveState("PlayerWin", OBJECTIVE_COMPLETED);
			sleep(5);
			Win(0);
			break;
		end;
	end;
end;

Trigger( PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero" );
function LostHero( HeroName )
	if ( HeroName == HERO_NAME ) then
		SetObjectiveState("HeroSurvive", OBJECTIVE_FAILED);
		sleep (10);
		Loose();
	end;
end;

Trigger( OBJECT_TOUCH_TRIGGER , "red" , "redkey" );
function redkey()
	SetObjectiveState('first', OBJECTIVE_ACTIVE);
	Trigger(OBJECT_TOUCH_TRIGGER,"red" , "redquest");
--	AddHeroCreatures(HERO_NAME, CREATURE_PEASANT, 10);
--	AddHeroCreatures(HERO_NAME, CREATURE_WOOD_ELF, 10);
--	AddHeroCreatures(HERO_NAME, CREATURE_FAMILIAR, 20);
--	AddHeroCreatures(HERO_NAME, CREATURE_GREMLIN, 2);
end;

Trigger( OBJECT_TOUCH_TRIGGER , "blue" , "bluekey" );
function bluekey()
	SetObjectiveState('second', OBJECTIVE_ACTIVE);
	Trigger(OBJECT_TOUCH_TRIGGER,"blue" , "bluequest");
--	AddHeroCreatures(HERO_NAME, CREATURE_ZOMBIE, 25);
--	AddHeroCreatures(HERO_NAME, CREATURE_VAMPIRE, 20);
--	AddHeroCreatures(HERO_NAME, CREATURE_LICH, 16);
end;

Trigger( OBJECT_TOUCH_TRIGGER , "green" , "greenkey" );
function greenkey()
	SetObjectiveState('third', OBJECTIVE_ACTIVE);
	Trigger(OBJECT_TOUCH_TRIGGER,"green" , "greenquest");
--	AddHeroCreatures(HERO_NAME, CREATURE_GIANT, 1);
--	AddHeroCreatures(HERO_NAME, CREATURE_DEVIL, 2);
--	AddHeroCreatures(HERO_NAME, CREATURE_BONE_DRAGON, 2);
--	AddHeroCreatures(HERO_NAME, CREATURE_ANGEL, 5);
end;

function redquest_old()
	print("Thread redquest has been started...");
	if GetHeroCreatures(HERO_NAME,CREATURE_PEASANT) >= 10 then
		if 2 * GetHeroCreatures(HERO_NAME,CREATURE_PEASANT) >= GetHeroCreatures(HERO_NAME,CREATURE_FAMILIAR) then
			if 2 * GetHeroCreatures(HERO_NAME,CREATURE_WOOD_ELF) >= GetHeroCreatures(HERO_NAME,CREATURE_FAMILIAR) then
			if GetHeroCreatures(HERO_NAME,CREATURE_PEASANT) >= 5 * GetHeroCreatures(HERO_NAME,CREATURE_GREMLIN) then
			SetObjectiveState("first",OBJECTIVE_COMPLETED);
			ObjectiveExp(HERO_NAME);
			RemoveHeroCreatures(HERO_NAME,CREATURE_GREMLIN,GetHeroCreatures(HERO_NAME,CREATURE_GREMLIN));
			RemoveHeroCreatures(HERO_NAME,CREATURE_WOOD_ELF,GetHeroCreatures(HERO_NAME,CREATURE_WOOD_ELF));
			RemoveHeroCreatures(HERO_NAME,CREATURE_FAMILIAR,GetHeroCreatures(HERO_NAME,CREATURE_FAMILIAR));
			RemoveHeroCreatures(HERO_NAME,CREATURE_PEASANT,GetHeroCreatures(HERO_NAME,CREATURE_PEASANT) - 1);
			Trigger(OBJECT_TOUCH_TRIGGER, "red" , nil);
			GiveBorderguardKey(1 , RED_KEY);
			else
				print("Peasant >= 5 * Gremlin not success");
			end;
			else
				print("Wood Elf >= 2 * Familiar not success");
			end;
		else
			print("2 * Peasants >= Familiar not success");
		end;
		else
		print("not enough peasants");
	end;
end;

function redquest()
	print("Thread redquest has been started...");
	if GetHeroCreatures(HERO_NAME,CREATURE_PEASANT) >= 20 then
		local familiars = GetHeroCreatures(HERO_NAME,CREATURE_FAMILIAR);
		local wood_elves = GetHeroCreatures(HERO_NAME,CREATURE_WOOD_ELF);
		local gremlins = GetHeroCreatures(HERO_NAME,CREATURE_GREMLIN);
		if GetHeroCreatures(HERO_NAME,CREATURE_PEASANT) >= 2 * familiars and familiars~=0 then
			if GetHeroCreatures(HERO_NAME,CREATURE_PEASANT) >= 4 * wood_elves and  wood_elves~=0 then
			if GetHeroCreatures(HERO_NAME,CREATURE_PEASANT) >= 20 * gremlins and gremlins~=0 then
			SetObjectiveState("first",OBJECTIVE_COMPLETED);
			ObjectiveExp(HERO_NAME);
			--RemoveHeroCreatures(HERO_NAME,CREATURE_GREMLIN,GetHeroCreatures(HERO_NAME,CREATURE_GREMLIN));
			--RemoveHeroCreatures(HERO_NAME,CREATURE_WOOD_ELF,GetHeroCreatures(HERO_NAME,CREATURE_WOOD_ELF));
			--RemoveHeroCreatures(HERO_NAME,CREATURE_FAMILIAR,GetHeroCreatures(HERO_NAME,CREATURE_FAMILIAR));
			--RemoveHeroCreatures(HERO_NAME,CREATURE_PEASANT,GetHeroCreatures(HERO_NAME,CREATURE_PEASANT) - 1);
			Trigger(OBJECT_TOUCH_TRIGGER, "red" , nil);
			GiveBorderguardKey(1 , RED_KEY);
			else
				print("Peasant >= 20 * Gremlin not success");
			end;
			else
				print("Peasant >= 4 * Wood Elf not success");
			end;
		else
			print("Peasants >= 2 * Familiar not success");
		end;
		else
		print("not enough peasants");
	end;
end;

function bluequest()
	Zombie = GetHeroCreatures(HERO_NAME,CREATURE_ZOMBIE);
	Walking_dead = GetHeroCreatures(HERO_NAME,CREATURE_WALKING_DEAD);
	Vampire = GetHeroCreatures(HERO_NAME,CREATURE_VAMPIRE);
	Vampire_lord = GetHeroCreatures(HERO_NAME,CREATURE_VAMPIRE_LORD);
	Lich = GetHeroCreatures(HERO_NAME,CREATURE_LICH);
	Demilich = GetHeroCreatures(HERO_NAME,CREATURE_DEMILICH);
	if (Zombie + Walking_dead == 25 and Vampire + Vampire_lord == 20 and Lich + Demilich == 16) then
		SetObjectiveState("second",OBJECTIVE_COMPLETED);
		ObjectiveExp(HERO_NAME);
		--if Zombie ~= 0  then 
		--	RemoveHeroCreatures(HERO_NAME,CREATURE_ZOMBIE,Zombie);
		--end;
		--print("zombie. ID = ",CREATURE_ZOMBIE,". Quantity = ",Zombie);
		--AddHeroCreatures(HERO_NAME, CREATURE_PEASANT, 1);
		--if Vampire ~= 0 then
			--RemoveHeroCreatures(HERO_NAME,CREATURE_VAMPIRE,Vampire);
		--end;
		--print("Vampire. ID = ",CREATURE_VAMPIRE,". Quantity = ",Vampire);
		--if Lich ~= 0    then
			--RemoveHeroCreatures(HERO_NAME,CREATURE_LICH,Lich);
		--end;
		--print("Lich. ID = ",CREATURE_LICH,". Quantity = ",Lich);
		--if Walking_dead ~= 0 then
			--RemoveHeroCreatures(HERO_NAME,CREATURE_WALKING_DEAD,Walking_dead);
		--end;
		--print("Walking dead. ID = ",CREATURE_WALKING_DEAD,". Quantity = ",Walking_dead);
		--if Vampire_lord ~= 0 then
			--RemoveHeroCreatures(HERO_NAME,CREATURE_VAMPIRE_LORD,Vampire_lord);
		--end;
		--print("Vampire Lord. ID = ",CREATURE_VAMPIRE_LORD,". Quantity = ",Vampire_lord);
		--if Demilich ~= 0     then
			--RemoveHeroCreatures(HERO_NAME,CREATURE_DEMILICH,Demilich);
		--end;
		--print("Demilich. ID = ",CREATURE_DEMILICH,". Quantity = ",Demilich);
		Trigger(OBJECT_TOUCH_TRIGGER, "blue" , nil);
		GiveBorderguardKey(1 , BLUE_KEY);
	end;
end;

function greenquest()
	if (GetHeroCreatures(HERO_NAME,CREATURE_GIANT) == 1
		and GetHeroCreatures(HERO_NAME,CREATURE_DEVIL) == 2 
		and GetHeroCreatures(HERO_NAME,CREATURE_BONE_DRAGON) == 2
		and GetHeroCreatures(HERO_NAME,CREATURE_ANGEL) == 5) then
		SetObjectiveState("third",OBJECTIVE_COMPLETED);
		ObjectiveExp(HERO_NAME);
		--RemoveHeroCreatures(HERO_NAME,CREATURE_GIANT,1);
		--AddHeroCreatures(HERO_NAME, CREATURE_PEASANT, 1);
		--RemoveHeroCreatures(HERO_NAME,CREATURE_DEVIL,2);
		--RemoveHeroCreatures(HERO_NAME,CREATURE_BONE_DRAGON,2);
		--RemoveHeroCreatures(HERO_NAME,CREATURE_ANGEL,5);
		Trigger(OBJECT_TOUCH_TRIGGER, "green" , nil);
		GiveBorderguardKey(1 , GREEN_KEY);
		startThread(PlayerWin);
	end;
end;

--DEBUG FUNCTIONS ---------
function GiveMeQuest1Creatures()
	AddHeroCreatures(HERO_NAME, CREATURE_PEASANT, 10);
	AddHeroCreatures(HERO_NAME, CREATURE_WOOD_ELF, 10);
	AddHeroCreatures(HERO_NAME, CREATURE_FAMILIAR, 20);
	AddHeroCreatures(HERO_NAME, CREATURE_GREMLIN, 2);
end;

function GiveMeQuest1CreaturesNew()
	AddHeroCreatures(HERO_NAME, CREATURE_PEASANT, 20);
	AddHeroCreatures(HERO_NAME, CREATURE_WOOD_ELF, 5);
	AddHeroCreatures(HERO_NAME, CREATURE_FAMILIAR, 10);
	AddHeroCreatures(HERO_NAME, CREATURE_GREMLIN, 1);
end;

function GiveMeQuest2Creatures()
	AddHeroCreatures(HERO_NAME, CREATURE_ZOMBIE, 25);
	AddHeroCreatures(HERO_NAME, CREATURE_VAMPIRE, 20);
	AddHeroCreatures(HERO_NAME, CREATURE_LICH, 16);
end;

function GiveMeQuest3Creatures()
	AddHeroCreatures(HERO_NAME, CREATURE_GIANT, 1);
	AddHeroCreatures(HERO_NAME, CREATURE_DEVIL, 2);
	AddHeroCreatures(HERO_NAME, CREATURE_BONE_DRAGON, 2);
	AddHeroCreatures(HERO_NAME, CREATURE_ANGEL, 5);
end;

function ObjectiveExp(HeroName)
	local ToLevel = GetExpToLevel(GetHeroLevel(HeroName)+1);
	local delta = (ToLevel - GetHeroStat(HeroName, STAT_EXPERIENCE)) / 2;
	ChangeHeroStat(HeroName, STAT_EXPERIENCE,delta);
	print("Now ",HeroName, " has ", GetHeroStat(HeroName, STAT_EXPERIENCE)," exp");
end;

function GetExpToLevel( j )
	local sum;      --LEVEL 1 2    3    4    5    6    7    8     9     10    11    12
	ExpArrayLess12 = {0,1000,2000,3200,4600,6200,8000,10000,12200,14700,17500,20600};
	ExpArrayLess12.n = 12;
					--LEVEL 13    14    15    16    17    18    19    20    21    22     23     24
	ExpArrayMore12 = {24320,28784,34141,40569,48283,57539,68647,81977,97972,117166,140200,167839};
	ExpArrayMore12.n = 12;
					--LEVEL 25     26     27     28     29     30     31      32      33      34
	ExpArrayMore25 = {201007,244126,304491,395040,539917,786208,1229533,2071000,3756484,7294215};
	ExpArrayMore25.n = 10;
	if j <= 12 then
		sum = ExpArrayLess12[j];
	else
		if j < 25 then
			sum = ExpArrayMore12[j-12];
		else
			if j < 35 then
				sum = ExpArrayMore25[j-24];
			else
				print("Das ist fantastisch!!!");
				sum = 0;
			end;
		end;
	end;
	print("Hero need ", sum, " experience to gain level ",j);
	return sum;
end;

SetObjectEnabled("red", nil);
SetObjectEnabled("blue", nil);
SetObjectEnabled("green", nil);
SetObjectiveState('HeroSurvive', OBJECTIVE_ACTIVE);
SetObjectiveState('PlayerWin', OBJECTIVE_ACTIVE);
DifficultyDependency();