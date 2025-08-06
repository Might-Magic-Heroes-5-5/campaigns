H55_PlayerStatus = {0,1,1,1,1,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_DWARVEN_MITHRAL_CUIRASS,
ARTIFACT_DWARVEN_MITHRAL_GREAVES,
ARTIFACT_DWARVEN_MITHRAL_HELMET,
ARTIFACT_DWARVEN_MITHRAL_SHIELD

};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C1M4");
	LoadHeroAllSetArtifacts( "Freyda" , "A1C1M3" );
end;

startThread(H55_InitSetArtifacts);

PlayerHero1 = "Freyda"
EnemyHero1 = "Laszlo"
diff = 0
w_paw3 = 0

SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
SetObjectiveState("sobj4", OBJECTIVE_ACTIVE);
SetRegionBlocked ("Block" , 1 , PLAYER_2); -- Garrison block for Rebels
SetRegionBlocked ("Block" , 1 , PLAYER_4); -- Garrison block for Laszlo

---------------- Difficulty settings -------------------

if GetDifficulty() == DIFFICULTY_EASY then
	diff = 1;
    print ("easy");
end;

if GetDifficulty() == DIFFICULTY_NORMAL then
	diff = 1;
    print ("normal");
end;

if GetDifficulty() == DIFFICULTY_HARD then
	diff = 2;
    print ("Hard");
end;

if GetDifficulty() == DIFFICULTY_HEROIC then
	diff = 3;
    print ("Impossible");
end;

-------- Objects disactivation -----------------------

SetObjectEnabled("garrison", nil);
--SetObjectEnabled("torhrall", nil);
SetObjectEnabled("karla1", nil);
SetObjectEnabled("karla2", nil);
SetObjectEnabled("karla3", nil);
SetObjectEnabled("secret_way", nil);
SetObjectEnabled("secret_way1", nil);
SetObjectEnabled("portal", nil);
SetObjectEnabled("hut", nil);
SetObjectEnabled("prison", nil);
SetObjectEnabled("tent", nil);
SetObjectEnabled("guard", nil);

Trigger (OBJECT_TOUCH_TRIGGER, "portal", "isntworkingyet");

function isntworkingyet()
	ShowFlyingSign("/Maps/Scenario/A1C1M4/portal.txt", "portal", 1, 5);
end;

Trigger (OBJECT_TOUCH_TRIGGER, "secret_way", "isntworkingyet1");
Trigger (OBJECT_TOUCH_TRIGGER, "secret_way1", "isntworkingyet1");

function isntworkingyet1()
	ShowFlyingSign("/Maps/Scenario/A1C1M4/mine.txt", "secret_way", 1, 5);
	ShowFlyingSign("/Maps/Scenario/A1C1M4/mine.txt", "secret_way1", 1, 5);
end;

-------objective 1--------

function garrison1() 
	StartDialogScene("/DialogScenes/A1C1/M4/S1/DialogScene.xdb#xpointer(/DialogScene)");
	Trigger (OBJECT_TOUCH_TRIGGER, "garrison", "garrison2");
	SetObjectiveState("obj1", OBJECTIVE_COMPLETED);
	sleep ( 5 );
	SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
end;

-------objective 2--------

function garrison2(hero)
if hero == "Freyda" then
	red_haven = 0;
	s_heaven = 0
	sleep (2);
	for hero_creatures = 106,112 do -- Red troops check
		if GetHeroCreatures(PlayerHero1, hero_creatures) > 0 then
			print("red haven 1")
			red_haven = 1;
		end;
	end;
	if red_haven > 0 then
		MessageBox("/Maps/Scenario/A1C1M4/garrison_answer.txt");
	end;
	too_many = 0;
	sleep (2);-- Freyda's army too strong
	if red_haven == 0 then
		print("red haven 0")
		if GetHeroCreatures(PlayerHero1, CREATURE_MILITIAMAN) > 100 then
			too_many = 1;
		end;
		if GetHeroCreatures(PlayerHero1, CREATURE_MARKSMAN ) > 80 then
			too_many = 1;
		end;
		if GetHeroCreatures(PlayerHero1, CREATURE_SWORDSMAN ) > 50 then
			too_many = 1;
		end;
		if GetHeroCreatures(PlayerHero1, CREATURE_ROYAL_GRIFFIN ) > 30 then
			too_many = 1;
		end;
		if GetHeroCreatures(PlayerHero1, CREATURE_CLERIC ) > 15 then
			too_many = 1;
		end;
		if GetHeroCreatures(PlayerHero1, CREATURE_PALADIN ) > 5 then
			too_many = 1;
		end;
		if too_many == 1 then
			MessageBox("/Maps/Scenario/A1C1M4/garrison_answer3.txt");
		end;
		if GetHeroCreatures(PlayerHero1, 1) > 0 then
			s_heaven = 1;
		elseif GetHeroCreatures(PlayerHero1, 3) > 0 then
			s_heaven = 1;
		elseif GetHeroCreatures(PlayerHero1, 5) > 0 then
			s_heaven = 1;
		elseif GetHeroCreatures(PlayerHero1, 7) > 0 then
			s_heaven = 1;
		elseif GetHeroCreatures(PlayerHero1, 9) > 0 then
			s_heaven = 1;
		elseif GetHeroCreatures(PlayerHero1, 11) > 0 then
			s_heaven = 1;
		end;
		sleep ( 3 );
		if s_heaven == 1 then
			MessageBox("/Maps/Scenario/A1C1M4/wrong_creature.txt");
		end;
		sleep ( 3 );
		resource = 0;
		sleep (2); -- Resource requirements check
		if GetPlayerResource(PLAYER_1, CRYSTAL) < 15 then
			resource = 1;
		end;
		if GetPlayerResource(PLAYER_1, SULFUR) < 15 then
			resource = 1;
		end;
		if GetPlayerResource(PLAYER_1, GEM) < 10 then
			resource = 1;
		end;
		if GetPlayerResource(PLAYER_1, GOLD) < 15000 then
			resource = 1;
		end;
		if resource == 1 then
			MessageBox("/Maps/Scenario/A1C1M4/garrison_answer4.txt");
		end;
		sum = resource + too_many + s_heaven; -- Resource requirements check (completed)
		if sum == 0 then
			print("requirements completed");
			SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
			SetPlayerResource(PLAYER_1, CRYSTAL, GetPlayerResource(PLAYER_1, CRYSTAL) - 15);
			SetPlayerResource(PLAYER_1, SULFUR, GetPlayerResource(PLAYER_1, SULFUR) - 15);
			SetPlayerResource(PLAYER_1, GEM, GetPlayerResource(PLAYER_1, GEM) - 10);
			SetPlayerResource(PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) - 15000);
			sleep ( 3 );
			SetObjectiveState("obj3", OBJECTIVE_ACTIVE);
			Trigger(REGION_ENTER_AND_STOP_TRIGGER , "meet" ,"atwar");
			Trigger (OBJECT_TOUCH_TRIGGER, "garrison", "question");
			print("garrison trigger is placed");
			question(hero);
		end;
	end;
end;
end;

function question(hero)
	if hero == "Freyda" then
		QuestionBox("/Maps/Scenario/A1C1M4/questionbox_travel.txt", "travel");
	end;
end;

function travel()	
	red_haven = 0;
	too_many = 0;
	s_heaven = 0;
	sleep (2);
	for hero_creatures = 106,112 do -- Red troops check
		if GetHeroCreatures(PlayerHero1, hero_creatures) > 0 then
			red_haven = 1;
		end;
	end;
	if red_haven > 0 then
		MessageBox("/Maps/Scenario/A1C1M4/garrison_answer.txt");
	end;
	if GetHeroCreatures(PlayerHero1, CREATURE_MILITIAMAN) > 100 then
		too_many = 1;
	end;
	if GetHeroCreatures(PlayerHero1, CREATURE_MARKSMAN ) > 80 then
		too_many = 1;
	end;
	if GetHeroCreatures(PlayerHero1, CREATURE_SWORDSMAN ) > 50 then
		too_many = 1;
	end;
	if GetHeroCreatures(PlayerHero1, CREATURE_ROYAL_GRIFFIN ) > 30 then
		too_many = 1;
	end;
	if GetHeroCreatures(PlayerHero1, CREATURE_CLERIC ) > 15 then
		too_many = 1;
	end;
	if GetHeroCreatures(PlayerHero1, CREATURE_PALADIN ) > 5 then
		too_many = 1;
	end;
	if too_many == 1 then
		MessageBox("/Maps/Scenario/A1C1M4/garrison_answer3.txt");
	end;
	if GetHeroCreatures(PlayerHero1, 1) > 0 then
		s_heaven = 1;
	elseif GetHeroCreatures(PlayerHero1, 3) > 0 then
		s_heaven = 1;
	elseif GetHeroCreatures(PlayerHero1, 5) > 0 then
		s_heaven = 1;
	elseif GetHeroCreatures(PlayerHero1, 7) > 0 then
		s_heaven = 1;
	elseif GetHeroCreatures(PlayerHero1, 9) > 0 then
		s_heaven = 1;
	elseif GetHeroCreatures(PlayerHero1, 11) > 0 then
		s_heaven = 1;
	end;
	sleep ( 3 );
	if s_heaven == 1 then
		MessageBox("/Maps/Scenario/A1C1M4/wrong_creature.txt");
	end;
	sleep ( 3 );
	if 	red_haven == 0 and too_many == 0 and s_heaven == 0 then
		print("question box check completed, red haven is 0");
		SetObjectPosition("Freyda", 46, 45, GROUND);
		print("teleporting Freyda to 46, 45");
		Trigger (OBJECT_TOUCH_TRIGGER, "garrison", nil);
	end;
end;

-------objective 3--------

function atwar()
	Trigger(REGION_ENTER_AND_STOP_TRIGGER , "meet" ,nil);
	sleep( 3 );
	BlockGame();
	DeployReserveHero(EnemyHero1, RegionToPoint('Laszlo_deploy'));
	sleep ( 1 );
	--EnableHeroAI(EnemyHero1, nil); --H55 fix
	MoveCamera(45, 36, GROUND, 50, 3.14/3, 0, 1, 1, 1);
	while 1 do
		ChangeHeroStat(EnemyHero1, STAT_MOVE_POINTS, 50000);
		sleep ( 1 );
		MoveHeroRealTime(EnemyHero1, 45 , 42);
		x,y = GetObjectPosition(EnemyHero1);
		sleep( 1 );
		if x == 45 and y == 42 then
			--EnableHeroAI(EnemyHero1, not nil); --H55 fix
			sleep( 1 );
			dwarftown_obj();
			sleep( 1 );
			UnblockGame();
			break;
		end;
	sleep( 2 );
	end;
end;	

function dwarftown_obj()
	StartDialogScene("/DialogScenes/A1C1/M4/S2/DialogScene.xdb#xpointer(/DialogScene)", "dwarftown_obj1", "autosave");
end;

function dwarftown_obj1()
	SetObjectiveState("obj3", OBJECTIVE_COMPLETED);
	sleep (1);
	SetObjectiveState("obj5", OBJECTIVE_ACTIVE);
	ChangeAllOwners();
    if IsObjectExists("d1") == 1 then
        RemoveObject("d1");
    end;
    if IsObjectExists("d2") == 1 then
        RemoveObject("d2");
    end;
    if IsObjectExists("d3") == 1 then
        RemoveObject("d3");
    end
	SetPlayerResource(PLAYER_1, WOOD, 0);
	SetPlayerResource(PLAYER_1, ORE, 0);
	SetPlayerResource(PLAYER_1, GEM, 0);
	SetPlayerResource(PLAYER_1, SULFUR, 0);
	SetPlayerResource(PLAYER_1, CRYSTAL, 0);
	SetPlayerResource(PLAYER_1, MERCURY, 0);
	SetPlayerResource(PLAYER_1, GOLD, 0);
	sleep( 1 );
	OpenCircleFog(75, 97, GROUND, 8, PLAYER_1);
	sleep( 2 );
	OpenCircleFog(131, 75, GROUND, 8, PLAYER_1);
	stout();
	thane();
	startThread (despawn);
	Trigger (OBJECT_TOUCH_TRIGGER, "portal", nil);
	print( "" )
end;

---------------Objects owner changes-----------------

function ChangeAllOwners()
	print ( "ChangeAllOwners() started" );
	SetObjectEnabled("portal", not nil);
	mines = GetObjectNamesByType( "BUILDING" );
	dwellings = GetObjectNamesByType( "DWELLING" );
	towns = GetObjectNamesByType( "TOWN" );
	for i, mine in mines do
		if GetObjectOwner( mine ) == PLAYER_1 then
			SetObjectOwner( mine, PLAYER_4 );
		end;
		if GetObjectOwner( mine ) == PLAYER_3 then
			SetObjectOwner( mine, PLAYER_5 );
		end;
	end;
	for i, mine in dwellings do
		if GetObjectOwner( mine ) == PLAYER_1 then
			SetObjectOwner( mine, PLAYER_4 );
		end;
		if GetObjectOwner( mine ) == PLAYER_3 then
			SetObjectOwner( mine, PLAYER_5 );
		end;
	end;
	for i, mine in towns do
		if GetObjectOwner( mine ) == PLAYER_1 then
			SetObjectOwner( mine, PLAYER_4 );
		end;
		if GetObjectOwner( mine ) == PLAYER_3 then
			SetObjectOwner( mine, PLAYER_5 );
		end;
	end;
	adding_creatures();
	SetObjectOwner( "garrison", PLAYER_5 );
	SetObjectOwner( "garrison1", PLAYER_5 );
	Trigger (REGION_ENTER_AND_STOP_TRIGGER, "exit", "escape");
	startThread (rebelcheck);
end;

function adding_creatures()
	AddObjectCreatures("torhrall", 93, 534);
	AddObjectCreatures("torhrall", 95, 357);
	AddObjectCreatures("torhrall", 97, 253);
	AddObjectCreatures("torhrall", 99, 157);
	AddObjectCreatures("torhrall", 101, 112);
	AddObjectCreatures("torhrall", 103, 86);
	AddObjectCreatures("torhrall", 105, 46);
end;
    

function rebelcheck()
	while 1 do
		if GetObjectiveState("obj3") == OBJECTIVE_COMPLETED then
			if GetObjectiveState("sobj4") == OBJECTIVE_ACTIVE then
				SetObjectiveState("sobj4", OBJECTIVE_FAILED);
				break;
			end;
		end;
	sleep(3);
	end
end

-------Secondary objective 1--------

function hut_quest(hero)
	if GetObjectiveState("sobj1") == OBJECTIVE_UNKNOWN then
		ShowFlyingSign("/Maps/Scenario/A1C1M4/hut.txt", "hut", 1, 5);
		SetObjectiveState("sobj1", OBJECTIVE_ACTIVE);
		Trigger (OBJECT_TOUCH_TRIGGER, "hut", "hut_quest1");
		OpenCircleFog(32, 120, GROUND, 3, PLAYER_1);
	end;
	sleep(1);
	if HasArtefact(hero, ARTIFACT_DWARVEN_MITHRAL_GREAVES) == not nil then
		QuestionBox("/Maps/Scenario/A1C1M4/questionbox_hut.txt", "ok");
	end;
	sleep(1);
end;

function ok()
	x, y, level = GetObjectPosition(PlayerHero1)
	--SetObjectEnabled("hut", not nil);
	--print("Hut of Magi enabled");
	RemoveArtefact("Freyda", ARTIFACT_DWARVEN_MITHRAL_GREAVES);
	--ShowFlyingSign("/Maps/Scenario/A1C1M4/hut1.txt", "hut", 1, 5);
	SetObjectiveState("sobj1", OBJECTIVE_COMPLETED);
	MarkObjectAsVisited("hut", PlayerHero1);
	MoveCamera(32, 88, GROUND, 50, 3.14/2, 4.71, 1, 0, 1);
	OpenCircleFog(32, 88, GROUND, 7, PLAYER_1);
	sleep( 15 );
	MoveCamera(9, 74, GROUND, 50, 3.14/2, 0, 1, 0, 1);
	OpenCircleFog(9, 74, GROUND, 7, PLAYER_1);
	sleep( 15 );
	MoveCamera(31, 60, GROUND, 50, 3.14/2, 0, 1, 1, 1);
	OpenCircleFog(31, 60, GROUND, 7, PLAYER_1);
	sleep( 15 );
	MoveCamera(80, 59, GROUND, 50, 3.14/2, 0, 1, 1, 1);
	OpenCircleFog(80, 59, GROUND, 7, PLAYER_1);
	sleep( 15 );
	MoveCamera(101, 72, GROUND, 50, 3.14/2, 0, 1, 1, 1);
	OpenCircleFog(101, 72, GROUND, 7, PLAYER_1);
	sleep( 15 );
	MoveCamera(127, 52, GROUND, 50, 3.14/2, 0, 1, 1, 1);
	OpenCircleFog(127, 52, GROUND, 7, PLAYER_1);
	sleep( 15 );
	MoveCamera(x, y, level, 50, 3.14/2, 0, 1, 1, 1);
	Trigger (OBJECT_TOUCH_TRIGGER, "hut", nil);	
end;	
	
function hut_quest1(hero)
	if HasArtefact(hero, ARTIFACT_DWARVEN_MITHRAL_GREAVES) == not nil then
		QuestionBox("/Maps/Scenario/A1C1M4/questionbox_hut.txt", "ok");
	end;
end;

function hut_fail()
	while 1 do
		if GetObjectiveState("sobj5") == OBJECTIVE_COMPLETED then
			Trigger (OBJECT_TOUCH_TRIGGER, "hut", "h_message");
			break;
		end;
	sleep( 3 );
	end;
end;

function h_message()
	MessageBox("/Maps/Scenario/A1C1M4/h_message.txt");
end;

-------Secondary objective 4--------

function rebels()
	while 1 do
		local exp = GetHeroStat(PlayerHero1, STAT_EXPERIENCE);
		local gd = GetPlayerResource(PLAYER_1, GOLD)	
		if GetObjectOwner("sd") == PLAYER_1 and table.length(GetPlayerHeroes(PLAYER_2)) == 0 and GetObjectOwner("rtown") == PLAYER_1 then
			SetObjectiveState("sobj4", OBJECTIVE_COMPLETED);
			if GetDifficulty() == DIFFICULTY_EASY then
				GiveExp(PlayerHero1, (exp / 100) * 15);
				SetPlayerResource(PLAYER_1, GOLD, gd + 5000)
			elseif GetDifficulty() == DIFFICULTY_NORMAL then
				GiveExp(PlayerHero1, (exp / 100) * 15);
				SetPlayerResource(PLAYER_1, GOLD, gd + 5000)
			elseif GetDifficulty() == DIFFICULTY_HARD then
				GiveExp(PlayerHero1, (exp / 100) * 15);
				SetPlayerResource(PLAYER_1, GOLD, gd + 5000)
			elseif GetDifficulty() == DIFFICULTY_HEROIC then
				GiveExp(PlayerHero1, (exp / 100) * 15);
				SetPlayerResource(PLAYER_1, GOLD, gd + 5000)
			end;
			break;
		elseif GetObjectiveState("sobj4") == OBJECTIVE_FAILED then
			break;
		end;
	sleep(3);
	end;
end;

-------Win--------

function escape()
	SaveHeroAllSetArtifactsEquipped("Freyda", "A1C1M4");
	sleep(5);
	StartDialogScene("/DialogScenes/A1C1/M4/S3/DialogScene.xdb#xpointer(/DialogScene)");
	SetObjectiveState("obj5", OBJECTIVE_COMPLETED);
	sleep(10);
	Win();
end;

-------Lose--------

function LostHero( HeroName )
	if HeroName == PlayerHero1 then
		SetObjectiveState("obj4", OBJECTIVE_FAILED);
		Trigger(PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, nil);
		sleep (15);
		Loose();
	end;
end;

-------Secondary objective 3--------


function dwarf_q1()
	MessageBox("/Maps/Scenario/A1C1M4/sobj3_d.txt");
	local exp = GetHeroStat(PlayerHero1, STAT_EXPERIENCE);
	if GetDifficulty() == DIFFICULTY_EASY then
		GiveExp(PlayerHero1, (exp / 100) * 15);
		SetPlayerResource(PLAYER_1, CRYSTAL, GetPlayerResource(PLAYER_1, CRYSTAL) + 4)
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		GiveExp(PlayerHero1, (exp / 100) * 15);
		SetPlayerResource(PLAYER_1, CRYSTAL, GetPlayerResource(PLAYER_1, CRYSTAL) + 3)
	elseif GetDifficulty() == DIFFICULTY_HARD then
		GiveExp(PlayerHero1, (exp / 100) * 15);
		SetPlayerResource(PLAYER_1, CRYSTAL, GetPlayerResource(PLAYER_1, CRYSTAL) + 2)
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		GiveExp(PlayerHero1, (exp / 100) * 15);
		SetPlayerResource(PLAYER_1, CRYSTAL, GetPlayerResource(PLAYER_1, CRYSTAL) + 1)
	end;
	ShowFlyingSign("/Maps/Scenario/A1C1M4/hut.txt", "karla1", 1, 5);
	OpenCircleFog(52, 102, GROUND, 5, PLAYER_1);
	SetObjectiveState("sobj3", OBJECTIVE_ACTIVE);
	Trigger (OBJECT_TOUCH_TRIGGER, "karla1", nil);
end;

function dwarf_q1_c()
	if IsObjectExists("ujos") == nil and GetObjectiveState("sobj3") == OBJECTIVE_ACTIVE then
		MessageBox("/Maps/Scenario/A1C1M4/dwarf2_answer.txt");
		Trigger (OBJECT_TOUCH_TRIGGER, "karla2", nil);
		Trigger (OBJECT_TOUCH_TRIGGER, "secret_way", "teleport");
		SetObjectiveState("sobj3", OBJECTIVE_COMPLETED);
		RemoveObject("karla1");
		RemoveObject("karla2");
	elseif GetObjectiveState ("sobj3") == OBJECTIVE_UNKNOWN and IsObjectExists("ujos") == nil then
		SetObjectiveState("sobj3", OBJECTIVE_ACTIVE);
		sleep(2);
		MessageBox("/Maps/Scenario/A1C1M4/dwarf2_answer.txt");
		Trigger (OBJECT_TOUCH_TRIGGER, "karla2", nil);
		Trigger (OBJECT_TOUCH_TRIGGER, "secret_way", "teleport");
		SetObjectiveState("sobj3", OBJECTIVE_COMPLETED);
		RemoveObject("karla2");
	else
		MessageBox("/Maps/Scenario/A1C1M4/dwarf2_1_answer.txt");
	end;
end;

function teleport(hero)
	SetObjectPosition(hero, 103, 74, GROUND);
	Trigger (OBJECT_TOUCH_TRIGGER, "secret_way", "callback");
	Trigger (OBJECT_TOUCH_TRIGGER, "secret_way1", "message");
end;	

function message(hero)
	SetObjectPosition(hero, 53, 103, GROUND);
end;

function callback(hero)
	SetObjectPosition(hero, 103, 74, GROUND);
end;



function hydra()
	local mood = 3;
	local courage = 1;
	CreateMonster( "ujos", CREATURE_CHAOS_HYDRA , 15 * diff, 54, 101, GROUND, 3, 1 );
end;

function despawn()
	while 1 do
		if IsObjectExists("ujos") == nil and GetObjectiveState("sobj3") == OBJECTIVE_UNKNOWN then
			RemoveObject("karla1");
			break;
		end;
	sleep( 3 );
	end;
end;	


-------Secondary objective 5--------

function prison_quest(hero)
	ShowFlyingSign("/Maps/Scenario/A1C1M4/hut.txt", "prison", 1, 5);
	OpenCircleFog(80, 111, GROUND, 6, PLAYER_1);
	OpenCircleFog(32, 120, GROUND, 6, PLAYER_1);
	Trigger (OBJECT_TOUCH_TRIGGER, "prison", "prison_quest1");
	SetObjectiveState("sobj5", OBJECTIVE_ACTIVE);
	sleep(1);
end;

function prison_quest1(hero)
	local mood = 0;
	local courage = 0;
--	if IsObjectExists("helm") == nil and IsObjectExists("boots") == nil then
		if HasArtefact(hero, ARTIFACT_DWARVEN_MITHRAL_GREAVES) == not nil and HasArtefact(hero, ARTIFACT_DWARVEN_MITHRAL_HELMET) == not nil then
			print("Sec_obj5_complete!!!!");
			QuestionBox("/Maps/Scenario/A1C1M4/questionbox_prison.txt", "ok_p");
		end;
--	elseif IsObjectExists("helm") == nil and IsObjectExists("boots") == nil then
		if HasArtefact(hero, ARTIFACT_DWARVEN_MITHRAL_GREAVES) == nil or HasArtefact(hero, ARTIFACT_DWARVEN_MITHRAL_HELMET) == nil then
			if GetObjectiveState("sobj5") == OBJECTIVE_ACTIVE then
				sleep(5);
				SetObjectiveState("sobj5", OBJECTIVE_FAILED);
				Trigger (OBJECT_TOUCH_TRIGGER, "prison", nil);
			end;
		end;
--	end;
end;

function ok_p()
	SetObjectiveState("sobj5", OBJECTIVE_COMPLETED);
	sleep( 1 );
	RemoveArtefact(PlayerHero1, ARTIFACT_DWARVEN_MITHRAL_GREAVES);
	RemoveArtefact(PlayerHero1, ARTIFACT_DWARVEN_MITHRAL_HELMET);
	sleep( 1 );
	CreateMonster( "paladin", CREATURE_PALADIN , 15 * diff, 121, 49, GROUND, 0, 0 );
	sleep( 1 );
	Trigger (OBJECT_TOUCH_TRIGGER, "prison", nil);
end;

function p_check()
	while 1 do
		if GetObjectiveState("sobj1") == OBJECTIVE_COMPLETED then
			Trigger (OBJECT_TOUCH_TRIGGER, "prison", "p_message");
			break;
		end;
	sleep( 3 );
	end;
end;

function p_message()
	MessageBox("/Maps/Scenario/A1C1M4/p_message.txt");
end;

-------Secondary objective 6--------

function tent_quest()
	ShowFlyingSign("/Maps/Scenario/A1C1M4/hut.txt", "tent", 1, 5);
	SetObjectiveState("so6", OBJECTIVE_ACTIVE);
	SetObjectEnabled("guard", not nil);
	MessageBox ("/Maps/Scenario/A1C1M4/sobj6_desc.txt");
	Trigger (OBJECT_TOUCH_TRIGGER, "tent", "tent_quest1");
	sleep(1);
	if GetPlayerResource(PLAYER_1, GEM) >= 5 and GetPlayerResource(PLAYER_1, CRYSTAL) >= 10 and GetPlayerResource(PLAYER_1, GOLD) >= 5000 then
		print("keymaster requirements completed");
		SetPlayerResource(PLAYER_1, GEM, GetPlayerResource(PLAYER_1, GEM) - 5)
		SetPlayerResource(PLAYER_1, CRYSTAL, GetPlayerResource(PLAYER_1, CRYSTAL) - 10)
		SetPlayerResource(PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) - 5000)
		SetObjectEnabled("tent", not nil);
		GiveBorderguardKey(PLAYER_1, RED_KEY);
		ShowFlyingSign("/Maps/Scenario/A1C1M4/tent1.txt", "tent", 1, 5);
		SetObjectiveState("so6", OBJECTIVE_COMPLETED);
		Trigger (OBJECT_TOUCH_TRIGGER, "guard", nil);
	end;
end;

function tent_quest1()
	if GetPlayerResource(PLAYER_1, GEM) >= 5 and GetPlayerResource(PLAYER_1, CRYSTAL) >= 10 and GetPlayerResource(PLAYER_1, GOLD) >= 5000 then
		print("keymaster requirements completed");
		SetPlayerResource(PLAYER_1, GEM, GetPlayerResource(PLAYER_1, GEM) - 5);
		SetPlayerResource(PLAYER_1, CRYSTAL, GetPlayerResource(PLAYER_1, CRYSTAL) - 10);
		SetPlayerResource(PLAYER_1, GOLD, GetPlayerResource(PLAYER_1, GOLD) - 5000);
		ShowFlyingSign("/Maps/Scenario/A1C1M4/tent1.txt", "tent", 1, 5);
		sleep(10);
		SetObjectEnabled("tent", not nil);
		GiveBorderguardKey(PLAYER_1, RED_KEY);
		SetObjectiveState("so6", OBJECTIVE_COMPLETED);
		Trigger (OBJECT_TOUCH_TRIGGER, "tent", nil);
	else
		MessageBox ("/Maps/Scenario/A1C1M4/messagebox_t.txt");
	end;
end;

function point()
	if GetObjectiveState("so6") == OBJECTIVE_UNKNOWN then
		MessageBox ("/Maps/Scenario/A1C1M4/messagebox_g.txt");
	end;
end;

function stout()
	local mood = 3;
	local courage = 1;
	CreateMonster( "guardian", CREATURE_STOUT_DEFENDER, 250 * diff, 47, 55, GROUND, 3, 1 );
end;

function thane()
	local mood = 3;
	local courage = 1;
	CreateMonster( "guardian1", CREATURE_THANE, 20 * diff, 73, 65, GROUND, 3, 1 );
end;

-------Secondary objective 7--------

function paw_quest()
	if IsObjectExists("paw1") == not nil or IsObjectExists("paw2") == not nil then	
		ShowFlyingSign("/Maps/Scenario/A1C1M4/hut.txt", "karla3", 1, 5);
		MessageBox("/Maps/Scenario/A1C1M4/sobj7_desc.txt");
		SetObjectiveState("sobj7", OBJECTIVE_ACTIVE);
		OpenCircleFog(35, 104, GROUND, 7, PLAYER_1);
		sleep(10);
		MoveCamera(34,103, GROUND, 50, 3.14/3, 0);
		Trigger (OBJECT_TOUCH_TRIGGER, "karla3", nil);
	end;
end;

function paw_quest1()
	while 1 do
		if IsObjectExists("paw1") == nil and IsObjectExists("paw2") == nil and w_paw3 == 1 and IsObjectExists("paw3") == nil then
			sleep( 6 );
			if GetObjectiveState("sobj7") == OBJECTIVE_UNKNOWN then
				RemoveObject("karla3");
				RemoveObject("karla4");
				RemoveObject("karla5");
				break;
			end;
			if GetObjectiveState("sobj7") == OBJECTIVE_ACTIVE then
				SetObjectiveState("sobj7", OBJECTIVE_COMPLETED);
				RemoveObject("karla3");
				RemoveObject("karla4");
				RemoveObject("karla5");
				break;
			end;			
		end;
	sleep( 3 );
	end;	
end;

function paw3_spawn()
	while 1 do
		local mood = 3;
		local courage = 1;	
		if IsObjectExists("paw1") == nil and IsObjectExists("paw2") == nil then
			CreateMonster( "paw3", CREATURE_WOLF, 65 * diff, 30, 102, GROUND, 3, 1 );
			sleep( 5 );
			w_paw3 = 1;
			break;
		end;
	sleep( 3 );
	end;
end;	

function o1_o5()
	while 1 do
		if GetObjectiveState("sobj1") == OBJECTIVE_COMPLETED and GetObjectiveState("sobj5") == OBJECTIVE_ACTIVE then
			SetObjectiveState("sobj5", OBJECTIVE_FAILED);
			break;
		elseif GetObjectiveState("sobj5") == OBJECTIVE_COMPLETED and GetObjectiveState("sobj1") == OBJECTIVE_ACTIVE then
			SetObjectiveState("sobj1", OBJECTIVE_FAILED);
			break;
		end;
	sleep( 3 );
	end;
end;

function debug()
	SetPlayerResource(PLAYER_1,GOLD,100000);
	SetPlayerResource(PLAYER_1,ORE,1000);
	SetPlayerResource(PLAYER_1,WOOD,1000);
	SetPlayerResource(PLAYER_1,MERCURY,1000);
	SetPlayerResource(PLAYER_1,SULFUR,1000);
	SetPlayerResource(PLAYER_1,CRYSTAL,1000);
	SetPlayerResource(PLAYER_1,GEM,1000);
	AddHeroCreatures("Freyda", 2, 100);
	AddHeroCreatures("Freyda", 4, 80);
	AddHeroCreatures("Freyda", 6, 50);
	AddHeroCreatures("Freyda", 8, 30);
	AddHeroCreatures("Freyda", 10, 15);
	AddHeroCreatures("Freyda", 12, 5);
end;

H55_CamFixTooManySkills(PLAYER_1,"Freyda");
hydra();
startThread (o1_o5);
startThread (p_check);
startThread (paw_quest1);
startThread (paw3_spawn);
startThread (rebels);
Trigger (OBJECT_TOUCH_TRIGGER, "karla1", "dwarf_q1");
Trigger (OBJECT_TOUCH_TRIGGER, "karla2", "dwarf_q1_c");
Trigger (OBJECT_TOUCH_TRIGGER, "karla3", "paw_quest");
Trigger (OBJECT_TOUCH_TRIGGER, "garrison", "garrison1");
Trigger (OBJECT_TOUCH_TRIGGER, "hut", "hut_quest");
Trigger (OBJECT_TOUCH_TRIGGER, "prison", "prison_quest");
Trigger (PLAYER_REMOVE_HERO_TRIGGER, PLAYER_1, "LostHero");
Trigger (OBJECT_TOUCH_TRIGGER, "tent", "tent_quest");
Trigger (OBJECT_TOUCH_TRIGGER, "guard", "point");