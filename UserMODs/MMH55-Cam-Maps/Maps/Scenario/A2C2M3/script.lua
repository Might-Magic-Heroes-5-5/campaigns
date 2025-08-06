------------------------a2c2m3---------------------------
print("Start_A2C1M2.................");

MAIN_HERO = "Faiz";
ENEMY_HERO = "Efion"

EnableHeroAI(ENEMY_HERO, nil);


SetPlayerResource(1, 0, 0);
SetPlayerResource(1, 1, 0);
SetPlayerResource(1, 2, 0);
SetPlayerResource(1, 3, 0);
SetPlayerResource(1, 4, 0);
SetPlayerResource(1, 5, 0);
SetPlayerResource(1, 6, 500);

SetObjectEnabled("h1", nil);
SetObjectEnabled("h2", nil);
SetObjectEnabled("h3", nil);


sleep( 5 );
SetObjectiveState('prim1',OBJECTIVE_ACTIVE);
OpenCircleFog( 5, 112, 0, 4, PLAYER_1 );
PlayVisualEffect( "/Effects/_(Effect)/Spells/LuckGood.xdb#xpointer(/Effect)", "Faiz", "Faiz1", 0, 0, 0, 0, 0 );

------------------------------------------------Looses

function Herkill()  
	while 1 do
		sleep(10);
		if IsHeroAlive(MAIN_HERO) == nil then
			SetObjectiveState('prim3',OBJECTIVE_FAILED);
			sleep(2);
			Loose();
			break;
		end;
	end;
end;
-------------------------------------------------Kill_inferno_mob

function Mob() 
	while 1 do
		sleep ( 10 );
		if IsObjectExists("Monster") == nil then
			sleep( 5 );
			SetObjectiveState('prim2',OBJECTIVE_ACTIVE);
			break;
		end;
	end;
end;

-------------------------------------------------Kill_inferno_hero
function Obj2_complete()  
	while 1 do
		sleep(10);
		if IsHeroAlive(ENEMY_HERO) == nil then
			sleep(5);
			SetObjectiveState("prim2", OBJECTIVE_COMPLETED);
			sleep(2);
			break;
		end;
	end;
end;
-------------------------------------------------Final_combat

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Finalcombat","AIAction", nil );

function AIAction()
	BlockGame();
	sleep(15);
	ChangeHeroStat( ENEMY_HERO, STAT_MOVE_POINTS, 30000 );
	MoveHeroRealTime( ENEMY_HERO, GetObjectPosition( MAIN_HERO ) );
	sleep(25);
	UnblockGame();	
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Finalcombat",nil);
end;

-------------------------------------------------Winners

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Final","Pobeda", nil );

function Pobeda()
	sleep(5);
	Win();
	sleep(2);
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "Final",nil);
end;

-------------------------------------------------1

Trigger (OBJECT_TOUCH_TRIGGER, "h1", "Spec_1");

function Spec_1( heroname )
	HN = heroname;
	sleep(2);
	QuestionBox("Maps/Scenario/A2C2M3/mess1.txt", "f_1");	
end;


function f_1() 
	if GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) < 13 then
		startThread(Rand_1);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) == 13 then
		startThread(Rand_2);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) > 13 then
		startThread(Rand_3);	
	end;
end;

function Rand_1()
local x = random(10);
	if x <= 8 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_SUCCUBUS,5,CREATURE_SUCCUBUS,5,CREATURE_SUCCUBUS,5,nil);
	end;
	if x == 9 then
	SetObjectPos(MAIN_HERO, 122, 12, 0);
	end;
end;

function Rand_2()
local x = random(10);
	if x <= 4 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_SUCCUBUS,5,CREATURE_SUCCUBUS,5,CREATURE_SUCCUBUS,5,nil);
	end;
	if x >= 5 then
	SetObjectPos(MAIN_HERO, 122, 12, 0);
	end;
end;

function Rand_3()
local x = random(10);
	if x <= 7 then
	SetObjectPos(MAIN_HERO, 122, 12, 0);
--	StartCombat(MAIN_HERO,nil,3,CREATURE_SUCCUBUS,5,CREATURE_SUCCUBUS,5,CREATURE_SUCCUBUS,5,nil);
	end;
	if x >= 8 then
--	SetObjectPos(MAIN_HERO, 122, 12, 0);
	StartCombat(MAIN_HERO,nil,3,CREATURE_SUCCUBUS,5,CREATURE_SUCCUBUS,5,CREATURE_SUCCUBUS,5,nil);
	end;
end;
--------------------------------------------------------2
Trigger (OBJECT_TOUCH_TRIGGER, "h2", "Spec_2");

function Spec_2( heroname )
	HN = heroname;
	sleep(2);
	QuestionBox("Maps/Scenario/A2C2M3/mess1.txt", "f_2");	
end;


function f_2() 
	if GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) < 15 then
		startThread(Rand_11);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) == 15 then
		startThread(Rand_22);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) > 15 then
		startThread(Rand_33);	
	end;
end;


function Rand_11()
local x = random(10);
	if x <= 8 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,nil);
	end;
	if x == 9 then
	SetObjectPos(MAIN_HERO, 14, 16, 0);
	end;
end;

function Rand_22()
local x = random(10);
	if x <= 4 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,nil);
	end;
	if x >= 5 then
	SetObjectPos(MAIN_HERO, 14, 16, 0);
	end;
end;

function Rand_33()
local x = random(10);
	if x <= 7 then
	SetObjectPos(MAIN_HERO, 14, 16, 0);
--	StartCombat(MAIN_HERO,nil,3,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,nil);
	end;
	if x >= 8 then
--	SetObjectPos(MAIN_HERO, 14, 16, 0);
	StartCombat(MAIN_HERO,nil,3,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,CREATURE_INFERNAL_SUCCUBUS,5,nil);
	end;
end;
----------------------------------------------------3

Trigger (OBJECT_TOUCH_TRIGGER, "h3", "Spec_3");

function Spec_3( heroname )
	HN = heroname;
	sleep(2);
	QuestionBox("Maps/Scenario/A2C2M3/mess1.txt", "f_3");	
end;


function f_3() 
	if GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) < 16 then
		startThread(Rand_111);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) == 16 then
		startThread(Rand_222);
	elseif GetHeroStat( MAIN_HERO, STAT_KNOWLEDGE ) > 16 then
		startThread(Rand_333);	
	end;
end;

function Rand_111()
local x = random(10);
	if x <= 8 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_BALOR,1,CREATURE_BALOR,1,CREATURE_BALOR,1,nil);
	end;
	if x == 9 then
	SetObjectPos(MAIN_HERO, 122, 12, 0);
	end;
end;

function Rand_222()
local x = random(10);
	if x <= 4 then
	StartCombat(MAIN_HERO,nil,3,CREATURE_BALOR,1,CREATURE_BALOR,1,CREATURE_BALOR,1,nil);
	end;
	if x >= 5 then
	SetObjectPos(MAIN_HERO, 122, 12, 0);
	end;
end;

function Rand_333()
local x = random(10);
	if x <= 7 then
	SetObjectPos(MAIN_HERO, 122, 12, 0);
--	StartCombat(MAIN_HERO,nil,3,CREATURE_BALOR,1,CREATURE_BALOR,1,CREATURE_BALOR,1,nil);
	end;
	if x >= 8 then
--	SetObjectPos(MAIN_HERO, 122, 12, 0);
	StartCombat(MAIN_HERO,nil,3,CREATURE_BALOR,1,CREATURE_BALOR,1,CREATURE_BALOR,1,nil);
	end;
end;

-------------------------------------------

startThread(Herkill);
startThread(Mob);
startThread(Obj2_complete);