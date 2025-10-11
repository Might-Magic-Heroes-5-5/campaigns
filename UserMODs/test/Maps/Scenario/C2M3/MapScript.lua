H55_PlayerStatus = {0,1,2,2,2,2,2,2};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C2M3");
    LoadHeroAllSetArtifacts("Agrael", "C2M2" );
end;

startThread(H55_InitSetArtifacts);

DividingNumber = 2; -- chislo, na kotoroe budet delitsya armiya Gilliona na NORMALe
DaysToGillionAIActivation=21; -- standartnoe chislo dney, cherez kotoroe Gillion prosipasetsya
Diff = GetDifficulty ();
if Diff == DIFFICULTY_NORMAL or Diff == DIFFICULTY_EASY then DaysToGillionAIActivation=42; end;
print ('Number of AI sleeping days: ', DaysToGillionAIActivation);


IsDruidsDefeated = 0;
C2M3_C1 = 0;
C2M3_C2 = 0;
C2M3_C3 = 0;
C2M3_C4 = 0;
C2M3_C5 = 0;
C2M3_C6 = 0;
C2M3_C7 = 0;
C2M3_C8 = 0;
increment = 0;
number=0;
AIenabled = 0;
FirstTime = 0;

function messages( dialog ) --вызывает диалогавые сцены и мессадж боксы в зависимости от входных параметров
	if dialog == 1 then
		C2M3_C1 = 1;
		print("C2M3_C1");
		StartDialogScene("/DialogScenes/C2/M3/D1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 2 then
		C2M3_C2 = 1;
		print("C2M3_C2");
		StartDialogScene("/DialogScenes/C2/M3/R1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 3 then
		C2M3_C3 = 1;
		print("C2M3_C3");
		StartDialogScene("/DialogScenes/C2/M3/R2/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 4 then
		MessageBox ("/Maps/Scenario/C2M3/messages/C2M3_C4.txt");
		C2M3_C4 = 1;
		print("C2M3_C4");
	end;
	if dialog == 5 then
		C2M3_C5 = 1;
		print("C2M3_C5");
		StartDialogScene("/DialogScenes/C2/M3/R3/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 6 then
		C2M3_C6 = 1;
		print("C2M3_C6");
		StartDialogScene("/DialogScenes/C2/M3/R4/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 7 then
		C2M3_C7 = 1;
		print("C2M3_C7");
		StartDialogScene("/DialogScenes/C2/M3/R5/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 8 then
		C2M3_C8 = 1;
		print("C2M3_C8");
		StartDialogScene("/DialogScenes/C2/M3/D2/DialogScene.xdb#xpointer(/DialogScene)");
	end;
end;

function Obj2() --тригерная функция(OBJECTIVE_STATE_CHANGE)
	if GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
		messages( 8 );
		ObjectiveExp("Agrael");
	end;
end;


function WinLoose()
	while 1 do
		sleep( 2 );
		if      GetObjectiveState("prim1") == OBJECTIVE_COMPLETED 
			and GetObjectiveState("prim2") == OBJECTIVE_COMPLETED then
			SetObjectiveState('prim4', OBJECTIVE_COMPLETED )
			SaveHeroAllSetArtifactsEquipped("Agrael", "C2M3");
			sleep( 10 );
			Win();
			return
		end;
		if GetObjectiveState("prim1") == OBJECTIVE_FAILED or GetObjectiveState("prim2") == OBJECTIVE_FAILED
		  or GetObjectiveState("prim4") == OBJECTIVE_FAILED then
			Loose();
			return
		end;
	end;
end;




function FightWithDruids(name) --триггерная функция (region enter and stop)
	if IsDruidsDefeated == 0 then
		local n;
		messages( 6 )
		IsDruidsDefeated = 1;
		n = GetDate(MONTH)+GetDate(WEEK)+GetDifficulty()*2;
		StartCombat(name,nil,5,CREATURE_DRUID_ELDER,n,CREATURE_DRUID_ELDER,n,CREATURE_TREANT_GUARDIAN,n,CREATURE_DRUID_ELDER,n,CREATURE_DRUID_ELDER,n,"/Maps/Scenario/C2M3/BattleVSDruids.xdb#xpointer(/Script)",'AfterFightWithDruids')
	end;
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'druids', nil );
end

function AfterFightWithDruids(name,result) --подфункция FightWithDruids(), вызывается по окончанию комбата, если комбат проигран то ничего не происходит
	if result==not nil then
		if GetObjectiveState("prim3") == OBJECTIVE_ACTIVE then
			messages( 7 )
			SetObjectiveState( 'prim3', OBJECTIVE_COMPLETED );
		end;		
		RemoveObject('drood01');
		RemoveObject('drood02');
		RemoveObject('drood03');
		RemoveObject('drood04');
		RemoveObject('drood05');
		ObjectiveExp("Agrael");
		H55_NewDayTrigger = 0;
		--Trigger( NEW_DAY_TRIGGER, nil );
	end;
end;
	

function CreaturesSpawn() 
	if GetDate( DAY_OF_WEEK ) == 1 then
		if (IsDruidsDefeated == 0) then
			--GenerateMonsters(monsterTypeID, countGroupsMin, countGroupsMax, countInGroupMin, countInGroupMax)
			if GetDifficulty() == DIFFICULTY_HEROIC then 
				increment = increment+1;
				GenerateMonsters(CREATURE_SPRITE, 10, 15, 50*increment, 80*increment);
				GenerateMonsters(CREATURE_WAR_DANCER, 5, 10, 30*increment, 50*increment);
				GenerateMonsters(CREATURE_GRAND_ELF, 4, 8, 16*increment, 25*increment);
				print("Druids have spawned monsters. Difficulty is HEROIC");
				else if GetDifficulty() == DIFFICULTY_HARD then 
					increment = increment+1;
					GenerateMonsters(CREATURE_SPRITE, 8, 12, 40*increment, 60*increment);
					GenerateMonsters(CREATURE_WAR_DANCER, 4, 8, 25*increment, 40*increment);
					GenerateMonsters(CREATURE_WOOD_ELF, 3, 6, 14*increment, 22*increment);
					print("Druids have spawned monsters. Difficulty is HARD");
					else if GetDifficulty() == DIFFICULTY_NORMAL then 
						GenerateMonsters(CREATURE_PIXIE, 8, 10, 30, 40);
						GenerateMonsters(CREATURE_BLADE_JUGGLER, 3, 6, 15, 20);
						GenerateMonsters(CREATURE_WOOD_ELF, 1, 2, 8, 10);
						print("Druids have spawned monsters. Difficulty is NORMAL");
						else if GetDifficulty() == DIFFICULTY_EASY then 
							GenerateMonsters(CREATURE_PIXIE, 4, 8, 15, 25);
							GenerateMonsters(CREATURE_BLADE_JUGGLER, 2, 4, 10, 14);
							print("Druids have spawned monsters. Difficulty is EASY");
						end;
					end;
				end;
			end;
		end;
	end;
end;

function H55_TriggerDaily()
	if GetDate( DAY_OF_WEEK ) == 1 then
		if FirstTime == 0 then
			messages( 5 );
			sleep( 1 );
			SetObjectiveState( 'prim3', OBJECTIVE_ACTIVE );
			FirstTime = 1;
		end;
		MessageBox ("/Maps/Scenario/C2M3/messages/C2M3_C4.txt", 'CreaturesSpawn' );
	end;
end;

function LodefallotIsCaptured()
	print("Thread LodefallotIsCaptured has been started...");
	while GetObjectOwner("Town1") == PLAYER_2 do
		sleep(5);
	end;
	print("Town Lodefallot has been captured by player");
	if IsHeroAlive("Gillion") == not nil then
		messages( 3 );
	end;
	if IsDruidsDefeated == 0 then
		H55_NewDayTrigger = 1;
		--Trigger( NEW_DAY_TRIGGER, 'NewDay' );
	else
		print("Druids already defeated");
	end;
end;


function FirstFight(name) --триггерная функция (region), певая встреча Аграила с Гилреаном
	if name == 'Agrael' then
		messages( 1 );
		x,y = GetObjectPosition("Gillion");
		ChangeHeroStat("Agrael",STAT_MOVE_POINTS,500);
		MoveHeroRealTime('Agrael',x,y,GROUND);
		EnableHeroAI("Gillion",not nil);
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "border", nil );
	end;
end;

function scene2(name)
	if name=='Gillion' then
		messages( 2 )
		sleep(2);
		MessageBox("/Maps/Scenario/C2M3/Message_GilraenDefeated.txt");
		SetObjectiveState( 'prim0', OBJECTIVE_COMPLETED );
		ObjectiveExp("Agrael");
		DeployReserveHero("Gillion", 115, 95, GROUND);
		EnableHeroAI("Gillion",nil);
		startThread(EnableGilraenAI,GetDate(DAY));
		Trigger( PLAYER_REMOVE_HERO_TRIGGER , PLAYER_2, nil);
		SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );
	end
end


function DifficultyDependencies()
	if GetDifficulty()==DIFFICULTY_HARD then
		print("Difficulty Level is HARD");
		AddHeroCreatures('Agrael', CREATURE_SUCCUBUS, 4);
		SetPlayerStartResource(PLAYER_1,WOOD,15);
		SetPlayerStartResource(PLAYER_1,ORE,15);
		SetPlayerStartResource(PLAYER_1,GEM,10);
		SetPlayerStartResource(PLAYER_1,CRYSTAL,10);
		SetPlayerStartResource(PLAYER_1,MERCURY,10);
		SetPlayerStartResource(PLAYER_1,SULFUR,10);
		SetPlayerStartResource(PLAYER_1,GOLD,8000);
		else if GetDifficulty()==DIFFICULTY_NORMAL then
			print("Difficulty Level is NORMAL");
			AddHeroCreatures('Agrael', CREATURE_SUCCUBUS, 15);
			AddHeroCreatures('Agrael', CREATURE_FAMILIAR, 30);
			SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_FORT,2);
			SetTownBuildingLimitLevel("InfernoTown",TOWN_BUILDING_FORT,2);
			SetPlayerStartResource(PLAYER_1,WOOD,30);
			SetPlayerStartResource(PLAYER_1,ORE,30);
			SetPlayerStartResource(PLAYER_1,GEM,15);
			SetPlayerStartResource(PLAYER_1,CRYSTAL,15);
			SetPlayerStartResource(PLAYER_1,MERCURY,15);
			SetPlayerStartResource(PLAYER_1,SULFUR,15);
			SetPlayerStartResource(PLAYER_1,GOLD,20000);
			else if GetDifficulty()==DIFFICULTY_HEROIC then
				print("Difficulty Level is HEROIC");
				SetPlayerStartResource(PLAYER_1,WOOD,10);
				SetPlayerStartResource(PLAYER_1,ORE,10);
				SetPlayerStartResource(PLAYER_1,GEM,5);
				SetPlayerStartResource(PLAYER_1,CRYSTAL,5);
				SetPlayerStartResource(PLAYER_1,MERCURY,5);
				SetPlayerStartResource(PLAYER_1,SULFUR,5);
				SetPlayerStartResource(PLAYER_1,GOLD,5000);
				else if GetDifficulty()==DIFFICULTY_EASY then
					print("Difficulty Level is EASY");
					AddHeroCreatures('Agrael', CREATURE_SUCCUBUS, 20);
					AddHeroCreatures('Agrael', CREATURE_FAMILIAR, 60);
					AddHeroCreatures('Agrael', CREATURE_HELL_HOUND, 20);
					SetTownBuildingLimitLevel("InfernoTown",TOWN_BUILDING_FORT,3);
					SetTownBuildingLimitLevel("Town2",TOWN_BUILDING_FORT,1);
					SetPlayerStartResource(PLAYER_1,WOOD,30);
					SetPlayerStartResource(PLAYER_1,ORE,30);
					SetPlayerStartResource(PLAYER_1,GEM,15);
					SetPlayerStartResource(PLAYER_1,CRYSTAL,15);
					SetPlayerStartResource(PLAYER_1,MERCURY,15);
					SetPlayerStartResource(PLAYER_1,SULFUR,15);
					SetPlayerStartResource(PLAYER_1,GOLD,20000);
				end;
			end;
		end;
	end
end

function agrael_dead(name)
	if name=='Agrael' then
		print("Agrael is dead. Name = ",name);
		SetObjectiveState("prim4",OBJECTIVE_FAILED);
		sleep(15);
		Loose(PLAYER_1);
	end;
end;

function EnableGilraenAI(date)
	if Diff == DIFFICULTY_NORMAL then 
		print("6 weeks before Gilraen's AI enabling");
	  else print("3 weeks before Gilraen's AI enabling"); end;
	while GetDate(DAY) <= date + DaysToGillionAIActivation do
		sleep(10);
	end;
	print("Time to AI enabling");
	if (IsHeroAlive("Gillion") == not nil) and (AIenabled == 0) then
		EnableHeroAI("Gillion",not nil);
		HalfArmy();
		AIenabled = 1;
		print("AI was enabled");
	end;
end;


function GilraenAI(heroname)
	if (heroname == "Agrael") and (AIenabled == 0) then
		EnableHeroAI("Gillion",not nil);
		HalfArmy();
		AIenabled = 1;
		print("AI for hero Gillion has been enabled");
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"Gilraen",nil);
	else
		print("enemy hero has entered in region Gilraen");
		Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"Gilraen","GilraenAI");
	end;
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
------------------------------------------------------
function HalfArmy ()
	if Diff == DIFFICULTY_NORMAL or Diff == DIFFICULTY_EASY  then --- UPOLOVINIVAEM ARMIYU GILLIANA NA NORMALE ----
		print ('Nachinaem delenie')
		local creatures = {
		CREATURE_BLADE_JUGGLER,
		CREATURE_WAR_DANCER,
		CREATURE_WOOD_ELF,
		CREATURE_GRAND_ELF,
		CREATURE_DRUID,
		CREATURE_DRUID_ELDER,
		CREATURE_UNICORN,
		CREATURE_WAR_UNICORN,
		CREATURE_DRYAD,
		CREATURE_BLADE_SINGER,
		CREATURE_SHARP_SHOOTER,
		CREATURE_HIGH_DRUID,
		CREATURE_WHITE_UNICORN
		}
		
		for index, creature in creatures do
			local count = GetHeroCreatures('Gillion', creature) / DividingNumber;
			if count > 0 then
				RemoveHeroCreatures('Gillion', creature, count);
			end;
		end;
		
		local DeletedCreatures = {
		CREATURE_TREANT,
		CREATURE_TREANT_GUARDIAN,
		CREATURE_GREEN_DRAGON,
		CREATURE_GOLD_DRAGON,
		CREATURE_ANGER_TREANT,
		CREATURE_RAINBOW_DRAGON
		}

		for index, creature in DeletedCreatures do
			local count = GetHeroCreatures('Gillion', creature);
			if count > 0 then
				RemoveHeroCreatures('Gillion', creature, count);
			end;
		end;
	end;
end;

--------------------------SCRIPT MAIN PART-------------------------------------------------------

--------------------------------------------
H55_CamFixTooManySkills(PLAYER_1,"Agrael");
DeployReserveHero("Gillion", 34, 28, GROUND);
EnableAIHeroHiring(PLAYER_2,"Town1",nil);

DifficultyDependencies();
EnableHeroAI("Gillion",nil)
startThread(LodefallotIsCaptured);
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "border", "FirstFight" );
Trigger( PLAYER_REMOVE_HERO_TRIGGER , PLAYER_2, 'scene2')
Trigger( PLAYER_REMOVE_HERO_TRIGGER , PLAYER_1, 'agrael_dead' )
--------------------------------------------

SetRegionBlocked("blockAI", not nil, PLAYER_2);
SetRegionBlocked("BorderBlockAI",not nil,PLAYER_2);
Trigger( OBJECTIVE_STATE_CHANGE_TRIGGER , "prim2", "Obj2" );
Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"Gilraen","GilraenAI");
Trigger( REGION_ENTER_AND_STOP_TRIGGER, 'druids', "FightWithDruids" );
startThread( WinLoose );
	