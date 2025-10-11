----------------------------------------------------------------------------------------
----------------------------------   CONSTANTS   ---------------------------------------
----------------------------------------------------------------------------------------

loopSoundsLocks = 0
function LockLoopSounds() loopSoundsLocks = loopSoundsLocks + 1; end;
function UnlockLoopSounds() loopSoundsLocks = loopSoundsLocks - 1; end;

-- HERO NAMES -------------------------------------------
QUROQ = "Quroq";
AI_HERO = "Sarge";

-- PATH -------------------------------------------------
PATH = "Maps/Scenario/A2C0M0/";

-- MESSAGE BOXES ----------------------------------------
MSGBOX_GOBLINS_SCENE = PATH.."MsgBox_GoblinsScene.txt";
MSGBOX_BUTCHERS_SCENE = PATH.."MsgBox_ButchersScene.txt";
MSGBOX_CYCLOPS_SCENE = PATH.."MsgBox_CyclopsScene.txt";


-- VOICE OVERS  ------------------------------------------
VOICEOVER_MISSION_LOADING = "/DialogScenes/A2C0/M2/S1/C0M2S1_18sound.xdb#xpointer(/Sound)"; -- Куджин взывает к духу Геббельса
VOICEOVER_MISSION_START  = "/Maps/Scenario/A2C0M0/C0M1_V05_Quroq_01sound.xdb#xpointer(/Sound)"; -- Вопли Курка при старте миссии
VOICEOVER_RECEIVE_DESTROY_TOWN = "/DialogScenes/A2C0/M2/S1/C0M2S1_02sound.xdb#xpointer(/Sound)"; -- Курок получает задание "уничтожить город"
--VOICEOVER_BEFORE_FIRST_COMBAT = "/DialogScenes/A2C0/M2/S1/C0M2S1_02sound.xdb#xpointer(/Sound)"; -- Перед первым комбатом гонево про бладрейдж
--VOICEOVER_COMBAT_GAIN_RAGE = ""; -- Во время комбата, за получение рейджбонуса
VOICEOVER_QUROQ_RELEASES_CENTAURS = "/Maps/Scenario/A2C0M0/C0M1_V07_Quroq_01sound.xdb#xpointer(/Sound)";-- После освобождения кентавров
VOICEOVER_QUROQ_RELEASES_GOBLINS = "/Maps/Scenario/A2C0M0/C0M1_VO9_Khenghi_01sound.xdb#xpointer(/Sound)"; -- После освобождения гоблинов
VOICEOVER_QUROQ_RELEASES_BUTCHERS = "/Maps/Scenario/A2C0M0/C0M1_V010_Butcher_01sound.xdb#xpointer(/Sound)";-- После освобождения бутчеров
VOICEOVER_QUROQ_RELEASES_CYCLOPS = "/Maps/Scenario/A2C0M0/C0M1_V011_Cyclops_01sound.xdb#xpointer(/Sound)"; -- После освобождения циклопов
VOICEOVER_DESTROY_TOWN_COMPLETED = "/DialogScenes/A2C0/M2/S1/C0M2S1_02sound.xdb#xpointer(/Sound)"; -- После уничтожения города
VOICEOVER_RELEASE_ALL_CREATURES_COMPLETED = "/DialogScenes/A2C0/M2/S1/C0M2S1_02sound.xdb#xpointer(/Sound)";-- Все орки освобождены


-- EFFECTS  ----------------------------------------------
EFFECT_TREE_HIT = "/Effects/_(Effect)/Characters/hits/dendroidsoldier_hit.xdb#xpointer(/Effect)";
EFFECT_BALLISTA_DEATH = "/Effects/_(Effect)/Characters/WarMachines/Ballista_WildFire/death01.(Effect).xdb#xpointer(/Effect)";
EFFECT_FIREWALL = "/Effects/_(Effect)/Spells/FireWall.(Effect).xdb#xpointer(/Effect)";
EFFECT_DUST = "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)";
EFFECT_FIRE_01 = "/Effects/_(Effect)/Towns/Inferno/MagicGuild.xdb#xpointer(/Effect)";
EFFECT_FIRE_02 = "/Effects/_(Effect)/Towns/Inferno/DemonGate.xdb#xpointer(/Effect)";
EFFECT_GLOW = "/Effects/_(Effect)/Environment/Inferno/Hellpikes/Hellpikes4x4_3.xdb#xpointer(/Effect)";

SOUND_EFFECT_HUT_CRUSH = "/Sounds/_(Sound)/SFX/Seige-Destr/tower-crash.xdb#xpointer(/Sound)";
SOUND_EFFECT_SCREAMS = "/Sounds/_(Sound)/SFX/Screams.xdb#xpointer(/Sound)";
SOUND_EFFECT_HUT_BURN = "/Sounds/_(Sound)/Buildings/Arena.xdb#xpointer(/Sound)";
--SOUND_EFFECT_HUT_BURN = "/Sounds/_(Sound)/Buildings/Elemental_conflux.xdb#xpointer(/Sound)";



-- COMBAT SCRIPT PATH ------------------------------------
COMBAT_SCRIPT = "/Maps/Scenario/A2C0M0/A2C0M0_CombatVSPeasants.(Script).xdb#xpointer(/Script)";


-- OTHER -------------------------------------------------
LISTENING_DISTANCE = 20; -- расстояние на котором Курок "слышит" вопли своих сородичей, игроку показывают скриптовую сценку про их муки.

FIRST_COMBAT_PEASANTS_AMOUNT = 80; -- количество в стеке. Стеков четыре. Число надо умножать на 4.
BUTCHERS_TO_DEPLOY = 30; -- Количество освобождаемых бутчеров



----------------------------------------------------------------------------------------
----------------------------------   VARIABLES   ---------------------------------------
----------------------------------------------------------------------------------------
isGoblinsShowed = 0;
isButchersShowed = 0;
isCyclopsShowed = 0;

creaturesCollected = 0;
butchersDeployed = 0;

isTutorialOn = 1;

TouchedBuilding = "fake";


----------------------------------------------------------------------------------------
------------------------------   INITIAL CONDITIONS   ----------------------------------
----------------------------------------------------------------------------------------
if GetDifficulty() == DIFFICULTY_EASY then
	diff = 2;
	print("MAIN: Difficulty level is EASY");
elseif GetDifficulty() == DIFFICULTY_NORMAL then
	diff = 2;
	print("MAIN: Difficulty level is NORMAL");
elseif GetDifficulty() == DIFFICULTY_HARD then
	diff = 3;
	print("MAIN: Difficulty level is HARD");
elseif GetDifficulty() == DIFFICULTY_HEROIC then
	diff = 4;
	print("MAIN: Difficulty level is HEROIC");
end;

MakeHeroReturnToTavernAfterDeath( "Nathaniel", not nil, 0);
MakeHeroReturnToTavernAfterDeath( "Giar", not nil, 0);
MakeHeroReturnToTavernAfterDeath( "Glen", not nil, 0);
MakeHeroReturnToTavernAfterDeath( "Ving", not nil, 0);
MakeHeroReturnToTavernAfterDeath( "Maeve", not nil, 0);
MakeHeroReturnToTavernAfterDeath( "Brem", not nil, 0);
MakeHeroReturnToTavernAfterDeath( "Christian", not nil, 0);
--MakeHeroReturnToTavernAfterDeath( "RedHeavenHero01", not nil, 0);
--MakeHeroReturnToTavernAfterDeath( "RedHeavenHero02", not nil, 0);
--MakeHeroReturnToTavernAfterDeath( "RedHeavenHero03", not nil, 0);

SetObjectEnabled( "HutOfMagi_Cyclops", nil );
SetObjectEnabled( "HutOfMagi_Goblins", nil );
SetObjectEnabled( "HutOfMagi_Butchers", nil );

SetObjectEnabled( "prison", nil );

SetObjectEnabled( "peasant_1", nil );
SetObjectEnabled( "peasant_2", nil );
SetObjectEnabled( "centaur", nil );

SetObjectEnabled( "west_hut", nil );
SetObjectEnabled( "east_hut", nil );
SetObjectEnabled( "south_hut", nil );

SetRegionBlocked( "centaur_dwelling_area", not nil, PLAYER_1 );
SetRegionBlocked( "goblin_dwelling_area", not nil, PLAYER_1 );
SetRegionBlocked( "military_post_area", not nil, PLAYER_1 );
SetRegionBlocked( "centaur_dwelling_area", not nil, PLAYER_2 );
SetRegionBlocked( "goblin_dwelling_area", not nil, PLAYER_2 );
SetRegionBlocked( "military_post_area", not nil, PLAYER_2 );
SetRegionBlocked( "ai1", not nil, PLAYER_2 );
SetRegionBlocked( "ai2", not nil, PLAYER_2 );
SetRegionBlocked( "ai3", not nil, PLAYER_2 );
SetRegionBlocked( "ai4", not nil, PLAYER_2 );
SetRegionBlocked( "ai5", not nil, PLAYER_2 );
SetRegionBlocked( "ai6", not nil, PLAYER_2 );
SetRegionBlocked( "skeletons", not nil, PLAYER_2 );
SetRegionBlocked( "sucrificial_pit", not nil, PLAYER_2 );

EnableHeroAI( AI_HERO, nil );
SetHeroRoleMode( AI_HERO, HERO_ROLE_MODE_HERMIT );

AddHeroCreatures( AI_HERO, CREATURE_LONGBOWMAN, 15+10*(diff-1));
AddHeroCreatures( AI_HERO, CREATURE_CHAMPION, 1+2*(diff-1));
AddHeroCreatures( AI_HERO, CREATURE_VINDICATOR, 20+8*(diff-1));
AddHeroCreatures( AI_HERO, CREATURE_BATTLE_GRIFFIN, 3+3*(diff-1));

if GetDifficulty()~=DIFFICULTY_EASY then
	RemoveHeroCreatures( "Quroq", CREATURE_ORC_WARRIOR, 10*GetDifficulty() );
end;

if GetDifficulty()==DIFFICULTY_HEROIC then
	ChangeHeroStat( AI_HERO, STAT_EXPERIENCE, 11000 );
	AddHeroCreatures( AI_HERO, CREATURE_CHAMPION, 6 );
	AddHeroCreatures( AI_HERO, CREATURE_SERAPH, 5 );
end;

OverrideObjectTooltipNameAndDescription( "prison", "", PATH.."Tooltip_Prison.txt");

SetPlayerStartResource( PLAYER_1, GOLD, 1000+1000*(4-diff) );
SetPlayerStartResource( PLAYER_1, ORE, 0 );
SetPlayerStartResource( PLAYER_1, WOOD, 0 );
SetPlayerStartResource( PLAYER_1, CRYSTAL, 0 );
SetPlayerStartResource( PLAYER_1, GEM, 0 );
SetPlayerStartResource( PLAYER_1, SULFUR, 0 );
SetPlayerStartResource( PLAYER_1, MERCURY, 0 );

function PlayStartVoiceover()
	UnlockLoopSounds();
	BlockGame();
	Play2DSound( VOICEOVER_MISSION_START );
	sleep(GetSoundTimeInSleeps( VOICEOVER_MISSION_START ));
	UnblockGame();
end;

LockLoopSounds();
StartDialogScene( "/DialogScenes/A2C0/M1/S1/DialogScene.xdb#xpointer(/DialogScene)", "PlayStartVoiceover" );

SetObjectiveState( "prim1_CaptureTown", OBJECTIVE_ACTIVE );
----------------------------------------------------------------------------------------
----------------------------------   FUNCTIONS   ---------------------------------------
----------------------------------------------------------------------------------------

function PlayRazedTownEffects( townName )
	Play2DSound( "/Maps/Scenario/A2C2M1/Siege_WallCrash02sound.xdb#xpointer(/Sound)" );
	
	local x,y,floor = GetObjectPosition( townName );
	PlayVisualEffect( EFFECT_DUST, "", "fire", x-1.5, y-1, 0, 90, floor );
	PlayVisualEffect( EFFECT_FIREWALL, "", "fire", x-1.5, y-1, 0, 90, floor );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x-1, y+0.5, 0, 0, floor );
	PlayVisualEffect( EFFECT_FIREWALL, "", "fire", x-1, y+0.5, 0, 0, floor );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x+1.5, y-1, 0, 0, floor );
	PlayVisualEffect( EFFECT_FIREWALL, "", "fire", x+1.5, y-1, 0, 90, floor );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x+1, y+0.5, 0, 0, floor );
	PlayVisualEffect( EFFECT_FIRE_01, "", "fire", x+1, y+0.5, 0, 0, floor );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x-1, y, 0, 0, floor );
	PlayVisualEffect( EFFECT_FIRE_01, "", "fire", x-1, y, 0, 0, floor );
	
	PlayVisualEffect( EFFECT_DUST, "", "fire", x+4, y, 0, 0, floor );
	PlayVisualEffect( EFFECT_FIRE_02, "", "fire", x+4, y, 0, 0, floor );
end;


function IsPeasantHutTouched( heroName, objectName )
	if heroName==QUROQ then
		TouchedBuilding = objectName;
		QuestionBox( PATH.."MsgBox_DoYouWantBurnHut.txt", "WantBurnHut");
	end;
end;

function SetAIHeroesRoleModeFreelancer()
	while GetObjectiveState( "prim1_CaptureTown")~=OBJECTIVE_COMPLETED do
		while GetCurrentPlayer()~=PLAYER_2 do sleep(1); end;
		print("AI turn");
		playerHeroes = GetPlayerHeroes( PLAYER_2 );
		for i=0, table.length( playerHeroes )-1	do
			if playerHeroes[i]~=AI_HERO then
				SetHeroRoleMode( playerHeroes[i], HERO_ROLE_MODE_FREEMAN );
				print("Role mode for hero ",playerHeroes[i]," was switched to freelancer");
			end;
		end;
		while GetCurrentPlayer()==PLAYER_2 do sleep(1); end;
		print("AI turn finished");
		sleep(1);
	end;
	print("SetAIHeroesRoleModeFreelancer:  AI player doesn't exist. Function terminated");
end;

function WantBurnHut()
	Trigger( OBJECT_TOUCH_TRIGGER, TouchedBuilding, nil );
	SetObjectOwner( TouchedBuilding, PLAYER_NONE );
	OverrideObjectTooltipNameAndDescription( TouchedBuilding, "", "Maps/Scenario/A2C0M0/ToolTip_BurnedPeasantHut.txt");
	x, y, floor = GetObjectPosition( TouchedBuilding );
	x = x+0.5
	y = y+0.5
	PlayVisualEffect( "/Effects/_(Effect)/Buildings/Capture/Start_dust_S.xdb#xpointer(/Effect)", "","tag1", x, y, 0, floor ); -- Пыль
	PlayVisualEffect( EFFECT_FIREWALL,"","tag2", x, y, 0, floor ); -- Огонь
	PlayVisualEffect( EFFECT_FIREWALL,"","tag2", x, y+1, 0, floor ); -- Огонь
	Play3DSound( SOUND_EFFECT_HUT_CRUSH, GetObjectPosition( TouchedBuilding ) );
	Play2DSound( SOUND_EFFECT_SCREAMS );
	startThread( PlayLoopSound, SOUND_EFFECT_HUT_BURN, TouchedBuilding );
	sleep(5);
	SetPlayerResource( PLAYER_1, GOLD, ( GetPlayerResource(PLAYER_1, GOLD)+2500 ), QUROQ );
	sleep(5);
	ChangeHeroStat( QUROQ, STAT_EXPERIENCE, 2000 );
end;


function MoveHeroRealTimeAndReachPoint( heroName, x, y, floor )
	moveCost = CalcHeroMoveCost( heroName, x, y, GROUND );
	ChangeHeroStat( heroName, STAT_MOVE_POINTS, moveCost );
	sleep(1);
	MoveHeroRealTime( heroName, x, y, GROUND );
end;

function Distance( object1, object2, x, y )
	distance = -1;
	if IsObjectExists( object1 ) or IsHeroAlive( object1 ) then
		if IsObjectExists( object2 ) or IsHeroAlive( object2 ) then
			x_1, y_1 = GetObjectPosition( object1 );
			x_2, y_2 = GetObjectPosition( object2 );
			distance = sqrt((x_1-x_2)*(x_1-x_2) + (y_1-y_2)*(y_1-y_2));
		else
			if x ~= nil and y~= nil then
				distance = sqrt((x_1-x)*(x_1-x) + (y_1-y)*(y_1-y));
			else
				print("Distance: ERROR. You must specify coorinates!");
			end;
		end;
	else
		print("Distance: ERROR. Object doesn't exist!");
	end;
	return distance;
end;

function ShowCyclopsIfListeningDistanceReached()
	while Distance( QUROQ, "cyclop" ) > LISTENING_DISTANCE do sleep(1); end;
	if isCyclopsShowed==0 and IsHeroAlive( QUROQ )==not nil then 
		PlayCyclopScene();
	end;
end;

function ShowGoblinsIfListeningDistanceReached()
	while Distance( QUROQ, "goblin_gold" ) > LISTENING_DISTANCE do sleep(1); end;
	if isGoblinsShowed==0 and IsHeroAlive( QUROQ )==not nil  then 
		PlayGoblinsScene();
	end;
end;

function ShowButchersIfListeningDistanceReached()
	while Distance( QUROQ, "prison" ) > LISTENING_DISTANCE do sleep(1); end;
	if isButchersShowed==0 and IsHeroAlive( QUROQ )==not nil then 
		PlayButcherScene();
	end;
end;

function HutOfMagi( heroName, hutName )
	if GetObjectOwner( heroName ) == PLAYER_1 then
		if hutName == "HutOfMagi_Cyclops" then
			startThread( PlayCyclopScene );
		elseif hutName == "HutOfMagi_Butchers" then
			startThread( PlayButcherScene );
		elseif hutName == "HutOfMagi_Goblins" then
			startThread( PlayGoblinsScene );
		end;
		MarkObjectAsVisited( hutName, heroName );
	end;
end;



function PlayCentaursScene()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ShowCentaur", nil );
	OpenCircleFog( 115, 33, GROUND, 7, PLAYER_1);
	MoveCamera( 115, 33, GROUND, 17, 0.7, 1.1, 0, 0, 1 );
	PlayObjectAnimation( "peasant_1", "attack00", IDLE );
	sleep(3);
	PlayObjectAnimation( "peasant_2", "attack00", IDLE );
	sleep(5);
	PlayObjectAnimation( "centaur", "hit", IDLE );
	sleep(15);
	local x,y,z = GetObjectPosition( QUROQ )
	MoveCamera( x, y, z, 35, 0.9, 0, 0, 0, 1 );
end;

function PlayGoblinsScene()
	BlockGame();
	OpenCircleFog( 129, 127, GROUND, 7, PLAYER_1);
	MoveCamera( 129, 127, GROUND, 20, 0.7, 0.5, 0, 0, 1 );
	sleep(10);
	if isGoblinsShowed == 0 then
		isGoblinsShowed = 1;
		PlayObjectAnimation("footman_goblin_guard", "attack00", ONESHOT );
		sleep(10);
		PlayObjectAnimation("goblin_gold", "attack00", IDLE );
		SetObjectRotation( "footman_goblin_guard", 90 );
		sleep(5);
		PlayObjectAnimation("footman_goblin_guard", "attack00", ONESHOT );
		sleep(10);
		PlayObjectAnimation("goblin_ore", "attack00", IDLE );
		SetObjectRotation( "footman_goblin_guard", -60 );
		sleep(5);
		PlayObjectAnimation("footman_goblin_guard", "attack00", ONESHOT );
		sleep(5);
		PlayObjectAnimation("goblin_left", "death", ONESHOT_STILL );
		sleep(15);
		RemoveObject("goblin_left");
		MessageBox( MSGBOX_GOBLINS_SCENE );
	end;
	local x,y,z = GetObjectPosition( QUROQ );
	UnblockGame();
	MoveCamera( x, y, z, 35, 0.9, 0, 0, 0, 1 );
end;

function PlayButcherScene()
	OpenCircleFog( 22, 22, GROUND, 7, PLAYER_1);
	BlockGame();
	MoveCamera( 22, 22, GROUND, 23, 0.6, 2.4, 0, 0, 1 );
	sleep(15);
	if isButchersShowed == 0 then 
		isButchersShowed = 1;
		MessageBox( MSGBOX_BUTCHERS_SCENE );
	end;
	local x,y,z = GetObjectPosition( QUROQ )
	MoveCamera( x, y, z, 35, 0.9, 0, 0, 0, 1 );
	UnblockGame();
end;

function PlayCyclopScene()
	BlockGame();
	OpenCircleFog( 34, 89, GROUND, 7, PLAYER_1);
	MoveCamera( 34, 89, GROUND, 15, 0.6, -0.4, 0, 0, 1 );
	sleep(10);
	if isCyclopsShowed == 0 then
		isCyclopsShowed = 1;
		PlayObjectAnimation("archer1", "rangeattack", ONESHOT );
		sleep(5);
		PlayObjectAnimation("archer2", "rangeattack", ONESHOT );
		sleep(5);
		PlayObjectAnimation("cyclop", "hit", ONESHOT );
		sleep(10);
		SetObjectRotation( "cyclop", 90 );
		sleep(1);
		PlayObjectAnimation("cyclop", "attack00", ONESHOT );
		sleep(3);
		PlayVisualEffect( EFFECT_TREE_HIT, "tree" );
		PlayVisualEffect( EFFECT_BALLISTA_DEATH, "tree" );
		sleep(5);
		local tree_x, tree_y, tree_floor = GetObjectPosition( "tree" );
		RemoveObject( "tree" );
		sleep(1);
		SetObjectPosition( "stump", tree_x, tree_y, tree_floor );
		sleep(5);
		PlayObjectAnimation("cyclop", "happy", ONESHOT );
		sleep(15);
		MessageBox( MSGBOX_CYCLOPS_SCENE );
	end;
	local x,y,z = GetObjectPosition( QUROQ )
	UnblockGame();
	MoveCamera( x, y, z, 35, 0.9, 0, 0, 0, 1 );
end;

function IsGoblinsGuardKilled()
	while IsObjectExists( "goblins_guard" ) == not nil do sleep(2); end;
	print("IsGoblinsGuardKilled: Goblins are liberated!!!");
	BlockGame();	
	MoveCamera( 129, 127, GROUND, 20, 0.7, 0.5, 0, 0, 1 );
	sleep(5);
	SetObjectRotation( "goblin_gold", 0 );
	SetObjectRotation( "goblin_ore", 270 );
	sleep(1);
	PlayObjectAnimation( "goblin_gold", "attack00", ONESHOT );
	PlayObjectAnimation( "goblin_ore", "attack00", ONESHOT );
	sleep(5);
	PlayObjectAnimation( "footman_goblin_guard", "death", ONESHOT_STILL );
	sleep(10);
	PlayObjectAnimation( "goblin_gold", "happy", ONESHOT );
	PlayObjectAnimation( "goblin_ore", "happy", ONESHOT );
	Play2DSound( VOICEOVER_QUROQ_RELEASES_GOBLINS );
	creaturesCollected = creaturesCollected  + 1;
	SetObjectiveProgress( "prim2_CollectCreatures", creaturesCollected );
	RemoveObject( "footman_goblin_guard" );
	sleep(15);
	UnblockGame();
	MoveHeroRealTimeAndReachPoint( QUROQ, GetObjectPosition("goblin_ore") );
	while IsObjectExists("goblin_ore")==not nil do sleep(1); end;
	MoveHeroRealTimeAndReachPoint( QUROQ, GetObjectPosition("goblin_gold") );
	while IsObjectExists("goblin_gold")==not nil do sleep(1); end;
	print("IsGoblinsGuardKilled: All goblins enslaved!");	
	local hero_x, hero_y, hero_floor = GetObjectPosition( QUROQ );
	SetRegionBlocked( "goblin_dwelling_area", nil );
	PlayVisualEffect( EFFECT_DUST, "", "", 120, 9, GROUND );
	CreateDwelling( "goblins_dwelling", TOWN_STRONGHOLD, 1, PLAYER_1, 120, 9, GROUND, 90 );
	sleep(1);
	MoveCamera( 120, 9, GROUND, 30, 0.7, 0, 0, 0, 1);
	sleep(15);
	MessageBox( PATH.."MsgBox_CanRecruitGoblins.txt" );
	MoveCamera( hero_x, hero_y, hero_floor, 35, 0.9, 0, 0, 0, 1 );
end;


function IsPrisonTouched( heroName )
	butchersDeployed = 1; --> See the DeployButchers() function
	Trigger( OBJECT_TOUCH_TRIGGER, "prison", "PrisonVisited" );
end;
	
function DeployButchers()
	while butchersDeployed==0 do sleep(2); end;
	local x, y, floor = GetObjectPosition(QUROQ);
	BlockGame();	
	CreateMonster( "butchers", CREATURE_ORCCHIEF_BUTCHER, BUTCHERS_TO_DEPLOY*2, x, y, floor, MONSTER_MOOD_FRIENDLY, MONSTER_COURAGE_ALWAYS_JOIN );
	Play2DSound( VOICEOVER_QUROQ_RELEASES_BUTCHERS );
	sleep(1);
	SetObjectRotation("butchers", 60);
	sleep(1);
	PlayObjectAnimation( "butchers", "happy", ONESHOT );
	sleep(15);
	UnblockGame();
	MessageBox(PATH.."MsgBox_Butchersthanks.txt");
	MoveHeroRealTimeAndReachPoint( QUROQ, GetObjectPosition("butchers") );
	while IsObjectExists( "butchers" )==not nil do sleep(1); end;
	local hero_x, hero_y, hero_floor = GetObjectPosition( QUROQ );
	SetRegionBlocked( "military_post_area", nil );
	PlayVisualEffect( EFFECT_DUST, "", "", 128, 8, GROUND );
	CreateDwelling( "military_post", TOWN_STRONGHOLD, 5, PLAYER_1, 128, 8, GROUND, 270 );	
	MoveCamera( 130, 8, GROUND, 30, 0.7, 0, 0, 0, 1);
	sleep(15);
	MessageBox( PATH.."MsgBox_CanRecruitButchers.txt");
	MoveCamera( hero_x, hero_y, hero_floor, 35, 0.9, 0, 0, 0, 1 );
	creaturesCollected = creaturesCollected  + 1;
	SetObjectiveProgress( "prim2_CollectCreatures", creaturesCollected );
	MarkObjectAsVisited( "prison", QUROQ );
end;

function PrisonVisited()
	MessageBox( PATH.."MsgBox_PrisonIsEmpty.txt" );
end;

function IsCyclopsGuardKilled()
	while IsObjectExists( "cyclops_guard" ) == not nil do sleep(2); end;
	BlockGame()
	MoveCamera( 34, 89, GROUND, 15, 0.6, -0.4, 0, 0, 1 );
	SetObjectRotation( "cyclop", 270 );
	sleep(1);
	PlayObjectAnimation( "cyclop", "happy", ONESHOT );
	sleep(5);
	PlayObjectAnimation( "archer1", "rangeattack", IDLE );
	sleep(2);
	PlayObjectAnimation( "archer2", "rangeattack", IDLE );
	sleep(10);
	SetObjectRotation( "cyclop", 220 );
	sleep(1);
	PlayObjectAnimation( "cyclop", "attack00", ONESHOT );
	sleep(5);
	PlayVisualEffect( EFFECT_BALLISTA_DEATH, "archer1_fence" );
	PlayObjectAnimation( "archer1", "death", ONESHOT_STILL );
	RemoveObject("archer1_fence");
	sleep(2);
	SetObjectRotation( "cyclop", 320 );
	PlayObjectAnimation( "cyclop", "attack00", ONESHOT );
	sleep(4);
	PlayVisualEffect( EFFECT_BALLISTA_DEATH, "archer2_fence" );
	PlayObjectAnimation( "archer2", "death", ONESHOT_STILL );
	RemoveObject("archer2_fence");
	sleep(2);
	SetObjectRotation( "cyclop", 270 );
	sleep(2);
	PlayObjectAnimation( "cyclop", "attack00", ONESHOT );
	sleep(4);
	PlayVisualEffect( EFFECT_BALLISTA_DEATH, "fence_1" );
	PlayVisualEffect( EFFECT_BALLISTA_DEATH, "fence_2" );
	sleep(1);
	RemoveObject("fence_1");
	RemoveObject("fence_2");
	PlayObjectAnimation( "cyclop", "happy", ONESHOT );
	sleep(10);
	RemoveObject("archer1");
	RemoveObject("archer2");
	Play2DSound( VOICEOVER_QUROQ_RELEASES_CYCLOPS );
	sleep(10);
	MoveHeroRealTimeAndReachPoint( QUROQ, GetObjectPosition("cyclop"));
	while IsObjectExists("cyclop")==not nil do sleep(1); end;
	creaturesCollected = creaturesCollected  + 1;
	SetObjectiveProgress( "prim2_CollectCreatures", creaturesCollected );
	UnblockGame();
end;




function StartCombatVsPeasant()
	Trigger( REGION_ENTER_AND_STOP_TRIGGER, "centaur_region", nil );
	TutorialMessageBox( "MsgBox_RagePointsBeforeCombat"); --must be tutorial
	StartCombat( QUROQ, nil, 4, CREATURE_PEASANT, FIRST_COMBAT_PEASANTS_AMOUNT,
								CREATURE_PEASANT, FIRST_COMBAT_PEASANTS_AMOUNT,
								CREATURE_PEASANT, FIRST_COMBAT_PEASANTS_AMOUNT,
								CREATURE_PEASANT, FIRST_COMBAT_PEASANTS_AMOUNT, 
								COMBAT_SCRIPT,"IsPeasantsDefeated", nil, nil );
end;


function IsPeasantsDefeated( heroName, combatResult )
	if combatResult == not nil then
		LockLoopSounds();
		StartDialogScene( "/DialogScenes/A2C0/M1/S3/DialogScene.xdb#xpointer(/DialogScene)", "UnlockLoopSounds" );
		RemoveObject( "peasant_1" );
		RemoveObject( "peasant_2" );
		SetObjectEnabled( "centaur", not nil );
		PlayObjectAnimation( "centaur", "happy", ONESHOT );
		Play2DSound( VOICEOVER_QUROQ_RELEASES_CENTAURS );
		sleep(20);
		MessageBox( PATH.."MsgBox_CentaursThanks.txt" );
		startThread( JoinCentaurs );
	else
		print("Our glorious hero is defeated!");
	end;
end;

function JoinCentaurs()
	MoveHeroRealTimeAndReachPoint( QUROQ, GetObjectPosition("centaur") );
	while IsObjectExists("centaur")==not nil do sleep(1); end;
	SetRegionBlocked( "centaur_dwelling_area", nil );
	PlayVisualEffect( EFFECT_DUST, "", "", 125, 12, GROUND );
	CreateDwelling( "centaur_dwelling", TOWN_STRONGHOLD, 2, PLAYER_1, 125, 12, GROUND, 0 );
	local hero_x, hero_y, hero_floor = GetObjectPosition( QUROQ );
	MoveCamera( 125, 12, GROUND, 30, 0.7, 0, 0, 0, 1 );
	sleep(15);
	MessageBox( PATH.."MsgBox_CanRecruitCentaurs.txt" );
	MoveCamera( hero_x, hero_y, hero_floor, 35, 0.9, 0, 0, 0, 1 );
	SetObjectiveState( "prim2_CollectCreatures", OBJECTIVE_ACTIVE );
	sleep(1);
	SetObjectiveProgress( "prim2_CollectCreatures", creaturesCollected );
	sleep(1);
	TutorialMessageBox( "MsgBox_RagePointsAfterCombat");--must be tutorial
	startThread( Prim2_CollectAllStrongholdCreatures );
end;

function SacrificePeasants()
	while IsObjectExists("sucrifice_peasants")==not nil do sleep(1); end;
	MessageBox( PATH.."MsgBox_CanSucrificePeasantst.txt");
end;

function SacrificeSkeletons()
	while IsObjectExists("sucrifice_skeleton")==not nil do sleep(1); end;
	MessageBox( PATH.."MsgBox_CanSucrificeSkeletons.txt");
	BlockGame();	
	local pit_x, pit_y, pit_floor = GetObjectPosition("sacrificial_pit");
	local hero_x, hero_y, hero_floor = GetObjectPosition( QUROQ );
	MoveCamera( pit_x, pit_y, pit_floor, 30, 0.7, 0, 0, 0, 1);
	OpenCircleFog( pit_x, pit_y, pit_floor, 7, PLAYER_1 );
	sleep(10);
	MoveCamera( hero_x, hero_y, hero_floor, 35, 0.9, 0, 0, 0, 1 );
	UnblockGame();
end;

function PlayLoopSound( soundName, objectName )
	local delay;
	delay = GetSoundTimeInSleeps( soundName ) + 1;
	if delay < 1 then delay=1; end;
	while 1 do
		if IsObjectExists( objectName )==nil then return end;
		if loopSoundsLocks <= 0 then
			Play3DSound( soundName, GetObjectPosition( objectName ) );
		end;
		sleep( delay );
	end;
end;

----------------------------------------------------------------------------------------
-----------------------   OBJECTIVES AND WIN CONDITIONS   ------------------------------
----------------------------------------------------------------------------------------

function Prim1_CaptureHeavenTown( oldOwner, newOwner )
	if newOwner == PLAYER_1 then
		Trigger( OBJECT_CAPTURE_TRIGGER, "heaven_town", nil );
		SetObjectiveState( "prim1_CaptureTown", OBJECTIVE_COMPLETED );
		RazeTown( "heaven_town" );
		PlayRazedTownEffects( "heaven_town" );
		--Play2DSound( VOICEOVER_DESTROY_TOWN_COMPLETED );
	end;
end;

function Prim2_CollectAllStrongholdCreatures()
	while creaturesCollected < 3 do sleep(5); end;
	SetObjectiveState( "prim2_CollectCreatures", OBJECTIVE_COMPLETED );
	--Play2DSound( VOICEOVER_RELEASE_ALL_CREATURES_COMPLETED );
end;

function Prim3_QuroqMustSurvive()
	while IsHeroAlive( QUROQ )==not nil do sleep(5); end;
	SetObjectiveState( "prim3_QuroqMustSurvive", OBJECTIVE_FAILED );
	sleep(10);
	Loose();
end;

function PlayerWin()
	repeat
		sleep(5);
	until GetObjectiveState("prim1_CaptureTown")==OBJECTIVE_COMPLETED and GetObjectiveState("prim2_CollectCreatures")==OBJECTIVE_COMPLETED;
	LockLoopSounds();
	StartDialogScene( "/DialogScenes/A2C0/M1/S2/DialogScene.xdb#xpointer(/DialogScene)", "UnlockLoopSounds" );
	print("All objectives completed");	
	Win( PLAYER_1 );
end;



----------------------------------------------------------------------------------------
-------------------------   TUTORIAL FUNCTIONS   ---------------------------------------
----------------------------------------------------------------------------------------

function Tutorial_UseCyclopsNotification(heroName)
	if heroName == QUROQ then
		print("hero in region");
		TutorialMessageBox( "MsgBox_UseCyclops" );
		startThread( ShowCyclops );
	end;
end;

function ShowCyclops()
	while IsTutorialMessageBoxOpen()==not nil do sleep(1); end;
	BlockGame();
	OpenCircleFog( 34, 89, GROUND, 7, PLAYER_1 );
	MoveCamera( 34, 89, GROUND, 15, 0.6, -0.4, 0, 0, 1 );
	local x,y,floor = GetObjectPosition( QUROQ );
	PlayObjectAnimation("cyclop", "happy", ONESHOT );
	sleep(15);
	MoveCamera( x, y, floor, 35, 0.9, 0, 0, 0, 1 );
	UnblockGame();
end;

function StopTriggerIfCyclopsNotExist()
	while IsObjectExists("cyclop") == not nil do -- Пока циклоп присутствует на карте 
		print("StopTriggerIfCyclopsNotExist: new iteration");
		repeat sleep(1); until IsObjectExists("cyclop")==nil or IsTutorialEnabled() ~= not nil; -- ждать пока не исчезнет циклоп или не будет выключен туториал
		print("StopTriggerIfCyclopsNotExist: repeat end");
		if IsObjectExists("cyclop")==nil then -- если исчез циклоп
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "UseCyclopsTutorialNotification_area", nil ); -- снимать триггер, выходить из фунции
			print("StopTriggerIfCyclopsNotExist: trigger stopped. Cyclop is dead");
			return
		end;
		if IsTutorialEnabled() ~= not nil then -- если был выключен туториал
			Trigger( REGION_ENTER_AND_STOP_TRIGGER, "UseCyclopsTutorialNotification_area", nil ); -- снимать триггер, но из функции не выходить
			print("StopTriggerIfCyclopsNotExist: trigger stopped. Waiting for enabling tutorial...");
		end;
		repeat sleep(1); until IsTutorialEnabled() == not nil; -- ждать, не включит ли игрок туториал
		print("StopTriggerIfCyclopsNotExist: tutorial is enabled");
		Trigger( REGION_ENTER_AND_STOP_TRIGGER, "UseCyclopsTutorialNotification_area", "Tutorial_UseCyclopsNotification" ); -- если включен туториал снова вешать триггер на регион перед городом
		sleep(1);
	end;
	print("StopTriggerIfCyclopsNotExist: function terminated");
end;

function Tutorial_HeroHasSkill_battleElation()
	repeat sleep(1); until HasHeroSkill( QUROQ, HERO_SKILL_BATTLE_ELATION )==not nil;
	if IsTutorialEnabled() == not nil then
		TutorialMessageBox( "MsgBox_HeroHasBattleElation" );
		WaitForTutorialMessageBox();
	end;
end;

function Tutorial_HeroHasSkill_MemoryOfOurBlood()
	repeat sleep(1); until HasHeroSkill( QUROQ, HERO_SKILL_MEMORY_OF_OUR_BLOOD )==not nil;
	if IsTutorialEnabled() == not nil then
		TutorialMessageBox( "MsgBox_HeroHasMemoryOfOurBlood" );
		WaitForTutorialMessageBox();
	end;
end;


----------------------------------------------------------------------------------------
----------------------------------   MAIN   --------------------------------------------
----------------------------------------------------------------------------------------

Trigger( OBJECT_TOUCH_TRIGGER, "HutOfMagi_Cyclops", "HutOfMagi" );
Trigger( OBJECT_TOUCH_TRIGGER, "HutOfMagi_Goblins", "HutOfMagi" );
Trigger( OBJECT_TOUCH_TRIGGER, "HutOfMagi_Butchers", "HutOfMagi" );
Trigger( OBJECT_TOUCH_TRIGGER, "prison", "IsPrisonTouched" );

Trigger( OBJECT_TOUCH_TRIGGER, "west_hut", "IsPeasantHutTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "east_hut", "IsPeasantHutTouched" );
Trigger( OBJECT_TOUCH_TRIGGER, "south_hut", "IsPeasantHutTouched" );

Trigger( REGION_ENTER_AND_STOP_TRIGGER, "ShowCentaur", "PlayCentaursScene" );
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "centaur_region", "StartCombatVsPeasant" );

startThread( PlayerWin );
Trigger( OBJECT_CAPTURE_TRIGGER, "heaven_town", "Prim1_CaptureHeavenTown" );
startThread( Prim3_QuroqMustSurvive );
startThread( IsGoblinsGuardKilled );
startThread( IsCyclopsGuardKilled );
startThread( DeployButchers );
startThread( SacrificePeasants );
startThread( SacrificeSkeletons );
startThread( SetAIHeroesRoleModeFreelancer );

startThread( ShowCyclopsIfListeningDistanceReached );
startThread( ShowGoblinsIfListeningDistanceReached );
startThread( ShowButchersIfListeningDistanceReached );


------------------------ TUTORIAL MAIN ----------------------------------------------------
Trigger( REGION_ENTER_AND_STOP_TRIGGER, "UseCyclopsTutorialNotification_area", "Tutorial_UseCyclopsNotification" );  
startThread( StopTriggerIfCyclopsNotExist );

startThread( Tutorial_HeroHasSkill_battleElation );
startThread( Tutorial_HeroHasSkill_MemoryOfOurBlood );