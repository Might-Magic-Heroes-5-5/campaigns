doFile("/scripts/A2_Artifact_Sets/A2_Artifact_Sets.lua");

function H55_InitSetArtifacts()
	InitAllSetArtifacts("C2M2");
    LoadHeroAllSetArtifacts("Agrael", "C2M1" );
end;

startThread(H55_InitSetArtifacts);

--Global var
SetGameVar("C2M2_IsVeyerDefeatGiar",0);
SetGameVar("C2M2_VeyerDefeated",0);
SetAIHeroAttractor("mausoleum","Veyer",2);
Agrael = "Agrael";
Veyer = "Veyer";
Mardigo = "Mardigo";
Deleb = "Deleb"
Veyerm = 0;
C2M2_C1 = 0;
C2M2_C2 = 0;
C2M2_C3 = 0;
C2M2_C4 = 0;
assasins_ambush = 0;
revealed = 0;
skipday = 3;
OpenCircleFog(64,125,0,15,PLAYER_1);
OpenCircleFog(104,3,0,15,PLAYER_1);

SetObjectEnabled("loot2", nil);
SetObjectEnabled("loot4", nil);

EnableHeroAI("Mardigo", nil);

SetPlayerStartResource( PLAYER_1, WOOD, 0 );
SetPlayerStartResource( PLAYER_1, ORE, 0 );
SetPlayerStartResource( PLAYER_1, MERCURY, 0 );
SetPlayerStartResource( PLAYER_1, CRYSTAL, 0 );
SetPlayerStartResource( PLAYER_1, GEM, 0 );

function DifficultyDependencies()
	if GetDifficulty() == DIFFICULTY_EASY then
		print("Difficulty level is NORMAL");
		SetPlayerStartResource( PLAYER_1, SULFUR, 10 );
		SetPlayerStartResource( PLAYER_1, GOLD, 10000 );
		AddHeroCreatures(Agrael,CREATURE_FAMILIAR,30);
		AddHeroCreatures(Agrael,CREATURE_HORNED_DEMON,20);
		AddHeroCreatures(Agrael,CREATURE_HELL_HOUND,15);
		AddHeroCreatures(Agrael,CREATURE_NIGHTMARE,8);
		startThread(RemoveVeyerMP(2));
	else
		if GetDifficulty() == DIFFICULTY_NORMAL then
			print("Difficulty level is NORMAL");
			SetPlayerStartResource( PLAYER_1, SULFUR, 5 );
			SetPlayerStartResource( PLAYER_1, GOLD, 8000 );
			startThread(RemoveVeyerMP(3));
			AddHeroCreatures(Agrael,CREATURE_FAMILIAR,20);
			AddHeroCreatures(Agrael,CREATURE_HORNED_DEMON,15);
			AddHeroCreatures(Agrael,CREATURE_HELL_HOUND,10);
			AddHeroCreatures(Agrael,CREATURE_NIGHTMARE,6);
		else
			if GetDifficulty() == DIFFICULTY_HARD then
				print("Difficulty level is HARD");
				SetPlayerStartResource( PLAYER_1, SULFUR, 0 );
				SetPlayerStartResource( PLAYER_1, GOLD, 2000 );
			else
				print("Difficulty level is HEROIC");
				SetPlayerStartResource( PLAYER_1, SULFUR, 0 );
				SetPlayerStartResource( PLAYER_1, GOLD, 1000 );
			end;
		end;
	end;
end;

function messages( dialog )
	if dialog == 1 then
		StartDialogScene("/DialogScenes/C2/M2/D1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 2 then
		StartDialogScene("/DialogScenes/C2/M2/D2/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 3 then
		StartDialogScene("/DialogScenes/C2/M2/R1/DialogScene.xdb#xpointer(/DialogScene)");
	end;
	if dialog == 4 then
		MessageBox ("/Maps/Scenario/C2M2/Messages/C2M2_C4.txt");
	end;
end;

function len( x, y )
local l = sqrt( x * x + y * y );
	return l;
end;

function RemoveVeyerMP(part)
	while 1 do
		repeat 
			sleep(1);
		until GetCurrentPlayer() == PLAYER_2;
		print("Player's 2 turn");
		delta_MP = (GetHeroStat(Veyer,STAT_MOVE_POINTS) - mod (GetHeroStat(Veyer,STAT_MOVE_POINTS),part))/part;
		print("Hero has ",GetHeroStat(Veyer,STAT_MOVE_POINTS)," move points");
		print("delta = ",delta_MP);
		ChangeHeroStat(Veyer,STAT_MOVE_POINTS,-delta_MP);
		sleep(2);
		print("Now hero has ",GetHeroStat(Veyer,STAT_MOVE_POINTS));
		repeat
			sleep(1);
		until GetCurrentPlayer() ~= PLAYER_2;
		print("End of player's 2 turn");	
	end;
end;


function Amb2()
	assasins_ambush = assasins_ambush + 1;
	if assasins_ambush == 2 then
		MessageBox("/Maps/Scenario/C2M2/messages/C2M2_assasin1.txt", "add_assasins");
		Trigger(OBJECT_TOUCH_TRIGGER, "loot2", nil);
		SetObjectEnabled("loot2", not nil);
	else
		MessageBox("/Maps/Scenario/C2M2/messages/C2M2_assasin.txt", "Ambush2");
	end;
end;

function Ambush2()
	local rnd_slots = random( 2 ) + 1;
	SetObjectEnabled("loot2", not nil);
	Trigger(OBJECT_TOUCH_TRIGGER, "loot2", nil);
	if rnd_slots == 1 then
		StartCombat( "Agrael", nil, 1, CREATURE_ASSASSIN, random(20) + 30, nil, nil);
	elseif rnd_slots == 2 then
		StartCombat( "Agrael", nil, 2, CREATURE_ASSASSIN, random(10) + 20, CREATURE_ASSASSIN, random(10) + 20, nil, nil);
	elseif rnd_slots == 3 then
		StartCombat( "Agrael", nil, 3, CREATURE_ASSASSIN, random(10) + 20, CREATURE_SCOUT, random(10) + 20, CREATURE_SCOUT, random(10) + 20, nil, nil);
	end;
end;

function Amb4()
	assasins_ambush = assasins_ambush + 1;
	if assasins_ambush == 2 then
		MessageBox("/Maps/Scenario/C2M2/messages/C2M2_assasin1.txt", "add_assasins");
		Trigger(OBJECT_TOUCH_TRIGGER, "loot4", nil);
		SetObjectEnabled("loot4", not nil);
	else
		MessageBox("/Maps/Scenario/C2M2/messages/C2M2_assasin.txt", "Ambush4");
	end;
end;

function add_assasins()
	print("Assassins were added to Agrael's army");
	AddHeroCreatures("Agrael",CREATURE_ASSASSIN, random(20) + 20);
end;


function Ambush4()
	local rnd_slots = random( 2 ) + 1;
	SetObjectEnabled("loot4", not nil);
	Trigger(OBJECT_TOUCH_TRIGGER, "loot4", nil);
	if rnd_slots == 1 then
		StartCombat( "Agrael", nil, 1, CREATURE_ASSASSIN, random(20) + 30, nil, nil);
	elseif rnd_slots == 2 then
		StartCombat( "Agrael", nil, 2, CREATURE_ASSASSIN, random(10) + 20, CREATURE_ASSASSIN, random(10) + 20, nil, nil);
	elseif rnd_slots == 3 then
		StartCombat( "Agrael", nil, 3, CREATURE_ASSASSIN, random(10) + 20, CREATURE_SCOUT, random(10) + 20, CREATURE_SCOUT, random(10) + 20, nil, nil);
	end;
end;


function Mausoleum(heroname)
	print("Thread Mausoleum has been started...");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "crypt2",nil);
	if heroname == 'Agrael' then
		print("Agrail has arrived in area");
		Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'crypt', nil );
		Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'enemy_stop', 'Giar_stopped');
		BlockGame();
		SetObjectPosition( 'Veyer', 72, 118, -1 );
		EnableHeroAI( "Veyer", nil );
		Agrael_x, Agrael_y = GetObjectPosition( 'Agrael' );
		MoveHeroRealTime('Mardigo', Agrael_x, Agrael_y , -1 );
		UnblockGame();
	else
		print("This hero is not Agrael");
	end;
end;

function Giar_stopped(heroname)
	print('Thread Giar_stopped has been started');
	if heroname == 'Mardigo' then
		print("Giar has arrived in zone enemy_stop");
		BlockGame();
		Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'enemy_stop', nil);
		messages( 2 );
		sleep(2);
		MoveHeroRealTime('Mardigo', Agrael_x, Agrael_y , -1 );
		startThread(VeyerAttacks);
		UnblockGame();
	else
		print("Hero is not Giar");
	end;
end;

function VeyerAttacks()
	print("Thread VeyerAttacks has been started...");
	BlockGame();
	while 1 do
		sleep(10);
		if IsHeroAlive('Mardigo') == nil then
			print("Giar is dead. Veyer attacks!");
			--SetRegionBlocked( 'area1', nil, PLAYER_2);
			messages( 3 );
			SaveHeroAllSetArtifactsEquipped("Agrael", "C2M2");
			ChangeHeroStat("Veyer",STAT_MOVE_POINTS,4000);
			MoveHeroRealTime('Veyer', Agrael_x, Agrael_y , -1 );
			GetHeroStat("Veyer", STAT_MOVE_POINTS);
			UnblockGame();
			return
		end;
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

function GetAgraelCoords()
	while IsHeroAlive("Agrael") == not nil do
		sleep(10);
		Agrael_x,Agrael_y = GetObjectPosition("Agrael");
	end;
end;


mycoolfuncobject = function ()
	RemoveObject("Veyer");
	SetObjectiveState( 'prim1', OBJECTIVE_COMPLETED);
	SetObjectiveState( 'prim2', OBJECTIVE_COMPLETED);
	Win(PLAYER_1);
	end;

function StartCutscene()
	print("Thread StartCutscene has been started...");
	repeat
		sleep(1);
	until GetGameVar("C2M2_VeyerDefeated") == "1";
	print("Cutscene has been started...");
	Save("SaveName");
	StartCutScene("/Maps/Cutscenes/C2M2/_.(AnimScene).xdb#xpointer(/AnimScene)", "mycoolfuncobject");
end;

function LooseIfVeyerFaster()
	print("Thread LooseIfVeyerFaster has been started...");
	Trigger(REGION_ENTER_AND_STOP_TRIGGER, "crypt2",nil);
	sleep(7);
	Loose(PLAYER_1);
end;

function MoveVeyer()
	print("Veyer has been moved");
	SetObjectPosition("Veyer",71,114);
end;

function military_disable()
	SetObjectEnabled("military",nil);
	print("Military post has been disabled...");
	Trigger(OBJECT_TOUCH_TRIGGER, "military", nil);
end;

function sotona_disable()
	SetObjectEnabled("sotona",nil);
	print("Demon dwelling has been disabled...");
	Trigger(OBJECT_TOUCH_TRIGGER, "sotona", nil);
end;

function konura_disable()
	SetObjectEnabled("konura",nil);
	print("Hell hound's dwelling has been disabled...");
	Trigger(OBJECT_TOUCH_TRIGGER, "konura", nil);
end;

function besovstvo_disable()
	SetObjectEnabled("konura",nil);
	print("Imp's dwelling has been disabled...");
	Trigger(OBJECT_TOUCH_TRIGGER, "besovstvo", nil);
end;

function VeyerHasNoWay()
	Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"VeyerStop",nil);
	SetRegionBlocked("VeyerStop2",not nil);
	print("Veyer can not return back.");
end;

-------------------
H55_CamFixTooManySkills(PLAYER_1,"Agrael");
messages( 1 );
SetObjectiveState( 'prim2', OBJECTIVE_ACTIVE );

startThread(DifficultyDependencies);
Trigger(REGION_ENTER_AND_STOP_TRIGGER, "crypt2","LooseIfVeyerFaster");
Trigger(REGION_ENTER_AND_STOP_TRIGGER , 'crypt', "Mausoleum" );
Trigger(OBJECT_TOUCH_TRIGGER, "loot2", "Amb2");
Trigger(OBJECT_TOUCH_TRIGGER, "loot4", "Amb4");
Trigger(OBJECT_TOUCH_TRIGGER, "military", "military_disable");
Trigger(OBJECT_TOUCH_TRIGGER, "sotona", "sotona_disable");
Trigger(OBJECT_TOUCH_TRIGGER, "konura", "konura_disable");
Trigger(OBJECT_TOUCH_TRIGGER, "besovstvo", "besovstvo_disable");
Trigger(REGION_ENTER_WITHOUT_STOP_TRIGGER,"VeyerStop","VeyerHasNoWay");
startThread(GetAgraelCoords);
startThread(StartCutscene);
print("All triggers and functions run");
