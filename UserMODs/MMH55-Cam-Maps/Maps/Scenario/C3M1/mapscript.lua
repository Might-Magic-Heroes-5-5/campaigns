doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C3M1");
end;

startThread(H55_InitSetArtifacts);

H55_RemoveTheseArtifactsFromBanks = {ARTIFACT_STAFF_OF_VEXINGS,ARTIFACT_RING_OF_DEATH,ARTIFACT_CLOAK_OF_MOURNING,ARTIFACT_NECROMANCER_PENDANT};

-- CONSTS ------------
OUR_HERO = "Berein";
WIZARD_1_NAME = "Tan";
WIZARD_2_NAME = "Astral";
REBEL_HERO = "Mardigo"

INTERCEPT_RADIUS = 13;
DETECTING_RADIUS = 2.7;
ENEMY_STOPPING_RADIUS = 5;
INTERCEPT_FACTOR = 0.5;
START_INTERCEPT = 1;

--Block Regions
SetRegionBlocked("dungeon",1,3);
SetRegionBlocked("dungeon",1,2);
SetRegionBlocked("vampires",1,3);
SetRegionBlocked("almegir",1,3);
--Disable Hero AI
EnableHeroAI('Godric',nil);
EnableHeroAI(WIZARD_1_NAME,nil);
EnableHeroAI(WIZARD_2_NAME,nil);
SetObjectEnabled(WIZARD_1_NAME,nil);
SetObjectEnabled(WIZARD_2_NAME,nil);
EnableHeroAI(REBEL_HERO,nil);
EnableHeroAI('Almegir',nil);
EnableHeroAI('Dalom',nil);


SetPlayerResource(PLAYER_1,WOOD,10);
SetPlayerResource(PLAYER_1,ORE,10);
SetPlayerResource(PLAYER_1,GEM,5);
SetPlayerResource(PLAYER_1,CRYSTAL,5);
SetPlayerResource(PLAYER_1,MERCURY,5);
SetPlayerResource(PLAYER_1,SULFUR,5);
SetPlayerResource(PLAYER_1,GOLD,500);

SetPlayerResource(PLAYER_3,WOOD,0);
SetPlayerResource(PLAYER_3,ORE,0);
SetPlayerResource(PLAYER_3,GEM,0);
SetPlayerResource(PLAYER_3,CRYSTAL,0);
SetPlayerResource(PLAYER_3,MERCURY,0);
SetPlayerResource(PLAYER_3,SULFUR,0);
SetPlayerResource(PLAYER_3,GOLD,0);

SetPlayerResource(PLAYER_2,WOOD,0);
SetPlayerResource(PLAYER_2,ORE,0);
SetPlayerResource(PLAYER_2,GEM,0);
SetPlayerResource(PLAYER_2,CRYSTAL,0);
SetPlayerResource(PLAYER_2,MERCURY,0);
SetPlayerResource(PLAYER_2,SULFUR,0);
SetPlayerResource(PLAYER_2,GOLD,0);


StartDialogScene("/DialogScenes/C3/M1/D1/DialogScene.xdb#xpointer(/DialogScene)");

coords = {{22,34},{18,45},{8,57},{7,78},{16,88}};
coords2 = {{44,63},{31,73},{17,79},{16,92}};
coords.n = 5;
coords2.n = 4;


--DIFFICULTY LEVEL DEPENDENCIES -----------

if GetDifficulty() == DIFFICULTY_EASY then
	CreateMonster("skeleton_archer",CREATURE_SKELETON_ARCHER,100,32,67,0);
	CreateMonster("demilich",CREATURE_DEMILICH,12,57,33,0);
	CreateMonster("vampire_lord",CREATURE_VAMPIRE_LORD,16,45,61,1);
	-- CreateMonster("skeleton_archer2",CREATURE_SKELETON_ARCHER,50,25,21,0);
	-- CreateMonster("lich",CREATURE_LICH,6,31,39,0);
	-- CreateMonster("skeleton",CREATURE_SKELETON,62,23,9,0);
	-- CreateMonster("vampire_lord2",CREATURE_VAMPIRE_LORD,8,75,21,0);
	-- CreateMonster("demilich2",CREATURE_DEMILICH,8,71,24,1);
	-- CreateMonster("vampire_lord3",CREATURE_VAMPIRE_LORD,16,48,76,1);
	AddHeroCreatures(OUR_HERO,CREATURE_LICH,4);
	AddHeroCreatures(OUR_HERO,CREATURE_SKELETON,40);
	START_INTERCEPT = 0;
	print("Difficulty level is EASY");
end;

if GetDifficulty() == DIFFICULTY_NORMAL then
	print("Difficulty level is NORMAL");
	CreateMonster("skeleton_archer",CREATURE_SKELETON_ARCHER,100,32,67,0);
	CreateMonster("demilich",CREATURE_DEMILICH,12,57,33,0);
	CreateMonster("vampire_lord",CREATURE_VAMPIRE_LORD,16,45,61,1);
	START_INTERCEPT = 0;
end;

if GetDifficulty() == DIFFICULTY_HARD then
	print("Difficulty level is HARD");
	AddHeroCreatures(REBEL_HERO,CREATURE_GRIFFIN,6);
	AddHeroCreatures(REBEL_HERO,CREATURE_MARKSMAN,12);
	AddHeroCreatures(REBEL_HERO,CREATURE_PEASANT,80);
	AddHeroCreatures(REBEL_HERO,CREATURE_MILITIAMAN,50);
	INTERCEPT_RADIUS = 13;
end;

if GetDifficulty() == DIFFICULTY_HEROIC then
	print("Difficulty level is HEROIC");
	AddHeroCreatures(REBEL_HERO,CREATURE_PALADIN,3);
	AddHeroCreatures(REBEL_HERO,CREATURE_GRIFFIN,10);
	AddHeroCreatures(REBEL_HERO,CREATURE_MARKSMAN,15);
	AddHeroCreatures(REBEL_HERO,CREATURE_ARCHER,20);
	AddHeroCreatures(REBEL_HERO,CREATURE_PEASANT,80);
	AddHeroCreatures(REBEL_HERO,CREATURE_MILITIAMAN,100);
	INTERCEPT_RADIUS = 15;
end;

-------------------------------------------


function len( x, y )
local l = sqrt( x * x + y * y );
	return l;
end;

function WaitDay()
	local Xday;
	Xday = GetDate(DAY) + 1;
	while Xday ~= GetDate(DAY) do
		sleep();
	end;
end;

function dungeon_town_captured()
	print("Thread dungeon_town_captured has been started...");
	while 1 do
		sleep(10);
		if GetObjectOwner("dungeon_town") == PLAYER_1 or IsObjectExists("hidr") == nil then
			print("Almegir has got his overmind back and will strike now!");
			EnableHeroAI("Almegir",1);
			SetRegionBlocked("almegir",nil,3);
			SetAIHeroAttractor("dungeon_town","Almegir",2);
			break;
		end;
	end;
end;


function InterceptHero()
	print("Hero ",WIZARD_1_NAME," want to intercept Berein! Time to make leggs!!!");
	MoveHeroRealTime(WIZARD_1_NAME,56,35,GROUND);
	stop = 1;
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"intercept",nil);
end;


function AroundHero(patrol_name)
	print(patrol_name, ". Thread AroundHero has been started...");
	while 1 do
		sleep(10);
		if IsHeroAlive(patrol_name) == nil then
			print(patrol_name, " is dead. Thread AroundHero(",patrol_name,") has been terminated");
			return
		end;
		local Player_x,Player_y, Player_z = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(patrol_name);
		if len(Player_x - cx,Player_y - cy) < INTERCEPT_RADIUS and IsObjectVisible(PLAYER_2,OUR_HERO) and Player_z == cl then
			print("Our hero is close to the enemy");
			if GetObjectiveState("avoid_wizard1") ~= OBJECTIVE_ACTIVE then
				SetObjectiveState("avoid_wizard1",OBJECTIVE_ACTIVE);
			end;
		--print("MP to Our Hero = ",CalcHeroMoveCost(patrol_name,Player_x,Player_y));
			stop = 1;
			startThread(FollowHero1,patrol_name);
			break;
		end;
	end;
end;


function Patrol2()
	if IsHeroAlive(WIZARD_1_NAME) == nil
	then
		print(WIZARD_1_NAME, "is dead. Thread Patrol2 has been terminated");
		return
	end;
	if START_INTERCEPT == 1 then
		print(WIZARD_1_NAME,". Difficulty level is hard or heroic. Intercepting algorithm has been started...");
		startThread(AroundHero,WIZARD_1_NAME);
	end;
	stop = 0;
	print("Thread Patrol2 has been started");
	local cx,cy,cl;
	local j = coords2.n;
	EnableHeroAI(WIZARD_1_NAME,nil);
	SetObjectEnabled(WIZARD_1_NAME,nil);
	sleep();
while stop ~= 1 do	
	for i=1, coords2.n do
		local Player_x,Player_y = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(WIZARD_1_NAME);
		if stop == 1 then
			print("Thread patrol has been terminated...");
			return
		end;
		MoveHeroRealTime(WIZARD_1_NAME,coords2[i][1],coords2[i][2],GROUND);
		while len( cx-coords2[i][1],cy-coords2[i][2] ) > 4 do
			if IsHeroAlive(WIZARD_1_NAME) == not nil then
				cx,cy,cl = GetObjectPos(WIZARD_1_NAME);
				sleep(10);
			else
				print(WIZARD_1_NAME," is dead. Thread Patrol2 has been terminated...");
				return
			end;
		end;
		print("Wait day");
		WaitDay();
	end;
	for j=coords2.n, 1,-1 do
		local Player_x,Player_y = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(WIZARD_1_NAME);
		if stop == 1 then
			print("Thread patrol has been terminated...");
			return
		end;
		MoveHeroRealTime(WIZARD_1_NAME,coords2[j][1],coords2[j][2],GROUND);
		while len( cx-coords2[j][1],cy-coords2[j][2] ) > 4 do
			if IsHeroAlive(WIZARD_1_NAME) == not nil then
				cx,cy,cl = GetObjectPos(WIZARD_1_NAME);
				sleep(10);
			else
				print(WIZARD_1_NAME," is dead. Thread Patrol2 has been terminated...");
				return	
			end;
		end;
		WaitDay();
	end;
	sleep();
end;
end;

function FollowHero1(follow1_patrol_name)
	print("Thread FollowHero1 for hero ",follow1_patrol_name, " has been started...");
	local INx = GetObjectPos(follow1_patrol_name);
	local Xday = GetDate(DAY);
	local currentday = GetDate(DAY);
	while currentday <= Xday+1 do
		sleep(20);
		currentday = GetDate(DAY);
		if IsHeroAlive(follow1_patrol_name) == nil then
				print(follow1_patrol_name, " is dead. Thread FollowHero1(",follow1_patrol_name,") has been terminated");
				return
		end;
		local Player_x,Player_y,Player_z = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(follow1_patrol_name);
		if Player_z == cl then
			Total = GetHeroStat(follow1_patrol_name,STAT_MOVE_POINTS);
			MpToBerein = CalcHeroMoveCost(follow1_patrol_name,Player_x,Player_y);
			print("Total = ",Total," MpToBerein = ", MpToBerein,". ENEMY_STOPPING_RADIUS = ",ENEMY_STOPPING_RADIUS*75);
			if Total > MpToBerein+225 then
				ChangeHeroStat(follow1_patrol_name,STAT_MOVE_POINTS,-Total);
				sleep(2);
				print("Current ", follow1_patrol_name,"  MP = ",GetHeroStat(follow1_patrol_name,STAT_MOVE_POINTS));
				ChangeHeroStat(follow1_patrol_name,STAT_MOVE_POINTS,(MpToBerein - ENEMY_STOPPING_RADIUS*75));
				sleep(2);
				print("Current ", follow1_patrol_name,"  MP = ",GetHeroStat(follow1_patrol_name,STAT_MOVE_POINTS));
			end;
			if len(Player_x - cx,Player_y - cy) < INTERCEPT_RADIUS then
				print("len = ",len(Player_x - cx,Player_y - cy));
				local Player_x,Player_y = GetObjectPos(OUR_HERO);
				local cx,cy,cl = GetObjectPos(follow1_patrol_name);
				if INx ~= cx then
					print("Current coords is not equal initial coords");
					break;
				end;
				if IsHeroAlive(follow1_patrol_name) == nil
				then
					print(follow1_patrol_name, " is dead. Thread AroundHero(",follow1_patrol_name,") has been terminated");
					return
				end;
				MoveHeroRealTime(follow1_patrol_name,Player_x,Player_y,GROUND);
			else
				print("Our Hero has avoid foolish wizard ",follow1_patrol_name,"!");
				SetObjectiveState("avoid_wizard1",OBJECTIVE_COMPLETED);
				stop = 0;
				startThread(Patrol2);
				return
			end;
		else
			print("Our and enemy hero are on other floors");	
			print("Our Hero has avoid foolish wizard ",follow1_patrol_name,"!");
			SetObjectiveState("avoid_wizard1",OBJECTIVE_COMPLETED);
			stop = 0;
			startThread(Patrol2);
			return
		end;
	end;
	startThread(FollowHero,follow1_patrol_name)
end;


function FollowHero(follow_patrol_name)
	print("Thread FollowHero has been started...");
	while 1 do
		sleep(10);
		if IsHeroAlive(follow_patrol_name) == nil
		then
			print(follow_patrol_name, " is dead. Thread FollowHero1(",follow_patrol_name,") has been terminated");
			return
		end;
		local Player_x,Player_y,Player_z = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(follow_patrol_name);
		if Player_z == cl then
			if len(Player_x - cx,Player_y - cy) < INTERCEPT_RADIUS then
				print("len = ",len(Player_x - cx,Player_y - cy));
				--WaitDay();
				local Player_x,Player_y = GetObjectPos(OUR_HERO);
				local cx,cy,cl = GetObjectPos(follow_patrol_name);
				MoveHeroRealTime(follow_patrol_name,Player_x,Player_y,GROUND);
				--or CalcHeroMoveCost("Tan",Player_x,Player_y) ~= -1
			else
				print("len = ",len(Player_x - cx,Player_y - cy));
				print("Our Hero has avoid foolish wizard ",follow_patrol_name,"!");
				SetObjectiveState("avoid_wizard1",OBJECTIVE_COMPLETED);
				stop = 0;
				startThread(Patrol2);
				break;
			end;
		else
		print("Our and enemy hero are on other floors");
		sleep(15);
		end;
	end;
end;


function AroundHero1_new(patrol_name)
	print("Thread AroundHero1 has been started...");
	while 1 do
		sleep(10);
		if IsHeroAlive(patrol_name) == nil then
			print(patrol_name, " is dead. Thread AroundHero1(",patrol_name,") has been terminated");
			return
		end;
		local Player_x,Player_y = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(patrol_name);
		
		if CalcHeroMoveCost(patrol_name,Player_x,Player_y) < GetHeroStat(patrol_name,STAT_MOVE_POINTS)
				and IsObjectVisible(PLAYER_2,OUR_HERO)
				and CalcHeroMoveCost(patrol_name,Player_x,Player_y) ~= -1
			then
			print("Our hero is close to the enemy");
			if GetObjectiveState("prim2") ~= OBJECTIVE_ACTIVE then
				SetObjectiveState("prim2",OBJECTIVE_ACTIVE);
			end;
		--print("MP to Our Hero = ",CalcHeroMoveCost(patrol_name,Player_x,Player_y));
			stop_ = 1;
			startThread(FollowHero01,patrol_name);
			--startThread(FollowHero01_new,patrol_name);
			break;
		end;
	end;
end;

function AroundHero1(patrol_name)
	print(patrol_name, ". Thread AroundHero1 has been started...");
	while 1 do
		sleep(10);
		if IsHeroAlive(patrol_name) == nil then
			print(patrol_name, " is dead. Thread AroundHero1(",patrol_name,") has been terminated");
			return
		end;
		local Player_x,Player_y,Player_z = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(patrol_name);
		if len(Player_x - cx,Player_y - cy) < INTERCEPT_RADIUS and IsObjectVisible(PLAYER_2,OUR_HERO) and Player_z == cl then
			print("Our hero is close to the enemy");
			if GetObjectiveState("avoid_wizard2") ~= OBJECTIVE_ACTIVE then
				SetObjectiveState("avoid_wizard2",OBJECTIVE_ACTIVE);
			end;
		--print("MP to Our Hero = ",CalcHeroMoveCost(patrol_name,Player_x,Player_y));
			stop_ = 1;
			startThread(FollowHero01,patrol_name);
			--startThread(FollowHero01_new,patrol_name);
			break;
		end;
	end;
end;

function Patrol1()
	if IsHeroAlive(WIZARD_2_NAME) == nil
	then
		print(WIZARD_2_NAME, "is dead. Thread Patrol2 has been terminated");
		return
	end;
	if START_INTERCEPT == 1 then
		print(WIZARD_2_NAME,". Difficulty level is hard or heroic. Intercepting algorithm has been started...");
		startThread(AroundHero1,WIZARD_2_NAME);
	end;
	stop_ = 0;
	print("Thread Patrol1 has been started");
	local cx,cy,cl;
	local j = coords2.n;
	EnableHeroAI(WIZARD_2_NAME,nil);
	SetObjectEnabled(WIZARD_2_NAME,nil);
	sleep();
while stop_ ~= 1 do
	for i=1, coords.n do
		if stop_ == 1 then
			print("Thread patrol has been terminated...");
			return
		end;
		local Player_x,Player_y = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(WIZARD_2_NAME);
		MoveHeroRealTime(WIZARD_2_NAME,coords[i][1],coords[i][2],GROUND);
		while len( cx-coords[i][1],cy-coords[i][2] ) > 4 do
			if IsHeroAlive(WIZARD_2_NAME) == not nil then
				cx,cy,cl = GetObjectPos(WIZARD_2_NAME);
				sleep(10);
			else
				print(WIZARD_2_NAME, " is dead. Thread Patrol1 has been terminated...");
				return
			end;	
		end;
		print("Wait day");
		WaitDay();
	end;
	for j=coords.n, 1,-1 do
		local Player_x,Player_y = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(WIZARD_2_NAME);
		if stop_ == 1 then
			print("Thread patrol has been terminated...");
			return
		end;
		MoveHeroRealTime(WIZARD_2_NAME,coords[j][1],coords[j][2],GROUND);
		while len( cx-coords[j][1],cy-coords[j][2] ) > 4 do
			if IsHeroAlive(WIZARD_2_NAME) == not nil then
				cx,cy,cl = GetObjectPos(WIZARD_2_NAME);
				sleep(10);
			else
				print(WIZARD_2_NAME, " is dead. Thread Patrol1 has been terminated...");
				return
			end;
		end;
		WaitDay();
	end;
	sleep();
end;
end;

function FollowHero01(follow1_patrol_name)
	print("Thread FollowHero01 for hero ",follow1_patrol_name," has been started...");
	local INx = GetObjectPos(follow1_patrol_name);
	local Xday = GetDate(DAY);
	local currentday = GetDate(DAY);
	while currentday <= Xday+1 do
		sleep(1);
		currentday = GetDate(DAY);
		local Player_x,Player_y,Player_z = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(follow1_patrol_name);
		if Player_z == cl then
			Total = GetHeroStat(follow1_patrol_name,STAT_MOVE_POINTS);
			MpToBerein = CalcHeroMoveCost(follow1_patrol_name,Player_x,Player_y);
			print("Total = ",Total," MpToBerein = ", MpToBerein,". ENEMY_STOPPING_RADIUS = ",ENEMY_STOPPING_RADIUS*75);
			if Total > MpToBerein+75*(DETECTING_RADIUS+1) then
				ChangeHeroStat(follow1_patrol_name,STAT_MOVE_POINTS,-Total);
				sleep(2);
				print("Current ", follow1_patrol_name,"  MP = ",GetHeroStat(follow1_patrol_name,STAT_MOVE_POINTS));
				ChangeHeroStat(follow1_patrol_name,STAT_MOVE_POINTS,(MpToBerein - ENEMY_STOPPING_RADIUS*75));
				sleep(2);
				print("Current ", follow1_patrol_name,"  MP = ",GetHeroStat(follow1_patrol_name,STAT_MOVE_POINTS));
			end;
			if len(Player_x - cx,Player_y - cy) < INTERCEPT_RADIUS then
				print("len = ",len(Player_x - cx,Player_y - cy));
				local Player_x,Player_y = GetObjectPos(OUR_HERO);
				local cx,cy,cl = GetObjectPos(follow1_patrol_name);
				if INx ~= cx then
					print("Current coords is not equal initial coords");
					break;
				end;
				MoveHeroRealTime(follow1_patrol_name,Player_x,Player_y,GROUND);
				else
					print("Our Hero has avoid foolish wizard ",follow1_patrol_name,"!");
					SetObjectiveState("avoid_wizard2",OBJECTIVE_COMPLETED);
					stop_ = 0;
					startThread(Patrol1);
					return
			end;
		else
			print("Our and enemy hero are on other floors");
			print("Our Hero has avoid foolish wizard ",follow1_patrol_name,"!");
			SetObjectiveState("avoid_wizard2",OBJECTIVE_COMPLETED);
			stop_ = 0;
			startThread(Patrol1);
			return
		end;
	end;
	startThread(FollowHero0,follow1_patrol_name)
end;

function FollowHero01_new(follow1_patrol_name)
	print("Thread FollowHero1 has been started...");
	local INx = GetObjectPos(follow1_patrol_name);
	local Xday = GetDate(DAY);
	local currentday = GetDate(DAY);
	while currentday <= Xday+1 do
		sleep(20);
		currentday = GetDate(DAY);
		local Player_x,Player_y,Player_z = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(follow1_patrol_name);
		if Player_z == cl then
			Total = GetHeroStat(follow1_patrol_name,STAT_MOVE_POINTS);
			MpToBerein = CalcHeroMoveCost(follow1_patrol_name,Player_x,Player_y);
			print("Total = ",Total," MpToBerein = ", MpToBerein,". ENEMY_STOPPING_RADIUS = ",ENEMY_STOPPING_RADIUS*75);
			--Если слоник с запасом может добежать до Берейна, то ему кастрируют МувПоинты, чтобы не добежал
			if Total > MpToBerein+(75+DETECTING_RADIUS*3) then
				ChangeHeroStat(follow1_patrol_name,STAT_MOVE_POINTS,-Total);
				sleep(2);
				print("Current ", follow1_patrol_name,"  MP = ",GetHeroStat(follow1_patrol_name,STAT_MOVE_POINTS));
				ChangeHeroStat(follow1_patrol_name,STAT_MOVE_POINTS,(MpToBerein - ENEMY_STOPPING_RADIUS*75));
				sleep(2);
				print("Current ", follow1_patrol_name,"  MP = ",GetHeroStat(follow1_patrol_name,STAT_MOVE_POINTS));
			end;
			--Если с запасом не добегает,то просто не отдается никакая команда. Слоник тупит.
			--Слонику отдается команда - бежать к Берейну, если расстояние до него меньше некоторой части МП героя.
			if MpToBerein < Total*INTERCEPT_FACTOR then
				local Player_x,Player_y = GetObjectPos(OUR_HERO);
				local cx,cy,cl = GetObjectPos(follow1_patrol_name);
				if INx ~= cx then
					print("Current coords is not equal initial coords");
					break;
				end;
				MoveHeroRealTime(follow1_patrol_name,Player_x,Player_y,GROUND);
				else
					--Расстояние до Берейна превысило половину МП героя АИ
					print("Our Hero has avoid foolish wizard ",follow1_patrol_name,"!");
					SetObjectiveState("avoid_wizard2",OBJECTIVE_COMPLETED);
					stop_ = 0;
					startThread(Patrol1);
					return
			end;
		else
		print("Our and enemy hero are on other floors");
		sleep(15);
		end;
	end;
	--1) Настал следующий день
	--2) Герой АИ сдвинулся с места
	startThread(FollowHero0,follow1_patrol_name)
end;

function FollowHero0(follow_patrol_name)
	print("Thread FollowHero0 has been started...");
	while 1 do
		sleep(10);
		local Player_x,Player_y,Player_z = GetObjectPos(OUR_HERO);
		local cx,cy,cl = GetObjectPos(follow_patrol_name);
		if Player_z == cl then
			if len(Player_x - cx,Player_y - cy) < INTERCEPT_RADIUS then
				print("len = ",len(Player_x - cx,Player_y - cy));
				--WaitDay();
				local Player_x,Player_y = GetObjectPos(OUR_HERO);
				local cx,cy,cl = GetObjectPos(follow_patrol_name);
				MoveHeroRealTime(follow_patrol_name,Player_x,Player_y,GROUND);
				 --or CalcHeroMoveCost("Tan",Player_x,Player_y) ~= -1
			else
				print("len = ",len(Player_x - cx,Player_y - cy));
				print("Our Hero has avoid foolish wizard ",follow_patrol_name,"!");
				SetObjectiveState("avoid_wizard2",OBJECTIVE_COMPLETED);
				stop_ = 0;
				startThread(Patrol1);
				break;
			end;
		else
			print("Our and enemy hero are on other floors");
			sleep(15);
		end;
	end;
end;

function ReachSorreth()
	print("Thread Reach Sorreth has been started...");
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"townexit",nil);
	if IsObjectInRegion("Berein","townexit") == 1 then
		print("Berein reachs Sorreth");
		SetObjectiveState("prim1",OBJECTIVE_COMPLETED);
		ObjectiveExp(OUR_HERO);
		sleep(10);
		StartDialogScene("/DialogScenes/C3/M1/R1/DialogScene.xdb#xpointer(/DialogScene)");
		SetObjectiveState("prim3",OBJECTIVE_ACTIVE);
	end;
end;

function BereinAlive()
	while 1 do
		sleep(10);
		if IsHeroAlive("Berein") == nil then
			print("Berein dead, but he must live in our hearts forever...");
			Loose(0);
			break;
		end;
	end;
end;


function PlayerWin()
	while 1 do
		sleep(10);
		if (IsHeroAlive(REBEL_HERO)==nil) then
			print("You won!!!");
			SaveHeroAllSetArtifactsEquipped("Berein", "C3M1");
			if GetObjectiveState("prim2") ~= OBJECTIVE_COMPLETED then
				SetObjectiveState("prim2",OBJECTIVE_COMPLETED);
				sleep(5);
			else
				print("Objective 'Avoid enemy patrols' already completed.");
			end;
			StartDialogScene("/DialogScenes/C3/M1/D2/DialogScene.xdb#xpointer(/DialogScene)", nil, "AgreementWithNecromant");
			sleep(5);
			SetObjectiveState("prim3",OBJECTIVE_COMPLETED);
			sleep(5);
			SetObjectiveState("prim4",OBJECTIVE_COMPLETED);
			Win(0);
			break;			
		end
	end
end

function detecting1()
	print("Thread detecting 1 has been started...")
	while 1 do
		sleep(1);
		if IsHeroAlive(WIZARD_2_NAME) == nil then
			print(WIZARD_2_NAME, " is dead. Thread detecting 1  has been terminated");
			return
		end;
		local x1,y1,z1 = GetObjectPos(WIZARD_2_NAME);
		local x2,y2,z2 = GetObjectPos("Berein");
		if (len(x1-x2,y1-y2) < DETECTING_RADIUS and z1 == z2) then
			SetObjectiveState("avoid_wizard2",OBJECTIVE_FAILED);
			StartDialogScene("/DialogScenes/C3/M1/R2/DialogScene.xdb#xpointer(/DialogScene)");
			sleep(10);
			Loose(0);
			--sleep(10);
			print("table.length between our Hero and ",WIZARD_2_NAME," = ",len(x1-x2,y1-y2));
			print("Our hero has been detected...");
			break;
		end;
	end;
end;

function detecting2()
	print("Thread detecting 2 has been started...")
	while 1 do
		sleep(1);
		if IsHeroAlive(WIZARD_1_NAME) == nil then
			print(WIZARD_1_NAME, " is dead. Thread detecting2 has been terminated");
			return
		end;
		local x1,y1,z1 = GetObjectPos(WIZARD_1_NAME);
		local x2,y2,z2 = GetObjectPos("Berein");
		if (len(x1-x2,y1-y2) <= DETECTING_RADIUS and z1 == z2) then
			SetObjectiveState("prim2",OBJECTIVE_FAILED);
			StartDialogScene("/DialogScenes/C3/M1/R2/DialogScene.xdb#xpointer(/DialogScene)");
			sleep(10);
			Loose(0);
			print("table.length between our Hero and ",WIZARD_1_NAME," = ",len(x1-x2,y1-y2));
			print("Our hero has been detected...");
			break;
		end;
	end;
end;

function found_liches()
	print("Player has found liches!!!");
	MessageBox("/Maps/Scenario/C3M1/LichesFinding.txt");
	AddHeroCreatures("Berein",CREATURE_LICH,4);
	Trigger(REGION_ENTER_AND_STOP_TRIGGER,"liches",nil);
end;

function sunduk()
	StartCombat("Berein",nil,CREATURE_SCOUT,32);
end;

function hydra()
	print("Thread Hydra has been started...");
	while 1 do
		sleep(10);
		if (Exists("hidraliska") == nil) then
			print("Berein has got 5 vampires!");
			AddHeroCreatures("Berein",CREATURE_VAMPIRE,5);
			MessageBox("/Maps/Scenario/C3M1/VampitesFinding.txt");
			break;
		end;
	end;
end;

function enable_dungeon()
	print("Thread enable_dungeon has been started...");
	while 1 do
		sleep(10);
		if IsObjectExists("scout") == nil then
			print("Dalom AI has been enabled...");
			EnableHeroAI("Dalom",1);
			startThread(SlonikGoToDungeon);
			break;
		end;
	end;
end;

function SlonikGoToDungeon()
	print(WIZARD_1_NAME, " and his bravery slonik want to enter dungeon");
	local Day = GetDate(DAY);
	while 1 do
		sleep(10);
		if GetDate(DAY) == Day+4 then
			SetRegionBlocked("intercept",1,2);
			print(WIZARD_1_NAME, " goes to the Dungeon");
			EnableHeroAI(WIZARD_1_NAME,1);
			SetObjectEnabled(WIZARD_1_NAME,1);
			SetAIHeroAttractor("mine",WIZARD_1_NAME,2);
			startThread(CaptureGortadan);
			break;
		end;
	end;
end;

function CaptureGortadan()
	print("Thread CaptureGortadan has been started...");
	while 1 do
		sleep(10);
		if GetObjectOwner("mine") == PLAYER_2 then
			print("Slonik wants to capture Gortadan");
			SetAIHeroAttractor("mine",WIZARD_1_NAME,0);
			SetAIHeroAttractor("dungeon_town",WIZARD_1_NAME,2);
			break;
		end;
	end;
end;


function SlonikDeath(WizardName)
	print("Thread SlonikDeath for ",WizardName," has been started");
	while 1 do
		sleep(10);
		if IsHeroAlive(WizardName) == nil then
			stop = 1;
			stop_ = 1;
			print("Glorious ", WizardName, " is dead!");
			break;
		end;
	end;
end;

function ObjectiveExp(HeroName)
	local ToLevel = GetExpToLevel(GetHeroLevel(HeroName)+1);
	local delta = (ToLevel - GetHeroStat(HeroName, STAT_EXPERIENCE)) / 2;
	ChangeHeroStat(HeroName, STAT_EXPERIENCE,delta);
	print("Now ",HeroName, " has ", GetHeroStat(HeroName, STAT_EXPERIENCE)," exp");
end;

function AvoidEnemyComplete()
	print("Thread AvoidEnemyComplete has been started...");
	while IsHeroAlive(WIZARD_1_NAME) ~= nil or IsHeroAlive(WIZARD_2_NAME) ~= nil do
		sleep(15);
	end;
	print("Enemy patrols are dead. Objective Complete.");
	SetObjectiveState("prim2",OBJECTIVE_COMPLETED);
end;


function GetExpToLevel( j )
	local sum;
	if j <= 12 then
		print("N less than 12");
		local ExpArray = {0,1000,2000,3200,4600,6200,8000,10000,12200,14700,17500,20600};
			  ExpArray.n = 12;
		sum = ExpArray[j];
	else
		sum = 20600;
		local q = 3100;
		if j < 25 then
			print("N less than 25");
			for i=1,j-12 do
				q = q*1.2;
				sum = sum + q;
			end;
		else
			print("N more than 25");
			for i=1,12 do
				q = q*1.2;
				sum = sum + q;
			end;
			for i=1,j-24 do
				q = q*((j-13)/10);
				sum = sum + q;
			end;
		end;
	end;
	print("Hero need ", sum, " experience to gain level ",j);
	return sum;
end;

H55_CamFixTooManySkills(PLAYER_4,"Godric");
startThread(SlonikDeath,WIZARD_1_NAME);
startThread(SlonikDeath,WIZARD_2_NAME);
startThread(enable_dungeon);
startThread(dungeon_town_captured);
startThread(hydra);
startThread(Patrol1);
startThread(Patrol2);
Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"townexit","ReachSorreth");
startThread(BereinAlive);
startThread(detecting1);
startThread(detecting2);
startThread(PlayerWin);
startThread(AvoidEnemyComplete);
Trigger(REGION_ENTER_AND_STOP_TRIGGER,"liches","found_liches");
--Trigger(OBJECT_TOUCH_TRIGGER,"sunduk","sunduk")
Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"intercept","InterceptHero");
--Trigger(NEW_DAY_TRIGGER,patrol2);