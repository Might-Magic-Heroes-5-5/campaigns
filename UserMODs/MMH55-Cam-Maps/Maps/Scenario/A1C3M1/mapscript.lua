H55_PlayerStatus = {0,1,2,2,2,2,2,2};

H55_RemoveTheseArtifactsFromBanks = {

ARTIFACT_DRAGON_SCALE_ARMOR,
ARTIFACT_DRAGON_SCALE_SHIELD,
ARTIFACT_DRAGON_BONE_GRAVES,
ARTIFACT_DRAGON_WING_MANTLE,
ARTIFACT_DRAGON_TEETH_NECKLACE,
ARTIFACT_DRAGON_TALON_CROWN,
ARTIFACT_DRAGON_EYE_RING,
ARTIFACT_DRAGON_FLAME_TONGUE

};

doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("A1C3M1");
end;

startThread(H55_InitSetArtifacts);

PlayerHero = "Shadwyn"
EnemyHero = "Kelodin"
EnemyHero1 = "Thralsai"
edeploy = 0;
cnt = {0, 0, 0, 0, 0, 0};
count = 0;

SetHeroesExpCoef( 0.3 );

function diff_setup()
	if GetDifficulty() == DIFFICULTY_EASY then
		diff = 1;
	    print ("easy");
	elseif GetDifficulty() == DIFFICULTY_NORMAL then
		diff = 1;
	    print ("normal");
	elseif GetDifficulty() == DIFFICULTY_HARD then
		diff = 2;
	    print ("Hard");
	elseif GetDifficulty() == DIFFICULTY_HEROIC then
		diff = 3;
	    print ("Impossible");
	end;
end;


SetPlayerResource(PLAYER_1, WOOD, 0);
SetPlayerResource(PLAYER_1, ORE, 0);
SetPlayerResource(PLAYER_1, MERCURY, 0);
SetPlayerResource(PLAYER_1, SULFUR, 0);
SetPlayerResource(PLAYER_1, GEM, 0);
SetPlayerResource(PLAYER_1, CRYSTAL, 0);
SetPlayerResource(PLAYER_1, GOLD, 0);

StartDialogScene("/DialogScenes/A1C3/M1/S1/DialogScene.xdb#xpointer(/DialogScene)");

SetObjectiveState("sobj1", OBJECTIVE_ACTIVE);
SetObjectiveState("obj1", OBJECTIVE_ACTIVE);
SetObjectiveState("obj2", OBJECTIVE_ACTIVE);
SetRegionBlocked("graal", 1, PLAYER_1)

-----Huts-----

SetObjectEnabled("h1", nil);
SetObjectEnabled("h2", nil);
SetObjectEnabled("h3", nil);
SetObjectEnabled("h4", nil);
SetObjectEnabled("h5", nil);
SetObjectEnabled("h6", nil);

Trigger (OBJECT_TOUCH_TRIGGER, "h1", "h1");

function h1(heroName)
	MoveCamera(80, 54, GROUND, 25, 3.14/3, 0, 1, 1, 1);
	sleep(2);
	OpenCircleFog(80, 54, GROUND, 3, PLAYER_1);
	MarkObjectAsVisited("h1", heroName);
--	cnt[1] = 1;
	sleep( 15 );
	recall();
end;

Trigger (OBJECT_TOUCH_TRIGGER, "h2", "h2");

function h2(heroName)
	MoveCamera(70, 66, GROUND, 25, 3.14/3, 0, 1, 1, 1);
	sleep(2);
	OpenCircleFog(70, 66, GROUND, 3, PLAYER_1);
	MarkObjectAsVisited("h2", heroName);
--	cnt[2] = 1;
	sleep( 15 );
	recall();
end;

Trigger (OBJECT_TOUCH_TRIGGER, "h3", "h3");

function h3(heroName)
	MoveCamera(54, 55, GROUND, 25, 3.14/3, 0, 1, 1, 1);
	sleep(2);
	OpenCircleFog(54, 55, GROUND, 3, PLAYER_1);
	MarkObjectAsVisited("h3", heroName);
--	cnt[3] = 1;
	sleep( 15 );
	recall();
end;

Trigger (OBJECT_TOUCH_TRIGGER, "h4", "h4");

function h4(heroName)
	MoveCamera(42, 79, UNDERGROUND, 25, 3.14/3, -450, 1, 0, 1);
	sleep(2);
	OpenCircleFog(42, 79, UNDERGROUND, 3, PLAYER_1);
	MarkObjectAsVisited("h4", heroName);
--	cnt[4] = 1;
	sleep( 15 );
	recall();
end;

Trigger (OBJECT_TOUCH_TRIGGER, "h5", "h5");

function h5(heroName)
	MoveCamera(9, 20, UNDERGROUND, 25, 3.14/3, 0, 1, 0, 1);
	sleep(2);
	OpenCircleFog(9, 20, UNDERGROUND, 3, PLAYER_1);
	MarkObjectAsVisited("h5", heroName);
--	cnt[5] = 1;
	sleep( 15 );
	recall();
end;

Trigger (OBJECT_TOUCH_TRIGGER, "h6", "h6");

function h6(heroName)
	MoveCamera(31, 5, UNDERGROUND, 25, 3.14/3, -520, 1, 0, 1);
	sleep(2);
	OpenCircleFog(31, 5, UNDERGROUND, 3, PLAYER_1);
	MarkObjectAsVisited("h6", heroName);
--	cnt[6] = 1;
	sleep( 15 );
	recall();
end;

function sranaya_pignya()
	local s = 0;
	while 1 do
		s = 0;
		for i = 1, 6 do
			s = s + cnt[i];
		end;
		if s == 6 and count == 6 then
			SetObjectiveState("sobj2", OBJECTIVE_COMPLETED);
			exp = GetHeroStat(PlayerHero, STAT_EXPERIENCE);
			skill_up_attack = GetHeroStat(PlayerHero, STAT_ATTACK);
			skill_up_defence = GetHeroStat(PlayerHero, STAT_DEFENCE);
			if GetDifficulty() == DIFFICULTY_EASY then
				GiveExp(PlayerHero, (exp / 100) * 20);
				ChangeHeroStat(PlayerHero, STAT_ATTACK, skill_up_attack + 2);
				ChangeHeroStat(PlayerHero, STAT_DEFENCE, skill_up_defence + 2);
			elseif GetDifficulty() == DIFFICULTY_NORMAL then
				GiveExp(PlayerHero, (exp / 100) * 20);
				ChangeHeroStat(PlayerHero, STAT_ATTACK, skill_up_attack + 2);
				ChangeHeroStat(PlayerHero, STAT_DEFENCE, skill_up_defence + 2);
			elseif GetDifficulty() == DIFFICULTY_HARD then
				GiveExp(PlayerHero, (exp / 100) * 25);
				ChangeHeroStat(PlayerHero, STAT_ATTACK, skill_up_attack + 2);
				ChangeHeroStat(PlayerHero, STAT_DEFENCE, skill_up_defence + 3);
			elseif GetDifficulty() == DIFFICULTY_HEROIC then
				GiveExp(PlayerHero, (exp / 100) * 30);
				ChangeHeroStat(PlayerHero, STAT_ATTACK, skill_up_attack + 3);
				ChangeHeroStat(PlayerHero, STAT_DEFENCE, skill_up_defence + 3);		
			end;
			break;
		end;
		sleep( 3 );
	end;
end;

function recall()
	x,y,level = GetObjectPosition(PlayerHero);
	sleep( 10 );
	MoveCamera(x, y, level, 25, 3.14/2, 0, 1, 0, 1);
end;

-----Objective 1-----

Trigger (OBJECT_TOUCH_TRIGGER, "m1", "m");
Trigger (OBJECT_TOUCH_TRIGGER, "m2", "m");
Trigger (OBJECT_TOUCH_TRIGGER, "m3", "m");
Trigger (OBJECT_TOUCH_TRIGGER, "m4", "m");
Trigger (OBJECT_TOUCH_TRIGGER, "m5", "m");
Trigger (OBJECT_TOUCH_TRIGGER, "m6", "m");

function m()
	sleep(2);
	OpenPuzzleMap(PLAYER_1, 1);
end;

function objective1()
	while 1 do
		count = 0
		if IsObjectExists("m1") == nil then
			count = count + 1;
			cnt[1] = 1; --DB!!!!!!!!!!!!!!!!!!!!!!!!
		end;
		if IsObjectExists("m2") == nil then
			count = count + 1;
			cnt[2] = 1;
		end;
		if IsObjectExists("m3") == nil then
			count = count + 1;
			cnt[3] = 1;
		end;
		if IsObjectExists("m4") == nil then
			count = count + 1;
			cnt[4] = 1;
		end;
		if IsObjectExists("m5") == nil then
			count = count + 1;
			cnt[5] = 1;
		end;
		if IsObjectExists("m6") == nil then
			count = count + 1;
			cnt[6] = 1;
		end;
		if GetObjectiveState("sobj2") == OBJECTIVE_COMPLETED then
			break;
		end;
	sleep(2);
	end;
end;

Trigger (REGION_ENTER_WITHOUT_STOP_TRIGGER, "camp", "waiting");

function waiting()
	BlockGame();
	DeployReserveHero(EnemyHero1, 4, 22, GROUND);
	OpenCircleFog(4, 22, GROUND, 4, PLAYER_1);
	sleep(5);
	EnableHeroAI(EnemyHero1, nil);
	--Trigger (NEW_DAY_TRIGGER, nil);
	startThread(walk);
	ShowFlyingSign("/Maps/Scenario/A1C3M1/camp.txt", "Shadwyn", 1, 5);
	Trigger (REGION_ENTER_WITHOUT_STOP_TRIGGER, "camp", nil);
	MoveCamera(32, 30, GROUND, 50, 3.14/3, 0);
end;

function walk()
	while 1 do
		if IsObjectExists(EnemyHero1) then
			a, b = GetObjectPosition(EnemyHero1);
			EnableHeroAI(EnemyHero1, not nil);
			ChangeHeroStat(EnemyHero1, STAT_MOVE_POINTS, 3000);
			OpenCircleFog(33, 30, GROUND, 8, PLAYER_1);
			sleep( 1 );
			MoveHeroRealTime(EnemyHero1, 31,30, GROUND);
			if a == 31 and b == 30 then
				DeployReserveHero(EnemyHero, 3, 5, GROUND);
				sleep(3);
				startThread(lilwin);
				break;
			end;
		end;
		sleep( 2 );
	end;
end;	

function lilwin()
	while 1 do
		if IsObjectExists(EnemyHero) then
			SetObjectPosition(EnemyHero, 33, 30, GROUND);
			sleep( 10 );
			break;
		end;
		sleep( 2 );
	end;

	while 1 do
		x, y = GetObjectPosition(EnemyHero);
		if x == 33 and y == 30 then
			sleep( 15 );
			SetObjectPosition(EnemyHero, 3, 5, GROUND);
			SetObjectPosition(EnemyHero1, 3, 4, GROUND);
			sleep( 1 );
			StartDialogScene("/DialogScenes/A1C3/M1/S2/DialogScene.xdb#xpointer(/DialogScene)", "DoWin", "autosave");
			break;
		end;
		sleep( 2 );
	end;
end;

function DoWin()
	SaveHeroAllSetArtifactsEquipped("Shadwyn", "A1C3M1");
	sleep(5);
	SetObjectiveState("obj2", OBJECTIVE_COMPLETED);
	sleep(5);
	Win();
end;

-----Objective 2-----

function objective2()
	while 1 do
		if IsHeroAlive(PlayerHero) == nil then
			SetObjectiveState("obj2", OBJECTIVE_FAILED);
			sleep(3);
			Loose();
		end;
	sleep(3);
	end;
end;


-----Dungeon Cr. Check-----

Trigger (REGION_ENTER_AND_STOP_TRIGGER, "d1", "ahtung");
Trigger (REGION_ENTER_AND_STOP_TRIGGER, "d2", "ahtung");
Trigger (REGION_ENTER_AND_STOP_TRIGGER, "d3", "ahtung");
Trigger (REGION_ENTER_AND_STOP_TRIGGER, "d4", "ahtung");

function ahtung()
	MessageBox("/Maps/Scenario/A1C3M1/messagebox_q.txt");
	print("message bla !")
	startThread(check);
end;


function check()
	while 1 do
		if IsObjectExists( "dc" ) == nil then
			ShowFlyingSign("/Maps/Scenario/A1C3M1/lose.txt", "Shadwyn", 1, 5);
			sleep( 10 );
			Loose();
		end;
	sleep( 3 );	
	end;
end;

-----Secondary Objective 1-----

SetObjectEnabled("seer_hut", nil);

Trigger (OBJECT_TOUCH_TRIGGER, "seer_hut", "sobjective1");

function sobjective1()
	SetObjectiveState("sobj1", OBJECTIVE_COMPLETED);
	sleep(3);
	-- ShowFlyingSign("/Maps/Scenario/A1C3M1/new_objective.txt", "seer_hut", 1, 5);
	sleep(1);
	SetObjectiveState("sobj2", OBJECTIVE_ACTIVE);
	Trigger (OBJECT_TOUCH_TRIGGER, "seer_hut", nil);
end;

diff_setup();
startThread (sranaya_pignya);	
startThread (objective1);
startThread (objective2);
-----------------------------------------